Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102FA166F06;
	Wed,  5 Mar 2025 18:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197665; cv=none; b=cR7gbTQ6qsz10FM6weHSZjyCF4Pe9H6DWvtxXNRVssyE2AnyqECbwCykz3rw8yVTSg/LRg4BI1AzSw5J449WsFmHBU/hpEuVjQ4XhpRdiEGlrRFDj0axQxP/rRQxctf3qY+yPXxhzgNmwhek0HyWryjG9fkW8RZnelq5CgmZmv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197665; c=relaxed/simple;
	bh=Ax7R/P0hZUhUrDQ2v4tXvLLHfH8B4XxGRJJfBDR1l+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBm8vntPaCeJPfB7aTZP/gmozriUppFclHEJRjEug/g6WQJe+0S7BfPctHR70Vg7t/6XlTM5NzC4ChCQNSKgm3VL/+Og7usHETwnL/D//v2+7dPTYyWqDOkK9kdc1EqefBN4xag60Ayjm6/1c3BQUVYkppKuHdd1jwt2ic3wPYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbv9wIWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbv9wIWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADAAC4CED1;
	Wed,  5 Mar 2025 18:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197664;
	bh=Ax7R/P0hZUhUrDQ2v4tXvLLHfH8B4XxGRJJfBDR1l+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbv9wIWOhkCEGUmMwx6P4I70O9v3OZ1KX6C1A2MdxFSLYi40QA+JptnQhI2DN//5z
	 anokKxk5CQk3/bsiPaQ6gaLg2LAQBbdftw2M9UyzDoMZyl8cLT8ef9jCODF0rDqnKZ
	 Bv7YvTlnkBnXtPGo/gROdsJDWuZcAwMinlS5Shtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/142] RISCV: KVM: Introduce mp_state_lock to avoid lock inversion
Date: Wed,  5 Mar 2025 18:47:56 +0100
Message-ID: <20250305174502.629278166@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

[ Upstream commit 2121cadec45aaf61fa45b3aa3d99723ed4e6683a ]

Documentation/virt/kvm/locking.rst advises that kvm->lock should be
acquired outside vcpu->mutex and kvm->srcu. However, when KVM/RISC-V
handling SBI_EXT_HSM_HART_START, the lock ordering is vcpu->mutex,
kvm->srcu then kvm->lock.

Although the lockdep checking no longer complains about this after commit
f0f44752f5f6 ("rcu: Annotate SRCU's update-side lockdep dependencies"),
it's necessary to replace kvm->lock with a new dedicated lock to ensure
only one hart can execute the SBI_EXT_HSM_HART_START call for the target
hart simultaneously.

Additionally, this patch also rename "power_off" to "mp_state" with two
possible values. The vcpu->mp_state_lock also protects the access of
vcpu->mp_state.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20240417074528.16506-2-yongxuan.wang@sifive.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Stable-dep-of: c7db342e3b47 ("riscv: KVM: Fix hart suspend status check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/kvm_host.h |  8 ++++--
 arch/riscv/kvm/vcpu.c             | 48 ++++++++++++++++++++++---------
 arch/riscv/kvm/vcpu_sbi.c         |  7 +++--
 arch/riscv/kvm/vcpu_sbi_hsm.c     | 39 +++++++++++++++++--------
 4 files changed, 73 insertions(+), 29 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 1ebf20dfbaa69..459e61ad7d2b6 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -236,8 +236,9 @@ struct kvm_vcpu_arch {
 	/* Cache pages needed to program page tables with spinlock held */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
-	/* VCPU power-off state */
-	bool power_off;
+	/* VCPU power state */
+	struct kvm_mp_state mp_state;
+	spinlock_t mp_state_lock;
 
 	/* Don't run the VCPU (blocked) */
 	bool pause;
@@ -351,7 +352,10 @@ int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu);
 bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, u64 mask);
+void __kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
+void __kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
+bool kvm_riscv_vcpu_stopped(struct kvm_vcpu *vcpu);
 
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 82229db1ce73f..9584d62c96ee7 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -100,6 +100,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *cntx;
 	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
 
+	spin_lock_init(&vcpu->arch.mp_state_lock);
+
 	/* Mark this VCPU never ran */
 	vcpu->arch.ran_atleast_once = false;
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
@@ -193,7 +195,7 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
 	return (kvm_riscv_vcpu_has_interrupts(vcpu, -1UL) &&
-		!vcpu->arch.power_off && !vcpu->arch.pause);
+		!kvm_riscv_vcpu_stopped(vcpu) && !vcpu->arch.pause);
 }
 
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
@@ -421,26 +423,42 @@ bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
 	return kvm_riscv_vcpu_aia_has_interrupts(vcpu, mask);
 }
 
-void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
+void __kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.power_off = true;
+	WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
 	kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
-void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu)
+void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.power_off = false;
+	spin_lock(&vcpu->arch.mp_state_lock);
+	__kvm_riscv_vcpu_power_off(vcpu);
+	spin_unlock(&vcpu->arch.mp_state_lock);
+}
+
+void __kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu)
+{
+	WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
 	kvm_vcpu_wake_up(vcpu);
 }
 
+void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu)
+{
+	spin_lock(&vcpu->arch.mp_state_lock);
+	__kvm_riscv_vcpu_power_on(vcpu);
+	spin_unlock(&vcpu->arch.mp_state_lock);
+}
+
+bool kvm_riscv_vcpu_stopped(struct kvm_vcpu *vcpu)
+{
+	return READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_STOPPED;
+}
+
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	if (vcpu->arch.power_off)
-		mp_state->mp_state = KVM_MP_STATE_STOPPED;
-	else
-		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
+	*mp_state = READ_ONCE(vcpu->arch.mp_state);
 
 	return 0;
 }
@@ -450,17 +468,21 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 {
 	int ret = 0;
 
+	spin_lock(&vcpu->arch.mp_state_lock);
+
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
-		vcpu->arch.power_off = false;
+		WRITE_ONCE(vcpu->arch.mp_state, *mp_state);
 		break;
 	case KVM_MP_STATE_STOPPED:
-		kvm_riscv_vcpu_power_off(vcpu);
+		__kvm_riscv_vcpu_power_off(vcpu);
 		break;
 	default:
 		ret = -EINVAL;
 	}
 
+	spin_unlock(&vcpu->arch.mp_state_lock);
+
 	return ret;
 }
 
@@ -561,11 +583,11 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu)) {
 			kvm_vcpu_srcu_read_unlock(vcpu);
 			rcuwait_wait_event(wait,
-				(!vcpu->arch.power_off) && (!vcpu->arch.pause),
+				(!kvm_riscv_vcpu_stopped(vcpu)) && (!vcpu->arch.pause),
 				TASK_INTERRUPTIBLE);
 			kvm_vcpu_srcu_read_lock(vcpu);
 
-			if (vcpu->arch.power_off || vcpu->arch.pause) {
+			if (kvm_riscv_vcpu_stopped(vcpu) || vcpu->arch.pause) {
 				/*
 				 * Awaken to handle a signal, request to
 				 * sleep again later.
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 7a7fe40d0930b..be43278109f4e 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -102,8 +102,11 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 	unsigned long i;
 	struct kvm_vcpu *tmp;
 
-	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
-		tmp->arch.power_off = true;
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+		spin_lock(&vcpu->arch.mp_state_lock);
+		WRITE_ONCE(tmp->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
+		spin_unlock(&vcpu->arch.mp_state_lock);
+	}
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
 	memset(&run->system_event, 0, sizeof(run->system_event));
diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index 7dca0e9381d9a..827d946ab8714 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -18,12 +18,18 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 	struct kvm_vcpu *target_vcpu;
 	unsigned long target_vcpuid = cp->a0;
+	int ret = 0;
 
 	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
 	if (!target_vcpu)
 		return SBI_ERR_INVALID_PARAM;
-	if (!target_vcpu->arch.power_off)
-		return SBI_ERR_ALREADY_AVAILABLE;
+
+	spin_lock(&target_vcpu->arch.mp_state_lock);
+
+	if (!kvm_riscv_vcpu_stopped(target_vcpu)) {
+		ret = SBI_ERR_ALREADY_AVAILABLE;
+		goto out;
+	}
 
 	reset_cntx = &target_vcpu->arch.guest_reset_context;
 	/* start address */
@@ -34,19 +40,31 @@ static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
 	reset_cntx->a1 = cp->a2;
 	kvm_make_request(KVM_REQ_VCPU_RESET, target_vcpu);
 
-	kvm_riscv_vcpu_power_on(target_vcpu);
+	__kvm_riscv_vcpu_power_on(target_vcpu);
 
-	return 0;
+out:
+	spin_unlock(&target_vcpu->arch.mp_state_lock);
+
+	return ret;
 }
 
 static int kvm_sbi_hsm_vcpu_stop(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.power_off)
-		return SBI_ERR_FAILURE;
+	int ret = 0;
 
-	kvm_riscv_vcpu_power_off(vcpu);
+	spin_lock(&vcpu->arch.mp_state_lock);
 
-	return 0;
+	if (kvm_riscv_vcpu_stopped(vcpu)) {
+		ret = SBI_ERR_FAILURE;
+		goto out;
+	}
+
+	__kvm_riscv_vcpu_power_off(vcpu);
+
+out:
+	spin_unlock(&vcpu->arch.mp_state_lock);
+
+	return ret;
 }
 
 static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
@@ -58,7 +76,7 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
 	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
 	if (!target_vcpu)
 		return SBI_ERR_INVALID_PARAM;
-	if (!target_vcpu->arch.power_off)
+	if (!kvm_riscv_vcpu_stopped(target_vcpu))
 		return SBI_HSM_STATE_STARTED;
 	else if (vcpu->stat.generic.blocking)
 		return SBI_HSM_STATE_SUSPENDED;
@@ -71,14 +89,11 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 {
 	int ret = 0;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
-	struct kvm *kvm = vcpu->kvm;
 	unsigned long funcid = cp->a6;
 
 	switch (funcid) {
 	case SBI_EXT_HSM_HART_START:
-		mutex_lock(&kvm->lock);
 		ret = kvm_sbi_hsm_vcpu_start(vcpu);
-		mutex_unlock(&kvm->lock);
 		break;
 	case SBI_EXT_HSM_HART_STOP:
 		ret = kvm_sbi_hsm_vcpu_stop(vcpu);
-- 
2.39.5



