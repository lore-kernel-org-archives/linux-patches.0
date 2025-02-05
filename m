Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74C28634E;
	Wed,  5 Feb 2025 14:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765082; cv=none; b=qCmnD0RIKIo4A2HebDs3Z1Bi4PrggEZnE8pgaR+GGBWAcQuDa2K3I7VgnbMkT7bAsUPZBtsA6FQs0aSwrXaS+9+x0YaQxBipd8/y9y/7jiUOIxvNipTneL/bytR8qX485tDvd8nb0us2Yx8f2GAGLrHKyZs5oCT+/DDeY9Bd8Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765082; c=relaxed/simple;
	bh=/wI28X7y/QLlQL4bMHMt/Hi3HUu2RR9mqORrRZYrSPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eaTH38pUG3epojdXa7viJHIuf9jaKiOTGiyi/JJ9Fvv/T+eH/BFcEtIX1r6E9g0XMgDk1cNjO1aNE83cu6+5jItZgQ99FVoPHJDeTnOHSPEtXFNEYdRem8O02nbjUqlqvI78MfHrmFAoWBB4iLUzffvAphCZlMilQmS00o/iFow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvZzav7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvZzav7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6429C4CEE3;
	Wed,  5 Feb 2025 14:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765082;
	bh=/wI28X7y/QLlQL4bMHMt/Hi3HUu2RR9mqORrRZYrSPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvZzav7Og1pT7gKQyzBdX7qSSkn2iLjPcVbDMMneWjPilOML131caeLGXnGqyTq6W
	 yQubzg4xnMuoDDAEAZCulRTC35rNpt0CAuEcskBtqALas+NnI2774YVAJw6tGA9tX1
	 5i/K9kwKjOnqHbIm2IhEr1oRy1HcQ3vuCy/TVvJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 188/590] wifi: mt76: Enhance mt7925_mac_link_sta_add to support MLO
Date: Wed,  5 Feb 2025 14:39:03 +0100
Message-ID: <20250205134502.471647628@linuxfoundation.org>
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

[ Upstream commit e6803d39a8aa59e557402a541a97ee04b06c49b2 ]

Enhance mt7925_mac_link_sta_add to support MLO.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-9-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 3cd3c3e289e72..1140af6577937 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -878,9 +878,14 @@ static int mt7925_mac_link_sta_add(struct mt76_dev *mdev,
 	link_conf = mt792x_vif_to_bss_conf(vif, link_id);
 
 	/* should update bss info before STA add */
-	if (vif->type == NL80211_IFTYPE_STATION && !link_sta->sta->tdls)
-		mt7925_mcu_add_bss_info(&dev->phy, mconf->mt76.ctx,
-					link_conf, link_sta, false);
+	if (vif->type == NL80211_IFTYPE_STATION && !link_sta->sta->tdls) {
+		if (ieee80211_vif_is_mld(vif))
+			mt7925_mcu_add_bss_info(&dev->phy, mconf->mt76.ctx,
+						link_conf, link_sta, link_sta != mlink->pri_link);
+		else
+			mt7925_mcu_add_bss_info(&dev->phy, mconf->mt76.ctx,
+						link_conf, link_sta, false);
+	}
 
 	if (ieee80211_vif_is_mld(vif) &&
 	    link_sta == mlink->pri_link) {
-- 
2.39.5



