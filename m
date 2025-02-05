Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66579522A;
	Wed,  5 Feb 2025 14:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765662; cv=none; b=tXtgvovgCLKAzMH8HGi32sGwYQqEadyulZMhgp6tfpcEqf7+l6dwUtna9PUZ2atdCphUrh4rQ1pPtCek32MyFGBXXIpbn/MnJlbw//aJsYgJJmnKp0+9bFDT7kwgeBfXFrWCLUhcVf99cFCCNcP73KU92rB0a/TGeIOqSU8hoeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765662; c=relaxed/simple;
	bh=ULvoZgXjLGrmVE/K4OT8q7RGVN5BzuAm1EcEWdL+H10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=el2GLcFqeGP1Pd7dC0dSI00nBo8Ix0aRfEZT/b0elZrtogin21sL7kNISeLdnHmeTZoZWdSXtvL5ZkZwnrdcTx9g2BvFs9inyhWdVYl6KDTcd9k5E9MaeO+YVIZm+U6liB3ScstRP+b/KQULhm0OfjX6PD05MaTcrKKxtYPcoqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNtAgl1k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNtAgl1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61B8C4CED1;
	Wed,  5 Feb 2025 14:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765662;
	bh=ULvoZgXjLGrmVE/K4OT8q7RGVN5BzuAm1EcEWdL+H10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BNtAgl1k00RGfTbGluvDBNi89/IgKuKp/O5agj2R0YNZfwjKT1ayXQUHpaOqi9dmu
	 X61GzEAVSxAQOaODMaM4pmefQ5s4cb986FFrJrx1Vzilwo+Jz5mXslM+qDzfSZdwFJ
	 ATjstYAiB9pxbg44dlKrDhDSDk+N4QZOSBge7fPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 193/623] wifi: mt76: mt7925: Enhance mt7925_mac_link_bss_add to support MLO
Date: Wed,  5 Feb 2025 14:38:55 +0100
Message-ID: <20250205134503.620270800@linuxfoundation.org>
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

[ Upstream commit ac03e5b82bc6b44e8ea3e7c7c624ee1445ff4e4b ]

In mt7925_mac_link_bss_add(), the mt76_connac_mcu_uni_add_dev() function
must be executed only after all parameters have been properly initialized.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-8-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 268d216f09e20..3cd3c3e289e72 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -365,18 +365,14 @@ static int mt7925_mac_link_bss_add(struct mt792x_dev *dev,
 	mconf->mt76.omac_idx = ieee80211_vif_is_mld(vif) ?
 			       0 : mconf->mt76.idx;
 	mconf->mt76.band_idx = 0xff;
-	mconf->mt76.wmm_idx = mconf->mt76.idx % MT76_CONNAC_MAX_WMM_SETS;
+	mconf->mt76.wmm_idx = ieee80211_vif_is_mld(vif) ?
+			      0 : mconf->mt76.idx % MT76_CONNAC_MAX_WMM_SETS;
 
 	if (mvif->phy->mt76->chandef.chan->band != NL80211_BAND_2GHZ)
 		mconf->mt76.basic_rates_idx = MT792x_BASIC_RATES_TBL + 4;
 	else
 		mconf->mt76.basic_rates_idx = MT792x_BASIC_RATES_TBL;
 
-	ret = mt76_connac_mcu_uni_add_dev(&dev->mphy, link_conf, &mconf->mt76,
-					  &mlink->wcid, true);
-	if (ret)
-		goto out;
-
 	dev->mt76.vif_mask |= BIT_ULL(mconf->mt76.idx);
 	mvif->phy->omac_mask |= BIT_ULL(mconf->mt76.omac_idx);
 
@@ -395,6 +391,12 @@ static int mt7925_mac_link_bss_add(struct mt792x_dev *dev,
 	ewma_rssi_init(&mconf->rssi);
 
 	rcu_assign_pointer(dev->mt76.wcid[idx], &mlink->wcid);
+
+	ret = mt76_connac_mcu_uni_add_dev(&dev->mphy, link_conf, &mconf->mt76,
+					  &mlink->wcid, true);
+	if (ret)
+		goto out;
+
 	if (vif->txq) {
 		mtxq = (struct mt76_txq *)vif->txq->drv_priv;
 		mtxq->wcid = idx;
-- 
2.39.5



