Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984ED1B4F0A;
	Fri, 21 Nov 2025 13:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731381; cv=none; b=IyQNOKt+55bnacxLFV+iwF99WjMNReZyk88Vmmm8ZF8GoPBhVaKbmj5qVyXt0vCwkuigAL+psSceUatxONOOwGNpM86ZuGSbkFNVQ5MUCfgHnVqGvNx6R2xm8ecPlYMmQWvS7KyH/tywV/FPnZpyY0x6UbPBVrXlvfr5z2VV6o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731381; c=relaxed/simple;
	bh=0fryPIQ+UmKHGeAOwfPcvkPELPeO3K5Q7zhm9219pTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwOg6jZjubIT4dre/DUqjC2McpJTdIBIex/GNFvnd7JvL8kk4OCEChlK9E1ewfvVB/PynjntNyS8/Qf70ierswlMyXyvwYXGlRRVB4vyTyG866whR9kAVn9eKH7RUeR4uJMGur1aQydA9rG1r09TceKi44395np6mfnhETaBYoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2tyDqnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2tyDqnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4DBC4CEFB;
	Fri, 21 Nov 2025 13:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731381;
	bh=0fryPIQ+UmKHGeAOwfPcvkPELPeO3K5Q7zhm9219pTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2tyDqnrSM4ULHdTr+E9aYDzm4KDFzfTZu8Tjy5UdzSEeNN0S03XRa/pllLuBiyDZ
	 GBLcsIK3UYVVjW+tPk185fJGKQriDrKGgdPsiP0M37s9YH2od7oAE2PW93pWzgjcZt
	 WWoUK9VVleVOCIY171GipYeOjICgsbnxqEjjZHBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.17 156/247] KVM: nSVM: Fix and simplify LBR virtualization handling with nested
Date: Fri, 21 Nov 2025 14:11:43 +0100
Message-ID: <20251121130200.321619057@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry.ahmed@linux.dev>

commit 8a4821412cf2c1429fffa07c012dd150f2edf78c upstream.

The current scheme for handling LBRV when nested is used is very
complicated, especially when L1 does not enable LBRV (i.e. does not set
LBR_CTL_ENABLE_MASK).

To avoid copying LBRs between VMCB01 and VMCB02 on every nested
transition, the current implementation switches between using VMCB01 or
VMCB02 as the source of truth for the LBRs while L2 is running. If L2
enables LBR, VMCB02 is used as the source of truth. When L2 disables
LBR, the LBRs are copied to VMCB01 and VMCB01 is used as the source of
truth. This introduces significant complexity, and incorrect behavior in
some cases.

For example, on a nested #VMEXIT, the LBRs are only copied from VMCB02
to VMCB01 if LBRV is enabled in VMCB01. This is because L2's writes to
MSR_IA32_DEBUGCTLMSR to enable LBR are intercepted and propagated to
VMCB01 instead of VMCB02. However, LBRV is only enabled in VMCB02 when
L2 is running.

This means that if L2 enables LBR and exits to L1, the LBRs will not be
propagated from VMCB02 to VMCB01, because LBRV is disabled in VMCB01.

There is no meaningful difference in CPUID rate in L2 when copying LBRs
on every nested transition vs. the current approach, so do the simple
and correct thing and always copy LBRs between VMCB01 and VMCB02 on
nested transitions (when LBRV is disabled by L1). Drop the conditional
LBRs copying in __svm_{enable/disable}_lbrv() as it is now unnecessary.

VMCB02 becomes the only source of truth for LBRs when L2 is running,
regardless of LBRV being enabled by L1, drop svm_get_lbr_vmcb() and use
svm->vmcb directly in its place.

Fixes: 1d5a1b5860ed ("KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://patch.msgid.link/20251108004524.1600006-4-yosry.ahmed@linux.dev
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |   20 +++++++-------------
 arch/x86/kvm/svm/svm.c    |   46 ++++++++++------------------------------------
 2 files changed, 17 insertions(+), 49 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -669,11 +669,10 @@ static void nested_vmcb02_prepare_save(s
 		 */
 		svm_copy_lbrs(vmcb02, vmcb12);
 		vmcb02->save.dbgctl &= ~DEBUGCTL_RESERVED_BITS;
-		svm_update_lbrv(&svm->vcpu);
-
-	} else if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
+	} else {
 		svm_copy_lbrs(vmcb02, vmcb01);
 	}
+	svm_update_lbrv(&svm->vcpu);
 }
 
 static inline bool is_evtinj_soft(u32 evtinj)
@@ -825,11 +824,7 @@ static void nested_vmcb02_prepare_contro
 			svm->soft_int_next_rip = vmcb12_rip;
 	}
 
-	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
-					      LBR_CTL_ENABLE_MASK;
-	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV))
-		vmcb02->control.virt_ext  |=
-			(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK);
+	/* LBR_CTL_ENABLE_MASK is controlled by svm_update_lbrv() */
 
 	if (!nested_vmcb_needs_vls_intercept(svm))
 		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
@@ -1169,13 +1164,12 @@ int nested_svm_vmexit(struct vcpu_svm *s
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 
 	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK)))
 		svm_copy_lbrs(vmcb12, vmcb02);
-		svm_update_lbrv(vcpu);
-	} else if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
+	else
 		svm_copy_lbrs(vmcb01, vmcb02);
-		svm_update_lbrv(vcpu);
-	}
+
+	svm_update_lbrv(vcpu);
 
 	if (vnmi) {
 		if (vmcb02->control.int_ctl & V_NMI_BLOCKING_MASK)
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -854,13 +854,7 @@ void svm_copy_lbrs(struct vmcb *to_vmcb,
 
 static void __svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
-
-	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
-	if (is_guest_mode(vcpu))
-		svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
+	to_svm(vcpu)->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
 }
 
 void svm_enable_lbrv(struct kvm_vcpu *vcpu)
@@ -871,35 +865,15 @@ void svm_enable_lbrv(struct kvm_vcpu *vc
 
 static void __svm_disable_lbrv(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-
 	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
-	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
-
-	/*
-	 * Move the LBR msrs back to the vmcb01 to avoid copying them
-	 * on nested guest entries.
-	 */
-	if (is_guest_mode(vcpu))
-		svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
-}
-
-static struct vmcb *svm_get_lbr_vmcb(struct vcpu_svm *svm)
-{
-	/*
-	 * If LBR virtualization is disabled, the LBR MSRs are always kept in
-	 * vmcb01.  If LBR virtualization is enabled and L1 is running VMs of
-	 * its own, the MSRs are moved between vmcb01 and vmcb02 as needed.
-	 */
-	return svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK ? svm->vmcb :
-								   svm->vmcb01.ptr;
+	to_svm(vcpu)->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
 }
 
 void svm_update_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
-	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
+	bool enable_lbrv = (svm->vmcb->save.dbgctl & DEBUGCTLMSR_LBR) ||
 			    (is_guest_mode(vcpu) && guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
 			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
 
@@ -2785,19 +2759,19 @@ static int svm_get_msr(struct kvm_vcpu *
 		msr_info->data = svm->tsc_aux;
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
-		msr_info->data = svm_get_lbr_vmcb(svm)->save.dbgctl;
+		msr_info->data = svm->vmcb->save.dbgctl;
 		break;
 	case MSR_IA32_LASTBRANCHFROMIP:
-		msr_info->data = svm_get_lbr_vmcb(svm)->save.br_from;
+		msr_info->data = svm->vmcb->save.br_from;
 		break;
 	case MSR_IA32_LASTBRANCHTOIP:
-		msr_info->data = svm_get_lbr_vmcb(svm)->save.br_to;
+		msr_info->data = svm->vmcb->save.br_to;
 		break;
 	case MSR_IA32_LASTINTFROMIP:
-		msr_info->data = svm_get_lbr_vmcb(svm)->save.last_excp_from;
+		msr_info->data = svm->vmcb->save.last_excp_from;
 		break;
 	case MSR_IA32_LASTINTTOIP:
-		msr_info->data = svm_get_lbr_vmcb(svm)->save.last_excp_to;
+		msr_info->data = svm->vmcb->save.last_excp_to;
 		break;
 	case MSR_VM_HSAVE_PA:
 		msr_info->data = svm->nested.hsave_msr;
@@ -3053,10 +3027,10 @@ static int svm_set_msr(struct kvm_vcpu *
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
-		if (svm_get_lbr_vmcb(svm)->save.dbgctl == data)
+		if (svm->vmcb->save.dbgctl == data)
 			break;
 
-		svm_get_lbr_vmcb(svm)->save.dbgctl = data;
+		svm->vmcb->save.dbgctl = data;
 		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
 		svm_update_lbrv(vcpu);
 		break;


