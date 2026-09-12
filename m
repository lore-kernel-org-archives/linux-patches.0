Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5A238D6A2;
	Sat, 12 Sep 2026 08:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201197; cv=none; b=DPDFPN3TN084xumAA4jo4gjaF3eYKuwKfjnMfyPfO9Gb8NZUU8bIk7l7Hh5HUwvetS3GRnvxZscT5fT6igfT+QQuQrL96f3DhojdISM+y/1ss5lPZlfnqbRJiswy0TozkgWgloRm+Iv89gZMHgkeqKTIhrVZpWKVZoLwId13oO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201197; c=relaxed/simple;
	bh=Jk2MT70vWbxibTwaO8wbp8ckjB2pjPBbWxAvinxEvBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ksn9i+9AyxS3S2IbPgwgRtKb1J/IVemCgTmzk3c0ytI4OFSZUZ0gpixdzlh9pAhvLXw9aNfUyo+dCn6n9I2DOJBeHmkK1sZLXL8Mnv6ygdjbcUOWeBpGkuCZPS+48B09RR5fX9GEH0Mxp33JHffm9CfciQmJeDM+Cm90QXD0dRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8eKH0TZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8eKH0TZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFB61F000FF;
	Sat, 12 Sep 2026 08:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201196;
	bh=AjTxYi+p3A5qvrlVM4v0KOyysWhzYzjamnVU/C108VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H8eKH0TZ7FUP+Tc7ZdjeQCZb87idGQ4BwU82b3uxltezVxKZA/Q1rvGy37c2hJ9ld
	 zSB7lyuGzruSXn2pS4CeoN9ovb+YafGJR6afGMDJ7AJECCTDZcy1dq6kPLPsSm17qx
	 S49O7qL8+ZV7pwxLXFDXOTuAC1SqcIpUvLZTSSIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0946/1815] wifi: mt76: mt7996: do not leave state behind after a failed WED attach
Date: Sat, 12 Sep 2026 08:44:56 +0200
Message-ID: <20260912065711.164684737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 6a4cabff1203791797683cf6be8f56bee983dc73 ]

mt7996_mmio_wed_init() set dev->mt76.hwrro_mode and rx_token_size while
building the WED configuration, before knowing whether the WED attach
can succeed. A failed attach left the enlarged rx_token_size behind and
reset hwrro_mode to MT76_HWRRO_OFF, clobbering the values that another
RX datapath owner may have configured earlier in probe: on Airoha
platforms with the wed_enable module parameter set, this broke the NPU
offload configuration set up by mt76_npu_init() (NPU offload requires
HW-RRO and a larger rx token space, and the attach always fails there
since no SoC has both an Airoha NPU and MTK WED).

Move both assignments after a successful attach, next to the existing
success-only dma_dev/irq assignments. This is safe for the regular WED
attach case: the first consumer of either field runs after probe
continues (mtk_wed_device_attach() only invokes the init_buf callback;
rx buffers are allocated via init_rx_buf from mtk_wed_start(), long
after mt7996_mmio_wed_init() has returned).

Within the WED configuration the HW-RRO checks were constant: the mode
was assigned unconditionally right before them, and the hif2 path is
only reachable after a successful main attach has set it. Resolve them
to their constant values and drop the dead branches.

Fixes: 377aa17d2aed ("wifi: mt76: mt7996: Add NPU offload support to MT7996 driver")
Link: https://patch.msgid.link/20260727150434.1778520-7-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mmio.c  | 51 +++++++------------
 1 file changed, 19 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index ba064324a7cc7..ac81be5fe0230 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -493,9 +493,6 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 	if (hif2 && !mtk_wed_device_active(&dev->mt76.mmio.wed))
 		return 0;
 
-	dev->mt76.hwrro_mode = is_mt7996(&dev->mt76) ? MT76_HWRRO_V3
-						     : MT76_HWRRO_V3_1;
-
 	hif1_ofs = dev->hif2 ? MT_WFDMA0_PCIE1(0) - MT_WFDMA0(0) : 0;
 
 	if (hif2)
@@ -520,23 +517,16 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 		wed->wlan.wpdma_tx = wed->wlan.phy_base + hif1_ofs +
 					     MT_TXQ_RING_BASE(0) +
 					     MT7996_TXQ_BAND2 * MT_RING_SIZE;
-		if (mt7996_has_hwrro(dev)) {
-			if (is_mt7996(&dev->mt76)) {
-				wed->wlan.txfree_tbit = ffs(MT_INT_RX_TXFREE_EXT) - 1;
-				wed->wlan.wpdma_txfree = wed->wlan.phy_base + hif1_ofs +
-							 MT_RXQ_RING_BASE(0) +
-							 MT7996_RXQ_TXFREE2 * MT_RING_SIZE;
-			} else {
-				wed->wlan.txfree_tbit = ffs(MT_INT_RX_TXFREE_BAND1_EXT) - 1;
-				wed->wlan.wpdma_txfree = wed->wlan.phy_base + hif1_ofs +
-							 MT_RXQ_RING_BASE(0) +
-							 MT7996_RXQ_MCU_WA_EXT * MT_RING_SIZE;
-			}
+		if (is_mt7996(&dev->mt76)) {
+			wed->wlan.txfree_tbit = ffs(MT_INT_RX_TXFREE_EXT) - 1;
+			wed->wlan.wpdma_txfree = wed->wlan.phy_base + hif1_ofs +
+						 MT_RXQ_RING_BASE(0) +
+						 MT7996_RXQ_TXFREE2 * MT_RING_SIZE;
 		} else {
+			wed->wlan.txfree_tbit = ffs(MT_INT_RX_TXFREE_BAND1_EXT) - 1;
 			wed->wlan.wpdma_txfree = wed->wlan.phy_base + hif1_ofs +
 						 MT_RXQ_RING_BASE(0) +
-						 MT7996_RXQ_MCU_WA_TRI * MT_RING_SIZE;
-			wed->wlan.txfree_tbit = ffs(MT_INT_RX_DONE_WA_TRI) - 1;
+						 MT7996_RXQ_MCU_WA_EXT * MT_RING_SIZE;
 		}
 
 		wed->wlan.wpdma_rx_glo = wed->wlan.phy_base + hif1_ofs + MT_WFDMA0_GLO_CFG;
@@ -547,7 +537,7 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 		wed->wlan.id = MT7996_DEVICE_ID_2;
 		wed->wlan.tx_tbit[0] = ffs(MT_INT_TX_DONE_BAND2) - 1;
 	} else {
-		wed->wlan.hw_rro = mt7996_has_hwrro(dev);
+		wed->wlan.hw_rro = true;
 		wed->wlan.wpdma_int = wed->wlan.phy_base + MT_INT_SOURCE_CSR;
 		wed->wlan.wpdma_mask = wed->wlan.phy_base + MT_INT_MASK_CSR;
 		wed->wlan.wpdma_tx = wed->wlan.phy_base + MT_TXQ_RING_BASE(0) +
@@ -600,23 +590,15 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 		wed->wlan.tx_tbit[0] = ffs(MT_INT_TX_DONE_BAND0) - 1;
 		wed->wlan.tx_tbit[1] = ffs(MT_INT_TX_DONE_BAND1) - 1;
 		if (is_mt7996(&dev->mt76)) {
-			if (mt7996_has_hwrro(dev)) {
-				wed->wlan.wpdma_txfree = wed->wlan.phy_base +
-							 MT_RXQ_RING_BASE(0) +
-							 MT7996_RXQ_TXFREE0 * MT_RING_SIZE;
-				wed->wlan.txfree_tbit = ffs(MT_INT_RX_TXFREE_MAIN) - 1;
-			} else {
-				wed->wlan.wpdma_txfree = wed->wlan.phy_base +
-							 MT_RXQ_RING_BASE(0) +
-							 MT7996_RXQ_MCU_WA_MAIN * MT_RING_SIZE;
-				wed->wlan.txfree_tbit = ffs(MT_INT_RX_DONE_WA_MAIN) - 1;
-			}
+			wed->wlan.wpdma_txfree = wed->wlan.phy_base +
+						 MT_RXQ_RING_BASE(0) +
+						 MT7996_RXQ_TXFREE0 * MT_RING_SIZE;
+			wed->wlan.txfree_tbit = ffs(MT_INT_RX_TXFREE_MAIN) - 1;
 		} else {
 			wed->wlan.txfree_tbit = ffs(MT_INT_RX_DONE_WA_MAIN) - 1;
 			wed->wlan.wpdma_txfree = wed->wlan.phy_base + MT_RXQ_RING_BASE(0) +
 						  MT7996_RXQ_MCU_WA_MAIN * MT_RING_SIZE;
 		}
-		dev->mt76.rx_token_size = MT7996_TOKEN_SIZE + wed->wlan.rx_npkt;
 
 		if (dev->hif2 && is_mt7992(&dev->mt76))
 			wed->wlan.id = 0x7992;
@@ -639,9 +621,14 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 		wed->wlan.reset_complete = mt76_wed_reset_complete;
 	}
 
-	if (mtk_wed_device_attach(wed)) {
-		dev->mt76.hwrro_mode = MT76_HWRRO_OFF;
+	if (mtk_wed_device_attach(wed))
 		return 0;
+
+	if (!hif2) {
+		dev->mt76.hwrro_mode = is_mt7996(&dev->mt76) ? MT76_HWRRO_V3
+							     : MT76_HWRRO_V3_1;
+		dev->mt76.rx_token_size = MT7996_TOKEN_SIZE +
+					  wed->wlan.rx_npkt;
 	}
 
 	*irq = wed->irq;
-- 
2.53.0



