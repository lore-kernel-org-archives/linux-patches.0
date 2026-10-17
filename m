Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908B337F01B;
	Sat, 17 Oct 2026 18:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260150; cv=none; b=R1oPk5ghSDLQRo+FO3HJ2cyUUHIaCxVBWtFkTvsNQ5owusd6lL2CCAynMvgc8fsS8eeT5IkAjC475NSTyXAW+LYlBS0ETBM9m6mvz6O2cUuNxdxDoUHhsis6I1jcUl+F2EJJ10wkqYCASx26K63k/75ZwE8TIflbmLnnqOAEOao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260150; c=relaxed/simple;
	bh=tn1ksC3+npcemsC+qECZDDeLNixyjKFP64MD9nZn7KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ypdvk887IyZqbntMmE4jqqgMtsnbQCu+e171vhQGPo/xs/rCug4t7Ecx3ngHCXlFdfSvjS6aeeJu9LJaBMBkD7BcACDvBNtAUYPhyvpOGUMo/Z3UKppREBYqI0dFLwfis9ihNEn/MKgA2ElXxJ+XQiYX53oqJzorcctSrQJmfxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MiUgMdRc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MiUgMdRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956D81F000C4;
	Sat, 17 Oct 2026 18:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260149;
	bh=ArgukiEml0mtBoC/bONgLW7728lSRPHJe4RYvPiLys0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MiUgMdRcNwKKjbHiVxz61h0/EgmO6CE7cKxSsH9lPjDdZUFwvOqagH6YPC0Nsgnwu
	 7y+Y9lvpxjLZLPjBil7W3/Wo82YynzixR/n/JzC/YOpvBYPw5dPzyepgf9jsIUfjtX
	 2t5Mfl1kaNPUj9gDqXYZgru9heQTxBlAfH8UAF0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1448/1674] wifi: mt76: mt7915: allocate vif wcid in the same range as stations
Date: Sat, 17 Oct 2026 18:02:00 +0200
Message-ID: <20261017160508.349277810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit f3049b88b2b32326df97461813ae73e8bbc296fc ]

Reduces the amount of unnecessary WTBL bank switching, while still reserving
WTBL entries for vifs.

Link: https://patch.msgid.link/20240827093011.18621-8-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 2fb6480c52f6 ("wifi: mt76: mt7915: unwind state on add_interface failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 19355a11e0c77..22875dc94b5b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -245,7 +245,9 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	dev->mt76.vif_mask |= BIT_ULL(mvif->mt76.idx);
 	phy->omac_mask |= BIT_ULL(mvif->mt76.omac_idx);
 
-	idx = MT7915_WTBL_RESERVED - mvif->mt76.idx;
+	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, mt7915_wtbl_size(dev));
+	if (idx < 0)
+		return -ENOSPC;
 
 	INIT_LIST_HEAD(&mvif->sta.rc_list);
 	INIT_LIST_HEAD(&mvif->sta.wcid.poll_list);
@@ -292,6 +294,7 @@ static void mt7915_remove_interface(struct ieee80211_hw *hw,
 
 	mt7915_mcu_add_bss_info(phy, vif, false);
 	mt7915_mcu_add_sta(dev, vif, NULL, false);
+	mt76_wcid_mask_clear(dev->mt76.wcid_mask, mvif->sta.wcid.idx);
 
 	mutex_lock(&dev->mt76.mutex);
 	mt76_testmode_reset(phy->mt76, true);
-- 
2.53.0



