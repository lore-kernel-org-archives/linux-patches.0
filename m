Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44A5388364;
	Tue, 10 Mar 2026 11:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141972; cv=none; b=Yv8SM1U80My+m9sjledzprfW+3gJhsz9lqBKF+UwSVEYFQA4ArnDnQ6sBw/5wOpJgjIcy/GOEhAl0BGtDHl+oJtT8Q0AnCdakQd95tOtOOFb5LPYLM3pZ+TdsqSmBB8AJDDT5Fuvg0wwGxAoaH2gGzzntI5uTQIwvcIEyrN44oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141972; c=relaxed/simple;
	bh=N1keDK2B16HDwjI3CPafDcY8P2v1OPn7mGpx6v28ZRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fV+LNSvmBAY3s1dc6tkhGahhzDlIpAWlUukPDGHJp9TBjRzTHabYHk2TRrmnsfXgadXmjwef223wbLsDNuqlcED2ZVaYCoLpaz5r2YWwa0rmrJwZvepVHFQl5G1oZdmp3lf2Ir9qZk5DxJ0+7JXdG8CTj1gIM8qfgvo/UjFujOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X2iFgiYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X2iFgiYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA05C2BCAF;
	Tue, 10 Mar 2026 11:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141972;
	bh=N1keDK2B16HDwjI3CPafDcY8P2v1OPn7mGpx6v28ZRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2iFgiYqXvDOhacwZr4NYn4LGUmGuV8GUkcBxH9YLSZcR/oDTTibVToVX0cLbElMK
	 UQMEINQ2elrwfkioA9lm7yOQVGboJBuefCXEsV1leSmV+gq2Qh3UTOkHeQzUsw/VTG
	 vVDc5d3STJwL/GRIMIKJ4ZmD4bn+OajHc/YdiCPjxtn5cL2nIHgmJlRxirzF1KA2i3
	 /6N5sL1dy0GVGQFqVkTivacXMZnfHaB/wXvfDeJtLcZjgInn2BPjPmBzWz41kPPa3C
	 d+Va8q1SyN5saU4sjosL8vWbHJ3CO1kK2aw33/mjYyIIHCa95gq9pn/xXcrtvDeICB
	 /7VfAxd+U//cg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Jens Remus <jremus@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/314] unwind_user/x86: Teach FP unwind about start of function
Date: Tue, 10 Mar 2026 07:15:56 -0400
Message-ID: <30e84d1986eaee7b48635cbaa3030555af19c1a2.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit ae25884ad749e7f6e0c3565513bdc8aa2554a425 ]

When userspace is interrupted at the start of a function, before we
get a chance to complete the frame, unwind will miss one caller.

X86 has a uprobe specific fixup for this, add bits to the generic
unwinder to support this.

Suggested-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20251024145156.GM4068168@noisy.programming.kicks-ass.net
Stable-dep-of: d55c571e4333 ("x86/uprobes: Fix XOL allocation failure for 32-bit tasks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c             | 40 ------------------------------
 arch/x86/include/asm/unwind_user.h | 12 +++++++++
 arch/x86/include/asm/uprobes.h     |  9 +++++++
 arch/x86/kernel/uprobes.c          | 32 ++++++++++++++++++++++++
 include/linux/unwind_user_types.h  |  1 +
 kernel/unwind/user.c               | 39 ++++++++++++++++++++++-------
 6 files changed, 84 insertions(+), 49 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 56df4855f38e9..64e2bf2d4a615 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2846,46 +2846,6 @@ static unsigned long get_segment_base(unsigned int segment)
 	return get_desc_base(desc);
 }
 
-#ifdef CONFIG_UPROBES
-/*
- * Heuristic-based check if uprobe is installed at the function entry.
- *
- * Under assumption of user code being compiled with frame pointers,
- * `push %rbp/%ebp` is a good indicator that we indeed are.
- *
- * Similarly, `endbr64` (assuming 64-bit mode) is also a common pattern.
- * If we get this wrong, captured stack trace might have one extra bogus
- * entry, but the rest of stack trace will still be meaningful.
- */
-static bool is_uprobe_at_func_entry(struct pt_regs *regs)
-{
-	struct arch_uprobe *auprobe;
-
-	if (!current->utask)
-		return false;
-
-	auprobe = current->utask->auprobe;
-	if (!auprobe)
-		return false;
-
-	/* push %rbp/%ebp */
-	if (auprobe->insn[0] == 0x55)
-		return true;
-
-	/* endbr64 (64-bit only) */
-	if (user_64bit_mode(regs) && is_endbr((u32 *)auprobe->insn))
-		return true;
-
-	return false;
-}
-
-#else
-static bool is_uprobe_at_func_entry(struct pt_regs *regs)
-{
-	return false;
-}
-#endif /* CONFIG_UPROBES */
-
 #ifdef CONFIG_IA32_EMULATION
 
 #include <linux/compat.h>
diff --git a/arch/x86/include/asm/unwind_user.h b/arch/x86/include/asm/unwind_user.h
index b166e102d4445..c4f1ff8874d67 100644
--- a/arch/x86/include/asm/unwind_user.h
+++ b/arch/x86/include/asm/unwind_user.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_UNWIND_USER_H
 
 #include <asm/ptrace.h>
+#include <asm/uprobes.h>
 
 #define ARCH_INIT_USER_FP_FRAME(ws)			\
 	.cfa_off	=  2*(ws),			\
@@ -10,6 +11,12 @@
 	.fp_off		= -2*(ws),			\
 	.use_fp		= true,
 
+#define ARCH_INIT_USER_FP_ENTRY_FRAME(ws)		\
+	.cfa_off	=  1*(ws),			\
+	.ra_off		= -1*(ws),			\
+	.fp_off		= 0,				\
+	.use_fp		= false,
+
 static inline int unwind_user_word_size(struct pt_regs *regs)
 {
 	/* We can't unwind VM86 stacks */
@@ -22,4 +29,9 @@ static inline int unwind_user_word_size(struct pt_regs *regs)
 	return sizeof(long);
 }
 
+static inline bool unwind_user_at_function_start(struct pt_regs *regs)
+{
+	return is_uprobe_at_func_entry(regs);
+}
+
 #endif /* _ASM_X86_UNWIND_USER_H */
diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 1ee2e5115955c..362210c799987 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -62,4 +62,13 @@ struct arch_uprobe_task {
 	unsigned int			saved_tf;
 };
 
+#ifdef CONFIG_UPROBES
+extern bool is_uprobe_at_func_entry(struct pt_regs *regs);
+#else
+static bool is_uprobe_at_func_entry(struct pt_regs *regs)
+{
+	return false;
+}
+#endif /* CONFIG_UPROBES */
+
 #endif	/* _ASM_UPROBES_H */
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 845aeaf36b8d2..7ef0535fcd547 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -1819,3 +1819,35 @@ bool arch_uretprobe_is_alive(struct return_instance *ret, enum rp_check ctx,
 	else
 		return regs->sp <= ret->stack;
 }
+
+/*
+ * Heuristic-based check if uprobe is installed at the function entry.
+ *
+ * Under assumption of user code being compiled with frame pointers,
+ * `push %rbp/%ebp` is a good indicator that we indeed are.
+ *
+ * Similarly, `endbr64` (assuming 64-bit mode) is also a common pattern.
+ * If we get this wrong, captured stack trace might have one extra bogus
+ * entry, but the rest of stack trace will still be meaningful.
+ */
+bool is_uprobe_at_func_entry(struct pt_regs *regs)
+{
+	struct arch_uprobe *auprobe;
+
+	if (!current->utask)
+		return false;
+
+	auprobe = current->utask->auprobe;
+	if (!auprobe)
+		return false;
+
+	/* push %rbp/%ebp */
+	if (auprobe->insn[0] == 0x55)
+		return true;
+
+	/* endbr64 (64-bit only) */
+	if (user_64bit_mode(regs) && is_endbr((u32 *)auprobe->insn))
+		return true;
+
+	return false;
+}
diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h
index 938f7e6233327..412729a269bcc 100644
--- a/include/linux/unwind_user_types.h
+++ b/include/linux/unwind_user_types.h
@@ -39,6 +39,7 @@ struct unwind_user_state {
 	unsigned int				ws;
 	enum unwind_user_type			current_type;
 	unsigned int				available_types;
+	bool					topmost;
 	bool					done;
 };
 
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index 642871527a132..39e2707894447 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -26,14 +26,12 @@ get_user_word(unsigned long *word, unsigned long base, int off, unsigned int ws)
 	return get_user(*word, addr);
 }
 
-static int unwind_user_next_fp(struct unwind_user_state *state)
+static int unwind_user_next_common(struct unwind_user_state *state,
+				   const struct unwind_user_frame *frame)
 {
-	const struct unwind_user_frame frame = {
-		ARCH_INIT_USER_FP_FRAME(state->ws)
-	};
 	unsigned long cfa, fp, ra;
 
-	if (frame.use_fp) {
+	if (frame->use_fp) {
 		if (state->fp < state->sp)
 			return -EINVAL;
 		cfa = state->fp;
@@ -42,7 +40,7 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
 	}
 
 	/* Get the Canonical Frame Address (CFA) */
-	cfa += frame.cfa_off;
+	cfa += frame->cfa_off;
 
 	/* stack going in wrong direction? */
 	if (cfa <= state->sp)
@@ -53,19 +51,41 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
 		return -EINVAL;
 
 	/* Find the Return Address (RA) */
-	if (get_user_word(&ra, cfa, frame.ra_off, state->ws))
+	if (get_user_word(&ra, cfa, frame->ra_off, state->ws))
 		return -EINVAL;
 
-	if (frame.fp_off && get_user_word(&fp, cfa, frame.fp_off, state->ws))
+	if (frame->fp_off && get_user_word(&fp, cfa, frame->fp_off, state->ws))
 		return -EINVAL;
 
 	state->ip = ra;
 	state->sp = cfa;
-	if (frame.fp_off)
+	if (frame->fp_off)
 		state->fp = fp;
+	state->topmost = false;
 	return 0;
 }
 
+static int unwind_user_next_fp(struct unwind_user_state *state)
+{
+#ifdef CONFIG_HAVE_UNWIND_USER_FP
+	struct pt_regs *regs = task_pt_regs(current);
+
+	if (state->topmost && unwind_user_at_function_start(regs)) {
+		const struct unwind_user_frame fp_entry_frame = {
+			ARCH_INIT_USER_FP_ENTRY_FRAME(state->ws)
+		};
+		return unwind_user_next_common(state, &fp_entry_frame);
+	}
+
+	const struct unwind_user_frame fp_frame = {
+		ARCH_INIT_USER_FP_FRAME(state->ws)
+	};
+	return unwind_user_next_common(state, &fp_frame);
+#else
+	return -EINVAL;
+#endif
+}
+
 static int unwind_user_next(struct unwind_user_state *state)
 {
 	unsigned long iter_mask = state->available_types;
@@ -118,6 +138,7 @@ static int unwind_user_start(struct unwind_user_state *state)
 		state->done = true;
 		return -EINVAL;
 	}
+	state->topmost = true;
 
 	return 0;
 }
-- 
2.51.0

