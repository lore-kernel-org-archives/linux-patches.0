Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D97A268C62;
	Tue,  8 Apr 2025 11:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111751; cv=none; b=QY3ruR6sswIiYozgSm3BY/HO2FM/jKotYc9ToJjPvVlbW4SxgRivvy38uhOUYewYb9loe2vN4iSIhUesaoXamivntuHqcN6cSpRD1W4q3lT+N/qsReGfJIMIIYtSB/ggWJgriHQDsk1w/Ot7ENPsdPb4aU8MmylaI7HUaxROJzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111751; c=relaxed/simple;
	bh=Xhe+bQVEOwUVywf90hYju5zwdBLk+qvwSjIXwrPiajk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNoLEmaJRveSpDCjEs4aeDhZzymWfoXjx+qS/uknXrk3H5N6XAeDdT/hxaTiaziw7/G2PlVAE3DtA3CEZlOytpCyfI7WiASvqAHeAPjN+gJehwV8CKbe2XN+/afcxdZTotUAJw//jUIE9B2FhGg1n5Q/rxNJ9tx8DVauUkUbxYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JmeKNZrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JmeKNZrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D019C4CEE5;
	Tue,  8 Apr 2025 11:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111751;
	bh=Xhe+bQVEOwUVywf90hYju5zwdBLk+qvwSjIXwrPiajk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JmeKNZrFDkhQm4NR4Rb6BKQ21F+vMQFPmXoFrLgPkFlaSCB/qYJqhCRNCMcL8I0i9
	 LnWfSqlR6PhcNd91ASc3ITNhxntZVll5HAU6ANJOzFOFKFc9tLO0pS2DCX7c4gGJRc
	 oZaD6C78vZcN7YMw2EIGcVxty12+9aEAlvMcycvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 545/731] objtool: Handle PC relative relocation type
Date: Tue,  8 Apr 2025 12:47:22 +0200
Message-ID: <20250408104926.953677572@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit c4b93b06230ae49870187189d9f7342f6ad4f14e ]

For the most part, an absolute relocation type is used for rodata.
In the case of STT_SECTION, reloc->sym->offset is always zero, for
the other symbol types, reloc_addend(reloc) is always zero, thus it
can use a simple statement "reloc->sym->offset + reloc_addend(reloc)"
to obtain the symbol offset for various symbol types.

When compiling on LoongArch, there exist PC relative relocation types
for rodata, it needs to calculate the symbol offset with "S + A - PC"
according to the spec of "ELF for the LoongArch Architecture".

If there is only one jump table in the rodata, the "PC" is the entry
address which is equal with the value of reloc_offset(reloc), at this
time, reloc_offset(table) is 0.

If there are many jump tables in the rodata, the "PC" is the offset
of the jump table's base address which is equal with the value of
reloc_offset(reloc) - reloc_offset(table).

So for LoongArch, if the relocation type is PC relative, it can use a
statement "reloc_offset(reloc) - reloc_offset(table)" to get the "PC"
value when calculating the symbol offset with "S + A - PC" for one or
many jump tables in the rodata.

Add an arch-specific function arch_jump_table_sym_offset() to assign
the symbol offset, for the most part that is an absolute relocation,
the default value is "reloc->sym->offset + reloc_addend(reloc)" in
the weak definition, it can be overridden by each architecture that
has different requirements.

Link: https://github.com/loongson/la-abi-specs/blob/release/laelf.adoc
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/r/20250211115016.26913-4-yangtiezhu@loongson.cn
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Stable-dep-of: ef753d66051c ("objtool: Fix detection of consecutive jump tables on Clang 20")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/arch/loongarch/decode.c           | 17 +++++++++++++----
 tools/objtool/arch/loongarch/include/arch/elf.h |  7 +++++++
 tools/objtool/check.c                           |  7 ++++++-
 tools/objtool/include/objtool/arch.h            |  1 +
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/tools/objtool/arch/loongarch/decode.c b/tools/objtool/arch/loongarch/decode.c
index b64205b89f6b4..02e4905559667 100644
--- a/tools/objtool/arch/loongarch/decode.c
+++ b/tools/objtool/arch/loongarch/decode.c
@@ -5,10 +5,7 @@
 #include <asm/inst.h>
 #include <asm/orc_types.h>
 #include <linux/objtool_types.h>
-
-#ifndef EM_LOONGARCH
-#define EM_LOONGARCH	258
-#endif
+#include <arch/elf.h>
 
 int arch_ftrace_match(char *name)
 {
@@ -374,3 +371,15 @@ unsigned int arch_reloc_size(struct reloc *reloc)
 		return 8;
 	}
 }
+
+unsigned long arch_jump_table_sym_offset(struct reloc *reloc, struct reloc *table)
+{
+	switch (reloc_type(reloc)) {
+	case R_LARCH_32_PCREL:
+	case R_LARCH_64_PCREL:
+		return reloc->sym->offset + reloc_addend(reloc) -
+		       (reloc_offset(reloc) - reloc_offset(table));
+	default:
+		return reloc->sym->offset + reloc_addend(reloc);
+	}
+}
diff --git a/tools/objtool/arch/loongarch/include/arch/elf.h b/tools/objtool/arch/loongarch/include/arch/elf.h
index 9623d663220ef..ec79062c9554d 100644
--- a/tools/objtool/arch/loongarch/include/arch/elf.h
+++ b/tools/objtool/arch/loongarch/include/arch/elf.h
@@ -18,6 +18,13 @@
 #ifndef R_LARCH_32_PCREL
 #define R_LARCH_32_PCREL	99
 #endif
+#ifndef R_LARCH_64_PCREL
+#define R_LARCH_64_PCREL	109
+#endif
+
+#ifndef EM_LOONGARCH
+#define EM_LOONGARCH		258
+#endif
 
 #define R_NONE			R_LARCH_NONE
 #define R_ABS32			R_LARCH_32
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 4b9f01a11792f..12bf6c1f5071d 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1944,6 +1944,11 @@ static int add_special_section_alts(struct objtool_file *file)
 	return ret;
 }
 
+__weak unsigned long arch_jump_table_sym_offset(struct reloc *reloc, struct reloc *table)
+{
+	return reloc->sym->offset + reloc_addend(reloc);
+}
+
 static int add_jump_table(struct objtool_file *file, struct instruction *insn,
 			  struct reloc *next_table)
 {
@@ -1972,7 +1977,7 @@ static int add_jump_table(struct objtool_file *file, struct instruction *insn,
 		if (prev_offset && reloc_offset(reloc) != prev_offset + arch_reloc_size(reloc))
 			break;
 
-		sym_offset = reloc->sym->offset + reloc_addend(reloc);
+		sym_offset = arch_jump_table_sym_offset(reloc, table);
 
 		/* Detect function pointers from contiguous objects: */
 		if (reloc->sym->sec == pfunc->sec && sym_offset == pfunc->offset)
diff --git a/tools/objtool/include/objtool/arch.h b/tools/objtool/include/objtool/arch.h
index 396f7c6c81c0f..089a1acc48a8d 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -98,5 +98,6 @@ int arch_rewrite_retpolines(struct objtool_file *file);
 bool arch_pc_relative_reloc(struct reloc *reloc);
 
 unsigned int arch_reloc_size(struct reloc *reloc);
+unsigned long arch_jump_table_sym_offset(struct reloc *reloc, struct reloc *table);
 
 #endif /* _ARCH_H */
-- 
2.39.5



