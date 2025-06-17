Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126D0221F1F;
	Tue, 17 Jun 2025 15:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174544; cv=none; b=htwNatUp/JccVFQlh+WClDiXqKrSb1/2zSDW2ep1mqe0F17yC3lWIG5GNL5ELNs7egWE2Z6LiiVBs06QwzHGOap8sO9UwOpVAmLpIPZxhBPxuLheyLMQjatOY24M7mWDUxgL6EyTROIzx0KmYokO/czW2h/c+eUgQElwK3ual+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174544; c=relaxed/simple;
	bh=EM7YWcYYAddLPfhIcmf/DpH3/bL2tFZpBZ86SdxEgl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgpZgOKabCCL9SQl/7R1ZcG3upaiWOsMSMS81vZ2+ARwoWJJcSse100BliryZzqAk1Lg9ISIw8SxCoWTgN5Ibbtf4kZVty/h15s318gogECIcsdUXvppz6I7foeT1IyZ9Z3rgssmsrNfUNxeUFqwNICAGJuXxT1siTzHIHT4yik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RO1pVdIB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RO1pVdIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227A4C4CEE7;
	Tue, 17 Jun 2025 15:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174541;
	bh=EM7YWcYYAddLPfhIcmf/DpH3/bL2tFZpBZ86SdxEgl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RO1pVdIBJR06XYi52J07C/YwYl3igT/VsCay+DtrVopEMjVOveFR0O/5zniLeBt9z
	 qscN+ojFww+uVRvSYVlG1d4fBU4p4rRe/UAUXgpJ1hCLonk8lg3kfA3nBpw8mYvrZm
	 m0XLWcN62vH6BQn+7P7XGyoxmdpm3Y/fHoprcAPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/356] arm64/fpsimd: Avoid RES0 bits in the SME trap handler
Date: Tue, 17 Jun 2025 17:22:54 +0200
Message-ID: <20250617152340.607123520@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 95507570fb2f75544af69760cd5d8f48fc5c7f20 ]

The SME trap handler consumes RES0 bits from the ESR when determining
the reason for the trap, and depends upon those bits reading as zero.
This may break in future when those RES0 bits are allocated a meaning
and stop reading as zero.

For SME traps taken with ESR_ELx.EC == 0b011101, the specific reason for
the trap is indicated by ESR_ELx.ISS.SMTC ("SME Trap Code"). This field
occupies bits [2:0] of ESR_ELx.ISS, and as of ARM DDI 0487 L.a, bits
[24:3] of ESR_ELx.ISS are RES0. ESR_ELx.ISS itself occupies bits [24:0]
of ESR_ELx.

Extract the SMTC field specifically, matching the way we handle ESR_ELx
fields elsewhere, and ensuring that the handler is future-proof.

Fixes: 8bd7f91c03d8 ("arm64/sme: Implement traps and syscall handling for SME")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20250409164010.3480271-2-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/esr.h | 14 ++++++++------
 arch/arm64/kernel/fpsimd.c   |  2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 1cdae1b4f03be..b04575ea3a355 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -366,12 +366,14 @@
 /*
  * ISS values for SME traps
  */
-
-#define ESR_ELx_SME_ISS_SME_DISABLED	0
-#define ESR_ELx_SME_ISS_ILL		1
-#define ESR_ELx_SME_ISS_SM_DISABLED	2
-#define ESR_ELx_SME_ISS_ZA_DISABLED	3
-#define ESR_ELx_SME_ISS_ZT_DISABLED	4
+#define ESR_ELx_SME_ISS_SMTC_MASK		GENMASK(2, 0)
+#define ESR_ELx_SME_ISS_SMTC(esr)		((esr) & ESR_ELx_SME_ISS_SMTC_MASK)
+
+#define ESR_ELx_SME_ISS_SMTC_SME_DISABLED	0
+#define ESR_ELx_SME_ISS_SMTC_ILL		1
+#define ESR_ELx_SME_ISS_SMTC_SM_DISABLED	2
+#define ESR_ELx_SME_ISS_SMTC_ZA_DISABLED	3
+#define ESR_ELx_SME_ISS_SMTC_ZT_DISABLED	4
 
 /* ISS field definitions for MOPS exceptions */
 #define ESR_ELx_MOPS_ISS_MEM_INST	(UL(1) << 24)
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index bd4f6c6ee0f31..9f6ea38f5189f 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1514,7 +1514,7 @@ void do_sme_acc(unsigned long esr, struct pt_regs *regs)
 	 * If this not a trap due to SME being disabled then something
 	 * is being used in the wrong mode, report as SIGILL.
 	 */
-	if (ESR_ELx_ISS(esr) != ESR_ELx_SME_ISS_SME_DISABLED) {
+	if (ESR_ELx_SME_ISS_SMTC(esr) != ESR_ELx_SME_ISS_SMTC_SME_DISABLED) {
 		force_signal_inject(SIGILL, ILL_ILLOPC, regs->pc, 0);
 		return;
 	}
-- 
2.39.5



