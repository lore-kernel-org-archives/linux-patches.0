Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BAD1849DA;
	Wed,  3 Jul 2024 11:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006282; cv=none; b=UN+haUlpakJlXF/UUdCWiH2EeBsDutQX6pTGP5brQCR968/SyKguDJJyWekVzE9ITkkzNpN23866u5OKUkaWecIy2C7hr7T8XRzcZVkcQ0zX03MC0ak6Wls0+oOgraZrWhMcIXyP8i0vA4t3fFRColAn9WHau1hBT8uSmYVhiqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006282; c=relaxed/simple;
	bh=cq3o8YIAfYP5vaKXQMzs+rvPG8sVJkvb+SKObfyCMY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzhnryTZke8TYVF4vzZV5N+cWzeevMtU+7eipOfCH8ZcoxAzZ36E417VgsEdPt9gsBQPXpZuOvuzghXrEBtZ7X2FoOy7MBaQGvwwkpjYqlpBBP4blz1YcXkjr6BgKoik7Wil69+gOzoxThjHfxi9ArhmNAAEyiAOyqnyiqTxgR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHIQojsN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHIQojsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5145C2BD10;
	Wed,  3 Jul 2024 11:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006282;
	bh=cq3o8YIAfYP5vaKXQMzs+rvPG8sVJkvb+SKObfyCMY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHIQojsNVL+e/JGDXraYVsiSm7F0U8hrnbK1pRpL+RiBny3+1BleLlVAeNNIBgGQy
	 eC5s/ctIOrDaskyKJnzPG1RNa7T7vmHZeMDeXSe6f3rg415C1pZIyH1o6FMiQPJdHZ
	 G8Ib3k3mEuyAohrHvSVX8NdMExrvOo5pSnFkvhG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Chen <chenxiang66@hisilicon.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Gowans <jgowans@amazon.com>
Subject: [PATCH 5.15 353/356] KVM: arm64: vgic-v4: Make the doorbell request robust w.r.t preemption
Date: Wed,  3 Jul 2024 12:41:29 +0200
Message-ID: <20240703102926.462520218@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit b321c31c9b7b309dcde5e8854b741c8e6a9a05f0 upstream.

Xiang reports that VMs occasionally fail to boot on GICv4.1 systems when
running a preemptible kernel, as it is possible that a vCPU is blocked
without requesting a doorbell interrupt.

The issue is that any preemption that occurs between vgic_v4_put() and
schedule() on the block path will mark the vPE as nonresident and *not*
request a doorbell irq. This occurs because when the vcpu thread is
resumed on its way to block, vcpu_load() will make the vPE resident
again. Once the vcpu actually blocks, we don't request a doorbell
anymore, and the vcpu won't be woken up on interrupt delivery.

Fix it by tracking that we're entering WFI, and key the doorbell
request on that flag. This allows us not to make the vPE resident
when going through a preempt/schedule cycle, meaning we don't lose
any state.

Cc: stable@vger.kernel.org
Fixes: 8e01d9a396e6 ("KVM: arm64: vgic-v4: Move the GICv4 residency flow to be driven by vcpu_load/put")
Reported-by: Xiang Chen <chenxiang66@hisilicon.com>
Suggested-by: Zenghui Yu <yuzenghui@huawei.com>
Tested-by: Xiang Chen <chenxiang66@hisilicon.com>
Co-developed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Zenghui Yu <yuzenghui@huawei.com>
Link: https://lore.kernel.org/r/20230713070657.3873244-1-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
[ modified to wrangle the vCPU flags directly instead of going through
  the flag helper macros as they have not yet been introduced. Also doing
  the flag wranging in the kvm_arch_vcpu_{un}blocking() hooks as the
  introduction of kvm_vcpu_wfi has not yet happened. See:
  6109c5a6ab7f ("KVM: arm64: Move vGIC v4 handling for WFI out arch callback hook") ]
Signed-off-by: James Gowans <jgowans@amazon.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/kvm_host.h |    1 +
 arch/arm64/kvm/arm.c              |    6 ++++--
 arch/arm64/kvm/vgic/vgic-v3.c     |    2 +-
 arch/arm64/kvm/vgic/vgic-v4.c     |    8 ++++++--
 include/kvm/arm_vgic.h            |    2 +-
 5 files changed, 13 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -419,6 +419,7 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_EXCEPT_MASK		(7 << 9) /* Target EL/MODE */
 #define KVM_ARM64_DEBUG_STATE_SAVE_SPE	(1 << 12) /* Save SPE context if active  */
 #define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
+#define KVM_ARM64_VCPU_IN_WFI		(1 << 14) /* WFI instruction trapped */
 
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -379,13 +379,15 @@ void kvm_arch_vcpu_blocking(struct kvm_v
 	 */
 	preempt_disable();
 	kvm_vgic_vmcr_sync(vcpu);
-	vgic_v4_put(vcpu, true);
+	vcpu->arch.flags |= KVM_ARM64_VCPU_IN_WFI;
+	vgic_v4_put(vcpu);
 	preempt_enable();
 }
 
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
+	vcpu->arch.flags &= ~KVM_ARM64_VCPU_IN_WFI;
 	vgic_v4_load(vcpu);
 	preempt_enable();
 }
@@ -696,7 +698,7 @@ static void check_vcpu_requests(struct k
 		if (kvm_check_request(KVM_REQ_RELOAD_GICv4, vcpu)) {
 			/* The distributor enable bits were changed */
 			preempt_disable();
-			vgic_v4_put(vcpu, false);
+			vgic_v4_put(vcpu);
 			vgic_v4_load(vcpu);
 			preempt_enable();
 		}
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -715,7 +715,7 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	WARN_ON(vgic_v4_put(vcpu, false));
+	WARN_ON(vgic_v4_put(vcpu));
 
 	vgic_v3_vmcr_sync(vcpu);
 
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -333,14 +333,15 @@ void vgic_v4_teardown(struct kvm *kvm)
 	its_vm->vpes = NULL;
 }
 
-int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db)
+int vgic_v4_put(struct kvm_vcpu *vcpu)
 {
 	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
 
 	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
 		return 0;
 
-	return its_make_vpe_non_resident(vpe, need_db);
+	return its_make_vpe_non_resident(vpe,
+			vcpu->arch.flags & KVM_ARM64_VCPU_IN_WFI);
 }
 
 int vgic_v4_load(struct kvm_vcpu *vcpu)
@@ -351,6 +352,9 @@ int vgic_v4_load(struct kvm_vcpu *vcpu)
 	if (!vgic_supports_direct_msis(vcpu->kvm) || vpe->resident)
 		return 0;
 
+	if (vcpu->arch.flags & KVM_ARM64_VCPU_IN_WFI)
+		return 0;
+
 	/*
 	 * Before making the VPE resident, make sure the redistributor
 	 * corresponding to our current CPU expects us here. See the
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -423,6 +423,6 @@ int kvm_vgic_v4_unset_forwarding(struct
 
 int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
-int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db);
+int vgic_v4_put(struct kvm_vcpu *vcpu);
 
 #endif /* __KVM_ARM_VGIC_H */


