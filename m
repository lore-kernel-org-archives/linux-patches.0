Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE92B55409F;
	Thu, 17 Sep 2026 15:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659532; cv=none; b=RIw3P2itYnh6SL6JPZX6U+ZJRBEdmGz+uAdnXoj3e/SqGJdgw+uqs2eEflDDskhbdl3IX54/LsiD1HGsBgJUgUI9Qlofj7pp8r5FAc0cJSaMJZJDTh0NmT1ZmxrpqIkbkG+T8oENu/ReApcJ4dfAwmGiRyCpjPf/oXaWK9E11Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659532; c=relaxed/simple;
	bh=xME4y/LXkOJE53fr/h4bxDmb0/rBg3YUCWBi4u65g0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQRp8ucAYLhxPleV2HCdXhmlwdPrcKGuq08A9Gp/Oymx44mDS0aQLTVrcstmZrM9WxvaJ2CeE3Jhld+QBxfFjmZfvat0yxe2lbbai+iV4tc8NL1GU4Z20V2UeVPZu1sa15EALHs/qtSPklBQipOv67QampL80/ZfBBT4Lu8oVQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=johCw4xn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="johCw4xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2B81F00899;
	Thu, 17 Sep 2026 15:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659528;
	bh=Fw+FwrSCYCc2BeYLHQkPUeMllTHS+xvVVXuNpF6AlYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=johCw4xn4VANIS6Qy38wAFUUtHhdKA/bh+l6glpphZJRrykgGCy+BDu+vfqWY534l
	 8pQD0q/OyEY3jyYQWT1QQ1oOrq5AA+0L9xWcGQN0ru94XS5cjPDaOZZVdbL0/zhsy6
	 xXgCwYU9CF1v0hOzXx7GLRUXVRWgJzt3VmPavIqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 249/733] bpf: Track verifier instruction stats for each subprogram
Date: Thu, 17 Sep 2026 16:09:17 +0100
Message-ID: <20260917151357.491908096@linuxfoundation.org>
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

[ Upstream commit 14c950ac2be8cadb63e1bfe22111ab0fdc829eb8 ]

The verifier currently records one instruction count for the main program
and each global subprogram checked independently. Static subprograms are
explored within callers, so their verification cost cannot be reported
separately.

Track both self and inclusive instruction counts for every subprogram.
Charge each processed instruction as self work to the current subprogram and
to a path-local subtotal in its function frame. When a function returns, add
the callee subtotal to its inclusive count and to its parent subtotal. Fold
any remaining frames when a path terminates or is pruned.

Instruction subtotals are accounting state, not semantic verifier state.
Clear them when a verifier state is copied so work before a path fork is
charged once, rather than again when a saved branch is explored. If copying
a saved state fails before all frames are allocated, skip missing frames
while folding the current path.

This generic frame accounting also records self and inclusive totals when an
asynchronous callback starts as a fresh frame-zero state. It does not yet
charge that independently explored callback path back to the main or global
exploration root which scheduled it. That will be done in subsequent
changes.

This does not change the verification statistics output format. It only
prepares the counters for per-subprogram reporting.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://patch.msgid.link/20260812221925.3358041-2-memxor@gmail.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Stable-dep-of: 369f4ce73457 ("bpf: Check ancestor frames for rbtree callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h |  5 +++-
 kernel/bpf/verifier.c        | 55 ++++++++++++++++++++++++++++++------
 2 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index ad7b8335ebc82..70a6133c5e7b0 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -385,6 +385,8 @@ struct bpf_func_state {
 	 *                           | number of simulations is tracked in frame N
 	 */
 	u32 callback_depth;
+	/* Instructions processed in this frame and callees on the current path. */
+	u32 insns_subtotal;
 
 	/* The following fields should be last. See copy_func_state() */
 	/* The state of the stack. Each element of the array describes BPF_REG_SIZE
@@ -805,7 +807,8 @@ struct bpf_subprog_info {
 	u32 exit_idx; /* Index of one of the BPF_EXIT instructions in this subprogram */
 	u16 stack_depth; /* max. stack depth used by this function */
 	u16 stack_extra;
-	u32 insn_processed;
+	u32 insns_total;
+	u32 insns_self;
 	/* offsets in range [stack_depth .. fastcall_stack_off)
 	 * are used for bpf_fastcall spills and fills.
 	 */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d1f6365e2a817..989d418da374c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1613,6 +1613,8 @@ static int copy_func_state(struct bpf_func_state *dst,
 			   const struct bpf_func_state *src)
 {
 	memcpy(dst, src, offsetof(struct bpf_func_state, stack));
+	/* Instruction accounting is path-local, not part of verifier state. */
+	dst->insns_subtotal = 0;
 	return copy_stack_state(dst, src);
 }
 
@@ -9718,6 +9720,42 @@ static int set_task_work_schedule_callback_state(struct bpf_verifier_env *env,
 
 static bool is_rbtree_lock_required_kfunc(u32 btf_id);
 
+static void account_processed_insn(struct bpf_verifier_env *env)
+{
+	struct bpf_func_state *frame = cur_func(env);
+
+	env->insn_processed++;
+	frame->insns_subtotal++;
+	env->subprog_info[frame->subprogno].insns_self++;
+}
+
+static void account_processed_insns(struct bpf_verifier_env *env,
+				    struct bpf_func_state *callee,
+				    struct bpf_func_state *caller)
+{
+	u32 insns;
+
+	if (!callee)
+		return;
+
+	insns = callee->insns_subtotal;
+
+	env->subprog_info[callee->subprogno].insns_total += insns;
+	if (caller)
+		caller->insns_subtotal += insns;
+	callee->insns_subtotal = 0;
+}
+
+static void account_current_path(struct bpf_verifier_env *env)
+{
+	struct bpf_verifier_state *state = env->cur_state;
+	int frame;
+
+	for (frame = state->curframe; frame >= 0; frame--)
+		account_processed_insns(env, state->frame[frame],
+					frame ? state->frame[frame - 1] : NULL);
+}
+
 /* Are we currently verifying the callback for a rbtree helper that must
  * be called with lock held? If so, no need to complain about unreleased
  * lock
@@ -9814,6 +9852,7 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 		verbose(env, "to caller at %d:\n", *insn_idx);
 		print_verifier_state(env, state, caller->frameno, true);
 	}
+	account_processed_insns(env, callee, caller);
 	/* clear everything in the callee. In case of exceptional exits using
 	 * bpf_throw, this will be done by copy_verifier_state for extra frames. */
 	free_func_state(callee);
@@ -17445,7 +17484,9 @@ static int do_check(struct bpf_verifier_env *env)
 		insn = &insns[env->insn_idx];
 		insn_aux = &env->insn_aux_data[env->insn_idx];
 
-		if (++env->insn_processed > BPF_COMPLEXITY_LIMIT_INSNS) {
+		account_processed_insn(env);
+
+		if (env->insn_processed > BPF_COMPLEXITY_LIMIT_INSNS) {
 			verbose(env,
 				"BPF program is too large. Processed %d insn\n",
 				env->insn_processed);
@@ -17585,6 +17626,7 @@ static int do_check(struct bpf_verifier_env *env)
 					    "speculation barrier after jump instruction may not have the desired effect"))
 				return -EFAULT;
 process_bpf_exit:
+			account_current_path(env);
 			mark_verifier_state_scratched(env);
 			err = bpf_update_branch_counts(env, env->cur_state);
 			if (err)
@@ -18579,6 +18621,7 @@ static int do_check_common(struct bpf_verifier_env *env, int subprog)
 
 	ret = do_check(env);
 out:
+	account_current_path(env);
 	if (!ret && pop_log)
 		bpf_vlog_reset(&env->log, 0);
 	free_states(env);
@@ -18610,7 +18653,6 @@ static int do_check_subprogs(struct bpf_verifier_env *env)
 	struct bpf_prog_aux *aux = env->prog->aux;
 	struct bpf_func_info_aux *sub_aux;
 	int i, ret, new_cnt;
-	u32 insn_processed;
 
 	if (!aux->func_info)
 		return 0;
@@ -18625,8 +18667,6 @@ static int do_check_subprogs(struct bpf_verifier_env *env)
 		if (!bpf_subprog_is_global(env, i))
 			continue;
 
-		insn_processed = env->insn_processed;
-
 		sub_aux = subprog_aux(env, i);
 		if (!sub_aux->called || sub_aux->verified)
 			continue;
@@ -18634,7 +18674,6 @@ static int do_check_subprogs(struct bpf_verifier_env *env)
 		env->insn_idx = env->subprog_info[i].start;
 		WARN_ON_ONCE(env->insn_idx == 0);
 		ret = do_check_common(env, i);
-		env->subprog_info[i].insn_processed = env->insn_processed - insn_processed;
 		if (ret) {
 			return ret;
 		} else if (env->log.level & BPF_LOG_LEVEL) {
@@ -18661,12 +18700,10 @@ static int do_check_subprogs(struct bpf_verifier_env *env)
 
 static int do_check_main(struct bpf_verifier_env *env)
 {
-	u32 insn_processed = env->insn_processed;
 	int ret;
 
 	env->insn_idx = 0;
 	ret = do_check_common(env, 0);
-	env->subprog_info[0].insn_processed = env->insn_processed - insn_processed;
 	if (!ret)
 		env->prog->aux->stack_depth = env->subprog_info[0].stack_depth;
 	return ret;
@@ -18685,10 +18722,10 @@ static void print_verification_stats(struct bpf_verifier_env *env)
 		for (i = 1; i < subprog_cnt; i++)
 			verbose(env, "+%d", env->subprog_info[i].stack_depth);
 		verbose(env, " max %d\n", env->max_stack_depth);
-		verbose(env, "insns processed %d", env->subprog_info[0].insn_processed);
+		verbose(env, "insns processed %d", env->subprog_info[0].insns_total);
 		for (i = 1; i < subprog_cnt; i++)
 			if (bpf_subprog_is_global(env, i))
-				verbose(env, "+%d", env->subprog_info[i].insn_processed);
+				verbose(env, "+%d", env->subprog_info[i].insns_total);
 		verbose(env, "\n");
 	}
 	verbose(env, "processed %d insns (limit %d) max_states_per_insn %d "
-- 
2.53.0



