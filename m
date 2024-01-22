Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51271627EB;
	Tue, 23 Jan 2024 01:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974954; cv=none; b=OgI6ATrcVLVmJ4rG+KsW9kHIPc0MNeGgr0xu+vUpEszl2IR6gKBtbyYXEiku5GhkzH3WdBlfmG/avpNxeqiPiMhy4i6GKf0R56TNR0jaS7xnmrueRb5b/xZp2SvNEiqlOZMOe+DJAbq7hkhBidF5rSXetjr32CEr5sGNox0OXP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974954; c=relaxed/simple;
	bh=9NdGZZIgOlkXND2lgzh2I+m/F93rOmETj2pMtjKMT0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLJc6m13C/tLG0URVag+ETOx7rZQS1Arz0c24y0FuH7bxfyathwWtf+OOZtRrqRub/5Q6qVEreRUKmby93Q8k1MR6xnvML5UHIlRiVml1ahny7X4+DNcrIouD25gZVA0Hswf6WTDU3NBTxPPn0XwSTp8VN+8hNgxZ/PLltRM7no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xj4k2a+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xj4k2a+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D64BC43399;
	Tue, 23 Jan 2024 01:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974954;
	bh=9NdGZZIgOlkXND2lgzh2I+m/F93rOmETj2pMtjKMT0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xj4k2a+OCWCF3gMs1PRIy6SnSTkTzWSYGdBkaIQ8MecLAGiH4i7GELD3VjrVGF15k
	 zBZJvbl1YcP5PbfQ09AnRQzXFhrErcXhGlCjINjMqIW/kOdsUuJmIBCAf0YHglO9X6
	 m2iOA222r8WDXlyWhKb6ub+u0S++oXlqvaVk0vc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 5.15 284/374] KVM: arm64: vgic-v4: Restore pending state on host userspace write
Date: Mon, 22 Jan 2024 15:59:00 -0800
Message-ID: <20240122235754.652120637@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

commit 7b95382f965133ef61ce44aaabc518c16eb46909 upstream.

When the VMM writes to ISPENDR0 to set the state pending state of
an SGI, we fail to convey this to the HW if this SGI is already
backed by a GICv4.1 vSGI.

This is a bit of a corner case, as this would only occur if the
vgic state is changed on an already running VM, but this can
apparently happen across a guest reset driven by the VMM.

Fix this by always writing out the pending_latch value to the
HW, and reseting it to false.

Reported-by: Kunkun Jiang <jiangkunkun@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Cc: stable@vger.kernel.org # 5.10+
Link: https://lore.kernel.org/r/7e7f2c0c-448b-10a9-8929-4b8f4f6e2a32@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -363,19 +363,26 @@ static int vgic_v3_uaccess_write_pending
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
-		if (test_bit(i, &val)) {
-			/*
-			 * pending_latch is set irrespective of irq type
-			 * (level or edge) to avoid dependency that VM should
-			 * restore irq config before pending info.
-			 */
-			irq->pending_latch = true;
-			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
-		} else {
+
+		/*
+		 * pending_latch is set irrespective of irq type
+		 * (level or edge) to avoid dependency that VM should
+		 * restore irq config before pending info.
+		 */
+		irq->pending_latch = test_bit(i, &val);
+
+		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
+			irq_set_irqchip_state(irq->host_irq,
+					      IRQCHIP_STATE_PENDING,
+					      irq->pending_latch);
 			irq->pending_latch = false;
-			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 		}
 
+		if (irq->pending_latch)
+			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+		else
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 


