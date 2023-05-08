Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B92168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4805C433D2;
	Mon,  8 May 2023 10:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542349;
	bh=0ovDxWfPiRaDk5Z2AmzJEHlT27OomhaXK38BTyLRLtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFpStFbPA0zi8RLU7z371+YK/i52180VYnHiqcSlc0RBQrGP/VneUUbKPoHAiEJ8D
	 D3XvTnvUDl5e53mrtzSci3FPirSjbnRlkIfzCESP3aBLphiihfAGLDeop+XX3F+YYb
	 evewfaWB0tcy8+ru5chWssdfDd6MFz+LiE5ZhX+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 407/663] wifi: mt76: mt7996: rely on mt76_connac_txp_common structure
Date: Mon,  8 May 2023 11:43:53 +0200
Message-Id: <20230508094441.277661108@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 3c38dfc1702d812f7c4a89ed5b0521e2ad8381d6 ]

mt7996_txp structure is equal to mt76_connac_fw_txp one. Drop mt7996_txp
and rely on mt76_connac_txp_common.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 3b522cadedfe ("wifi: mt76: mt7996: fill txd by host driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   | 38 +++++++++----------
 .../net/wireless/mediatek/mt76/mt7996/mac.h   | 15 +-------
 .../net/wireless/mediatek/mt76/mt7996/mmio.c  |  2 +-
 3 files changed, 22 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 17f0b287507d7..4a9d1d3556825 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1072,8 +1072,8 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx_info->skb);
 	struct ieee80211_key_conf *key = info->control.hw_key;
 	struct ieee80211_vif *vif = info->control.vif;
+	struct mt76_connac_txp_common *txp;
 	struct mt76_txwi_cache *t;
-	struct mt7996_txp *txp;
 	int id, i, pid, nbuf = tx_info->nbuf - 1;
 	bool is_8023 = info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP;
 	u8 *txwi = (u8 *)txwi_ptr;
@@ -1107,35 +1107,35 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 		mt7996_mac_write_txwi(dev, txwi_ptr, tx_info->skb, wcid, key,
 				      pid, qid, 0);
 
-	txp = (struct mt7996_txp *)(txwi + MT_TXD_SIZE);
+	txp = (struct mt76_connac_txp_common *)(txwi + MT_TXD_SIZE);
 	for (i = 0; i < nbuf; i++) {
-		txp->buf[i] = cpu_to_le32(tx_info->buf[i + 1].addr);
-		txp->len[i] = cpu_to_le16(tx_info->buf[i + 1].len);
+		txp->fw.buf[i] = cpu_to_le32(tx_info->buf[i + 1].addr);
+		txp->fw.len[i] = cpu_to_le16(tx_info->buf[i + 1].len);
 	}
-	txp->nbuf = nbuf;
+	txp->fw.nbuf = nbuf;
 
-	txp->flags = cpu_to_le16(MT_CT_INFO_FROM_HOST);
+	txp->fw.flags = cpu_to_le16(MT_CT_INFO_FROM_HOST);
 
 	if (!is_8023 || pid >= MT_PACKET_ID_FIRST)
-		txp->flags |= cpu_to_le16(MT_CT_INFO_APPLY_TXD);
+		txp->fw.flags |= cpu_to_le16(MT_CT_INFO_APPLY_TXD);
 
 	if (!key)
-		txp->flags |= cpu_to_le16(MT_CT_INFO_NONE_CIPHER_FRAME);
+		txp->fw.flags |= cpu_to_le16(MT_CT_INFO_NONE_CIPHER_FRAME);
 
 	if (!is_8023 && ieee80211_is_mgmt(hdr->frame_control))
-		txp->flags |= cpu_to_le16(MT_CT_INFO_MGMT_FRAME);
+		txp->fw.flags |= cpu_to_le16(MT_CT_INFO_MGMT_FRAME);
 
 	if (vif) {
 		struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
 
-		txp->bss_idx = mvif->mt76.idx;
+		txp->fw.bss_idx = mvif->mt76.idx;
 	}
 
-	txp->token = cpu_to_le16(id);
+	txp->fw.token = cpu_to_le16(id);
 	if (test_bit(MT_WCID_FLAG_4ADDR, &wcid->flags))
-		txp->rept_wds_wcid = cpu_to_le16(wcid->idx);
+		txp->fw.rept_wds_wcid = cpu_to_le16(wcid->idx);
 	else
-		txp->rept_wds_wcid = cpu_to_le16(0xfff);
+		txp->fw.rept_wds_wcid = cpu_to_le16(0xfff);
 	tx_info->skb = DMA_DUMMY_DATA;
 
 	/* pass partial skb header to fw */
@@ -1174,13 +1174,13 @@ mt7996_tx_check_aggr(struct ieee80211_sta *sta, __le32 *txwi)
 static void
 mt7996_txp_skb_unmap(struct mt76_dev *dev, struct mt76_txwi_cache *t)
 {
-	struct mt7996_txp *txp;
+	struct mt76_connac_txp_common *txp;
 	int i;
 
 	txp = mt7996_txwi_to_txp(dev, t);
-	for (i = 0; i < txp->nbuf; i++)
-		dma_unmap_single(dev->dev, le32_to_cpu(txp->buf[i]),
-				 le16_to_cpu(txp->len[i]), DMA_TO_DEVICE);
+	for (i = 0; i < txp->fw.nbuf; i++)
+		dma_unmap_single(dev->dev, le32_to_cpu(txp->fw.buf[i]),
+				 le16_to_cpu(txp->fw.len[i]), DMA_TO_DEVICE);
 }
 
 static void
@@ -1557,11 +1557,11 @@ void mt7996_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue_entry *e)
 
 	/* error path */
 	if (e->skb == DMA_DUMMY_DATA) {
+		struct mt76_connac_txp_common *txp;
 		struct mt76_txwi_cache *t;
-		struct mt7996_txp *txp;
 
 		txp = mt7996_txwi_to_txp(mdev, e->txwi);
-		t = mt76_token_put(mdev, le16_to_cpu(txp->token));
+		t = mt76_token_put(mdev, le16_to_cpu(txp->fw.token));
 		e->skb = t ? t->skb : NULL;
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.h b/drivers/net/wireless/mediatek/mt76/mt7996/mac.h
index ed79388e59713..1404ded52104a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.h
@@ -265,17 +265,6 @@ enum tx_mgnt_type {
 /* VHT/HE only use bits 0-3 */
 #define MT_TX_RATE_IDX			GENMASK(5, 0)
 
-struct mt7996_txp {
-	__le16 flags;
-	__le16 token;
-	u8 bss_idx;
-	__le16 rept_wds_wcid;
-	u8 nbuf;
-#define MT_TXP_MAX_BUF_NUM	6
-	__le32 buf[MT_TXP_MAX_BUF_NUM];
-	__le16 len[MT_TXP_MAX_BUF_NUM];
-} __packed __aligned(4);
-
 #define MT_TXFREE0_PKT_TYPE		GENMASK(31, 27)
 #define MT_TXFREE0_MSDU_CNT		GENMASK(25, 16)
 #define MT_TXFREE0_RX_BYTE		GENMASK(15, 0)
@@ -379,7 +368,7 @@ struct mt7996_dfs_radar_spec {
 	struct mt7996_dfs_pattern radar_pattern[16];
 };
 
-static inline struct mt7996_txp *
+static inline struct mt76_connac_txp_common *
 mt7996_txwi_to_txp(struct mt76_dev *dev, struct mt76_txwi_cache *t)
 {
 	u8 *txwi;
@@ -389,7 +378,7 @@ mt7996_txwi_to_txp(struct mt76_dev *dev, struct mt76_txwi_cache *t)
 
 	txwi = mt76_get_txwi_ptr(dev, t);
 
-	return (struct mt7996_txp *)(txwi + MT_TXD_SIZE);
+	return (struct mt76_connac_txp_common *)(txwi + MT_TXD_SIZE);
 }
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index d8a2c1a744b25..2237f50adbc71 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -318,7 +318,7 @@ struct mt7996_dev *mt7996_mmio_probe(struct device *pdev,
 {
 	static const struct mt76_driver_ops drv_ops = {
 		/* txwi_size = txd size + txp size */
-		.txwi_size = MT_TXD_SIZE + sizeof(struct mt7996_txp),
+		.txwi_size = MT_TXD_SIZE + sizeof(struct mt76_connac_fw_txp),
 		.drv_flags = MT_DRV_TXWI_NO_FREE |
 			     MT_DRV_HW_MGMT_TXQ,
 		.survey_flags = SURVEY_INFO_TIME_TX |
-- 
2.39.2



