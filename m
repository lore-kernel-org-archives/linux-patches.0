Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D5936A357;
	Wed, 20 May 2026 17:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297702; cv=none; b=uo5DkMWdcndHyoKxHwwuwU2P/XBciSfUrk25SBxA74EJM7LAuokAaL3WR4ZWeK3eZwUYdVtsy+dDsJHCghvwZS2rlqB9BFGesCapgGkqfOjqTp5Du2QWSbYGdiKe5zZkPlzER4kVDg4oipOFc4jWWKZfoFDlRgAkuP2n2a4ZOcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297702; c=relaxed/simple;
	bh=dVulpm4Hk3x0u9kedSki4L0Mo1/nkeXFYpjF9vUhHEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V674Qs2WHww2LDUaULJUmFFLoofCI4k21V7ZUj2ZnQWarMH6hjIhollQLdmgWS0egSp+6OWOWeuAkA0rqTnRRwJnvM3XP1XTa6iebXFrZPYnC/lXxpxQ4rgtQ34NeTKRQLFpqc6REO1rddyHwxEeCxLrhFjswQFEBZJfLrdq1gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUqrQsF/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUqrQsF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9251F000E9;
	Wed, 20 May 2026 17:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297701;
	bh=7UJrmMcX1XodP0uBS6cW9CDIZj2CshZY+HtAifEJ1X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qUqrQsF/lzXmFsU1zWm4h7yX5fOjd2HsvsXVlvp/RB9esjpu8xKFBmYvbAoz7yoKz
	 5xVThZsdw3dX12UkR41YiZbgA6pHPetzr1Lw5XAqbBeILwr2NdOX1FYVQcHTyS3DAH
	 qe+s4GRJnxXyKA9NyZyMVXwqODSxJkDGjbLF3pT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Kao <jack.kao@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/957] wifi: mt76: mt7925: cqm rssi low/high event notify
Date: Wed, 20 May 2026 18:09:32 +0200
Message-ID: <20260520162136.490665440@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Jack Kao <jack.kao@mediatek.com>

[ Upstream commit 2a035ae2062f38dc5183002d1c5a64ca682170c1 ]

The implementation amounts to setting the driver flag
IEEE80211_VIF_SUPPORTS_CQM_RSSI, and then providing
mechanisms for continuously updating enough information
to be able to provide notifications to userspace when
RSSI drops below a certain threshold

Signed-off-by: Jack Kao <jack.kao@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20251001012506.2168037-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 59a1864509d0 ("wifi: mt76: mt7925: drop puncturing handling from BSS change path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  2 +
 .../net/wireless/mediatek/mt76/mt7925/main.c  |  6 ++
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 82 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/mcu.h   |  8 ++
 .../wireless/mediatek/mt76/mt7925/mt7925.h    |  7 ++
 5 files changed, 105 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 27daf419560a5..0b02f34c40a40 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1062,6 +1062,7 @@ enum {
 	MCU_UNI_EVENT_ROC = 0x27,
 	MCU_UNI_EVENT_TX_DONE = 0x2d,
 	MCU_UNI_EVENT_THERMAL = 0x35,
+	MCU_UNI_EVENT_RSSI_MONITOR = 0x41,
 	MCU_UNI_EVENT_NIC_CAPAB = 0x43,
 	MCU_UNI_EVENT_WED_RRO = 0x57,
 	MCU_UNI_EVENT_PER_STA_INFO = 0x6d,
@@ -1300,6 +1301,7 @@ enum {
 	MCU_UNI_CMD_THERMAL = 0x35,
 	MCU_UNI_CMD_VOW = 0x37,
 	MCU_UNI_CMD_FIXED_RATE_TABLE = 0x40,
+	MCU_UNI_CMD_RSSI_MONITOR = 0x41,
 	MCU_UNI_CMD_TESTMODE_CTRL = 0x46,
 	MCU_UNI_CMD_RRO = 0x57,
 	MCU_UNI_CMD_OFFCH_SCAN_CTRL = 0x58,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index d1f63c81ceb99..f503e861a7e63 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -430,6 +430,9 @@ mt7925_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		goto out;
 
 	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
+	if (phy->chip_cap & MT792x_CHIP_CAP_RSSI_NOTIFY_EVT_EN)
+		vif->driver_flags |= IEEE80211_VIF_SUPPORTS_CQM_RSSI;
+
 out:
 	mt792x_mutex_release(dev);
 
@@ -1958,6 +1961,9 @@ static void mt7925_link_info_changed(struct ieee80211_hw *hw,
 		mt7925_mcu_set_eht_pp(mvif->phy->mt76, &mconf->mt76,
 				      link_conf, NULL);
 
+	if (changed & BSS_CHANGED_CQM)
+		mt7925_mcu_set_rssimonitor(dev, vif);
+
 	mt792x_mutex_release(dev);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 130f1742546bc..d887aa9a3dff7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -450,6 +450,56 @@ mt7925_mcu_tx_done_event(struct mt792x_dev *dev, struct sk_buff *skb)
 	}
 }
 
+static void
+mt7925_mcu_rssi_monitor_iter(void *priv, u8 *mac,
+			     struct ieee80211_vif *vif)
+{
+	struct mt7925_uni_rssi_monitor_event *event = priv;
+	enum nl80211_cqm_rssi_threshold_event nl_event;
+	s32 rssi = le32_to_cpu(event->rssi);
+
+	if (vif->type != NL80211_IFTYPE_STATION)
+		return;
+
+	if (!(vif->driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI))
+		return;
+
+	if (rssi > vif->bss_conf.cqm_rssi_thold)
+		nl_event = NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH;
+	else
+		nl_event = NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW;
+
+	ieee80211_cqm_rssi_notify(vif, nl_event, rssi, GFP_KERNEL);
+}
+
+static void
+mt7925_mcu_rssi_monitor_event(struct mt792x_dev *dev, struct sk_buff *skb)
+{
+	struct tlv *tlv;
+	u32 tlv_len;
+	struct mt7925_uni_rssi_monitor_event *event;
+
+	skb_pull(skb, sizeof(struct mt7925_mcu_rxd) + 4);
+	tlv = (struct tlv *)skb->data;
+	tlv_len = skb->len;
+
+	while (tlv_len > 0 && le16_to_cpu(tlv->len) <= tlv_len) {
+		switch (le16_to_cpu(tlv->tag)) {
+		case UNI_EVENT_RSSI_MONITOR_INFO:
+			event = (struct mt7925_uni_rssi_monitor_event *)skb->data;
+			ieee80211_iterate_active_interfaces_atomic(dev->mt76.hw,
+								   IEEE80211_IFACE_ITER_RESUME_ALL,
+								   mt7925_mcu_rssi_monitor_iter,
+								   event);
+			break;
+		default:
+			break;
+		}
+		tlv_len -= le16_to_cpu(tlv->len);
+		tlv = (struct tlv *)((char *)(tlv) + le16_to_cpu(tlv->len));
+	}
+}
+
 static void
 mt7925_mcu_uni_debug_msg_event(struct mt792x_dev *dev, struct sk_buff *skb)
 {
@@ -546,6 +596,9 @@ mt7925_mcu_uni_rx_unsolicited_event(struct mt792x_dev *dev,
 	case MCU_UNI_EVENT_BSS_BEACON_LOSS:
 		mt7925_mcu_connection_loss_event(dev, skb);
 		break;
+	case MCU_UNI_EVENT_RSSI_MONITOR:
+		mt7925_mcu_rssi_monitor_event(dev, skb);
+		break;
 	case MCU_UNI_EVENT_COREDUMP:
 		dev->fw_assert = true;
 		mt76_connac_mcu_coredump_event(&dev->mt76, skb, &dev->coredump);
@@ -3821,3 +3874,32 @@ int mt7925_mcu_set_rxfilter(struct mt792x_dev *dev, u32 fif,
 	return mt76_mcu_send_msg(&phy->dev->mt76, MCU_UNI_CMD(BAND_CONFIG),
 				 &req, sizeof(req), true);
 }
+
+int mt7925_mcu_set_rssimonitor(struct mt792x_dev *dev, struct ieee80211_vif *vif)
+{
+	struct mt792x_bss_conf *mconf = mt792x_link_conf_to_mconf(&vif->bss_conf);
+	struct {
+		struct {
+			u8 bss_idx;
+			u8 pad[3];
+		} __packed hdr;
+		__le16 tag;
+		__le16 len;
+		u8 enable;
+		s8 cqm_rssi_high;
+		s8 cqm_rssi_low;
+		u8 rsv;
+	} req = {
+		.hdr = {
+			.bss_idx = mconf->mt76.idx,
+		},
+		.tag = cpu_to_le16(UNI_CMD_RSSI_MONITOR_SET),
+		.len = cpu_to_le16(sizeof(req) - 4),
+		.enable = vif->cfg.assoc,
+		.cqm_rssi_high = (s8)(vif->bss_conf.cqm_rssi_thold + vif->bss_conf.cqm_rssi_hyst),
+		.cqm_rssi_low = (s8)(vif->bss_conf.cqm_rssi_thold - vif->bss_conf.cqm_rssi_hyst),
+	};
+
+	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(RSSI_MONITOR), &req,
+				 sizeof(req), false);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
index a40764d89a1ff..148aa3c05c8c4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
@@ -152,6 +152,14 @@ enum {
 	UNI_EVENT_SCAN_DONE_NLO = 3,
 };
 
+enum {
+	UNI_CMD_RSSI_MONITOR_SET = 0,
+};
+
+enum {
+	UNI_EVENT_RSSI_MONITOR_INFO = 0,
+};
+
 enum connac3_mcu_cipher_type {
 	CONNAC3_CIPHER_NONE = 0,
 	CONNAC3_CIPHER_WEP40 = 1,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index 1c5ab3ea247d8..7f67e0a978726 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -103,6 +103,12 @@ struct mt7925_uni_beacon_loss_event {
 	struct mt7925_beacon_loss_tlv beacon_loss;
 } __packed;
 
+struct mt7925_uni_rssi_monitor_event {
+		__le16 tag;
+		__le16 len;
+		__le32 rssi;
+} __packed;
+
 #define to_rssi(field, rxv)		((FIELD_GET(field, rxv) - 220) / 2)
 #define to_rcpi(rssi)			(2 * (rssi) + 220)
 
@@ -372,4 +378,5 @@ int mt7925_testmode_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 int mt7925_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *msg,
 			 struct netlink_callback *cb, void *data, int len);
 
+int mt7925_mcu_set_rssimonitor(struct mt792x_dev *dev, struct ieee80211_vif *vif);
 #endif
-- 
2.53.0



