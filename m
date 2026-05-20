Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41CE2DC76C;
	Wed, 20 May 2026 17:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297705; cv=none; b=HKXybP67UCTAfsJp0d2ApV3sjgBSHugWWQSSx23SaafnPIq1bRBOOZN0yNYcOorLQwFwQ3qdvjfjK64JdBqVaNV0TJPiQENymXuW/m62uQgiJTwymv6AnsOKmQaOYwY1TYbegUM6wdzbsY2rITcTLWuDwq/VPg9Kg2CV/Qw0bwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297705; c=relaxed/simple;
	bh=FNYSJX8yrZLsYPPZrkHRNKurLEf9TUoETDh/pC5oKDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYi0b6waZrkJ+1kWhcxCzBaW1eFVf61K9IIrrvl2nJUqw/fpJRmcdM5wu8IP9Vv8x8ZXtm3v0n3eWHMzlOxFaJrh+HqHKN0Ukwnnt6xpDA9cIGXVBrOFPcNIm6b6qB0RGcMNx3J9Rv+wng5+cry6ZRfG+aSW8TAgZiG5Ad9KM7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcViCEIf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcViCEIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561CC1F000E9;
	Wed, 20 May 2026 17:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297703;
	bh=fAKB62YEQ7vfwFGGB8dUbni83/RZrYKqJhpb863dYYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wcViCEIfzdiqE7EgdXq7DsxR/hk+EIR76HrkX2Ro4HM9njzF7ZClAEYut4r8+DjRC
	 mIMvzZV7L17xbi+NjPQMeqdibd2U4u3Ray4gkXb/VVMUbcpxf0FYbS6FOeEr4SSjHJ
	 jpdkOiJjjfc+bwQbwlrWBtHNUKk8fwAHpKgz5C+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 090/957] wifi: mt76: mt7925: drop puncturing handling from BSS change path
Date: Wed, 20 May 2026 18:09:33 +0200
Message-ID: <20260520162136.512191589@linuxfoundation.org>
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
index f503e861a7e63..ebb746f4072de 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1912,10 +1912,8 @@ static void mt7925_link_info_changed(struct ieee80211_hw *hw,
 	struct mt792x_phy *phy = mt792x_hw_phy(hw);
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
 	struct mt792x_bss_conf *mconf;
-	struct ieee80211_bss_conf *link_conf;
 
 	mconf = mt792x_vif_to_link(mvif, info->link_id);
-	link_conf = mt792x_vif_to_bss_conf(vif, mconf->link_id);
 
 	mt792x_mutex_acquire(dev);
 
@@ -1957,10 +1955,6 @@ static void mt7925_link_info_changed(struct ieee80211_hw *hw,
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



