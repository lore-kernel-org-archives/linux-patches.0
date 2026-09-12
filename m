Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BDA455626;
	Sat, 12 Sep 2026 12:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216801; cv=none; b=f+IKouGYAK3IgiiR77niBDZRjkQ/E1nKNKMkiHXm5y/O6dfh8RpZwgM+40F97dcPkqtdZfqHnt7BolzbWFduBNOK8/vleiYrtpnzp9mIgYAKcsypV99ii9t0eebXqWMUfo54EfU7DgmX4xHdzDjt4zCLC94m//6ZXxhaBhjGyRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216801; c=relaxed/simple;
	bh=FeU/mi8Wu9Oy7YNkwZoki1lwx+e6RKR6CI2NSmUNA3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMeeAq/tFxk7Zi6F0O/tM9P2rRrcowlOOQcJm8eIunhfJzTqWUt2uXoCu/R3OsVRb0ydY4b6IjKv2t1OEIan3QvWd/Ycr343ZfBZlYghoVD2XDzANz1LH8csM8cfO+Nu7bKiK0XxR2Q2FkRFVz5RKf4ZiiTUw7YjtGdPPy2vD3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIPGNN62; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIPGNN62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6A31F000FF;
	Sat, 12 Sep 2026 12:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216799;
	bh=ByZR8iyYt02WIOBa964JkMIaCAA5HAOllQeTuuItnpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TIPGNN62n25wsInowI2aNTDgCzvmACBq+7GiCM90713F3Mo09gtqCigBN3ZbVhZP5
	 WQG1A0YK2Q4MdgmepWXGIMWSQfnjvK33cRxGaHAIpJMndSYn8h/CLmQOjSv2ba+rK+
	 GDb4p6UDAyjPqIJPBbgqUrpSQfOYmnUgPa8TpS90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0810/1376] wifi: mt76: mt7915: clear wcid mask under mutex after RCU pointer clear
Date: Sat, 12 Sep 2026 08:53:56 +0200
Message-ID: <20260912065625.594389750@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9b0fde73b8945..4875f51472ed8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -296,7 +296,6 @@ static void mt7915_remove_interface(struct ieee80211_hw *hw,
 
 	mt7915_mcu_add_bss_info(phy, vif, false);
 	mt7915_mcu_add_sta(dev, vif, NULL, CONN_STATE_DISCONNECT, false);
-	mt76_wcid_mask_clear(dev->mt76.wcid_mask, mvif->sta.wcid.idx);
 
 	mutex_lock(&dev->mt76.mutex);
 	mt76_testmode_reset(phy->mt76, true);
@@ -312,6 +311,7 @@ static void mt7915_remove_interface(struct ieee80211_hw *hw,
 	mutex_lock(&dev->mt76.mutex);
 	dev->mt76.vif_mask &= ~BIT_ULL(mvif->mt76.idx);
 	phy->omac_mask &= ~BIT_ULL(mvif->mt76.omac_idx);
+	mt76_wcid_mask_clear(dev->mt76.wcid_mask, mvif->sta.wcid.idx);
 	mutex_unlock(&dev->mt76.mutex);
 
 	spin_lock_bh(&dev->mt76.sta_poll_lock);
-- 
2.53.0



