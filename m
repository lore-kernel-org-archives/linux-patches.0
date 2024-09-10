Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5083118DF69;
	Tue, 10 Sep 2024 10:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964053; cv=none; b=pxkhDCIdqViBQJ/hInWhhjWA08WfVoK5hoiR4JeqtQIgZVa++Nf7dLC7GStLmabqIFfLiFOvcuPfsLiUSz4MvcfLHXU42CHBSkKAu94+2u0HGgB+qJtkQv1ze2bczC7GQVE7h5R7eBit+P8P9lkMt7A/wnJCIdpsS56m7F3/OgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964053; c=relaxed/simple;
	bh=dFC9eaqT5Am7E59kYISrAr+BSPvwQC09y/UDWZzDDes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxP7v04WOsndZV5t2+cFrW3+JHdJC9VuM6LD9F4N96UrQzZr6g/M43ft4PNiCgXNO3e2g4FBx8mgsqGJ6qsR7Xc6penmYcvFZzwrBvMygTteDaS0Iex3zRUjs63Fv+gkdXFAwqthCzHtO8TgCyyGhnE0/ILXp1Ni3jbyiAwNWNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyr4oDFp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyr4oDFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CB2C4CEC3;
	Tue, 10 Sep 2024 10:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964052;
	bh=dFC9eaqT5Am7E59kYISrAr+BSPvwQC09y/UDWZzDDes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyr4oDFpp2E/2V1bh9E06wewCihU5A+bmPtmaHyXFnxluNcj06lOEcZL7dPy7hXTu
	 heN/Aj6sScnb5dOmTH0zqdtnADU05PpC32DPm4LKjqcLUthTFykrBELjV9FkPmYe3V
	 StSK4aeF7y6YUsl2Qm9TSEdBwSJoaT6jWKVBLK1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Mitchell Levy <levymitchell0@gmail.com>
Subject: [PATCH 6.6 051/269] x86/fpu: Avoid writing LBR bit to IA32_XSS unless supported
Date: Tue, 10 Sep 2024 11:30:38 +0200
Message-ID: <20240910092610.061641823@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Mitchell Levy <levymitchell0@gmail.com>

commit 2848ff28d180bd63a95da8e5dcbcdd76c1beeb7b upstream.

There are two distinct CPU features related to the use of XSAVES and LBR:
whether LBR is itself supported and whether XSAVES supports LBR. The LBR
subsystem correctly checks both in intel_pmu_arch_lbr_init(), but the
XSTATE subsystem does not.

The LBR bit is only removed from xfeatures_mask_independent when LBR is not
supported by the CPU, but there is no validation of XSTATE support.

If XSAVES does not support LBR the write to IA32_XSS causes a #GP fault,
leaving the state of IA32_XSS unchanged, i.e. zero. The fault is handled
with a warning and the boot continues.

Consequently the next XRSTORS which tries to restore supervisor state fails
with #GP because the RFBM has zero for all supervisor features, which does
not match the XCOMP_BV field.

As XFEATURE_MASK_FPSTATE includes supervisor features setting up the FPU
causes a #GP, which ends up in fpu_reset_from_exception_fixup(). That fails
due to the same problem resulting in recursive #GPs until the kernel runs
out of stack space and double faults.

Prevent this by storing the supported independent features in
fpu_kernel_cfg during XSTATE initialization and use that cached value for
retrieving the independent feature bits to be written into IA32_XSS.

[ tglx: Massaged change log ]

Fixes: f0dccc9da4c0 ("x86/fpu/xstate: Support dynamic supervisor feature for LBR")
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240812-xsave-lbr-fix-v3-1-95bac1bf62f4@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/fpu/types.h |    7 +++++++
 arch/x86/kernel/fpu/xstate.c     |    3 +++
 arch/x86/kernel/fpu/xstate.h     |    4 ++--
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -589,6 +589,13 @@ struct fpu_state_config {
 	 * even without XSAVE support, i.e. legacy features FP + SSE
 	 */
 	u64 legacy_features;
+	/*
+	 * @independent_features:
+	 *
+	 * Features that are supported by XSAVES, but not managed as part of
+	 * the FPU core, such as LBR
+	 */
+	u64 independent_features;
 };
 
 /* FPU state configuration information */
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -788,6 +788,9 @@ void __init fpu__init_system_xstate(unsi
 		goto out_disable;
 	}
 
+	fpu_kernel_cfg.independent_features = fpu_kernel_cfg.max_features &
+					      XFEATURE_MASK_INDEPENDENT;
+
 	/*
 	 * Clear XSAVE features that are disabled in the normal CPUID.
 	 */
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -64,9 +64,9 @@ static inline u64 xfeatures_mask_supervi
 static inline u64 xfeatures_mask_independent(void)
 {
 	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR))
-		return XFEATURE_MASK_INDEPENDENT & ~XFEATURE_MASK_LBR;
+		return fpu_kernel_cfg.independent_features & ~XFEATURE_MASK_LBR;
 
-	return XFEATURE_MASK_INDEPENDENT;
+	return fpu_kernel_cfg.independent_features;
 }
 
 /* XSAVE/XRSTOR wrapper functions */


