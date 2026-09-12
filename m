Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAB5390615;
	Sat, 12 Sep 2026 16:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230451; cv=none; b=QhsU02HA0Fk+4/yXKpMlb5ojPhWbRd76jC8+vXITx6S/U71Z9UFJcMsa/7knVv1DeU0Ji17hlqWijxpyteiXhpVKpsR2EncISKRkU8mTJjZbi2zeRwQMc/7mjcqIrhscTRb+ZJiECZNE7okXlGRLdEp1HLRlfLUS1Kc30c8BL7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230451; c=relaxed/simple;
	bh=aLS0Wy71Xpjq/Rl8h39MzNesrQLxK9nlCNgwqJkuhnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFeR/iqWMosX3h+ulAIt489SPM39JIZEzbZiOooD9e0Tsun/WhC2NrOBNPOH7VGpqRhF3DUYE5F2afU5x4ZlZAydXV+P6a+6si5B6MSHt7XCU6O0UHzXiuCpBGkKK5wCj97NR2suA6G/HB+5p6Bo6AKwV4Uy24bU1vC1Ym6Zknw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRh8yiUr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRh8yiUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFE31F000FF;
	Sat, 12 Sep 2026 16:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230448;
	bh=SH9kl/lLV+tOiFW0rGOp934IaYF06Q/4msvwBv9mdcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZRh8yiUrwdrLf1+QwZVZG4lwY0y3q7vcdXWzN7arphNG4frK8zr9V/hJagHZlegnn
	 nKBm4AkR+JuhZhygekqOyyvdJeJE5YoVcqi5q6Cd30VzPpwpwWFWaxAlwFLH2WH+1A
	 GNdSahDZb1Ir46gf2f4iwF+8e3rsYaWSVUe4i80c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	Sujuan Chen <sujuan.chen@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0797/1191] wifi: mt76: mt7915: move wed init routines in mmio.c
Date: Sat, 12 Sep 2026 08:58:45 +0200
Message-ID: <20260912065606.174213423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 5498cee3c84f117286f70c687a9e78e7aa137f4e ]

This is a preliminary patch to enable wed support for mt7986-wmac
chipset.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Bo Jiao <Bo.Jiao@mediatek.com>
Signed-off-by: Bo Jiao <Bo.Jiao@mediatek.com>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: bade0d238b60 ("wifi: mt76: mt7915: fix net_fill_forward_path for non-DBDC mt7986")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mmio.c  | 91 ++++++++++++++++++
 .../wireless/mediatek/mt76/mt7915/mt7915.h    |  2 +
 .../net/wireless/mediatek/mt76/mt7915/pci.c   | 93 +------------------
 3 files changed, 94 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
index 74f5321611c45..08031ebd6907b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
@@ -10,6 +10,9 @@
 #include "mac.h"
 #include "../trace.h"
 
+static bool wed_enable;
+module_param(wed_enable, bool, 0644);
+
 static const u32 mt7915_reg[] = {
 	[INT_SOURCE_CSR]	= 0xd7010,
 	[INT_MASK_CSR]		= 0xd7014,
@@ -472,6 +475,94 @@ static u32 mt7915_rmw(struct mt76_dev *mdev, u32 offset, u32 mask, u32 val)
 	return dev->bus_ops->rmw(mdev, addr, mask, val);
 }
 
+#ifdef CONFIG_NET_MEDIATEK_SOC_WED
+static int mt7915_mmio_wed_offload_enable(struct mtk_wed_device *wed)
+{
+	struct mt7915_dev *dev;
+	struct mt7915_phy *phy;
+	int ret;
+
+	dev = container_of(wed, struct mt7915_dev, mt76.mmio.wed);
+
+	spin_lock_bh(&dev->mt76.token_lock);
+	dev->mt76.token_size = wed->wlan.token_start;
+	spin_unlock_bh(&dev->mt76.token_lock);
+
+	ret = wait_event_timeout(dev->mt76.tx_wait,
+				 !dev->mt76.wed_token_count, HZ);
+	if (!ret)
+		return -EAGAIN;
+
+	phy = &dev->phy;
+	mt76_set(dev, MT_AGG_ACR4(phy->band_idx), MT_AGG_ACR_PPDU_TXS2H);
+
+	phy = dev->mt76.phys[MT_BAND1] ? dev->mt76.phys[MT_BAND1]->priv : NULL;
+	if (phy)
+		mt76_set(dev, MT_AGG_ACR4(phy->band_idx),
+			 MT_AGG_ACR_PPDU_TXS2H);
+
+	return 0;
+}
+
+static void mt7915_mmio_wed_offload_disable(struct mtk_wed_device *wed)
+{
+	struct mt7915_dev *dev;
+	struct mt7915_phy *phy;
+
+	dev = container_of(wed, struct mt7915_dev, mt76.mmio.wed);
+
+	spin_lock_bh(&dev->mt76.token_lock);
+	dev->mt76.token_size = MT7915_TOKEN_SIZE;
+	spin_unlock_bh(&dev->mt76.token_lock);
+
+	/* MT_TXD5_TX_STATUS_HOST (MPDU format) has higher priority than
+	 * MT_AGG_ACR_PPDU_TXS2H (PPDU format) even though ACR bit is set.
+	 */
+	phy = &dev->phy;
+	mt76_clear(dev, MT_AGG_ACR4(phy->band_idx), MT_AGG_ACR_PPDU_TXS2H);
+
+	phy = dev->mt76.phys[MT_BAND1] ? dev->mt76.phys[MT_BAND1]->priv : NULL;
+	if (phy)
+		mt76_clear(dev, MT_AGG_ACR4(phy->band_idx),
+			   MT_AGG_ACR_PPDU_TXS2H);
+}
+#endif
+
+int mt7915_mmio_wed_init(struct mt7915_dev *dev, struct pci_dev *pdev,
+			 int *irq)
+{
+#ifdef CONFIG_NET_MEDIATEK_SOC_WED
+	struct mtk_wed_device *wed = &dev->mt76.mmio.wed;
+	int ret;
+
+	if (!wed_enable)
+		return 0;
+
+	wed->wlan.pci_dev = pdev;
+	wed->wlan.wpdma_phys = pci_resource_start(pdev, 0) +
+			       MT_WFDMA_EXT_CSR_BASE;
+	wed->wlan.nbuf = 4096;
+	wed->wlan.token_start = MT7915_TOKEN_SIZE - wed->wlan.nbuf;
+	wed->wlan.init_buf = mt7915_wed_init_buf;
+	wed->wlan.offload_enable = mt7915_mmio_wed_offload_enable;
+	wed->wlan.offload_disable = mt7915_mmio_wed_offload_disable;
+
+	if (mtk_wed_device_attach(wed) != 0)
+		return 0;
+
+	*irq = wed->irq;
+	dev->mt76.dma_dev = wed->dev;
+
+	ret = dma_set_mask(wed->dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
+
+	return 1;
+#else
+	return 0;
+#endif
+}
+
 static int mt7915_mmio_init(struct mt76_dev *mdev,
 			    void __iomem *mem_base,
 			    u32 device_id)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index 1eb11617a6255..93999d633b750 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -590,5 +590,7 @@ bool mt7915_debugfs_rx_log(struct mt7915_dev *dev, const void *data, int len);
 void mt7915_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, struct dentry *dir);
 #endif
+int mt7915_mmio_wed_init(struct mt7915_dev *dev, struct pci_dev *pdev,
+			 int *irq);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
index 3808ce1647d9e..a6ab184fbcf71 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
@@ -12,9 +12,6 @@
 #include "mac.h"
 #include "../trace.h"
 
-static bool wed_enable = false;
-module_param(wed_enable, bool, 0644);
-
 static LIST_HEAD(hif_list);
 static DEFINE_SPINLOCK(hif_lock);
 static u32 hif_idx;
@@ -102,94 +99,6 @@ static int mt7915_pci_hif2_probe(struct pci_dev *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_NET_MEDIATEK_SOC_WED
-static int mt7915_wed_offload_enable(struct mtk_wed_device *wed)
-{
-	struct mt7915_dev *dev;
-	struct mt7915_phy *phy;
-	int ret;
-
-	dev = container_of(wed, struct mt7915_dev, mt76.mmio.wed);
-
-	spin_lock_bh(&dev->mt76.token_lock);
-	dev->mt76.token_size = wed->wlan.token_start;
-	spin_unlock_bh(&dev->mt76.token_lock);
-
-	ret = wait_event_timeout(dev->mt76.tx_wait,
-				 !dev->mt76.wed_token_count, HZ);
-	if (!ret)
-		return -EAGAIN;
-
-	phy = &dev->phy;
-	mt76_set(dev, MT_AGG_ACR4(phy->band_idx), MT_AGG_ACR_PPDU_TXS2H);
-
-	phy = dev->mt76.phys[MT_BAND1] ? dev->mt76.phys[MT_BAND1]->priv : NULL;
-	if (phy)
-		mt76_set(dev, MT_AGG_ACR4(phy->band_idx),
-			 MT_AGG_ACR_PPDU_TXS2H);
-
-	return 0;
-}
-
-static void mt7915_wed_offload_disable(struct mtk_wed_device *wed)
-{
-	struct mt7915_dev *dev;
-	struct mt7915_phy *phy;
-
-	dev = container_of(wed, struct mt7915_dev, mt76.mmio.wed);
-
-	spin_lock_bh(&dev->mt76.token_lock);
-	dev->mt76.token_size = MT7915_TOKEN_SIZE;
-	spin_unlock_bh(&dev->mt76.token_lock);
-
-	/* MT_TXD5_TX_STATUS_HOST (MPDU format) has higher priority than
-	 * MT_AGG_ACR_PPDU_TXS2H (PPDU format) even though ACR bit is set.
-	 */
-	phy = &dev->phy;
-	mt76_clear(dev, MT_AGG_ACR4(phy->band_idx), MT_AGG_ACR_PPDU_TXS2H);
-
-	phy = dev->mt76.phys[MT_BAND1] ? dev->mt76.phys[MT_BAND1]->priv : NULL;
-	if (phy)
-		mt76_clear(dev, MT_AGG_ACR4(phy->band_idx),
-			   MT_AGG_ACR_PPDU_TXS2H);
-}
-#endif
-
-static int
-mt7915_pci_wed_init(struct mt7915_dev *dev, struct pci_dev *pdev, int *irq)
-{
-#ifdef CONFIG_NET_MEDIATEK_SOC_WED
-	struct mtk_wed_device *wed = &dev->mt76.mmio.wed;
-	int ret;
-
-	if (!wed_enable)
-		return 0;
-
-	wed->wlan.pci_dev = pdev;
-	wed->wlan.wpdma_phys = pci_resource_start(pdev, 0) +
-			       MT_WFDMA_EXT_CSR_BASE;
-	wed->wlan.nbuf = 4096;
-	wed->wlan.token_start = MT7915_TOKEN_SIZE - wed->wlan.nbuf;
-	wed->wlan.init_buf = mt7915_wed_init_buf;
-	wed->wlan.offload_enable = mt7915_wed_offload_enable;
-	wed->wlan.offload_disable = mt7915_wed_offload_disable;
-
-	if (mtk_wed_device_attach(wed) != 0)
-		return 0;
-
-	*irq = wed->irq;
-	dev->mt76.dma_dev = wed->dev;
-
-	ret = dma_set_mask(wed->dev, DMA_BIT_MASK(32));
-	if (ret)
-		return ret;
-
-	return 1;
-#else
-	return 0;
-#endif
-}
-
 static int mt7915_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
@@ -227,7 +136,7 @@ static int mt7915_pci_probe(struct pci_dev *pdev,
 	mt7915_wfsys_reset(dev);
 	hif2 = mt7915_pci_init_hif2(pdev);
 
-	ret = mt7915_pci_wed_init(dev, pdev, &irq);
+	ret = mt7915_mmio_wed_init(dev, pdev, &irq);
 	if (ret < 0)
 		goto free_wed_or_irq_vector;
 
-- 
2.53.0



