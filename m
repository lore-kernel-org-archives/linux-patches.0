Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF0C1E0E14;
	Tue, 16 Dec 2025 12:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887979; cv=none; b=Kv+rGIB2JdehikyXgid5By8/bVfNrTQD7sYE1p60U3XQknAMcxEIotijO5GsMtsnbq9/Wf6CHzOm4ZQ8TzoGwbcUxH8opqkjch3BmDbwtJeQLh+b41arBErjonbLt4KDXVkI0DtUS4V42ROfevM0CFkRlkNdX/p7hjIGgNmdgiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887979; c=relaxed/simple;
	bh=2VkohBmhh+8kXqPNTYq0uPv10IDdKgQBAqeFg6RyzBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcaBs050/ZH/raECIzrJOMRsm0dCrYj4G4/2/VM4kHBzOQlfBafPpwCQrIi+cQK+0ySXMCk/ynbh2D400MLug2+MGilHS3uNTEQc4LWDhxanIiJ5qqWkkqubndZe7qgew+wvIVqkTXxJyPHVXrBAlJBXS+sHt3eQosFFyGJ2UbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mesHWexh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mesHWexh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6B0C4CEF1;
	Tue, 16 Dec 2025 12:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887979;
	bh=2VkohBmhh+8kXqPNTYq0uPv10IDdKgQBAqeFg6RyzBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mesHWexhkMhkkS+AH/cxL1wGAZHkUIZOXqKI7XGUwMEMQ2CGBsMqrQx/yTEEOL+nq
	 VlWa4DcBm9w25su+9QoOTrXxNC2BvlKAdi4o/PNQFr/W+5enOu0UklgYNVahnxD8wx
	 A5nzMrMW5Zh3ZIUlUqHWYyfkx4LGo0ZzGMEPRusA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Lu <rex.lu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 396/614] wifi: mt76: mt7996: fix EMI rings for RRO
Date: Tue, 16 Dec 2025 12:12:43 +0100
Message-ID: <20251216111415.722353532@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit a4031fec9d0d230224a7edcefa3368c06c317148 ]

The RRO EMI rings only need to be allocated when WED is not active.
This patch fixes command timeout issue for the setting of WED off and
RRO on.

Fixes: 3a29164425e9 ("wifi: mt76: mt7996: Add SW path for HW-RRO v3.1")
Co-developed-by: Rex Lu <rex.lu@mediatek.com>
Signed-off-by: Rex Lu <rex.lu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251106064203.1000505-12-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/dma.c   | 15 +++++++++------
 .../net/wireless/mediatek/mt76/mt7996/init.c  | 19 ++++++++++++++++---
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/dma.c b/drivers/net/wireless/mediatek/mt76/mt7996/dma.c
index 659015f93d323..7ed2f21b0e6db 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/dma.c
@@ -512,12 +512,15 @@ int mt7996_dma_rro_init(struct mt7996_dev *dev)
 		if (ret)
 			return ret;
 
-		/* We need to set cpu idx pointer before resetting the EMI
-		 * queues.
-		 */
-		mdev->q_rx[MT_RXQ_RRO_RXDMAD_C].emi_cpu_idx =
-			&dev->wed_rro.emi_rings_cpu.ptr->ring[0].idx;
-		mt76_queue_reset(dev, &mdev->q_rx[MT_RXQ_RRO_RXDMAD_C], true);
+		if (!mtk_wed_device_active(&mdev->mmio.wed)) {
+			/* We need to set cpu idx pointer before resetting the
+			 * EMI queues.
+			 */
+			mdev->q_rx[MT_RXQ_RRO_RXDMAD_C].emi_cpu_idx =
+				&dev->wed_rro.emi_rings_cpu.ptr->ring[0].idx;
+			mt76_queue_reset(dev, &mdev->q_rx[MT_RXQ_RRO_RXDMAD_C],
+					 true);
+		}
 		goto start_hw_rro;
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 5e95a36b42d16..b136b9a669769 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -959,9 +959,10 @@ static int mt7996_wed_rro_init(struct mt7996_dev *dev)
 		       MT7996_RRO_MSDU_PG_SIZE_PER_CR);
 	}
 
-	if (dev->mt76.hwrro_mode == MT76_HWRRO_V3_1) {
+	if (!mtk_wed_device_active(&dev->mt76.mmio.wed) &&
+	    dev->mt76.hwrro_mode == MT76_HWRRO_V3_1) {
 		ptr = dmam_alloc_coherent(dev->mt76.dma_dev,
-					  sizeof(dev->wed_rro.emi_rings_cpu.ptr),
+					  sizeof(*dev->wed_rro.emi_rings_cpu.ptr),
 					  &dev->wed_rro.emi_rings_cpu.phy_addr,
 					  GFP_KERNEL);
 		if (!ptr)
@@ -970,7 +971,7 @@ static int mt7996_wed_rro_init(struct mt7996_dev *dev)
 		dev->wed_rro.emi_rings_cpu.ptr = ptr;
 
 		ptr = dmam_alloc_coherent(dev->mt76.dma_dev,
-					  sizeof(dev->wed_rro.emi_rings_dma.ptr),
+					  sizeof(*dev->wed_rro.emi_rings_dma.ptr),
 					  &dev->wed_rro.emi_rings_dma.phy_addr,
 					  GFP_KERNEL);
 		if (!ptr)
@@ -1036,6 +1037,18 @@ static void mt7996_wed_rro_free(struct mt7996_dev *dev)
 				   dev->wed_rro.msdu_pg[i].phy_addr);
 	}
 
+	if (dev->wed_rro.emi_rings_cpu.ptr)
+		dmam_free_coherent(dev->mt76.dma_dev,
+				   sizeof(*dev->wed_rro.emi_rings_cpu.ptr),
+				   dev->wed_rro.emi_rings_cpu.ptr,
+				   dev->wed_rro.emi_rings_cpu.phy_addr);
+
+	if (dev->wed_rro.emi_rings_dma.ptr)
+		dmam_free_coherent(dev->mt76.dma_dev,
+				   sizeof(*dev->wed_rro.emi_rings_dma.ptr),
+				   dev->wed_rro.emi_rings_dma.ptr,
+				   dev->wed_rro.emi_rings_dma.phy_addr);
+
 	if (!dev->wed_rro.session.ptr)
 		return;
 
-- 
2.51.0



