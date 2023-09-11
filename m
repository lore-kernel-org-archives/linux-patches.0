Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E1A8472
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A37C433C7;
	Mon, 11 Sep 2023 14:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442823;
	bh=Gcfcmk7Rdre/TkDxWB9LhWr7Hqm//P5G9OuPT0M6XMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvbDsDnQUrXCBWfy3IwiyfVE8/LOE2HmL2qlxBii8Z7I97z1nfFevV9CPCxHOUlVj
	 cnudX3L+vWuykgYlurPwioLcSP/eCBrHHJfoaxQJZ3MbqzVNEOfpqgAqnYNGcPBHWL
	 DDK3PWzOE+DCL4+1OOwZ+iqq2nyI4lnEkdK/Tafc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 161/737] wifi: mt76: mt7915: rework tx bytes counting when WED is active
Date: Mon, 11 Sep 2023 15:40:20 +0200
Message-ID: <20230911134654.993290292@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit f39d499345dddb8382986fd5a2a0e84a63b1a6d5 ]

Concurrent binding/non-binding skbs could be handled anywhere which leads
to mixed byte counting, so switch to use PPDU TxS reporting regardless Tx
paths when WED is active.

Fixes: 43eaa3689507 ("wifi: mt76: add PPDU based TxS support for WED device")
Co-developed-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt76_connac_mac.c  |  2 --
 .../net/wireless/mediatek/mt76/mt7915/init.c  |  6 ++++
 .../net/wireless/mediatek/mt76/mt7915/mmio.c  | 30 ++-----------------
 drivers/net/wireless/mediatek/mt76/tx.c       |  9 +++++-
 4 files changed, 16 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index 49b2b1f3ffa87..e415ac5e321f1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -522,8 +522,6 @@ void mt76_connac2_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 		q_idx = wmm_idx * MT76_CONNAC_MAX_WMM_SETS +
 			mt76_connac_lmac_mapping(skb_get_queue_mapping(skb));
 
-		/* counting non-offloading skbs */
-		wcid->stats.tx_bytes += skb->len;
 		/* mt7915 WA only counts WED path */
 		if (is_mt7915(dev) && mtk_wed_device_active(&dev->mmio.wed))
 			wcid->stats.tx_packets++;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index ac2049f49bb38..927a98a315ae8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -499,6 +499,12 @@ mt7915_mac_init_band(struct mt7915_dev *dev, u8 band)
 	set = FIELD_PREP(MT_WTBLOFF_TOP_RSCR_RCPI_MODE, 0) |
 	      FIELD_PREP(MT_WTBLOFF_TOP_RSCR_RCPI_PARAM, 0x3);
 	mt76_rmw(dev, MT_WTBLOFF_TOP_RSCR(band), mask, set);
+
+	/* MT_TXD5_TX_STATUS_HOST (MPDU format) has higher priority than
+	 * MT_AGG_ACR_PPDU_TXS2H (PPDU format) even though ACR bit is set.
+	 */
+	if (mtk_wed_device_active(&dev->mt76.mmio.wed))
+		mt76_set(dev, MT_AGG_ACR4(band), MT_AGG_ACR_PPDU_TXS2H);
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
index 45f3558bf31c1..2fa059af23ded 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
@@ -545,8 +545,6 @@ static u32 mt7915_rmw(struct mt76_dev *mdev, u32 offset, u32 mask, u32 val)
 static int mt7915_mmio_wed_offload_enable(struct mtk_wed_device *wed)
 {
 	struct mt7915_dev *dev;
-	struct mt7915_phy *phy;
-	int ret;
 
 	dev = container_of(wed, struct mt7915_dev, mt76.mmio.wed);
 
@@ -554,43 +552,19 @@ static int mt7915_mmio_wed_offload_enable(struct mtk_wed_device *wed)
 	dev->mt76.token_size = wed->wlan.token_start;
 	spin_unlock_bh(&dev->mt76.token_lock);
 
-	ret = wait_event_timeout(dev->mt76.tx_wait,
-				 !dev->mt76.wed_token_count, HZ);
-	if (!ret)
-		return -EAGAIN;
-
-	phy = &dev->phy;
-	mt76_set(dev, MT_AGG_ACR4(phy->mt76->band_idx), MT_AGG_ACR_PPDU_TXS2H);
-
-	phy = dev->mt76.phys[MT_BAND1] ? dev->mt76.phys[MT_BAND1]->priv : NULL;
-	if (phy)
-		mt76_set(dev, MT_AGG_ACR4(phy->mt76->band_idx),
-			 MT_AGG_ACR_PPDU_TXS2H);
-
-	return 0;
+	return !wait_event_timeout(dev->mt76.tx_wait,
+				   !dev->mt76.wed_token_count, HZ);
 }
 
 static void mt7915_mmio_wed_offload_disable(struct mtk_wed_device *wed)
 {
 	struct mt7915_dev *dev;
-	struct mt7915_phy *phy;
 
 	dev = container_of(wed, struct mt7915_dev, mt76.mmio.wed);
 
 	spin_lock_bh(&dev->mt76.token_lock);
 	dev->mt76.token_size = MT7915_TOKEN_SIZE;
 	spin_unlock_bh(&dev->mt76.token_lock);
-
-	/* MT_TXD5_TX_STATUS_HOST (MPDU format) has higher priority than
-	 * MT_AGG_ACR_PPDU_TXS2H (PPDU format) even though ACR bit is set.
-	 */
-	phy = &dev->phy;
-	mt76_clear(dev, MT_AGG_ACR4(phy->mt76->band_idx), MT_AGG_ACR_PPDU_TXS2H);
-
-	phy = dev->mt76.phys[MT_BAND1] ? dev->mt76.phys[MT_BAND1]->priv : NULL;
-	if (phy)
-		mt76_clear(dev, MT_AGG_ACR4(phy->mt76->band_idx),
-			   MT_AGG_ACR_PPDU_TXS2H);
 }
 
 static void mt7915_mmio_wed_release_rx_buf(struct mtk_wed_device *wed)
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 72b3ec715e47a..e9b9728458a9b 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -121,6 +121,7 @@ int
 mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
 		       struct sk_buff *skb)
 {
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct mt76_tx_cb *cb = mt76_tx_skb_cb(skb);
 	int pid;
@@ -134,8 +135,14 @@ mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
 		return MT_PACKET_ID_NO_ACK;
 
 	if (!(info->flags & (IEEE80211_TX_CTL_REQ_TX_STATUS |
-			     IEEE80211_TX_CTL_RATE_CTRL_PROBE)))
+			     IEEE80211_TX_CTL_RATE_CTRL_PROBE))) {
+		if (mtk_wed_device_active(&dev->mmio.wed) &&
+		    ((info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) ||
+		     ieee80211_is_data(hdr->frame_control)))
+			return MT_PACKET_ID_WED;
+
 		return MT_PACKET_ID_NO_SKB;
+	}
 
 	spin_lock_bh(&dev->status_lock);
 
-- 
2.40.1



