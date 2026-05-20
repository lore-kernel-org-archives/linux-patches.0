Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B70435AC18;
	Wed, 20 May 2026 17:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297620; cv=none; b=KCCCiwgUR1lxhW4WF/89C8775e+ZNMeP1qBVbaBn9KYEl8tktoh6VIutcKT5p9hwcp8xAIeuXwikP3RbwkGyaGfvWIYbRuugxUn7Ngh4cqav50xafGZC1BGv4hq9wqfjuUhcVOKQOwJPhgZspS6tVI405NNcBTqlYTm4HJ1Hrnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297620; c=relaxed/simple;
	bh=xcjUjgIOc1SH4wHOQpWcxc6UOyszkDvlTS+nw5JcFQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T81SHMcSiYVN8jUovKjcg3nxnNT58x/bmBH858cWyR5NB1HmRq3zao9PDn6JA0t0mbs+uRwU9I/ui79eGZnsDuP4wjf1ZgnM1IOb8431Ts6J2lrOsLuVAv23VXdCANSittzDeYN7FXBfh/UK17jjHSIHj3Vso4r2CeB4SLOnBdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbX9oNnp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbX9oNnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02001F00893;
	Wed, 20 May 2026 17:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297619;
	bh=x5n2CmBf8QMjoKn2ij9krTFoXqmR8AAWVai9ycaY+64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pbX9oNnpbwfK85it801AGMrpuG2mCGhvubHn4U8tVXH7MJhnUn1xDMI8X3R5vhXiw
	 qOmadJ/Xe1loDaWBozzGkCo21Y/pFyqQ+2OhvgJdC3QOk7Avc6ldud+7avDLN5Ll6x
	 ARVfHHgMUc1c5Mga1z0JSGYOUWw7f8foROOUieog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 101/957] wifi: mt76: mt7996: Remove link pointer dependency in mt7996_mac_sta_remove_links()
Date: Wed, 20 May 2026 18:09:44 +0200
Message-ID: <20260520162136.751207369@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 589b228a4eb0c..32d44540605fc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1047,8 +1047,7 @@ mt7996_mac_sta_remove_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 
 	for_each_set_bit(link_id, &links, IEEE80211_MLD_MAX_NUM_LINKS) {
 		struct mt7996_sta_link *msta_link = NULL;
-		struct mt7996_vif_link *link;
-		struct mt76_phy *mphy;
+		struct mt7996_phy *phy;
 
 		msta_link = rcu_replace_pointer(msta->link[link_id], msta_link,
 						lockdep_is_held(&mdev->mutex));
@@ -1057,17 +1056,12 @@ mt7996_mac_sta_remove_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 
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
 			continue;
-- 
2.53.0



