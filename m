Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6555D2F5481;
	Tue, 12 Aug 2025 18:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023797; cv=none; b=IRGRMpRs3T8OTSSBtB7jFAeKFSLAFgYtUnXrdxJiWb539St6LLPYW0ect0/oqD+iCc1TUTCBhZG8vUJuoLpns3oOotdHAa35VAlv78zhyZgZZpz5DXpdmHsR/vuGAXkYNk3jhWe5IemvQOo5HSU4sfMm4Nlx4Dta/NErG8PyUzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023797; c=relaxed/simple;
	bh=D2DujF2dcbfx834i7vjK9d3nl41j9GjFVOWkG1cti8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2ki/U6HSrvOsy9Hm+sN3JQ9k2EScnQkQsv7fx99mrBeaCKCImgCo3pInouteZc5bTFP4WM+V05aCv0eKisNs22T7XyUmjh8xrNMAW53uNq7GFQ6g9ICDcqDhlIwipKZb2Cjf6spqiQGieZGOhWd2liMQNZveqhmAs0uRsvKxzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnYcsfDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnYcsfDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85EBC4CEF0;
	Tue, 12 Aug 2025 18:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023797;
	bh=D2DujF2dcbfx834i7vjK9d3nl41j9GjFVOWkG1cti8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnYcsfDe8Hepzu0J8+tDKo+Mq6RDoBQKBglubcEtvwo2eU5lfJg0ObtEN7Y+ryr75
	 oqBV9RGpSnXFwlKEzGvUPRJ6z2RF8tMyrBvAp/sp3FKoeuX/+0fZXDjeLzkZx+IP18
	 gmyM6C2NQbPiWcRc2ozI7pGikKuDt6oQiT6inw/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 185/627] wifi: mt76: mt7996: Fix possible OOB access in mt7996_tx()
Date: Tue, 12 Aug 2025 19:28:00 +0200
Message-ID: <20250812173426.318154838@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 64cbf0d7ce9afe20666da90ec6ecaec6ba5ac64b ]

Fis possible Out-Of-Boundary access in mt7996_tx routine if link_id is
set to IEEE80211_LINK_UNSPECIFIED

Fixes: 3ce8acb86b661 ("wifi: mt76: mt7996: Update mt7996_tx to MLO support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250704-mt7996-mlo-fixes-v1-6-356456c73f43@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c    | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 07dd75ce94a5..44b4e48e499d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1216,10 +1216,17 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 
 	if (vif) {
 		struct mt7996_vif *mvif = (void *)vif->drv_priv;
-		struct mt76_vif_link *mlink;
+		struct mt76_vif_link *mlink = &mvif->deflink.mt76;
 
-		mlink = rcu_dereference(mvif->mt76.link[link_id]);
-		if (mlink && mlink->wcid)
+		if (link_id < IEEE80211_LINK_UNSPECIFIED)
+			mlink = rcu_dereference(mvif->mt76.link[link_id]);
+
+		if (!mlink) {
+			ieee80211_free_txskb(hw, skb);
+			goto unlock;
+		}
+
+		if (mlink->wcid)
 			wcid = mlink->wcid;
 
 		if (mvif->mt76.roc_phy &&
@@ -1228,7 +1235,7 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 			if (mphy->roc_link)
 				wcid = mphy->roc_link->wcid;
 		} else {
-			mphy = mt76_vif_link_phy(&mvif->deflink.mt76);
+			mphy = mt76_vif_link_phy(mlink);
 		}
 	}
 
@@ -1237,7 +1244,7 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 		goto unlock;
 	}
 
-	if (control->sta) {
+	if (control->sta && link_id < IEEE80211_LINK_UNSPECIFIED) {
 		struct mt7996_sta *msta = (void *)control->sta->drv_priv;
 		struct mt7996_sta_link *msta_link;
 
-- 
2.39.5



