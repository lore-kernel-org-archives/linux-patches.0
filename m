Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123E72584
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4D7C433D2;
	Thu, 23 Feb 2023 13:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157890;
	bh=gs+G/0ZKCYZx9olu3Obeo2nWpZlFCLaGk9k74HjWiXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPAbJvnhcnCp5Ttg0P9WWpk9MqU8PjF9RTXZ19ANrML8Ning8As2QSICWY+0STafu
	 pZLmr/qyTQ4yr21SwIrQv6SOIoNbAyBGzI4l5AWiW5rPCIFyOIO4LDj/gPLOssXyU2
	 2wDahYr0ZrScdISgjzgfSBgZTmFHxtg4CX8iLH/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Jim Mattson <jmattson@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/36] KVM: VMX: Execute IBPB on emulated VM-exit when guest has IBRS
Date: Thu, 23 Feb 2023 14:06:49 +0100
Message-Id: <20230223130429.687534575@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 2e7eab81425ad6c875f2ed47c0ce01e78afc38a5 ]

According to Intel's document on Indirect Branch Restricted
Speculation, "Enabling IBRS does not prevent software from controlling
the predicted targets of indirect branches of unrelated software
executed later at the same predictor mode (for example, between two
different user applications, or two different virtual machines). Such
isolation can be ensured through use of the Indirect Branch Predictor
Barrier (IBPB) command." This applies to both basic and enhanced IBRS.

Since L1 and L2 VMs share hardware predictor modes (guest-user and
guest-kernel), hardware IBRS is not sufficient to virtualize
IBRS. (The way that basic IBRS is implemented on pre-eIBRS parts,
hardware IBRS is actually sufficient in practice, even though it isn't
sufficient architecturally.)

For virtual CPUs that support IBRS, add an indirect branch prediction
barrier on emulated VM-exit, to ensure that the predicted targets of
indirect branches executed in L1 cannot be controlled by software that
was executed in L2.

Since we typically don't intercept guest writes to IA32_SPEC_CTRL,
perform the IBPB at emulated VM-exit regardless of the current
IA32_SPEC_CTRL.IBRS value, even though the IBPB could technically be
deferred until L1 sets IA32_SPEC_CTRL.IBRS, if IA32_SPEC_CTRL.IBRS is
clear at emulated VM-exit.

This is CVE-2022-2196.

Fixes: 5c911beff20a ("KVM: nVMX: Skip IBPB when switching between vmcs01 and vmcs02")
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20221019213620.1953281-3-jmattson@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 11 +++++++++++
 arch/x86/kvm/vmx/vmx.c    |  6 ++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cdebeceedbd06..f3c136548af69 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4617,6 +4617,17 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 	vmx_switch_vmcs(vcpu, &vmx->vmcs01);
 
+	/*
+	 * If IBRS is advertised to the vCPU, KVM must flush the indirect
+	 * branch predictors when transitioning from L2 to L1, as L1 expects
+	 * hardware (KVM in this case) to provide separate predictor modes.
+	 * Bare metal isolates VMX root (host) from VMX non-root (guest), but
+	 * doesn't isolate different VMCSs, i.e. in this case, doesn't provide
+	 * separate modes for L2 vs L1.
+	 */
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		indirect_branch_prediction_barrier();
+
 	/* Update any VMCS fields that might have changed while L2 ran */
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0718658268fef..c849173b60c27 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1332,8 +1332,10 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 
 		/*
 		 * No indirect branch prediction barrier needed when switching
-		 * the active VMCS within a guest, e.g. on nested VM-Enter.
-		 * The L1 VMM can protect itself with retpolines, IBPB or IBRS.
+		 * the active VMCS within a vCPU, unless IBRS is advertised to
+		 * the vCPU.  To minimize the number of IBPBs executed, KVM
+		 * performs IBPB on nested VM-Exit (a single nested transition
+		 * may switch the active VMCS multiple times).
 		 */
 		if (!buddy || WARN_ON_ONCE(buddy->vmcs != prev))
 			indirect_branch_prediction_barrier();
-- 
2.39.0



