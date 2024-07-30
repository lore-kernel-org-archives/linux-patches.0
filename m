Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33D81A76A1;
	Tue, 30 Jul 2024 17:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360328; cv=none; b=miQdxu8pxr2MpksL3XMVaPkZ0vV9q9wIX4RIng3Sz4JNf6wzCWqN/2OSIKFlTV6RiLrCU1efv4c9S6KxVhDSyLDaTD6ZPkCdEJeH7aQU9yvzCRXzr3kHro4sneozyuh9yvN2sSFa3rqzT0Oau8KRAQYDdT3DOCMn8AnRehQfTkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360328; c=relaxed/simple;
	bh=EtmjBassc0WXEX5pnEMnbHFFFFAotejW/FJwdvJA3jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlVQvBSxZnmooDn1/fgdm0uiOZFpg8RmAred5gMGFyuVv/78gn1YHX3WehTvfJ9oj75pO+XTL7OX52DGsbUOqnsX64PE6iMaA+hBs2WFMzr8XzWuKR3OzFNNLjOTYu/o7T9n6I+4PKJ2Lnu190T0568kwD0+N35nYZlZc1YvpHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9BzZBkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9BzZBkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239F3C32782;
	Tue, 30 Jul 2024 17:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360328;
	bh=EtmjBassc0WXEX5pnEMnbHFFFFAotejW/FJwdvJA3jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9BzZBkHSzhodCVP6wYZ0bGHKIFHBU3xInb97F1DcGM0YVYFP211HJ5mbFLd2Uw7O
	 ZQ/XqoDVdlpFeQ5MAaAkdVyq2otT/DByhE47vignwIs0Ifkuphh/5ah+z+XKSx8z17
	 zZEAGw1uaWR0o0AcWhLa6lce6oWmsKpaQty2u8sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.10 624/809] KVM: nVMX: Fold requested virtual interrupt check into has_nested_events()
Date: Tue, 30 Jul 2024 17:48:20 +0200
Message-ID: <20240730151749.486701829@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 321ef62b0c5f6f57bb8500a2ca5986052675abbf upstream.

Check for a Requested Virtual Interrupt, i.e. a virtual interrupt that is
pending delivery, in vmx_has_nested_events() and drop the one-off
kvm_x86_ops.guest_apic_has_interrupt() hook.

In addition to dropping a superfluous hook, this fixes a bug where KVM
would incorrectly treat virtual interrupts _for L2_ as always enabled due
to kvm_arch_interrupt_allowed(), by way of vmx_interrupt_blocked(),
treating IRQs as enabled if L2 is active and vmcs12 is configured to exit
on IRQs, i.e. KVM would treat a virtual interrupt for L2 as a valid wake
event based on L1's IRQ blocking status.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240607172609.3205077-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm-x86-ops.h |    1 -
 arch/x86/include/asm/kvm_host.h    |    1 -
 arch/x86/kvm/vmx/main.c            |    1 -
 arch/x86/kvm/vmx/nested.c          |    4 ++++
 arch/x86/kvm/vmx/vmx.c             |   20 --------------------
 arch/x86/kvm/vmx/x86_ops.h         |    1 -
 arch/x86/kvm/x86.c                 |   10 +---------
 7 files changed, 5 insertions(+), 33 deletions(-)

--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -85,7 +85,6 @@ KVM_X86_OP_OPTIONAL(update_cr8_intercept
 KVM_X86_OP(refresh_apicv_exec_ctrl)
 KVM_X86_OP_OPTIONAL(hwapic_irr_update)
 KVM_X86_OP_OPTIONAL(hwapic_isr_update)
-KVM_X86_OP_OPTIONAL_RET0(guest_apic_has_interrupt)
 KVM_X86_OP_OPTIONAL(load_eoi_exitmap)
 KVM_X86_OP_OPTIONAL(set_virtual_apic_mode)
 KVM_X86_OP_OPTIONAL(set_apic_access_page_addr)
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1714,7 +1714,6 @@ struct kvm_x86_ops {
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(int isr);
-	bool (*guest_apic_has_interrupt)(struct kvm_vcpu *vcpu);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
 	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -97,7 +97,6 @@ struct kvm_x86_ops vt_x86_ops __initdata
 	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
 	.hwapic_irr_update = vmx_hwapic_irr_update,
 	.hwapic_isr_update = vmx_hwapic_isr_update,
-	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
 	.sync_pir_to_irr = vmx_sync_pir_to_irr,
 	.deliver_interrupt = vmx_deliver_interrupt,
 	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4060,6 +4060,10 @@ static bool vmx_has_nested_events(struct
 
 	vppr = *((u32 *)(vapic + APIC_PROCPRI));
 
+	max_irr = vmx_get_rvi();
+	if ((max_irr & 0xf0) > (vppr & 0xf0))
+		return true;
+
 	if (vmx->nested.pi_pending && vmx->nested.pi_desc &&
 	    pi_test_on(vmx->nested.pi_desc)) {
 		max_irr = pi_find_highest_vector(vmx->nested.pi_desc);
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4108,26 +4108,6 @@ void pt_update_intercept_for_msr(struct
 	}
 }
 
-bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	void *vapic_page;
-	u32 vppr;
-	int rvi;
-
-	if (WARN_ON_ONCE(!is_guest_mode(vcpu)) ||
-		!nested_cpu_has_vid(get_vmcs12(vcpu)) ||
-		WARN_ON_ONCE(!vmx->nested.virtual_apic_map.gfn))
-		return false;
-
-	rvi = vmx_get_rvi();
-
-	vapic_page = vmx->nested.virtual_apic_map.hva;
-	vppr = *((u32 *)(vapic_page + APIC_PROCPRI));
-
-	return ((rvi & 0xf0) > (vppr & 0xf0));
-}
-
 void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -49,7 +49,6 @@ void vmx_apicv_pre_state_restore(struct
 bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason);
 void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
 void vmx_hwapic_isr_update(int max_isr);
-bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu);
 int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu);
 void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13100,12 +13100,6 @@ void kvm_arch_commit_memory_region(struc
 		kvm_arch_free_memslot(kvm, old);
 }
 
-static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
-{
-	return (is_guest_mode(vcpu) &&
-		static_call(kvm_x86_guest_apic_has_interrupt)(vcpu));
-}
-
 static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 {
 	if (!list_empty_careful(&vcpu->async_pf.done))
@@ -13136,9 +13130,7 @@ static inline bool kvm_vcpu_has_events(s
 	if (kvm_test_request(KVM_REQ_PMI, vcpu))
 		return true;
 
-	if (kvm_arch_interrupt_allowed(vcpu) &&
-	    (kvm_cpu_has_interrupt(vcpu) ||
-	    kvm_guest_apic_has_interrupt(vcpu)))
+	if (kvm_arch_interrupt_allowed(vcpu) && kvm_cpu_has_interrupt(vcpu))
 		return true;
 
 	if (kvm_hv_has_stimer_pending(vcpu))


