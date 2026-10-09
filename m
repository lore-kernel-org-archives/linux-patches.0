Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871FF4D9F7C;
	Fri,  9 Oct 2026 14:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555242; cv=none; b=Es4zb8AmYWHhQLzBNL9mB7UzFKHao+9UfxAqoJdaK1lI0hIpwTS0LJBn5ZeH9qOZP6iCdAOFC444oUxsMFYxCZF4jUg2FLet4qOGDyRqDAZiW1aLclvxT/xCsXpfo75koXpdmGJa5tVxmwfO5wzy4tMpvkhZSEZtX+YWZotUSto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555242; c=relaxed/simple;
	bh=I6xOdce0Nc7NFNBmFHo+tBNbkV5Qp8+8eRoiDV0jjcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/wvKweP/MlE2AydtaLMBgXPiaVcfMGzdqzI7AvsdIgVAr2a1k4bOnecmynVztkY0K9FNGOOqmZr/wayySVGhIwZ7C9wYmMclDVoc2QHEuaww+7Ep7QVmmSV78NjS1bS5x4baJ+CvSqsqerm70wo3T4LCDq/X7IWfIrEJo0GZJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IENUE1xk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IENUE1xk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA051F000FF;
	Fri,  9 Oct 2026 14:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555235;
	bh=Vq0jGHy+5tv0XV7VJtO+jY000gvcGq0efwhIkVclTTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IENUE1xkdIYUwS2HxiSsyserGW+1/sfmRN3Yld4iEN4rBuddHEBngcRSIDHBoSNim
	 c1NPaQmJRtGmQ572y1HlZlkqlKeOR2KGgm0ZvKT/K0yjFr6J/01ukpO2Mh43/HKp6O
	 Lwv8LNayw/nT5xzNYzQzEGCploafsOTLO1FymabM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shen Yongchao <grayhat@foxmail.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/403] KVM: arm64: nv: Fix life cycle of the nested_mmus array
Date: Fri,  9 Oct 2026 16:06:03 +0200
Message-ID: <20261009140952.179060490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 33346f8960c7bb6a3b4e273b5cfe25c5a8be349f ]

The nested_mmus array holds the shadow page tables that are used when
a guest is running a nested context. These structures are allocated on
VCPU_INIT for whole guest, which implies that they may have to be
relocated as the array grows.

Should a VCPU_INIT occur whilst a vcpu is actively running an L2 and
that the allocation requires relocation, that vcpu will still be
running with a pointer to the previous structure, which will have been
freed.

Fix this by turning the array of structures to an array of pointers,
which is now allocated at VM creation, sized to the absolute maximum
that KVM can handle.

In turn, each VCPU_INIT contributes S2_MMU_PER_VCPU to the pool. No
reallocation is ever performed, and the life cycle of each object is
much clearer:

- the nested_mmus array is allocated in kvm_init_nested(), and freed
  in kvm_arch_destroy_vm()

- s2_mmu structures are allocated in kvm_vcpu_init_nested(), and freed
  on kvm_arch_flush_shadow_all()

Finally, the freeing of vcpu->arch.vncr_array is made consistent
rather than being done on some failure paths, but not others.

Fixes: 4f128f8e1aaa ("KVM: arm64: nv: Support multiple nested Stage-2 mmu structures")
Reported-by: Shen Yongchao <grayhat@foxmail.com>
Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
Suggested-by: Karl Mehltretter <kmehltretter@gmail.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Link: https://lore.kernel.org/r/20260803224405.41468-1-kmehltretter@gmail.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Wei-Lin Chang <weilin.chang@arm.com>
Link: https://patch.msgid.link/20260911162203.1919330-2-maz@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>

Stable adaptation for 6.18:
- Omit initialization of vncr_tlb_count, which this branch does not have.
- Add the missing err_uninit_mmu cleanup path and use it for both nested
  allocation failures and pkvm_init_host_vm() failures, releasing the
  canonical stage-2 MMU and the newly allocated nested MMU pointer array.
- Retain the pointer-array conversion and per-vCPU MMU allocations so
  e5843f4effaa can defer freeing these objects until VM destruction.
No new functions are introduced by this dependency backport.

Stable-dep-of: e5843f4effaa ("KVM: arm64: nv: Delay freeing of shadow S2 structures until VM destruction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h   |  2 +-
 arch/arm64/include/asm/kvm_nested.h |  2 +-
 arch/arm64/kvm/arm.c                | 12 +++-
 arch/arm64/kvm/nested.c             | 89 +++++++++++++----------------
 4 files changed, 52 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index feff0d13f052c..ca26460bde651 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -307,7 +307,7 @@ struct kvm_arch {
 	 * Stage 2 paging state for VMs with nested S2 using a virtual
 	 * VMID.
 	 */
-	struct kvm_s2_mmu *nested_mmus;
+	struct kvm_s2_mmu **nested_mmus;
 	size_t nested_mmus_size;
 	int nested_mmus_next;
 
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index b9d86614994db..30d4c8ae28d3e 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -65,7 +65,7 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
 
 extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
 extern bool forward_debug_exception(struct kvm_vcpu *vcpu);
-extern void kvm_init_nested(struct kvm *kvm);
+extern int kvm_init_nested(struct kvm *kvm);
 extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
 extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
 extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 52549bebb7829..47c9e53f43b4b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -176,8 +176,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	mutex_unlock(&kvm->lock);
 #endif
 
-	kvm_init_nested(kvm);
-
 	ret = kvm_share_hyp(kvm, kvm + 1);
 	if (ret)
 		return ret;
@@ -192,6 +190,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto err_free_cpumask;
 
+	ret = kvm_init_nested(kvm);
+	if (ret)
+		goto err_uninit_mmu;
+
 	if (is_protected_kvm_enabled()) {
 		/*
 		 * If any failures occur after this is successful, make sure to
@@ -199,7 +201,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		 */
 		ret = pkvm_init_host_vm(kvm);
 		if (ret)
-			goto err_free_cpumask;
+			goto err_uninit_mmu;
 	}
 
 	kvm_vgic_early_init(kvm);
@@ -215,6 +217,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	return 0;
 
+err_uninit_mmu:
+	kvm_uninit_stage2_mmu(kvm);
+	kvfree(kvm->arch.nested_mmus);
 err_free_cpumask:
 	free_cpumask_var(kvm->arch.supported_cpus);
 err_unshare_kvm:
@@ -271,6 +276,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 
 	kvm_unshare_hyp(kvm, kvm + 1);
 
+	kvfree(kvm->arch.nested_mmus);
 	kvm_arm_teardown_hypercalls(kvm);
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 9be5346140ce3..289daac6c070a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -44,10 +44,14 @@ struct vncr_tlb {
  */
 #define S2_MMU_PER_VCPU		2
 
-void kvm_init_nested(struct kvm *kvm)
+int kvm_init_nested(struct kvm *kvm)
 {
-	kvm->arch.nested_mmus = NULL;
+	kvm->arch.nested_mmus = kvmalloc_objs(struct kvm_s2_mmu *,
+					      KVM_MAX_VCPUS * S2_MMU_PER_VCPU,
+					      GFP_KERNEL_ACCOUNT);
 	kvm->arch.nested_mmus_size = 0;
+
+	return kvm->arch.nested_mmus ? 0 : -ENOMEM;
 }
 
 static int init_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
@@ -68,8 +72,9 @@ static int init_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-	struct kvm_s2_mmu *tmp;
-	int num_mmus, ret = 0;
+	int num_mmus;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
 
 	if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features) &&
 	    !cpus_have_final_cap(ARM64_HAS_HCR_NV1))
@@ -82,51 +87,40 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.ctxt.vncr_array)
 		return -ENOMEM;
 
-	/*
-	 * Let's treat memory allocation failures as benign: If we fail to
-	 * allocate anything, return an error and keep the allocated array
-	 * alive. Userspace may try to recover by intializing the vcpu
-	 * again, and there is no reason to affect the whole VM for this.
-	 */
 	num_mmus = atomic_read(&kvm->online_vcpus) * S2_MMU_PER_VCPU;
 
 	if (num_mmus > kvm->arch.nested_mmus_size) {
-		tmp = kvcalloc(num_mmus, sizeof(*tmp), GFP_KERNEL_ACCOUNT);
-		if (!tmp)
-			return -ENOMEM;
-
-		write_lock(&kvm->mmu_lock);
+		struct kvm_s2_mmu *tmp;
+		int i, ret = 0;
 
-		if (kvm->arch.nested_mmus_size) {
-			memcpy(tmp, kvm->arch.nested_mmus,
-			       size_mul(sizeof(*tmp), kvm->arch.nested_mmus_size));
+		tmp = kvzalloc_objs(*tmp, S2_MMU_PER_VCPU, GFP_KERNEL_ACCOUNT);
+		if (!tmp)
+			ret = -ENOMEM;
 
-			for (int i = 0; i < kvm->arch.nested_mmus_size; i++)
-				tmp[i].pgt->mmu = &tmp[i];
+		for (i = 0; !ret && i < S2_MMU_PER_VCPU; i++) {
+			ret = init_nested_s2_mmu(kvm, &tmp[i]);
+			if (ret)
+				break;
 		}
 
-		swap(kvm->arch.nested_mmus, tmp);
-
-		write_unlock(&kvm->mmu_lock);
-
-		kvfree(tmp);
-	}
+		if (ret) {
+			while (--i >= 0)
+				kvm_free_stage2_pgd(&tmp[i]);
 
-	for (int i = kvm->arch.nested_mmus_size; !ret && i < num_mmus; i++)
-		ret = init_nested_s2_mmu(kvm, &kvm->arch.nested_mmus[i]);
+			kvfree(tmp);
+			free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
+			vcpu->arch.ctxt.vncr_array = NULL;
+			return ret;
+		}
 
-	if (ret) {
-		for (int i = kvm->arch.nested_mmus_size; i < num_mmus; i++)
-			kvm_free_stage2_pgd(&kvm->arch.nested_mmus[i]);
+		guard(write_lock)(&kvm->mmu_lock);
 
-		free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
-		vcpu->arch.ctxt.vncr_array = NULL;
+		for (i = 0; i < S2_MMU_PER_VCPU; i++)
+			kvm->arch.nested_mmus[i + kvm->arch.nested_mmus_size] = &tmp[i];
 
-		return ret;
+		kvm->arch.nested_mmus_size += S2_MMU_PER_VCPU;
 	}
 
-	kvm->arch.nested_mmus_size = num_mmus;
-
 	return 0;
 }
 
@@ -620,7 +614,7 @@ void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
 	write_lock(&kvm->mmu_lock);
 
 	for (int i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (!kvm_s2_mmu_valid(mmu))
 			continue;
@@ -662,7 +656,7 @@ struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu)
 	 *   if S2 translation is disabled.
 	 */
 	for (int i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (!kvm_s2_mmu_valid(mmu))
 			continue;
@@ -701,7 +695,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	for (i = kvm->arch.nested_mmus_next;
 	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
 	     i++) {
-		s2_mmu = &kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
+		s2_mmu = kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
 
 		if (atomic_read(&s2_mmu->refcnt) == 0)
 			break;
@@ -1147,7 +1141,7 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (kvm_s2_mmu_valid(mmu))
 			kvm_stage2_wp_range(mmu, 0, kvm_phys_size(mmu));
@@ -1163,7 +1157,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (kvm_s2_mmu_valid(mmu))
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
@@ -1179,7 +1173,7 @@ void kvm_nested_s2_flush(struct kvm *kvm)
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (kvm_s2_mmu_valid(mmu))
 			kvm_stage2_flush_range(mmu, 0, kvm_phys_size(mmu));
@@ -1188,16 +1182,15 @@ void kvm_nested_s2_flush(struct kvm *kvm)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	int i;
-
-	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+	for (int i = kvm->arch.nested_mmus_size - 1; i >= 0; i--) {
+		struct kvm_s2_mmu *mmu = kvm->arch.nested_mmus[i];
 
 		if (!WARN_ON(atomic_read(&mmu->refcnt)))
 			kvm_free_stage2_pgd(mmu);
+
+		if ((i % S2_MMU_PER_VCPU) == 0)
+			kvfree(mmu);
 	}
-	kvfree(kvm->arch.nested_mmus);
-	kvm->arch.nested_mmus = NULL;
 	kvm->arch.nested_mmus_size = 0;
 	kvm_uninit_stage2_mmu(kvm);
 }
-- 
2.53.0



