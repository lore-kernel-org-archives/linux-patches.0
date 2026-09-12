Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03D43859E6;
	Sat, 12 Sep 2026 08:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201053; cv=none; b=FoHXC0rusQv4c33sb4q52ZXoNhlpiUFgWAEP1UbRgSYqQplNLdOGiE+p8cM7PHawtptXeHWkpcvx34qP9crneipfqgiN2sgWk2PsoQq/p186XQsx2jsC1NGYMEmvARjJPulUjrXlcyXZGFUrH2iuxWzqDRKqab3qxYxmHkz53sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201053; c=relaxed/simple;
	bh=s/R3EC8wrSvloQED0BT2JUgzOXEAL/YJi8/L3sERn14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWZ2P+vfZ3ql9Xe/rN8OKsTGNc4hgm73hKXwFkLByGcCoQP04XHGNJrJuCZUqAE/muh4kp3O0iB6faAAt3Pp2WYRBF0CZ4BQbwnvS6PMcnMRIjZRXlx+CnHcoBKIO8TkV9MNNkvErlSlPprGKtHTvdXPbtPxkmi3SPMiYWtyjXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0pmYGHG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0pmYGHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501A91F000FF;
	Sat, 12 Sep 2026 08:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201052;
	bh=xRe3dzlkY30z6mWngL6t+tN3pzaci86yxOe7LI1N7pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0pmYGHGvjT3ycRYTmufioz8/MeyPDvC/shURUYV2wh8PfeDgqiQn4TgaPgJBmdrR
	 ll7zoAcXeaPJSSQJQpmKFSGc/WoAOXdlH4pp+Mz7+cB9aZHt6BS+n2BVBjydHcrB9s
	 Nauk0IPe32Ju6ZXRjw0zWFQ+yki2Fh5AMFauPg+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad@monroe.io>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0874/1815] wifi: mt76: mt7996: fix non-MLD station num_sta leak
Date: Sat, 12 Sep 2026 08:43:44 +0200
Message-ID: <20260912065709.440367512@linuxfoundation.org>
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

From: Chad Monroe <chad@monroe.io>

[ Upstream commit 2087f029924b75324cfa9a41ba1a349a9620f06e ]

The MLO link-reconfiguration rework moved the per-phy num_sta
decrement inside a link_valid guard. link_valid is only set for
MLO links, but num_sta is incremented for every station link,
including the non-MLO deflink. Non-MLO stations bump num_sta
on association and never drop it on removal.

A non-zero num_sta forces connected-mode off-channel scanning which
prevents the directed probe exchange needed to find hidden APs.

Decrement phy->num_sta on the actual link teardown, pairing it with
the unconditional increment on link creation.

Fixes: e8c819df0243 ("wifi: mt76: mt7996: Destroy active sta links in mt7996_mac_sta_remove()")
Signed-off-by: Chad Monroe <chad@monroe.io>
Link: https://patch.msgid.link/20260721185333.2419297-2-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index afbcc8c7b18b2..574aeac286ccb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1202,15 +1202,9 @@ void mt7996_mac_sta_remove_link(struct mt7996_dev *dev,
 	mt76_wcid_cleanup(&dev->mt76, &msta_link->wcid);
 
 	if (msta_link->wcid.link_valid) {
-		struct mt7996_phy *phy;
-
 		mt7996_mac_wtbl_update(dev, msta_link->wcid.idx,
 				       MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
 
-		phy = __mt7996_phy(dev, msta_link->wcid.phy_idx);
-		if (phy)
-			phy->mt76->num_sta--;
-
 		if (msta->deflink_id == link_id) {
 			msta->deflink_id = IEEE80211_LINK_UNSPECIFIED;
 			if (msta->seclink_id == link_id) {
@@ -1236,6 +1230,12 @@ void mt7996_mac_sta_remove_link(struct mt7996_dev *dev,
 	}
 
 	if (flush) {
+		struct mt7996_phy *phy =
+			__mt7996_phy(dev, msta_link->wcid.phy_idx);
+
+		if (phy)
+			phy->mt76->num_sta--;
+
 		rcu_assign_pointer(msta->link[link_id], NULL);
 		rcu_assign_pointer(dev->mt76.wcid[msta_link->wcid.idx], NULL);
 		mt76_wcid_mask_clear(dev->mt76.wcid_mask, msta_link->wcid.idx);
-- 
2.53.0



