#!/bin/bash
set -euo pipefail

# 定义文件夹名称和压缩文件名
folder_name="I2C_OLED_Dino"
zip_file_name="${folder_name}.zip"

# 检查 zip 命令是否存在
if ! command -v zip >/dev/null 2>&1; then
    echo "错误: 未找到 zip 命令，请先安装 zip"
    exit 1
fi

# 删除已存在的压缩文件
if [ -f "$zip_file_name" ]; then
    rm "$zip_file_name"
fi

# 先将整个目录压缩，但排除 build 目录和 Debug 目录下的所有内容
zip -rq "$zip_file_name" "$folder_name" -x "$folder_name/build/*" "$folder_name/Debug/*"

# 如果需要保留 Debug/${folder_name}.elf，则单独把它加入到压缩包（存在时）
elf_path="$folder_name/Debug/${folder_name}.elf"
if [ -f "$elf_path" ]; then
    zip -q "$zip_file_name" "$elf_path"
else
    echo "警告: 未找到 ${elf_path}，因此压缩包中不会包含该文件。"
fi

echo "${folder_name} 压缩完成: ${zip_file_name}"