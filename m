Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E98F2C6AF;
	Sun,  1 Sep 2024 17:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210362; cv=none; b=IEnfUN2lpzLawTuIo/BY/SLoOryedonFxG4R1wxqfoe+T7wLxXO5TL7CFOkQjQO9DortP+KknSlPJ5MTLZVqjOHij+VREhyfoXUkA4FUXLiy86hVU5Yp3TJBJdfBJQsO/S92HOUSin2W2il1JVK1wVbGIdtNSyngX0JcG/0Fz9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210362; c=relaxed/simple;
	bh=xS21LTM+gFB94VSRasRXReIYf3C/DY+Vj6GtIq5qkA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoDq4DoU4cX/KH6MnSM9i29QGstvGK8STxEHYt4rfL4nXtaZy6/W6iWo1VFkfDCaR9ncZ0Pn3mSvnpD8vSrV5Q52LMBPYeEKQ/sM9xo3ItbxIOvFBZKK5LwD8OUhqLsRKeHsK8zcPTHpwJq59pOyfkamEfKm0nw1H8z7xRfqvag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNhudVUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNhudVUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EF1C4CEC3;
	Sun,  1 Sep 2024 17:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210362;
	bh=xS21LTM+gFB94VSRasRXReIYf3C/DY+Vj6GtIq5qkA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNhudVUXldl01wckqIOPpet6mOZoyKErDXgA3bDhsEWLjx9ggikfesfJQppAk2pW5
	 s4/4xim/iFL7YPl/QLX0C3e4Od9EA2QYq2eayrcHf5zWuMapLbBpsmrYz74Qe9iBEV
	 KvO1abT+TdfX/P0BmMgI7sTAwHo7yf5HrbThQhLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 5.15 165/215] KVM: arm64: Make ICC_*SGI*_EL1 undef in the absence of a vGICv3
Date: Sun,  1 Sep 2024 18:17:57 +0200
Message-ID: <20240901160829.596137703@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

commit 3e6245ebe7ef341639e9a7e402b3ade8ad45a19f upstream.

On a system with a GICv3, if a guest hasn't been configured with
GICv3 and that the host is not capable of GICv2 emulation,
a write to any of the ICC_*SGI*_EL1 registers is trapped to EL2.

We therefore try to emulate the SGI access, only to hit a NULL
pointer as no private interrupt is allocated (no GIC, remember?).

The obvious fix is to give the guest what it deserves, in the
shape of a UNDEF exception.

Reported-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240820100349.3544850-2-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/sys_regs.c  |    6 ++++++
 arch/arm64/kvm/vgic/vgic.h |    7 +++++++
 2 files changed, 13 insertions(+)

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -30,6 +30,7 @@
 #include <trace/events/kvm.h>
 
 #include "sys_regs.h"
+#include "vgic/vgic.h"
 
 #include "trace.h"
 
@@ -203,6 +204,11 @@ static bool access_gic_sgi(struct kvm_vc
 {
 	bool g1;
 
+	if (!kvm_has_gicv3(vcpu->kvm)) {
+		kvm_inject_undefined(vcpu);
+		return false;
+	}
+
 	if (!p->is_write)
 		return read_from_write_only(vcpu, p, r);
 
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -324,4 +324,11 @@ void vgic_v4_configure_vsgis(struct kvm
 void vgic_v4_get_vlpi_state(struct vgic_irq *irq, bool *val);
 int vgic_v4_request_vpe_irq(struct kvm_vcpu *vcpu, int irq);
 
+static inline bool kvm_has_gicv3(struct kvm *kvm)
+{
+	return (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) &&
+		irqchip_in_kernel(kvm) &&
+		kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3);
+}
+
 #endif


