Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5F01A704B;
	Sun,  7 Sep 2025 20:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277507; cv=none; b=WSQLffAH/IpKmRdJSE9Ts2Uo9Fy5z8xDcO3C4+i1PEN6GbfLOO9OcDrp9Le5YNvCUywjRIXYGKm1bweOTenc/FQN4BC2bb88e9FgYWUwyisJ9yvAwsTAvRqRjrNxYHxx+5pkaI8t5N1Dc1U7F/F1hu6fDTJQLwY/h5T9BSxOBJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277507; c=relaxed/simple;
	bh=7DfoF6dItP0KHvvduVp1jpeKtut2C6eqKJtLEyN3meY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lShkibvKjza0K0pRjGFXrs8IZgJWl8AM9Y4rfZ0IZtddaKqszixw/ubuDeaF2TCUidWvOsVZGkXXjqF1Xo/JiGlNclOrbKMWrs7i50Wfc3zAAHHp8R46ZqLiS2GYWEwMG6jWjOAiJRuxgohSAxNlZcFkVoUaFaht27ErF4VW/n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mL9h/ie8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mL9h/ie8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D58AC4CEF0;
	Sun,  7 Sep 2025 20:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277506;
	bh=7DfoF6dItP0KHvvduVp1jpeKtut2C6eqKJtLEyN3meY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mL9h/ie8NLr+adsVjkCFXYOS5+HpkBZ2cwbKFbaFqLY53gZA+2Aa8+Fstz3vuEOte
	 cte7K/ZYQfqbfuu3O10Vz6ile0S7ABQT/fUCMZvFRAIPj/dk+YWWPqHx79iWKf1tVS
	 AQhOaWqHQug5l8FeU9/IwwtIAFtCEevuFEPjIK3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 037/183] wifi: mt76: mt7996: add missing check for rx wcid entries
Date: Sun,  7 Sep 2025 21:57:44 +0200
Message-ID: <20250907195616.656326639@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 4a522b01e368eec58d182ecc47d24f49a39e440d ]

Non-station wcid entries must not be passed to the rx functions.
In case of the global wcid entry, it could even lead to corruption in the wcid
array due to pointer being casted to struct mt7996_sta_link using container_of.

Fixes: 7464b12b7d92 ("wifi: mt76: mt7996: rework mt7996_rx_get_wcid to support MLO")
Link: https://patch.msgid.link/20250827085352.51636-3-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index b0fa051fc3094..a7a5ac8b7d265 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -62,7 +62,7 @@ static struct mt76_wcid *mt7996_rx_get_wcid(struct mt7996_dev *dev,
 	int i;
 
 	wcid = mt76_wcid_ptr(dev, idx);
-	if (!wcid)
+	if (!wcid || !wcid->sta)
 		return NULL;
 
 	if (!mt7996_band_valid(dev, band_idx))
-- 
2.50.1



