Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CFE3446C0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301659; cv=none; b=cF9ad2oalDLhlruOGemHW6nIieXA1TXDU595a5zSITXKh1qKtzUbQGrIQXEwDbP2qx92I2xGcodvKjyYT53nfZvzILNu5TPZLl6p+9Y3ym7q3yNxuZFyG1Dsp/bB3fwDGSCgTuYjiJoI+upNTRot2B9QM/H/6PPfF0OmVSbJglo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301659; c=relaxed/simple;
	bh=xlvBpnYV0Hm+ATHEeAFE2rENFHtbXlRMy0hDfFItS3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBAB14BsOKnZgtYiKN0F/r6aOSd9biBlOjAG+p88VhSWbrJF3ucwdnWNCOwjP6evNhZjMWssVjBq5JNKimsSXXVcMvegJaciFrCvWl8eB7RPSGbEK/3XYgY4ceAV4XJuysZQ+4P+JVTD9NrcBEy0jrxEXlQaOObnR/j0Lk+nisc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ppd4SHXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ppd4SHXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF39AC116D0;
	Sat, 28 Feb 2026 18:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301659;
	bh=xlvBpnYV0Hm+ATHEeAFE2rENFHtbXlRMy0hDfFItS3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppd4SHXY1pJZVK5Bae0MCkzrUgNxWZFOxlzzaXIft1hBanriL4yaS7Xd1X9JG4tPq
	 zH/4EciRDo1jdOvcNeHPQ7NcxUqB6a/gkJT0Tao3b7vOKEXh8rKX2EM0cLORSZj/8H
	 LUj70tNdXX7LC3b3Bw1rUYC/o/9SZj8b49y1gq5WqHPO0mmCZbl3VDnyymPUFKTdCY
	 uDiyCdjsgBM9cofOO6txeuR6X79gQA6AJZBAM14fGi3VvfEMC2uqi+/7wUDjCMeHU6
	 MjsNWnXAVLyBpd8kKRhj5UmTfjsweJN64CffaCc201Oec97LoDiA4kqlDFUjbTQm7T
	 EHQypAJxo6hzA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Puranjay Mohan <puranjay@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/385] bpf: Preserve id of register in sync_linked_regs()
Date: Sat, 28 Feb 2026 12:54:39 -0500
Message-ID: <20260228180011.1568201-57-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit af9e89d8dd39530c8bd14c33ddf6b502df1071b6 ]

sync_linked_regs() copies the id of known_reg to reg when propagating
bounds of known_reg to reg using the off of known_reg, but when
known_reg was linked to reg like:

known_reg = reg         ; both known_reg and reg get same id
known_reg += 4          ; known_reg gets off = 4, and its id gets BPF_ADD_CONST

now when a call to sync_linked_regs() happens, let's say with the following:

if known_reg >= 10 goto pc+2

known_reg's new bounds are propagated to reg but now reg gets
BPF_ADD_CONST from the copy.

This means if another link to reg is created like:

another_reg = reg       ; another_reg should get the id of reg but
                          assign_scalar_id_before_mov() sees
                          BPF_ADD_CONST on reg and assigns a new id to it.

As reg has a new id now, known_reg's link to reg is broken. If we find
new bounds for known_reg, they will not be propagated to reg.

This can be seen in the selftest added in the next commit:

0: (85) call bpf_get_prandom_u32#7    ; R0=scalar()
1: (57) r0 &= 255                     ; R0=scalar(smin=smin32=0,smax=umax=smax32=umax32=255,var_off=(0x0; 0xff))
2: (bf) r1 = r0                       ; R0=scalar(id=1,smin=smin32=0,smax=umax=smax32=umax32=255,var_off=(0x0; 0xff)) R1=scalar(id=1,smin=smin32=0,smax=umax=smax32=umax32=255,var_off=(0x0; 0xff))
3: (07) r1 += 4                       ; R1=scalar(id=1+4,smin=umin=smin32=umin32=4,smax=umax=smax32=umax32=259,var_off=(0x0; 0x1ff))
4: (a5) if r1 < 0xa goto pc+4         ; R1=scalar(id=1+4,smin=umin=smin32=umin32=10,smax=umax=smax32=umax32=259,var_off=(0x0; 0x1ff))
5: (bf) r2 = r0                       ; R0=scalar(id=2,smin=umin=smin32=umin32=6,smax=umax=smax32=umax32=255) R2=scalar(id=2,smin=umin=smin32=umin32=6,smax=umax=smax32=umax32=255)
6: (a5) if r1 < 0xe goto pc+2         ; R1=scalar(id=1+4,smin=umin=smin32=umin32=14,smax=umax=smax32=umax32=259,var_off=(0x0; 0x1ff))
7: (35) if r0 >= 0xa goto pc+1        ; R0=scalar(id=2,smin=umin=smin32=umin32=6,smax=umax=smax32=umax32=9,var_off=(0x0; 0xf))
8: (37) r0 /= 0
div by zero

When 4 is verified, r1's bounds are propagated to r0 but r0 also gets
BPF_ADD_CONST (bug).
When 5 is verified, r0 gets a new id (2) and its link with r1 is broken.

After 6 we know r1 has bounds [14, 259] and therefore r0 should have
bounds [10, 255], therefore the branch at 7 is always taken. But because
r0's id was changed to 2, r1's new bounds are not propagated to r0.
The verifier still thinks r0 has bounds [6, 255] before 7 and execution
can reach div by zero.

Fix this by preserving id in sync_linked_regs() like off and subreg_def.

Fixes: 98d7ca374ba4 ("bpf: Track delta between "linked" registers.")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260115151143.1344724-2-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7b75a2dd8cb8f..08cdf6ace02ac 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15478,6 +15478,7 @@ static void sync_linked_regs(struct bpf_verifier_state *vstate, struct bpf_reg_s
 		} else {
 			s32 saved_subreg_def = reg->subreg_def;
 			s32 saved_off = reg->off;
+			u32 saved_id = reg->id;
 
 			fake_reg.type = SCALAR_VALUE;
 			__mark_reg_known(&fake_reg, (s32)reg->off - (s32)known_reg->off);
@@ -15485,10 +15486,11 @@ static void sync_linked_regs(struct bpf_verifier_state *vstate, struct bpf_reg_s
 			/* reg = known_reg; reg += delta */
 			copy_register_state(reg, known_reg);
 			/*
-			 * Must preserve off, id and add_const flag,
+			 * Must preserve off, id and subreg_def flag,
 			 * otherwise another sync_linked_regs() will be incorrect.
 			 */
 			reg->off = saved_off;
+			reg->id = saved_id;
 			reg->subreg_def = saved_subreg_def;
 
 			scalar32_min_max_add(reg, &fake_reg);
-- 
2.51.0

