Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80774ABBA1;
	Thu, 17 Sep 2026 17:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665775; cv=none; b=ucaV+l7Mi/MX9Cb8HgAZQunJrxBfI055FvIw5L5TREXeyKJd07twGTN+1SKUtjPN5oUc+bLR484JiZT//qxRWXQNJUYtrdIh4s1darW3cAZwyiMA/vEXIstUD0gl3G+S066+H/Gc8w5A6nPuFtbBnNT7ylyO6odQII/XYMtm6WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665775; c=relaxed/simple;
	bh=cjytxVAdnUTBRgSrvksaoAFYeYAwdOq8Ji+XU4osEFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H03t+11amhqKzy7akU34xMq3LacRxorkMN+QrbHhrgL7rUkOhJjZ4kPhAHlx+VliW5+DOUAqcScy+RGezx9MZtZNwkKDx0mA+wyyWhTa4KKGU0NiWoVndx3Qe4o+WiFlWhiUNOoWNsvLxh0QdTxkiy7ao/AUwLSO83wB5ts0BUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wilpOjcA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wilpOjcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FF21F000FF;
	Thu, 17 Sep 2026 17:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665774;
	bh=WoF4+5Yhw7irPwtGIs5OVHHGmT0ReAFLFw7Ie6/lCv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wilpOjcA+cb/fpwOBg6K5uvVZ51++wV+mB2hbzbo3MDd1cXtavyHHZTIFQiVfcwUi
	 L5XLXp0egAGMt0GQ8vJ243eTnlQHY+ARkaL5RglUXcKkZFxfv3HRFqnGyNBLNLt7cg
	 dX49+FaKfj3Bn4j/0IkwA3Y5LdAmjNlpt10ScODM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0777/1250] bpf: Check ancestor frames for rbtree callbacks
Date: Thu, 17 Sep 2026 16:09:32 +0100
Message-ID: <20260917151612.949696357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cd7aa64e5c258..dd215227c3b3a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11153,9 +11153,10 @@ static void account_current_path(struct bpf_verifier_env *env)
 					frame ? state->frame[frame - 1] : NULL);
 }
 
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
@@ -11163,17 +11164,19 @@ static bool in_rbtree_lock_required_cb(struct bpf_verifier_env *env)
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



