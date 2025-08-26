Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C74C2820B1;
	Tue, 26 Aug 2025 11:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208139; cv=none; b=C19wQj92md+MXlJv2OnNG+A6WNpcqUs9OA00jAgDsReQFlDj1QF57gEue9D4UCAHnIoOnSnS+PSLq4veIMFkTc8jJRiBrZoAda9/ULvDV6IhFh0o7itscntRg1lzYjcGNCTrncKwwPCDQYsi1oks6xJwvrL/48LTayHuiA2zFmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208139; c=relaxed/simple;
	bh=9/M2EfChW2T23diUXgoUtramwi86hpeMSO4POvk89t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlBXijoKGN9XY4YKvOd/Ob/W0UM+5qV7ddf21ikRq6gmInB908n/biQIk2BLH32b9Rg6q+h2CkUdotIzJTZrwc+d76ky9Et2KWmvRZ1Kq2RbLdcweDgfxUB6arKFrKJ0EuQgZUc08yBsE8ntk9tD4K22bAQrZjnM8FjT7WKQhxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LE7vNErP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LE7vNErP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F119CC4CEF1;
	Tue, 26 Aug 2025 11:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208139;
	bh=9/M2EfChW2T23diUXgoUtramwi86hpeMSO4POvk89t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LE7vNErPmKeUT35jmFNTLH8LTXFd3AqckCIDoDHc4/I5BD82HDHIbkwtrVvoS39mq
	 s5GJQzKLiifcGLN/N5mV7yUEA8Nbs+LTTd7RIsHaL5AJ/DpFtnsqrEW4WRFl9MWnsY
	 iBlufVqRS+jnhWwR6lW9DPmqphmRVUo0SEkp9uNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 422/457] objtool/LoongArch: Get table size correctly if LTO is enabled
Date: Tue, 26 Aug 2025 13:11:46 +0200
Message-ID: <20250826110947.722432738@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit a47bc954cf0eb51f2828e1607d169d487df7f11f ]

When compiling with LLVM and CONFIG_LTO_CLANG is set, there exist many
objtool warnings "sibling call from callable instruction with modified
stack frame".

For this special case, the related object file shows that there is no
generated relocation section '.rela.discard.tablejump_annotate' for the
table jump instruction jirl, thus objtool can not know that what is the
actual destination address.

It needs to do something on the LLVM side to make sure that there is the
relocation section '.rela.discard.tablejump_annotate' if LTO is enabled,
but in order to maintain compatibility for the current LLVM compiler,
this can be done in the kernel Makefile for now. Ensure it is aware of
linker with LTO, '--loongarch-annotate-tablejump' needs to be passed via
'-mllvm' to ld.lld.

Before doing the above changes, it should handle the special case of the
relocation section '.rela.discard.tablejump_annotate' to get the correct
table size first, otherwise there are many objtool warnings and errors
if LTO is enabled.

There are many different rodata for each function if LTO is enabled, it
is necessary to enhance get_rodata_table_size_by_table_annotate().

Fixes: b95f852d3af2 ("objtool/LoongArch: Add support for switch table")
Closes: https://lore.kernel.org/loongarch/20250731175655.GA1455142@ax162/
Reported-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/arch/loongarch/special.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/objtool/arch/loongarch/special.c b/tools/objtool/arch/loongarch/special.c
index e39f86d97002..a80b75f7b061 100644
--- a/tools/objtool/arch/loongarch/special.c
+++ b/tools/objtool/arch/loongarch/special.c
@@ -27,6 +27,7 @@ static void get_rodata_table_size_by_table_annotate(struct objtool_file *file,
 	struct table_info *next_table;
 	unsigned long tmp_insn_offset;
 	unsigned long tmp_rodata_offset;
+	bool is_valid_list = false;
 
 	rsec = find_section_by_name(file->elf, ".rela.discard.tablejump_annotate");
 	if (!rsec)
@@ -35,6 +36,12 @@ static void get_rodata_table_size_by_table_annotate(struct objtool_file *file,
 	INIT_LIST_HEAD(&table_list);
 
 	for_each_reloc(rsec, reloc) {
+		if (reloc->sym->sec->rodata)
+			continue;
+
+		if (strcmp(insn->sec->name, reloc->sym->sec->name))
+			continue;
+
 		orig_table = malloc(sizeof(struct table_info));
 		if (!orig_table) {
 			WARN("malloc failed");
@@ -49,6 +56,22 @@ static void get_rodata_table_size_by_table_annotate(struct objtool_file *file,
 
 		if (reloc_idx(reloc) + 1 == sec_num_entries(rsec))
 			break;
+
+		if (strcmp(insn->sec->name, (reloc + 1)->sym->sec->name)) {
+			list_for_each_entry(orig_table, &table_list, jump_info) {
+				if (orig_table->insn_offset == insn->offset) {
+					is_valid_list = true;
+					break;
+				}
+			}
+
+			if (!is_valid_list) {
+				list_del_init(&table_list);
+				continue;
+			}
+
+			break;
+		}
 	}
 
 	list_for_each_entry(orig_table, &table_list, jump_info) {
-- 
2.50.1



