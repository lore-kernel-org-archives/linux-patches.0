Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726D336CDF8;
	Tue, 16 Dec 2025 12:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887989; cv=none; b=TvmO2soIDV/LWbHVxMk2ZmH+axBwvhdFfd9sifSKBbAA4QRU5r92w9kRTQjZKX3ONL9uBsG2fxbU8HnbtkWLebsLm4xm2j5ahL4rOjTZAllyszL9ujNCrGKrArN1E7YHUeHGJFhru7cuAvGtKqbzze6nrJt7xC23/vB3IzvaLfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887989; c=relaxed/simple;
	bh=DCsgb2BFvohP9pppSZ3/eSsFrsSlf2R92NKWduE68Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUBozl4XYI7AmzZD6eyPyxDJ+ipM+cPGwIrwu33UOMCzMWuuP1BMZmQqC+CI9SSjHB0879Gqnp32Bh/d3eMuhMwFotlLpEUNRMif/Ag/cBvoeZFTyYDOEE24/5ZSxyabQFOILcJKDN9rxlH2hoEOSaH3Hw7ESxiwCjQXPg9MVDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1466BFM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1466BFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A8EC16AAE;
	Tue, 16 Dec 2025 12:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887989;
	bh=DCsgb2BFvohP9pppSZ3/eSsFrsSlf2R92NKWduE68Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1466BFMnXco899+WlRrztlseKGpVZRPIzZJn44I52hse9IfeulCZ1KiXJQmUQ1jE
	 aCvs0bj7GucXzeFXZSrerB2pM4MD9AlSRuPIfu7NpGUpu7oWw4lmgldC1Q7zcdKMse
	 3Ty3Vl3+c9/bbcQiulU6sGFRpkkUg3ObJwp0KXFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 399/614] wifi: mt76: mt7996: skip deflink accounting for offchannel links
Date: Tue, 16 Dec 2025 12:12:46 +0100
Message-ID: <20251216111415.830395669@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

[ Upstream commit 4fe823b9ee0317b04ddc6d9e00fea892498aa0f2 ]

Do not take into account offchannel links for deflink accounting.

Fixes: a3316d2fc669f ("wifi: mt76: mt7996: set vif default link_id adding/removing vif links")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Tested-by: Ben Greear <greearb@candelatech.com>
Link: https://patch.msgid.link/20251114-mt76-fix-missing-mtx-v1-4-259ebf11f654@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index ead56ce4c0362..5ff7ab596f88c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -370,7 +370,8 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 
 	ieee80211_iter_keys(mphy->hw, vif, mt7996_key_iter, &it);
 
-	if (mvif->mt76.deflink_id == IEEE80211_LINK_UNSPECIFIED)
+	if (!mlink->wcid->offchannel &&
+	    mvif->mt76.deflink_id == IEEE80211_LINK_UNSPECIFIED)
 		mvif->mt76.deflink_id = link_conf->link_id;
 
 	return 0;
@@ -401,7 +402,8 @@ void mt7996_vif_link_remove(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 
 	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
 
-	if (mvif->mt76.deflink_id == link_conf->link_id) {
+	if (!mlink->wcid->offchannel &&
+	    mvif->mt76.deflink_id == link_conf->link_id) {
 		struct ieee80211_bss_conf *iter;
 		unsigned int link_id;
 
-- 
2.51.0



