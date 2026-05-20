Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942AB35AC18;
	Wed, 20 May 2026 17:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297575; cv=none; b=DoAeeSJBDNuiK9am8DfOmiqgKAGo5SsRdktSiyOKp+Hop8fAvQDpVnYWDUcYRd3FJQGigk9AOp5B3vuFJc4iJHrLKFX9q180XzZiLDrRb9SWkMy/6X6XUy2Bb/Rgs6wa7E/5pDnlMCcVwaBQ9AHeopnK9h45j2ye79ORDjMaWPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297575; c=relaxed/simple;
	bh=SU74u38Jqvxa6Odnpin7t3iMdehiw1JY5k6n9ntHVGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjkPc8syYwL+/Aochm/6Q+k5WUTCPPquWwzMlFx4a/wBWCkeXXAVzMIfzfQ2yBE0Za8A7C0crlyHtbh3+mw0FGReo0300U0qdTOqHTZkxlz2RR65/9Nl9a3y3FuCtAAGJpSWC731MVbs7GDFV2fFu+PiLq91F7XpCZzkoPA9+A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUGaj+Vs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUGaj+Vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0475E1F000E9;
	Wed, 20 May 2026 17:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297574;
	bh=6BJFPLD79UaiFla1++sviO9Z4MSfjidIFJeBsqOJi34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUGaj+VsxTjWToFIKRK4/iH8lRtMtDiblD8Z23gpa/SPv7vANWVgPWf8ZL6/BO5hZ
	 09P2QFwTfBQq9rYPSDkILf9wSkfzhM3SrBEIKMCOeeoycuk2mCMyPdImd4SfwR7/1z
	 EUMuwqst2niwLXRekoIcISbl0hKo6I6xriV1s9DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Yen <leon.yen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/957] wifi: mt76: mt7925: Fix incorrect MLO mode in firmware control
Date: Wed, 20 May 2026 18:09:24 +0200
Message-ID: <20260520162136.317413809@linuxfoundation.org>
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
index ac3d485a2f78f..d1f63c81ceb99 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -533,7 +533,7 @@ static int mt7925_set_mlo_roc(struct mt792x_phy *phy,
 
 	phy->roc_grant = false;
 
-	err = mt7925_mcu_set_mlo_roc(mconf, sel_links, 5, ++phy->roc_token_id);
+	err = mt7925_mcu_set_mlo_roc(phy, mconf, sel_links, 5, ++phy->roc_token_id);
 	if (err < 0) {
 		clear_bit(MT76_STATE_ROC, &phy->mt76->state);
 		goto out;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index e44c9ba168878..130f1742546bc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1243,8 +1243,8 @@ int mt7925_mcu_add_key(struct mt76_dev *dev, struct ieee80211_vif *vif,
 	return mt76_mcu_skb_send_msg(dev, skb, mcu_cmd, true);
 }
 
-int mt7925_mcu_set_mlo_roc(struct mt792x_bss_conf *mconf, u16 sel_links,
-			   int duration, u8 token_id)
+int mt7925_mcu_set_mlo_roc(struct mt792x_phy *phy, struct mt792x_bss_conf *mconf,
+			   u16 sel_links, int duration, u8 token_id)
 {
 	struct mt792x_vif *mvif = mconf->vif;
 	struct ieee80211_vif *vif = container_of((void *)mvif,
@@ -1279,6 +1279,8 @@ int mt7925_mcu_set_mlo_roc(struct mt792x_bss_conf *mconf, u16 sel_links,
 			.roc[1].len = cpu_to_le16(sizeof(struct roc_acquire_tlv))
 	};
 
+	struct wiphy *wiphy = phy->mt76->hw->wiphy;
+
 	if (!mconf || hweight16(vif->valid_links) < 2 ||
 	    hweight16(sel_links) != 2)
 		return -EPERM;
@@ -1301,7 +1303,8 @@ int mt7925_mcu_set_mlo_roc(struct mt792x_bss_conf *mconf, u16 sel_links,
 		is_AG_band |= links[i].chan->band == NL80211_BAND_2GHZ;
 	}
 
-	if (vif->cfg.eml_cap & IEEE80211_EML_CAP_EMLSR_SUPP)
+	if (!(wiphy->iftype_ext_capab[0].mld_capa_and_ops &
+	      IEEE80211_MLD_CAP_OP_MAX_SIMUL_LINKS))
 		type = is_AG_band ? MT7925_ROC_REQ_MLSR_AG :
 				    MT7925_ROC_REQ_MLSR_AA;
 	else
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index 1b165d0d8bd39..1c5ab3ea247d8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -345,8 +345,8 @@ int mt7925_set_tx_sar_pwr(struct ieee80211_hw *hw,
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



