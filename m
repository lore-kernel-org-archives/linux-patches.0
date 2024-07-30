Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD14418B46A;
	Tue, 30 Jul 2024 16:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357110; cv=none; b=tyTev4RNdlt2eY6k6TqDMl3l6pXW7XJXQY0suvbj57TIA9p3aQRfIpF7TWtZBArfc52fpuu0xRWdnyolTO4Nb5pKiJdzohMNXY79l30yM/KBkjxsxmoe7URNmxL2CKvWoyU6qEcTDhtImfULridKuYAIiWOZBGfCyQBHBUViUHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357110; c=relaxed/simple;
	bh=9x/m8hRPQxnn7FWw1rxkzGaiBW9gi23PyxA/iVvFMvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGKgjMtLQGUzXfQMp17yTRbuU5qwopIjemxJ1uDtK+H2U4myy+1FiBKnrjYQc9/lmjxhpW3/1AK3qDnzjpnd8klFfaGehoqMqNwYTS3EzVazYPcbJKdoWntkwZO5Pqlny34BlMqH7wQLrUw/uP4tlwJtYy1mCHSgXRHJrCLVFzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDlLQtbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDlLQtbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39539C4AF0A;
	Tue, 30 Jul 2024 16:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357110;
	bh=9x/m8hRPQxnn7FWw1rxkzGaiBW9gi23PyxA/iVvFMvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDlLQtbi+Z1dBJFH6TroKLuIk/eMkyjCH3ftl8FdYnRruDdJUGyW5P1g0JTP6uB/X
	 OhH3dreSFQbAn4sDPUHmYCcqrutlSEzCvSSZ3opqK28J06ZS1B+E/+s557CZuDF185
	 OHFmicVkjsObWLwipGVOQx95BBjAq9+YMmcUsmKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 219/809] riscv, bpf: Fix out-of-bounds issue when preparing trampoline image
Date: Tue, 30 Jul 2024 17:41:35 +0200
Message-ID: <20240730151733.257087333@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 9f1e16fb1fc9826001c69e0551d51fbbcd2d74e9 ]

We get the size of the trampoline image during the dry run phase and
allocate memory based on that size. The allocated image will then be
populated with instructions during the real patch phase. But after
commit 26ef208c209a ("bpf: Use arch_bpf_trampoline_size"), the `im`
argument is inconsistent in the dry run and real patch phase. This may
cause emit_imm in RV64 to generate a different number of instructions
when generating the 'im' address, potentially causing out-of-bounds
issues. Let's emit the maximum number of instructions for the "im"
address during dry run to fix this problem.

Fixes: 26ef208c209a ("bpf: Use arch_bpf_trampoline_size")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240622030437.3973492-3-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 79a001d5533ea..212b015e09b75 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -16,6 +16,8 @@
 #include "bpf_jit.h"
 
 #define RV_FENTRY_NINSNS 2
+/* imm that allows emit_imm to emit max count insns */
+#define RV_MAX_COUNT_IMM 0x7FFF7FF7FF7FF7FF
 
 #define RV_REG_TCC RV_REG_A6
 #define RV_REG_TCC_SAVED RV_REG_S6 /* Store A6 in S6 if program do calls */
@@ -915,7 +917,7 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 		orig_call += RV_FENTRY_NINSNS * 4;
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
-		emit_imm(RV_REG_A0, (const s64)im, ctx);
+		emit_imm(RV_REG_A0, ctx->insns ? (const s64)im : RV_MAX_COUNT_IMM, ctx);
 		ret = emit_call((const u64)__bpf_tramp_enter, true, ctx);
 		if (ret)
 			return ret;
@@ -976,7 +978,7 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		im->ip_epilogue = ctx->insns + ctx->ninsns;
-		emit_imm(RV_REG_A0, (const s64)im, ctx);
+		emit_imm(RV_REG_A0, ctx->insns ? (const s64)im : RV_MAX_COUNT_IMM, ctx);
 		ret = emit_call((const u64)__bpf_tramp_exit, true, ctx);
 		if (ret)
 			goto out;
@@ -1045,6 +1047,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image,
 {
 	int ret;
 	struct rv_jit_context ctx;
+	u32 size = image_end - image;
 
 	ctx.ninsns = 0;
 	/*
@@ -1058,11 +1061,16 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image,
 	ctx.ro_insns = image;
 	ret = __arch_prepare_bpf_trampoline(im, m, tlinks, func_addr, flags, &ctx);
 	if (ret < 0)
-		return ret;
+		goto out;
 
-	bpf_flush_icache(ctx.insns, ctx.insns + ctx.ninsns);
+	if (WARN_ON(size < ninsns_rvoff(ctx.ninsns))) {
+		ret = -E2BIG;
+		goto out;
+	}
 
-	return ninsns_rvoff(ret);
+	bpf_flush_icache(image, image_end);
+out:
+	return ret < 0 ? ret : size;
 }
 
 int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
-- 
2.43.0



