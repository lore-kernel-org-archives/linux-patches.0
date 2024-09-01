Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB58E1DFD1;
	Sun,  1 Sep 2024 16:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209683; cv=none; b=q1sC2WyYs6wqXbp1vPUa68SkmNia6/6MzDsf/8xzBoU0fGQ5Cq+ZI+l8ouyDPmxrsrEzbfIO89fkTgCkIGHDQOakE8qXE5d1KI+nR7RtxBkwyPwfdsEkEGqF0NwNPptHb3TvWFGLVbWJGwmKfLCgKCd4tzJVLprFRB21agxja/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209683; c=relaxed/simple;
	bh=JTWwN2RVuqgoX4iELSFHJGmYWoZ02VZUVnocunf3PTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqQFYvnQ+zs6FoN8OkjY6/ay//eW7lEqa/OuRw0tWCdxF/EulDw0jS3WK8TEAS2yWPD9hT34fXbfa/tkYqkOSrPsCvBtoUDickwheScO0YEmu5Iz8K+De7azdw7mjuDlbC+SVbc7rX9v9lXpqRffR5f7fdxp68k5xvetxTBqNuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHN2eduL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHN2eduL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF22BC4CEC3;
	Sun,  1 Sep 2024 16:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209683;
	bh=JTWwN2RVuqgoX4iELSFHJGmYWoZ02VZUVnocunf3PTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KHN2eduL73+y6+gcSeduwy4DpO/eNY88lNAlXpAIY1GZ4KP5Lp2dc1RRcaHmduR7d
	 rOnSsZ/r99rLwaBW1AnxALlgo+XEo1S+b5l33Rpgahmv8+Z15U7KHWX/oMfcQsNNyH
	 zgV3PFMNYA666w3DKS8j62dEmo3bDcQrvuCLw0z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 5.10 113/151] KVM: arm64: Make ICC_*SGI*_EL1 undef in the absence of a vGICv3
Date: Sun,  1 Sep 2024 18:17:53 +0200
Message-ID: <20240901160818.359461356@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -275,6 +276,11 @@ static bool access_gic_sgi(struct kvm_vc
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
@@ -318,4 +318,11 @@ int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
 void vgic_v4_configure_vsgis(struct kvm *kvm);
 
+static inline bool kvm_has_gicv3(struct kvm *kvm)
+{
+	return (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) &&
+		irqchip_in_kernel(kvm) &&
+		kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3);
+}
+
 #endif


