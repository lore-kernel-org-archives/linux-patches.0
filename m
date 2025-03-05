Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E158119ABA3;
	Wed,  5 Mar 2025 18:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198562; cv=none; b=K4uK2r4CeolW/EFW5PH2t4fIEYOdaPmXI8ApHJLJZ/OKBuRZKxAv4pSAyG+3AXm0xNjSbejgqIt/nNvBXLrXk1zI3cqIi0rY5oOf8QRZvDEP6Qgnr3i9lhQUW76wquPblkbcHt168mUqfDJJOqH80YNQDHkVNlvRrJq+Sifqi54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198562; c=relaxed/simple;
	bh=au/wMKkrfQtDqAtWWtVP1rTolXcTFPqoXOE0pwf6NiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mt5TrO77OozVwkyrTJG/sVKt4Rwcr52Q9M7yk92b4i741b7iwHmb/vhmGqvZ/HJOMwF1hSr7Ka8AaWbgCpPUARakwE6X5Ct4R+Ng3bs8OsifFfK5nhEDGlTgHIE1M8Jy6JWZTJEa9VWIp3Cyjevpc8ho7L5O3xBHdJREwaIQG04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cktN27Vk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cktN27Vk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADC4C4CED1;
	Wed,  5 Mar 2025 18:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198561;
	bh=au/wMKkrfQtDqAtWWtVP1rTolXcTFPqoXOE0pwf6NiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cktN27Vk3IC3EqP3RLGxamB2MhygBeqz9yV0zELfmGTvvQxl9NJPHcpSYNWlSQwJJ
	 TvrITiSVQQPyvT4XZQyCoA4wIhmLrkd9eDVEyJDMVdvcPqi2aCLi4VCi4VfprlIBEk
	 6iXFzORbNloGOrXwcjFfGA6kfhV7QZWpHnpQf71w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH 6.13 071/157] objtool: Fix C jump table annotations for Clang
Date: Wed,  5 Mar 2025 18:48:27 +0100
Message-ID: <20250305174508.156006944@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 73cfc53cc3b6380eccf013049574485f64cb83ca ]

A C jump table (such as the one used by the BPF interpreter) is a const
global array of absolute code addresses, and this means that the actual
values in the table may not be known until the kernel is booted (e.g.,
when using KASLR or when the kernel VA space is sized dynamically).

When using PIE codegen, the compiler will default to placing such const
global objects in .data.rel.ro (which is annotated as writable), rather
than .rodata (which is annotated as read-only). As C jump tables are
explicitly emitted into .rodata, this used to result in warnings for
LoongArch builds (which uses PIE codegen for the entire kernel) like

  Warning: setting incorrect section attributes for .rodata..c_jump_table

due to the fact that the explicitly specified .rodata section inherited
the read-write annotation that the compiler uses for such objects when
using PIE codegen.

This warning was suppressed by explicitly adding the read-only
annotation to the __attribute__((section(""))) string, by commit

  c5b1184decc8 ("compiler.h: specify correct attribute for .rodata..c_jump_table")

Unfortunately, this hack does not work on Clang's integrated assembler,
which happily interprets the appended section type and permission
specifiers as part of the section name, which therefore no longer
matches the hard-coded pattern '.rodata..c_jump_table' that objtool
expects, causing it to emit a warning

  kernel/bpf/core.o: warning: objtool: ___bpf_prog_run+0x20: sibling call from callable instruction with modified stack frame

Work around this, by emitting C jump tables into .data.rel.ro instead,
which is treated as .rodata by the linker script for all builds, not
just PIE based ones.

Fixes: c5b1184decc8 ("compiler.h: specify correct attribute for .rodata..c_jump_table")
Tested-by: Tiezhu Yang <yangtiezhu@loongson.cn> # on LoongArch
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20250221135704.431269-6-ardb+git@google.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler.h                | 2 +-
 tools/objtool/check.c                   | 7 ++++---
 tools/objtool/include/objtool/special.h | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 8104d3568d673..d004f9b5528d7 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -110,7 +110,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 /* Unreachable code */
 #ifdef CONFIG_OBJTOOL
 /* Annotate a C jump table to allow objtool to follow the code flow */
-#define __annotate_jump_table __section(".rodata..c_jump_table,\"a\",@progbits #")
+#define __annotate_jump_table __section(".data.rel.ro.c_jump_table")
 #else /* !CONFIG_OBJTOOL */
 #define __annotate_jump_table
 #endif /* CONFIG_OBJTOOL */
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 4d7d2c115cbac..6691bd106e4b6 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2589,13 +2589,14 @@ static void mark_rodata(struct objtool_file *file)
 	 *
 	 * - .rodata: can contain GCC switch tables
 	 * - .rodata.<func>: same, if -fdata-sections is being used
-	 * - .rodata..c_jump_table: contains C annotated jump tables
+	 * - .data.rel.ro.c_jump_table: contains C annotated jump tables
 	 *
 	 * .rodata.str1.* sections are ignored; they don't contain jump tables.
 	 */
 	for_each_sec(file, sec) {
-		if (!strncmp(sec->name, ".rodata", 7) &&
-		    !strstr(sec->name, ".str1.")) {
+		if ((!strncmp(sec->name, ".rodata", 7) &&
+		     !strstr(sec->name, ".str1.")) ||
+		    !strncmp(sec->name, ".data.rel.ro", 12)) {
 			sec->rodata = true;
 			found = true;
 		}
diff --git a/tools/objtool/include/objtool/special.h b/tools/objtool/include/objtool/special.h
index 86d4af9c5aa9d..89ee12b1a1384 100644
--- a/tools/objtool/include/objtool/special.h
+++ b/tools/objtool/include/objtool/special.h
@@ -10,7 +10,7 @@
 #include <objtool/check.h>
 #include <objtool/elf.h>
 
-#define C_JUMP_TABLE_SECTION ".rodata..c_jump_table"
+#define C_JUMP_TABLE_SECTION ".data.rel.ro.c_jump_table"
 
 struct special_alt {
 	struct list_head list;
-- 
2.39.5



