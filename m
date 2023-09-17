Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EE863DE
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD40EC433CD;
	Sun, 17 Sep 2023 19:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980546;
	bh=wRco8m6L3obNDJdzVVgi0LPy3X75To/3YrpkJ9L4W3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjvPSB86QkxWlIpE/tWbWd1eyszo2/9mBmrTtV87XILIm/qVxUrue76WJg25KTU2h
	 GVushQtt00HLdVBEKRmroMKsE+OtSM4Zz7xo4mVKKvsGbTRRztZ0zqt6gnoTxS084v
	 YcA5YfLnwrRWPOmg3YlWrvLzK6KCwRp+SZqJGHDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.5 223/285] KVM: SVM: Take and hold ir_list_lock when updating vCPUs Physical ID entry
Date: Sun, 17 Sep 2023 21:13:43 +0200
Message-ID: <20230917191059.210251691@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 4c08e737f056fec930b416a2bd37ed266d724f95 upstream.

Hoist the acquisition of ir_list_lock from avic_update_iommu_vcpu_affinity()
to its two callers, avic_vcpu_load() and avic_vcpu_put(), specifically to
encapsulate the write to the vCPU's entry in the AVIC Physical ID table.
This will allow a future fix to pull information from the Physical ID entry
when updating the IRTE, without potentially consuming stale information,
i.e. without racing with the vCPU being (un)loaded.

Add a comment to call out that ir_list_lock does NOT protect against
multiple writers, specifically that reading the Physical ID entry in
avic_vcpu_put() outside of the lock is safe.

To preserve some semblance of independence from ir_list_lock, keep the
READ_ONCE() in avic_vcpu_load() even though acuiring the spinlock
effectively ensures the load(s) will be generated after acquiring the
lock.

Cc: stable@vger.kernel.org
Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Link: https://lore.kernel.org/r/20230808233132.2499764-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -986,10 +986,11 @@ static inline int
 avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 {
 	int ret = 0;
-	unsigned long flags;
 	struct amd_svm_iommu_ir *ir;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	lockdep_assert_held(&svm->ir_list_lock);
+
 	if (!kvm_arch_has_assigned_device(vcpu->kvm))
 		return 0;
 
@@ -997,19 +998,15 @@ avic_update_iommu_vcpu_affinity(struct k
 	 * Here, we go through the per-vcpu ir_list to update all existing
 	 * interrupt remapping table entry targeting this vcpu.
 	 */
-	spin_lock_irqsave(&svm->ir_list_lock, flags);
-
 	if (list_empty(&svm->ir_list))
-		goto out;
+		return 0;
 
 	list_for_each_entry(ir, &svm->ir_list, node) {
 		ret = amd_iommu_update_ga(cpu, r, ir->data);
 		if (ret)
-			break;
+			return ret;
 	}
-out:
-	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
-	return ret;
+	return 0;
 }
 
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
@@ -1017,6 +1014,7 @@ void avic_vcpu_load(struct kvm_vcpu *vcp
 	u64 entry;
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long flags;
 
 	lockdep_assert_preemption_disabled();
 
@@ -1033,6 +1031,8 @@ void avic_vcpu_load(struct kvm_vcpu *vcp
 	if (kvm_vcpu_is_blocking(vcpu))
 		return;
 
+	spin_lock_irqsave(&svm->ir_list_lock, flags);
+
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 	WARN_ON_ONCE(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
 
@@ -1042,25 +1042,40 @@ void avic_vcpu_load(struct kvm_vcpu *vcp
 
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
+
+	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
 }
 
 void avic_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	u64 entry;
 	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long flags;
 
 	lockdep_assert_preemption_disabled();
 
+	/*
+	 * Note, reading the Physical ID entry outside of ir_list_lock is safe
+	 * as only the pCPU that has loaded (or is loading) the vCPU is allowed
+	 * to modify the entry, and preemption is disabled.  I.e. the vCPU
+	 * can't be scheduled out and thus avic_vcpu_{put,load}() can't run
+	 * recursively.
+	 */
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 
 	/* Nothing to do if IsRunning == '0' due to vCPU blocking. */
 	if (!(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK))
 		return;
 
+	spin_lock_irqsave(&svm->ir_list_lock, flags);
+
 	avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
 
 	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
+
+	spin_unlock_irqrestore(&svm->ir_list_lock, flags);
+
 }
 
 void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)


