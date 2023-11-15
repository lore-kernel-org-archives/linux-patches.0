Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4910741A84
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHkO8AMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7C8C433C8;
	Wed, 15 Nov 2023 19:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076982;
	bh=RBuHHBR9UDHlapYKZyNnkHzAJYa4Siz7Cjz0n/K5m00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHkO8AMA5h/ipoB+WHL2z3uIvgc+X2+MH6GQ6nnTuMD/ikLSfLYHY0fPgAwkNGsXN
	 +q1ZVoV8QRMEqvxp0ZWnRUM5vFz7xHMNIecwBfq3xHkzarDX1eKIr5CZVFNGtkdY+5
	 FT92YzjC8PV+bKS0lNzaDJIultDzObY7H7beG3NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/603] wifi: mt76: mt7996: fix wmm queue mapping
Date: Wed, 15 Nov 2023 14:10:31 -0500
Message-ID: <20231115191619.083855333@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit 9b11696e5c5bf6030a32571f3f88845226d8b662 ]

Firmware uses access class index (ACI) for wmm parameters update, so
convert mac80211 queue to ACI in mt7996_conf_tx().

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 12 +++++++++---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c  |  2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index c3a479dc3f533..600010cdb94e6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -190,7 +190,7 @@ static int mt7996_add_interface(struct ieee80211_hw *hw,
 	mvif->mt76.omac_idx = idx;
 	mvif->phy = phy;
 	mvif->mt76.band_idx = band_idx;
-	mvif->mt76.wmm_idx = band_idx;
+	mvif->mt76.wmm_idx = vif->type != NL80211_IFTYPE_AP;
 
 	ret = mt7996_mcu_add_dev_info(phy, vif, true);
 	if (ret)
@@ -414,10 +414,16 @@ mt7996_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	       const struct ieee80211_tx_queue_params *params)
 {
 	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
+	const u8 mq_to_aci[] = {
+		[IEEE80211_AC_VO] = 3,
+		[IEEE80211_AC_VI] = 2,
+		[IEEE80211_AC_BE] = 0,
+		[IEEE80211_AC_BK] = 1,
+	};
 
+	/* firmware uses access class index */
+	mvif->queue_params[mq_to_aci[queue]] = *params;
 	/* no need to update right away, we'll get BSS_CHANGED_QOS */
-	queue = mt76_connac_lmac_mapping(queue);
-	mvif->queue_params[queue] = *params;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 4ed1643818980..cf443748ef7cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2679,7 +2679,7 @@ int mt7996_mcu_set_tx(struct mt7996_dev *dev, struct ieee80211_vif *vif)
 
 		e = (struct edca *)tlv;
 		e->set = WMM_PARAM_SET;
-		e->queue = ac + mvif->mt76.wmm_idx * MT7996_MAX_WMM_SETS;
+		e->queue = ac;
 		e->aifs = q->aifs;
 		e->txop = cpu_to_le16(q->txop);
 
-- 
2.42.0



