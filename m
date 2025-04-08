Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D2626B091;
	Tue,  8 Apr 2025 11:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111754; cv=none; b=GQP/Ny5y14zmD5RbHIPJRzsEsVzN2WvjNoCJ/5LFpyIRD1Z1Cx8IaoKtyDsPcyN2kTCwohM2u7ygSwLVvtS0+DR0ATMmgCHA4pY1PmVfyGWhBJ33wW9/MWiuHVLm1xsqLPJIybLv19MBBnmY07Ufm4odlum4f78Xnj5slwMjOWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111754; c=relaxed/simple;
	bh=Z6qbWK6YM67DjlxctfD+Y4WnTreXyLJov4wmYXsM0+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwcyT5hRLHNYdd+e3JkM5YoICxALkVNXR1X3pDVmOViTYlE9yiH9nTgbztg18od9yVjoHQ7alrhjTidZTccXDLS4oZHsvvi9u48ItsQ3v8AjlGLLYDN7hVnRz3Sdhgj/O1UKlI+84YyoLAbfBOPKxcEVkP3aipVhkV2sDk3kvM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqbyUmXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqbyUmXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B6FC4CEEE;
	Tue,  8 Apr 2025 11:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111754;
	bh=Z6qbWK6YM67DjlxctfD+Y4WnTreXyLJov4wmYXsM0+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqbyUmXsrr0RBYHHblnqp1xUpMAR4Zac6zZQ5drvLwwSPbts2EwfTW5AD2/WH5nK9
	 viqynyC7s5NJD3qtZFPW5HK8q8xITqndCTUTDGh2xULVFFDbU/XhgDsUqOjmWjhGI1
	 Z/DhTwddXb7vmp3qYmPxylExKFpad/zIFOwv1anI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 546/731] objtool: Fix detection of consecutive jump tables on Clang 20
Date: Tue,  8 Apr 2025 12:47:23 +0200
Message-ID: <20250408104926.976020908@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit ef753d66051ca03bee1982ce047f9eaf90f81ab4 ]

The jump table detection code assumes jump tables are in the same order
as their corresponding indirect branches.  That's apparently not always
true with Clang 20.

Fix that by changing how multiple jump tables are detected.  In the
first detection pass, mark the beginning of each jump table so the
second pass can tell where one ends and the next one begins.

Fixes the following warnings:

  vmlinux.o: warning: objtool: SiS_GetCRT2Ptr+0x1ad: stack state mismatch: cfa1=4+8 cfa2=5+16
  sound/core/seq/snd-seq.o: warning: objtool: cc_ev_to_ump_midi2+0x589: return with modified stack frame

Fixes: be2f0b1e1264 ("objtool: Get rid of reloc->jump_table_start")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/141752fff614eab962dba6bdfaa54aa67ff03bba.1742852846.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/oe-kbuild-all/202503171547.LlCTJLQL-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202503200535.J3hAvcjw-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c               | 26 ++++++++------------------
 tools/objtool/elf.c                 |  6 +++---
 tools/objtool/include/objtool/elf.h | 27 ++++++++++++++++++++++++++-
 3 files changed, 37 insertions(+), 22 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 12bf6c1f5071d..813e708c16499 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -1949,8 +1949,7 @@ __weak unsigned long arch_jump_table_sym_offset(struct reloc *reloc, struct relo
 	return reloc->sym->offset + reloc_addend(reloc);
 }
 
-static int add_jump_table(struct objtool_file *file, struct instruction *insn,
-			  struct reloc *next_table)
+static int add_jump_table(struct objtool_file *file, struct instruction *insn)
 {
 	unsigned long table_size = insn_jump_table_size(insn);
 	struct symbol *pfunc = insn_func(insn)->pfunc;
@@ -1970,7 +1969,7 @@ static int add_jump_table(struct objtool_file *file, struct instruction *insn,
 		/* Check for the end of the table: */
 		if (table_size && reloc_offset(reloc) - reloc_offset(table) >= table_size)
 			break;
-		if (reloc != table && reloc == next_table)
+		if (reloc != table && is_jump_table(reloc))
 			break;
 
 		/* Make sure the table entries are consecutive: */
@@ -2061,8 +2060,10 @@ static void find_jump_table(struct objtool_file *file, struct symbol *func,
 		if (!dest_insn || !insn_func(dest_insn) || insn_func(dest_insn)->pfunc != func)
 			continue;
 
+		set_jump_table(table_reloc);
 		orig_insn->_jump_table = table_reloc;
 		orig_insn->_jump_table_size = table_size;
+
 		break;
 	}
 }
@@ -2104,31 +2105,20 @@ static void mark_func_jump_tables(struct objtool_file *file,
 static int add_func_jump_tables(struct objtool_file *file,
 				  struct symbol *func)
 {
-	struct instruction *insn, *insn_t1 = NULL, *insn_t2;
-	int ret = 0;
+	struct instruction *insn;
+	int ret;
 
 	func_for_each_insn(file, func, insn) {
 		if (!insn_jump_table(insn))
 			continue;
 
-		if (!insn_t1) {
-			insn_t1 = insn;
-			continue;
-		}
-
-		insn_t2 = insn;
 
-		ret = add_jump_table(file, insn_t1, insn_jump_table(insn_t2));
+		ret = add_jump_table(file, insn);
 		if (ret)
 			return ret;
-
-		insn_t1 = insn_t2;
 	}
 
-	if (insn_t1)
-		ret = add_jump_table(file, insn_t1, NULL);
-
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 6f64d611faea9..934855be631c0 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -583,7 +583,7 @@ static int elf_update_sym_relocs(struct elf *elf, struct symbol *sym)
 {
 	struct reloc *reloc;
 
-	for (reloc = sym->relocs; reloc; reloc = reloc->sym_next_reloc)
+	for (reloc = sym->relocs; reloc; reloc = sym_next_reloc(reloc))
 		set_reloc_sym(elf, reloc, reloc->sym->idx);
 
 	return 0;
@@ -880,7 +880,7 @@ static struct reloc *elf_init_reloc(struct elf *elf, struct section *rsec,
 	set_reloc_addend(elf, reloc, addend);
 
 	elf_hash_add(reloc, &reloc->hash, reloc_hash(reloc));
-	reloc->sym_next_reloc = sym->relocs;
+	set_sym_next_reloc(reloc, sym->relocs);
 	sym->relocs = reloc;
 
 	return reloc;
@@ -979,7 +979,7 @@ static int read_relocs(struct elf *elf)
 			}
 
 			elf_hash_add(reloc, &reloc->hash, reloc_hash(reloc));
-			reloc->sym_next_reloc = sym->relocs;
+			set_sym_next_reloc(reloc, sym->relocs);
 			sym->relocs = reloc;
 
 			nr_reloc++;
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index d7e815c2fd156..764cba535f22e 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -77,7 +77,7 @@ struct reloc {
 	struct elf_hash_node hash;
 	struct section *sec;
 	struct symbol *sym;
-	struct reloc *sym_next_reloc;
+	unsigned long _sym_next_reloc;
 };
 
 struct elf {
@@ -297,6 +297,31 @@ static inline void set_reloc_type(struct elf *elf, struct reloc *reloc, unsigned
 	mark_sec_changed(elf, reloc->sec, true);
 }
 
+#define RELOC_JUMP_TABLE_BIT 1UL
+
+/* Does reloc mark the beginning of a jump table? */
+static inline bool is_jump_table(struct reloc *reloc)
+{
+	return reloc->_sym_next_reloc & RELOC_JUMP_TABLE_BIT;
+}
+
+static inline void set_jump_table(struct reloc *reloc)
+{
+	reloc->_sym_next_reloc |= RELOC_JUMP_TABLE_BIT;
+}
+
+static inline struct reloc *sym_next_reloc(struct reloc *reloc)
+{
+	return (struct reloc *)(reloc->_sym_next_reloc & ~RELOC_JUMP_TABLE_BIT);
+}
+
+static inline void set_sym_next_reloc(struct reloc *reloc, struct reloc *next)
+{
+	unsigned long bit = reloc->_sym_next_reloc & RELOC_JUMP_TABLE_BIT;
+
+	reloc->_sym_next_reloc = (unsigned long)next | bit;
+}
+
 #define for_each_sec(file, sec)						\
 	list_for_each_entry(sec, &file->elf->sections, list)
 
-- 
2.39.5



