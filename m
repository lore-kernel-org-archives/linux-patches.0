Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410A62652AF;
	Tue, 11 Nov 2025 01:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824638; cv=none; b=JDQ+VRVLNmw0HWItGgRzEfAXImQSuzqQUD11C+FYeu+D2es40bT+d/NjWtJCP+yd3AMdjZgebrurHpKSBrrduLTkeekjtptZpAmiDITlTu+SvxNJEod+k3U030NauKN7V1U2CzlOJDMeYcBhQRrtdeX6yySmoUGez1giIKWtLD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824638; c=relaxed/simple;
	bh=HG9cOspX43/+gRgG6OBiehmm4Z10Ih2JyFG5jhMgTG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usjcGy0bKjAIkCbmZ1DZJcco2ToW1bnpMfHhh9Xs/7mZyie3a1hbwq12TmmcEFfjnEyy+seYbaQMWRnHsInjQw3HLaoCY8sx6pCgPqbSxWUoJ0DQDaidDbVb3NL7mwE6i5JdUT38IICoeO3BA158pZ2vIIFV5WwUDAEPK7VIYMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snD+4aVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snD+4aVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79C5C16AAE;
	Tue, 11 Nov 2025 01:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824638;
	bh=HG9cOspX43/+gRgG6OBiehmm4Z10Ih2JyFG5jhMgTG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=snD+4aVsvXkwamGUvh7sb6bKcWq4+4+XDdVBMLj93EPEWHY3nQURGCj97HR31PoQV
	 brbByRjbjiknYHOobPKNYHSV3YJSieGC8yVhyHYHYO2tzsLNwAW4zg708Ywmmm7+xi
	 jN3y1dGId02i77bDFyZgVqgB4X8vJlwAdhwgc8eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 541/849] wifi: mt76: mt7996: support writing MAC TXD for AddBA Request
Date: Tue, 11 Nov 2025 09:41:51 +0900
Message-ID: <20251111004549.492052494@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit cb6ebbdffef2a888b95f121637cd1fad473919c6 ]

Support writing MAC TXD for the AddBA Req. Without this commit, the
start sequence number in AddBA Req will be unexpected value for MT7996
and MT7992. This can result in certain stations (e.g., AX200) dropping
packets, leading to ping failures and degraded connectivity. Ensuring
the correct MAC TXD and TXP helps maintain reliable packet transmission
and prevents interoperability issues with affected stations.

Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Link: https://patch.msgid.link/20250909-mt7996-addba-txd-fix-v1-1-feec16f0c6f0@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt76_connac3_mac.h |  7 ++
 .../net/wireless/mediatek/mt76/mt7996/mac.c   | 91 +++++++++++++------
 2 files changed, 69 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.h b/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.h
index 1013cad57a7ff..c5eaedca11e09 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac3_mac.h
@@ -294,6 +294,13 @@ enum tx_frag_idx {
 #define MT_TXP_BUF_LEN			GENMASK(11, 0)
 #define MT_TXP_DMA_ADDR_H		GENMASK(15, 12)
 
+#define MT_TXP0_TOKEN_ID0		GENMASK(14, 0)
+#define MT_TXP0_TOKEN_ID0_VALID_MASK	BIT(15)
+
+#define MT_TXP1_TID_ADDBA		GENMASK(14, 12)
+#define MT_TXP3_ML0_MASK		BIT(15)
+#define MT_TXP3_DMA_ADDR_H		GENMASK(13, 12)
+
 #define MT_TX_RATE_STBC			BIT(14)
 #define MT_TX_RATE_NSS			GENMASK(13, 10)
 #define MT_TX_RATE_MODE			GENMASK(9, 6)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 222e720a56cf5..30e2ef1404b90 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -802,6 +802,9 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 	    mgmt->u.action.u.addba_req.action_code == WLAN_ACTION_ADDBA_REQ) {
 		if (is_mt7990(&dev->mt76))
 			txwi[6] |= cpu_to_le32(FIELD_PREP(MT_TXD6_TID_ADDBA, tid));
+		else
+			txwi[7] |= cpu_to_le32(MT_TXD7_MAC_TXD);
+
 		tid = MT_TX_ADDBA;
 	} else if (ieee80211_is_mgmt(hdr->frame_control)) {
 		tid = MT_TX_NORMAL;
@@ -1034,10 +1037,10 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx_info->skb);
 	struct ieee80211_key_conf *key = info->control.hw_key;
 	struct ieee80211_vif *vif = info->control.vif;
-	struct mt76_connac_txp_common *txp;
 	struct mt76_txwi_cache *t;
 	int id, i, pid, nbuf = tx_info->nbuf - 1;
 	bool is_8023 = info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP;
+	__le32 *ptr = (__le32 *)txwi_ptr;
 	u8 *txwi = (u8 *)txwi_ptr;
 
 	if (unlikely(tx_info->skb->len <= ETH_HLEN))
@@ -1060,46 +1063,76 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 		mt7996_mac_write_txwi(dev, txwi_ptr, tx_info->skb, wcid, key,
 				      pid, qid, 0);
 
-	txp = (struct mt76_connac_txp_common *)(txwi + MT_TXD_SIZE);
-	for (i = 0; i < nbuf; i++) {
-		u16 len;
+	/* MT7996 and MT7992 require driver to provide the MAC TXP for AddBA
+	 * req
+	 */
+	if (le32_to_cpu(ptr[7]) & MT_TXD7_MAC_TXD) {
+		u32 val;
+
+		ptr = (__le32 *)(txwi + MT_TXD_SIZE);
+		memset((void *)ptr, 0, sizeof(struct mt76_connac_fw_txp));
+
+		val = FIELD_PREP(MT_TXP0_TOKEN_ID0, id) |
+		      MT_TXP0_TOKEN_ID0_VALID_MASK;
+		ptr[0] = cpu_to_le32(val);
 
-		len = FIELD_PREP(MT_TXP_BUF_LEN, tx_info->buf[i + 1].len);
+		val = FIELD_PREP(MT_TXP1_TID_ADDBA,
+				 tx_info->skb->priority &
+				 IEEE80211_QOS_CTL_TID_MASK);
+		ptr[1] = cpu_to_le32(val);
+		ptr[2] = cpu_to_le32(tx_info->buf[1].addr & 0xFFFFFFFF);
+
+		val = FIELD_PREP(MT_TXP_BUF_LEN, tx_info->buf[1].len) |
+		      MT_TXP3_ML0_MASK;
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-		len |= FIELD_PREP(MT_TXP_DMA_ADDR_H,
-				  tx_info->buf[i + 1].addr >> 32);
+		val |= FIELD_PREP(MT_TXP3_DMA_ADDR_H,
+				  tx_info->buf[1].addr >> 32);
 #endif
+		ptr[3] = cpu_to_le32(val);
+	} else {
+		struct mt76_connac_txp_common *txp;
 
-		txp->fw.buf[i] = cpu_to_le32(tx_info->buf[i + 1].addr);
-		txp->fw.len[i] = cpu_to_le16(len);
-	}
-	txp->fw.nbuf = nbuf;
+		txp = (struct mt76_connac_txp_common *)(txwi + MT_TXD_SIZE);
+		for (i = 0; i < nbuf; i++) {
+			u16 len;
+
+			len = FIELD_PREP(MT_TXP_BUF_LEN, tx_info->buf[i + 1].len);
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+			len |= FIELD_PREP(MT_TXP_DMA_ADDR_H,
+					  tx_info->buf[i + 1].addr >> 32);
+#endif
 
-	txp->fw.flags = cpu_to_le16(MT_CT_INFO_FROM_HOST);
+			txp->fw.buf[i] = cpu_to_le32(tx_info->buf[i + 1].addr);
+			txp->fw.len[i] = cpu_to_le16(len);
+		}
+		txp->fw.nbuf = nbuf;
 
-	if (!is_8023 || pid >= MT_PACKET_ID_FIRST)
-		txp->fw.flags |= cpu_to_le16(MT_CT_INFO_APPLY_TXD);
+		txp->fw.flags = cpu_to_le16(MT_CT_INFO_FROM_HOST);
 
-	if (!key)
-		txp->fw.flags |= cpu_to_le16(MT_CT_INFO_NONE_CIPHER_FRAME);
+		if (!is_8023 || pid >= MT_PACKET_ID_FIRST)
+			txp->fw.flags |= cpu_to_le16(MT_CT_INFO_APPLY_TXD);
 
-	if (!is_8023 && mt7996_tx_use_mgmt(dev, tx_info->skb))
-		txp->fw.flags |= cpu_to_le16(MT_CT_INFO_MGMT_FRAME);
+		if (!key)
+			txp->fw.flags |= cpu_to_le16(MT_CT_INFO_NONE_CIPHER_FRAME);
 
-	if (vif) {
-		struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
-		struct mt76_vif_link *mlink = NULL;
+		if (!is_8023 && mt7996_tx_use_mgmt(dev, tx_info->skb))
+			txp->fw.flags |= cpu_to_le16(MT_CT_INFO_MGMT_FRAME);
 
-		if (wcid->offchannel)
-			mlink = rcu_dereference(mvif->mt76.offchannel_link);
-		if (!mlink)
-			mlink = rcu_dereference(mvif->mt76.link[wcid->link_id]);
+		if (vif) {
+			struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
+			struct mt76_vif_link *mlink = NULL;
 
-		txp->fw.bss_idx = mlink ? mlink->idx : mvif->deflink.mt76.idx;
-	}
+			if (wcid->offchannel)
+				mlink = rcu_dereference(mvif->mt76.offchannel_link);
+			if (!mlink)
+				mlink = rcu_dereference(mvif->mt76.link[wcid->link_id]);
 
-	txp->fw.token = cpu_to_le16(id);
-	txp->fw.rept_wds_wcid = cpu_to_le16(sta ? wcid->idx : 0xfff);
+			txp->fw.bss_idx = mlink ? mlink->idx : mvif->deflink.mt76.idx;
+		}
+
+		txp->fw.token = cpu_to_le16(id);
+		txp->fw.rept_wds_wcid = cpu_to_le16(sta ? wcid->idx : 0xfff);
+	}
 
 	tx_info->skb = NULL;
 
-- 
2.51.0



