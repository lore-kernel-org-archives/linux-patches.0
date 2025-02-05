Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA37D18D621;
	Wed,  5 Feb 2025 15:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768673; cv=none; b=CDwqR0tXMzjIfArs0v0eBPbP9tCCAo0tsmZkrrUyLYXmUSwZfQUEvAuXKsuWdaZdmPXP7ZufKffhJzM5DupeoJJNPCdnkHpdFsxLr/vpZRASEAsBt/NGzpG8uFWlh3jfjbeK0pt3yw/2QP06hmBI9ceJ1pFqJ8IorvzdjBGgx+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768673; c=relaxed/simple;
	bh=UAHow0vY0X2aKcKktSeX6qPRlYonw2KZNoe8WJ5bqRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFCgf8d0yQMQwX3iiP3IH+sBAncjXXj/TXx6YOUc3SEcvlnI4d+fubrXgUI5dln8aWlJhY+h9kyFwLfyRq2ibxo8GhmeNIEq0d81/8ZPhC4B7ovckjpRMaj/QMOeFtVoZPvvQ8meTn0/9Q9FAsHxXR0K+U53XJF9DMEYWAUHvJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHrrtCrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHrrtCrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39023C4CED1;
	Wed,  5 Feb 2025 15:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768673;
	bh=UAHow0vY0X2aKcKktSeX6qPRlYonw2KZNoe8WJ5bqRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHrrtCrWvsWp5P1C2ex06wS4Nc1z4xJkYqLgPwYY6+LM1CIr6M64n4zYAZ//uJApp
	 Al6qmu3Pa3EOj2AUFiNMyYakwQ0Q/na+sFZXOlzp2XBNZW7qABfkIH6jbHkrpK3jjU
	 +iv1JIDaqwjEW0HgqTIL2kN2RpxsFxztulKwYjzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.13 618/623] KVM: x86: Plumb in the vCPU to kvm_x86_ops.hwapic_isr_update()
Date: Wed,  5 Feb 2025 14:46:00 +0100
Message-ID: <20250205134519.857221783@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 76bce9f10162cd4b36ac0b7889649b22baf70ebd upstream.

Pass the target vCPU to the hwapic_isr_update() vendor hook so that VMX
can defer the update until after nested VM-Exit if an EOI for L1's vAPIC
occurs while L2 is active.

Note, commit d39850f57d21 ("KVM: x86: Drop @vcpu parameter from
kvm_x86_ops.hwapic_isr_update()") removed the parameter with the
justification that doing so "allows for a decent amount of (future)
cleanup in the APIC code", but it's not at all clear what cleanup was
intended, or if it was ever realized.

No functional change intended.

Cc: stable@vger.kernel.org
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/r/20241128000010.4051275-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/lapic.c            |   11 +++++------
 arch/x86/kvm/vmx/vmx.c          |    2 +-
 arch/x86/kvm/vmx/x86_ops.h      |    2 +-
 4 files changed, 8 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1735,7 +1735,7 @@ struct kvm_x86_ops {
 	bool allow_apicv_in_x2apic_without_x2apic_virtualization;
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
-	void (*hwapic_isr_update)(int isr);
+	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
 	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -763,7 +763,7 @@ static inline void apic_set_isr(int vec,
 	 * just set SVI.
 	 */
 	if (unlikely(apic->apicv_active))
-		kvm_x86_call(hwapic_isr_update)(vec);
+		kvm_x86_call(hwapic_isr_update)(apic->vcpu, vec);
 	else {
 		++apic->isr_count;
 		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
@@ -808,7 +808,7 @@ static inline void apic_clear_isr(int ve
 	 * and must be left alone.
 	 */
 	if (unlikely(apic->apicv_active))
-		kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(apic));
+		kvm_x86_call(hwapic_isr_update)(apic->vcpu, apic_find_highest_isr(apic));
 	else {
 		--apic->isr_count;
 		BUG_ON(apic->isr_count < 0);
@@ -2806,7 +2806,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vc
 	if (apic->apicv_active) {
 		kvm_x86_call(apicv_post_state_restore)(vcpu);
 		kvm_x86_call(hwapic_irr_update)(vcpu, -1);
-		kvm_x86_call(hwapic_isr_update)(-1);
+		kvm_x86_call(hwapic_isr_update)(vcpu, -1);
 	}
 
 	vcpu->arch.apic_arb_prio = 0;
@@ -3121,9 +3121,8 @@ int kvm_apic_set_state(struct kvm_vcpu *
 	kvm_apic_update_apicv(vcpu);
 	if (apic->apicv_active) {
 		kvm_x86_call(apicv_post_state_restore)(vcpu);
-		kvm_x86_call(hwapic_irr_update)(vcpu,
-						apic_find_highest_irr(apic));
-		kvm_x86_call(hwapic_isr_update)(apic_find_highest_isr(apic));
+		kvm_x86_call(hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
+		kvm_x86_call(hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
 	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	if (ioapic_in_kernel(vcpu->kvm))
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6862,7 +6862,7 @@ void vmx_set_apic_access_page_addr(struc
 	read_unlock(&vcpu->kvm->mmu_lock);
 }
 
-void vmx_hwapic_isr_update(int max_isr)
+void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 {
 	u16 status;
 	u8 old;
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -48,7 +48,7 @@ void vmx_migrate_timers(struct kvm_vcpu
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu);
 void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
-void vmx_hwapic_isr_update(int max_isr);
+void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
 int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu);
 void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector);


