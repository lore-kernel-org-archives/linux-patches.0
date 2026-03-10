Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD86537B413;
	Tue, 10 Mar 2026 11:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141970; cv=none; b=PflEDizsb60cKuE6KFyG6BCRr6JcNg/Ps+5nG0nEoM5g1hFc2VTrcxB5ZDzwr5yADj+DevjLCSboT1rnOXiHVRrvK59yMWf3xwK3xubuonkd/dfUr7p19U8O4rnEMg3QhFW2bT/lGiMH2SIghSqI739gtBlXUTi4ZyfqGOsTlTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141970; c=relaxed/simple;
	bh=0Cm+rfsYwmtSGR21m1f5DOfCNaKOTLvXwAXHyf9CtIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcRTgJchPC7iRMdQroFKFAsncA3SIv7hc+I6qyGCxY7qvrkZ+mNjcAzzGO5Wx5ftWvWd1sBuzQAgp/pF5Ane+Z3/TaCq6lWXWU8xurry7u5jPNEOVex8fZdULC4yYyhsTLXgia2b76Fed9/4RR87pAO14uoJCwcfiLRGaFqML5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VG2rUqdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VG2rUqdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCDAC2BCAF;
	Tue, 10 Mar 2026 11:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141970;
	bh=0Cm+rfsYwmtSGR21m1f5DOfCNaKOTLvXwAXHyf9CtIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VG2rUqdEZgfez64EsLe6xQYKx2fVV1A/Fvn6lxQLViDYfKZ35K2MIwMIDODmZ2ZjN
	 tZxS7b2ew/YJ3dHPEDYvDxXALN4DdU7nPKlGrzOB8XWiWvSkf/VDGEHV4+KhGvcSwS
	 DKIdoSJF9EwjbKDOyDTHPTdBnyRRz/sKE4IIjm9tMICbnhWr8CNl+0H4zQ6owe9FXr
	 yvbfknoPDqFeo0dg6eHvItuyVw5IEG5r/Q7gXtSAH9kWiuvR0ynYsiueSEgigsut0S
	 R5fxAo89ujcPhpalf8XQgDjtMzakiAShxG2+56W2z758AO3mpG+XfGiq5817qqaaPc
	 uM65EwCn8dA9Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/314] unwind: Implement compat fp unwind
Date: Tue, 10 Mar 2026 07:15:54 -0400
Message-ID: <fe4d1bbe16f175b8ba4d2e1b401caeabf9795584.1773141555.git.sashal@kernel.org>
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

[ Upstream commit c79dd946e370af3537edb854f210cba3a94b4516 ]

It is important to be able to unwind compat tasks too.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20250924080119.613695709@infradead.org
Stable-dep-of: d55c571e4333 ("x86/uprobes: Fix XOL allocation failure for 32-bit tasks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/unwind_user_types.h |  1 +
 kernel/unwind/user.c              | 40 ++++++++++++++++++++++---------
 2 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h
index a449f15be8902..938f7e6233327 100644
--- a/include/linux/unwind_user_types.h
+++ b/include/linux/unwind_user_types.h
@@ -36,6 +36,7 @@ struct unwind_user_state {
 	unsigned long				ip;
 	unsigned long				sp;
 	unsigned long				fp;
+	unsigned int				ws;
 	enum unwind_user_type			current_type;
 	unsigned int				available_types;
 	bool					done;
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index 9dcde797b5d93..642871527a132 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -8,19 +8,32 @@
 #include <linux/unwind_user.h>
 #include <linux/uaccess.h>
 
-static const struct unwind_user_frame fp_frame = {
-	ARCH_INIT_USER_FP_FRAME
-};
-
 #define for_each_user_frame(state) \
 	for (unwind_user_start(state); !(state)->done; unwind_user_next(state))
 
+static inline int
+get_user_word(unsigned long *word, unsigned long base, int off, unsigned int ws)
+{
+	unsigned long __user *addr = (void __user *)base + off;
+#ifdef CONFIG_COMPAT
+	if (ws == sizeof(int)) {
+		unsigned int data;
+		int ret = get_user(data, (unsigned int __user *)addr);
+		*word = data;
+		return ret;
+	}
+#endif
+	return get_user(*word, addr);
+}
+
 static int unwind_user_next_fp(struct unwind_user_state *state)
 {
-	const struct unwind_user_frame *frame = &fp_frame;
+	const struct unwind_user_frame frame = {
+		ARCH_INIT_USER_FP_FRAME(state->ws)
+	};
 	unsigned long cfa, fp, ra;
 
-	if (frame->use_fp) {
+	if (frame.use_fp) {
 		if (state->fp < state->sp)
 			return -EINVAL;
 		cfa = state->fp;
@@ -29,26 +42,26 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
 	}
 
 	/* Get the Canonical Frame Address (CFA) */
-	cfa += frame->cfa_off;
+	cfa += frame.cfa_off;
 
 	/* stack going in wrong direction? */
 	if (cfa <= state->sp)
 		return -EINVAL;
 
 	/* Make sure that the address is word aligned */
-	if (cfa & (sizeof(long) - 1))
+	if (cfa & (state->ws - 1))
 		return -EINVAL;
 
 	/* Find the Return Address (RA) */
-	if (get_user(ra, (unsigned long *)(cfa + frame->ra_off)))
+	if (get_user_word(&ra, cfa, frame.ra_off, state->ws))
 		return -EINVAL;
 
-	if (frame->fp_off && get_user(fp, (unsigned long __user *)(cfa + frame->fp_off)))
+	if (frame.fp_off && get_user_word(&fp, cfa, frame.fp_off, state->ws))
 		return -EINVAL;
 
 	state->ip = ra;
 	state->sp = cfa;
-	if (frame->fp_off)
+	if (frame.fp_off)
 		state->fp = fp;
 	return 0;
 }
@@ -100,6 +113,11 @@ static int unwind_user_start(struct unwind_user_state *state)
 	state->ip = instruction_pointer(regs);
 	state->sp = user_stack_pointer(regs);
 	state->fp = frame_pointer(regs);
+	state->ws = unwind_user_word_size(regs);
+	if (!state->ws) {
+		state->done = true;
+		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.51.0

