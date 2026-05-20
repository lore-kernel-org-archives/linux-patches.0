Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4062366065;
	Wed, 20 May 2026 16:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294630; cv=none; b=m31ydiS5GdZjI3yOyWuv0nea52Dx8v2qF47HZ6mZmI+SiFQHo8spYj8qWk20w9suMd8KDSqgctzLzEPYWfw2WQavKV8O7O9couiJbtZGkWkWAUl6VE+d1aKB964oJSnU7h0BFbti6XgEPiU/AOhS86Rm3ZkBqAkc8GoWjmCWjP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294630; c=relaxed/simple;
	bh=45usnLQ3XNM+bqkMXYGSk9ctG+vSVAB+zpyiPOJgsI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RbGEL0IERTZCRQ2J8d30toRbUl+NrV5ICVxkYR29vcjErraUGQNNkk4lCOWzwlEIGhRGWIOPPcbUb5+us+hf8oDRe1iCHyhdcVKyqe3l87Is7hrnT0W0Qfxh9znaZqUNPilvnGGwYhQCy+EvFO9CQGOem1Tb3akJifAymNkjiCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAunwCpZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAunwCpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B171F000E9;
	Wed, 20 May 2026 16:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294629;
	bh=lCrccU87wLcdVlBe3n0bDsU/xIW83VaK9qSUp2QEXcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yAunwCpZQ+JsZB29CTkZpXowlH0KE/AUysh47VKEP4tpujDWJpfTHXO02RjsUi45O
	 nQzn3u8Dyn9l+wZlPuvi+Q1TSVROzq3BVH8ruH3F/wWwqxR4xp0mxMlLHTbwbv08ND
	 sgZ2aAILEAUL5QWL8sUNeMnhBqKmtzmHO3eJtadg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0111/1146] wifi: mt76: mt7925: drop puncturing handling from BSS change path
Date: Wed, 20 May 2026 18:06:01 +0200
Message-ID: <20260520162150.850427024@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 59a1864509d084a4b34117e693951c06b846b00a ]

IEEE80211_CHANCTX_CHANGE_PUNCTURING is a channel context change
flag and should not be checked in the BSS change handler, where
the changed mask represents enum ieee80211_bss_change.

Remove the puncturing handling from the BSS path and rely on
mt7925_change_chanctx() to update puncturing configuration.

Fixes: cadebdad959b ("wifi: mt76: mt7925: add EHT preamble puncturing")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20251216022017.23870-1-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index d99a60ae063e8..3d622c066ac76 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1894,10 +1894,8 @@ static void mt7925_link_info_changed(struct ieee80211_hw *hw,
 	struct mt792x_phy *phy = mt792x_hw_phy(hw);
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
 	struct mt792x_bss_conf *mconf;
-	struct ieee80211_bss_conf *link_conf;
 
 	mconf = mt792x_vif_to_link(mvif, info->link_id);
-	link_conf = mt792x_vif_to_bss_conf(vif, mconf->link_id);
 
 	mt792x_mutex_acquire(dev);
 
@@ -1939,10 +1937,6 @@ static void mt7925_link_info_changed(struct ieee80211_hw *hw,
 		mvif->mlo_pm_state = MT792x_MLO_CHANGED_PS;
 	}
 
-	if (changed & IEEE80211_CHANCTX_CHANGE_PUNCTURING)
-		mt7925_mcu_set_eht_pp(mvif->phy->mt76, &mconf->mt76,
-				      link_conf, NULL);
-
 	if (changed & BSS_CHANGED_CQM)
 		mt7925_mcu_set_rssimonitor(dev, vif);
 
-- 
2.53.0



