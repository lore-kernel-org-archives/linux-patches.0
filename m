Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF9F13C90B;
	Tue, 25 Jun 2024 10:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309803; cv=none; b=Au59lqj6d65gMcH2343C1c2DNdAr+5DbKrgdnkqnEJp7yK5o6sbMaYd6avzpsJv/sN7FC8Vfg05pHFPy7Xr5qVuPPPOtopHR08ao7NXHAKIQW2UjQdwsJqmHpZfQS+gaL+FDeYk12xSHKW7sB94nAuckDke1L8G+vorrJFyPpGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309803; c=relaxed/simple;
	bh=IiB5E5MCpitwnuOtmxqjuAZuev4wRz/9F44X4pfD70U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGGLv99dmpawUs3RAhyYqrL50ZolZLukFao7jkBKZleA2fVrG1euIejEHliYv5O4CqfiWzXawaIblF+zt5yS1C6ZkDTVxTcFKzUxzhVrWVfsHV4SXBbyRauY/pG4oTkIq5Rk3MwE2eGjX6ORC8MGH7I4o/eVA0+fkEJsVT1Avag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuSTgzLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuSTgzLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AA5C32786;
	Tue, 25 Jun 2024 10:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309803;
	bh=IiB5E5MCpitwnuOtmxqjuAZuev4wRz/9F44X4pfD70U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuSTgzLcEmx96H/vlz3HWThKS/l0Yc5NKSCpAtImyEGODJeaEvLa8JxeR1SX+hA5X
	 C1/QHqV3pIWhH2hfKwQ8mN1AEK/s+AufH41KLhkYt3tvC7qvxtRJJXai/qSkCXeY8p
	 Mj1Nn1dUPzduhgkZnQ8nByW2yg1EvPhZgRj41vS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 100/131] KVM: arm64: Disassociate vcpus from redistributor region on teardown
Date: Tue, 25 Jun 2024 11:34:15 +0200
Message-ID: <20240625085529.739252282@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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
@@ -942,8 +942,19 @@ free:
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
@@ -968,7 +979,7 @@ int vgic_v3_set_redist_base(struct kvm *
 
 		mutex_lock(&kvm->arch.config_lock);
 		rdreg = vgic_v3_rdist_region_from_index(kvm, index);
-		vgic_v3_free_redist_region(rdreg);
+		vgic_v3_free_redist_region(kvm, rdreg);
 		mutex_unlock(&kvm->arch.config_lock);
 		return ret;
 	}
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -301,7 +301,7 @@ vgic_v3_rd_region_size(struct kvm *kvm,
 
 struct vgic_redist_region *vgic_v3_rdist_region_from_index(struct kvm *kvm,
 							   u32 index);
-void vgic_v3_free_redist_region(struct vgic_redist_region *rdreg);
+void vgic_v3_free_redist_region(struct kvm *kvm, struct vgic_redist_region *rdreg);
 
 bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size);
 


