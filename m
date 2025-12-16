Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5411F3446C0;
	Tue, 16 Dec 2025 11:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886052; cv=none; b=uZznOv1QOPZOBdPnxvpHk6Y3jyeZSccAFg/Y1damUhvXBOEAEXZMjjgO+b9iu+HXt33ionpDeA7QizgoKeCQVy0GOpaPVDoXUianQ5VJSx2ByJcApUj5CfIYoKbdR15LLxNRnWcOs4GubnAoSbp4Ned/WHRt68Tuq7NYxJ7Ez4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886052; c=relaxed/simple;
	bh=bxCnYt5/wyIzlJ6OysRwX/koE3km/p2ALd9Ia3xAz3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMXhwdVtuNvUHKjX3MvXTawGJhP0KJvotAT+fXebtstAksPlwLfKh0MOJdPJozCaTPz/nABTgxkC1sHn4YB+jLas0mHuFncCXOdQuDnCi5Qi4R04ZMZbind7CpqFTSnLZlT1TVPsZC5LEEgNfBCORaBjE3/4lN4rQuJYyCJpKQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTSeyRK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTSeyRK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6005AC4CEF1;
	Tue, 16 Dec 2025 11:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886051;
	bh=bxCnYt5/wyIzlJ6OysRwX/koE3km/p2ALd9Ia3xAz3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTSeyRK3brlhanGJdjpOgNpNie7HuJq7gE0/puKyQOvxj0hYqXOO0VUqyQ+CxhdMV
	 y1VH1NF4WxJzBy/gRoYNMJ4euauQoxsbpkp/KAB1G6osI1y1RzuHf96/MxhyeyJHss
	 QvcRxlrCIxivgnJCN/Ii25eIxCvVwECMpcjBjU2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 324/507] wifi: mt76: mt7925: add MBSSID support
Date: Tue, 16 Dec 2025 12:12:45 +0100
Message-ID: <20251216111357.203862300@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 74e756b9e28af3ee94a7ea480bb39694be5fbd96 ]

Enable MBSSID support for MT7925 by setting the
appropriate capability to the firmware.

Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250729084932.264155-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: cdb2941a516c ("Revert "wifi: mt76: mt792x: improve monitor interface handling"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  |  1 +
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 23 ++++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt792x_core.c  |  7 +++++-
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index b0e053b152273..c7903972b1d59 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -240,6 +240,7 @@ int mt7925_init_mlo_caps(struct mt792x_phy *phy)
 {
 	struct wiphy *wiphy = phy->mt76->hw->wiphy;
 	static const u8 ext_capa_sta[] = {
+		[2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
 		[7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
 	};
 	static struct wiphy_iftype_ext_capab ext_capab[] = {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index cd457be26523e..10d68d241ba1f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2621,6 +2621,25 @@ mt7925_mcu_bss_qos_tlv(struct sk_buff *skb, struct ieee80211_bss_conf *link_conf
 	qos->qos = link_conf->qos;
 }
 
+static void
+mt7925_mcu_bss_mbssid_tlv(struct sk_buff *skb, struct ieee80211_bss_conf *link_conf,
+			  bool enable)
+{
+	struct bss_info_uni_mbssid *mbssid;
+	struct tlv *tlv;
+
+	if (!enable && !link_conf->bssid_indicator)
+		return;
+
+	tlv = mt76_connac_mcu_add_tlv(skb, UNI_BSS_INFO_11V_MBSSID,
+				      sizeof(*mbssid));
+
+	mbssid = (struct bss_info_uni_mbssid *)tlv;
+	mbssid->max_indicator = link_conf->bssid_indicator;
+	mbssid->mbss_idx = link_conf->bssid_index;
+	mbssid->tx_bss_omac_idx = 0;
+}
+
 static void
 mt7925_mcu_bss_he_tlv(struct sk_buff *skb, struct ieee80211_bss_conf *link_conf,
 		      struct mt792x_phy *phy)
@@ -2787,8 +2806,10 @@ int mt7925_mcu_add_bss_info(struct mt792x_phy *phy,
 		mt7925_mcu_bss_color_tlv(skb, link_conf, enable);
 	}
 
-	if (enable)
+	if (enable) {
 		mt7925_mcu_bss_rlm_tlv(skb, phy->mt76, link_conf, ctx);
+		mt7925_mcu_bss_mbssid_tlv(skb, link_conf, enable);
+	}
 
 	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
 				     MCU_UNI_CMD(BSS_INFO_UPDATE), true);
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index e3a703398b30c..44378f7394e8d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -689,8 +689,13 @@ int mt792x_init_wiphy(struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, SUPPORTS_VHT_EXT_NSS_BW);
 	ieee80211_hw_set(hw, CONNECTION_MONITOR);
 	ieee80211_hw_set(hw, NO_VIRTUAL_MONITOR);
-	if (is_mt7921(&dev->mt76))
+
+	if (is_mt7921(&dev->mt76)) {
 		ieee80211_hw_set(hw, CHANCTX_STA_CSA);
+	} else {
+		ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
+		ieee80211_hw_set(hw, SUPPORTS_ONLY_HE_MULTI_BSSID);
+	}
 
 	if (dev->pm.enable)
 		ieee80211_hw_set(hw, CONNECTION_MONITOR);
-- 
2.51.0



