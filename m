Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3001519BE;
	Wed,  5 Feb 2025 14:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765050; cv=none; b=QHHYJyyWNYVUv3TGdZ3w7QwPeEO9RtEMlZUKO0SwCRRM94UlIArS/Llm078eFfikUymDEsoh+9CgKpQHKZt4RBuBvNBn5N6e3jl6cdvFhPzVBb5tMf+On0gle/XJ5f5Ala80wakHLqKmOudoju4fmsFXC2WGjV2KwCLnCDdMaZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765050; c=relaxed/simple;
	bh=JYCRcn7b+bsDS5PFaqYPGtoNB02Eg/m3Z8xhp1xol3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFociIbH25L4BKPzyLewK8xk1H29p92NzngC6H200nIb8Ug8p7doYYxf9/sPzbxt/vLiNDK2hqhVzrAez17hpAnbLKkGrk3syPet2UjeZxGYMwHdG4iJP42WDJD4JEpKoWWCH+GD7HQgDBcQl96dvO5i9K8bsK4WIxZPiWQS9IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOue9SKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOue9SKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01E5C4CED1;
	Wed,  5 Feb 2025 14:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765050;
	bh=JYCRcn7b+bsDS5PFaqYPGtoNB02Eg/m3Z8xhp1xol3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SOue9SKqcSZEndqJ8yeBRcKvHO4575Dha73elou0/pFVbD0LCaa/xAagxY8Snh0Bj
	 32ufWSEZ5zOJzd76P/MY3NP40zWyhYx5POvNS85xbFSiRfSd1zrFGfoqw0dS72ih3G
	 wJnOlcYG6DEoeMwRRviKs3PggSNKMdKJH1rGysYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 185/590] wifi: mt76: mt7925: fix wrong parameter for related cmd of chan info
Date: Wed,  5 Feb 2025 14:39:00 +0100
Message-ID: <20250205134502.358184671@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



