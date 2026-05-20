Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C42A3D6CB5;
	Wed, 20 May 2026 17:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297599; cv=none; b=uBn2ywmN0R4P2/UyVf9PuyX0K+1l649PHLq7970hnTQfUa3PRyjT3QqvH117d4GK9LQfiLY2J7jbp9BGzo4E//ea2lF+xeo4yRe3NPL8PCFuNVm4k2QakTMJuKzZR+37lGw+9SvQ/W9/hhjAx/cKQEMo8Xd/J1zqvscR02ZvCwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297599; c=relaxed/simple;
	bh=chewGazq+j/jjiWXmRNj5UTrWCETkMM5WuJNHUAWH4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FplUwo+f7JtFWi5lxDvRabUlVy9rIRb7ftJDtX3td6LUug9oxZjNRyToiWOShwjUofjpcKk5i9JWazZHYmEWfvhKJTrOUZ/SWK2pyMQHehXIzutFbtTAKqSwlHBfBvxseuKk9Z8MN1t60xJKuNX/pOdstvAlLN5y1klOdAQhz28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6YjwE+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6YjwE+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B239B1F000E9;
	Wed, 20 May 2026 17:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297598;
	bh=oIvGX3udvmHje5zpZPCFcX5PaoEK3Ms5/0ALbpUMhsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6YjwE+s2oS8OfOY87jgqU+xs55mciOnjTMLPOTG5Q0oTmrlg82W5PcGDDVaU5cLB
	 ZOiFfXEOGkN/T23Q/Hs1jZmC2kibT17yR8wLqIg6drWe029XrkWnV43MMLycoVvP10
	 zN5rmPey7P+4ea6hKojNhRMQo5pOcme4Zei/n3nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad@monroe.io>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/957] wifi: mt76: fix deadlock in remain-on-channel
Date: Wed, 20 May 2026 18:09:36 +0200
Message-ID: <20260520162136.576551670@linuxfoundation.org>
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

From: Chad Monroe <chad@monroe.io>

[ Upstream commit 6939b97ddad3cf3dfbb3b5a0a12ef79cb886747e ]

mt76_remain_on_channel() and mt76_roc_complete() call mt76_set_channel()
while already holding dev->mutex. Since mt76_set_channel() also acquires
dev->mutex, this results in a deadlock.

Use __mt76_set_channel() instead of mt76_set_channel().
Add cancel_delayed_work_sync() for mac_work before acquiring the mutex
in mt76_remain_on_channel() to prevent a secondary deadlock with the
mac_work workqueue.

Fixes: a8f424c1287c ("wifi: mt76: add multi-radio remain_on_channel functions")
Signed-off-by: Chad Monroe <chad@monroe.io>
Link: https://patch.msgid.link/ace737e7b621af7c2adb33b0188011a5c1de2166.1765204256.git.chad@monroe.io
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 130af1b254dbf..eccaee1fd434f 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -326,7 +326,7 @@ void mt76_roc_complete(struct mt76_phy *phy)
 		mlink->mvif->roc_phy = NULL;
 	if (phy->main_chandef.chan &&
 	    !test_bit(MT76_MCU_RESET, &dev->phy.state))
-		mt76_set_channel(phy, &phy->main_chandef, false);
+		__mt76_set_channel(phy, &phy->main_chandef, false);
 	mt76_put_vif_phy_link(phy, phy->roc_vif, phy->roc_link);
 	phy->roc_vif = NULL;
 	phy->roc_link = NULL;
@@ -370,6 +370,8 @@ int mt76_remain_on_channel(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (!phy)
 		return -EINVAL;
 
+	cancel_delayed_work_sync(&phy->mac_work);
+
 	mutex_lock(&dev->mutex);
 
 	if (phy->roc_vif || dev->scan.phy == phy ||
@@ -388,7 +390,14 @@ int mt76_remain_on_channel(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	phy->roc_vif = vif;
 	phy->roc_link = mlink;
 	cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_HT20);
-	mt76_set_channel(phy, &chandef, true);
+	ret = __mt76_set_channel(phy, &chandef, true);
+	if (ret) {
+		mlink->mvif->roc_phy = NULL;
+		phy->roc_vif = NULL;
+		phy->roc_link = NULL;
+		mt76_put_vif_phy_link(phy, vif, mlink);
+		goto out;
+	}
 	ieee80211_ready_on_channel(hw);
 	ieee80211_queue_delayed_work(phy->hw, &phy->roc_work,
 				     msecs_to_jiffies(duration));
-- 
2.53.0



