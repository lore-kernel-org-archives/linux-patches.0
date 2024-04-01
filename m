Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFECE47A64;
	Mon,  1 Apr 2024 17:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991225; cv=none; b=fduxk3Ns8O1DVdmVBeg8hmLECW1bwr/F2RSt8jqXCc8sVuREOiH8sdb6FJNwadxZXk2MEA+nc55YGE/9k/4XBAnL3ox8jp0r2A19Xfk7HZ7PBltHAYHyiUc/lOIbqqwHd2+f7Uis/7dxt5cEm64zRZBwXih8ekN/2Xn94Nahxmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991225; c=relaxed/simple;
	bh=jUhFBMSdo/UuTo7GkDxf5XDfne48aEC5+MHohkZ/1Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KofzK2Np6BWITer9bRb2eCOgaJcPr/JEn8v8Hj8VZyj1NP/SC/U6saKbpD7o9KstC2aNaMl9Seqcn78kqqPNk5f7uWP3xOSQ46qXWWa/xLovOrkFHM15zpkp8ikITxTwEj3BND9ipQmk3EV+O0ja/W+I8waueDP7nofIobUgIMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skqwW+sq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skqwW+sq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2642CC433F1;
	Mon,  1 Apr 2024 17:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991225;
	bh=jUhFBMSdo/UuTo7GkDxf5XDfne48aEC5+MHohkZ/1Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skqwW+sqY33t7Md8/AU8jcnVz6TX3pkDKQtjGcaVcJQ2OCTSQWanJDG886iMECPvR
	 Z0FNJjEMQUBOh0Dduf4ko8Fi6G6jHZ7WSDdbUIqKEPzHDAYMPFFmsQdxDxnz4P5RAS
	 sb4TewxH+b0ntVnqmjFXXY5nfoXUKcNwJBpcqRaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 6.1 200/272] vfio/pci: Disable auto-enable of exclusive INTx IRQ
Date: Mon,  1 Apr 2024 17:46:30 +0200
Message-ID: <20240401152537.139718435@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/vfio_pci_intrs.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -251,8 +251,15 @@ static int vfio_intx_set_signal(struct v
 
 	vdev->ctx[0].trigger = trigger;
 
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
 			  irqflags, vdev->ctx[0].name, vdev);
@@ -263,13 +270,9 @@ static int vfio_intx_set_signal(struct v
 		return ret;
 	}
 
-	/*
-	 * INTx disable will stick across the new irq setup,
-	 * disable_irq won't.
-	 */
 	spin_lock_irqsave(&vdev->irqlock, flags);
-	if (!vdev->pci_2_3 && vdev->ctx[0].masked)
-		disable_irq_nosync(pdev->irq);
+	if (!vdev->pci_2_3 && !vdev->ctx[0].masked)
+		enable_irq(pdev->irq);
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
 
 	return 0;


