Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031402;
	b=tLTgJA48v3CKP2pEZE4gtiMBYgeXjhwRzYyvDuBUjcx2P5ZsUTMueuXTVIMI4YHQ+kXu
	 gwpe+Cm/tnB5aCvM1zLW+VfYhjx1MoGu/0kau3egt2lqXfmF64PoAwjiRJ0Kg674Baj6f
	 l20sLOiZI37ykVHuACvpo2W8auyx7pAzzPfEgkSSlZxpG/Z46rMiyucujxcNdXUAI2mFZ
	 wxbkDDF47d9Bkc/Aoxb/yrwkHnmrCoBvQY92jmIfVmSUTdIC/dAY53Pw4u1y3TTqmM1AZ
	 ZdbcVtq+S8fsrvrQYZBayFHRZ64PFNiMia/3mua0SwPnWmgvcivawHsPuzU2G6jSkVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=noCHafHo3CrE3eTmK2UweY1Xvxc+9muoM9DQ76cii1Y=;
	b=jEN64hJzCVY2muOdxu87Z38BaVPwX4sKPJcZPV/IlDjbrth46YXTPzzjg9bCtjOlEbeN
	 M4EjGkX6IddMdbNR2QhB3Sgf5tkjNIR/5puC+GTQaxmqHIRKvdUj9BDMz0LGdQmmFFcKL
	 CiT8rA4Ozz14nFh1F/UoekhgVbpMxsi4IKzLVsY/Y2Au9PBk/bao8x9QhoDrz1PPEMH0Q
	 CwVdhuDmj+R8cF2eUAcCo1Ai4sqwzamWIQXuJL8rZPZuuAof/GsAIUbRlr5m6kRCdrEP/
	 Hcqsb4HaGxvYocUPqxcShPEdu1X94wi/F0GEwgflAgm7ZiytIIWDSFMNkavy0VKwnsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gODx8JqE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E2A606A31C;
	Wed, 18 Nov 2026 19:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gODx8JqE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0710F1F000C9;
	Wed, 18 Nov 2026 19:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031402;
	bh=noCHafHo3CrE3eTmK2UweY1Xvxc+9muoM9DQ76cii1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gODx8JqEqIFTFiyVFnvM+8tc+5gIKUkJJDNP8dhtZdNoxAtqklSHuvgEUK6jyEVHl
	 cJ9Y1S48jlz6324l94irbRcbxmbkW8st9ER0ZBehf1yhWSpdkJTvJRD1lMcMNt2Lgs
	 NBNn2tSsFxa8+7FvYA7CTUBWhRtZ8cIJioyMCO+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Pu Lehui <pulehui@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1045/1756] bpf, riscv: Fix stack-passed arguments for indirect trampolines
Date: Wed, 18 Nov 2026 15:52:52 +0100
Message-ID: <20261118150051.662621401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit b4a1ecae94ae803fcd75fb16a7653ff86b64ed8b ]

store_args() reads stack-passed arguments relative to FP assuming the
trampoline was entered through the fentry call from a traced function. In
that path, the trampoline pushes the parent frame before establishing its
final FP, so the incoming stack arguments start at FP + 16.

An indirect trampoline for a struct_ops callback is called through a
function pointer. Its prologue allocates only the trampoline frame and sets
FP to the incoming SP. The RISC-V ABI places the first stack argument at
that incoming SP, so the arguments start at FP, not FP + 16. Every
stack-passed argument of a callback with more than eight argument slots is
therefore read two slots late.

Pass the prologue-dependent offset to store_args(), using zero for a direct
struct_ops trampoline and 16 for the fentry path.

Fixes: 6801b0aef79d ("riscv, bpf: Add 12-argument support for RV64 bpf trampoline")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260930083522.1914145-2-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 55c2f85090d45..07e60330b2a96 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -729,7 +729,8 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
 	return ret;
 }
 
-static void store_args(int nr_arg_slots, int args_off, struct rv_jit_context *ctx)
+static void store_args(int nr_arg_slots, int args_off, int stack_args_off,
+		       struct rv_jit_context *ctx)
 {
 	int i;
 
@@ -737,8 +738,8 @@ static void store_args(int nr_arg_slots, int args_off, struct rv_jit_context *ct
 		if (i < RV_MAX_REG_ARGS) {
 			emit_sd(RV_REG_FP, -args_off, RV_REG_A0 + i, ctx);
 		} else {
-			/* skip slots for T0 and FP of traced function */
-			emit_ld(RV_REG_T1, 16 + (i - RV_MAX_REG_ARGS) * 8, RV_REG_FP, ctx);
+			emit_ld(RV_REG_T1, stack_args_off +
+				(i - RV_MAX_REG_ARGS) * 8, RV_REG_FP, ctx);
 			emit_sd(RV_REG_FP, -args_off, RV_REG_T1, ctx);
 		}
 		args_off -= 8;
@@ -973,7 +974,12 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 	emit_li(RV_REG_T1, nr_arg_slots, ctx);
 	emit_sd(RV_REG_FP, -nregs_off, RV_REG_T1, ctx);
 
-	store_args(nr_arg_slots, args_off, ctx);
+	/*
+	 * A direct struct_ops call has its first stack argument at the incoming
+	 * SP, which the trampoline keeps as FP. The fentry path pushes the
+	 * parent frame first, so its incoming stack arguments start at FP + 16.
+	 */
+	store_args(nr_arg_slots, args_off, is_struct_ops ? 0 : 16, ctx);
 
 	/* skip to actual body of traced function */
 	if (flags & BPF_TRAMP_F_SKIP_FRAME)
-- 
2.53.0



