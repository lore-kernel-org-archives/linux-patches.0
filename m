Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A1019E7F7;
	Sat, 12 Sep 2026 08:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201156; cv=none; b=Pv2qGLIlhx+uKu7Pcxyd9zQ7BFlwjL0L9DMsjgY0549DGAFSj8vmH6kzA0voCQJ7OgA5G4bUebmC16JADOzkhp4CHm8J3znbErxxpwTZKR4UnJUXbDd5T+ERB3sfwYLiCx2GM6hvlrUIr0AsUVn7Cgl1L/l4XOVbPSd9h3llbmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201156; c=relaxed/simple;
	bh=AAZd7Q2mSogkKK9fanpsJ6w3ukrnIVjgTCN9uchV0Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IW5uQHV9n75RM7TLFKPK1DpVaL4kI/gVPko3ul0XiwmKnWMnqfEBWq7LUPSwqbVJoyWpdiG5nu0ogM78U5JbZm5G5kyPbmZRe/fy2Ys+S/B1nPjGRjRYA+7FRp4xVjm2YZeg32xYVquqTHsrdExKZMakWkRrt5TJ9pUSQr2Kej0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lApKVgw+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lApKVgw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F821F000FF;
	Sat, 12 Sep 2026 08:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201154;
	bh=0X6rcrY+CfyIGJ6oAXfm4Ne17N2aAU/GQ3CD4TZ1B2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lApKVgw+PP/mrEqKmW14i2MVP6BU/sNA13PH4juoKVWdLcCHIWAvDNxElcOH86h/+
	 B/9sdsXi6w6RBhlAAuikE2f+ws1knzijy3B371N9H6WPww5PPy1xwzVrss2Tjfacy3
	 f/FymjHFo4Oah5fWvHG45RYGvQxbDaUe47PsiwPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0938/1815] wifi: mt76: mt7996: clear stale link state on full reset
Date: Sat, 12 Sep 2026 08:44:48 +0200
Message-ID: <20260912065710.977502141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 75d2a4e2129b58bb0ddb842387299038495aad2a ]

After a full chip reset, mac80211 reconfig replays interface, link and
channel context setup. mt7996_vif_link_add() short-circuits when the
link_id is still marked in mvif->valid_links, a state introduced for
postponing link teardown to interface removal. The reset path frees the
link structures without clearing those bits, so the replayed setup never
re-creates dev_info/bss_info/STA records in the restarted firmware and
never re-registers the link wcid, leaving the device inoperative.

The reset path also leaks every allocated MLD index: per-link indices
and the per-vif group/remap indices are re-allocated from scratch during
reconfig, but the old bits stay set in the masks, so repeated full
resets exhaust the index space.

Clear valid_links in the reset vif iterator and reset the MLD index
masks alongside the existing omac_mask clearing.

Fixes: ace5d3b6b49e ("wifi: mt76: mt7996: improve hardware restart reliability")
Fixes: 08813703ac41 ("wifi: mt76: mt7996: Destroy vif active links in mt7996_remove_interface()")
Link: https://patch.msgid.link/20260724124813.3961474-26-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index a9d298a163abb..85d4adf1c113d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2451,6 +2451,7 @@ mt7996_mac_reset_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 		rcu_assign_pointer(mvif->link[i], NULL);
 		kfree_rcu(mlink, rcu_head);
 	}
+	mvif->valid_links = 0;
 	rcu_read_unlock();
 }
 
@@ -2485,6 +2486,8 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 
 	mt7996_for_each_phy(dev, phy)
 		phy->omac_mask = 0;
+	dev->mld_idx_mask = 0;
+	dev->mld_remap_idx_mask = 0;
 
 	ieee80211_iterate_stations_atomic(hw, mt7996_mac_reset_sta_iter, dev);
 	mt76_reset_device(&dev->mt76);
-- 
2.53.0



