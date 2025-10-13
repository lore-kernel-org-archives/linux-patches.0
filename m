Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7A8BA34;
	Mon, 13 Oct 2025 15:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368494; cv=none; b=AhvBneOA51Ni51NHBk7qq7/CPDU9XVGbMjMfTzV0iyy3uphhFC1ZPXrp/x9y2ABzUCHccz02zHPMRzsKa/XSN3OAWVW6d8RBf7ZqfT+OUAgdKCq3mbXwRYHrqwJWtwFqVwQjqf6pXWFmCE/B2TcGXneaIsr6ESXaoGnHqv8g2yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368494; c=relaxed/simple;
	bh=VpV7Lmdj4sRZlMujol5U+FtsVSTMTLHWoAhPZvaj03I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qI3P0wym6IrTzXDkBmbRVah/nmVQVmzH00HitBHmcqU8xeyfd9o7yDTnAn6ra9NJS/xgyQCqJrcu14jIWVODZaGsNWZcGYjzAnQR+cSQk1ykowr4f5BiKmxg3MnLQA981QZ/lzkv5W4ZtSSO6hd2wqOvQ4cRPo+mAV93bNOOiM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10N7ryAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10N7ryAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E76C4CEE7;
	Mon, 13 Oct 2025 15:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368493;
	bh=VpV7Lmdj4sRZlMujol5U+FtsVSTMTLHWoAhPZvaj03I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10N7ryADZ8QySm5o6anmimvcIU7ILCDr7fwf+2XIMJb0uwaf4AHCUbOhUWuD+lqCb
	 WQeLMH+HV6re86hMbRUz4s5aBZGvB5n4XbbFhsuDC9bi4wbOHpT83tLbJQ8jUTIhdN
	 muCACcSQVwPZh+/TPXOxKAb7cr5s8neqKxhHXm7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/262] wifi: mt76: mt7996: Fix RX packets configuration for primary WED device
Date: Mon, 13 Oct 2025 16:44:50 +0200
Message-ID: <20251013144331.451596249@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit cffed52dbf0ddd0db11f9df63f9976fe58ac9628 ]

In order to properly set the number of rx packets for primary WED device
if hif device is available, move hif pointer initialization before
running mt7996_mmio_wed_init routine.

Fixes: 83eafc9251d6d ("wifi: mt76: mt7996: add wed tx support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250909-mt7996-rro-rework-v5-9-7d66f6eb7795@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
index 04056181368a6..dbd05612f2e4a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
@@ -132,6 +132,7 @@ static int mt7996_pci_probe(struct pci_dev *pdev,
 	mdev = &dev->mt76;
 	mt7996_wfsys_reset(dev);
 	hif2 = mt7996_pci_init_hif2(pdev);
+	dev->hif2 = hif2;
 
 	ret = mt7996_mmio_wed_init(dev, pdev, false, &irq);
 	if (ret < 0)
@@ -156,7 +157,6 @@ static int mt7996_pci_probe(struct pci_dev *pdev,
 
 	if (hif2) {
 		hif2_dev = container_of(hif2->dev, struct pci_dev, dev);
-		dev->hif2 = hif2;
 
 		ret = mt7996_mmio_wed_init(dev, hif2_dev, true, &hif2_irq);
 		if (ret < 0)
-- 
2.51.0



