Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C64B63E;
	Mon,  1 Apr 2024 16:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989699; cv=none; b=tm9dfhim2UqHCiLpalIhXqucz9nLMXQFmFkX8jkn9bZ2PaXF/wXKeeAiJIPVPwarkZRfbmC/Ul2uyTPYrpcmUmr/vXQkMYuERMIyuWo4qwjvEv/6ggH9VJBFOMDpgUtVu1U1yEGIqOZhaV5jkyrQhRBHaN5UjfYFGVFCGubyPrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989699; c=relaxed/simple;
	bh=zWKtth+KIr8ZJetjGcZenQLnRctk+q+mLQggugVkYoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=glT4a1AVeqKDAnnwHlYXtPfqlPY42kWj+fP0jH2hok9sXID2SDQm3h/5FEBPjt9YzN+60VMIV2rjyonBn4vcUGjD7HhjlWSaZr2YVPB7KyT8/FHaVtkuflBQmkHS2ny0VsYo0Vhsar0bbmMmp4iC1/dUhQAO81MdKe7gQK0/HJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v02pBULu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v02pBULu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1065FC433F1;
	Mon,  1 Apr 2024 16:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989699;
	bh=zWKtth+KIr8ZJetjGcZenQLnRctk+q+mLQggugVkYoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v02pBULutjUuBnMFQ+2emNqKp9S1OGjhrOv1a+FWqsGoqGhk1JAttJMLG1qDIwt5q
	 VVSaBNnMlj8kLp3rPchA6tjWJhhhKXJbuNIMMpvlTSWz9KMGLToerf/O25mfV4ENT+
	 FE/W/i1aVMT+8jLpNCPr0GbBfozq+S4YDuYYTnCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/396] vfio/pci: Disable auto-enable of exclusive INTx IRQ
Date: Mon,  1 Apr 2024 17:42:56 +0200
Message-ID: <20240401152551.704434446@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit fe9a7082684eb059b925c535682e68c34d487d43 ]

Currently for devices requiring masking at the irqchip for INTx, ie.
devices without DisINTx support, the IRQ is enabled in request_irq()
and subsequently disabled as necessary to align with the masked status
flag.  This presents a window where the interrupt could fire between
these events, resulting in the IRQ incrementing the disable depth twice.
This would be unrecoverable for a user since the masked flag prevents
nested enables through vfio.

Instead, invert the logic using IRQF_NO_AUTOEN such that exclusive INTx
is never auto-enabled, then unmask as required.

Cc:  <stable@vger.kernel.org>
Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20240308230557.805580-2-alex.williamson@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index cbb4bcbfbf83d..3dbeeb5bfadce 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -296,8 +296,15 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
 
 	ctx->trigger = trigger;
 
+	/*
+	 * Devices without DisINTx support require an exclusive interrupt,
+	 * IRQ masking is performed at the IRQ chip.  The masked status is
+	 * protected by vdev->irqlock. Setup the IRQ without auto-enable and
+	 * unmask as necessary below under lock.  DisINTx is unmodified by
+	 * the IRQ configuration and may therefore use auto-enable.
+	 */
 	if (!vdev->pci_2_3)
-		irqflags = 0;
+		irqflags = IRQF_NO_AUTOEN;
 
 	ret = request_irq(pdev->irq, vfio_intx_handler,
 			  irqflags, ctx->name, vdev);
@@ -308,13 +315,9 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
 		return ret;
 	}
 
-	/*
-	 * INTx disable will stick across the new irq setup,
-	 * disable_irq won't.
-	 */
 	spin_lock_irqsave(&vdev->irqlock, flags);
-	if (!vdev->pci_2_3 && ctx->masked)
-		disable_irq_nosync(pdev->irq);
+	if (!vdev->pci_2_3 && !ctx->masked)
+		enable_irq(pdev->irq);
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
 
 	return 0;
-- 
2.43.0



