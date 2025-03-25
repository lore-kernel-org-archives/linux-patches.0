Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34F026B0A9;
	Tue, 25 Mar 2025 12:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906216; cv=none; b=X+sJMGLZAc09/Y0U+s3HweStsCwgwylEBYTTH3JXZlniI35GXQfwdTqPSgYkVUJxyGE1Qjjl4NeROf6w4vwgrQkI/ExHjIuLgOlO4u8cCeUXBglqCt8ej2AWrrB36dASWClKv8bGudKFwi48MDmKoTPBa32xPxZjGxQCSVfBLlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906216; c=relaxed/simple;
	bh=S3aJotmRPaVvRxxS8eMyX5s2W0NPMnTyHq9qFwGAkYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwsDa3Mka40e8I61FQ1klP11hpqBA0vl3aL/R5V+xNtkse8lcE0tH2EbblwYQaBeVZ4OQ+IRbismbLpo9DurjurhiR3Z7UnpCwwCohx18z8Jj5X833ZHcWx17FUDkA+Hh1ZNtl6f4rWEsN8XpONAxImtzLvPfvQGyMc5Sw965Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFBFddp4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFBFddp4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDCFC4CEE4;
	Tue, 25 Mar 2025 12:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906216;
	bh=S3aJotmRPaVvRxxS8eMyX5s2W0NPMnTyHq9qFwGAkYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFBFddp4EguD+okKEITtmRnCwNXjwDFYMM0hPyUtAMAn3UwA6+GOKlb7jViaXEHy1
	 qvEB/C08R6638pFcN/tz/vcdBZZBPWFjb1t8w4d2vz3E/jZGXsySl1IxbowtyvbF+Z
	 CteahV4m4hRhu+YJ3jSkgwhJ89MFT//hOM5aS8Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.6 67/77] KVM: arm64: Remove VHE host restore of CPACR_EL1.SMEN
Date: Tue, 25 Mar 2025 08:23:02 -0400
Message-ID: <20250325122146.135282891@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

[ Upstream commit 407a99c4654e8ea65393f412c421a55cac539f5b ]

When KVM is in VHE mode, the host kernel tries to save and restore the
configuration of CPACR_EL1.SMEN (i.e. CPTR_EL2.SMEN when HCR_EL2.E2H=1)
across kvm_arch_vcpu_load_fp() and kvm_arch_vcpu_put_fp(), since the
configuration may be clobbered by hyp when running a vCPU. This logic
has historically been broken, and is currently redundant.

This logic was originally introduced in commit:

  861262ab86270206 ("KVM: arm64: Handle SME host state when running guests")

At the time, the VHE hyp code would reset CPTR_EL2.SMEN to 0b00 when
returning to the host, trapping host access to SME state. Unfortunately,
this was unsafe as the host could take a softirq before calling
kvm_arch_vcpu_put_fp(), and if a softirq handler were to use kernel mode
NEON the resulting attempt to save the live FPSIMD/SVE/SME state would
result in a fatal trap.

That issue was limited to VHE mode. For nVHE/hVHE modes, KVM always
saved/restored the host kernel's CPACR_EL1 value, and configured
CPTR_EL2.TSM to 0b0, ensuring that host usage of SME would not be
trapped.

The issue above was incidentally fixed by commit:

  375110ab51dec5dc ("KVM: arm64: Fix resetting SME trap values on reset for (h)VHE")

That commit changed the VHE hyp code to configure CPTR_EL2.SMEN to 0b01
when returning to the host, permitting host kernel usage of SME,
avoiding the issue described above. At the time, this was not identified
as a fix for commit 861262ab86270206.

Now that the host eagerly saves and unbinds its own FPSIMD/SVE/SME
state, there's no need to save/restore the state of the EL0 SME trap.
The kernel can safely save/restore state without trapping, as described
above, and will restore userspace state (including trap controls) before
returning to userspace.

Remove the redundant logic.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20250210195226.1215254-5-mark.rutland@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
[Update for rework of flags storage -- broonie]
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h |    2 --
 arch/arm64/kvm/fpsimd.c           |   23 -----------------------
 2 files changed, 25 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -717,8 +717,6 @@ struct kvm_vcpu_arch {
 /* vcpu running in HYP context */
 #define VCPU_HYP_CONTEXT	__vcpu_single_flag(iflags, BIT(7))
 
-/* SME enabled for EL0 */
-#define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
 /* Physical CPU not in supported_cpus */
 #define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))
 /* WFIT instruction trapped */
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -87,12 +87,6 @@ void kvm_arch_vcpu_load_fp(struct kvm_vc
 	 */
 	fpsimd_save_and_flush_cpu_state();
 	vcpu->arch.fp_state = FP_STATE_FREE;
-
-	if (system_supports_sme()) {
-		vcpu_clear_flag(vcpu, HOST_SME_ENABLED);
-		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
-			vcpu_set_flag(vcpu, HOST_SME_ENABLED);
-	}
 }
 
 /*
@@ -157,23 +151,6 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcp
 
 	local_irq_save(flags);
 
-	/*
-	 * If we have VHE then the Hyp code will reset CPACR_EL1 to
-	 * the default value and we need to reenable SME.
-	 */
-	if (has_vhe() && system_supports_sme()) {
-		/* Also restore EL0 state seen on entry */
-		if (vcpu_get_flag(vcpu, HOST_SME_ENABLED))
-			sysreg_clear_set(CPACR_EL1, 0,
-					 CPACR_EL1_SMEN_EL0EN |
-					 CPACR_EL1_SMEN_EL1EN);
-		else
-			sysreg_clear_set(CPACR_EL1,
-					 CPACR_EL1_SMEN_EL0EN,
-					 CPACR_EL1_SMEN_EL1EN);
-		isb();
-	}
-
 	if (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED) {
 		if (vcpu_has_sve(vcpu)) {
 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);


