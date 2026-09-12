Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6162737FC;
	Sat, 12 Sep 2026 08:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200880; cv=none; b=KnaVrmZjOjw4UFaulTg6ngMjoKaPEby5XeLH1gT20ytQ/NfuMSiCGrVKR3S4NmlF7U9TrJ2Wl2yVn5/ZKRwamkxCOzJaVA1iIIfhk+NZVusk7nztt79CaryZHjR/m2GdO/WD4+1BzfyGhkwSEgu100pOMft3/TQI7lcLvsJRg8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200880; c=relaxed/simple;
	bh=ggyub7W7XyBLccKm7TidbmYe2i131aFdID3bQDNuzoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGZf8saCE9xWHsDKX75embr04x4UTyZo9DLrZLYJ/ho2EtcJ75c1xNT3czVmGVCN7qzbRJix1xLRLA3Fqp72Y3KDtbmB8CkYcTId1pOwUu1Za1jPa5eJghGnbpnNesNm6/efXeZSrO9+FG5tPHDprrZ3aB7rmzMn+Y8rAGq9ntA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNapNx2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNapNx2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECF61F000FF;
	Sat, 12 Sep 2026 08:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200879;
	bh=jVrGv2JMVQF9jUqx/WS5NJyv0eLTVbn2pCtvgHgqqY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNapNx2hl0PO9t4CBCGTpSu7076TLeWmVTyRyFlNM8Cc4SlVbr215I6qXWYy7xRUT
	 80Bnq0uM2QttlcaHjzeqsI4RIw8f/Ui3wI/UXmAulNH+nVKBLyV/IePhGOm5huO5eL
	 PwrQEzNJD7h8NLQeJXt+zLacggP+QZr7v6bUC+ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0882/1815] wifi: mt76: mt7915: clear wcid mask under mutex after RCU pointer clear
Date: Sat, 12 Sep 2026 08:43:52 +0200
Message-ID: <20260912065709.627571750@linuxfoundation.org>
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

[ Upstream commit 6486e11a6e2f679597af2d5bb48c3b07a2b2a7ba ]

mt7915_remove_interface() cleared the wcid mask bit with no lock held and
before clearing the RCU wcid pointer. The mask is a non-atomic RMW shared
with the allocators, which all run under dev->mt76.mutex; on DBDC the two
wiphys share one mt76_dev, so this raced add_interface/sta_add on the
other band and could leak or double-hand-out a wcid. Clearing the bit
before the RCU pointer also let a concurrent allocation reuse the index
and publish its wcid, which the subsequent NULL assignment then wiped.
Move the clear into the existing mutex section, after the RCU pointer is
cleared.

Fixes: f3049b88b2b3 ("wifi: mt76: mt7915: allocate vif wcid in the same range as stations")
Link: https://patch.msgid.link/20260722082610.2699628-8-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 044b592efe284..c5eeafef3a903 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -294,7 +294,6 @@ static void mt7915_remove_interface(struct ieee80211_hw *hw,
 
 	mt7915_mcu_add_bss_info(phy, vif, false);
 	mt7915_mcu_add_sta(dev, vif, NULL, CONN_STATE_DISCONNECT, false);
-	mt76_wcid_mask_clear(dev->mt76.wcid_mask, mvif->sta.wcid.idx);
 
 	mutex_lock(&dev->mt76.mutex);
 	mt76_testmode_reset(phy->mt76, true);
@@ -310,6 +309,7 @@ static void mt7915_remove_interface(struct ieee80211_hw *hw,
 	mutex_lock(&dev->mt76.mutex);
 	dev->mt76.vif_mask &= ~BIT_ULL(mvif->mt76.idx);
 	phy->omac_mask &= ~BIT_ULL(mvif->mt76.omac_idx);
+	mt76_wcid_mask_clear(dev->mt76.wcid_mask, mvif->sta.wcid.idx);
 	mutex_unlock(&dev->mt76.mutex);
 
 	spin_lock_bh(&dev->mt76.sta_poll_lock);
-- 
2.53.0



