Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14292AF07;
	Mon, 28 Oct 2024 06:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098171; cv=none; b=pt3t0poGEiCzBV6FKbdqSXEXGrARWYBrrAgj3ursft/u1ii9wnTneMTqCTxhd88H0aqVvjWQD/9wOGGtlULsMpX5ji13ZHfmYvDVW/5IrWZ6CnAfBD3aT/wppHh/aNpj7KEaZASD9uwjL/y5nAQjr7WEgen7Q4D19MjqM+9FvaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098171; c=relaxed/simple;
	bh=Ubc6YwivSYrDJeADpxk0mcg6YN36sZ2IcwftC+uFcQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qne+OcKuJmJV9iCQURkf378FrsUqx2rq7ReDYO7WdOEPlS+Lr56bxfOwA12KGToNy12IeOdsSSD5BGgxQFp0g/LqHqWjyt6LlyJ86r9G7TMDPK+Xos/gb+pxSfgUpYUQImui7+ai0Du2prtaiJ4yRXawja1dgAL/eIE2I1hBEcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMh/l3ch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMh/l3ch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1631BC4CEC3;
	Mon, 28 Oct 2024 06:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098171;
	bh=Ubc6YwivSYrDJeADpxk0mcg6YN36sZ2IcwftC+uFcQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMh/l3chQWHc5/CN78a7pM6cjE/nH4upuiNTuQfe7qK4/YAxUGd0V/5vBfQxyYBTL
	 Nf5RSFqXuAVzDBu67aXsPWE+0CpEneuMptul3Ia/VPjQ9MFmukTGrbGXX4JKdg11fC
	 0Y79SoDCImcJ/u8Pw8/ZoXFCGoBeAIx1iLHA9GDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathaniel Theis <nathaniel.theis@nccgroup.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 109/261] bpf: Fix incorrect delta propagation between linked registers
Date: Mon, 28 Oct 2024 07:24:11 +0100
Message-ID: <20241028062314.759011171@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 3878ae04e9fc24dacb77a1d32bd87e7d8108599e ]

Nathaniel reported a bug in the linked scalar delta tracking, which can lead
to accepting a program with OOB access. The specific code is related to the
sync_linked_regs() function and the BPF_ADD_CONST flag, which signifies a
constant offset between two scalar registers tracked by the same register id.

The verifier attempts to track "similar" scalars in order to propagate bounds
information learned about one scalar to others. For instance, if r1 and r2
are known to contain the same value, then upon encountering 'if (r1 != 0x1234)
goto xyz', not only does it know that r1 is equal to 0x1234 on the path where
that conditional jump is not taken, it also knows that r2 is.

Additionally, with env->bpf_capable set, the verifier will track scalars
which should be a constant delta apart (if r1 is known to be one greater than
r2, then if r1 is known to be equal to 0x1234, r2 must be equal to 0x1233.)
The code path for the latter in adjust_reg_min_max_vals() is reached when
processing both 32 and 64-bit addition operations. While adjust_reg_min_max_vals()
knows whether dst_reg was produced by a 32 or a 64-bit addition (based on the
alu32 bool), the only information saved in dst_reg is the id of the source
register (reg->id, or'ed by BPF_ADD_CONST) and the value of the constant
offset (reg->off).

Later, the function sync_linked_regs() will attempt to use this information
to propagate bounds information from one register (known_reg) to others,
meaning, for all R in linked_regs, it copies known_reg range (and possibly
adjusting delta) into R for the case of R->id == known_reg->id.

For the delta adjustment, meaning, matching reg->id with BPF_ADD_CONST, the
verifier adjusts the register as reg = known_reg; reg += delta where delta
is computed as (s32)reg->off - (s32)known_reg->off and placed as a scalar
into a fake_reg to then simulate the addition of reg += fake_reg. This is
only correct, however, if the value in reg was created by a 64-bit addition.
When reg contains the result of a 32-bit addition operation, its upper 32
bits will always be zero. sync_linked_regs() on the other hand, may cause
the verifier to believe that the addition between fake_reg and reg overflows
into those upper bits. For example, if reg was generated by adding the
constant 1 to known_reg using a 32-bit alu operation, then reg->off is 1
and known_reg->off is 0. If known_reg is known to be the constant 0xFFFFFFFF,
sync_linked_regs() will tell the verifier that reg is equal to the constant
0x100000000. This is incorrect as the actual value of reg will be 0, as the
32-bit addition will wrap around.

Example:

  0: (b7) r0 = 0;             R0_w=0
  1: (18) r1 = 0x80000001;    R1_w=0x80000001
  3: (37) r1 /= 1;            R1_w=scalar()
  4: (bf) r2 = r1;            R1_w=scalar(id=1) R2_w=scalar(id=1)
  5: (bf) r4 = r1;            R1_w=scalar(id=1) R4_w=scalar(id=1)
  6: (04) w2 += 2147483647;   R2_w=scalar(id=1+2147483647,smin=0,smax=umax=0xffffffff,var_off=(0x0; 0xffffffff))
  7: (04) w4 += 0 ;           R4_w=scalar(id=1+0,smin=0,smax=umax=0xffffffff,var_off=(0x0; 0xffffffff))
  8: (15) if r2 == 0x0 goto pc+1
 10: R0=0 R1=0xffffffff80000001 R2=0x7fffffff R4=0xffffffff80000001 R10=fp0

What can be seen here is that r1 is copied to r2 and r4, such that {r1,r2,r4}.id
are all the same which later lets sync_linked_regs() to be invoked. Then, in
a next step constants are added with alu32 to r2 and r4, setting their ->off,
as well as id |= BPF_ADD_CONST. Next, the conditional will bind r2 and
propagate ranges to its linked registers. The verifier now believes the upper
32 bits of r4 are r4=0xffffffff80000001, while actually r4=r1=0x80000001.

One approach for a simple fix suitable also for stable is to limit the constant
delta tracking to only 64-bit alu addition. If necessary at some later point,
BPF_ADD_CONST could be split into BPF_ADD_CONST64 and BPF_ADD_CONST32 to avoid
mixing the two under the tradeoff to further complicate sync_linked_regs().
However, none of the added tests from dedf56d775c0 ("selftests/bpf: Add tests
for add_const") make this necessary at this point, meaning, BPF CI also passes
with just limiting tracking to 64-bit alu addition.

Fixes: 98d7ca374ba4 ("bpf: Track delta between "linked" registers.")
Reported-by: Nathaniel Theis <nathaniel.theis@nccgroup.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20241016134913.32249-1-daniel@iogearbox.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 42d6bc5392757..5b8b1d0e76cf1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14136,12 +14136,13 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 	 * r1 += 0x1
 	 * if r2 < 1000 goto ...
 	 * use r1 in memory access
-	 * So remember constant delta between r2 and r1 and update r1 after
-	 * 'if' condition.
+	 * So for 64-bit alu remember constant delta between r2 and r1 and
+	 * update r1 after 'if' condition.
 	 */
-	if (env->bpf_capable && BPF_OP(insn->code) == BPF_ADD &&
-	    dst_reg->id && is_reg_const(src_reg, alu32)) {
-		u64 val = reg_const_value(src_reg, alu32);
+	if (env->bpf_capable &&
+	    BPF_OP(insn->code) == BPF_ADD && !alu32 &&
+	    dst_reg->id && is_reg_const(src_reg, false)) {
+		u64 val = reg_const_value(src_reg, false);
 
 		if ((dst_reg->id & BPF_ADD_CONST) ||
 		    /* prevent overflow in find_equal_scalars() later */
-- 
2.43.0



