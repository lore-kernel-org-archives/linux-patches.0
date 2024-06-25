Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A2912EBEA;
	Tue, 25 Jun 2024 09:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308650; cv=none; b=XIt37zoswhIz5G5twNd2IDdw7QBqcAzfLaG5gHwM7y5EwD1Q1HjHp/LX521PmnBZuAs5foynQVM4r1WwkcEGwbvrjIg8BBK3xaHssznihmXekx7h6QDWSjQSzeH0PhhkV1pTF/3pYVLhxvpx3TFctTRb32U5J4VY6n7NqwwpN0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308650; c=relaxed/simple;
	bh=Ia38vSLdukPEr7X0Nz+xKZocu3HCawJ2U1d2Nxrcnqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhm07gD+IpIw9zgp5brCusehPy2dMnvXBEwgIRLAAfQdzt5gClsxuMgAwFeFYGiX2Zm1/rAFB5aKd+LLFG7hDOSmdslpAEz6V14Me+kxGNN6OHrTIP7GayeaniMFq5hX23fHT+gmIw5E4fvEbAAYNDPsNCJqMbuahjccbuqzS3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h13by+Du; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h13by+Du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38023C32781;
	Tue, 25 Jun 2024 09:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308650;
	bh=Ia38vSLdukPEr7X0Nz+xKZocu3HCawJ2U1d2Nxrcnqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h13by+Duq+wb1W4F380MQZN3xogMwzVffIPWnCYlIxQOz6mUmfYnSAo7hJGivyBqa
	 fLDQb5OXOCe0A+aV0kVksmmhdIZwbzBUjVNDFuzSVPn59nTXwgRATkEsB6B0ktZhWT
	 S/7Tjkfh+QTBiW47S59r2WdsH3aOPt8IWK7Wsrf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.9 192/250] KVM: arm64: Disassociate vcpus from redistributor region on teardown
Date: Tue, 25 Jun 2024 11:32:30 +0200
Message-ID: <20240625085555.421228123@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 0d92e4a7ffd5c42b9fa864692f82476c0bf8bcc8 upstream.

When tearing down a redistributor region, make sure we don't have
any dangling pointer to that region stored in a vcpu.

Fixes: e5a35635464b ("kvm: arm64: vgic-v3: Introduce vgic_v3_free_redist_region()")
Reported-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240605175637.1635653-1-maz@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-init.c    |    2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |   15 +++++++++++++--
 arch/arm64/kvm/vgic/vgic.h         |    2 +-
 3 files changed, 15 insertions(+), 4 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -355,7 +355,7 @@ static void kvm_vgic_dist_destroy(struct
 
 	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
 		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list)
-			vgic_v3_free_redist_region(rdreg);
+			vgic_v3_free_redist_region(kvm, rdreg);
 		INIT_LIST_HEAD(&dist->rd_regions);
 	} else {
 		dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -919,8 +919,19 @@ free:
 	return ret;
 }
 
-void vgic_v3_free_redist_region(struct vgic_redist_region *rdreg)
+void vgic_v3_free_redist_region(struct kvm *kvm, struct vgic_redist_region *rdreg)
 {
+	struct kvm_vcpu *vcpu;
+	unsigned long c;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	/* Garbage collect the region */
+	kvm_for_each_vcpu(c, vcpu, kvm) {
+		if (vcpu->arch.vgic_cpu.rdreg == rdreg)
+			vcpu->arch.vgic_cpu.rdreg = NULL;
+	}
+
 	list_del(&rdreg->list);
 	kfree(rdreg);
 }
@@ -945,7 +956,7 @@ int vgic_v3_set_redist_base(struct kvm *
 
 		mutex_lock(&kvm->arch.config_lock);
 		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
-		vgic_v3_free_redist_region(rdreg);
+		vgic_v3_free_redist_region(kvm, rdreg);
 		mutex_unlock(&kvm->arch.config_lock);
 		return ret;
 	}
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -317,7 +317,7 @@ vgic_v3_rd_region_size(struct kvm *kvm,
 
 struct vgic_redist_region *vgic_v3_rdist_region_from_index(struct kvm *kvm,
 							   u32 index);
-void vgic_v3_free_redist_region(struct vgic_redist_region *rdreg);
+void vgic_v3_free_redist_region(struct kvm *kvm, struct vgic_redist_region *rdreg);
 
 bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size);
 


