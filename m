Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FC9347BCB;
	Wed,  3 Dec 2025 16:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780902; cv=none; b=MnLgStP3s2qvCi/rPwceCb3JhULwtkCcWkJWyNs5mdcz04HhaxBhzw8iuEgitbdBf2XGrztlBB9GbTrE8cBmPqR/1enkVO1gtnpOM/NfMEsEeHozkcCcxfa8ZIJVZG8BdR4nRic97TlvJvIoSCUU5Y79N0mK0f/GBbLfmzjqwow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780902; c=relaxed/simple;
	bh=+VFVh7Rtf4Q5SnzMvjHBixCrIDaWiSVAuODN3zmMVgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jy0RPqEJc/93TcUDADoNk926xVLBLdwsGrsUAaTKDhFrZ2NZKhHYaidG0Ct606osQ7161Vz1v7PFS2qUKwLOPnot5YmcYonwFG5+kbydRsSxabfucS0M/BdzvFUq9b947QJCqMERYzp301sDi1tvtUMh9PRY4wk5RrX5xjqNH7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcFaUFtZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcFaUFtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D602AC4CEF5;
	Wed,  3 Dec 2025 16:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780902;
	bh=+VFVh7Rtf4Q5SnzMvjHBixCrIDaWiSVAuODN3zmMVgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcFaUFtZyMqjBIkml+2hir/QarU/I1o7VgNhRcS5i51sIUqoRO2rW9QmA0pTQvmTR
	 FJUV6h/aKhhtaaszpCE2iejZtXh0qXIWjriVOJfoGSuRaZPqoSCQBnXOSBpAyWFTWM
	 8Noa8swcMwJGb0fQbEv+0sU1Z9K5usOIrN5PtEKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 123/132] KVM: nSVM: Fix and simplify LBR virtualization handling with nested
Date: Wed,  3 Dec 2025 16:30:02 +0100
Message-ID: <20251203152347.869961220@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |   20 ++++++-------------
 arch/x86/kvm/svm/svm.c    |   47 +++++++++-------------------------------------
 2 files changed, 17 insertions(+), 50 deletions(-)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -602,11 +602,10 @@ static void nested_vmcb02_prepare_save(s
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
@@ -731,11 +730,7 @@ static void nested_vmcb02_prepare_contro
 			svm->soft_int_next_rip = vmcb12_rip;
 	}
 
-	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
-					      LBR_CTL_ENABLE_MASK;
-	if (guest_can_use(vcpu, X86_FEATURE_LBRV))
-		vmcb02->control.virt_ext  |=
-			(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK);
+	/* LBR_CTL_ENABLE_MASK is controlled by svm_update_lbrv() */
 
 	if (!nested_vmcb_needs_vls_intercept(svm))
 		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
@@ -1066,13 +1061,12 @@ int nested_svm_vmexit(struct vcpu_svm *s
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 
 	if (unlikely(guest_can_use(vcpu, X86_FEATURE_LBRV) &&
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
@@ -1016,13 +1016,7 @@ static void svm_recalc_lbr_msr_intercept
 
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
@@ -1033,36 +1027,15 @@ void svm_enable_lbrv(struct kvm_vcpu *vc
 
 static void __svm_disable_lbrv(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_svm *svm = to_svm(vcpu);
-
 	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
-
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
 			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
 			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
 
@@ -2991,19 +2964,19 @@ static int svm_get_msr(struct kvm_vcpu *
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
@@ -3276,10 +3249,10 @@ static int svm_set_msr(struct kvm_vcpu *
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


