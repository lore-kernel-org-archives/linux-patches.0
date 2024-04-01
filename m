Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3616E4A99C;
	Mon,  1 Apr 2024 15:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986977; cv=none; b=MPvTDY/8P2AKXvRFF8tw3vy693ywCm5GcxpwzzjUCXumGb7e/E6DHmIlMj0tguN80zJEBM/A8Aj8ZFCttbPxLIqyM97Z2GwM9lJ39OfyytjOJ71B5mv7FjrL7viuMLe+cPDNBfQqmzILp1ZPvAKh6rFwHWdRbiE+YR/UJxHPwHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986977; c=relaxed/simple;
	bh=pZcSOb2dqlmfwiVBCYTp/LmgE4aiKbw/cEI3hb9jVqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUMHefJopBJKteiV8nu9f2Pg/lnZWgX6HqaDrIUib43Iw0LJYgXvWLRVQfSOpGZVIko0Cp2g/gn82V6otClehDF7600X0RzTT6m1i7hS9nm9o8stsvRfI+h4WIUTPypkh0o8P7fxTgPGhRqvwojO8KOPaXtOF4G0KoHZfLtR0ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9R21Rja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9R21Rja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9934BC43390;
	Mon,  1 Apr 2024 15:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986977;
	bh=pZcSOb2dqlmfwiVBCYTp/LmgE4aiKbw/cEI3hb9jVqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9R21Rjao3YXZgjoj4pAo/ONxVFNzejNMXtgSufuqDlfMnxDXlh9rsWTv+fr6qJJt
	 7JvQJUYVfV7BqLLs055cswtq/dt3awMKWbG4GtybL0s87lSOaFdtGknA+5ZllEYH51
	 opZBChdDIDUW+YkWh/0z8iT6BarWEVEtUVXhVZtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 146/399] vfio/pci: Disable auto-enable of exclusive INTx IRQ
Date: Mon,  1 Apr 2024 17:41:52 +0200
Message-ID: <20240401152553.548413381@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 237beac838097..136101179fcbd 100644
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



