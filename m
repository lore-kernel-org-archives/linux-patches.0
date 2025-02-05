Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969B61519A4;
	Wed,  5 Feb 2025 14:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765069; cv=none; b=d9Efhh5XYWcm/NDy6kHTBLpR8hmlHgKRq2jQMWZRUHUm2q+2XtEPmqRcWrbsJ5pyga8fFADbRJ6M0Hai/QUokeLvcASkxS1s88i8Im1ONoiOFuSc8CD+nCYl2LKZh5wShJ2oDV+hoLmRh0nunopoZT/wj3YGUozakPkGWaAAfiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765069; c=relaxed/simple;
	bh=gsyMZA34rkIyqPIP+LWuJEHb3b1xa8Iu5TckbjXRgrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1Zkfm3IDNQep7ArB/WIi9kRhmz6uo0l6yOQL6sxDduNh/cputRH82v/ZWn5lDu7/nmonC7SGVHUP8+YGv5E7yEpRIM31foUzIO/GJuqaTblTs7Mm3C9t7gzwVnrQpmr0sfHDh0ezT2DiQWADM8syZkvAfIkH1STCA+ih3IgdMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgV9MEB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgV9MEB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111A0C4CED1;
	Wed,  5 Feb 2025 14:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765069;
	bh=gsyMZA34rkIyqPIP+LWuJEHb3b1xa8Iu5TckbjXRgrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgV9MEB2yKrjHr75cN6JFxUXJuoqe+3lf9MEHSVhVtUAdPikW1eAZTq+ouC9NhGam
	 F8SfStR7Hu8c7eRgCGRnpjgQmAttUC9Sl0OtZA8aKkHSfcv6ISKO1HufWzItcUY+Ba
	 nXC/f0GWgiP21izzv3c1u1SeQZ9rhGA9VwizWJEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/590] wifi: mt76: mt7925: Enhance mt7925_mac_link_bss_add to support MLO
Date: Wed,  5 Feb 2025 14:39:02 +0100
Message-ID: <20250205134502.433623333@linuxfoundation.org>
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



