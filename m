Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2862FA626;
	Tue, 17 Jun 2025 16:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179562; cv=none; b=a7K6kgATAHcMlyBsxYS0S4u3ViYSlvANMB+x4y5fLhLK2bUpj1yopOr4aLeiAZWHgJsxOfbNbTSBNM5UQAq/eZOVFcThoKT+kWyCZwILM5km6fo2c1oGk0TAG7/677q8Zy9VjCm10OSZjcNxYr5JXYFeLuUYcjAnMZsRcU5M+KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179562; c=relaxed/simple;
	bh=GK8mw+ZhsSQf4V3iV09E94VRm/ikTfED4F8qEaDqy0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaHFU6tlCUdExwkWErmrkhK34bZqdRKZm8mrAP+IXy7UuriPWjKOUil8t8wVGaSBwlEeSjAQDoticZQw694njDGUEBx8Pb+R+75nyj9ejI3UO7NM0DAcHMxA1mmpLlsDtUOisyNK3Qe9T9Od85HPNVEtcS/tnvk1rBIYgjhOIVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIZhb9ea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIZhb9ea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EEDC4CEE3;
	Tue, 17 Jun 2025 16:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179562;
	bh=GK8mw+ZhsSQf4V3iV09E94VRm/ikTfED4F8qEaDqy0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIZhb9eaS6RjIU6bcVrvXUuBsVUE0z8hazBtrfa7aMCREqCPidwHHG1gKeG6EU/zg
	 zxbO7o8BRfd7uI7nvz3jF0u2O09wA6tqQs84tk0zmQgtXoV72Y0912Hcd8CDc3FWwI
	 IA3VhuNFZtGitpZAcGlAyHivMSyrNQ/3Dl5Qg+Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Kisel <romank@linux.microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.15 772/780] x86/hyperv: Fix APIC ID and VP index confusion in hv_snp_boot_ap()
Date: Tue, 17 Jun 2025 17:28:00 +0200
Message-ID: <20250617152522.951409048@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Kisel <romank@linux.microsoft.com>

commit 86c48271e0d60c82665e9fd61277002391efcef7 upstream.

To start an application processor in SNP-isolated guest, a hypercall
is used that takes a virtual processor index. The hv_snp_boot_ap()
function uses that START_VP hypercall but passes as VP index to it
what it receives as a wakeup_secondary_cpu_64 callback: the APIC ID.

As those two aren't generally interchangeable, that may lead to hung
APs if the VP index and the APIC ID don't match up.

Update the parameter names to avoid confusion as to what the parameter
is. Use the APIC ID to the VP index conversion to provide the correct
input to the hypercall.

Cc: stable@vger.kernel.org
Fixes: 44676bb9d566 ("x86/hyperv: Add smp support for SEV-SNP guest")
Signed-off-by: Roman Kisel <romank@linux.microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/20250507182227.7421-2-romank@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20250507182227.7421-2-romank@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/hyperv/hv_init.c       |   33 ++++++++++++++++++++++++++++++
 arch/x86/hyperv/hv_vtl.c        |   44 +++++-----------------------------------
 arch/x86/hyperv/ivm.c           |   22 ++++++++++++++++++--
 arch/x86/include/asm/mshyperv.h |    6 +++--
 include/hyperv/hvgdk_mini.h     |    2 -
 5 files changed, 64 insertions(+), 43 deletions(-)

--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -706,3 +706,36 @@ bool hv_is_hyperv_initialized(void)
 	return hypercall_msr.enable;
 }
 EXPORT_SYMBOL_GPL(hv_is_hyperv_initialized);
+
+int hv_apicid_to_vp_index(u32 apic_id)
+{
+	u64 control;
+	u64 status;
+	unsigned long irq_flags;
+	struct hv_get_vp_from_apic_id_in *input;
+	u32 *output, ret;
+
+	local_irq_save(irq_flags);
+
+	input = *this_cpu_ptr(hyperv_pcpu_input_arg);
+	memset(input, 0, sizeof(*input));
+	input->partition_id = HV_PARTITION_ID_SELF;
+	input->apic_ids[0] = apic_id;
+
+	output = *this_cpu_ptr(hyperv_pcpu_output_arg);
+
+	control = HV_HYPERCALL_REP_COMP_1 | HVCALL_GET_VP_INDEX_FROM_APIC_ID;
+	status = hv_do_hypercall(control, input, output);
+	ret = output[0];
+
+	local_irq_restore(irq_flags);
+
+	if (!hv_result_success(status)) {
+		pr_err("failed to get vp index from apic id %d, status %#llx\n",
+		       apic_id, status);
+		return -EINVAL;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hv_apicid_to_vp_index);
--- a/arch/x86/hyperv/hv_vtl.c
+++ b/arch/x86/hyperv/hv_vtl.c
@@ -206,41 +206,9 @@ free_lock:
 	return ret;
 }
 
-static int hv_vtl_apicid_to_vp_id(u32 apic_id)
-{
-	u64 control;
-	u64 status;
-	unsigned long irq_flags;
-	struct hv_get_vp_from_apic_id_in *input;
-	u32 *output, ret;
-
-	local_irq_save(irq_flags);
-
-	input = *this_cpu_ptr(hyperv_pcpu_input_arg);
-	memset(input, 0, sizeof(*input));
-	input->partition_id = HV_PARTITION_ID_SELF;
-	input->apic_ids[0] = apic_id;
-
-	output = *this_cpu_ptr(hyperv_pcpu_output_arg);
-
-	control = HV_HYPERCALL_REP_COMP_1 | HVCALL_GET_VP_ID_FROM_APIC_ID;
-	status = hv_do_hypercall(control, input, output);
-	ret = output[0];
-
-	local_irq_restore(irq_flags);
-
-	if (!hv_result_success(status)) {
-		pr_err("failed to get vp id from apic id %d, status %#llx\n",
-		       apic_id, status);
-		return -EINVAL;
-	}
-
-	return ret;
-}
-
 static int hv_vtl_wakeup_secondary_cpu(u32 apicid, unsigned long start_eip)
 {
-	int vp_id, cpu;
+	int vp_index, cpu;
 
 	/* Find the logical CPU for the APIC ID */
 	for_each_present_cpu(cpu) {
@@ -251,18 +219,18 @@ static int hv_vtl_wakeup_secondary_cpu(u
 		return -EINVAL;
 
 	pr_debug("Bringing up CPU with APIC ID %d in VTL2...\n", apicid);
-	vp_id = hv_vtl_apicid_to_vp_id(apicid);
+	vp_index = hv_apicid_to_vp_index(apicid);
 
-	if (vp_id < 0) {
+	if (vp_index < 0) {
 		pr_err("Couldn't find CPU with APIC ID %d\n", apicid);
 		return -EINVAL;
 	}
-	if (vp_id > ms_hyperv.max_vp_index) {
-		pr_err("Invalid CPU id %d for APIC ID %d\n", vp_id, apicid);
+	if (vp_index > ms_hyperv.max_vp_index) {
+		pr_err("Invalid CPU id %d for APIC ID %d\n", vp_index, apicid);
 		return -EINVAL;
 	}
 
-	return hv_vtl_bringup_vcpu(vp_id, cpu, start_eip);
+	return hv_vtl_bringup_vcpu(vp_index, cpu, start_eip);
 }
 
 int __init hv_vtl_early_init(void)
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -9,6 +9,7 @@
 #include <linux/bitfield.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/cpu.h>
 #include <asm/svm.h>
 #include <asm/sev.h>
 #include <asm/io.h>
@@ -288,7 +289,7 @@ static void snp_cleanup_vmsa(struct sev_
 		free_page((unsigned long)vmsa);
 }
 
-int hv_snp_boot_ap(u32 cpu, unsigned long start_ip)
+int hv_snp_boot_ap(u32 apic_id, unsigned long start_ip)
 {
 	struct sev_es_save_area *vmsa = (struct sev_es_save_area *)
 		__get_free_page(GFP_KERNEL | __GFP_ZERO);
@@ -297,10 +298,27 @@ int hv_snp_boot_ap(u32 cpu, unsigned lon
 	u64 ret, retry = 5;
 	struct hv_enable_vp_vtl *start_vp_input;
 	unsigned long flags;
+	int cpu, vp_index;
 
 	if (!vmsa)
 		return -ENOMEM;
 
+	/* Find the Hyper-V VP index which might be not the same as APIC ID */
+	vp_index = hv_apicid_to_vp_index(apic_id);
+	if (vp_index < 0 || vp_index > ms_hyperv.max_vp_index)
+		return -EINVAL;
+
+	/*
+	 * Find the Linux CPU number for addressing the per-CPU data, and it
+	 * might not be the same as APIC ID.
+	 */
+	for_each_present_cpu(cpu) {
+		if (arch_match_cpu_phys_id(cpu, apic_id))
+			break;
+	}
+	if (cpu >= nr_cpu_ids)
+		return -EINVAL;
+
 	native_store_gdt(&gdtr);
 
 	vmsa->gdtr.base = gdtr.address;
@@ -348,7 +366,7 @@ int hv_snp_boot_ap(u32 cpu, unsigned lon
 	start_vp_input = (struct hv_enable_vp_vtl *)ap_start_input_arg;
 	memset(start_vp_input, 0, sizeof(*start_vp_input));
 	start_vp_input->partition_id = -1;
-	start_vp_input->vp_index = cpu;
+	start_vp_input->vp_index = vp_index;
 	start_vp_input->target_vtl.target_vtl = ms_hyperv.vtl;
 	*(u64 *)&start_vp_input->vp_context = __pa(vmsa) | 1;
 
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -268,11 +268,11 @@ int hv_unmap_ioapic_interrupt(int ioapic
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 bool hv_ghcb_negotiate_protocol(void);
 void __noreturn hv_ghcb_terminate(unsigned int set, unsigned int reason);
-int hv_snp_boot_ap(u32 cpu, unsigned long start_ip);
+int hv_snp_boot_ap(u32 apic_id, unsigned long start_ip);
 #else
 static inline bool hv_ghcb_negotiate_protocol(void) { return false; }
 static inline void hv_ghcb_terminate(unsigned int set, unsigned int reason) {}
-static inline int hv_snp_boot_ap(u32 cpu, unsigned long start_ip) { return 0; }
+static inline int hv_snp_boot_ap(u32 apic_id, unsigned long start_ip) { return 0; }
 #endif
 
 #if defined(CONFIG_AMD_MEM_ENCRYPT) || defined(CONFIG_INTEL_TDX_GUEST)
@@ -306,6 +306,7 @@ static __always_inline u64 hv_raw_get_ms
 {
 	return __rdmsr(reg);
 }
+int hv_apicid_to_vp_index(u32 apic_id);
 
 #else /* CONFIG_HYPERV */
 static inline void hyperv_init(void) {}
@@ -327,6 +328,7 @@ static inline void hv_set_msr(unsigned i
 static inline u64 hv_get_msr(unsigned int reg) { return 0; }
 static inline void hv_set_non_nested_msr(unsigned int reg, u64 value) { }
 static inline u64 hv_get_non_nested_msr(unsigned int reg) { return 0; }
+static inline int hv_apicid_to_vp_index(u32 apic_id) { return -EINVAL; }
 #endif /* CONFIG_HYPERV */
 
 
--- a/include/hyperv/hvgdk_mini.h
+++ b/include/hyperv/hvgdk_mini.h
@@ -475,7 +475,7 @@ union hv_vp_assist_msr_contents {	 /* HV
 #define HVCALL_CREATE_PORT				0x0095
 #define HVCALL_CONNECT_PORT				0x0096
 #define HVCALL_START_VP					0x0099
-#define HVCALL_GET_VP_ID_FROM_APIC_ID			0x009a
+#define HVCALL_GET_VP_INDEX_FROM_APIC_ID			0x009a
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE	0x00af
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST	0x00b0
 #define HVCALL_SIGNAL_EVENT_DIRECT			0x00c0


