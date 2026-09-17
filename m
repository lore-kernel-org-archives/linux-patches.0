Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE10E4D4860;
	Thu, 17 Sep 2026 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659541; cv=none; b=FCs70qT3vvltcS/7OjV0cFe9PCBotw++lhznzpXI0WGNeAh3sUftHIkUayLp6+gjtpUZbJbXB43R7W001WIj4l0KmX9uQmdL5k39OfvkU5qzV1RAIoxg8rI0fpJ0rCN9C4JnBNWB5LlXphPFUimE/BzXZY9WuzyoLnHTs9A2ers=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659541; c=relaxed/simple;
	bh=2CKTzVlveIGkOEL/YPfrNi+wnQXbyB3rix0LREyBdR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3J6h+DPgABYvlNMqWKehlTSMIaHnSh3NPSsN7m83+1PxaO7K2TUzIVOWssweEaumKE/EZmy5ieYZOSH0fNxk1JdevUXGjx7NtPuvd7ufvGZ17+u2bF+s2c8eQOsPgSBaad3fM6otMe1UJLJPS3T9r6BHiuHfzKeE0pCfsnRQdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Otp3ZNYk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Otp3ZNYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CD61F0089C;
	Thu, 17 Sep 2026 15:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659531;
	bh=ii4L5gIjNHXnBgdpYfm50JLrf3DhVxULHLwfx+7O4s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Otp3ZNYk7EaFBO+qOeJAR+wQ6sz89jRgJ5hejhGaPwYcobRyrxScayY8UYQmrXMIf
	 cQM+R38FOPxuZiUb7U5cYJqRdwJl4IXy86n/ATOT4wl/u00e+Jh2y6lxERS6Im0W+s
	 s8fyDBcI7t0QaVSwh3fjLRkoC3KYq5IgT1HzejXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 250/733] bpf: Check ancestor frames for rbtree callbacks
Date: Thu, 17 Sep 2026 16:09:18 +0100
Message-ID: <20260917151357.519364451@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 989d418da374c..9554eb6bd2016 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9756,9 +9756,10 @@ static void account_current_path(struct bpf_verifier_env *env)
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
@@ -9766,17 +9767,19 @@ static bool in_rbtree_lock_required_cb(struct bpf_verifier_env *env)
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
 
 static bool retval_range_within(struct bpf_retval_range range, const struct bpf_reg_state *reg)
-- 
2.53.0



