Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34CD3B71DA;
	Sat, 12 Sep 2026 10:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209288; cv=none; b=bErfQ+JSxNxE+8xRl82hAgM20WVe4TeEqqhrGUtBHD8WIZIC7nSFfJtvk6VhRl/+5ZZQuufYwRQu8futCvGcVHoeKHO2JZqRAtJq9E1tV+zCoAwjZTl/xXU61mtyhOmC5J2jLLpHpVVyfQ/yaHDuxHC+XzD8n//cE3arExFcy2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209288; c=relaxed/simple;
	bh=8p7Tx23z8UQKqpGwtlITK7qVVAp4SO16mL+ao3LhhDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSAvfZLfSGBRTZ5GvJ4IPGEfBsdG4eqg9o1vwKoBN83m2XAu9lz5l+0c7JvNzTksb5grLgAb9Tl9ijZe1SKGNjyI40KTxRqXU18NmE1lpd+0HE+iWHktIikeMH51ge7C+osNKzVC8pKhp0pAZqvOJwW7AEqK6lTrp6Rp4PpTaPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AwOVIqjs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AwOVIqjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63EA1F000FF;
	Sat, 12 Sep 2026 10:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209285;
	bh=j2PhkC5S4LK79CbluoCvbjWK6Hyxln6OUOmY3A0AFlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwOVIqjsgCxKTfeRza4epl/rAIJqPiNlJ+YjAB6fKA1kkMpYiZ3GeqcUl2/UZOgI8
	 JaOaKNZqmsdCEQg8QNX9NpX23eOEe/DpXjO3+ogQgnEaKJMnVRWm9AJjk3s4rC9SuP
	 wGrB5OyR3WT6uuBwXEE2SX7hxeCub//ITqTYqupo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0791/1518] wifi: mt76: mt7996: free vif links after clearing wcid entries on full reset
Date: Sat, 12 Sep 2026 08:49:20 +0200
Message-ID: <20260912065641.327749845@linuxfoundation.org>
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

[ Upstream commit 7e4208e9f6a876c2b7d28fdb6b86dff3b05db2f7 ]

mt7996_mac_reset_vif_iter() queues non-default vif links for kfree_rcu
while dev->wcid[] still holds pointers to the wcid embedded in each
freed link; mt76_reset_device() then dereferences those entries and
runs mt76_wcid_cleanup() on them. If a grace period elapses in between,
the cleanup operates on freed memory.

Run mt76_reset_device() first, so the wcid entries are cleaned up and
cleared while the links are still valid.

Fixes: ace5d3b6b49e ("wifi: mt76: mt7996: improve hardware restart reliability")
Link: https://patch.msgid.link/20260724124813.3961474-25-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 35a34fc346eb7..dc1a3e91218ad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2539,10 +2539,10 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 		phy->omac_mask = 0;
 
 	ieee80211_iterate_stations_atomic(hw, mt7996_mac_reset_sta_iter, dev);
+	mt76_reset_device(&dev->mt76);
 	ieee80211_iterate_active_interfaces_atomic(hw,
 						   IEEE80211_IFACE_SKIP_SDATA_NOT_IN_DRIVER,
 						   mt7996_mac_reset_vif_iter, dev);
-	mt76_reset_device(&dev->mt76);
 
 	INIT_LIST_HEAD(&dev->sta_rc_list);
 	INIT_LIST_HEAD(&dev->twt_list);
-- 
2.53.0



