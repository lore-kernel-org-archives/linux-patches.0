Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4002215F6C;
	Tue, 29 Apr 2025 17:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949397; cv=none; b=djeg8LZUnXT9E28T1YOGT8X+taXEp6mLYSshc00o4espuEmpMTs8RXyc4tbL7fYvDfLPA0COE2yXifRz+RwQmG0K8XV97L9bJacsDcYAP0I5C0zUuMoVMqJ2/nhQelouhjHf7/kuoflvgpkVZJyTWkF2k6CCNthp6zhw4ys50QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949397; c=relaxed/simple;
	bh=eeKUEeUqSHlOpsW+TNlHxsypHTzq17WziiBj5uhvrig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7wGi74x8nP2OAcISBF/ODEY7EdwSMm++1SR8HR8ZUvOqQDHNcz0ryUFNnsiOK4lDiaOiJY/JpHdyHZuynum1zoR8m/1egtGgswgXvYw+C79zhlIsiTc5yr2y7jr7rVIWw2XNSIw8deB5O8Wi41oeKswqZkBxve7TNbwf3nCQas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wjhad7sf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wjhad7sf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E582C4CEE3;
	Tue, 29 Apr 2025 17:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949396;
	bh=eeKUEeUqSHlOpsW+TNlHxsypHTzq17WziiBj5uhvrig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wjhad7sfVkN9qwHSvDWg5CEBUAhiF+jM8+K0WRAIzqDFo+QjHN+s+izug5FZbDcu3
	 JL4UQL17IQj3Gw/l/qkpBf351ctcOWSqn9JSWziybxHp8ksWwwlElFGpbGzONP1/hL
	 pAc/t/glb6D1ppUWAuMharCl7UTGF1yVfc2wq+S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 305/373] KVM: x86: Reset IRTE to host control if *new* route isnt postable
Date: Tue, 29 Apr 2025 18:43:02 +0200
Message-ID: <20250429161135.663316990@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 9bcac97dc42d2f4da8229d18feb0fe2b1ce523a2 upstream.

Restore an IRTE back to host control (remapped or posted MSI mode) if the
*new* GSI route prevents posting the IRQ directly to a vCPU, regardless of
the GSI routing type.  Updating the IRTE if and only if the new GSI is an
MSI results in KVM leaving an IRTE posting to a vCPU.

The dangling IRTE can result in interrupts being incorrectly delivered to
the guest, and in the worst case scenario can result in use-after-free,
e.g. if the VM is torn down, but the underlying host IRQ isn't freed.

Fixes: efc644048ecd ("KVM: x86: Update IRTE for posted-interrupts")
Fixes: 411b44ba80ab ("svm: Implements update_pi_irte hook to setup posted interrupt")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250404193923.1413163-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c        |   58 +++++++++++++++++++++--------------------
 arch/x86/kvm/vmx/posted_intr.c |   28 +++++++------------
 2 files changed, 41 insertions(+), 45 deletions(-)

--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -801,6 +801,7 @@ int svm_update_pi_irte(struct kvm *kvm,
 {
 	struct kvm_kernel_irq_routing_entry *e;
 	struct kvm_irq_routing_table *irq_rt;
+	bool enable_remapped_mode = true;
 	int idx, ret = 0;
 
 	if (!kvm_arch_has_assigned_device(kvm) ||
@@ -838,6 +839,8 @@ int svm_update_pi_irte(struct kvm *kvm,
 		    kvm_vcpu_apicv_active(&svm->vcpu)) {
 			struct amd_iommu_pi_data pi;
 
+			enable_remapped_mode = false;
+
 			/* Try to enable guest_mode in IRTE */
 			pi.base = __sme_set(page_to_phys(svm->avic_backing_page) &
 					    AVIC_HPA_MASK);
@@ -856,33 +859,6 @@ int svm_update_pi_irte(struct kvm *kvm,
 			 */
 			if (!ret && pi.is_guest_mode)
 				svm_ir_list_add(svm, &pi);
-		} else {
-			/* Use legacy mode in IRTE */
-			struct amd_iommu_pi_data pi;
-
-			/**
-			 * Here, pi is used to:
-			 * - Tell IOMMU to use legacy mode for this interrupt.
-			 * - Retrieve ga_tag of prior interrupt remapping data.
-			 */
-			pi.prev_ga_tag = 0;
-			pi.is_guest_mode = false;
-			ret = irq_set_vcpu_affinity(host_irq, &pi);
-
-			/**
-			 * Check if the posted interrupt was previously
-			 * setup with the guest_mode by checking if the ga_tag
-			 * was cached. If so, we need to clean up the per-vcpu
-			 * ir_list.
-			 */
-			if (!ret && pi.prev_ga_tag) {
-				int id = AVIC_GATAG_TO_VCPUID(pi.prev_ga_tag);
-				struct kvm_vcpu *vcpu;
-
-				vcpu = kvm_get_vcpu_by_id(kvm, id);
-				if (vcpu)
-					svm_ir_list_del(to_svm(vcpu), &pi);
-			}
 		}
 
 		if (!ret && svm) {
@@ -898,6 +874,34 @@ int svm_update_pi_irte(struct kvm *kvm,
 	}
 
 	ret = 0;
+	if (enable_remapped_mode) {
+		/* Use legacy mode in IRTE */
+		struct amd_iommu_pi_data pi;
+
+		/**
+		 * Here, pi is used to:
+		 * - Tell IOMMU to use legacy mode for this interrupt.
+		 * - Retrieve ga_tag of prior interrupt remapping data.
+		 */
+		pi.prev_ga_tag = 0;
+		pi.is_guest_mode = false;
+		ret = irq_set_vcpu_affinity(host_irq, &pi);
+
+		/**
+		 * Check if the posted interrupt was previously
+		 * setup with the guest_mode by checking if the ga_tag
+		 * was cached. If so, we need to clean up the per-vcpu
+		 * ir_list.
+		 */
+		if (!ret && pi.prev_ga_tag) {
+			int id = AVIC_GATAG_TO_VCPUID(pi.prev_ga_tag);
+			struct kvm_vcpu *vcpu;
+
+			vcpu = kvm_get_vcpu_by_id(kvm, id);
+			if (vcpu)
+				svm_ir_list_del(to_svm(vcpu), &pi);
+		}
+	}
 out:
 	srcu_read_unlock(&kvm->irq_srcu, idx);
 	return ret;
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -270,6 +270,7 @@ int pi_update_irte(struct kvm *kvm, unsi
 {
 	struct kvm_kernel_irq_routing_entry *e;
 	struct kvm_irq_routing_table *irq_rt;
+	bool enable_remapped_mode = true;
 	struct kvm_lapic_irq irq;
 	struct kvm_vcpu *vcpu;
 	struct vcpu_data vcpu_info;
@@ -308,21 +309,8 @@ int pi_update_irte(struct kvm *kvm, unsi
 
 		kvm_set_msi_irq(kvm, e, &irq);
 		if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
-		    !kvm_irq_is_postable(&irq)) {
-			/*
-			 * Make sure the IRTE is in remapped mode if
-			 * we don't handle it in posted mode.
-			 */
-			ret = irq_set_vcpu_affinity(host_irq, NULL);
-			if (ret < 0) {
-				printk(KERN_INFO
-				   "failed to back to remapped mode, irq: %u\n",
-				   host_irq);
-				goto out;
-			}
-
+		    !kvm_irq_is_postable(&irq))
 			continue;
-		}
 
 		vcpu_info.pi_desc_addr = __pa(&to_vmx(vcpu)->pi_desc);
 		vcpu_info.vector = irq.vector;
@@ -330,11 +318,12 @@ int pi_update_irte(struct kvm *kvm, unsi
 		trace_kvm_pi_irte_update(host_irq, vcpu->vcpu_id, e->gsi,
 				vcpu_info.vector, vcpu_info.pi_desc_addr, set);
 
-		if (set)
-			ret = irq_set_vcpu_affinity(host_irq, &vcpu_info);
-		else
-			ret = irq_set_vcpu_affinity(host_irq, NULL);
+		if (!set)
+			continue;
 
+		enable_remapped_mode = false;
+
+		ret = irq_set_vcpu_affinity(host_irq, &vcpu_info);
 		if (ret < 0) {
 			printk(KERN_INFO "%s: failed to update PI IRTE\n",
 					__func__);
@@ -342,6 +331,9 @@ int pi_update_irte(struct kvm *kvm, unsi
 		}
 	}
 
+	if (enable_remapped_mode)
+		ret = irq_set_vcpu_affinity(host_irq, NULL);
+
 	ret = 0;
 out:
 	srcu_read_unlock(&kvm->irq_srcu, idx);


