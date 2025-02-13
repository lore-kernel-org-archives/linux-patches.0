Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209F326B087;
	Thu, 13 Feb 2025 15:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459082; cv=none; b=NFeCnx5PtzAikxWr5Gw+RMh4DE0toHmPMzOjaALXbYVlT0TxoBIX1L+Kc7Wn+Kuy4C2J+T2i4BaIbJSOhrUQHcFaoMArgIhgHmzUHX4q5bZWs8lbqYUIKtVAed49UBIKvPwbH565Sujf6wVmOESRLqaDmbmHJZTpg4FU6HIkRCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459082; c=relaxed/simple;
	bh=hvh3Nj038NjHhzJI+IdrMOK8t5+M5buzqTTD49YBrgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+KzVMl2g5ZwXS7Azl5llaWxQX8OJzEiecXjbkl3Qvf6tHsLH94Z7crmHG3F7Y8X+TVboMqcZrnyCEdjRXK5IIx+iyNxibcQJoY+qzMJJSCwwm8t1RtJ6Ct4+7Kt55abqU4EkvdNKg/fsqm3eRE90xjNf02d/MyAjODnFUunIPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sweY4mHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sweY4mHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284C7C4CED1;
	Thu, 13 Feb 2025 15:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459081;
	bh=hvh3Nj038NjHhzJI+IdrMOK8t5+M5buzqTTD49YBrgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sweY4mHGu9jJ2VqSKZaQr5aRS4CVTOnvsQos3n+1ro3mNc6ZxiZCPyYZwouwYfGrz
	 HF9bj6RitYkZBp8BZqPb9dQnJbspcLaDaT19l7vVRKIpZ8wnWSwQ4I1hRuosqK13TJ
	 BJWftCrMGcxug6XKMZCLj322ym7uCTWiT7C7DzJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.13 162/443] arm64/sme: Move storage of reg_smidr to __cpuinfo_store_cpu()
Date: Thu, 13 Feb 2025 15:25:27 +0100
Message-ID: <20250213142446.848336529@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

commit d3c7c48d004f6c8d892f39b5d69884fd0fe98c81 upstream.

In commit 892f7237b3ff ("arm64: Delay initialisation of
cpuinfo_arm64::reg_{zcr,smcr}") we moved access to ZCR, SMCR and SMIDR
later in the boot process in order to ensure that we don't attempt to
interact with them if SVE or SME is disabled on the command line.
Unfortunately when initialising the boot CPU in init_cpu_features() we work
on a copy of the struct cpuinfo_arm64 for the boot CPU used only during
boot, not the percpu copy used by the sysfs code. The expectation of the
feature identification code was that the ID registers would be read in
__cpuinfo_store_cpu() and the values not modified by init_cpu_features().

The main reason for the original change was to avoid early accesses to
ZCR on practical systems that were seen shipping with SVE reported in ID
registers but traps enabled at EL3 and handled as fatal errors, SME was
rolled in due to the similarity with SVE. Since then we have removed the
early accesses to ZCR and SMCR in commits:

  abef0695f9665c3d ("arm64/sve: Remove ZCR pseudo register from cpufeature code")
  391208485c3ad50f ("arm64/sve: Remove SMCR pseudo register from cpufeature code")

so only the SMIDR_EL1 part of the change remains. Since SMIDR_EL1 is
only trapped via FEAT_IDST and not the SME trap it is less likely to be
affected by similar issues, and the factors that lead to issues with SVE
are less likely to apply to SME.

Since we have not yet seen practical SME systems that need to use a
command line override (and are only just beginning to see SME systems at
all) and the ID register read is much more likely to be safe let's just
store SMIDR_EL1 along with all the other ID register reads in
__cpuinfo_store_cpu().

This issue wasn't apparent when testing on emulated platforms that do not
report values in SMIDR_EL1.

Fixes: 892f7237b3ff ("arm64: Delay initialisation of cpuinfo_arm64::reg_{zcr,smcr}")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241217-arm64-fix-boot-cpu-smidr-v3-1-7be278a85623@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/cpufeature.c |   13 -------------
 arch/arm64/kernel/cpuinfo.c    |   10 ++++++++++
 2 files changed, 10 insertions(+), 13 deletions(-)

--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1167,12 +1167,6 @@ void __init init_cpu_features(struct cpu
 	    id_aa64pfr1_sme(read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1))) {
 		unsigned long cpacr = cpacr_save_enable_kernel_sme();
 
-		/*
-		 * We mask out SMPS since even if the hardware
-		 * supports priorities the kernel does not at present
-		 * and we block access to them.
-		 */
-		info->reg_smidr = read_cpuid(SMIDR_EL1) & ~SMIDR_EL1_SMPS;
 		vec_init_vq_map(ARM64_VEC_SME);
 
 		cpacr_restore(cpacr);
@@ -1423,13 +1417,6 @@ void update_cpu_features(int cpu,
 	    id_aa64pfr1_sme(read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1))) {
 		unsigned long cpacr = cpacr_save_enable_kernel_sme();
 
-		/*
-		 * We mask out SMPS since even if the hardware
-		 * supports priorities the kernel does not at present
-		 * and we block access to them.
-		 */
-		info->reg_smidr = read_cpuid(SMIDR_EL1) & ~SMIDR_EL1_SMPS;
-
 		/* Probe vector lengths */
 		if (!system_capabilities_finalized())
 			vec_update_vq_map(ARM64_VEC_SME);
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -482,6 +482,16 @@ static void __cpuinfo_store_cpu(struct c
 	if (id_aa64pfr0_mpam(info->reg_id_aa64pfr0))
 		info->reg_mpamidr = read_cpuid(MPAMIDR_EL1);
 
+	if (IS_ENABLED(CONFIG_ARM64_SME) &&
+	    id_aa64pfr1_sme(info->reg_id_aa64pfr1)) {
+		/*
+		 * We mask out SMPS since even if the hardware
+		 * supports priorities the kernel does not at present
+		 * and we block access to them.
+		 */
+		info->reg_smidr = read_cpuid(SMIDR_EL1) & ~SMIDR_EL1_SMPS;
+	}
+
 	cpuinfo_detect_icache_policy(info);
 }
 


