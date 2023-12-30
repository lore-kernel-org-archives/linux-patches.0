Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC92579DD;
	Sat, 30 Dec 2023 12:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5MF52Kt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657E0C433C7;
	Sat, 30 Dec 2023 12:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938336;
	bh=iQw6TlIsKCSqpMX1DTxMWDe2i63gANPBEmBo5KSMD0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5MF52Ktbh5f+xj+pReHGd0RTWCPvqn3ALQf4Gi/b2ndbqxcUGxD+Ga8GN9OJ63fo
	 F/H0hxdkdd0jLb1UZQwEepZ01p+6LS+cRwzvI3Fd2B7yMtU28lVeMSpkQmIAnDwNfH
	 J0lH+2SfxRlwy/2pdUGnWsYaA6yy98dxDU4gjj+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.1 107/112] KVM: arm64: vgic: Force vcpu vgic teardown on vcpu destroy
Date: Sat, 30 Dec 2023 12:00:20 +0000
Message-ID: <20231230115810.194205263@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 02e3858f08faabab9503ae2911cf7c7e27702257 upstream.

When failing to create a vcpu because (for example) it has a
duplicate vcpu_id, we destroy the vcpu. Amusingly, this leaves
the redistributor registered with the KVM_MMIO bus.

This is no good, and we should properly clean the mess. Force
a teardown of the vgic vcpu interface, including the RD device
before returning to the caller.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20231207151201.3028710-4-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/arm.c               |    2 +-
 arch/arm64/kvm/vgic/vgic-init.c    |    5 ++++-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |    2 +-
 arch/arm64/kvm/vgic/vgic.h         |    1 +
 4 files changed, 7 insertions(+), 3 deletions(-)

--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -386,7 +386,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vc
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
-
+	kvm_vgic_vcpu_destroy(vcpu);
 	kvm_arm_vcpu_destroy(vcpu);
 }
 
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -379,7 +379,10 @@ static void __kvm_vgic_vcpu_destroy(stru
 	vgic_flush_pending_lpis(vcpu);
 
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
-	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+		vgic_unregister_redist_iodev(vcpu);
+		vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+	}
 }
 
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -820,7 +820,7 @@ out_unlock:
 	return ret;
 }
 
-static void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
+void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
 {
 	struct vgic_io_device *rd_dev = &vcpu->arch.vgic_cpu.rd_iodev;
 
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -229,6 +229,7 @@ int vgic_v3_lpi_sync_pending_status(stru
 int vgic_v3_save_pending_tables(struct kvm *kvm);
 int vgic_v3_set_redist_base(struct kvm *kvm, u32 index, u64 addr, u32 count);
 int vgic_register_redist_iodev(struct kvm_vcpu *vcpu);
+void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu);
 bool vgic_v3_check_base(struct kvm *kvm);
 
 void vgic_v3_load(struct kvm_vcpu *vcpu);


