Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C003B14A2;
	Thu, 17 Sep 2026 17:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665766; cv=none; b=ZP7iLVB3FVRs3Mj/bpNNFkQraSKVs150GRZ409EkJEpN6Kk1XxFMP1Ph+yb1mDcN0osPqLqiMczCzW9mFj7VbaZJsoNAp8SJbtGhFWgtvS0jOv07MwmoLwkKtTzaJv7ry+ly8LlY7gGmvixHwbxniOE8fuv4wSo6LPMYtPlqFWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665766; c=relaxed/simple;
	bh=592m4Rpn5Mdgv/tO/tC8EW94ImslM6rfADb0A/Ffc+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGLWNGwLR16NOHAIiGxMn0QAPryAxcrn/l2Ja9nrLhXcL/auXvJjhI03CgEIyFFKNmefJjgyxtNtZi432Nt28Zrs67h2376yZLILwwC9OpT0OuEL+nHRYcrErnmEAoTfdqxnlapl1ngp9UzVTnZ2XidaKhBeh19TF/YX2SsGPO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkBADvlV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkBADvlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE84A1F000FF;
	Thu, 17 Sep 2026 17:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665765;
	bh=mfwy2ho8XNWyns/msMU+E0KTeDcIiaJp8Y7tEofca+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YkBADvlVMOOxKjj01atP51MtwIE2lgAwdBa3Ix/+gMthyo+pqOLZU4hdtBlOf+eWv
	 HKVBXrk/fHiJR9vUrqIWvZVtrpWbVL/kwBzLkSTNR/sYjGGyXuzsACmovjxzyMohbD
	 /hHN0+Lk8iYRls4zgtb4moDmAJfBSaocE1bZB/98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0776/1250] bpf: Track verifier instruction stats for each subprogram
Date: Thu, 17 Sep 2026 16:09:31 +0100
Message-ID: <20260917151612.919158953@linuxfoundation.org>
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
index 80136ecfa6cbc..e30f50c2fee74 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -305,6 +305,8 @@ struct bpf_func_state {
 	 *                           | number of simulations is tracked in frame N
 	 */
 	u32 callback_depth;
+	/* Instructions processed in this frame and callees on the current path. */
+	u32 insns_subtotal;
 
 	/* The following fields should be last. See copy_func_state() */
 	/* The state of the stack. Each element of the array describes BPF_REG_SIZE
@@ -648,7 +650,8 @@ struct bpf_subprog_info {
 	u32 postorder_start; /* The idx to the env->cfg.insn_postorder */
 	u16 stack_depth; /* max. stack depth used by this function */
 	u16 stack_extra;
-	u32 insn_processed;
+	u32 insns_total;
+	u32 insns_self;
 	/* offsets in range [stack_depth .. fastcall_stack_off)
 	 * are used for bpf_fastcall spills and fills.
 	 */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d1def3edb9d1e..cd7aa64e5c258 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1726,6 +1726,8 @@ static int copy_func_state(struct bpf_func_state *dst,
 			   const struct bpf_func_state *src)
 {
 	memcpy(dst, src, offsetof(struct bpf_func_state, stack));
+	/* Instruction accounting is path-local, not part of verifier state. */
+	dst->insns_subtotal = 0;
 	return copy_stack_state(dst, src);
 }
 
@@ -11115,6 +11117,42 @@ static int set_task_work_schedule_callback_state(struct bpf_verifier_env *env,
 
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
@@ -11216,6 +11254,7 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
 		verbose(env, "to caller at %d:\n", *insn_idx);
 		print_verifier_state(env, state, caller->frameno, true);
 	}
+	account_processed_insns(env, callee, caller);
 	/* clear everything in the callee. In case of exceptional exits using
 	 * bpf_throw, this will be done by copy_verifier_state for extra frames. */
 	free_func_state(callee);
@@ -20469,7 +20508,9 @@ static int do_check(struct bpf_verifier_env *env)
 		insn = &insns[env->insn_idx];
 		insn_aux = &env->insn_aux_data[env->insn_idx];
 
-		if (++env->insn_processed > BPF_COMPLEXITY_LIMIT_INSNS) {
+		account_processed_insn(env);
+
+		if (env->insn_processed > BPF_COMPLEXITY_LIMIT_INSNS) {
 			verbose(env,
 				"BPF program is too large. Processed %d insn\n",
 				env->insn_processed);
@@ -20594,6 +20635,7 @@ static int do_check(struct bpf_verifier_env *env)
 					    "speculation barrier after jump instruction may not have the desired effect"))
 				return -EFAULT;
 process_bpf_exit:
+			account_current_path(env);
 			mark_verifier_state_scratched(env);
 			err = update_branch_counts(env, env->cur_state);
 			if (err)
@@ -23748,6 +23790,7 @@ static int do_check_common(struct bpf_verifier_env *env, int subprog)
 
 	ret = do_check(env);
 out:
+	account_current_path(env);
 	if (!ret && pop_log)
 		bpf_vlog_reset(&env->log, 0);
 	free_states(env);
@@ -23779,7 +23822,6 @@ static int do_check_subprogs(struct bpf_verifier_env *env)
 	struct bpf_prog_aux *aux = env->prog->aux;
 	struct bpf_func_info_aux *sub_aux;
 	int i, ret, new_cnt;
-	u32 insn_processed;
 
 	if (!aux->func_info)
 		return 0;
@@ -23794,8 +23836,6 @@ static int do_check_subprogs(struct bpf_verifier_env *env)
 		if (!bpf_subprog_is_global(env, i))
 			continue;
 
-		insn_processed = env->insn_processed;
-
 		sub_aux = subprog_aux(env, i);
 		if (!sub_aux->called || sub_aux->verified)
 			continue;
@@ -23803,7 +23843,6 @@ static int do_check_subprogs(struct bpf_verifier_env *env)
 		env->insn_idx = env->subprog_info[i].start;
 		WARN_ON_ONCE(env->insn_idx == 0);
 		ret = do_check_common(env, i);
-		env->subprog_info[i].insn_processed = env->insn_processed - insn_processed;
 		if (ret) {
 			return ret;
 		} else if (env->log.level & BPF_LOG_LEVEL) {
@@ -23830,12 +23869,10 @@ static int do_check_subprogs(struct bpf_verifier_env *env)
 
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
@@ -23854,10 +23891,10 @@ static void print_verification_stats(struct bpf_verifier_env *env)
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



