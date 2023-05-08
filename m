Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C81168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E381AC433D2;
	Mon,  8 May 2023 09:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539675;
	bh=0LU/QxmSwwgF43C2S8QuXXLFz0QjEk8SxJglLnWEkHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBnqNP4JBHZUtHSSrmgBKsMj2JrYQHUFsI/B9vur3f2SOQI/jLK0DG/+JoqGSwS5d
	 g+qI/U736AAPVmi+N8aImUsiipzz8FpM3veM544TjPj1plp3b6IT3ein3W7j4L/tB7
	 ck6lvFwk/9bsWPiComVlRn4KmIWa76gDAZsvlilY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 100/611] RISC-V: Align SBI probe implementation with spec
Date: Mon,  8 May 2023 11:39:02 +0200
Message-Id: <20230508094425.470961520@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrew Jones <ajones@ventanamicro.com>

commit 41cad8284d5e6bf1d49d3c10a6b52ee1ae866a20 upstream.

sbi_probe_extension() is specified with "Returns 0 if the given SBI
extension ID (EID) is not available, or 1 if it is available unless
defined as any other non-zero value by the implementation."
Additionally, sbiret.value is a long. Fix the implementation to
ensure any nonzero long value is considered a success, rather
than only positive int values.

Fixes: b9dcd9e41587 ("RISC-V: Add basic support for SBI v0.2")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230427163626.101042-1-ajones@ventanamicro.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/sbi.h        |    2 +-
 arch/riscv/kernel/cpu_ops.c         |    2 +-
 arch/riscv/kernel/sbi.c             |   17 ++++++++---------
 arch/riscv/kvm/main.c               |    2 +-
 drivers/cpuidle/cpuidle-riscv-sbi.c |    2 +-
 drivers/perf/riscv_pmu_sbi.c        |    2 +-
 6 files changed, 13 insertions(+), 14 deletions(-)

--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -293,7 +293,7 @@ int sbi_remote_hfence_vvma_asid(const st
 				unsigned long start,
 				unsigned long size,
 				unsigned long asid);
-int sbi_probe_extension(int ext);
+long sbi_probe_extension(int ext);
 
 /* Check if current SBI specification version is 0.1 or not */
 static inline int sbi_spec_is_0_1(void)
--- a/arch/riscv/kernel/cpu_ops.c
+++ b/arch/riscv/kernel/cpu_ops.c
@@ -27,7 +27,7 @@ const struct cpu_operations cpu_ops_spin
 void __init cpu_set_ops(int cpuid)
 {
 #if IS_ENABLED(CONFIG_RISCV_SBI)
-	if (sbi_probe_extension(SBI_EXT_HSM) > 0) {
+	if (sbi_probe_extension(SBI_EXT_HSM)) {
 		if (!cpuid)
 			pr_info("SBI HSM extension detected\n");
 		cpu_ops[cpuid] = &cpu_ops_sbi;
--- a/arch/riscv/kernel/sbi.c
+++ b/arch/riscv/kernel/sbi.c
@@ -581,19 +581,18 @@ static void sbi_srst_power_off(void)
  * sbi_probe_extension() - Check if an SBI extension ID is supported or not.
  * @extid: The extension ID to be probed.
  *
- * Return: Extension specific nonzero value f yes, -ENOTSUPP otherwise.
+ * Return: 1 or an extension specific nonzero value if yes, 0 otherwise.
  */
-int sbi_probe_extension(int extid)
+long sbi_probe_extension(int extid)
 {
 	struct sbiret ret;
 
 	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, extid,
 			0, 0, 0, 0, 0);
 	if (!ret.error)
-		if (ret.value)
-			return ret.value;
+		return ret.value;
 
-	return -ENOTSUPP;
+	return 0;
 }
 EXPORT_SYMBOL(sbi_probe_extension);
 
@@ -662,26 +661,26 @@ void __init sbi_init(void)
 	if (!sbi_spec_is_0_1()) {
 		pr_info("SBI implementation ID=0x%lx Version=0x%lx\n",
 			sbi_get_firmware_id(), sbi_get_firmware_version());
-		if (sbi_probe_extension(SBI_EXT_TIME) > 0) {
+		if (sbi_probe_extension(SBI_EXT_TIME)) {
 			__sbi_set_timer = __sbi_set_timer_v02;
 			pr_info("SBI TIME extension detected\n");
 		} else {
 			__sbi_set_timer = __sbi_set_timer_v01;
 		}
-		if (sbi_probe_extension(SBI_EXT_IPI) > 0) {
+		if (sbi_probe_extension(SBI_EXT_IPI)) {
 			__sbi_send_ipi	= __sbi_send_ipi_v02;
 			pr_info("SBI IPI extension detected\n");
 		} else {
 			__sbi_send_ipi	= __sbi_send_ipi_v01;
 		}
-		if (sbi_probe_extension(SBI_EXT_RFENCE) > 0) {
+		if (sbi_probe_extension(SBI_EXT_RFENCE)) {
 			__sbi_rfence	= __sbi_rfence_v02;
 			pr_info("SBI RFENCE extension detected\n");
 		} else {
 			__sbi_rfence	= __sbi_rfence_v01;
 		}
 		if ((sbi_spec_version >= sbi_mk_version(0, 3)) &&
-		    (sbi_probe_extension(SBI_EXT_SRST) > 0)) {
+		    sbi_probe_extension(SBI_EXT_SRST)) {
 			pr_info("SBI SRST extension detected\n");
 			pm_power_off = sbi_srst_power_off;
 			sbi_srst_reboot_nb.notifier_call = sbi_srst_reboot;
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -84,7 +84,7 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
-	if (sbi_probe_extension(SBI_EXT_RFENCE) <= 0) {
+	if (!sbi_probe_extension(SBI_EXT_RFENCE)) {
 		kvm_info("require SBI RFENCE extension\n");
 		return -ENODEV;
 	}
--- a/drivers/cpuidle/cpuidle-riscv-sbi.c
+++ b/drivers/cpuidle/cpuidle-riscv-sbi.c
@@ -612,7 +612,7 @@ static int __init sbi_cpuidle_init(void)
 	 * 2) SBI HSM extension is available
 	 */
 	if ((sbi_spec_version < sbi_mk_version(0, 3)) ||
-	    sbi_probe_extension(SBI_EXT_HSM) <= 0) {
+	    !sbi_probe_extension(SBI_EXT_HSM)) {
 		pr_info("HSM suspend not available\n");
 		return 0;
 	}
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -869,7 +869,7 @@ static int __init pmu_sbi_devinit(void)
 	struct platform_device *pdev;
 
 	if (sbi_spec_version < sbi_mk_version(0, 3) ||
-	    sbi_probe_extension(SBI_EXT_PMU) <= 0) {
+	    !sbi_probe_extension(SBI_EXT_PMU)) {
 		return 0;
 	}
 


