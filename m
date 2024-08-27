Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A731D1A072D;
	Tue, 27 Aug 2024 15:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771616; cv=none; b=l1tRPiqoFuCM1BSm/u/quVm3/EFZYT461EY6ww0FxFxou9GIbhfNdxvZgnJl4ggHcF40GzN2IRa67qeGrMkxYHpiMgTGPu+K0ppTFvpnExGlW2H9gEtg4vhWBkERp8WxzT6L5PJfJbF3v2ZizwhOGRj3AW0DndUnHawofBwM9/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771616; c=relaxed/simple;
	bh=9dc525tjQ8F5XA1BOHj3Vvz/u3idRsYdDCV0xp6P158=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2a7MY3GjThO1EzPw7YMCShRcIqPvS9zXtUjMFUJKg2KY9U6Q7FAPTWHtZmoT11X4pcQcvxZ3vlC9808Dxy9ASppRUG2mSRNggjJzRjZ6siSzA3nXbXJvKYkuAiz8hb+hREKFGnQQfH/8w/uLXbXuATl6hAzzgQlYOl489Ffvgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2R9sytG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2R9sytG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBD1C6105F;
	Tue, 27 Aug 2024 15:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771616;
	bh=9dc525tjQ8F5XA1BOHj3Vvz/u3idRsYdDCV0xp6P158=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2R9sytGAbiqDciuf9PPtKObzKcyPlfTtzOsqF7MO3+5dvDM5HytlPSafePNtGSMA
	 W/CpvyTg8O2LqfT+Z4Ybk8fnBORk9z5RWZAVTQFzalJtMs4qKPC/HRQO88aZKCpIwW
	 5k2YAiVunASx+iNOZzzSMwbK93j9c8TSJ9D2nSVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.10 243/273] KVM: arm64: Make ICC_*SGI*_EL1 undef in the absence of a vGICv3
Date: Tue, 27 Aug 2024 16:39:27 +0200
Message-ID: <20240827143842.649457999@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -33,6 +33,7 @@
 #include <trace/events/kvm.h>
 
 #include "sys_regs.h"
+#include "vgic/vgic.h"
 
 #include "trace.h"
 
@@ -428,6 +429,11 @@ static bool access_gic_sgi(struct kvm_vc
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
@@ -346,4 +346,11 @@ void vgic_v4_configure_vsgis(struct kvm
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


