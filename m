Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCAE3BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0V3LKTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAA9C433CD;
	Wed, 15 Nov 2023 19:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076133;
	bh=xGTSM0215/3VrZcVSj/+VqkIjZ7UFv9Dxa9dExgNCqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0V3LKTHYBTR5kAsMsVhpE2uTSf/UfgZiqfpv4OQx92J4PH9Le7siZh58siVcPH+K
	 dylOu5Dm33cxvvquY5JUAixHzIXlbezLaQTmwG45v51Cb5VI/KNWXgnDarvhIPtaXa
	 8XOK5bhKcVYdlYU9kiSIA1HhmYJNuJTr9GgWI+r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 095/550] wifi: mt76: fix per-band IEEE80211_CONF_MONITOR flag comparison
Date: Wed, 15 Nov 2023 14:11:19 -0500
Message-ID: <20231115191607.301883910@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit c685034cabc574dbdf16fa675010e202083cb4c2 ]

Use the correct ieee80211_conf of each band for IEEE80211_CONF_MONITOR
comparison.

Fixes: 24e69f6bc3ca ("mt76: fix monitor rx FCS error in DFS channel")
Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 8d745c9730c72..955974a82180f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -2147,7 +2147,7 @@ int mt7615_mcu_set_chan_info(struct mt7615_phy *phy, int cmd)
 	};
 
 	if (cmd == MCU_EXT_CMD(SET_RX_PATH) ||
-	    dev->mt76.hw->conf.flags & IEEE80211_CONF_MONITOR)
+	    phy->mt76->hw->conf.flags & IEEE80211_CONF_MONITOR)
 		req.switch_reason = CH_SWITCH_NORMAL;
 	else if (phy->mt76->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
 		req.switch_reason = CH_SWITCH_SCAN_BYPASS_DPD;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index fa0f938f03a32..4116434a8b313 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2702,7 +2702,7 @@ int mt7915_mcu_set_chan_info(struct mt7915_phy *phy, int cmd)
 	if (mt76_connac_spe_idx(phy->mt76->antenna_mask))
 		req.tx_path_num = fls(phy->mt76->antenna_mask);
 
-	if (dev->mt76.hw->conf.flags & IEEE80211_CONF_MONITOR)
+	if (phy->mt76->hw->conf.flags & IEEE80211_CONF_MONITOR)
 		req.switch_reason = CH_SWITCH_NORMAL;
 	else if (phy->mt76->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL ||
 		 phy->mt76->hw->conf.flags & IEEE80211_CONF_IDLE)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index c4492803ec16e..c45a8afc7c18a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2873,7 +2873,7 @@ int mt7996_mcu_set_chan_info(struct mt7996_phy *phy, u16 tag)
 		.channel_band = ch_band[chandef->chan->band],
 	};
 
-	if (dev->mt76.hw->conf.flags & IEEE80211_CONF_MONITOR)
+	if (phy->mt76->hw->conf.flags & IEEE80211_CONF_MONITOR)
 		req.switch_reason = CH_SWITCH_NORMAL;
 	else if (phy->mt76->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL ||
 		 phy->mt76->hw->conf.flags & IEEE80211_CONF_IDLE)
-- 
2.42.0



