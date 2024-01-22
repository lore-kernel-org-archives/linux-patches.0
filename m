Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A198174E25;
	Tue, 23 Jan 2024 02:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975473; cv=none; b=GgGhR2z/dHxWHdhQohcyOhdpuZKU7Mv8IaJg/FMxxMLs7XAb2ZSt4mIENwmNIsa8dTx6cVr60XeJ2OPGygeONXl26Ge5vCnvae+D82sX+8HqiFzFKMMF8ZEWSK2FeM6od8TxyIs5Sz+AQzyDzncRiojPFPVP1beGudEi1MxPbWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975473; c=relaxed/simple;
	bh=1H70l8E45MxcPJ0fIGBzxOLW7jRAhXTx0PSgOhoKX78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQDrWZSypDSHBWZq5sZBqWYMRe/xMQgKENErr7lrMEv1oTHpb8TZZkDVkuP6y2FvwsWZJga7h0T49e5JgKKuhCnBk2K/mDbUa5UL0y6dBdvgAd6l5dGufyL/QHgPhjwRl3Bd1dYkPhhCZmMT1hpmMtZ4mHByUc1mJdYR5szFL9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycjE83Ua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycjE83Ua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2B6C433C7;
	Tue, 23 Jan 2024 02:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975473;
	bh=1H70l8E45MxcPJ0fIGBzxOLW7jRAhXTx0PSgOhoKX78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ycjE83UahfTRqQzsAaZqHIs4PgzmFibIgZgBs4N2KMTqbf+XdMJZAIo7rQNMOJ8q5
	 mUX8irKb7PQRetewO2/dyOaY7zDr24AKoK51W6sCzkpiAa7O+c+3VO+0paOawFuXJk
	 uy/QpTFw3/imxxp7hiPwqcTAunqJFAQJKMBawY68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 6.6 428/583] KVM: arm64: vgic-v4: Restore pending state on host userspace write
Date: Mon, 22 Jan 2024 15:57:59 -0800
Message-ID: <20240122235825.077196709@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
 


