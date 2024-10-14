Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E98F1C231D;
	Mon, 14 Oct 2024 15:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918936; cv=none; b=AF/1BhrNu8whoLeQDT1d6qx/pEhmqQwumDbxJ5aXFhFhIMHau+9RPN/rY7gc3iu7m19omFBnHczFyd0mmTODTvB2Zau0vOy9qAFWZsVhtZK5CjWa6DVwSLPz1m94T5iZKkoXboJRsLp4v8vqlWEqw7MYv7K3BxyCNDdnPSH4+oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918936; c=relaxed/simple;
	bh=XBUjjSi3Evjkf/4zyhCtC5DUfvAs98xYeys5WtP0VSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XebTM4HR87CwUKbk4z1B6oGB6Mnwv2NHPH7u9kXdZtwHcibfIxfGNu0pADvHfBZpG6rcZ0AeJ78DW/8+1e33i8+8dYKYZbr3yZO+O4N6KljG3Est7/5KFqgvSQZVdXw2fMJDVb4hnru8SaWBHcNQJy7DoGvvPT+CUEl7G7NGa7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GicOBGgc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GicOBGgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D07C4CEC3;
	Mon, 14 Oct 2024 15:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918936;
	bh=XBUjjSi3Evjkf/4zyhCtC5DUfvAs98xYeys5WtP0VSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GicOBGgcOMnPtxvs9cyxIODopCHfmb0kpJyYZOc05Qa+AkKBAWd1Ppde+lzceFFrU
	 ig/MUovGKP803HWmW4JpGUgRYWgRiGXmcSamWhGuUJBop7HwYnWxaRbPC/QV9K5cvf
	 JnrJvKTg7w8Tyivdb/gSaOG0LcCFcceeupT6j83c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Beckett <bob.beckett@collabora.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 434/798] nvme-pci: qdepth 1 quirk
Date: Mon, 14 Oct 2024 16:16:28 +0200
Message-ID: <20241014141235.012700099@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 83bdfcbdbe5d901c5fa432decf12e1725a840a56 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/nvme.h |  5 +++++
 drivers/nvme/host/pci.c  | 18 +++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 8e28d2de45c0e..5f8a146b70148 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -86,6 +86,11 @@ enum nvme_quirks {
 	 */
 	NVME_QUIRK_NO_DEEPEST_PS		= (1 << 5),
 
+	/*
+	 *  Problems seen with concurrent commands
+	 */
+	NVME_QUIRK_QDEPTH_ONE			= (1 << 6),
+
 	/*
 	 * Set MEDIUM priority on SQ creation
 	 */
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 54a969aa72bed..f0063962c2c87 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2621,15 +2621,8 @@ static int nvme_pci_enable(struct nvme_dev *dev)
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
@@ -3491,6 +3484,8 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_BOGUS_NID, },
 	{ PCI_VDEVICE(REDHAT, 0x0010),	/* Qemu emulated controller */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1217, 0x8760), /* O2 Micro 64GB Steam Deck */
+		.driver_data = NVME_QUIRK_QDEPTH_ONE },
 	{ PCI_DEVICE(0x126f, 0x2262),	/* Silicon Motion generic */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
 				NVME_QUIRK_BOGUS_NID, },
@@ -3617,7 +3612,12 @@ static const struct pci_device_id nvme_id_table[] = {
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
-- 
2.43.0



