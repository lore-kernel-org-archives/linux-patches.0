Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3AE15573F;
	Wed,  5 Feb 2025 14:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765116; cv=none; b=j/ttIlaUAjzOCle1To+dlZ/XmlyquNdBRlw8ga9SzpGoYAO/HhLW0jKEj3zpDagEcDLgwMWpeJGrx3R1uyC16rYGl0Rf/zmKOCQvTWn8Ljzh6p4LBK3y2nW5vKQNZZ6xp7Y2CjIm/6um89RJPPSDHnCqYpIuTD/pg6uiXGckW0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765116; c=relaxed/simple;
	bh=QVKMxVNmPXwRqNInhnMniW4EmgNEZiZOJxlz3IXSbpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXYJfhyHeowk7nCt7VwgLCqITUSnUhOJ+qKsKobFd7/a2rrHbTZrsR8dvHndo71yromk2V2VpKNl90AlM34xJJ19sB42CqqbHlNfh8rytcforboOan/pCFzccSya3qPMRge72IeidRiOOQd3mGZBN0/LoY/nN2AODp7reg5i6A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b06Gfigi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b06Gfigi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC5FC4CED1;
	Wed,  5 Feb 2025 14:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765116;
	bh=QVKMxVNmPXwRqNInhnMniW4EmgNEZiZOJxlz3IXSbpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b06GfigiBzXVwJ2y98qKZrr3jfxviDGhobLuMthh3b4KXcJP2LTeWe62xU8gzWrQJ
	 U9S90TTWDX/3/BqGUAUh3yt7ZakOfYW/PTEVBJC5yag3O7Sk+LQm5VxWgCJmDDqYPa
	 uDNphP+3ZEuA5qEm0RLd9tbAMISuQsHVW7L1DqpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 191/590] wifi: mt76: mt7925: Update mt7925_unassign_vif_chanctx for per-link BSS
Date: Wed,  5 Feb 2025 14:39:06 +0100
Message-ID: <20250205134502.586536936@linuxfoundation.org>
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

[ Upstream commit 30b721467c9c2510e26af6e78e92d7cc08a14bc4 ]

Update mt7925_unassign_vif_chanctx to support per-link BSS.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-12-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 1140af6577937..a78aae7d10886 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2081,18 +2081,16 @@ static void mt7925_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	struct mt792x_chanctx *mctx = (struct mt792x_chanctx *)ctx->drv_priv;
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
-	struct ieee80211_bss_conf *pri_link_conf;
 	struct mt792x_bss_conf *mconf;
 
 	mutex_lock(&dev->mt76.mutex);
 
 	if (ieee80211_vif_is_mld(vif)) {
 		mconf = mt792x_vif_to_link(mvif, link_conf->link_id);
-		pri_link_conf = mt792x_vif_to_bss_conf(vif, mvif->deflink_id);
 
 		if (vif->type == NL80211_IFTYPE_STATION &&
 		    mconf == &mvif->bss_conf)
-			mt7925_mcu_add_bss_info(&dev->phy, NULL, pri_link_conf,
+			mt7925_mcu_add_bss_info(&dev->phy, NULL, link_conf,
 						NULL, false);
 	} else {
 		mconf = &mvif->bss_conf;
-- 
2.39.5



