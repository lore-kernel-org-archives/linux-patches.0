Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019037;
	b=uomeoy+2lzRAReBPRho+/7Qr8LJi6CQkzYzrWpXdMSF2N+d49noixjYMZLE1y1LKD8TZ
	 XMjLpXPRflQhKR/U/nw2HDmsvRYVZ2DvfLmuQXCYHvIX37XBF3M3ptfa6BCt53US2YjIQ
	 knwIuhlzYmwxdZhbvf07rTWMxSGrTw9uGZU2bN7EWVWm990zwGOftqWeLrm4IILHnoreS
	 IeuAR4q+xpjTNaTiWZhWNzCHlBHR+EpKPvgOKV/P8kdSsab98eNV9jwv69T4UxrWfBP2z
	 Wl2o31ZhMISebWxSjcC0yVeUihwODgDHif78UVn9W+WaGFJH9z3gkndCfvwCciWZsXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mMsBMt1DeXZAPJBkr9iBQeO2sAzsuzZcaikGG8zR0Dk=;
	b=ZeNRK9w2XvqUhnVFu/ADlgAiiZKqz5BbrI0OMFa2E25T724Z9NzAvwKvER5M5PUq3GmA
	 6Ha4rofup+fbh7/UzhxKSJvYTfjExi+QxHvYWtkQ0QFDZOy/VPoiW9fE2hnBxZBvM38Gq
	 62cYb64CWrNza/CxgO+KaTX0WqnsGNVipo8Q4If6XT24WoKfvk659wsIx4FVGfr6M56Wf
	 f2B2Y+PGAHhfLRgzbBrQstumqRlTK4BnGL/QzObPMyOpyFs5I9pgAMv5ov6RvWdI5v8j8
	 NARyU60ZgY3PRsADyYXh5J1uUIQkq2AILv31BRvgWn3m4Nu3z8gh1amzXwNm5y1ncag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPRld3Dy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2003606A320;
	Wed, 18 Nov 2026 16:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPRld3Dy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130F11F000C4;
	Wed, 18 Nov 2026 16:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019037;
	bh=mMsBMt1DeXZAPJBkr9iBQeO2sAzsuzZcaikGG8zR0Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPRld3DyE08dDQ40G6Yv+NUUbwakUbhU5ycDwrXGtJC3SASqOcSvq5TZdm7ACAK1H
	 RAba+IyM6WpZX8e4sCram6dDcdxDTAh7uzSJULSw9cDqk+ul+w6cZEcYbDXzd3WDKv
	 UkMezAdg0z+ecoOOZWVBSPDYB1dntiXPBDefqA/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1454/2651] wifi: mt76: mt7915: fix thermal zone use-after-free
Date: Wed, 18 Nov 2026 15:44:54 +0100
Message-ID: <20261118150340.384416894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Leung <untilscour@protonmail.com>

[ Upstream commit 9be6ee96184c3f1219f2ab023345d22268e06833 ]

The thermal zone registered via devm_thermal_of_zone_register() on the
parent device is never torn down when the phy is unregistered, so the
thermal core can still dereference it after the phy is freed.

Unregister the thermal zone alongside the cooling device in
mt7915_unregister_thermal(). Also clear phy->tzone and phy->cdev after
unregistering so the function is safe to call when only a subset of
the objects were registered, e.g. after a partially failed
mt7915_thermal_init().

While at it, include the band index in the thermal zone registration
warning to help identify which band failed on multi-band chips.

Fixes: 313f1a27ebcb ("wifi: mt76: mt7915: add thermal zone device registration")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
Link: https://patch.msgid.link/20261003-mt7915-unregister-thermal-v4-1-8ed55f6f5535@protonmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index df056e06d907d..358c45acf79b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -200,11 +200,17 @@ static void mt7915_unregister_thermal(struct mt7915_phy *phy)
 {
 	struct wiphy *wiphy = phy->mt76->hw->wiphy;
 
+	if (phy->tzone) {
+		devm_thermal_of_zone_unregister(phy->dev->mt76.dev, phy->tzone);
+		phy->tzone = NULL;
+	}
+
 	if (!phy->cdev)
 		return;
 
 	sysfs_remove_link(&wiphy->dev.kobj, "cooling_device");
 	thermal_cooling_device_unregister(phy->cdev);
+	phy->cdev = NULL;
 }
 
 static int mt7915_thermal_init(struct mt7915_phy *phy)
@@ -238,8 +244,8 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 	if (IS_ERR(phy->tzone)) {
 		if (PTR_ERR(phy->tzone) != -ENODEV)
 			dev_warn(phy->dev->mt76.dev,
-				 "failed to register thermal zone: %ld\n",
-				 PTR_ERR(phy->tzone));
+				 "failed to register thermal zone %d: %ld\n",
+				 phy->mt76->band_idx, PTR_ERR(phy->tzone));
 		phy->tzone = NULL;
 	}
 
-- 
2.53.0



