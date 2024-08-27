Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFB01C7B62;
	Tue, 27 Aug 2024 14:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770686; cv=none; b=MXmzM6zT8MsGsT1iOkntMOEtWNoH1YB+o0MiZeCYyrLLnmVhj/TNBhQamI//5SKS4fvnJ0eNMuJLaSZyBs/A7Vlrr8Z3wdwXHWvJxnqEzaeRfmhF4P0bWwGBJDr55uYHkC8wxNHn1dyXtBHnc3jjkqyACekXyGqaz6bcqjxiY8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770686; c=relaxed/simple;
	bh=JVXBOk9MoD1iy63QPDDcNePvKmN5mn851n/LZ2tdiFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqyIgIcGywlcO4mxpecCbTvfMFMCVbJtPV1N4JpTM+erZ6pwWap4SkFqrWyeWnSS5m2V26K2NEhApoBaUHkBTf+iUV/rtPVAi14iJ8nxtlvGDFvXRjiuKipkPo+5y4EeMMNmfyXHeg9EnSrxm1dyQXCUhMaQG2ARNZapxVd9Gco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aw2pkDFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aw2pkDFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15493C61044;
	Tue, 27 Aug 2024 14:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770686;
	bh=JVXBOk9MoD1iy63QPDDcNePvKmN5mn851n/LZ2tdiFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aw2pkDFi5y4hQl0ufSdOOf1bA1PGheJguvdpoRuxGXp+j6HbpblcoOYSQOhsXelo8
	 CBk9LnokTD2kI+yJZluhRpjHgTjoOhXyDtjDneAHabjqOtlvib0HagboCP0im7cexC
	 vICcY3/uwcYkj1sekh5DOpNS9JXnwF47BA9RAa+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.6 304/341] KVM: arm64: Make ICC_*SGI*_EL1 undef in the absence of a vGICv3
Date: Tue, 27 Aug 2024 16:38:55 +0200
Message-ID: <20240827143854.958087263@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -32,6 +32,7 @@
 #include <trace/events/kvm.h>
 
 #include "sys_regs.h"
+#include "vgic/vgic.h"
 
 #include "trace.h"
 
@@ -301,6 +302,11 @@ static bool access_gic_sgi(struct kvm_vc
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
@@ -343,4 +343,11 @@ void vgic_v4_configure_vsgis(struct kvm
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


