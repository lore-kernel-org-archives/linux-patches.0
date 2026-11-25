Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618130;
	b=q3+rrQ9WMGCy0bYwj3X3JmGr9pfkM8VSDtxD2/YFu+o+K5GKT8ly58z09CGEsknU6gvN
	 So7oUfJqyPdlZWq8sTwOiVSNw1gKGoMXfgdUUUcA4Fa7N6OvQReMWk84jMw2gvwWUDGgw
	 lGf70rP1TAkDOJqboFWbpEuuVrfV2HXacXij0xi6m2H1IfjxSf391B+/rDun8HJzd7hlz
	 1a87Lh7X91w413dXRqvLzTCleTSlu8GXFVitedJ7fUuULB8+xjWBVFmUre8mFsB8i4uZB
	 9Wnq64RHg6WJmagNb6Vsh7kG3RuE6etNKAo4aSz/llqcgaRvjugqupaav/osXDTS0KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SrBvaaicH8frQAib6PVKUhNebOfyrp1XuM+L3xR25kw=;
	b=tAECn5QUmQC4CrZn3RLu2DQeCkmtYUMDSqJZM0LHTPDeHESt7CK/FSO/yk7MXnWt8EmB
	 zWSJt1vXcmvUkT12om+jGmIw704fF6g8xzpIH9C32nV4K4pWJ3IW9kQxMozzELOl2pGRX
	 TMA1hiMVrS+Y7SFfDvKXv86zfvOl4LDjJCNUERiZPU5NKA+rgOI1GniChH0iyg8Svaasj
	 4bXfg5KvbiXeIjXitRr20K2ZOaAqEJUkEhukMkcRsHKEJKBR28yrinrpMvyLDsDE/PTR6
	 eDoghYpu6M5RJmn2V2LgWKNrVdx5J9RHTpL26w0NvI7aYw9fNRrgH/Be9ftXDODViMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=05cc6t33;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CD5606A32C;
	Wed, 25 Nov 2026 14:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=05cc6t33
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C691F000C6;
	Wed, 25 Nov 2026 14:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618130;
	bh=SrBvaaicH8frQAib6PVKUhNebOfyrp1XuM+L3xR25kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=05cc6t333f39yqmsvX6xp12V8rH7YBJNuSpv94CRWGqRQEHuGuWp8NGzcEchUbpw4
	 oFfV+MuBwjzDmEB61ZxqIcr34U1ungzgV487vMusc+D2Th8gLeXMpALRFLMHTeqxig
	 lRc9MvsWGjw2V/1cWfA7Bhie6LwIXesDy6u0acnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0183/1005] bpf: Dont trust pointers spilled in slots that a callee can write
Date: Wed, 25 Nov 2026 15:25:21 +0100
Message-ID: <20261125143826.028506918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit cdefba74b53fb9b482355ebde1654800aea45dae ]

arg_track follows pointers to the stack through registers and spills.
Scalar evolution and the removal of dead slots rely on it to know which
slots an insn reads and writes.

arg_track assumes that a call does not change the pointers that are spilled
in the frame of the caller. But a static subprog or a callback can store
a pointer to other memory there, and the caller can use it:

  *(u64 *)(r10 - 16) = fp-8
  r1 = fp-16, r2 = map_value
  call sub                        ; *(u64 *)(r1 + 0) = r2
  r7 = *(u64 *)(r10 - 16)         ; verifier: map_value. arg_track: fp-8
  *(u64 *)(r10 - 8) = fp-24
  *(u64 *)(r7 + 0) = 0            ; arg_track: fp-8 is overwritten
  r8 = *(u64 *)(r10 - 8)          ; verifier: fp-24. arg_track: none
  loop:
    r1 = *(u64 *)(r10 - 24)       ; the counter of the loop
    ...
    *(u64 *)(r8 + 0) = 4096       ; arg_track: not a write to fp-24

Scalar evolution does not see the last store. It gives the counter the
range of a loop that only increments it. The prog loads, and it accesses
a map value out of bounds.

Valid progs are rejected as well. The store through r7 makes fp-8 dead, and
a later read of fp-8 fails with "slot poisoned by dead code elimination".

When a static subprog or a callback can get a pointer to the frame of its
caller, join every slot of that frame with "not a pointer to the stack".
Reads and possible writes through a filled pointer are still seen, but no
store through it is a certain write. It has to be every slot: the callee
reaches the whole frame from one pointer, and callees are analyzed after
the caller. The price is precision: an 8-byte load through a filled
pointer gives a value that can point to any frame.

For a spilled copy of r10 this needs "bpf: Fix the join of fp+0 with
a value that is not a pointer to stack".

In selftests, Cilium and sched_ext the stack marks change in 4 of 12522
progs. Verdicts, insns and states do not change in any prog.

one_fp_clear_stack_threshold and two_fp_clear_stack_threshold expect the
fake offset fp+0 in the log now.

Fixes: bf0c571f7feb ("bpf: introduce forward arg-tracking dataflow analysis")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261102055913.3598414-4-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/liveness.c                         | 52 ++++++++++++++-----
 .../selftests/bpf/progs/verifier_live_stack.c | 12 +++--
 2 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/kernel/bpf/liveness.c b/kernel/bpf/liveness.c
index b01cdabaf3bf5..8980e2aa25738 100644
--- a/kernel/bpf/liveness.c
+++ b/kernel/bpf/liveness.c
@@ -1282,6 +1282,31 @@ static struct arg_track arg_track_deref(struct bpf_verifier_env *env, struct bpf
 	return (struct arg_track){ .frame = ARG_NONE };
 }
 
+/*
+ * True if the call at @insn_idx can pass a pointer to the frame at @depth to a static subprog
+ * or to a callback. They use it as a pointer to stack, a global subprog gets plain memory.
+ * It errs on the safe side: it looks at all argument registers and stack args, also at those
+ * that this callee doesn't take.
+ */
+static bool subprog_gets_local_fp(struct bpf_verifier_env *env, struct bpf_insn *insn, int insn_idx,
+				  struct arg_track *at, int depth)
+{
+	int r;
+
+	if (bpf_pseudo_call(insn)) {
+		r = bpf_find_subprog(env, insn_idx + insn->imm + 1);
+		if (r >= 0 && bpf_subprog_is_global(env, r))
+			return false;
+	} else if (!bpf_is_callx(insn) && !bpf_calls_callback(env, insn_idx)) {
+		return false;
+	}
+	/* R1-R5 and stack args */
+	for (r = BPF_REG_1; r < MAX_AT_TRACK_REGS; r++)
+		if ((r <= BPF_REG_5 || r >= MAX_BPF_REG) && can_be_local_fp(depth, r, &at[r]))
+			return true;
+	return false;
+}
+
 /*
  * Pure dataflow transfer function for arg_track state.
  * Updates at_out[] based on how the instruction modifies registers.
@@ -1345,21 +1370,22 @@ static void arg_track_xfer(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		*dst = none;
 	} else if (class == BPF_JMP && code == BPF_CALL) {
 		/*
-		 * at_stack_out[slot] is not cleared by the helper and subprog calls.
-		 * The fill_from_stack() may return the stale spill — which is an FP-derived arg_track
-		 * (the value that was originally spilled there). The loaded register then carries
-		 * a phantom FP-derived identity that doesn't correspond to what's actually in the slot.
-		 * This phantom FP pointer propagates forward, and wherever it's subsequently used
-		 * (as a helper argument, another store, etc.), it sets stack liveness bits.
-		 * Those bits correspond to stack accesses that don't actually happen.
-		 * So the effect is over-reporting stack liveness — marking slots as live that aren't
-		 * actually accessed. The verifier preserves more state than necessary across calls,
-		 * which is conservative.
+		 * Helpers, kfuncs and global subprogs can scratch stack slots. The verifier reads
+		 * a scalar from a scratched slot, but at_stack_out[slot] is not cleared, and
+		 * fill_from_stack() returns the stale spill: an FP-derived arg_track for a scalar.
+		 * A scalar can't be dereferenced, so the stale value can only set liveness bits
+		 * for stack accesses that don't happen. That is conservative.
 		 *
-		 * helpers can scratch stack slots, but they won't make a valid pointer out of it.
-		 * subprogs are allowed to write into parent slots, but they cannot write
-		 * _any_ FP-derived pointer into it (either their own or parent's FP).
+		 * Static subprogs and callbacks can't store an FP-derived pointer into the frame of
+		 * the caller, but they can store any other pointer there. The caller can fill it
+		 * and store through it. With the stale spill that store would be a definite write
+		 * to a stack slot, and it doesn't touch the stack. Callees are analyzed after the
+		 * caller, and they reach the whole frame from one pointer to it. So after the call
+		 * every slot holds what it held before or a value that is not FP-derived.
 		 */
+		if (subprog_gets_local_fp(env, insn, insn_idx, at_out, depth))
+			for (slot = 0; slot < nslots; slot++)
+				at_stack_out[slot] = __arg_track_join(at_stack_out[slot], none);
 		for (r = BPF_REG_0; r <= BPF_REG_5; r++)
 			at_out[r] = none;
 	} else if (class == BPF_LDX) {
diff --git a/tools/testing/selftests/bpf/progs/verifier_live_stack.c b/tools/testing/selftests/bpf/progs/verifier_live_stack.c
index 401152b2b64fc..ec2f25df3d4da 100644
--- a/tools/testing/selftests/bpf/progs/verifier_live_stack.c
+++ b/tools/testing/selftests/bpf/progs/verifier_live_stack.c
@@ -1763,11 +1763,15 @@ static __used __naked void grandchild_deref(void)
 	::: __clobber_all);
 }
 
+/*
+ * The callee gets a pointer to the frame that holds the spills. It can store a pointer
+ * that is not FP-derived over them: after the call each of them is "fp-N or not FP-derived".
+ */
 SEC("socket")
 __log_level(2)
 __success
-__msg("14: (79) r1 = *(u64 *)(r10 -8) // r6=fp0-8 r7=fp1-16 fp-8=fp1-16 fp-16=fp0-8")
-__msg("15: (79) r0 = *(u64 *)(r1 +0) // r1=fp1-16 r6=fp0-8 r7=fp1-16 fp-8=fp1-16 fp-16=fp0-8")
+__msg("14: (79) r1 = *(u64 *)(r10 -8) // r6=fp0-8 r7=fp1-16 fp-8=fp1-16|fp1+0 fp-16=fp0-8|fp0+0")
+__msg("15: (79) r0 = *(u64 *)(r1 +0) // r1=fp1-16|fp1+0 r6=fp0-8 r7=fp1-16 fp-8=fp1-16|fp1+0")
 __msg("stack use/def subprog#1 mid_two_fp_threshold (d1,cs2):")
 __msg("14: (79) r1 = *(u64 *)(r10 -8)        ; use: fp1-8")
 __msg("15: (79) r0 = *(u64 *)(r1 +0)         ; use: fp1-16")
@@ -1812,8 +1816,8 @@ static __used __naked void inner_nop_fptest(void)
 SEC("socket")
 __log_level(2)
 __success
-__msg("13: (79) r1 = *(u64 *)(r10 -8) // r6=fp0-8 r7=fp1-16 fp-8=fp1-16 fp-16=fp0-8")
-__msg("14: (79) r0 = *(u64 *)(r1 +0) // r1=fp1-16 r6=fp0-8 r7=fp1-16 fp-8=fp1-16 fp-16=fp0-8")
+__msg("13: (79) r1 = *(u64 *)(r10 -8) // r6=fp0-8 r7=fp1-16 fp-8=fp1-16|fp1+0 fp-16=fp0-8|fp0+0")
+__msg("14: (79) r0 = *(u64 *)(r1 +0) // r1=fp1-16|fp1+0 r6=fp0-8 r7=fp1-16 fp-8=fp1-16|fp1+0")
 __msg("stack use/def subprog#1 mid_one_fp_threshold (d1,cs2):")
 __msg("13: (79) r1 = *(u64 *)(r10 -8)        ; use: fp1-8")
 __msg("14: (79) r0 = *(u64 *)(r1 +0)         ; use: fp1-16")
-- 
2.53.0



