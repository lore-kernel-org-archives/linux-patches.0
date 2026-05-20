Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F4F3EEACD;
	Wed, 20 May 2026 16:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294601; cv=none; b=BJJaRk3CEJq6CAFboWp6nwwqpMKe7s+Z3d5YIE0O2ey0GYD6uNQLp0NnCvcqqMcIQ6YowY3gU/DB90Hj60ZqGYoaSgolwemsrYgjjsFrPgnIA9RfX0oeJSJ4Abq13HM3uEZTgwVmqez2Jz9z08tIUMt1V2dzDD99xtqE3792AYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294601; c=relaxed/simple;
	bh=ldFB//cCJ1VOP5RmQq6Z69OBINPZNwY8vULABkUik7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUGarPqobzT8w8xaXUiHZmKVSb5dubNaQLdNM0YPc8QuURqJsdfvoNSZ6GN6j3L3+fao+wiz8IDQcnFmjrzAIXklLuaoJ7JCuiaXzL8hIUnO1iUlIWsNhCdpXoo1T/dokg8c1ryEnn/uIbwDT82Lb/VBdZJ/zN7sJs5HPznmNtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WL9Juvbh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WL9Juvbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156691F000E9;
	Wed, 20 May 2026 16:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294600;
	bh=A6R7ylZUltsO06JQrbfduh9rAq0QE2kEHcbxbmg0NqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WL9JuvbhBJHiJJecIEZ6paRrdt1qGYIG8EgbwXbxk5wTd+6CTnh7nf/Um8KqQVWL5
	 aPx70P5DugYzYbolWWgPilwgx0YV8yO6+bg+GEuSI4A3K8N2XGhVzliKjXKPr2tCWR
	 bHbSu8TeH5G6ZXabB/U+7XkaqHl8FffBSmirZ8QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Yen <leon.yen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0101/1146] wifi: mt76: mt7925: Fix incorrect MLO mode in firmware control
Date: Wed, 20 May 2026 18:05:51 +0200
Message-ID: <20260520162150.630777171@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Yen <leon.yen@mediatek.com>

[ Upstream commit 1695f662329faa07c860c73453c097823852df28 ]

The selection of MLO mode should depend on the capabilities of the STA
rather than those of the peer AP to avoid compatibility issues with
certain APs, such as Xiaomi BE5000 WiFi7 router.

Fixes: 69acd6d910b0c ("wifi: mt76: mt7925: add mt7925_change_vif_links")
Signed-off-by: Leon Yen <leon.yen@mediatek.com>
Link: https://patch.msgid.link/20251211123836.4169436-1-leon.yen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    | 9 ++++++---
 drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h | 4 ++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 2d358a96640c9..d99a60ae063e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -541,7 +541,7 @@ static int mt7925_set_mlo_roc(struct mt792x_phy *phy,
 
 	phy->roc_grant = false;
 
-	err = mt7925_mcu_set_mlo_roc(mconf, sel_links, 5, ++phy->roc_token_id);
+	err = mt7925_mcu_set_mlo_roc(phy, mconf, sel_links, 5, ++phy->roc_token_id);
 	if (err < 0) {
 		clear_bit(MT76_STATE_ROC, &phy->mt76->state);
 		goto out;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 47f91b9f1b95b..dec8e2de86b69 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1294,8 +1294,8 @@ int mt7925_mcu_add_key(struct mt76_dev *dev, struct ieee80211_vif *vif,
 	return mt76_mcu_skb_send_msg(dev, skb, mcu_cmd, true);
 }
 
-int mt7925_mcu_set_mlo_roc(struct mt792x_bss_conf *mconf, u16 sel_links,
-			   int duration, u8 token_id)
+int mt7925_mcu_set_mlo_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
+			   u16 sel_links, int duration, u8 token_id)
 {
 	struct mt792x_vif *mvif = mconf->vif;
 	struct ieee80211_vif *vif = container_of((void *)mvif,
@@ -1330,6 +1330,8 @@ int mt7925_mcu_set_mlo_roc(struct mt792x_bss_conf *mconf, u16 sel_links,
 			.roc[1].len = cpu_to_le16(sizeof(struct roc_acquire_tlv))
 	};
 
+	struct wiphy *wiphy = phy->mt76->hw->wiphy;
+
 	if (!mconf || hweight16(vif->valid_links) < 2 ||
 	    hweight16(sel_links) != 2)
 		return -EPERM;
@@ -1352,7 +1354,8 @@ int mt7925_mcu_set_mlo_roc(struct mt792x_bss_conf *mconf, u16 sel_links,
 		is_AG_band |= links[i].chan->band == NL80211_BAND_2GHZ;
 	}
 
-	if (vif->cfg.eml_cap & IEEE80211_EML_CAP_EMLSR_SUPP)
+	if (!(wiphy->iftype_ext_capab[0].mld_capa_and_ops &
+	      IEEE80211_MLD_CAP_OP_MAX_SIMUL_LINKS))
 		type = is_AG_band ? MT7925_ROC_REQ_MLSR_AG :
 				    MT7925_ROC_REQ_MLSR_AA;
 	else
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index 6b9bf1b890320..a1d902ccce6d2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -349,8 +349,8 @@ int mt7925_set_tx_sar_pwr(struct ieee80211_hw *hw,
 int mt7925_mcu_regval(struct mt792x_dev *dev, u32 regidx, u32 *val, bool set);
 int mt7925_mcu_set_clc(struct mt792x_dev *dev, u8 *alpha2,
 		       enum environment_cap env_cap);
-int mt7925_mcu_set_mlo_roc(struct mt792x_bss_conf *mconf, u16 sel_links,
-			   int duration, u8 token_id);
+int mt7925_mcu_set_mlo_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
+			   u16 sel_links, int duration, u8 token_id);
 int mt7925_mcu_set_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
 		       struct ieee80211_channel *chan, int duration,
 		       enum mt7925_roc_req type, u8 token_id);
-- 
2.53.0



