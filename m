Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9894F1F8910;
	Tue, 15 Oct 2024 12:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994282; cv=none; b=QkGU6P+RPXHPVbxB1HmU8BC6e+PTfz/b6tOVBePHhDQ+WjhngW3aG2Ve2OGrD8jbleDYvANybScFcGHTRbOQ0glo7oMrLKztRxCxQaqb9rNyy/SLmQp2J6F/4cMSQjQMigtxV0zfgx4oEm0FEpjnw61V7wPCwNO5d1fyiye7jyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994282; c=relaxed/simple;
	bh=0S4BlbK3a+1HJ08Mpepzg3bPluTN0n8rFLuBn2GAX0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcX7RyRCphwLYVtYEqXE52MLCVvcn+902iPalKI4OAHQvFpEE3ISEOT5wo/afkIhiVdSGUsI1MaK4TSdXOGwYHwJ5HWple3DsYF72YY6fHt6Cs0xOWfeqvOHpCKB7hPZA0EBB4MpjrI83GmbgOi97RFki8gc5NEllo1d8H9q4NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxmJIsxO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxmJIsxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BDAC4CEC6;
	Tue, 15 Oct 2024 12:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994282;
	bh=0S4BlbK3a+1HJ08Mpepzg3bPluTN0n8rFLuBn2GAX0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxmJIsxOwpHDUQCoRJKSOg3vNwJ1TUtNoQVbKkbRBulqdvmlSSlNXc57s3PU+P1kh
	 OzUAPWXYtz417ZfaoF4sqefPei2ezM3xx29tOECHKancqB4AFRwKxTyfDD65hK4SSX
	 fJ4fr6oa6f2Ee+S88WjM3yF6IGKBHiO4UiBsTbSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 660/691] x86/fpu: Avoid writing LBR bit to IA32_XSS unless supported
Date: Tue, 15 Oct 2024 13:30:08 +0200
Message-ID: <20241015112506.518479412@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mitchell Levy <levymitchell0@gmail.com>

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
[ Mitchell Levy: Backport to 5.15, since struct fpu_config is not
  introduced until 578971f4e228 and feature masks are not included in
  said struct until 1c253ff2287f ]
Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240812-xsave-lbr-fix-v3-1-95bac1bf62f4@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/fpu/xstate.h | 5 +++--
 arch/x86/kernel/fpu/xstate.c      | 7 +++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index d91df71f60fb1..3bc08b5313b0b 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -85,6 +85,7 @@
 #endif
 
 extern u64 xfeatures_mask_all;
+extern u64 xfeatures_mask_indep;
 
 static inline u64 xfeatures_mask_supervisor(void)
 {
@@ -124,9 +125,9 @@ static inline u64 xfeatures_mask_fpstate(void)
 static inline u64 xfeatures_mask_independent(void)
 {
 	if (!boot_cpu_has(X86_FEATURE_ARCH_LBR))
-		return XFEATURE_MASK_INDEPENDENT & ~XFEATURE_MASK_LBR;
+		return xfeatures_mask_indep & ~XFEATURE_MASK_LBR;
 
-	return XFEATURE_MASK_INDEPENDENT;
+	return xfeatures_mask_indep;
 }
 
 extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 81891f0fff6f6..3772577462a07 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -60,6 +60,11 @@ static short xsave_cpuid_features[] __initdata = {
  * XSAVE buffer, both supervisor and user xstates.
  */
 u64 xfeatures_mask_all __ro_after_init;
+/*
+ * This represents the "independent" xfeatures that are supported by XSAVES, but not managed as part
+ * of the FPU core, such as LBR.
+ */
+u64 xfeatures_mask_indep __ro_after_init;
 EXPORT_SYMBOL_GPL(xfeatures_mask_all);
 
 static unsigned int xstate_offsets[XFEATURE_MAX] __ro_after_init =
@@ -768,6 +773,8 @@ void __init fpu__init_system_xstate(void)
 		goto out_disable;
 	}
 
+	xfeatures_mask_indep = xfeatures_mask_all & XFEATURE_MASK_INDEPENDENT;
+
 	/*
 	 * Clear XSAVE features that are disabled in the normal CPUID.
 	 */
-- 
2.43.0



