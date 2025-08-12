Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35E41A3029;
	Tue, 12 Aug 2025 19:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025772; cv=none; b=Y3/ykCuuKmM3L5s4CdzsppaLiAB7GBdED2Xw33aZj+rfrx0XJyGqGN80eKyqgzJasH4d9oDLkV7iLyalSpqVn/EYo0hZWqFFesKTFBY/tuh0GggUBrfU49Nnbu1R+xX4uADmxGr5+j7Zdlg7ZQR3ZSI4jVIZjWHSjtiLQ1TbaVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025772; c=relaxed/simple;
	bh=eg+UqTy4e4QjtKs5/vJs7JR99VptOzgE1HgUdZO/O+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QO1FTTxUwros3khJCbv1FdBgBaWFlMwMEU++C5XrScEvnfoAUF4x8RNmLURwCqptQMQ1ngBxE1wpyrk/lNYhaElKtfAw3z1OutHHxaxTOoTpLNkOaAA189ROQLx4zIZcvhhNvhV5Byj4rYCioz+qmlWBLAHOq8VoE1J9HKAsKVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=te0nJptZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="te0nJptZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC2DC4CEF0;
	Tue, 12 Aug 2025 19:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025772;
	bh=eg+UqTy4e4QjtKs5/vJs7JR99VptOzgE1HgUdZO/O+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=te0nJptZ2XHuCXMrDxJH1T+MkWIUH9y9nVuS+DamC6sUZX3V0RsJL2QcJuuLlVNvT
	 6jN5TF87TsTn1JpJiT/UNVOkh7taZxRUpy46mP0AvdawdsYmo7l3wh4sjzy/djTgeL
	 pS0SEyofEWo9ir2NaE84Dw9fZh/7BZzfv8gyPdTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 139/480] wifi: mt76: mt7996: Fix possible OOB access in mt7996_tx()
Date: Tue, 12 Aug 2025 19:45:47 +0200
Message-ID: <20250812174403.255950923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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
index 5584bea9e2a3..631ad0f9ff93 100644
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



