Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119572505BD;
	Wed,  5 Mar 2025 18:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198559; cv=none; b=ouuTaZERa6Ax+BlWHM4MsAM0eqYnxUTLcRX+i4U+Bk+w0Jutjolv4lcA44QoctXmXk64Fx8A4giN2bjyPPbqQobAY/AUitklGVYQKUlPEiki+hJcqYTTXiuoDZ6xrQR2hKU3EB6PHpZ0kWPp0wjcMV+9lXjnC2vuXj/EdZGFWKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198559; c=relaxed/simple;
	bh=AM09X5vPG07jOp6vl2ejZXAzmjCXf4UcQzvMNog/BHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DW5TWfV+DkDu4X+uXc/6AQ8Hnd94A2N6IrS19Yhq8TznjtltopBXWaQR+efXI5Sup74vPZeFoAIS5q+mgFQquD3sZzU/HAGuOD31dttTjnCIhTAmsgR7c5kWP7b3o8U7BimINYHJmOcPnvemSRY+jOFRFph6Mwi5QLTneHEoJm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q236tHDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q236tHDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6DEC4CED1;
	Wed,  5 Mar 2025 18:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198558;
	bh=AM09X5vPG07jOp6vl2ejZXAzmjCXf4UcQzvMNog/BHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q236tHDk+1MPuHq3u1d+gSdAt4lMo/bA20Ka8xQLijiYZW/qn4iwuqhJiOX0Pi98e
	 3HIxgbshQdfOBNOpWoOJokTQN881rtNbuQWhhe/7+G9/brrwS1T8mqpHhUkLEbPk0s
	 /RV4nzZ6CjXn5pTiF7158Xa0z21gD4m7i/nNj1t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 070/157] objtool: Remove annotate_{,un}reachable()
Date: Wed,  5 Mar 2025 18:48:26 +0100
Message-ID: <20250305174508.115393593@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 06e24745985c8dd0da18337503afcf2f2fdbdff1 ]

There are no users of annotate_reachable() left.

And the annotate_unreachable() usage in unreachable() is plain wrong;
it will hide dangerous fall-through code-gen.

Remove both.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/20241128094312.235637588@infradead.org
Stable-dep-of: 73cfc53cc3b6 ("objtool: Fix C jump table annotations for Clang")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler.h | 27 -------------------------
 tools/objtool/check.c    | 43 ++--------------------------------------
 2 files changed, 2 insertions(+), 68 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index bd5d10c479c09..8104d3568d673 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -109,35 +109,9 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 
 /* Unreachable code */
 #ifdef CONFIG_OBJTOOL
-/*
- * These macros help objtool understand GCC code flow for unreachable code.
- * The __COUNTER__ based labels are a hack to make each instance of the macros
- * unique, to convince GCC not to merge duplicate inline asm statements.
- */
-#define __stringify_label(n) #n
-
-#define __annotate_reachable(c) ({					\
-	asm volatile(__stringify_label(c) ":\n\t"			\
-			".pushsection .discard.reachable\n\t"		\
-			".long " __stringify_label(c) "b - .\n\t"	\
-			".popsection\n\t");				\
-})
-#define annotate_reachable() __annotate_reachable(__COUNTER__)
-
-#define __annotate_unreachable(c) ({					\
-	asm volatile(__stringify_label(c) ":\n\t"			\
-		     ".pushsection .discard.unreachable\n\t"		\
-		     ".long " __stringify_label(c) "b - .\n\t"		\
-		     ".popsection\n\t" : : "i" (c));			\
-})
-#define annotate_unreachable() __annotate_unreachable(__COUNTER__)
-
 /* Annotate a C jump table to allow objtool to follow the code flow */
 #define __annotate_jump_table __section(".rodata..c_jump_table,\"a\",@progbits #")
-
 #else /* !CONFIG_OBJTOOL */
-#define annotate_reachable()
-#define annotate_unreachable()
 #define __annotate_jump_table
 #endif /* CONFIG_OBJTOOL */
 
@@ -147,7 +121,6 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
  * control elsewhere.
  */
 #define unreachable() do {		\
-	annotate_unreachable();		\
 	barrier_before_unreachable();	\
 	__builtin_unreachable();	\
 } while (0)
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index e7ec29dfdff22..4d7d2c115cbac 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -639,47 +639,8 @@ static int add_dead_ends(struct objtool_file *file)
 	uint64_t offset;
 
 	/*
-	 * Check for manually annotated dead ends.
-	 */
-	rsec = find_section_by_name(file->elf, ".rela.discard.unreachable");
-	if (!rsec)
-		goto reachable;
-
-	for_each_reloc(rsec, reloc) {
-		if (reloc->sym->type == STT_SECTION) {
-			offset = reloc_addend(reloc);
-		} else if (reloc->sym->local_label) {
-			offset = reloc->sym->offset;
-		} else {
-			WARN("unexpected relocation symbol type in %s", rsec->name);
-			return -1;
-		}
-
-		insn = find_insn(file, reloc->sym->sec, offset);
-		if (insn)
-			insn = prev_insn_same_sec(file, insn);
-		else if (offset == reloc->sym->sec->sh.sh_size) {
-			insn = find_last_insn(file, reloc->sym->sec);
-			if (!insn) {
-				WARN("can't find unreachable insn at %s+0x%" PRIx64,
-				     reloc->sym->sec->name, offset);
-				return -1;
-			}
-		} else {
-			WARN("can't find unreachable insn at %s+0x%" PRIx64,
-			     reloc->sym->sec->name, offset);
-			return -1;
-		}
-
-		insn->dead_end = true;
-	}
-
-reachable:
-	/*
-	 * These manually annotated reachable checks are needed for GCC 4.4,
-	 * where the Linux unreachable() macro isn't supported.  In that case
-	 * GCC doesn't know the "ud2" is fatal, so it generates code as if it's
-	 * not a dead end.
+	 * UD2 defaults to being a dead-end, allow them to be annotated for
+	 * non-fatal, eg WARN.
 	 */
 	rsec = find_section_by_name(file->elf, ".rela.discard.reachable");
 	if (!rsec)
-- 
2.39.5



