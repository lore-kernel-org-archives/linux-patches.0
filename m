Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FB5168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605E6C433D2;
	Mon,  8 May 2023 10:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543339;
	bh=SMFIXUIWqeYELLyq6WxcJPxoahWwHnZMCJ12D43Z72w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+QyP9Kduunb2noRS+35RHRnMblSSxtmJVJDQOqK6sd3PQWGcQgn3FBsKb1t28RSJ
	 rdDhZ+TbIvMU5JLqWT3RbVRu4psHUC/m33UhTYFww0k1HXCrXxXFWV71bP1CkM3Y2d
	 vGa75NJJNMUryuXw5X/fQEusxt4PSsbe8dnh53IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Linton <jeremy.linton@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.3 059/694] KVM: arm64: Avoid lock inversion when setting the VM register width
Date: Mon,  8 May 2023 11:38:14 +0200
Message-Id: <20230508094434.496428690@linuxfoundation.org>
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

commit c43120afb5c66a3465c7468f5cf9806a26484cde upstream.

kvm->lock must be taken outside of the vcpu->mutex. Of course, the
locking documentation for KVM makes this abundantly clear. Nonetheless,
the locking order in KVM/arm64 has been wrong for quite a while; we
acquire the kvm->lock while holding the vcpu->mutex all over the shop.

All was seemingly fine until commit 42a90008f890 ("KVM: Ensure lockdep
knows about kvm->lock vs. vcpu->mutex ordering rule") caught us with our
pants down, leading to lockdep barfing:

 ======================================================
 WARNING: possible circular locking dependency detected
 6.2.0-rc7+ #19 Not tainted
 ------------------------------------------------------
 qemu-system-aar/859 is trying to acquire lock:
 ffff5aa69269eba0 (&host_kvm->lock){+.+.}-{3:3}, at: kvm_reset_vcpu+0x34/0x274

 but task is already holding lock:
 ffff5aa68768c0b8 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x8c/0xba0

 which lock already depends on the new lock.

Add a dedicated lock to serialize writes to VM-scoped configuration from
the context of a vCPU. Protect the register width flags with the new
lock, thus avoiding the need to grab the kvm->lock while holding
vcpu->mutex in kvm_reset_vcpu().

Cc: stable@vger.kernel.org
Reported-by: Jeremy Linton <jeremy.linton@arm.com>
Link: https://lore.kernel.org/kvmarm/f6452cdd-65ff-34b8-bab0-5c06416da5f6@arm.com/
Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230327164747.2466958-3-oliver.upton@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h |    3 +++
 arch/arm64/kvm/arm.c              |   18 ++++++++++++++++++
 arch/arm64/kvm/reset.c            |    6 +++---
 3 files changed, 24 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -199,6 +199,9 @@ struct kvm_arch {
 	/* Mandated version of PSCI */
 	u32 psci_version;
 
+	/* Protects VM-scoped configuration data */
+	struct mutex config_lock;
+
 	/*
 	 * If we encounter a data abort without valid instruction syndrome
 	 * information, report this to user space.  User space can (and
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -128,6 +128,16 @@ int kvm_arch_init_vm(struct kvm *kvm, un
 {
 	int ret;
 
+	mutex_init(&kvm->arch.config_lock);
+
+#ifdef CONFIG_LOCKDEP
+	/* Clue in lockdep that the config_lock must be taken inside kvm->lock */
+	mutex_lock(&kvm->lock);
+	mutex_lock(&kvm->arch.config_lock);
+	mutex_unlock(&kvm->arch.config_lock);
+	mutex_unlock(&kvm->lock);
+#endif
+
 	ret = kvm_share_hyp(kvm, kvm + 1);
 	if (ret)
 		return ret;
@@ -329,6 +339,14 @@ int kvm_arch_vcpu_create(struct kvm_vcpu
 
 	spin_lock_init(&vcpu->arch.mp_state_lock);
 
+#ifdef CONFIG_LOCKDEP
+	/* Inform lockdep that the config_lock is acquired after vcpu->mutex */
+	mutex_lock(&vcpu->mutex);
+	mutex_lock(&vcpu->kvm->arch.config_lock);
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
+	mutex_unlock(&vcpu->mutex);
+#endif
+
 	/* Force users to call KVM_ARM_VCPU_INIT */
 	vcpu->arch.target = -1;
 	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -205,7 +205,7 @@ static int kvm_set_vm_width(struct kvm_v
 
 	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
 
-	lockdep_assert_held(&kvm->lock);
+	lockdep_assert_held(&kvm->arch.config_lock);
 
 	if (test_bit(KVM_ARCH_FLAG_REG_WIDTH_CONFIGURED, &kvm->arch.flags)) {
 		/*
@@ -262,9 +262,9 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu
 	bool loaded;
 	u32 pstate;
 
-	mutex_lock(&vcpu->kvm->lock);
+	mutex_lock(&vcpu->kvm->arch.config_lock);
 	ret = kvm_set_vm_width(vcpu);
-	mutex_unlock(&vcpu->kvm->lock);
+	mutex_unlock(&vcpu->kvm->arch.config_lock);
 
 	if (ret)
 		return ret;


