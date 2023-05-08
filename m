Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F44168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B03C433D2;
	Mon,  8 May 2023 10:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543342;
	bh=GS78Kwo1Pmcfx7vRMttqCzXhHSMzOBqtrq80ebbvM0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2TPvJmz5o9SBj0k3/9t8ZaKwFanltR1powVpHUSO/UEHsPotvp//VaHP157cO1Xs
	 tgHzbM/ng9LiMe7GwtK6eA0Zoqq6W6UYFvZgRZIZJhtLtj+5LKwfzyWkISutbwQXXD
	 14wLTsbPyeSCtF7KQE2tuJ8MLFrJjIXku2afNq5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Linton <jeremy.linton@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.3 060/694] KVM: arm64: Use config_lock to protect data ordered against KVM_RUN
Date: Mon,  8 May 2023 11:38:15 +0200
Message-Id: <20230508094434.525476378@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

commit 4bba7f7def6f278266dadf845da472cfbfed784e upstream.

There are various bits of VM-scoped data that can only be configured
before the first call to KVM_RUN, such as the hypercall bitmaps and
the PMU. As these fields are protected by the kvm->lock and accessed
while holding vcpu->mutex, this is yet another example of lock
inversion.

Change out the kvm->lock for kvm->arch.config_lock in all of these
instances. Opportunistically simplify the locking mechanics of the
PMU configuration by holding the config_lock for the entirety of
kvm_arm_pmu_v3_set_attr().

Note that this also addresses a couple of bugs. There is an unguarded
read of the PMU version in KVM_ARM_VCPU_PMU_V3_FILTER which could race
with KVM_ARM_VCPU_PMU_V3_SET_PMU. Additionally, until now writes to the
per-vCPU vPMU irq were not serialized VM-wide, meaning concurrent calls
to KVM_ARM_VCPU_PMU_V3_IRQ could lead to a false positive in
pmu_irq_is_valid().

Cc: stable@vger.kernel.org
Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230327164747.2466958-4-oliver.upton@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/arm.c        |    4 ++--
 arch/arm64/kvm/guest.c      |    2 ++
 arch/arm64/kvm/hypercalls.c |    4 ++--
 arch/arm64/kvm/pmu-emul.c   |   23 ++++++-----------------
 4 files changed, 12 insertions(+), 21 deletions(-)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -625,9 +625,9 @@ int kvm_arch_vcpu_run_pid_change(struct
 	if (kvm_vm_is_protected(kvm))
 		kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 
 	return ret;
 }
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -957,7 +957,9 @@ int kvm_arm_vcpu_arch_set_attr(struct kv
 
 	switch (attr->group) {
 	case KVM_ARM_VCPU_PMU_V3_CTRL:
+		mutex_lock(&vcpu->kvm->arch.config_lock);
 		ret = kvm_arm_pmu_v3_set_attr(vcpu, attr);
+		mutex_unlock(&vcpu->kvm->arch.config_lock);
 		break;
 	case KVM_ARM_VCPU_TIMER_CTRL:
 		ret = kvm_arm_timer_set_attr(vcpu, attr);
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -377,7 +377,7 @@ static int kvm_arm_set_fw_reg_bmap(struc
 	if (val & ~fw_reg_features)
 		return -EINVAL;
 
-	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
 
 	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags) &&
 	    val != *fw_reg_bmap) {
@@ -387,7 +387,7 @@ static int kvm_arm_set_fw_reg_bmap(struc
 
 	WRITE_ONCE(*fw_reg_bmap, val);
 out:
-	mutex_unlock(&kvm->lock);
+	mutex_unlock(&kvm->arch.config_lock);
 	return ret;
 }
 
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -876,7 +876,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct
 	struct arm_pmu *arm_pmu;
 	int ret = -ENXIO;
 
-	mutex_lock(&kvm->lock);
+	lockdep_assert_held(&kvm->arch.config_lock);
 	mutex_lock(&arm_pmus_lock);
 
 	list_for_each_entry(entry, &arm_pmus, entry) {
@@ -896,7 +896,6 @@ static int kvm_arm_pmu_v3_set_pmu(struct
 	}
 
 	mutex_unlock(&arm_pmus_lock);
-	mutex_unlock(&kvm->lock);
 	return ret;
 }
 
@@ -904,22 +903,20 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_v
 {
 	struct kvm *kvm = vcpu->kvm;
 
+	lockdep_assert_held(&kvm->arch.config_lock);
+
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return -ENODEV;
 
 	if (vcpu->arch.pmu.created)
 		return -EBUSY;
 
-	mutex_lock(&kvm->lock);
 	if (!kvm->arch.arm_pmu) {
 		/* No PMU set, get the default one */
 		kvm->arch.arm_pmu = kvm_pmu_probe_armpmu();
-		if (!kvm->arch.arm_pmu) {
-			mutex_unlock(&kvm->lock);
+		if (!kvm->arch.arm_pmu)
 			return -ENODEV;
-		}
 	}
-	mutex_unlock(&kvm->lock);
 
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PMU_V3_IRQ: {
@@ -963,19 +960,13 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_v
 		     filter.action != KVM_PMU_EVENT_DENY))
 			return -EINVAL;
 
-		mutex_lock(&kvm->lock);
-
-		if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
-			mutex_unlock(&kvm->lock);
+		if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags))
 			return -EBUSY;
-		}
 
 		if (!kvm->arch.pmu_filter) {
 			kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
-			if (!kvm->arch.pmu_filter) {
-				mutex_unlock(&kvm->lock);
+			if (!kvm->arch.pmu_filter)
 				return -ENOMEM;
-			}
 
 			/*
 			 * The default depends on the first applied filter.
@@ -994,8 +985,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_v
 		else
 			bitmap_clear(kvm->arch.pmu_filter, filter.base_event, filter.nevents);
 
-		mutex_unlock(&kvm->lock);
-
 		return 0;
 	}
 	case KVM_ARM_VCPU_PMU_V3_SET_PMU: {


