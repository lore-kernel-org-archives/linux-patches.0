Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFA121B9FC;
	Tue, 17 Jun 2025 16:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177418; cv=none; b=VHaTBYfda02RPNkBHrpsn7SwR4QLkgGMBd8OC4K6ewReJnLvj7kfmiMS9hMpnYWfENtBElAVLA7B2I+MvfsDbpgvoFOivmHURDnjQw/+9Pu/zhRyzKBZ8t7xDgoVm/JEJr/9wsjDRHo5AdbDveWu0H+qDsAaqYkFGpk/tCwUqCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177418; c=relaxed/simple;
	bh=1lPkNAi9MhvH2jEn7YOQcQBxiCR5Opq7YoXImDHdq68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LuS9F0e+Z8WpIGaA5XitPW9MQSGlS92623rktSaDXOF2jyEThZTVp4uv1Lho156DqhWiqYw1qH8jFBPfJydXjMfRPgQ61XQAE2BYwH6WzWMy4GbT264qE3K/JO9W+PK3tH9i3sTpPwcSnRP8o3/51fA0rSeRbPl01rV0j7eRBB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6x1k7Yc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6x1k7Yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332EDC4CEE7;
	Tue, 17 Jun 2025 16:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177418;
	bh=1lPkNAi9MhvH2jEn7YOQcQBxiCR5Opq7YoXImDHdq68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6x1k7Yc3/F+6AHfmYfBFeA9HML0/t4Xuhz1WsC+5PhBwGzHGkE/ybePUC1hRAEjW
	 fiSSGOpHKmZJAIkwov2llSEq9C6bq9vdAKMqDqtgivhX4xShirJLtu9HE8rkh31bAh
	 gKThHGnO7r1RTVhuJXPHK2pbRRx9fVkrRtF9VJkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 303/780] wifi: mt76: mt7996: fix invalid NSS setting when TX path differs from NSS
Date: Tue, 17 Jun 2025 17:20:11 +0200
Message-ID: <20250617152503.806134708@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit d5012734fc4bd5371e2e8dea8c2f3d28287573b8 ]

The maximum TX path and NSS may differ on a band. For example, one variant
of the MT7992 has 5 TX paths and 4 NSS on the 5 GHz band. To address this,
add orig_antenna_mask to record the maximum NSS and prevent setting an
invalid NSS in mt7996_set_antenna().

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20250515032952.1653494-5-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c | 1 +
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
index 53dfac02f8af0..f0c76aac175df 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
@@ -304,6 +304,7 @@ int mt7996_eeprom_parse_hw_cap(struct mt7996_dev *dev, struct mt7996_phy *phy)
 		phy->has_aux_rx = true;
 
 	mphy->antenna_mask = BIT(nss) - 1;
+	phy->orig_antenna_mask = mphy->antenna_mask;
 	mphy->chainmask = (BIT(path) - 1) << dev->chainshift[band_idx];
 	phy->orig_chainmask = mphy->chainmask;
 	dev->chainmask |= mphy->chainmask;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 8698c4345af0c..a3295b22523a6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1528,7 +1528,8 @@ mt7996_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
 		u8 shift = dev->chainshift[band_idx];
 
 		phy->mt76->chainmask = tx_ant & phy->orig_chainmask;
-		phy->mt76->antenna_mask = phy->mt76->chainmask >> shift;
+		phy->mt76->antenna_mask = (phy->mt76->chainmask >> shift) &
+					  phy->orig_antenna_mask;
 
 		mt76_set_stream_caps(phy->mt76, true);
 		mt7996_set_stream_vht_txbf_caps(phy);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 43e646ed6094c..c393784436d4c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -293,6 +293,7 @@ struct mt7996_phy {
 	struct mt76_channel_state state_ts;
 
 	u16 orig_chainmask;
+	u16 orig_antenna_mask;
 
 	bool has_aux_rx;
 	bool counter_reset;
-- 
2.39.5



