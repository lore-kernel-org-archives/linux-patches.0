Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374AF26AA89;
	Tue,  8 Apr 2025 11:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111746; cv=none; b=Q7nKxLM7wVSfGK3lQzlOpz3piUfbL12fIE5kiy90kuGFJkorTTRYaRimxySaEBDgcRvX1EhqoPiQZG6hogYd4WVG8b/0uAGOWvGR12kfJ1LpYq/StSeUYkR3DlT5GVQNCmfZtakcJnpiVcOyFPc0qQY3eI7AXxb+3W1BC0W3r0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111746; c=relaxed/simple;
	bh=dgfpyDbxHAnwVsdtd/abe58+/wtgNXfjNniYpybVky0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEQOnHaCmJZE7XVUIaNa3Z35c2PjJu3+qyjmdMvhPmq0D2vBMJ6pRHbkocJZtz3RQhgT8F1DQWN5RVuU0vyuGxI6MjIdnR4GA8raiBo9rpXdePiYj/kGwgavDZY2cS2cTYZ5ob3qc2MHlRYOOwgMtxAMp755n+Lvh0u6ijwybNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUsgszFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUsgszFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB307C4CEE5;
	Tue,  8 Apr 2025 11:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111746;
	bh=dgfpyDbxHAnwVsdtd/abe58+/wtgNXfjNniYpybVky0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUsgszFH/7nunOhPZZzFOAVa3TrxyPOE5kmD5VEJhk6zFzF5jm6XA5d2wlNR/Mqv2
	 KpDdbrTkr46VKSFHBNnn2+0TLHBQpxEl89Gmt2iy1GzFFMZZudx/s4rjl2Th0B0tw/
	 xuXGRHrdUhq1HFy06E7hekXP56+aJnl+tjbv5eKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 543/731] objtool: Handle various symbol types of rodata
Date: Tue,  8 Apr 2025 12:47:20 +0200
Message-ID: <20250408104926.907425008@linuxfoundation.org>
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

[ Upstream commit ab6ce22b789622ca732e91cbb3a5cb5ba370cbd0 ]

In the relocation section ".rela.rodata" of each .o file compiled with
LoongArch toolchain, there are various symbol types such as STT_NOTYPE,
STT_OBJECT, STT_FUNC in addition to the usual STT_SECTION, it needs to
use reloc symbol offset instead of reloc addend to find the destination
instruction in find_jump_table() and add_jump_table().

For the most part, an absolute relocation type is used for rodata. In the
case of STT_SECTION, reloc->sym->offset is always zero, and for the other
symbol types, reloc_addend(reloc) is always zero, thus it can use a simple
statement "reloc->sym->offset + reloc_addend(reloc)" to obtain the symbol
offset for various symbol types.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/r/20250211115016.26913-2-yangtiezhu@loongson.cn
Acked-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Stable-dep-of: ef753d66051c ("objtool: Fix detection of consecutive jump tables on Clang 20")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index c1fa0220f33de..79c49c75b429b 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1954,6 +1954,7 @@ static int add_jump_table(struct objtool_file *file, struct instruction *insn,
 	unsigned int prev_offset = 0;
 	struct reloc *reloc = table;
 	struct alternative *alt;
+	unsigned long sym_offset;
 
 	/*
 	 * Each @reloc is a switch table relocation which points to the target
@@ -1971,9 +1972,10 @@ static int add_jump_table(struct objtool_file *file, struct instruction *insn,
 		if (prev_offset && reloc_offset(reloc) != prev_offset + 8)
 			break;
 
+		sym_offset = reloc->sym->offset + reloc_addend(reloc);
+
 		/* Detect function pointers from contiguous objects: */
-		if (reloc->sym->sec == pfunc->sec &&
-		    reloc_addend(reloc) == pfunc->offset)
+		if (reloc->sym->sec == pfunc->sec && sym_offset == pfunc->offset)
 			break;
 
 		/*
@@ -1981,10 +1983,10 @@ static int add_jump_table(struct objtool_file *file, struct instruction *insn,
 		 * which point to the end of the function.  Ignore them.
 		 */
 		if (reloc->sym->sec == pfunc->sec &&
-		    reloc_addend(reloc) == pfunc->offset + pfunc->len)
+		    sym_offset == pfunc->offset + pfunc->len)
 			goto next;
 
-		dest_insn = find_insn(file, reloc->sym->sec, reloc_addend(reloc));
+		dest_insn = find_insn(file, reloc->sym->sec, sym_offset);
 		if (!dest_insn)
 			break;
 
@@ -2023,6 +2025,7 @@ static void find_jump_table(struct objtool_file *file, struct symbol *func,
 	struct reloc *table_reloc;
 	struct instruction *dest_insn, *orig_insn = insn;
 	unsigned long table_size;
+	unsigned long sym_offset;
 
 	/*
 	 * Backward search using the @first_jump_src links, these help avoid
@@ -2046,7 +2049,10 @@ static void find_jump_table(struct objtool_file *file, struct symbol *func,
 		table_reloc = arch_find_switch_table(file, insn, &table_size);
 		if (!table_reloc)
 			continue;
-		dest_insn = find_insn(file, table_reloc->sym->sec, reloc_addend(table_reloc));
+
+		sym_offset = table_reloc->sym->offset + reloc_addend(table_reloc);
+
+		dest_insn = find_insn(file, table_reloc->sym->sec, sym_offset);
 		if (!dest_insn || !insn_func(dest_insn) || insn_func(dest_insn)->pfunc != func)
 			continue;
 
-- 
2.39.5



