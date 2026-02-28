Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C5E4A2E30
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300959; cv=none; b=kM97/q9MJif/xWvQecwyvQr/tfGItwMJAu8HD4FBeBltRN9epZdBZj2VZE2eM1VG4LEdcFdO5aEEzfluT/a48Hs6+Yf9PD/5EBMIJpKAnAzNp5CZNClgP5mmLDmAn6p7AtgY1FsUKp0jl/FN4sznAFm5o4X3DPCqxTr/M4cM3yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300959; c=relaxed/simple;
	bh=119vkDYbA2aov3eWe9asn1beBfWokDMi/0W7Y1RpUNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdnKIdIARS7XbSdzRbpPnVLl4hR55avnn7hpw7nbsLJQafbeHalPjhE8UCZcq2xtZer0f2njY8aEeOHsMhZbIjf1425gC8xnWMr2ssF69uNBXrmAX3P2UzpTJmb/5V9C/L/GlaZ/FgYtGZe56nmEgOlZs3KRkIfARXEXG1LmM+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YQb64zuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YQb64zuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7BAC19425;
	Sat, 28 Feb 2026 17:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300959;
	bh=119vkDYbA2aov3eWe9asn1beBfWokDMi/0W7Y1RpUNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQb64zuCug2SvCqmuxWaGC46Ou5Jo1sOhSLZVbgyUQTWhj1I1+jj099vV7b3IBEj1
	 7Q4qD+eKr6oIVelUKKAoSoYVuIr1Er9wJs+iRXuGpY4jUUmgFF7dDfZG+L7Y/3ztr4
	 zZRIIOiB7gYlDSWcJjlLILu5O8wL4Eb3mtFdPZb1TgfQCIrIKBbasE8s6d1sJFrDU4
	 WtzaZWRKvNFTJ4g/5FlgUzHUbWD7JJzYCAPhmJrBtdWOUuD9WqdNqmBBPWrscsKzTP
	 gi+OITLnVLSPEXr76l6hnmmdpxoFs8ifhECKpWZWWKGh+zEaebpdfLxnDL5I6bCmzp
	 fMrDCAaxselxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexei Starovoitov <ast@kernel.org>,
	Hao Sun <sunhao.th@gmail.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 083/752] bpf: Recognize special arithmetic shift in the verifier
Date: Sat, 28 Feb 2026 12:36:34 -0500
Message-ID: <20260228174750.1542406-83-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit bffacdb80b93b7b5e96b26fad64cc490a6c7d6c7 ]

cilium bpf_wiregard.bpf.c when compiled with -O1 fails to load
with the following verifier log:

192: (79) r2 = *(u64 *)(r10 -304)     ; R2=pkt(r=40) R10=fp0 fp-304=pkt(r=40)
...
227: (85) call bpf_skb_store_bytes#9          ; R0=scalar()
228: (bc) w2 = w0                     ; R0=scalar() R2=scalar(smin=0,smax=umax=0xffffffff,var_off=(0x0; 0xffffffff))
229: (c4) w2 s>>= 31                  ; R2=scalar(smin=0,smax=umax=0xffffffff,smin32=-1,smax32=0,var_off=(0x0; 0xffffffff))
230: (54) w2 &= -134                  ; R2=scalar(smin=0,smax=umax=umax32=0xffffff7a,smax32=0x7fffff7a,var_off=(0x0; 0xffffff7a))
...
232: (66) if w2 s> 0xffffffff goto pc+125     ; R2=scalar(smin=umin=umin32=0x80000000,smax=umax=umax32=0xffffff7a,smax32=-134,var_off=(0x80000000; 0x7fffff7a))
...
238: (79) r4 = *(u64 *)(r10 -304)     ; R4=scalar() R10=fp0 fp-304=scalar()
239: (56) if w2 != 0xffffff78 goto pc+210     ; R2=0xffffff78 // -136
...
258: (71) r1 = *(u8 *)(r4 +0)
R4 invalid mem access 'scalar'

The error might confuse most bpf authors, since fp-304 slot had 'pkt'
pointer at insn 192 and became 'scalar' at 238. That happened because
bpf_skb_store_bytes() clears all packet pointers including those in
the stack. On the first glance it might look like a bug in the source
code, since ctx->data pointer should have been reloaded after the call
to bpf_skb_store_bytes().

The relevant part of cilium source code looks like this:

// bpf/lib/nodeport.h
int dsr_set_ipip6()
{
	if (ctx_adjust_hroom(...))
		return DROP_INVALID; // -134
	if (ctx_store_bytes(...))
		return DROP_WRITE_ERROR; // -141
	return 0;
}

bool dsr_fail_needs_reply(int code)
{
	if (code == DROP_FRAG_NEEDED) // -136
		return true;
	return false;
}

tail_nodeport_ipv6_dsr()
{
	ret = dsr_set_ipip6(...);
	if (!IS_ERR(ret)) {
		...
	} else {
		if (dsr_fail_needs_reply(ret))
			return dsr_reply_icmp6(...);
	}
}

The code doesn't have arithmetic shift by 31 and it reloads ctx->data
every time it needs to access it. So it's not a bug in the source code.

The reason is DAGCombiner::foldSelectCCToShiftAnd() LLVM transformation:

  // If this is a select where the false operand is zero and the compare is a
  // check of the sign bit, see if we can perform the "gzip trick":
  // select_cc setlt X, 0, A, 0 -> and (sra X, size(X)-1), A
  // select_cc setgt X, 0, A, 0 -> and (not (sra X, size(X)-1)), A

The conditional branch in dsr_set_ipip6() and its return values
are optimized into BPF_ARSH plus BPF_AND:

227: (85) call bpf_skb_store_bytes#9
228: (bc) w2 = w0
229: (c4) w2 s>>= 31   ; R2=scalar(smin=0,smax=umax=0xffffffff,smin32=-1,smax32=0,var_off=(0x0; 0xffffffff))
230: (54) w2 &= -134   ; R2=scalar(smin=0,smax=umax=umax32=0xffffff7a,smax32=0x7fffff7a,var_off=(0x0; 0xffffff7a))

after insn 230 the register w2 can only be 0 or -134,
but the verifier approximates it, since there is no way to
represent two scalars in bpf_reg_state.
After fallthough at insn 232 the w2 can only be -134,
hence the branch at insn
239: (56) if w2 != -136 goto pc+210
should be always taken, and trapping insn 258 should never execute.
LLVM generated correct code, but the verifier follows impossible
path and rejects valid program. To fix this issue recognize this
special LLVM optimization and fork the verifier state.
So after insn 229: (c4) w2 s>>= 31
the verifier has two states to explore:
one with w2 = 0 and another with w2 = 0xffffffff
which makes the verifier accept bpf_wiregard.c

A similar pattern exists were OR operation is used in place of the AND
operation, the verifier detects that pattern as well by forking the
state before the OR operation with a scalar in range [-1,0].

Note there are 20+ such patterns in bpf_wiregard.o compiled
with -O1 and -O2, but they're rarely seen in other production
bpf programs, so push_stack() approach is not a concern.

Reported-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Co-developed-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20260112201424.816836-2-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f7ca88fe20e75..e94a02ae3e1cd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15418,6 +15418,35 @@ static bool is_safe_to_compute_dst_reg_range(struct bpf_insn *insn,
 	}
 }
 
+static int maybe_fork_scalars(struct bpf_verifier_env *env, struct bpf_insn *insn,
+			      struct bpf_reg_state *dst_reg)
+{
+	struct bpf_verifier_state *branch;
+	struct bpf_reg_state *regs;
+	bool alu32;
+
+	if (dst_reg->smin_value == -1 && dst_reg->smax_value == 0)
+		alu32 = false;
+	else if (dst_reg->s32_min_value == -1 && dst_reg->s32_max_value == 0)
+		alu32 = true;
+	else
+		return 0;
+
+	branch = push_stack(env, env->insn_idx + 1, env->insn_idx, false);
+	if (IS_ERR(branch))
+		return PTR_ERR(branch);
+
+	regs = branch->frame[branch->curframe]->regs;
+	if (alu32) {
+		__mark_reg32_known(&regs[insn->dst_reg], 0);
+		__mark_reg32_known(dst_reg, -1ull);
+	} else {
+		__mark_reg_known(&regs[insn->dst_reg], 0);
+		__mark_reg_known(dst_reg, -1ull);
+	}
+	return 0;
+}
+
 /* WARNING: This function does calculations on 64-bit values, but the actual
  * execution may occur on 32-bit values. Therefore, things like bitshifts
  * need extra checks in the 32-bit case.
@@ -15480,11 +15509,21 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		scalar_min_max_mul(dst_reg, &src_reg);
 		break;
 	case BPF_AND:
+		if (tnum_is_const(src_reg.var_off)) {
+			ret = maybe_fork_scalars(env, insn, dst_reg);
+			if (ret)
+				return ret;
+		}
 		dst_reg->var_off = tnum_and(dst_reg->var_off, src_reg.var_off);
 		scalar32_min_max_and(dst_reg, &src_reg);
 		scalar_min_max_and(dst_reg, &src_reg);
 		break;
 	case BPF_OR:
+		if (tnum_is_const(src_reg.var_off)) {
+			ret = maybe_fork_scalars(env, insn, dst_reg);
+			if (ret)
+				return ret;
+		}
 		dst_reg->var_off = tnum_or(dst_reg->var_off, src_reg.var_off);
 		scalar32_min_max_or(dst_reg, &src_reg);
 		scalar_min_max_or(dst_reg, &src_reg);
-- 
2.51.0

