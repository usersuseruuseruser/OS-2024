#!/usr/bin/env bash


step=1
hits=0
misses=0
numbers=()
hit_colors=() 


validate_input() {
    if [[ "$1" =~ ^[0-9]$ ]] || [[ "$1" == "q" ]]; then
        return 0
    else
        return 1
    fi
}


colored_numbers() {
    for i in "${!numbers[@]}"; do
        if [[ "${hit_colors[$i]}" == "green" ]]; then
            echo -ne "\e[32m${numbers[$i]}\e[0m "
        else
            echo -ne "\e[31m${numbers[$i]}\e[0m "
        fi
    done
    echo
}

while true; do
    random_number=$((RANDOM % 10))

    echo -e "Step: $step"
    read -p "Please enter number from 0 to 9 (q - quit): " user_input

    if ! validate_input "$user_input"; then
        echo "Input error!"
        continue
    fi

    if [[ "$user_input" == "q" ]]; then
        break
    fi

    numbers+=("$random_number")

    if [[ "$user_input" -eq "$random_number" ]]; then
        echo -e "Hit! My number: $random_number"
        hits=$((hits + 1))
        hit_colors+=("green")
    else
        echo -e "Miss! My number: $random_number"
        misses=$((misses + 1))
        hit_colors+=("red")
    fi

    total=$((hits + misses))
    hit_percent=$((hits * 100 / total))
    miss_percent=$((misses * 100 / total))

    echo "Hit: ${hit_percent}% Miss: ${miss_percent}%"

    echo -n "Numbers: "
    colored_numbers

    if [[ ${#numbers[@]} -gt 10 ]]; then
        numbers=(${numbers[@]: -10})
        hit_colors=(${hit_colors[@]: -10})
    fi

    step=$((step + 1))
done

echo "Goodbye!"
