Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5613BB9ED;
	Sat, 17 Oct 2026 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255459; cv=none; b=MSUtifweS99tJit418SEh5hkZnfqpVSTUtjGHLrb7JFuCwwn35hZyz9e/5CKHdRpcd/M5dXGbCiSlcyI+g8RGZ6X/yXBRFab5GhUk/4Y8bZwkD/qykv6ZgYQo3ac+W+SUo8pZXni5AXoM22fBKlP7OhTsooh1it5uQIbqTGLjvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255459; c=relaxed/simple;
	bh=isVreduTi7qfJ6xqt/yjclopYe9OZ3Q4HnXCx5EYlr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fts0m7BKKobdycfN7C7XTDSf+PjrwWAyfG7OELld9BTLLFUJyDUuy7VgOCBSknANiWrZO1uC08uPM1ivOJ4+eEDcT611wlSGARjYvHb2nekico6BT6VjZylFB11gq/l6wWkAG1v3BAI1zgpSIe+Ml4cyplci+t/m5Y8nH2p0Xi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXTRsd4k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXTRsd4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A6F1F000C4;
	Sat, 17 Oct 2026 16:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255458;
	bh=sx4LIi8Jzj4byJy7kmypjYh4SoEWFT2vKML3Ob5C4vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXTRsd4kZ+BbSczlkJ3AdS6d/J0BPFTnsvW2JOyQvFc/FypSzi/TOKDXsyMF34aC9
	 sermM4ov7iKXmTjWR+nhkBFIDXPNsN8atPjl0Y4rAGdnysKes9Ip4M+KPpfDzaRWtZ
	 DuRT54qzJp+IMt5RZq8SFmR5iSq0ik07vizrGsf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 782/869] bpf: Check ancestor frames for rbtree callbacks
Date: Sat, 17 Oct 2026 18:00:23 +0200
Message-ID: <20261017160056.964423854@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 369f4ce734570bdfedaa4b5ca50e2a3f6a892728 ]

bpf_rbtree_add() invokes its comparator while the caller holds the root
lock. The native insertion code retains raw parent and link pointers across
the callback, so the verifier prohibits unlocking, consuming tree nodes,
or changing RCU state from that callback.

in_rbtree_lock_required_cb() only checks the innermost verifier frame.
Static subprogram calls are permitted while holding a spin lock, and such a
call pushes a frame without in_callback_fn set. Consequently, all callback
restrictions disappear in the nested frame. The subprogram can unlock the
tree, remove and drop the node being compared, then relock. Native insertion
resumes with the stale parent pointer and links freed memory into the tree.

Walk all active frames for the rbtree callback instead. Benign static
subprograms remain permitted, while callback restrictions follow execution
into nested frames.

Fixes: a44b1334aadd ("bpf: Allow calling static subprogs while holding a bpf_spin_lock")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260903214758.2727663-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 424cf2b196f27..106547524c563 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10424,9 +10424,10 @@ static int set_rbtree_add_callback_state(struct bpf_verifier_env *env,
 
 static bool is_rbtree_lock_required_kfunc(u32 btf_id);
 
-/* Are we currently verifying the callback for a rbtree helper that must
- * be called with lock held? If so, no need to complain about unreleased
- * lock
+/*
+ * Are we currently verifying the callback for an rbtree kfunc that must
+ * be called with a lock held, or one of that callback's subprogs? If so,
+ * no need to complain about an unreleased lock.
  */
 static bool in_rbtree_lock_required_cb(struct bpf_verifier_env *env)
 {
@@ -10434,17 +10435,19 @@ static bool in_rbtree_lock_required_cb(struct bpf_verifier_env *env)
 	struct bpf_insn *insn = env->prog->insnsi;
 	struct bpf_func_state *callee;
 	int kfunc_btf_id;
+	u32 frame;
 
-	if (!state->curframe)
-		return false;
-
-	callee = state->frame[state->curframe];
+	for (frame = state->curframe; frame; frame--) {
+		callee = state->frame[frame];
+		if (!callee->in_callback_fn)
+			continue;
 
-	if (!callee->in_callback_fn)
-		return false;
+		kfunc_btf_id = insn[callee->callsite].imm;
+		if (is_rbtree_lock_required_kfunc(kfunc_btf_id))
+			return true;
+	}
 
-	kfunc_btf_id = insn[callee->callsite].imm;
-	return is_rbtree_lock_required_kfunc(kfunc_btf_id);
+	return false;
 }
 
 static bool retval_range_within(struct bpf_retval_range range, const struct bpf_reg_state *reg,
-- 
2.53.0



