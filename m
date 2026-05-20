Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B05C3630AD;
	Wed, 20 May 2026 16:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294583; cv=none; b=K31AlRjjlwwtjp1uyExkIFqDLQ5gEjLgvjjWfYZwiHxTHAHyKtF0mpLCGu6dJdg0DrCqgERkbP9s0cbk6uugwX7tqGxuiCJb0+B6MgIjagMifiTjNWjVxTCT7uuV0osn6VaKS4IqCglTnjMv0diI3IUTgOoy5XyNGpS1tLH6Xeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294583; c=relaxed/simple;
	bh=NKCj2tXYMvwfodfMH8pGllv6WSdPBL6otoTp3+nYcaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9ame+rwX4fRT8jtfkXHhXmrPvOkD51PbeMWyIL4kxSmsAGDO0749u1o1AdnLTN4we/S1JxyuTzO7bKAvyzBUAf7pNNKCRP2N25GQq9xbvQA5cuqY4xC8UZMMJzyqg0CcbfraaLoNVMWHQ66ynEefpfucUtmwI3+UaSHfAoMk+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhgyyoCI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhgyyoCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1DC1F000E9;
	Wed, 20 May 2026 16:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294582;
	bh=3ZqQP/E2cmLgQOoTCeybVSvFqL877gsnN04/TUjbC+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vhgyyoCIEtaSW4+PpYUXnEsAjPdrKBXuwKiUqKCE6UoIIfYzQ3tsTlOKUDcaAPuw9
	 GPQ5kOVesOItujha7AbyEDDZRK7g4weK/ZjYkbyDxJUE39P/6pM+53d+hVxwrWaf3s
	 lJHI2UYMlSXHGbaDCAfLaK6/F/Obxc+rySf21YA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0095/1146] wifi: mt76: mt7996: Set mtxq->wcid just for primary link
Date: Wed, 20 May 2026 18:05:45 +0200
Message-ID: <20260520162150.499090165@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 654abcbe4528f74428b69292fad5c4224414fa1b ]

Set WCID index in mt76_txq struct just for the primary link in
mt7996_vif_link_add routine.

Fixes: 69d54ce7491d0 ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251205-mt76-txq-wicd-fix-v2-1-f19ba48af7c1@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index dfac3b9b28fe9..d75f48c61ce0f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -301,7 +301,6 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 		.cmd = SET_KEY,
 		.link_id = link_conf->link_id,
 	};
-	struct mt76_txq *mtxq;
 	int mld_idx, idx, ret;
 
 	mlink->idx = __ffs64(~dev->mt76.vif_mask);
@@ -344,11 +343,6 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 	mt7996_mac_wtbl_update(dev, idx,
 			       MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
 
-	if (vif->txq) {
-		mtxq = (struct mt76_txq *)vif->txq->drv_priv;
-		mtxq->wcid = idx;
-	}
-
 	if (vif->type != NL80211_IFTYPE_AP &&
 	    (!mlink->omac_idx || mlink->omac_idx > 3))
 		vif->offload_flags = 0;
@@ -371,9 +365,13 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 
 	ieee80211_iter_keys(mphy->hw, vif, mt7996_key_iter, &it);
 
-	if (!mlink->wcid->offchannel &&
-	    mvif->mt76.deflink_id == IEEE80211_LINK_UNSPECIFIED)
+	if (vif->txq && !mlink->wcid->offchannel &&
+	    mvif->mt76.deflink_id == IEEE80211_LINK_UNSPECIFIED) {
+		struct mt76_txq *mtxq = (struct mt76_txq *)vif->txq->drv_priv;
+
 		mvif->mt76.deflink_id = link_conf->link_id;
+		mtxq->wcid = idx;
+	}
 
 	return 0;
 }
-- 
2.53.0



