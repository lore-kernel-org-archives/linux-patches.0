Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D642A4DA9D7;
	Tue, 13 Oct 2026 12:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894125; cv=none; b=FWEI2FQ/EvdOCz+dl0sTB/SGcyBgXUwLA5bQLEPfR3+Y2ugSxJdJklX0rueXmKBSrjunQjdnWm05fU34gbXFP+Vavk5uTsJzeakmwtYCm5+BGAehJ3doQ706q1dkB5uNDsv9Gj4+1pqcpPP9wwkJlveXIw0Wey3zbTVdVrLdviQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894125; c=relaxed/simple;
	bh=gGIRoKEiOJYvDlyuz+u6wN3OGbDEPwTIAYK3COdkU7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXO9sIK/gfR15xdwiIpwKpGzX7sIF8MkCSgxeXhQUZah2DK68TBHjDy7MKoaV2fNIzpGr2BNBzj+4v8NSxoRWaTRz/EVTvU+MpGDgzBwg4loYcjTJQZlDRtFLcOcsXdLpAFIunavk4S4ioiF+wqTdgiMV1YXpIcY62SSXSUvBtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dX/Yfham; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dX/Yfham"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F091F00899;
	Tue, 13 Oct 2026 12:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894124;
	bh=p2dMPPVNy+71bCtTsUDSl6rRtjDKo0tn2xNvjCrW9QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dX/YfhamI7mmxCZAyqC6SKtcOHPoVNKqH5OksbOW495YTJy7jDxEGKGCl/XoxiHU2
	 A0k6DGMg/ED52MsAJ0aCR15PwaWH1RrJI2kD+UjidAA842oL66Go1S+bMgeJ1xJW93
	 yNJ2uW13XYwdxpnrk3A7RawlgdKIAWKwXz4Vl/pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 455/621] wifi: mt76: mt7996: clear stale link state on full reset
Date: Tue, 13 Oct 2026 13:37:30 +0200
Message-ID: <20261013112931.630052471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index dc1a3e91218ad..ed3508afc0844 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2503,6 +2503,7 @@ mt7996_mac_reset_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 		rcu_assign_pointer(mvif->link[i], NULL);
 		kfree_rcu(mlink, rcu_head);
 	}
+	mvif->valid_links = 0;
 	rcu_read_unlock();
 }
 
@@ -2537,6 +2538,8 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 
 	mt7996_for_each_phy(dev, phy)
 		phy->omac_mask = 0;
+	dev->mld_idx_mask = 0;
+	dev->mld_remap_idx_mask = 0;
 
 	ieee80211_iterate_stations_atomic(hw, mt7996_mac_reset_sta_iter, dev);
 	mt76_reset_device(&dev->mt76);
-- 
2.53.0



