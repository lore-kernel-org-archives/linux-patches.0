Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31562C026C;
	Sat, 17 Oct 2026 16:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254245; cv=none; b=g7J2CQwcASdrJwdDea1uVi/kW0AhSWNPt7JFmMYK6j9zBP8n6omlGxYUyRF7S/HcOndqDuVsT8Cq/tTy3gMCxJf6gfwWE+3woi8g4awd7cHGJTRi3v22J9RT+TEa35loJ7nWrpCMFh3nFXRDpx94ZFBABrK2xC1ToWGAqsYmSpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254245; c=relaxed/simple;
	bh=4BEW61WZ0xDf1oZjX22aaxGZWAjXqbyuL0bj7Sni2Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0QGo4La285lbB/Ea8heR8rvgjpfmNWUSuUFT03fQHtgq+/UVpOeoDI3k1GjPRh4L5CrqAEkdDNg4wBE0s+fv2japOT9kaJzjsVEzh9bWz4yXMdSXr4FzatPgZLMr26y/cIAVVUY3qVFxfieKYZYqooLxQGcTW/sHeEuymazaYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6rWLeGa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6rWLeGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1381F000C4;
	Sat, 17 Oct 2026 16:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254243;
	bh=DDdZNfCxXrV+wgvnM21GmozyVBp9KF709zqAem0qcZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b6rWLeGaBpxFaPkAzqMXqU264P5qpzyB/241F8PqxxGMMxqPil+CDCzksUkjm40Ws
	 bW/NVAuBc/ETgOb2TPIYT+ZWekP/3CMcNtlhZ0XkXmiITZ1zI/RcfcFRnR3zl/sFb4
	 K5iCdnoCNgv3J1adAW589m+XjUaKiBi2/DIBEeNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiajia Liu <liujiajia@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 342/869] wifi: mt76: add wcid publish check in mt76_sta_add
Date: Sat, 17 Oct 2026 17:53:03 +0200
Message-ID: <20261017160045.850815128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiajia Liu <liujiajia@kylinos.cn>

[ Upstream commit 20b126920a259df4d7dcae19fcfe2c57a74d6b2e ]

Since mt7925_mac_sta_add publishes wcid, add publish check in mt76_sta_add
to avoid reinitializing the wcid->poll_list.

Found dev->sta_poll_list corruption when using mt7925 and 7.1-rc4.
According to the corruption information, prev->next was changed to itself.

wlan0: disconnect from AP 90:fb:5d:94:8b:e3 for new auth to 90:fb:5d:94:8b:e2
wlan0: authenticate with 90:fb:5d:94:8b:e2 (local address=84:9e:56:9c:7e:6b)
wlan0: send auth to 90:fb:5d:94:8b:e2 (try 1/3)
 slab kmalloc-8k start ffff8c80958a6000 pointer offset 4160 size 8192
list_add corruption. prev->next should be next (ffff8c808a7488f8), but was ffff8c80958a7040. (prev=ffff8c80958a7040).

 mt76_wcid_add_poll+0x95/0xd0 [mt76]
 mt7925_mac_add_txs.part.0+0xa5/0xe0 [mt7925_common]
 mt7925_rx_check+0xa7/0xc0 [mt7925_common]
 mt76_dma_rx_poll+0x50d/0x790 [mt76]
 mt792x_poll_rx+0x52/0xe0 [mt792x_lib]

Signed-off-by: Jiajia Liu <liujiajia@kylinos.cn>
Link: https://patch.msgid.link/20260528033814.46418-1-liujiajia@kylinos.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 22 ++++++++++++++-----
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index ca1f7b2991c51..cd02dff7ab347 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1486,6 +1486,7 @@ mt76_sta_add(struct mt76_phy *phy, struct ieee80211_vif *vif,
 {
 	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
 	struct mt76_dev *dev = phy->dev;
+	struct mt76_wcid *published;
 	int ret;
 	int i;
 
@@ -1505,13 +1506,22 @@ mt76_sta_add(struct mt76_phy *phy, struct ieee80211_vif *vif,
 		mtxq->wcid = wcid->idx;
 	}
 
-	ewma_signal_init(&wcid->rssi);
-	if (phy->band_idx == MT_BAND1)
-		mt76_wcid_mask_set(dev->wcid_phy_mask, wcid->idx);
-	wcid->phy_idx = phy->band_idx;
-	rcu_assign_pointer(dev->wcid[wcid->idx], wcid);
+	published = rcu_dereference_protected(dev->wcid[wcid->idx],
+					      lockdep_is_held(&dev->mutex));
+	if (published != wcid) {
+		WARN_ON_ONCE(published);
+		ewma_signal_init(&wcid->rssi);
+		if (phy->band_idx == MT_BAND1)
+			mt76_wcid_mask_set(dev->wcid_phy_mask, wcid->idx);
+		wcid->phy_idx = phy->band_idx;
+		rcu_assign_pointer(dev->wcid[wcid->idx], wcid);
+		mt76_wcid_init(wcid);
+	} else {
+		if (phy->band_idx == MT_BAND1)
+			mt76_wcid_mask_set(dev->wcid_phy_mask, wcid->idx);
+		wcid->phy_idx = phy->band_idx;
+	}
 
-	mt76_wcid_init(wcid);
 out:
 	mutex_unlock(&dev->mutex);
 
-- 
2.53.0



