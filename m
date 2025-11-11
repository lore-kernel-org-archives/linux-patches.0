Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A1F21ABB9;
	Tue, 11 Nov 2025 01:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825087; cv=none; b=p5lOTSqb0KmbjxdwipKBCMP7TpXV7HjSZzqtcGof+dtqMBuqjEVicd3mOCRQVRV7q+VUAKmn0KcpZboVB6rieTTGWJRd5136B7fuY1J+nieajYKLg76jfbu90U/L3ZqAgngPIoNznbEBGgXqcszreljN2wyonvMhrZ6byBbkhiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825087; c=relaxed/simple;
	bh=2Ybh7+3Pa2jOxAhKPZznNUZVllAPcTF8GOHOjrF150s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rl4F5oYatPM6w3xaX1TQsinHeldy/NLH4etL2j3hejkH4NmGVCe5KTK2e8Up4DQv/nfLsZVvOSZlU5zogid6yRfoXkzGyaFFKgUOwELTUVzFbxhKLnZi/CqjQ2NrhrCbnqEiSTD1sGmFRXPVjcETZMEwXpN7Mtrke+xVHk8vv0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yD2cRvgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yD2cRvgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66CAC4CEF5;
	Tue, 11 Nov 2025 01:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825087;
	bh=2Ybh7+3Pa2jOxAhKPZznNUZVllAPcTF8GOHOjrF150s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yD2cRvgLVqoyUIcbplBXmuV3wGCUkssK0XUhfwstG7Sm9+Dr1sfnk7PqbKWQaCD2+
	 j/KLcOh5yA1K5+g2DbOQBrcD9aLpyeU+lzHccLfE8EDSRSgmO0zWJyv0Cv/RIDyMQJ
	 wlkrySGXvB3mz0bmvjiBuf1BH4hiIrlF0LSPG7L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timothy Pearson <tpearson@raptorengineering.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 654/849] vfio/pci: Fix INTx handling on legacy non-PCI 2.3 devices
Date: Tue, 11 Nov 2025 09:43:44 +0900
Message-ID: <20251111004552.240113911@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timothy Pearson <tpearson@raptorengineering.com>

[ Upstream commit 8b9f128947dd72e0fcf256088a673abac9b720bf ]

PCI devices prior to PCI 2.3 both use level interrupts and do not support
interrupt masking, leading to a failure when passed through to a KVM guest on
at least the ppc64 platform. This failure manifests as receiving and
acknowledging a single interrupt in the guest, while the device continues to
assert the level interrupt indicating a need for further servicing.

When lazy IRQ masking is used on DisINTx- (non-PCI 2.3) hardware, the following
sequence occurs:

 * Level IRQ assertion on device
 * IRQ marked disabled in kernel
 * Host interrupt handler exits without clearing the interrupt on the device
 * Eventfd is delivered to userspace
 * Guest processes IRQ and clears device interrupt
 * Device de-asserts INTx, then re-asserts INTx while the interrupt is masked
 * Newly asserted interrupt acknowledged by kernel VMM without being handled
 * Software mask removed by VFIO driver
 * Device INTx still asserted, host controller does not see new edge after EOI

The behavior is now platform-dependent.  Some platforms (amd64) will continue
to spew IRQs for as long as the INTX line remains asserted, therefore the IRQ
will be handled by the host as soon as the mask is dropped.  Others (ppc64) will
only send the one request, and if it is not handled no further interrupts will
be sent.  The former behavior theoretically leaves the system vulnerable to
interrupt storm, and the latter will result in the device stalling after
receiving exactly one interrupt in the guest.

Work around this by disabling lazy IRQ masking for DisINTx- INTx devices.

Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
Link: https://lore.kernel.org/r/333803015.1744464.1758647073336.JavaMail.zimbra@raptorengineeringinc.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 123298a4dc8f5..61d29f6b3730c 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -304,9 +304,14 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
 
 	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
 
+	if (!vdev->pci_2_3)
+		irq_set_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
+
 	ret = request_irq(pdev->irq, vfio_intx_handler,
 			  irqflags, ctx->name, ctx);
 	if (ret) {
+		if (!vdev->pci_2_3)
+			irq_clear_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
 		vdev->irq_type = VFIO_PCI_NUM_IRQS;
 		kfree(name);
 		vfio_irq_ctx_free(vdev, ctx, 0);
@@ -352,6 +357,8 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
 		free_irq(pdev->irq, ctx);
+		if (!vdev->pci_2_3)
+			irq_clear_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
 		if (ctx->trigger)
 			eventfd_ctx_put(ctx->trigger);
 		kfree(ctx->name);
-- 
2.51.0



