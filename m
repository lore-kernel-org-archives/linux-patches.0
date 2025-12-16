Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB85126C02;
	Tue, 16 Dec 2025 11:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886072; cv=none; b=a7hpXikgclxmuVg5M6RK/ynEl4HT+QInbUlhQR7+EwGlqHmpyIj/b5iH3CfRYgi+9OlNmoKK/oN7QcjMOvsYMCxCxtANKMADDmVFMaSJICe/VInKvSOm0ZX24lJp5K21OQTnhtsDQaEjYPco6XlcZ83DnY/QZlU2sPNDWoAuEHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886072; c=relaxed/simple;
	bh=LE930jp4BfutVPrYDYN4Wf2kwIVEdCpqD7lKA3W9H8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXPaEmYVt/BqMpIcc7fddegr2ySRvJLsMKTmtrfX95OTXAyprvg/D4sANQaJ4ySRnN5RQZhWIJULKB36/NA8M1C46Ku9MLlSVstwww2NwNdOcZgS6ZG8yHL/6UZJE+6reHnGA2steqAXCZbsRut68k9NSr2q4OwpMCZLw09UxN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdPXFMiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdPXFMiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593BBC4CEF1;
	Tue, 16 Dec 2025 11:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886071;
	bh=LE930jp4BfutVPrYDYN4Wf2kwIVEdCpqD7lKA3W9H8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdPXFMiKwq7qZytEcI7B6a1yYj2xAj/7UiNy3xN92zFXdx6X4bFScoxb4kGUgJHpr
	 ccn+xlfD2pLS98nEe9eOmDmsKrWRotS8560DWuHfOh77AgaM2B+fVqPp0Ke9QoMvYN
	 sysR64f2PPFjD7paDqmD1adRFMEWqkUIPTyCF+xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 330/507] wifi: mt76: mt7996: fix teardown command for an MLD peer
Date: Tue, 16 Dec 2025 12:12:51 +0100
Message-ID: <20251216111357.421177799@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit e077071e7ac48d5453072f615d51629891c5b90d ]

For an MLD peer, we only need to call the teardown command when removing
the last link, and there's no need to call mt7996_mcu_add_sta() for the
earlier links.

Fixes: c1d6dd5d03eb ("wifi: mt76: mt7996: Add mt7996_mcu_teardown_mld_sta rouine")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251106064203.1000505-6-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 016b7e02d969d..5f90a385b4d38 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1197,13 +1197,13 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 				mt7996_mac_twt_teardown_flow(dev, link,
 							     msta_link, i);
 
-			if (sta->mlo && links == BIT(link_id)) /* last link */
-				mt7996_mcu_teardown_mld_sta(dev, link,
-							    msta_link);
-			else
+			if (!sta->mlo)
 				mt7996_mcu_add_sta(dev, link_conf, link_sta,
 						   link, msta_link,
 						   CONN_STATE_DISCONNECT, false);
+			else if (sta->mlo && links == BIT(link_id)) /* last link */
+				mt7996_mcu_teardown_mld_sta(dev, link,
+							    msta_link);
 			msta_link->wcid.sta_disabled = 1;
 			msta_link->wcid.sta = 0;
 			links = links & ~BIT(link_id);
-- 
2.51.0



