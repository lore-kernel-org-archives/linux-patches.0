Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91EF81ADA;
	Tue,  3 Dec 2024 16:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242261; cv=none; b=C4yn5Coe4IvW6d2nALNWM1AGigmD3RadsA8ChVyAHs6xvter/ayxLI7IspSSXURrZshF5mu6oSwS57XtY7OSc3wubw3viPIkpyooh4pEdkMuvGEeJmkJHiUtf5t4ZJSXkordkNk+q+BIp88D3F2KYGvVpNNGDha5sjXV2gUBxnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242261; c=relaxed/simple;
	bh=BGo/k75ilDtKhGO9TzvSXzzzq2/UMRfULU7Or+we0Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqi+5Y3H01Q7tdMQ6pt+S2zX/ljPW9LBLe7d5ra/9hB1MoCs0LNa60tQFxuTe6CM93JjvrzJTOdkBMldT/I6lWaKIAJHVju7FtQDzn7qnXYqD4N9WWGys/UDI3zCihFhFPvQzjRKvtr8bSELeKwrdX51WHHE0lVUgVMHFyYik+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xazpxW9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xazpxW9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4516BC4CECF;
	Tue,  3 Dec 2024 16:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242261;
	bh=BGo/k75ilDtKhGO9TzvSXzzzq2/UMRfULU7Or+we0Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xazpxW9S94DpuKSqBGhBEd7ovIEA7bC6Yk5jtGhfmKrWTWo+qeRNq0tl2vK+T2f+9
	 /N5IxKn17ld3NLdYDNBVW91QteXm9Sf1scmWqmHVj2mmo+YBxW9oIHCDS2NHNDcyTK
	 lSGL6vPpy/ZBHCvAQPj2NVIULaxU+hIRPCRivJbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 647/826] Revert "KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL errata handling out of setup_vmcs_config()"
Date: Tue,  3 Dec 2024 15:46:14 +0100
Message-ID: <20241203144808.986402378@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 85434c3c73fcad58870016ddfe5eaa5036672675 upstream.

Revert back to clearing VM_{ENTRY,EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL in KVM's
golden VMCS config, as applying the workaround during vCPU creation is
pointless and broken.  KVM *unconditionally* clears the controls in the
values returned by vmx_vmentry_ctrl() and vmx_vmexit_ctrl(), as KVM loads
PERF_GLOBAL_CTRL if and only if its necessary to do so.  E.g. if KVM wants
to run the guest with the same PERF_GLOBAL_CTRL as the host, then there's
no need to re-load the MSR on entry and exit.

Even worse, the buggy commit failed to apply the erratum where it's
actually needed, add_atomic_switch_msr().  As a result, KVM completely
ignores the erratum for all intents and purposes, i.e. uses the flawed
VMCS controls to load PERF_GLOBAL_CTRL.

To top things off, the patch was intended to be dropped, as the premise
of an L1 VMM being able to pivot on FMS is flawed, and KVM can (and now
does) fully emulate the controls in software.  Simply revert the commit,
as all upstream supported kernels that have the buggy commit should also
have commit f4c93d1a0e71 ("KVM: nVMX: Always emulate PERF_GLOBAL_CTRL
VM-Entry/VM-Exit controls"), i.e. the (likely theoretical) live migration
concern is a complete non-issue.

Opportunistically drop the manual "kvm: " scope from the warning about
the erratum, as KVM now uses pr_fmt() to provide the correct scope (v6.1
kernels and earlier don't, but the erratum only applies to CPUs that are
15+ years old; it's not worth a separate patch).

This reverts commit 9d78d6fb186bc4aff41b5d6c4726b76649d3cb53.

Link: https://lore.kernel.org/all/YtnZmCutdd5tpUmz@google.com
Fixes: 9d78d6fb186b ("KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL errata handling out of setup_vmcs_config()")
Cc: stable@vger.kernel.org
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-ID: <20241119011433.1797921-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |   54 +++++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 33 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2551,28 +2551,6 @@ static bool cpu_has_sgx(void)
 	return cpuid_eax(0) >= 0x12 && (cpuid_eax(0x12) & BIT(0));
 }
 
-/*
- * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
- * can't be used due to errata where VM Exit may incorrectly clear
- * IA32_PERF_GLOBAL_CTRL[34:32]. Work around the errata by using the
- * MSR load mechanism to switch IA32_PERF_GLOBAL_CTRL.
- */
-static bool cpu_has_perf_global_ctrl_bug(void)
-{
-	switch (boot_cpu_data.x86_vfm) {
-	case INTEL_NEHALEM_EP:	/* AAK155 */
-	case INTEL_NEHALEM:	/* AAP115 */
-	case INTEL_WESTMERE:	/* AAT100 */
-	case INTEL_WESTMERE_EP:	/* BC86,AAY89,BD102 */
-	case INTEL_NEHALEM_EX:	/* BA97 */
-		return true;
-	default:
-		break;
-	}
-
-	return false;
-}
-
 static int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt, u32 msr, u32 *result)
 {
 	u32 vmx_msr_low, vmx_msr_high;
@@ -2732,6 +2710,27 @@ static int setup_vmcs_config(struct vmcs
 		_vmexit_control &= ~x_ctrl;
 	}
 
+	/*
+	 * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
+	 * can't be used due to an errata where VM Exit may incorrectly clear
+	 * IA32_PERF_GLOBAL_CTRL[34:32].  Workaround the errata by using the
+	 * MSR load mechanism to switch IA32_PERF_GLOBAL_CTRL.
+	 */
+	switch (boot_cpu_data.x86_vfm) {
+	case INTEL_NEHALEM_EP:	/* AAK155 */
+	case INTEL_NEHALEM:	/* AAP115 */
+	case INTEL_WESTMERE:	/* AAT100 */
+	case INTEL_WESTMERE_EP:	/* BC86,AAY89,BD102 */
+	case INTEL_NEHALEM_EX:	/* BA97 */
+		_vmentry_control &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		_vmexit_control &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		pr_warn_once("VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
+			     "does not work properly. Using workaround\n");
+		break;
+	default:
+		break;
+	}
+
 	rdmsrl(MSR_IA32_VMX_BASIC, basic_msr);
 
 	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
@@ -4422,9 +4421,6 @@ static u32 vmx_vmentry_ctrl(void)
 			  VM_ENTRY_LOAD_IA32_EFER |
 			  VM_ENTRY_IA32E_MODE);
 
-	if (cpu_has_perf_global_ctrl_bug())
-		vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
-
 	return vmentry_ctrl;
 }
 
@@ -4442,10 +4438,6 @@ static u32 vmx_vmexit_ctrl(void)
 	if (vmx_pt_mode_is_system())
 		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
 				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
-
-	if (cpu_has_perf_global_ctrl_bug())
-		vmexit_ctrl &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
-
 	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
 	return vmexit_ctrl &
 		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
@@ -8400,10 +8392,6 @@ __init int vmx_hardware_setup(void)
 	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
 		return -EIO;
 
-	if (cpu_has_perf_global_ctrl_bug())
-		pr_warn_once("VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
-			     "does not work properly. Using workaround\n");
-
 	if (boot_cpu_has(X86_FEATURE_NX))
 		kvm_enable_efer_bits(EFER_NX);
 


