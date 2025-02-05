Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ADD14B959;
	Wed,  5 Feb 2025 14:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765587; cv=none; b=OYAKq5XBWGeccxbF0uPwe64eYsaN14uU6MEUXKWEnQUfsLsERHfG1d8AhiPyfBWWANVq1Ht4dSWPKn56CFrYjfFOQ+lgC6djJRSh0tOEavVnlFIbD/VzplRuNCU88qPbMZ9Fgq+4UWsMg3hWlUx/W1r4vu0vs9M4WfMCqYetxBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765587; c=relaxed/simple;
	bh=K4Pvq505q3yMDrxHcRdkpHHjoWi5LwycEXDRZXWOmAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZD6xf+9FBk+TtMuoJvcZa5cAOCYqVekakbeM+MSnkhiBkWsrsXIUAUkq6HMacu0oL/daapZMCcUQpbKOu7Apwi9h4ZbKbGx+G6CEDAYRjpttxyTZkidg90P7eYECLDbY9T5WhheGjrJxoF6fipIllvMhGHh1fnb6JEJfUxI0xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQxdh/qI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQxdh/qI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AAAC4CED1;
	Wed,  5 Feb 2025 14:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765587;
	bh=K4Pvq505q3yMDrxHcRdkpHHjoWi5LwycEXDRZXWOmAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yQxdh/qIkQ8Tu30SwgVU+hkERiUJW1w4fLInLha/olJpLtmNv/c7+vDAYCIEQAIuP
	 /XT+SsRhfiEjPfxXOooco65fWDtceK0qD0ZJH129Z4tFXMkVTXWMsrWqyOTivXWYOS
	 2dHHBaLNBJUg7mIShCX4S4Xv9m5IaeRJ/iKi2NvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 191/623] wifi: mt76: mt7925: fix wrong parameter for related cmd of chan info
Date: Wed,  5 Feb 2025 14:38:53 +0100
Message-ID: <20250205134503.544285041@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 3f0d2178aaf1ed1c017e61cde9ce8a4432c804d1 ]

Fix incorrect parameters for the related channel information command.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-6-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 23 +++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 7105705113baa..23d0b1d97956e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1198,6 +1198,8 @@ int mt7925_mcu_set_mlo_roc(struct mt792x_bss_conf *mconf, u16 sel_links,
 		req.roc[i].bw_from_ap = CMD_CBW_20MHZ;
 		req.roc[i].center_chan = center_ch;
 		req.roc[i].center_chan_from_ap = center_ch;
+		req.roc[i].center_chan2 = 0;
+		req.roc[i].center_chan2_from_ap = 0;
 
 		/* STR : 0xfe indicates BAND_ALL with enabling DBDC
 		 * EMLSR : 0xff indicates (BAND_AUTO) without DBDC
@@ -2175,11 +2177,27 @@ void mt7925_mcu_bss_rlm_tlv(struct sk_buff *skb, struct mt76_phy *phy,
 	req = (struct bss_rlm_tlv *)tlv;
 	req->control_channel = chandef->chan->hw_value;
 	req->center_chan = ieee80211_frequency_to_channel(freq1);
-	req->center_chan2 = ieee80211_frequency_to_channel(freq2);
+	req->center_chan2 = 0;
 	req->tx_streams = hweight8(phy->antenna_mask);
 	req->ht_op_info = 4; /* set HT 40M allowed */
 	req->rx_streams = hweight8(phy->antenna_mask);
-	req->band = band;
+	req->center_chan2 = 0;
+	req->sco = 0;
+	req->band = 1;
+
+	switch (band) {
+	case NL80211_BAND_2GHZ:
+		req->band = 1;
+		break;
+	case NL80211_BAND_5GHZ:
+		req->band = 2;
+		break;
+	case NL80211_BAND_6GHZ:
+		req->band = 3;
+		break;
+	default:
+		break;
+	}
 
 	switch (chandef->width) {
 	case NL80211_CHAN_WIDTH_40:
@@ -2190,6 +2208,7 @@ void mt7925_mcu_bss_rlm_tlv(struct sk_buff *skb, struct mt76_phy *phy,
 		break;
 	case NL80211_CHAN_WIDTH_80P80:
 		req->bw = CMD_CBW_8080MHZ;
+		req->center_chan2 = ieee80211_frequency_to_channel(freq2);
 		break;
 	case NL80211_CHAN_WIDTH_160:
 		req->bw = CMD_CBW_160MHZ;
-- 
2.39.5



