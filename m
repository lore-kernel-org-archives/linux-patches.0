Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43472137F;
	Tue, 23 Jan 2024 00:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969826; cv=none; b=XYsKnOsM53EjN6KzZ48vWzG9K1UCGvfQyc9iBs/opYkfajQw0HXs6aqtWm02J1pjX42r4QWiD7FZb11vdx/UOi1QN6a3ktVBbTjVa9XiDrbdmwjr1+85i5pBURcxNazvqBDRdq4+GxO+xiZsVoTXbbh9VGoIkeCYhZ7QXrtcLV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969826; c=relaxed/simple;
	bh=SNvNggRYEw5TGrb+URs0Qe+V025NgX8yi9tV3aFUwy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRa+JSBwII0TcMfzzMD3PLMwkubXSfz3O1NnG0Hwko0sA2Ga8+u9W93wxleOegpbXcP18zL+0AgUtlbAjtqxqv23G8/boW6cysHNeZWx0RqcoXJe89IMTrxecmbMuuxcZPdClKB9Tg6h0nAvq1ewrZTgHeXEegWBhjajBliYZGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wa9ibIJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wa9ibIJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3184FC43390;
	Tue, 23 Jan 2024 00:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969826;
	bh=SNvNggRYEw5TGrb+URs0Qe+V025NgX8yi9tV3aFUwy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wa9ibIJCyyKr4+RexehJa5X5OP6ZnElbbve9GRMa8JDa1W2auap/AO8bZrtHmJVpO
	 2zxWDQ5/o0GmZYZsAjuMRRYW/bnZNflbgMjccSr6OwRQX4iGlaMZocVxGlMJl97v/O
	 gimCCTx0jTFZ26pFko3AKl4Om2WeFeKo52iOLDbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 6.7 472/641] KVM: arm64: vgic-v4: Restore pending state on host userspace write
Date: Mon, 22 Jan 2024 15:56:16 -0800
Message-ID: <20240122235832.827479108@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -365,19 +365,26 @@ static int vgic_v3_uaccess_write_pending
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
 


