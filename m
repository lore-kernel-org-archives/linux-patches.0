Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57E236F401;
	Tue, 10 Mar 2026 11:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141305; cv=none; b=Giyd9yZoiOK/4DxNYrQ24PK/QaWnvxPS+BQRAJulrk++Eal9Bq3J/IDd7T/gEmHYnnMFMQkqBe8WVjHb2PEWQ9I64WnVlSbKHQYS/x6nS5K3w39bE9dlAW2kMyqNU++ZvZygeMGn6MnMxdbql/we5/6tpjrmW1pPvNtUSDyru1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141305; c=relaxed/simple;
	bh=H1ukzgr+0b4M4ynK4ohDjI/X5TWjXMNmS7hvgi30Dy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H2fVPgnFMmp/Ja5DzmaCeyl2kP8vDUmTzcUkdZZ+mI5ngaBQXXSOiuWkbBFNm+d9sICG7TYuqWVcyv/tGU4KCym8HUP0yufdRfPuYTFGtLR5QEGaPedxpKbBxmX7THaNwjZbU471sKQoB7Yzu4RED7AZc3ViOQXjkQe7ksYf1Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JjV7UOCt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JjV7UOCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F61C2BC86;
	Tue, 10 Mar 2026 11:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141305;
	bh=H1ukzgr+0b4M4ynK4ohDjI/X5TWjXMNmS7hvgi30Dy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjV7UOCtHD/Zuj+bEHDzVVeil8WRbWJhyu90Jfpsa/IZSANuuc3+5VFXPa+Obf/d2
	 BVeV8QHKKVFY362ALs5Su8d7el9qrDuH+JzNWFtNy8BbVDxNBWqid9HOKuFc3elwuR
	 hw7tB5d8GXcNa27IIZwx5fSJjuVdBVkaXi+3uOIwaJW/6jX6w2mir10VpkjuRj/MHg
	 7VZFU25oYXIjIBfgopVozBvpVh8bC5Nzz779NP/2odR80k0fT6nq4+CoU3dt/gVdVr
	 bmoOgCoVRiS27hycDXP9l+EVm0qVBeLpRuJwPD5HPZQ7333M69ssJegr8QvCYuJ772
	 bA6HSE2yEICFg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eduard Zingerman <eddyz87@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 310/311] bpf: collect only live registers in linked regs
Date: Tue, 10 Mar 2026 07:05:57 -0400
Message-ID: <45681bfa336f18eccd665a591e22912d8d681bd4.1773140656.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 2658a1720a1944fbaeda937000ad2b3c3dfaf1bb ]

Fix an inconsistency between func_states_equal() and
collect_linked_regs():
- regsafe() uses check_ids() to verify that cached and current states
  have identical register id mapping.
- func_states_equal() calls regsafe() only for registers computed as
  live by compute_live_registers().
- clean_live_states() is supposed to remove dead registers from cached
  states, but it can skip states belonging to an iterator-based loop.
- collect_linked_regs() collects all registers sharing the same id,
  ignoring the marks computed by compute_live_registers().
  Linked registers are stored in the state's jump history.
- backtrack_insn() marks all linked registers for an instruction
  as precise whenever one of the linked registers is precise.

The above might lead to a scenario:
- There is an instruction I with register rY known to be dead at I.
- Instruction I is reached via two paths: first A, then B.
- On path A:
  - There is an id link between registers rX and rY.
  - Checkpoint C is created at I.
  - Linked register set {rX, rY} is saved to the jump history.
  - rX is marked as precise at I, causing both rX and rY
    to be marked precise at C.
- On path B:
  - There is no id link between registers rX and rY,
    otherwise register states are sub-states of those in C.
  - Because rY is dead at I, check_ids() returns true.
  - Current state is considered equal to checkpoint C,
    propagate_precision() propagates spurious precision
    mark for register rY along the path B.
  - Depending on a program, this might hit verifier_bug()
    in the backtrack_insn(), e.g. if rY ∈  [r1..r5]
    and backtrack_insn() spots a function call.

The reproducer program is in the next patch.
This was hit by sched_ext scx_lavd scheduler code.

Changes in tests:
- verifier_scalar_ids.c selftests need modification to preserve
  some registers as live for __msg() checks.
- exceptions_assert.c adjusted to match changes in the verifier log,
  R0 is dead after conditional instruction and thus does not get
  range.
- precise.c adjusted to match changes in the verifier log, register r9
  is dead after comparison and it's range is not important for test.

Reported-by: Emil Tsalapatis <emil@etsalapatis.com>
Fixes: 0fb3cf6110a5 ("bpf: use register liveness information for func_states_equal")
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260306-linked-regs-and-propagate-precision-v1-1-18e859be570d@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c                         | 13 ++++-
 .../selftests/bpf/progs/exceptions_assert.c   | 34 +++++------
 .../selftests/bpf/progs/verifier_scalar_ids.c | 56 ++++++++++++++-----
 .../testing/selftests/bpf/verifier/precise.c  |  8 +--
 4 files changed, 73 insertions(+), 38 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c3b58f5d062b0..b594a065b83c4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16895,17 +16895,24 @@ static void __collect_linked_regs(struct linked_regs *reg_set, struct bpf_reg_st
  * in verifier state, save R in linked_regs if R->id == id.
  * If there are too many Rs sharing same id, reset id for leftover Rs.
  */
-static void collect_linked_regs(struct bpf_verifier_state *vstate, u32 id,
+static void collect_linked_regs(struct bpf_verifier_env *env,
+				struct bpf_verifier_state *vstate,
+				u32 id,
 				struct linked_regs *linked_regs)
 {
+	struct bpf_insn_aux_data *aux = env->insn_aux_data;
 	struct bpf_func_state *func;
 	struct bpf_reg_state *reg;
+	u16 live_regs;
 	int i, j;
 
 	id = id & ~BPF_ADD_CONST;
 	for (i = vstate->curframe; i >= 0; i--) {
+		live_regs = aux[frame_insn_idx(vstate, i)].live_regs_before;
 		func = vstate->frame[i];
 		for (j = 0; j < BPF_REG_FP; j++) {
+			if (!(live_regs & BIT(j)))
+				continue;
 			reg = &func->regs[j];
 			__collect_linked_regs(linked_regs, reg, id, i, j, true);
 		}
@@ -17113,9 +17120,9 @@ static int check_cond_jmp_op(struct bpf_verifier_env *env,
 	 * if parent state is created.
 	 */
 	if (BPF_SRC(insn->code) == BPF_X && src_reg->type == SCALAR_VALUE && src_reg->id)
-		collect_linked_regs(this_branch, src_reg->id, &linked_regs);
+		collect_linked_regs(env, this_branch, src_reg->id, &linked_regs);
 	if (dst_reg->type == SCALAR_VALUE && dst_reg->id)
-		collect_linked_regs(this_branch, dst_reg->id, &linked_regs);
+		collect_linked_regs(env, this_branch, dst_reg->id, &linked_regs);
 	if (linked_regs.cnt > 1) {
 		err = push_jmp_history(env, this_branch, 0, linked_regs_pack(&linked_regs));
 		if (err)
diff --git a/tools/testing/selftests/bpf/progs/exceptions_assert.c b/tools/testing/selftests/bpf/progs/exceptions_assert.c
index a01c2736890f9..858af5988a38a 100644
--- a/tools/testing/selftests/bpf/progs/exceptions_assert.c
+++ b/tools/testing/selftests/bpf/progs/exceptions_assert.c
@@ -18,43 +18,43 @@
 		return *(u64 *)num;					\
 	}
 
-__msg(": R0=0xffffffff80000000")
+__msg("R{{.}}=0xffffffff80000000")
 check_assert(s64, ==, eq_int_min, INT_MIN);
-__msg(": R0=0x7fffffff")
+__msg("R{{.}}=0x7fffffff")
 check_assert(s64, ==, eq_int_max, INT_MAX);
-__msg(": R0=0")
+__msg("R{{.}}=0")
 check_assert(s64, ==, eq_zero, 0);
-__msg(": R0=0x8000000000000000 R1=0x8000000000000000")
+__msg("R{{.}}=0x8000000000000000")
 check_assert(s64, ==, eq_llong_min, LLONG_MIN);
-__msg(": R0=0x7fffffffffffffff R1=0x7fffffffffffffff")
+__msg("R{{.}}=0x7fffffffffffffff")
 check_assert(s64, ==, eq_llong_max, LLONG_MAX);
 
-__msg(": R0=scalar(id=1,smax=0x7ffffffe)")
+__msg("R{{.}}=scalar(id=1,smax=0x7ffffffe)")
 check_assert(s64, <, lt_pos, INT_MAX);
-__msg(": R0=scalar(id=1,smax=-1,umin=0x8000000000000000,var_off=(0x8000000000000000; 0x7fffffffffffffff))")
+__msg("R{{.}}=scalar(id=1,smax=-1,umin=0x8000000000000000,var_off=(0x8000000000000000; 0x7fffffffffffffff))")
 check_assert(s64, <, lt_zero, 0);
-__msg(": R0=scalar(id=1,smax=0xffffffff7fffffff")
+__msg("R{{.}}=scalar(id=1,smax=0xffffffff7fffffff")
 check_assert(s64, <, lt_neg, INT_MIN);
 
-__msg(": R0=scalar(id=1,smax=0x7fffffff)")
+__msg("R{{.}}=scalar(id=1,smax=0x7fffffff)")
 check_assert(s64, <=, le_pos, INT_MAX);
-__msg(": R0=scalar(id=1,smax=0)")
+__msg("R{{.}}=scalar(id=1,smax=0)")
 check_assert(s64, <=, le_zero, 0);
-__msg(": R0=scalar(id=1,smax=0xffffffff80000000")
+__msg("R{{.}}=scalar(id=1,smax=0xffffffff80000000")
 check_assert(s64, <=, le_neg, INT_MIN);
 
-__msg(": R0=scalar(id=1,smin=umin=0x80000000,umax=0x7fffffffffffffff,var_off=(0x0; 0x7fffffffffffffff))")
+__msg("R{{.}}=scalar(id=1,smin=umin=0x80000000,umax=0x7fffffffffffffff,var_off=(0x0; 0x7fffffffffffffff))")
 check_assert(s64, >, gt_pos, INT_MAX);
-__msg(": R0=scalar(id=1,smin=umin=1,umax=0x7fffffffffffffff,var_off=(0x0; 0x7fffffffffffffff))")
+__msg("R{{.}}=scalar(id=1,smin=umin=1,umax=0x7fffffffffffffff,var_off=(0x0; 0x7fffffffffffffff))")
 check_assert(s64, >, gt_zero, 0);
-__msg(": R0=scalar(id=1,smin=0xffffffff80000001")
+__msg("R{{.}}=scalar(id=1,smin=0xffffffff80000001")
 check_assert(s64, >, gt_neg, INT_MIN);
 
-__msg(": R0=scalar(id=1,smin=umin=0x7fffffff,umax=0x7fffffffffffffff,var_off=(0x0; 0x7fffffffffffffff))")
+__msg("R{{.}}=scalar(id=1,smin=umin=0x7fffffff,umax=0x7fffffffffffffff,var_off=(0x0; 0x7fffffffffffffff))")
 check_assert(s64, >=, ge_pos, INT_MAX);
-__msg(": R0=scalar(id=1,smin=0,umax=0x7fffffffffffffff,var_off=(0x0; 0x7fffffffffffffff))")
+__msg("R{{.}}=scalar(id=1,smin=0,umax=0x7fffffffffffffff,var_off=(0x0; 0x7fffffffffffffff))")
 check_assert(s64, >=, ge_zero, 0);
-__msg(": R0=scalar(id=1,smin=0xffffffff80000000")
+__msg("R{{.}}=scalar(id=1,smin=0xffffffff80000000")
 check_assert(s64, >=, ge_neg, INT_MIN);
 
 SEC("?tc")
diff --git a/tools/testing/selftests/bpf/progs/verifier_scalar_ids.c b/tools/testing/selftests/bpf/progs/verifier_scalar_ids.c
index c0ce690ddb68a..1fdd85b4b8443 100644
--- a/tools/testing/selftests/bpf/progs/verifier_scalar_ids.c
+++ b/tools/testing/selftests/bpf/progs/verifier_scalar_ids.c
@@ -40,6 +40,9 @@ __naked void linked_regs_bpf_k(void)
 	 */
 	"r3 = r10;"
 	"r3 += r0;"
+	/* Mark r1 and r2 as alive. */
+	"r1 = r1;"
+	"r2 = r2;"
 	"r0 = 0;"
 	"exit;"
 	:
@@ -73,6 +76,9 @@ __naked void linked_regs_bpf_x_src(void)
 	 */
 	"r4 = r10;"
 	"r4 += r0;"
+	/* Mark r1 and r2 as alive. */
+	"r1 = r1;"
+	"r2 = r2;"
 	"r0 = 0;"
 	"exit;"
 	:
@@ -106,6 +112,10 @@ __naked void linked_regs_bpf_x_dst(void)
 	 */
 	"r4 = r10;"
 	"r4 += r3;"
+	/* Mark r1 and r2 as alive. */
+	"r0 = r0;"
+	"r1 = r1;"
+	"r2 = r2;"
 	"r0 = 0;"
 	"exit;"
 	:
@@ -143,6 +153,9 @@ __naked void linked_regs_broken_link(void)
 	 */
 	"r3 = r10;"
 	"r3 += r0;"
+	/* Mark r1 and r2 as alive. */
+	"r1 = r1;"
+	"r2 = r2;"
 	"r0 = 0;"
 	"exit;"
 	:
@@ -156,16 +169,16 @@ __naked void linked_regs_broken_link(void)
  */
 SEC("socket")
 __success __log_level(2)
-__msg("12: (0f) r2 += r1")
+__msg("17: (0f) r2 += r1")
 /* Current state */
-__msg("frame2: last_idx 12 first_idx 11 subseq_idx -1 ")
-__msg("frame2: regs=r1 stack= before 11: (bf) r2 = r10")
+__msg("frame2: last_idx 17 first_idx 14 subseq_idx -1 ")
+__msg("frame2: regs=r1 stack= before 16: (bf) r2 = r10")
 __msg("frame2: parent state regs=r1 stack=")
 __msg("frame1: parent state regs= stack=")
 __msg("frame0: parent state regs= stack=")
 /* Parent state */
-__msg("frame2: last_idx 10 first_idx 10 subseq_idx 11 ")
-__msg("frame2: regs=r1 stack= before 10: (25) if r1 > 0x7 goto pc+0")
+__msg("frame2: last_idx 13 first_idx 13 subseq_idx 14 ")
+__msg("frame2: regs=r1 stack= before 13: (25) if r1 > 0x7 goto pc+0")
 __msg("frame2: parent state regs=r1 stack=")
 /* frame1.r{6,7} are marked because mark_precise_scalar_ids()
  * looks for all registers with frame2.r1.id in the current state
@@ -173,20 +186,20 @@ __msg("frame2: parent state regs=r1 stack=")
 __msg("frame1: parent state regs=r6,r7 stack=")
 __msg("frame0: parent state regs=r6 stack=")
 /* Parent state */
-__msg("frame2: last_idx 8 first_idx 8 subseq_idx 10")
-__msg("frame2: regs=r1 stack= before 8: (85) call pc+1")
+__msg("frame2: last_idx 9 first_idx 9 subseq_idx 13")
+__msg("frame2: regs=r1 stack= before 9: (85) call pc+3")
 /* frame1.r1 is marked because of backtracking of call instruction */
 __msg("frame1: parent state regs=r1,r6,r7 stack=")
 __msg("frame0: parent state regs=r6 stack=")
 /* Parent state */
-__msg("frame1: last_idx 7 first_idx 6 subseq_idx 8")
-__msg("frame1: regs=r1,r6,r7 stack= before 7: (bf) r7 = r1")
-__msg("frame1: regs=r1,r6 stack= before 6: (bf) r6 = r1")
+__msg("frame1: last_idx 8 first_idx 7 subseq_idx 9")
+__msg("frame1: regs=r1,r6,r7 stack= before 8: (bf) r7 = r1")
+__msg("frame1: regs=r1,r6 stack= before 7: (bf) r6 = r1")
 __msg("frame1: parent state regs=r1 stack=")
 __msg("frame0: parent state regs=r6 stack=")
 /* Parent state */
-__msg("frame1: last_idx 4 first_idx 4 subseq_idx 6")
-__msg("frame1: regs=r1 stack= before 4: (85) call pc+1")
+__msg("frame1: last_idx 4 first_idx 4 subseq_idx 7")
+__msg("frame1: regs=r1 stack= before 4: (85) call pc+2")
 __msg("frame0: parent state regs=r1,r6 stack=")
 /* Parent state */
 __msg("frame0: last_idx 3 first_idx 1 subseq_idx 4")
@@ -204,6 +217,7 @@ __naked void precision_many_frames(void)
 	"r1 = r0;"
 	"r6 = r0;"
 	"call precision_many_frames__foo;"
+	"r6 = r6;" /* mark r6 as live */
 	"exit;"
 	:
 	: __imm(bpf_ktime_get_ns)
@@ -220,6 +234,8 @@ void precision_many_frames__foo(void)
 	"r6 = r1;"
 	"r7 = r1;"
 	"call precision_many_frames__bar;"
+	"r6 = r6;" /* mark r6 as live */
+	"r7 = r7;" /* mark r7 as live */
 	"exit"
 	::: __clobber_all);
 }
@@ -229,6 +245,8 @@ void precision_many_frames__bar(void)
 {
 	asm volatile (
 	"if r1 > 7 goto +0;"
+	"r6 = 0;" /* mark r6 as live */
+	"r7 = 0;" /* mark r7 as live */
 	/* force r1 to be precise, this eventually marks:
 	 * - bar frame r1
 	 * - foo frame r{1,6,7}
@@ -340,6 +358,8 @@ __naked void precision_two_ids(void)
 	"r3 += r7;"
 	/* force r9 to be precise, this also marks r8 */
 	"r3 += r9;"
+	"r6 = r6;" /* mark r6 as live */
+	"r8 = r8;" /* mark r8 as live */
 	"exit;"
 	:
 	: __imm(bpf_ktime_get_ns)
@@ -353,7 +373,7 @@ __flag(BPF_F_TEST_STATE_FREQ)
  * collect_linked_regs() can't tie more than 6 registers for a single insn.
  */
 __msg("8: (25) if r0 > 0x7 goto pc+0         ; R0=scalar(id=1")
-__msg("9: (bf) r6 = r6                       ; R6=scalar(id=2")
+__msg("14: (bf) r6 = r6                      ; R6=scalar(id=2")
 /* check that r{0-5} are marked precise after 'if' */
 __msg("frame0: regs=r0 stack= before 8: (25) if r0 > 0x7 goto pc+0")
 __msg("frame0: parent state regs=r0,r1,r2,r3,r4,r5 stack=:")
@@ -372,6 +392,12 @@ __naked void linked_regs_too_many_regs(void)
 	"r6 = r0;"
 	/* propagate range for r{0-6} */
 	"if r0 > 7 goto +0;"
+	/* keep r{1-5} live */
+	"r1 = r1;"
+	"r2 = r2;"
+	"r3 = r3;"
+	"r4 = r4;"
+	"r5 = r5;"
 	/* make r6 appear in the log */
 	"r6 = r6;"
 	/* force r0 to be precise,
@@ -517,7 +543,7 @@ __naked void check_ids_in_regsafe_2(void)
 	"*(u64*)(r10 - 8) = r1;"
 	/* r9 = pointer to stack */
 	"r9 = r10;"
-	"r9 += -8;"
+	"r9 += -16;"
 	/* r8 = ktime_get_ns() */
 	"call %[bpf_ktime_get_ns];"
 	"r8 = r0;"
@@ -538,6 +564,8 @@ __naked void check_ids_in_regsafe_2(void)
 	"if r7 > 4 goto l2_%=;"
 	/* Access memory at r9[r6] */
 	"r9 += r6;"
+	"r9 += r7;"
+	"r9 += r8;"
 	"r0 = *(u8*)(r9 + 0);"
 "l2_%=:"
 	"r0 = 0;"
diff --git a/tools/testing/selftests/bpf/verifier/precise.c b/tools/testing/selftests/bpf/verifier/precise.c
index 59a020c356474..ef3ec56672c22 100644
--- a/tools/testing/selftests/bpf/verifier/precise.c
+++ b/tools/testing/selftests/bpf/verifier/precise.c
@@ -44,9 +44,9 @@
 	mark_precise: frame0: regs=r2 stack= before 23\
 	mark_precise: frame0: regs=r2 stack= before 22\
 	mark_precise: frame0: regs=r2 stack= before 20\
-	mark_precise: frame0: parent state regs=r2,r9 stack=:\
+	mark_precise: frame0: parent state regs=r2 stack=:\
 	mark_precise: frame0: last_idx 19 first_idx 10\
-	mark_precise: frame0: regs=r2,r9 stack= before 19\
+	mark_precise: frame0: regs=r2 stack= before 19\
 	mark_precise: frame0: regs=r9 stack= before 18\
 	mark_precise: frame0: regs=r8,r9 stack= before 17\
 	mark_precise: frame0: regs=r0,r9 stack= before 15\
@@ -107,9 +107,9 @@
 	mark_precise: frame0: parent state regs=r2 stack=:\
 	mark_precise: frame0: last_idx 20 first_idx 20\
 	mark_precise: frame0: regs=r2 stack= before 20\
-	mark_precise: frame0: parent state regs=r2,r9 stack=:\
+	mark_precise: frame0: parent state regs=r2 stack=:\
 	mark_precise: frame0: last_idx 19 first_idx 17\
-	mark_precise: frame0: regs=r2,r9 stack= before 19\
+	mark_precise: frame0: regs=r2 stack= before 19\
 	mark_precise: frame0: regs=r9 stack= before 18\
 	mark_precise: frame0: regs=r8,r9 stack= before 17\
 	mark_precise: frame0: parent state regs= stack=:",
-- 
2.51.0

