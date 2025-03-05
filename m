Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956AD1ACEDD;
	Wed,  5 Mar 2025 18:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198257; cv=none; b=QWLMQGozhRPjlG4Z0DFKMXIPYUBhSo7yBhWD99UuB7PGuRYgN0zKoeOfFkx0RXPKabf/9FHbU/MZbdnqrt2KnZtLmzZpkQm2uJpMJ6IX0jXRIA40qXcg/AcOPhnoqD0H0al7Z0FhdbqU8PMk2jx3NX3ulAY3HGt+f2EuSPdNqSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198257; c=relaxed/simple;
	bh=hVc+fGo2CEXARBREtSdBWE7AgWoTh3QaNxG24f5PQrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLDxajBsWCf7vXl2/wMrixEy57kAgQzylznbUPATcn+0tbh4yg8jn+imLGkDrrBvG7lIvtqMbx5NSoEqqc28oOoPYYj6luXqddFquSSYDXJZ5QNfWnd2uXq4c4jrO72JT0TiCFKY6INmU4xVEPoVjr5kqiatXG/n7J1mZM3za1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+fe98SP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+fe98SP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F08C4CEE0;
	Wed,  5 Mar 2025 18:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198257;
	bh=hVc+fGo2CEXARBREtSdBWE7AgWoTh3QaNxG24f5PQrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+fe98SPElNTkMO9fltepx9USbmtOyLPmTwglFm90SqBbk9Qm9Redf84wIAzDg373
	 JXTgeqosP2QfdJihstJ305+mO2vpVP0VbaexycnqtjE5NyK9Snn1Uc5LrTpFcQ/2vu
	 GJELXWZ8RzcKTlwKBEaMBUBj1/bgeOIzfek2hJ5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/150] objtool: Remove annotate_{,un}reachable()
Date: Wed,  5 Mar 2025 18:48:25 +0100
Message-ID: <20250305174506.868421566@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0d10d75218f51..75a83394824c4 100644
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
index 8e02db7e83323..3e72c9f9b7f37 100644
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



