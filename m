Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C6D4EFFB7;
	Tue, 13 Oct 2026 11:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892055; cv=none; b=ZCEUxLbgf8EDyut1i4crhupie+7ILl0WOvH9M3Lt9LS5Ahw+vBPd2yCxhm1RV1p47bUBR7+188RKfmCQHHPKtRG0BpiuSjXnuYL4LDW8RycHY8TrMc09W4X4sC7k+anuU/8B0lk5/SpTOFFydX5/InMVI63J/fT+Vk3cRFKwB7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892055; c=relaxed/simple;
	bh=vWBmoFq/ys701GZR2m/byE00uXH2ibt1orx9TKoVm7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFxlZqDREHJDNUjNzhfBymnblyc2O9VSoDTxnoDhwHEYyYnTefMB4LTtQUHN6uCuePXwu8WpvAe7QjM04kzP510jm3GtsDVvdaGB3yxQ8JQPN/vc255J11Swwh7GW7ratjPV7ysmhNuGWVFoOHdnu8Q2Od1pozkW7ZEd8TlFmkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ngz/WhvF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ngz/WhvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC89C1F000FF;
	Tue, 13 Oct 2026 11:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892054;
	bh=QZzExc7zaHAmfh6eE/egofrRYMRswCoe0urRtyfKRu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ngz/WhvFOPMXBLEVB+yfMZH1jLAFIHX5EQLzBwuvn0Vk9yqaU5kAG2sgjhrZFJ9+6
	 tuleyRIe5KB6ElHaInv2GJvxWe8wOkJA45EzjFg67tTbQ851mk2b4naIaYaxXhc9f+
	 fqdQCiwV9etBzNfkeYUHn8PQXlFcjUzDP8Yp4c6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.2 046/281] RISC-V: Clear HSTATUS.HU on CPU initialization
Date: Tue, 13 Oct 2026 13:36:02 +0200
Message-ID: <20261013112856.169944981@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

commit 6694612317e5225086e39ca1ba97ada2b1942e48 upstream.

The RISC-V privileged specification does not mandate HSTATUS reset
values, leaving the HU bit potentially set after hardware reset.
When HU=1, hypervisor instructions (HLV/HLVX/HSV) can execute in
U-mode to access guest memory, which may cause unintended behavior
if not explicitly controlled.

Clear HSTATUS.HU during CPU initialization to ensure hypervisor
instructions are only available in HS-mode, preventing unexpected
guest memory access from U-mode code.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://patch.msgid.link/20260924-hstatus_hu-v2-1-7e970f5f1d8d@sifive.com
Cc: stable@vger.kernel.org
[pjw@kernel.org: capitalized RISCV_ISA_EXT_h to fix build; added stable cc]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/cpufeature.h |    2 ++
 arch/riscv/kernel/cpufeature.c      |   12 ++++++++++++
 arch/riscv/kernel/setup.c           |    2 ++
 arch/riscv/kernel/smpboot.c         |    2 ++
 arch/riscv/kernel/suspend.c         |    2 ++
 5 files changed, 20 insertions(+)

--- a/arch/riscv/include/asm/cpufeature.h
+++ b/arch/riscv/include/asm/cpufeature.h
@@ -40,6 +40,8 @@ extern u32 thead_vlenb_of;
 
 void __init riscv_user_isa_enable(void);
 
+void riscv_clear_hypervisor_csr(void);
+
 #define _RISCV_ISA_EXT_DATA(_name, _id, _subset_exts, _subset_exts_size, _validate) {	\
 	.name = #_name,									\
 	.property = #_name,								\
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -1184,6 +1184,18 @@ void __init riscv_user_isa_enable(void)
 		pr_warn("Zicbop disabled as it is unavailable on some harts\n");
 }
 
+void riscv_clear_hypervisor_csr(void)
+{
+	if (!riscv_has_extension_unlikely(RISCV_ISA_EXT_H))
+		return;
+
+	/*
+	 * Clear HSTATUS.HU to restrict hypervisor instructions to HS-mode.
+	 * This prevents user-mode from executing HLV/HSV instructions.
+	 */
+	csr_clear(CSR_HSTATUS, HSTATUS_HU);
+}
+
 #ifdef CONFIG_RISCV_ALTERNATIVE
 /*
  * Alternative patch sites consider 48 bits when determining when to patch
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -364,6 +364,8 @@ void __init setup_arch(char **cmdline_p)
 
 	if (!IS_ENABLED(CONFIG_RISCV_ISA_ZBB) || !riscv_isa_extension_available(NULL, ZBB))
 		static_branch_disable(&efficient_ffs_key);
+
+	riscv_clear_hypervisor_csr();
 }
 
 bool arch_cpu_is_hotpluggable(int cpu)
--- a/arch/riscv/kernel/smpboot.c
+++ b/arch/riscv/kernel/smpboot.c
@@ -244,6 +244,8 @@ asmlinkage __visible void smp_callin(voi
 
 	numa_add_cpu(curr_cpuid);
 
+	riscv_clear_hypervisor_csr();
+
 	pr_debug("CPU%u: Booted secondary hartid %lu\n", curr_cpuid,
 		cpuid_to_hartid_map(curr_cpuid));
 
--- a/arch/riscv/kernel/suspend.c
+++ b/arch/riscv/kernel/suspend.c
@@ -43,6 +43,8 @@ void suspend_save_csrs(struct suspend_co
 
 void suspend_restore_csrs(struct suspend_context *context)
 {
+	riscv_clear_hypervisor_csr();
+
 	csr_write(CSR_SCRATCH, 0);
 	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_XLINUXENVCFG))
 		csr_write(CSR_ENVCFG, context->envcfg);


