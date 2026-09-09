Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F79580394;
	Wed,  9 Sep 2026 14:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963240; cv=none; b=jZkKNKQOfX3OToMTWu7qULr2Ur3498hky6g4n8Jn8VAC08ZWi3Rwi512INeuQ6V0Z2B9w/7M4qR7ZJu95AfiqZHUcJDotCLKGuE1SEqO9gv38L2tLBWHINpGrGK7ZyKRCr/aQTTWp2RyE8y85V6oHXZ4DUigX7mFwjnxZREoy4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963240; c=relaxed/simple;
	bh=kR3p4wa4xVtZwfrVBbo0C6uktxaWQnkKuD/pI14uNIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/5BOHf3A+SSA37CYsT0Jy8tujOvorBMfkMfdJLUMOfmyKboFU5fsjuVYAQ2U7cBqymKESq0BS1b8Jv8mSb0YswV0Ovc5YFlMXG4dTP1SGgbnVSUaV4jzSBecWkcJ/wPcSNQmx+dLwglbDPq1sZjABg8ze8yBLp9gHnc6G9BA88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7OCkB2u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7OCkB2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E53C1F00A3D;
	Wed,  9 Sep 2026 14:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963238;
	bh=S8i2gnL73prV/5fMeKG6fBT02CDv4AMC7AZ8+s1m38w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J7OCkB2uQONbfGEn7ZpSP5RY4XIDWJFtDb0Maf9BtSTqaKmb0x35KH4OxEhRv6k17
	 MAVSeZBTEkx3FGeKxNiJg7UVtuEZpzRrSc2YTj1w4kb+k+Klfa39bAnH9CdaVcXjz4
	 Q74Eplkv6Oi4cDjSiICqBkJ/ycCjPTHtg4ekwDkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 6.18 011/583] bpf: fix the return value of push_stack
Date: Wed,  9 Sep 2026 15:34:56 +0200
Message-ID: <20260909134238.190089570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Anton Protopopov <a.s.protopopov@gmail.com>

commit 6ea5fc92a0fc1cde976cb701db2c1dba4dcab7cf upstream.

In [1] Eduard mentioned that on push_stack failure verifier code
should return -ENOMEM instead of -EFAULT. After checking with the
other call sites I've found that code randomly returns either -ENOMEM
or -EFAULT. This patch unifies the return values for the push_stack
(and similar push_async_cb) functions such that error codes are
always assigned properly.

  [1] https://lore.kernel.org/bpf/20250615085943.3871208-1-a.s.protopopov@gmail.com

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20251019202145.3944697-2-a.s.protopopov@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ Ajay: Modified to apply on v6.18 ]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   81 +++++++++++++++++++++++++-------------------------
 1 file changed, 41 insertions(+), 40 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2117,7 +2117,7 @@ static struct bpf_verifier_state *push_s
 
 	elem = kzalloc(sizeof(struct bpf_verifier_stack_elem), GFP_KERNEL_ACCOUNT);
 	if (!elem)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	elem->insn_idx = insn_idx;
 	elem->prev_insn_idx = prev_insn_idx;
@@ -2127,12 +2127,12 @@ static struct bpf_verifier_state *push_s
 	env->stack_size++;
 	err = copy_verifier_state(&elem->st, cur);
 	if (err)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	elem->st.speculative |= speculative;
 	if (env->stack_size > BPF_COMPLEXITY_LIMIT_JMP_SEQ) {
 		verbose(env, "The sequence of %d jumps is too complex.\n",
 			env->stack_size);
-		return NULL;
+		return ERR_PTR(-E2BIG);
 	}
 	if (elem->st.parent) {
 		++elem->st.parent->branches;
@@ -2981,7 +2981,7 @@ static struct bpf_verifier_state *push_a
 
 	elem = kzalloc(sizeof(struct bpf_verifier_stack_elem), GFP_KERNEL_ACCOUNT);
 	if (!elem)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	elem->insn_idx = insn_idx;
 	elem->prev_insn_idx = prev_insn_idx;
@@ -2993,7 +2993,7 @@ static struct bpf_verifier_state *push_a
 		verbose(env,
 			"The sequence of %d jumps is too complex for async cb.\n",
 			env->stack_size);
-		return NULL;
+		return ERR_PTR(-E2BIG);
 	}
 	/* Unlike push_stack() do not copy_verifier_state().
 	 * The caller state doesn't matter.
@@ -3004,7 +3004,7 @@ static struct bpf_verifier_state *push_a
 	elem->st.in_sleepable = is_sleepable;
 	frame = kzalloc(sizeof(*frame), GFP_KERNEL_ACCOUNT);
 	if (!frame)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	init_func_state(env, frame,
 			BPF_MAIN_FUNC /* callsite */,
 			0 /* frameno within this callchain */,
@@ -9137,8 +9137,8 @@ static int process_iter_next_call(struct
 		prev_st = find_prev_entry(env, cur_st->parent, insn_idx);
 		/* branch out active iter state */
 		queued_st = push_stack(env, insn_idx + 1, insn_idx, false);
-		if (!queued_st)
-			return -ENOMEM;
+		if (IS_ERR(queued_st))
+			return PTR_ERR(queued_st);
 
 		queued_iter = get_iter_from_state(queued_st, meta);
 		queued_iter->iter.state = BPF_ITER_STATE_ACTIVE;
@@ -10708,8 +10708,8 @@ static int push_callback_call(struct bpf
 		async_cb = push_async_cb(env, env->subprog_info[subprog].start,
 					 insn_idx, subprog,
 					 is_async_cb_sleepable(env, insn));
-		if (!async_cb)
-			return -EFAULT;
+		if (IS_ERR(async_cb))
+			return PTR_ERR(async_cb);
 		callee = async_cb->frame[0];
 		callee->async_entry_cnt = caller->async_entry_cnt + 1;
 
@@ -10725,8 +10725,8 @@ static int push_callback_call(struct bpf
 	 * proceed with next instruction within current frame.
 	 */
 	callback_state = push_stack(env, env->subprog_info[subprog].start, insn_idx, false);
-	if (!callback_state)
-		return -ENOMEM;
+	if (IS_ERR(callback_state))
+		return PTR_ERR(callback_state);
 
 	err = setup_func_entry(env, subprog, insn_idx, set_callee_state_cb,
 			       callback_state);
@@ -13979,9 +13979,9 @@ static int check_kfunc_call(struct bpf_v
 		struct bpf_reg_state *regs;
 
 		branch = push_stack(env, env->insn_idx + 1, env->insn_idx, false);
-		if (!branch) {
+		if (IS_ERR(branch)) {
 			verbose(env, "failed to push state for failed lock acquisition\n");
-			return -ENOMEM;
+			return PTR_ERR(branch);
 		}
 
 		regs = branch->frame[branch->curframe]->regs;
@@ -14447,16 +14447,15 @@ struct bpf_sanitize_info {
 	bool mask_to_left;
 };
 
-static struct bpf_verifier_state *
-sanitize_speculative_path(struct bpf_verifier_env *env,
-			  const struct bpf_insn *insn,
-			  u32 next_idx, u32 curr_idx)
+static int sanitize_speculative_path(struct bpf_verifier_env *env,
+				     const struct bpf_insn *insn,
+				     u32 next_idx, u32 curr_idx)
 {
 	struct bpf_verifier_state *branch;
 	struct bpf_reg_state *regs;
 
 	branch = push_stack(env, next_idx, curr_idx, true);
-	if (branch && insn) {
+	if (!IS_ERR(branch) && insn) {
 		regs = branch->frame[branch->curframe]->regs;
 		if (BPF_SRC(insn->code) == BPF_K) {
 			mark_reg_unknown(env, regs, insn->dst_reg);
@@ -14465,7 +14464,7 @@ sanitize_speculative_path(struct bpf_ver
 			mark_reg_unknown(env, regs, insn->src_reg);
 		}
 	}
-	return branch;
+	return PTR_ERR_OR_ZERO(branch);
 }
 
 static int sanitize_ptr_alu(struct bpf_verifier_env *env,
@@ -14484,7 +14483,6 @@ static int sanitize_ptr_alu(struct bpf_v
 	u8 opcode = BPF_OP(insn->code);
 	u32 alu_state, alu_limit;
 	struct bpf_reg_state tmp;
-	bool ret;
 	int err;
 
 	if (can_skip_alu_sanitation(env, insn))
@@ -14557,11 +14555,12 @@ do_sim:
 		tmp = *dst_reg;
 		copy_register_state(dst_reg, ptr_reg);
 	}
-	ret = sanitize_speculative_path(env, NULL, env->insn_idx + 1,
-					env->insn_idx);
-	if (!ptr_is_dst_reg && ret)
+	err = sanitize_speculative_path(env, NULL, env->insn_idx + 1, env->insn_idx);
+	if (err < 0)
+		return REASON_STACK;
+	if (!ptr_is_dst_reg)
 		*dst_reg = tmp;
-	return !ret ? REASON_STACK : 0;
+	return 0;
 }
 
 static void sanitize_mark_insn_seen(struct bpf_verifier_env *env)
@@ -17029,8 +17028,8 @@ static int check_cond_jmp_op(struct bpf_
 
 		/* branch out 'fallthrough' insn as a new state to explore */
 		queued_st = push_stack(env, idx + 1, idx, false);
-		if (!queued_st)
-			return -ENOMEM;
+		if (IS_ERR(queued_st))
+			return PTR_ERR(queued_st);
 
 		queued_st->may_goto_depth++;
 		if (prev_st)
@@ -17108,10 +17107,11 @@ static int check_cond_jmp_op(struct bpf_
 		 * the fall-through branch for simulation under speculative
 		 * execution.
 		 */
-		if (!env->bypass_spec_v1 &&
-		    !sanitize_speculative_path(env, insn, *insn_idx + 1,
-					       *insn_idx))
-			return -EFAULT;
+		if (!env->bypass_spec_v1) {
+			err = sanitize_speculative_path(env, insn, *insn_idx + 1, *insn_idx);
+			if (err < 0)
+				return err;
+		}
 		if (env->log.level & BPF_LOG_LEVEL)
 			print_insn_state(env, this_branch, this_branch->curframe);
 		*insn_idx += insn->off;
@@ -17121,11 +17121,12 @@ static int check_cond_jmp_op(struct bpf_
 		 * program will go. If needed, push the goto branch for
 		 * simulation under speculative execution.
 		 */
-		if (!env->bypass_spec_v1 &&
-		    !sanitize_speculative_path(env, insn,
-					       *insn_idx + insn->off + 1,
-					       *insn_idx))
-			return -EFAULT;
+		if (!env->bypass_spec_v1) {
+			err = sanitize_speculative_path(env, insn, *insn_idx + insn->off + 1,
+							*insn_idx);
+			if (err < 0)
+				return err;
+		}
 		if (env->log.level & BPF_LOG_LEVEL)
 			print_insn_state(env, this_branch, this_branch->curframe);
 		return 0;
@@ -17148,8 +17149,8 @@ static int check_cond_jmp_op(struct bpf_
 
 	other_branch = push_stack(env, *insn_idx + insn->off + 1, *insn_idx,
 				  false);
-	if (!other_branch)
-		return -EFAULT;
+	if (IS_ERR(other_branch))
+		return PTR_ERR(other_branch);
 	other_branch_regs = other_branch->frame[other_branch->curframe]->regs;
 
 	if (BPF_SRC(insn->code) == BPF_X) {
@@ -17448,8 +17449,8 @@ static int check_ld_abs(struct bpf_verif
 
 		mark_reg_scratched(env, BPF_REG_0);
 		branch = push_stack(env, env->insn_idx + 1, env->insn_idx, false);
-		if (!branch)
-			return -EFAULT;
+		if (IS_ERR(branch))
+			return PTR_ERR(branch);
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		err = prepare_func_exit(env, &env->insn_idx);
 		if (err)


