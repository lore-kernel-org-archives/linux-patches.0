Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161324779BE;
	Thu, 20 Aug 2026 16:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244471; cv=none; b=ZKJf6CdUNkQ1asy4Pk+DzNmxLYltZp4vds0dCk71zqyrtPsL1qTr98Ty1K3MPkbWA1RJO7rwN4w6W2cnhjNzHN3cH4zlp7G8YT61Y+iFWHffwBQsNAnU2fYJFlYdSx7/fnIaipRlk7Xo4m9xECVHgc/8jRAEitUYuHE0ASUGT6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244471; c=relaxed/simple;
	bh=m1WPMrJZH9cDsvNgZ1DbZXCGeyvkomVPd1DaXiBzJQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEXX0yNxZO5iyOGEc+fo5InJn/0kdYuqKiSiaSOYWauBhVtQwNxkuMqf/5BvYOFq1TPIsUcCuBXOVSwmDu806jWz0qpxzW/CJ89orjY+vEFSVE2f9nlmn2k7HQhQhy25UwiWqEBUCyxxXmQqyjioLix0mpELk88K5SOvmRa1vC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fxe7Rc3l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fxe7Rc3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A9D1F000E9;
	Thu, 20 Aug 2026 16:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244470;
	bh=lEPYv6EwArojnAaZc4GUz8aOJaT3xw80TM2vtE1QEZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fxe7Rc3loqWecS3kWr0EEWUlLpRuh/S/7kvcddVbdZJ7VHkc9Kwv4YVjCjYgPz+YL
	 +MV4aAFOGguy2BZxq+YJFQtYzmq3DWzV6pY4Do0i7ymvhN8SrgMb9cv7PtAHfeSne0
	 zVAeeJLds/mG93GBDIzvcTruGLzGHQwLSgUxeYeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/235] KVM: x86: Drop @vcpu parameter from kvm_x86_ops.hwapic_isr_update()
Date: Thu, 20 Aug 2026 16:56:17 +0200
Message-ID: <20260820145220.717475765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit d39850f57d2102c6b46feb21237bc23bc42de4f7 ]

Drop the unused @vcpu parameter from hwapic_isr_update().  AMD/AVIC is
unlikely to implement the helper, and VMX/APICv doesn't need the vCPU as
it operates on the current VMCS.  The result is somewhat odd, but allows
for a decent amount of (future) cleanup in the APIC code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220614230548.3852141-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: e800decd9c0a ("KVM: x86: Only reset TSC Deadline Timer in apic_timer_expired on KVM_RUN")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/lapic.c            |   10 ++++------
 arch/x86/kvm/svm/avic.c         |    2 +-
 arch/x86/kvm/svm/svm.h          |    2 +-
 arch/x86/kvm/vmx/vmx.c          |    2 +-
 5 files changed, 8 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1179,7 +1179,7 @@ struct kvm_x86_ops {
 	void (*pre_update_apicv_exec_ctrl)(struct kvm *kvm, bool activate);
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
-	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
+	void (*hwapic_isr_update)(int isr);
 	bool (*guest_apic_has_interrupt)(struct kvm_vcpu *vcpu);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -520,7 +520,7 @@ static inline void apic_set_isr(int vec,
 	 * just set SVI.
 	 */
 	if (unlikely(vcpu->arch.apicv_active))
-		kvm_x86_ops.hwapic_isr_update(vcpu, vec);
+		kvm_x86_ops.hwapic_isr_update(vec);
 	else {
 		++apic->isr_count;
 		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
@@ -568,8 +568,7 @@ static inline void apic_clear_isr(int ve
 	 * and must be left alone.
 	 */
 	if (unlikely(vcpu->arch.apicv_active))
-		kvm_x86_ops.hwapic_isr_update(vcpu,
-					       apic_find_highest_isr(apic));
+		kvm_x86_ops.hwapic_isr_update(apic_find_highest_isr(apic));
 	else {
 		--apic->isr_count;
 		BUG_ON(apic->isr_count < 0);
@@ -2383,7 +2382,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vc
 	if (vcpu->arch.apicv_active) {
 		kvm_x86_ops.apicv_post_state_restore(vcpu);
 		kvm_x86_ops.hwapic_irr_update(vcpu, -1);
-		kvm_x86_ops.hwapic_isr_update(vcpu, -1);
+		kvm_x86_ops.hwapic_isr_update(-1);
 	}
 
 	vcpu->arch.apic_arb_prio = 0;
@@ -2651,8 +2650,7 @@ int kvm_apic_set_state(struct kvm_vcpu *
 		kvm_x86_ops.apicv_post_state_restore(vcpu);
 		kvm_x86_ops.hwapic_irr_update(vcpu,
 				apic_find_highest_irr(apic));
-		kvm_x86_ops.hwapic_isr_update(vcpu,
-				apic_find_highest_isr(apic));
+		kvm_x86_ops.hwapic_isr_update(apic_find_highest_isr(apic));
 	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	if (ioapic_in_kernel(vcpu->kvm))
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -603,7 +603,7 @@ void svm_hwapic_irr_update(struct kvm_vc
 {
 }
 
-void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
+void svm_hwapic_isr_update(int max_isr)
 {
 }
 
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -457,7 +457,7 @@ bool svm_check_apicv_inhibit_reasons(ulo
 void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate);
 void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
-void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
+void svm_hwapic_isr_update(int max_isr);
 int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec);
 bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6403,7 +6403,7 @@ static void vmx_set_apic_access_page_add
 	put_page(page);
 }
 
-static void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
+static void vmx_hwapic_isr_update(int max_isr)
 {
 	u16 status;
 	u8 old;


