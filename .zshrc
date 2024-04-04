# Enable colors and change prompt:
autoload -Uz colors && colors
PS1="%B%{$fg[blue]%}(%{$fg[cyan]%}%n%{$fg[yellow]%}@%{$fg[red]%}%M %{$fg[magenta]%}%~%{$fg[blue]%})%{$reset_color%}$%b "

# History in cache directory:
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.config/zsh/.zsh-hist

# Basic auto/tab complete:
autoload -Uz compinit
compinit -d ~/.config/zsh/.zcompdump
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)   # Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Key bindings:
bindkey '^[[1;5C'   forward-word
bindkey '^[[1;5D'   backward-word
bindkey '^H'        backward-kill-word
bindkey '^J'        backward-kill-line
bindkey '^[[3;5~'   kill-word
bindkey '^[[H'      beginning-of-line
bindkey '^[[F'      end-of-line
bindkey '^[[3~'     delete-char
bindkey '^[[5~'     up-line-or-history
bindkey '^[[6~'     down-line-or-history

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins  # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;}  # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-f
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^F' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^E' edit-command-line

# Shortcut to exit shell on partial command line
exit_zsh() { exit }
zle -N exit_zsh
bindkey '^D' exit_zsh

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
