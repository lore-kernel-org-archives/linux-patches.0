Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7923372B50;
	Wed, 20 May 2026 16:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294765; cv=none; b=qsCJ1fymtSxb1K/GYKyAJ4B3U+VU5zinBTC7D3Ep0hyuYXNTkooT8yFxXM7pWh1a3JqyqnBpd5a48PGu07QYzw3vRFlklGzZUvt5Nz/mH8qcUqUCeNYLAAuz97QQkZpNlcWbFt5EOFbyRimudhxgJ8yTKYdc+FmokdYUTl33LA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294765; c=relaxed/simple;
	bh=D9/A4zvvLDKeE1/jM0qVu0ZNnul0USdaAa8UPXSluhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCxli931zxX5Et4bxWpF9bO81FGGMecIcwvVQ5CXhgrh25rhKZTEKw7GmWt1vYmdiBzLtwbWdEjVAlYQeJS486vOhWG2WqmmV5g8fX9g9dVGbaTPPDLK+g94EOQAeEQANA9qj8IgvweahrIsfVatdp+WMZvXo9TRGeM7zL8RoRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8ENcWOh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8ENcWOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0EC1F000E9;
	Wed, 20 May 2026 16:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294763;
	bh=mFZ1df2VdG+SWQ/tTf3gZ4sPigTVHJKk2n8wDnfsC7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8ENcWOhSat/CMH6PVMeJ8wnKtVhXzfGIla9X/derFmfyjoWGed1oqrSkt+BD6uJ0
	 cYB0AZQGWFL2tvJwOP/ZbsBocMgjnAU95Mv8RPttfnFAaHuNxQiCe8LFboWTq46smy
	 U9gOcafxmodem2pwIz1qOoBLLgzF8q86W2MtFz5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0126/1146] wifi: mt76: mt7996: Remove link pointer dependency in mt7996_mac_sta_remove_links()
Date: Wed, 20 May 2026 18:06:16 +0200
Message-ID: <20260520162151.179634789@linuxfoundation.org>
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

[ Upstream commit 569ce4340268915911fc356ec9ad27e92fb82289 ]

Remove link pointer dependency in mt7996_mac_sta_remove_links routine to
get the mt7996_phy pointer since the link can be already offchannel
running mt7996_mac_sta_remove_links(). Rely on __mt7996_phy routine
instead.

Fixes: 344dd6a4c919 ("wifi: mt76: mt7996: Move num_sta accounting in mt7996_mac_sta_{add,remove}_links")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260306-mt7996-deflink-lookup-link-remove-v1-1-7162b332873c@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 6b98835269353..ff3050c2344ab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1058,8 +1058,7 @@ mt7996_mac_sta_remove_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 
 	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
 		struct mt7996_sta_link *msta_link = NULL;
-		struct mt7996_vif_link *link;
-		struct mt76_phy *mphy;
+		struct mt7996_phy *phy;
 
 		msta_link = rcu_replace_pointer(msta->link[link_id], msta_link,
 						lockdep_is_held(&mdev->mutex));
@@ -1068,17 +1067,12 @@ mt7996_mac_sta_remove_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 
 		mt7996_mac_wtbl_update(dev, msta_link->wcid.idx,
 				       MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
-
 		mt7996_mac_sta_deinit_link(dev, msta_link);
-		link = mt7996_vif_link(dev, vif, link_id);
-		if (!link)
-			continue;
 
-		mphy = mt76_vif_link_phy(&link->mt76);
-		if (!mphy)
-			continue;
+		phy = __mt7996_phy(dev, msta_link->wcid.phy_idx);
+		if (phy)
+			phy->mt76->num_sta--;
 
-		mphy->num_sta--;
 		if (msta->deflink_id == link_id) {
 			msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
 			if (msta->seclink_id == link_id) {
-- 
2.53.0



