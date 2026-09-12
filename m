Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B834519D8BC;
	Sat, 12 Sep 2026 10:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209497; cv=none; b=PJo2X59GX5olQ1O1Yi4vgH8Q1UvOihzFe910CaEggKLipIv4/0FUFA1HWzglpoNSaAFQBjh+LWKYmxd6aBzIday9Zj4wNrldkXnUp6NKUcSziE4M76WS6ttiZj9FwkYFnw2dm4B0Rb99WNyQUtno6rlYMoN6hd0UrLezmlEpuFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209497; c=relaxed/simple;
	bh=fvrEQaEA+xe93oqr2ibUM5Ka/YLFd/YTttGGJW4Aox8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZW78a7vy4zS6awlLYbcfWwpZc0RUvsLqg5NOXoxC8AXPWp3EMuGSs9rKb13InfSC6Dyio+1AaLtgK/tcb/5RnNaID67s9R1sIQtR/YtUsr8X+x2jTQiwvoNHEJGw3Laa8SC695we9O3j5qeGtIrysLQ1FeYTsdtQ6+z4DV4S5Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUDcQswM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUDcQswM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12181F000FF;
	Sat, 12 Sep 2026 10:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209493;
	bh=/7aCPXb348r6k05WsHQ1CAw/BG1mxXGUym8OkwfLaQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUDcQswMD/i4YnKZYZrqY2e9gCIMv54bPIkcR+WdVYYMsAaSCoNzdMJLqnWZ9Ja05
	 scFPXZwjwL47CpNhxs4z4eyposMuNmyhtFfEyfUd2MbrbiebiUwBwpemd4f4C2yb/Q
	 s/6IU8CP5ASaKFmsE/IXJApfU5Uzi9WPDf9EPPMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0789/1518] wifi: mt76: mt7996: skip key upload when adding an offchannel link
Date: Sat, 12 Sep 2026 08:49:18 +0200
Message-ID: <20260912065641.283343872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit ccb4bda277999959bc852480d8684b13b926e657 ]

No hw keys are ever uploaded for scanning/roc links and the link remove
path already skips the key iteration for them. The add path still runs
it, and since mt7996_set_hw_key() resolves the target through
mvif->link[link_id] rather than the offchannel link, starting a scan on
another band re-uploads the group keys of the link sharing the same
link_id, re-sending its BSS cipher info and, for BIGTK with beacon
protection on an AP link, toggling its beacons off and on.

Skip the key iteration for offchannel links, mirroring the remove path.

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Link: https://patch.msgid.link/20260724124813.3961474-18-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 45cdbe727c8b7..a319a99b5056e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -362,7 +362,8 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 				   CONN_STATE_PORT_SECURE, true);
 	rcu_assign_pointer(dev->mt76.wcid[idx], &msta_link->wcid);
 
-	ieee80211_iter_keys(mphy->hw, vif, mt7996_key_iter, &it);
+	if (!mlink->wcid->offchannel)
+		ieee80211_iter_keys(mphy->hw, vif, mt7996_key_iter, &it);
 
 	if (vif->txq && !mlink->wcid->offchannel &&
 	    mvif->mt76.deflink_id == IEEE80211_LINK_UNSPECIFIED) {
-- 
2.53.0



