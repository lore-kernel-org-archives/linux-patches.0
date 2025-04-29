Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A89F24728A;
	Tue, 29 Apr 2025 18:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950434; cv=none; b=k0jqh0OwgMEDSE66D7QTI+YbW2nWO5LlBq7HXNzQ6pwBFaF2ljw1bn5AXy6ivY/395sWTp27vXLLyt6DqTJwwWABC/1VNczqtDal/w4s4DqIMy+1etxC93mkd/0+xdiJYW7yhsfcbJ2Y2+ITyP/ulkgywgzBlBZ5U3/XuYVkkT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950434; c=relaxed/simple;
	bh=ABLAxxy4L3V/ikWlQZziW/7z/OziUwk60Q6cDSAyaD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfDSUDPMU13ZrrovfnLMf11bGIbSqms0OqxbaJTmPRt5U6r5zOVoRt+FvOVvzrjbN01SWewpZN3tCRSrj+4odBHnAyml8FLlLuGLLqvTOkrDtJesdw3TZe/1SKor0N185F4UW0aRKcOS5P29XAHy6BtjLb2sjqXpnjBv/tR0edA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6SwhUBu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6SwhUBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5C1C4CEE3;
	Tue, 29 Apr 2025 18:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950434;
	bh=ABLAxxy4L3V/ikWlQZziW/7z/OziUwk60Q6cDSAyaD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6SwhUBuILBAXUWAuGnb1FX2i3edje8bbEiY0M3YT4S6b/y3gaTZPleTGJowdJtCT
	 Bcq8fO+W2YVS7/MEpT60ewAjzxxyRoOaZ+90SDgjMw870cWAmAaMjcP4zdhtBvNTCx
	 EwtJ7OXmel7aPmupXhquoKoSYf2FbUsldt5InxWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 093/204] KVM: x86: Reset IRTE to host control if *new* route isnt postable
Date: Tue, 29 Apr 2025 18:43:01 +0200
Message-ID: <20250429161103.243863792@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -896,6 +896,7 @@ int avic_pi_update_irte(struct kvm *kvm,
 {
 	struct kvm_kernel_irq_routing_entry *e;
 	struct kvm_irq_routing_table *irq_rt;
+	bool enable_remapped_mode = true;
 	int idx, ret = 0;
 
 	if (!kvm_arch_has_assigned_device(kvm) ||
@@ -933,6 +934,8 @@ int avic_pi_update_irte(struct kvm *kvm,
 		    kvm_vcpu_apicv_active(&svm->vcpu)) {
 			struct amd_iommu_pi_data pi;
 
+			enable_remapped_mode = false;
+
 			/* Try to enable guest_mode in IRTE */
 			pi.base = __sme_set(page_to_phys(svm->avic_backing_page) &
 					    AVIC_HPA_MASK);
@@ -951,33 +954,6 @@ int avic_pi_update_irte(struct kvm *kvm,
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
@@ -993,6 +969,34 @@ int avic_pi_update_irte(struct kvm *kvm,
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
@@ -274,6 +274,7 @@ int vmx_pi_update_irte(struct kvm *kvm,
 {
 	struct kvm_kernel_irq_routing_entry *e;
 	struct kvm_irq_routing_table *irq_rt;
+	bool enable_remapped_mode = true;
 	struct kvm_lapic_irq irq;
 	struct kvm_vcpu *vcpu;
 	struct vcpu_data vcpu_info;
@@ -312,21 +313,8 @@ int vmx_pi_update_irte(struct kvm *kvm,
 
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
 
 		vcpu_info.pi_desc_addr = __pa(vcpu_to_pi_desc(vcpu));
 		vcpu_info.vector = irq.vector;
@@ -334,11 +322,12 @@ int vmx_pi_update_irte(struct kvm *kvm,
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
@@ -346,6 +335,9 @@ int vmx_pi_update_irte(struct kvm *kvm,
 		}
 	}
 
+	if (enable_remapped_mode)
+		ret = irq_set_vcpu_affinity(host_irq, NULL);
+
 	ret = 0;
 out:
 	srcu_read_unlock(&kvm->irq_srcu, idx);


