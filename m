Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C393002B3;
	Sat, 12 Sep 2026 10:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209252; cv=none; b=pCmsdyPaKseP2TzMSVNw1fnv8IkDa7fcNhvvFV1mILtvg/sIs8jaoaOBRLwgdauZyhN3sbVWOCz0g+6ebpntmigbaRN4telkmi5bwyxEmDQ92EZ6wwpTS9VYJA/tVKp4Fq35BAlN/Kre8MZdaLJugmS+1nAdS0hhOhEoQTM617k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209252; c=relaxed/simple;
	bh=QrfvANaAf0b0q8IStg0c13jBABNCfKfDQvNy7drnWUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCpIDY4S/PW80v5igPuoE6UuRydwouep+MqqXtQM+fxu3zsAfS9ftPqml4huDYVTx30E96KoH5/5u/UaERwndkJCHXomlH/s6ciBhg/LS6fqSSZjckLPA6/gK8EHE8n34bM0yRgjbAtGGrF9eCt9P3pvc0VDjqCjN23GhCdeF4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8ZggMCU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8ZggMCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5328C1F00893;
	Sat, 12 Sep 2026 10:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209251;
	bh=ibzPxod29hENN6eMuTAEzl1YqQNV8a32893gg9SdSw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8ZggMCUwA51TmuqGBd5+uZW1/fEInpdlU4zYSe2b0c9t1hlJB95A/xIVvwLMuhco
	 czji5COHlPsYH4CZ5VGaSJKbT7DNsp/5p9xZ2Fi6lKqsc1CYByFhAY/I0T12/2Zmqa
	 MPZ2GOswLg0mFpwaiXgP4MZYR876fEJMO7EzRdTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0740/1518] wifi: mt76: mt7996: set specific BSSINFO and STAREC commands after channel switch
Date: Sat, 12 Sep 2026 08:48:29 +0200
Message-ID: <20260912065640.173802164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit 7247037a016ed4bc8a50507d74d0bae98409ae3f ]

After channel switch, some tags of BSSINFO (rfch) and STAREC (bfer,
rate_ctrl) commands should also be updated. Otherwise, a BSS might not be
able to transmit with its peer using correct bandwidth.

Co-developed-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Link: https://patch.msgid.link/20251215063728.3013365-3-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: ce35ecffc96e ("wifi: mt76: mt7996: fix MLD ID in MAC TXD and HIF TXP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 14 ++++-
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 59 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  3 +
 3 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index fd4e9112cccc5..d363f9022c4a6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -950,12 +950,24 @@ mt7996_post_channel_switch(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct cfg80211_chan_def *chandef = &link_conf->chanreq.oper;
 	struct mt7996_dev *dev = mt7996_hw_dev(hw);
 	struct mt7996_phy *phy = mt7996_band_phy(dev, chandef->chan->band);
-	int ret;
+	struct mt7996_vif_link *link;
+	int ret = -EINVAL;
 
 	mutex_lock(&dev->mt76.mutex);
 
+	link = mt7996_vif_conf_link(dev, vif, link_conf);
+	if (!link)
+		goto out;
+
+	ret = mt7996_mcu_update_bss_rfch(phy, link);
+	if (ret)
+		goto out;
+
+	ieee80211_iterate_stations_mtx(hw, mt7996_mcu_update_sta_rec_bw, link);
+
 	ret = mt7996_mcu_rdd_resume_tx(phy);
 
+out:
 	mutex_unlock(&dev->mt76.mutex);
 
 	return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index ee9716868c907..c591606c1765c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1177,6 +1177,22 @@ int mt7996_mcu_add_bss_info(struct mt7996_phy *phy, struct ieee80211_vif *vif,
 				     MCU_WMWA_UNI_CMD(BSS_INFO_UPDATE), true);
 }
 
+int mt7996_mcu_update_bss_rfch(struct mt7996_phy *phy, struct mt7996_vif_link *link)
+{
+	struct mt7996_dev *dev = phy->dev;
+	struct sk_buff *skb;
+
+	skb = __mt7996_mcu_alloc_bss_req(&dev->mt76, &link->mt76,
+					 MT7996_BSS_UPDATE_MAX_SIZE);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	mt7996_mcu_bss_rfch_tlv(skb, phy);
+
+	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
+				     MCU_WMWA_UNI_CMD(BSS_INFO_UPDATE), true);
+}
+
 int mt7996_mcu_set_timing(struct mt7996_phy *phy, struct ieee80211_vif *vif,
 			  struct ieee80211_bss_conf *link_conf)
 {
@@ -2541,6 +2557,49 @@ int mt7996_mcu_teardown_mld_sta(struct mt7996_dev *dev,
 				     MCU_WMWA_UNI_CMD(STA_REC_UPDATE), true);
 }
 
+void mt7996_mcu_update_sta_rec_bw(void *data, struct ieee80211_sta *sta)
+{
+	struct mt7996_vif_link *link = (struct mt7996_vif_link *)data;
+	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	struct mt7996_sta_link *msta_link;
+	struct mt7996_dev *dev;
+	struct ieee80211_bss_conf *link_conf;
+	struct ieee80211_link_sta *link_sta;
+	struct ieee80211_vif *vif;
+	struct sk_buff *skb;
+	int link_id;
+
+	if (link->mt76.mvif != &msta->vif->mt76)
+		return;
+
+	dev = link->phy->dev;
+	link_id = link->msta_link.wcid.link_id;
+	link_sta = link_sta_dereference_protected(sta, link_id);
+	if (!link_sta)
+		return;
+
+	msta_link = mt76_dereference(msta->link[link_id], &dev->mt76);
+	if (!msta_link)
+		return;
+
+	vif = container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
+	link_conf = link_conf_dereference_protected(vif, link_id);
+	if (!link_conf)
+		return;
+
+	skb = __mt76_connac_mcu_alloc_sta_req(&dev->mt76, &link->mt76,
+					      &msta_link->wcid,
+					      MT7996_STA_UPDATE_MAX_SIZE);
+	if (IS_ERR(skb))
+		return;
+
+	mt7996_mcu_sta_bfer_tlv(dev, skb, link_conf, link_sta, link);
+	mt7996_mcu_sta_rate_ctrl_tlv(skb, dev, vif, link_conf, link_sta, link);
+
+	mt76_mcu_skb_send_msg(&dev->mt76, skb,
+			      MCU_WMWA_UNI_CMD(STA_REC_UPDATE), true);
+}
+
 static int
 mt7996_mcu_sta_key_tlv(struct mt76_dev *dev, struct mt76_wcid *wcid,
 		       struct sk_buff *skb,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 9f46d39e1e2cf..26c04cd08caea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -670,6 +670,8 @@ int mt7996_mcu_add_bss_info(struct mt7996_phy *phy, struct ieee80211_vif *vif,
 			    struct ieee80211_bss_conf *link_conf,
 			    struct mt76_vif_link *mlink,
 			    struct mt7996_sta_link *msta_link, int enable);
+int mt7996_mcu_update_bss_rfch(struct mt7996_phy *phy,
+			       struct mt7996_vif_link *link);
 int mt7996_mcu_add_sta(struct mt7996_dev *dev,
 		       struct ieee80211_bss_conf *link_conf,
 		       struct ieee80211_link_sta *link_sta,
@@ -679,6 +681,7 @@ int mt7996_mcu_add_sta(struct mt7996_dev *dev,
 int mt7996_mcu_teardown_mld_sta(struct mt7996_dev *dev,
 				struct mt7996_vif_link *link,
 				struct mt7996_sta_link *msta_link);
+void mt7996_mcu_update_sta_rec_bw(void *data, struct ieee80211_sta *sta);
 int mt7996_mcu_add_tx_ba(struct mt7996_dev *dev,
 			 struct ieee80211_ampdu_params *params,
 			 struct ieee80211_vif *vif, bool enable);
-- 
2.53.0



