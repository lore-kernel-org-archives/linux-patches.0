Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB26185E7F;
	Tue, 27 May 2025 17:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366605; cv=none; b=NWKh1j/ybiwZC8N5LW1XJUwUDywcMfxMKVrN4rjML77wSL2HCqW3HjgFuFRHPaHePtTb8p77r6AWpnmWbxOXZS9sRx9tCAsUgeH89pTb741bLq4II1K9NH+6XEfx/9PU8c7BgrCm4QYfW7q+ulEva9cH9y72RtWlhgTWCZtJjuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366605; c=relaxed/simple;
	bh=xNK1yTCEYbYJs3RwVEHMBkOmRQ52eqSeJpns7umcGLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIfKQULlruNl4fAh0GrJAouz3tbFbAemtwzq0h0alZZsvrJzVk0zUlHksK18YVgog6eTaAX76JO803xj4WZmKrhPZeHp6Hpgk+FIuqo9mLGimZXZb4fqtYSPzsPwzMktfLtDrgK6naAs7tNJl6KVf5rkOilrSjZF4sxs/LKq7Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZdE6tet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZdE6tet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AF4C4CEE9;
	Tue, 27 May 2025 17:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366605;
	bh=xNK1yTCEYbYJs3RwVEHMBkOmRQ52eqSeJpns7umcGLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZdE6tet7tfs+Jvz6NPLopZunTp2l7hyoamCW66GLpzmi1LFvwq26SIq9elbzE8Rh
	 cylifh2LpgUpjdCd/S80NWKiJXF5HdNUeq/C+OhEu+6K9dEMJ4tLAvy7l+KpdiIUMQ
	 UX5OE4Ku8fG9fHJKTg2xmSmUivpi0QjIJoR8ofVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 115/783] wifi: mt76: mt7996: implement driver specific get_txpower function
Date: Tue, 27 May 2025 18:18:32 +0200
Message-ID: <20250527162517.834165862@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 86db2c5d4ed390b97a5b455a97e2cd9c4f3eff2b ]

Fixes reporting tx power for vifs that don't have a channel context
assigned. Report the tx power of a phy that is covered by the vif's
radio mask.

Link: https://patch.msgid.link/20250311103646.43346-7-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/main.c  | 29 ++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 69dd565d83190..980a059b3b38f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -601,6 +601,33 @@ static void mt7996_configure_filter(struct ieee80211_hw *hw,
 	mutex_unlock(&dev->mt76.mutex);
 }
 
+static int
+mt7996_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		   unsigned int link_id, int *dbm)
+{
+	struct mt7996_vif *mvif = (struct mt7996_vif *)vif->drv_priv;
+	struct mt7996_phy *phy = mt7996_vif_link_phy(&mvif->deflink);
+	struct mt7996_dev *dev = mt7996_hw_dev(hw);
+	struct wireless_dev *wdev;
+	int n_chains, delta, i;
+
+	if (!phy) {
+		wdev = ieee80211_vif_to_wdev(vif);
+		for (i = 0; i < hw->wiphy->n_radio; i++)
+			if (wdev->radio_mask & BIT(i))
+				phy = dev->radio_phy[i];
+
+		if (!phy)
+			return -EINVAL;
+	}
+
+	n_chains = hweight16(phy->mt76->chainmask);
+	delta = mt76_tx_power_nss_delta(n_chains);
+	*dbm = DIV_ROUND_UP(phy->mt76->txpower_cur + delta, 2);
+
+	return 0;
+}
+
 static u8
 mt7996_get_rates_table(struct mt7996_phy *phy, struct ieee80211_bss_conf *conf,
 		       bool beacon, bool mcast)
@@ -1650,7 +1677,7 @@ const struct ieee80211_ops mt7996_ops = {
 	.remain_on_channel = mt76_remain_on_channel,
 	.cancel_remain_on_channel = mt76_cancel_remain_on_channel,
 	.release_buffered_frames = mt76_release_buffered_frames,
-	.get_txpower = mt76_get_txpower,
+	.get_txpower = mt7996_get_txpower,
 	.channel_switch_beacon = mt7996_channel_switch_beacon,
 	.get_stats = mt7996_get_stats,
 	.get_et_sset_count = mt7996_get_et_sset_count,
-- 
2.39.5



