Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356BD15EA9D;
	Mon, 29 Jan 2024 17:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548527; cv=none; b=SskfujiM3xvUBc+G5sda3KpNibrQCvF8UIZfcS9azfHVQeDCO3j4uHgxRzO0a/DF5BNPQ+faSa53YC7IaJCioEX/q9TO0rTAyau/dcwe/be3OOYuBctWjcwN53hNH4f5Vs+kOdf1SjBnUIZ4cKXisvl2niNAzV1jDa186upANKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548527; c=relaxed/simple;
	bh=VIfTFORpaL4SOBc/lKQ6ASfOjTP245YDtZxk0Y+g3AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWCN6N1+sdyc2C7m9m9zjb1x4a2eM2NSkN/0Ai2yXQV7QfHuQQIzNyBpOSf+qhssyu8I40tOpizPd+bdj0qZe7H1VfQbOAhp4I1aOxTzu6dRzpyx7iBi3XGKWXyY/o9bFcLwDbIX7aNrOwF/hmjXH+CPDxAYEPdMpGl/KRY22I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=helQRkZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="helQRkZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B8FC43390;
	Mon, 29 Jan 2024 17:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548527;
	bh=VIfTFORpaL4SOBc/lKQ6ASfOjTP245YDtZxk0Y+g3AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=helQRkZ56ZMy9v3Q1GFyMZG/JPNWUpk93hKCyKd2+Vy38HeCxMFdqf+aCbtCXAWnO
	 4ThOckvPWzSWaUXsQSIxN4OBjP5olZA6VN5n5O/vkn7f/KCULXxmnZivTkjinxChHE
	 f3qqKursxnMxYk4m/mLHwPcpzooKvDI6E+I8Hffs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 161/331] bpf: keep track of max number of bpf_loop callback iterations
Date: Mon, 29 Jan 2024 09:03:45 -0800
Message-ID: <20240129170019.643107935@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

commit bb124da69c47dd98d69361ec13244ece50bec63e upstream.

In some cases verifier can't infer convergence of the bpf_loop()
iteration. E.g. for the following program:

    static int cb(__u32 idx, struct num_context* ctx)
    {
        ctx->i++;
        return 0;
    }

    SEC("?raw_tp")
    int prog(void *_)
    {
        struct num_context ctx = { .i = 0 };
        __u8 choice_arr[2] = { 0, 1 };

        bpf_loop(2, cb, &ctx, 0);
        return choice_arr[ctx.i];
    }

Each 'cb' simulation would eventually return to 'prog' and reach
'return choice_arr[ctx.i]' statement. At which point ctx.i would be
marked precise, thus forcing verifier to track multitude of separate
states with {.i=0}, {.i=1}, ... at bpf_loop() callback entry.

This commit allows "brute force" handling for such cases by limiting
number of callback body simulations using 'umax' value of the first
bpf_loop() parameter.

For this, extend bpf_func_state with 'callback_depth' field.
Increment this field when callback visiting state is pushed to states
traversal stack. For frame #N it's 'callback_depth' field counts how
many times callback with frame depth N+1 had been executed.
Use bpf_func_state specifically to allow independent tracking of
callback depths when multiple nested bpf_loop() calls are present.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20231121020701.26440-11-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf_verifier.h                                   |   11 +++
 kernel/bpf/verifier.c                                          |   19 ++++-
 tools/testing/selftests/bpf/progs/verifier_subprog_precision.c |   35 +++++++---
 3 files changed, 53 insertions(+), 12 deletions(-)

--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -300,6 +300,17 @@ struct bpf_func_state {
 	bool in_callback_fn;
 	struct tnum callback_ret_range;
 	bool in_async_callback_fn;
+	/* For callback calling functions that limit number of possible
+	 * callback executions (e.g. bpf_loop) keeps track of current
+	 * simulated iteration number.
+	 * Value in frame N refers to number of times callback with frame
+	 * N+1 was simulated, e.g. for the following call:
+	 *
+	 *   bpf_loop(..., fn, ...); | suppose current frame is N
+	 *                           | fn would be simulated in frame N+1
+	 *                           | number of simulations is tracked in frame N
+	 */
+	u32 callback_depth;
 
 	/* The following fields should be last. See copy_func_state() */
 	int acquired_refs;
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9301,6 +9301,8 @@ static int push_callback_call(struct bpf
 		return err;
 
 	callback_state->callback_unroll_depth++;
+	callback_state->frame[callback_state->curframe - 1]->callback_depth++;
+	caller->callback_depth = 0;
 	return 0;
 }
 
@@ -10090,8 +10092,21 @@ static int check_helper_call(struct bpf_
 		break;
 	case BPF_FUNC_loop:
 		update_loop_inline_state(env, meta.subprogno);
-		err = push_callback_call(env, insn, insn_idx, meta.subprogno,
-					 set_loop_callback_state);
+		/* Verifier relies on R1 value to determine if bpf_loop() iteration
+		 * is finished, thus mark it precise.
+		 */
+		err = mark_chain_precision(env, BPF_REG_1);
+		if (err)
+			return err;
+		if (cur_func(env)->callback_depth < regs[BPF_REG_1].umax_value) {
+			err = push_callback_call(env, insn, insn_idx, meta.subprogno,
+						 set_loop_callback_state);
+		} else {
+			cur_func(env)->callback_depth = 0;
+			if (env->log.level & BPF_LOG_LEVEL2)
+				verbose(env, "frame%d bpf_loop iteration limit reached\n",
+					env->cur_state->curframe);
+		}
 		break;
 	case BPF_FUNC_dynptr_from_mem:
 		if (regs[BPF_REG_1].type != PTR_TO_MAP_VALUE) {
--- a/tools/testing/selftests/bpf/progs/verifier_subprog_precision.c
+++ b/tools/testing/selftests/bpf/progs/verifier_subprog_precision.c
@@ -119,7 +119,23 @@ __naked int global_subprog_result_precis
 
 SEC("?raw_tp")
 __success __log_level(2)
-/* First simulated path does not include callback body */
+/* First simulated path does not include callback body,
+ * r1 and r4 are always precise for bpf_loop() calls.
+ */
+__msg("9: (85) call bpf_loop#181")
+__msg("mark_precise: frame0: last_idx 9 first_idx 9 subseq_idx -1")
+__msg("mark_precise: frame0: parent state regs=r4 stack=:")
+__msg("mark_precise: frame0: last_idx 8 first_idx 0 subseq_idx 9")
+__msg("mark_precise: frame0: regs=r4 stack= before 8: (b7) r4 = 0")
+__msg("mark_precise: frame0: last_idx 9 first_idx 9 subseq_idx -1")
+__msg("mark_precise: frame0: parent state regs=r1 stack=:")
+__msg("mark_precise: frame0: last_idx 8 first_idx 0 subseq_idx 9")
+__msg("mark_precise: frame0: regs=r1 stack= before 8: (b7) r4 = 0")
+__msg("mark_precise: frame0: regs=r1 stack= before 7: (b7) r3 = 0")
+__msg("mark_precise: frame0: regs=r1 stack= before 6: (bf) r2 = r8")
+__msg("mark_precise: frame0: regs=r1 stack= before 5: (bf) r1 = r6")
+__msg("mark_precise: frame0: regs=r6 stack= before 4: (b7) r6 = 3")
+/* r6 precision propagation */
 __msg("14: (0f) r1 += r6")
 __msg("mark_precise: frame0: last_idx 14 first_idx 9")
 __msg("mark_precise: frame0: regs=r6 stack= before 13: (bf) r1 = r7")
@@ -134,10 +150,9 @@ __msg("17: (b7) r0 = 0")
 __msg("18: (95) exit")
 __msg("returning from callee:")
 __msg("to caller at 9:")
-/* r4 (flags) is always precise for bpf_loop() */
-__msg("frame 0: propagating r4")
+__msg("frame 0: propagating r1,r4")
 __msg("mark_precise: frame0: last_idx 9 first_idx 9 subseq_idx -1")
-__msg("mark_precise: frame0: regs=r4 stack= before 18: (95) exit")
+__msg("mark_precise: frame0: regs=r1,r4 stack= before 18: (95) exit")
 __msg("from 18 to 9: safe")
 __naked int callback_result_precise(void)
 {
@@ -264,12 +279,12 @@ __msg("15: (b7) r0 = 0")
 __msg("16: (95) exit")
 __msg("returning from callee:")
 __msg("to caller at 9:")
-/* r4 (flags) is always precise for bpf_loop(),
+/* r1, r4 are always precise for bpf_loop(),
  * r6 was marked before backtracking to callback body.
  */
-__msg("frame 0: propagating r4,r6")
+__msg("frame 0: propagating r1,r4,r6")
 __msg("mark_precise: frame0: last_idx 9 first_idx 9 subseq_idx -1")
-__msg("mark_precise: frame0: regs=r4,r6 stack= before 16: (95) exit")
+__msg("mark_precise: frame0: regs=r1,r4,r6 stack= before 16: (95) exit")
 __msg("mark_precise: frame1: regs= stack= before 15: (b7) r0 = 0")
 __msg("mark_precise: frame1: regs= stack= before 9: (85) call bpf_loop")
 __msg("mark_precise: frame0: parent state regs= stack=:")
@@ -422,12 +437,12 @@ __msg("17: (b7) r0 = 0")
 __msg("18: (95) exit")
 __msg("returning from callee:")
 __msg("to caller at 10:")
-/* r4 (flags) is always precise for bpf_loop(),
+/* r1, r4 are always precise for bpf_loop(),
  * fp-8 was marked before backtracking to callback body.
  */
-__msg("frame 0: propagating r4,fp-8")
+__msg("frame 0: propagating r1,r4,fp-8")
 __msg("mark_precise: frame0: last_idx 10 first_idx 10 subseq_idx -1")
-__msg("mark_precise: frame0: regs=r4 stack=-8 before 18: (95) exit")
+__msg("mark_precise: frame0: regs=r1,r4 stack=-8 before 18: (95) exit")
 __msg("mark_precise: frame1: regs= stack= before 17: (b7) r0 = 0")
 __msg("mark_precise: frame1: regs= stack= before 10: (85) call bpf_loop#181")
 __msg("mark_precise: frame0: parent state regs= stack=:")


