Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5E04E2F22;
	Fri,  9 Oct 2026 14:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557216; cv=none; b=sgqALeCQ2M/Y708p5FjJz7yXYyIjQoIBRjUdM+scHlDUZTawoUsL2cLVBqMHS2DYlhT/AvR41+yCv2EqzN77DBIr3ZtZ7ZyeShHdhvkruyjmbTtRF/P6tN60ulO9om7mN1KkLGkKICXfPImDFQsK1OkMVtNF0qIeLWN/QxCJz0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557216; c=relaxed/simple;
	bh=Agr9IRCozievTGQIVXJzryuPfXu4025nGVIHeDdmFDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOycPnRDb2CQRg9FEacBWJHOOowb1gvuP9BlHG6lBT/LrTt2zl+bMY2sqwlaR0zKXZWdAPPLHJa5ca9TDhYpy/Gy4++cluloy+fnWGcTVlwmrsLbby1Z2INvakolkMPLvvaa8BDBLnxPV5WIR4AsosgfbBr1dxw59ivTHSkUXYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDhO3AXb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDhO3AXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CD11F000FF;
	Fri,  9 Oct 2026 14:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557215;
	bh=gQeK6Xs6vGCvCpi7zwZVaoIQQ6jZ3/hMBBmAAdoZU+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IDhO3AXbbeQ0hZfUnLTyhcQ55v9NOoDHReLmyp/C++j0iaBsXjI8WuiAnES2dm2p+
	 f0yyi+HXsTU/6V8/N7iaRD9D5ZyBwa2R6DCX8zUcbv1CGfzFdkClJXUbW/uojiLLun
	 hp+oskNhF9m6L9fZTaqP6Jcj1+0xO4garoDi6Ma4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 7.2 320/428] KVM: arm64: vgic: Allow last_lr_irq to be NULL when LRs are not overflowing
Date: Fri,  9 Oct 2026 16:10:57 +0200
Message-ID: <20261009140953.157661102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit e079ef0b1c40c7a4a1be0c1ac5dbff95685c3beb upstream.

last_lr_irq is always populated when there is any interrupt populated in
the AP list. Not only this is not necessary (it is only useful when we
completely fill the LRs), but this is in the way of further fixes.

Make sure last_lr_irq is kept to NULL when we LRs are not completely
full.

Fixes: 6da5e537f5afe ("KVM: arm64: vgic: Pick EOIcount deactivations from AP-list tail")
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260929093548.3598547-4-maz@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c |    6 ++++--
 arch/arm64/kvm/vgic/vgic-v3.c |    6 ++++--
 arch/arm64/kvm/vgic/vgic.c    |    8 +++-----
 3 files changed, 11 insertions(+), 9 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -122,6 +122,10 @@ void vgic_v2_fold_lr_state(struct kvm_vc
 	for (int lr = 0; lr < vgic_cpu->vgic_v2.used_lrs; lr++)
 		vgic_v2_fold_lr(vcpu, cpuif->vgic_lr[lr]);
 
+	cpuif->used_lrs = 0;
+	if (!irq)
+		return;
+
 	/* See the GICv3 equivalent for the EOIcount handling rationale */
 	list_for_each_entry_continue(irq, &vgic_cpu->ap_list_head, ap_list) {
 		u32 lr;
@@ -144,8 +148,6 @@ void vgic_v2_fold_lr_state(struct kvm_vc
 		vgic_v2_fold_lr(vcpu, lr);
 		eoicount--;
 	}
-
-	cpuif->used_lrs = 0;
 }
 
 void vgic_v2_deactivate(struct kvm_vcpu *vcpu, u32 val)
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -155,6 +155,10 @@ void vgic_v3_fold_lr_state(struct kvm_vc
 	for (int lr = 0; lr < cpuif->used_lrs; lr++)
 		vgic_v3_fold_lr(vcpu, cpuif->vgic_lr[lr]);
 
+	cpuif->used_lrs = 0;
+	if (!irq)
+		return;
+
 	/*
 	 * EOIMode=0: use EOIcount to emulate deactivation. We are
 	 * guaranteed to deactivate in reverse order of the activation, so
@@ -188,8 +192,6 @@ void vgic_v3_fold_lr_state(struct kvm_vc
 		vgic_v3_fold_lr(vcpu, lr);
 		eoicount--;
 	}
-
-	cpuif->used_lrs = 0;
 }
 
 void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -863,9 +863,6 @@ static void vgic_fold_state(struct kvm_v
 		return;
 	}
 
-	if (!*host_data_ptr(last_lr_irq))
-		return;
-
 	if (kvm_vgic_global_state.type == VGIC_V2)
 		vgic_v2_fold_lr_state(vcpu);
 	else
@@ -1018,11 +1015,12 @@ static void vgic_flush_lr_state(struct k
 		scoped_guard(raw_spinlock,  &irq->irq_lock) {
 			if (likely(vgic_target_oracle(irq) == vcpu)) {
 				vgic_populate_lr(vcpu, irq, count++);
-				*host_data_ptr(last_lr_irq) = irq;
+				if (count == kvm_vgic_global_state.nr_lr)
+					*host_data_ptr(last_lr_irq) = irq;
 			}
 		}
 
-		if (count == kvm_vgic_global_state.nr_lr)
+		if (*host_data_ptr(last_lr_irq))
 			break;
 	}
 


