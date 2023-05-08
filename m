Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E28A168C2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7924EC4339B;
	Mon,  8 May 2023 10:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541325;
	bh=X5jNEBYBe81yA+0iQb0bkyx+ceMdKOH33ZS35tsklFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbXBrXvJuWMy5gq7IMxeYWR/5Qnba2FkUsRlnTEFA+5p2umFoIkUHyQsGFnUUW2Xf
	 u1gChW8WSzYYdIxBbwh6yqeYcPOa/lpIf3Wzj0QvvbiOPHCls+Fraa4xCd3VSZcw37
	 h8uyI93WtLEv1ywlbPkp0uWNkPuXAf/4bcBu8n6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Linton <jeremy.linton@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.2 079/663] KVM: arm64: Avoid vcpu->mutex v. kvm->lock inversion in CPU_ON
Date: Mon,  8 May 2023 11:38:25 +0200
Message-Id: <20230508094431.020496965@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

commit 0acc7239c20a8401b8968c2adace8f7c9b0295ae upstream.

KVM/arm64 had the lock ordering backwards on vcpu->mutex and kvm->lock
from the very beginning. One such example is the way vCPU resets are
handled: the kvm->lock is acquired while handling a guest CPU_ON PSCI
call.

Add a dedicated lock to serialize writes to kvm_vcpu_arch::{mp_state,
reset_state}. Promote all accessors of mp_state to {READ,WRITE}_ONCE()
as readers do not acquire the mp_state_lock. While at it, plug yet
another race by taking the mp_state_lock in the KVM_SET_MP_STATE ioctl
handler.

As changes to MP state are now guarded with a dedicated lock, drop the
kvm->lock acquisition from the PSCI CPU_ON path. Similarly, move the
reader of reset_state outside of the kvm->lock and instead protect it
with the mp_state_lock. Note that writes to reset_state::reset have been
demoted to regular stores as both readers and writers acquire the
mp_state_lock.

While the kvm->lock inversion still exists in kvm_reset_vcpu(), at least
now PSCI CPU_ON no longer depends on it for serializing vCPU reset.

Cc: stable@vger.kernel.org
Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230327164747.2466958-2-oliver.upton@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h |    1 +
 arch/arm64/kvm/arm.c              |   31 ++++++++++++++++++++++---------
 arch/arm64/kvm/psci.c             |   28 ++++++++++++++++------------
 arch/arm64/kvm/reset.c            |    9 +++++----
 4 files changed, 44 insertions(+), 25 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -482,6 +482,7 @@ struct kvm_vcpu_arch {
 
 	/* vcpu power state */
 	struct kvm_mp_state mp_state;
+	spinlock_t mp_state_lock;
 
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -336,6 +336,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
 {
 	int err;
 
+	spin_lock_init(&vcpu->arch.mp_state_lock);
+
 	/* Force users to call KVM_ARM_VCPU_INIT */
 	vcpu->arch.target = -1;
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
@@ -453,34 +455,41 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *
 	vcpu->cpu = -1;
 }
 
-void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
+static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
+	WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
 	kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
+void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
+{
+	spin_lock(&vcpu->arch.mp_state_lock);
+	__kvm_arm_vcpu_power_off(vcpu);
+	spin_unlock(&vcpu->arch.mp_state_lock);
+}
+
 bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_STOPPED;
+	return READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_STOPPED;
 }
 
 static void kvm_arm_vcpu_suspend(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_SUSPENDED;
+	WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_SUSPENDED);
 	kvm_make_request(KVM_REQ_SUSPEND, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
 static bool kvm_arm_vcpu_suspended(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_SUSPENDED;
+	return READ_ONCE(vcpu->arch.mp_state.mp_state) == KVM_MP_STATE_SUSPENDED;
 }
 
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	*mp_state = vcpu->arch.mp_state;
+	*mp_state = READ_ONCE(vcpu->arch.mp_state);
 
 	return 0;
 }
@@ -490,12 +499,14 @@ int kvm_arch_vcpu_ioctl_set_mpstate(stru
 {
 	int ret = 0;
 
+	spin_lock(&vcpu->arch.mp_state_lock);
+
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
-		vcpu->arch.mp_state = *mp_state;
+		WRITE_ONCE(vcpu->arch.mp_state, *mp_state);
 		break;
 	case KVM_MP_STATE_STOPPED:
-		kvm_arm_vcpu_power_off(vcpu);
+		__kvm_arm_vcpu_power_off(vcpu);
 		break;
 	case KVM_MP_STATE_SUSPENDED:
 		kvm_arm_vcpu_suspend(vcpu);
@@ -504,6 +515,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(stru
 		ret = -EINVAL;
 	}
 
+	spin_unlock(&vcpu->arch.mp_state_lock);
+
 	return ret;
 }
 
@@ -1223,7 +1236,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init
 	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
 		kvm_arm_vcpu_power_off(vcpu);
 	else
-		vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
+		WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUNNABLE);
 
 	return 0;
 }
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -62,6 +62,7 @@ static unsigned long kvm_psci_vcpu_on(st
 	struct vcpu_reset_state *reset_state;
 	struct kvm *kvm = source_vcpu->kvm;
 	struct kvm_vcpu *vcpu = NULL;
+	int ret = PSCI_RET_SUCCESS;
 	unsigned long cpu_id;
 
 	cpu_id = smccc_get_arg1(source_vcpu);
@@ -76,11 +77,15 @@ static unsigned long kvm_psci_vcpu_on(st
 	 */
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
+
+	spin_lock(&vcpu->arch.mp_state_lock);
 	if (!kvm_arm_vcpu_stopped(vcpu)) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
-			return PSCI_RET_ALREADY_ON;
+			ret = PSCI_RET_ALREADY_ON;
 		else
-			return PSCI_RET_INVALID_PARAMS;
+			ret = PSCI_RET_INVALID_PARAMS;
+
+		goto out_unlock;
 	}
 
 	reset_state = &vcpu->arch.reset_state;
@@ -96,7 +101,7 @@ static unsigned long kvm_psci_vcpu_on(st
 	 */
 	reset_state->r0 = smccc_get_arg3(source_vcpu);
 
-	WRITE_ONCE(reset_state->reset, true);
+	reset_state->reset = true;
 	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
 
 	/*
@@ -108,7 +113,9 @@ static unsigned long kvm_psci_vcpu_on(st
 	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
 	kvm_vcpu_wake_up(vcpu);
 
-	return PSCI_RET_SUCCESS;
+out_unlock:
+	spin_unlock(&vcpu->arch.mp_state_lock);
+	return ret;
 }
 
 static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
@@ -168,8 +175,11 @@ static void kvm_prepare_system_event(str
 	 * after this call is handled and before the VCPUs have been
 	 * re-initialized.
 	 */
-	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
-		tmp->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+		spin_lock(&tmp->arch.mp_state_lock);
+		WRITE_ONCE(tmp->arch.mp_state.mp_state, KVM_MP_STATE_STOPPED);
+		spin_unlock(&tmp->arch.mp_state_lock);
+	}
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
 	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
@@ -229,7 +239,6 @@ static unsigned long kvm_psci_check_allo
 
 static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = vcpu->kvm;
 	u32 psci_fn = smccc_get_function(vcpu);
 	unsigned long val;
 	int ret = 1;
@@ -254,9 +263,7 @@ static int kvm_psci_0_2_call(struct kvm_
 		kvm_psci_narrow_to_32bit(vcpu);
 		fallthrough;
 	case PSCI_0_2_FN64_CPU_ON:
-		mutex_lock(&kvm->lock);
 		val = kvm_psci_vcpu_on(vcpu);
-		mutex_unlock(&kvm->lock);
 		break;
 	case PSCI_0_2_FN_AFFINITY_INFO:
 		kvm_psci_narrow_to_32bit(vcpu);
@@ -395,7 +402,6 @@ static int kvm_psci_1_x_call(struct kvm_
 
 static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = vcpu->kvm;
 	u32 psci_fn = smccc_get_function(vcpu);
 	unsigned long val;
 
@@ -405,9 +411,7 @@ static int kvm_psci_0_1_call(struct kvm_
 		val = PSCI_RET_SUCCESS;
 		break;
 	case KVM_PSCI_FN_CPU_ON:
-		mutex_lock(&kvm->lock);
 		val = kvm_psci_vcpu_on(vcpu);
-		mutex_unlock(&kvm->lock);
 		break;
 	default:
 		val = PSCI_RET_NOT_SUPPORTED;
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -255,15 +255,16 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu
 
 	mutex_lock(&vcpu->kvm->lock);
 	ret = kvm_set_vm_width(vcpu);
-	if (!ret) {
-		reset_state = vcpu->arch.reset_state;
-		WRITE_ONCE(vcpu->arch.reset_state.reset, false);
-	}
 	mutex_unlock(&vcpu->kvm->lock);
 
 	if (ret)
 		return ret;
 
+	spin_lock(&vcpu->arch.mp_state_lock);
+	reset_state = vcpu->arch.reset_state;
+	vcpu->arch.reset_state.reset = false;
+	spin_unlock(&vcpu->arch.mp_state_lock);
+
 	/* Reset PMU outside of the non-preemptible section */
 	kvm_pmu_vcpu_reset(vcpu);
 


