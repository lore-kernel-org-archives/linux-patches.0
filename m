Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDF3518148;
	Thu, 17 Sep 2026 17:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665785; cv=none; b=MVrG2HVnjRwSjXQoX3EMI2hUrQXV1Bc6HjRh1XSm3xH6qnie55FQPIEGypqs3xSQuat6nwXPfHWhd2I36TBZOnJ0KNebDd0+lLyi9ByKa2/jPWu0ERwgz0CA1Kf9QxLVriHeh2olCJYZJ7lUUCTMbteR4f/xks1PzYhSQ+Voq5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665785; c=relaxed/simple;
	bh=6U4EsymA1Bz9BruCJvdYxTs8FyIoHB21wEkHtWVqi/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfwZpZ9WnYEQG/BegecPejsQnWpq7OtqzWaYxfHqZSqKqdSCvGKuFrH7QoU6ZLfHdr/qLpAeBD47pEm6Rpfl2A7sxhKIwk0rEliynFH3xpricxb93/xuKDJNKzAKG96GRa92eSP0LZLSHjYRjmrIUqXKH14bJmHbBsgdb/wZcP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5JAxzHS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5JAxzHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B661F000FF;
	Thu, 17 Sep 2026 17:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665783;
	bh=SQ0U7KTNXEEoIm87PpeOeaYCq8JIbXj4HtUx8n4zoXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5JAxzHSvh5Ryv9kxtCVUolVI7jx+9lkn331/BHvEIAEQ27gKm2l3rWuj/xTqUUmF
	 MOLXTETNJEVtswfcC7CTSEEoc8DBB41f1MMnLV6lSKotELFWOzahslln2PjbX8+p8k
	 b2KyAYW3MdesymFs0yeU5tmngv4yBDTfKv8XFQFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0780/1250] bpf: Reject legacy packet loads from callbacks
Date: Thu, 17 Sep 2026 16:09:35 +0100
Message-ID: <20260917151613.033291906@linuxfoundation.org>
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

[ Upstream commit e7d28823c662128caae63f14e16bd394916c139b ]

check_ld_abs() models a failed BPF_LD_ABS or BPF_LD_IND in a
subprogram as an implicit return with R0 set to zero. It calls
prepare_func_exit() to explore this synthesized path.

When the load is reached directly from a synchronous callback,
prepare_func_exit() enforces the callback return contract and marks R0
precise. R0 is not derived from a real instruction on this path, so
precision backtracking reaches the callback call with R0 still requested
and triggers the "callback unexpected regs" verifier bug. A privileged
program loader can therefore cause a verifier warning and an -EFAULT
BPF_PROG_LOAD.

These legacy packet-load instructions are deprecated. Reject them from
callbacks rather than complicating their implicit-return model. Check all
active frames before constructing the implicit return so nested static
subprograms cannot hide the callback context.

Global functions are verified independently with a fresh frame zero, so
an active-frame check cannot identify a global function called from a
callback. Also check the complete subprogram call graph during stack-depth
validation and reject a function containing a legacy load when any caller
is a callback. This covers global and static descendants without making
has_ld_abs transitive, preserving its per-function BTF return-type check.
Ordinary uses outside callbacks remain supported.

Fixes: ee861486e377 ("bpf: Fix ld_{abs,ind} failure path analysis in subprogs")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/bpf/20260903152147.C0E241F00A3A@smtp.kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260903214758.2727663-8-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index dd215227c3b3a..46ab5178985a5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6657,6 +6657,15 @@ static int check_max_stack_depth_subprog(struct bpf_verifier_env *env, int idx,
 	if (!priv_stack_supported)
 		subprog[idx].priv_stack_mode = NO_PRIV_STACK;
 process_func:
+	if (subprog[idx].has_ld_abs) {
+		for (tmp = idx; tmp >= 0; tmp = dinfo[tmp].caller) {
+			if (subprog[tmp].is_cb) {
+				verbose(env, "cannot use BPF_LD_[ABS|IND] within callback\n");
+				return -EINVAL;
+			}
+		}
+	}
+
 	/* protect against potential stack overflow that might happen when
 	 * bpf2bpf calls get combined with tailcalls. Limit the caller's stack
 	 * depth for such case down to 256 so that the worst case scenario
@@ -17508,6 +17517,7 @@ static bool may_access_skb(enum bpf_prog_type type)
  */
 static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
 {
+	struct bpf_verifier_state *state = env->cur_state;
 	struct bpf_reg_state *regs = cur_regs(env);
 	static const int ctx_reg = BPF_REG_6;
 	u8 mode = BPF_MODE(insn->code);
@@ -17518,6 +17528,13 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
 		return -EINVAL;
 	}
 
+	for (i = state->curframe; i; i--) {
+		if (state->frame[i]->in_callback_fn) {
+			verbose(env, "cannot use BPF_LD_[ABS|IND] within callback\n");
+			return -EINVAL;
+		}
+	}
+
 	if (!env->ops->gen_ld_abs) {
 		verifier_bug(env, "gen_ld_abs is null");
 		return -EFAULT;
-- 
2.53.0



