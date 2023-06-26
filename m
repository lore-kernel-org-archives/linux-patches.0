Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2FF12B9C
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8D0C433C9;
	Mon, 26 Jun 2023 18:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803841;
	bh=zDkmCzoJ4gm1dJ3VkRsGn50ZQ7htLUi14Cd3SrW/GRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECkKTFQhzj1xnGOxs3AEaUyPRH0IKY7nwA7OBK18JNCbarSQGFBhRRJj6iYRZGjTT
	 hNVwvVQwIS8rofuvmnSTcsczBo7HUEXA860Yx1bDpntf9081WbUbjMYB3OhwZBrq3D
	 PaIDLTQ5r5NZNeBtOv5MgIbYlcJAhuJ86iN0wFSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.3 196/199] KVM: arm64: Restore GICv2-on-GICv3 functionality
Date: Mon, 26 Jun 2023 20:11:42 +0200
Message-ID: <20230626180814.344897430@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

commit 1caa71a7a600f7781ce05ef1e84701c459653663 upstream.

When reworking the vgic locking, the vgic distributor registration
got simplified, which was a very good cleanup. But just a tad too
radical, as we now register the *native* vgic only, ignoring the
GICv2-on-GICv3 that allows pre-historic VMs (or so I thought)
to run.

As it turns out, QEMU still defaults to GICv2 in some cases, and
this breaks Nathan's setup!

Fix it by propagating the *requested* vgic type rather than the
host's version.

Fixes: 59112e9c390b ("KVM: arm64: vgic: Fix a circular locking issue")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
link: https://lore.kernel.org/r/20230606221525.GA2269598@dev-arch.thelio-3990X
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-init.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -446,6 +446,7 @@ int vgic_lazy_init(struct kvm *kvm)
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	enum vgic_type type;
 	gpa_t dist_base;
 	int ret = 0;
 
@@ -460,10 +461,13 @@ int kvm_vgic_map_resources(struct kvm *k
 	if (!irqchip_in_kernel(kvm))
 		goto out;
 
-	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
+	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2) {
 		ret = vgic_v2_map_resources(kvm);
-	else
+		type = VGIC_V2;
+	} else {
 		ret = vgic_v3_map_resources(kvm);
+		type = VGIC_V3;
+	}
 
 	if (ret) {
 		__kvm_vgic_destroy(kvm);
@@ -473,8 +477,7 @@ int kvm_vgic_map_resources(struct kvm *k
 	dist_base = dist->vgic_dist_base;
 	mutex_unlock(&kvm->arch.config_lock);
 
-	ret = vgic_register_dist_iodev(kvm, dist_base,
-				       kvm_vgic_global_state.type);
+	ret = vgic_register_dist_iodev(kvm, dist_base, type);
 	if (ret) {
 		kvm_err("Unable to register VGIC dist MMIO regions\n");
 		kvm_vgic_destroy(kvm);


