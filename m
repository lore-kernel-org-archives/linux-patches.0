Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C42367B60;
	Sat, 12 Sep 2026 08:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200961; cv=none; b=f0Q3duPs6qPiDsLarUHdR2Fuqn66+KzBP3fhseBzkKBbdBnpw6b6koLcvo4dT4TsOjUv6oiahsgNZ44ZeJRSuQVPfzrwE3xk/Hbg8LQrr6tHVZVX84VOLfVEmLgLYHVD6xclmI828pdE4WZ/ilr8b0qV7OUhEeQMwAC2iyV+tGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200961; c=relaxed/simple;
	bh=g5ITXjZe5paG/0T4/eYgB9N0iUCkjj2+/mDf+sLdxNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjsIWeiXon+e6mjUtHh/pSpoxzxb+dSMboKSiR5NvuUUzCDTqPJl+NeO/NNrWuktAuQ1uwlLDCyuUz261kURj5lcK3NJDhhM9crVKBFEV7kvF4XrBBscQjGmJeh36j6vXWcGwkAvkhObeIARIFXJlJQhxj9ufFZ/YsNyTz1Ck48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTqJ7POs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTqJ7POs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C83F1F000FF;
	Sat, 12 Sep 2026 08:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200960;
	bh=q9RLoTGXGziOJ/7ayWTnNlieMlU/u3Acwu0YkSllrXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTqJ7POs7UlG7h3XIdUgL9ynu5nI2LMfAOeXUHmBpna/0zO/TNv/L/Xgw4oqIgNV1
	 JuXjS1QwlJJtk5ltezoM9bbJ/7KpGr0jKvSkFC919nZc9RvVfeKKBMweIEbnyn35QF
	 GpOQvGDP4XEu8C4Byf3N6O+BKIP75GFCkhkqK4ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0897/1815] wifi: mt76: decode the full VHT Rx STBC capability field
Date: Sat, 12 Sep 2026 08:44:07 +0200
Message-ID: <20260912065709.978526323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit e8b76a6e0d04d13ae55dc746a270f382825c395b ]

The Rx STBC subfield of the VHT capabilities is a 3-bit cumulative value,
but the driver only tested the RXSTBC_1 bit when advertising the peer's
Rx STBC support to firmware. A peer reporting Rx STBC of 2, 3 or 4 has
that bit clear, so STBC was never used towards it. Test the full
IEEE80211_VHT_CAP_RXSTBC_MASK, matching the HT path.

Fixes: 046d2e7c50e3 ("mac80211: prepare sta handling for MLO support")
Fixes: 2660fde82f65 ("wifi: mt76: mt7996: Update mt7996_mcu_add_rate_ctrl to MLO")
Link: https://patch.msgid.link/20260724124813.3961474-6-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 96d2770f7c398..8e0616504f4d5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -1625,7 +1625,7 @@ mt7915_mcu_sta_rate_ctrl_tlv(struct sk_buff *skb, struct mt7915_dev *dev,
 			cap |= STA_CAP_VHT_SGI_160;
 		if (sta->deflink.vht_cap.cap & IEEE80211_VHT_CAP_TXSTBC)
 			cap |= STA_CAP_VHT_TX_STBC;
-		if (sta->deflink.vht_cap.cap & IEEE80211_VHT_CAP_RXSTBC_1)
+		if (sta->deflink.vht_cap.cap & IEEE80211_VHT_CAP_RXSTBC_MASK)
 			cap |= STA_CAP_VHT_RX_STBC;
 		if (mvif->cap.vht_ldpc &&
 		    (sta->deflink.vht_cap.cap & IEEE80211_VHT_CAP_RXLDPC))
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index f57d4a28cc272..289c8390b5fa9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -2483,7 +2483,7 @@ mt7996_mcu_sta_rate_ctrl_tlv(struct sk_buff *skb, struct mt7996_dev *dev,
 			cap |= STA_CAP_VHT_SGI_160;
 		if (link_sta->vht_cap.cap & IEEE80211_VHT_CAP_TXSTBC)
 			cap |= STA_CAP_VHT_TX_STBC;
-		if (link_sta->vht_cap.cap & IEEE80211_VHT_CAP_RXSTBC_1)
+		if (link_sta->vht_cap.cap & IEEE80211_VHT_CAP_RXSTBC_MASK)
 			cap |= STA_CAP_VHT_RX_STBC;
 		if ((vif->type != NL80211_IFTYPE_AP || link_conf->vht_ldpc) &&
 		    (link_sta->vht_cap.cap & IEEE80211_VHT_CAP_RXLDPC))
-- 
2.53.0



