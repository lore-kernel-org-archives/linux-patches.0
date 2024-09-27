Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365C218C010;
	Fri, 27 Sep 2024 12:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439992; cv=none; b=lKBUQXVxFc0sFivsxYJj0aPUA6fOgK5rqgJ37wz4iVqTY4xbRAPC2G7zhoCc+8JLEv7nOfVtrPTtg7TKyD2NcdOj7yygaygXixqV3SRvGJRNr6yLHbAesJOvUlhg+u3nltjRmromQh3wySBwg/Q5Jfso8YVpiLUpihC77GpSzak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439992; c=relaxed/simple;
	bh=H8vgCAY3ZG1QSy85W6464KrXg0Mefee9w0hBP3vb0OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmAx17OJZ9gxcnkyHAs8ZksLdflYIttas533UXcP8NlX1uAEH3186uGY2K40dHILk/3BTmrq+O3s8ArUd4Kr8FjPTy9Jvazcy9qDLrcJdyS1XnZVRkTMbEF+/D/F4VVS78RnaO8D7rPf2h+zZO0yXkqUu0xvpEB7jE7bSRtheWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QG7mrr8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QG7mrr8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4811C4CEC4;
	Fri, 27 Sep 2024 12:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439992;
	bh=H8vgCAY3ZG1QSy85W6464KrXg0Mefee9w0hBP3vb0OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QG7mrr8KPfmKXncz5mcmve/1TgSQtmyIx4LBOFNmnr5pJHY9I8jXxsx0Caadezyzf
	 co65bwnuyoQdutpXorN7Lq9CQwdoTKmLUpmD1EeaV5jfVHsd6wT3WxodzNM/QXhBZT
	 n1rEracG+nMVL8rmOhxLPtVkhNirDdK8ZkY+HEGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Beckett <bob.beckett@collabora.com>,
	Keith Busch <kbusch@kernel.org>,
	"Gagniuc, Alexandru" <alexandru.gagniuc@hp.com>
Subject: [PATCH 6.6 49/54] nvme-pci: qdepth 1 quirk
Date: Fri, 27 Sep 2024 14:23:41 +0200
Message-ID: <20240927121721.777083304@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

commit 83bdfcbdbe5d901c5fa432decf12e1725a840a56 upstream.

Another device has been reported to be unreliable if we have more than
one outstanding command. In this new case, data corruption may occur.
Since we have two devices now needing this quirky behavior, make a
generic quirk flag.

The same Apple quirk is clearly not "temporary", so update the comment
while moving it.

Link: https://lore.kernel.org/linux-nvme/191d810a4e3.fcc6066c765804.973611676137075390@collabora.com/
Reported-by: Robert Beckett <bob.beckett@collabora.com>
Reviewed-by: Christoph Hellwig hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Cc: "Gagniuc, Alexandru" <alexandru.gagniuc@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/nvme.h |    5 +++++
 drivers/nvme/host/pci.c  |   18 +++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -89,6 +89,11 @@ enum nvme_quirks {
 	NVME_QUIRK_NO_DEEPEST_PS		= (1 << 5),
 
 	/*
+	 *  Problems seen with concurrent commands
+	 */
+	NVME_QUIRK_QDEPTH_ONE			= (1 << 6),
+
+	/*
 	 * Set MEDIUM priority on SQ creation
 	 */
 	NVME_QUIRK_MEDIUM_PRIO_SQ		= (1 << 7),
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2526,15 +2526,8 @@ static int nvme_pci_enable(struct nvme_d
 	else
 		dev->io_sqes = NVME_NVM_IOSQES;
 
-	/*
-	 * Temporary fix for the Apple controller found in the MacBook8,1 and
-	 * some MacBook7,1 to avoid controller resets and data loss.
-	 */
-	if (pdev->vendor == PCI_VENDOR_ID_APPLE && pdev->device == 0x2001) {
+	if (dev->ctrl.quirks & NVME_QUIRK_QDEPTH_ONE) {
 		dev->q_depth = 2;
-		dev_warn(dev->ctrl.device, "detected Apple NVMe controller, "
-			"set queue depth=%u to work around controller resets\n",
-			dev->q_depth);
 	} else if (pdev->vendor == PCI_VENDOR_ID_SAMSUNG &&
 		   (pdev->device == 0xa821 || pdev->device == 0xa822) &&
 		   NVME_CAP_MQES(dev->ctrl.cap) == 0) {
@@ -3399,6 +3392,8 @@ static const struct pci_device_id nvme_i
 				NVME_QUIRK_BOGUS_NID, },
 	{ PCI_VDEVICE(REDHAT, 0x0010),	/* Qemu emulated controller */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1217, 0x8760), /* O2 Micro 64GB Steam Deck */
+		.driver_data = NVME_QUIRK_QDEPTH_ONE },
 	{ PCI_DEVICE(0x126f, 0x2262),	/* Silicon Motion generic */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
 				NVME_QUIRK_BOGUS_NID, },
@@ -3531,7 +3526,12 @@ static const struct pci_device_id nvme_i
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0xcd02),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),
-		.driver_data = NVME_QUIRK_SINGLE_VECTOR },
+		/*
+		 * Fix for the Apple controller found in the MacBook8,1 and
+		 * some MacBook7,1 to avoid controller resets and data loss.
+		 */
+		.driver_data = NVME_QUIRK_SINGLE_VECTOR |
+				NVME_QUIRK_QDEPTH_ONE },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2003) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2005),
 		.driver_data = NVME_QUIRK_SINGLE_VECTOR |


