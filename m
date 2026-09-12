Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DFB362120;
	Sat, 12 Sep 2026 10:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209072; cv=none; b=kfTmiQhDHYhrom3jVZWjN1MdnLDjLaciFGSjG8tMXEwz4o/isrJA+RzQJzq0YZEbFD3cpBLCk8L281qOhEDmJ7Ewc/OFCDF80y6uN1MxpBjlIAq5LYeQsENWOg92u9TF69PD7eMSlSmwexZMUrKQLVqb8Ilo9T7X/snufVJLJv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209072; c=relaxed/simple;
	bh=h8YAeBZwa+1kpWJWn/0ujBfyyfcvVj6/v2hmF0Bwdmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIb+dpVEc8snw6U/A47It4cCj4m8URVjxF2aZiTtlA/5eK6yHnR/uZ1OZWA4GYaqy0ARJLAqtpZ1tL6eJWq1asneT82+iA2e15/PeBojmPNeXSHENqhodv4E54lk7wkXxCBmBKKUoNrnxpc9ijBs/g6u+NT2UwUvjC3UAAW8Ti0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmfZ+WRD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmfZ+WRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3B61F000FF;
	Sat, 12 Sep 2026 10:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209070;
	bh=VM8rXgtuEs+TT9reScs2by/cSXe7SdxXT3m7IXDj3oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmfZ+WRDHdD4yhcTnKT14tJiW5k/wQhv3P7+bKkbleQIbAkUEeqmifW+KvKyY5FdH
	 gvZXZjrpQglZImuTlb3GfrnZ6RJb5nsa90eofqq/EK3pG6/eO2UoRSbvndETUMyzgT
	 oLmvIB9eRxlXL5s5tzEjcv96Jz+LUk7Ttjs0tR4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0747/1518] wifi: mt76: mt7915: clear wcid mask under mutex after RCU pointer clear
Date: Sat, 12 Sep 2026 08:48:36 +0200
Message-ID: <20260912065640.330136110@linuxfoundation.org>
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
index 8e69df105c5ae..d6d90d305ab91 100644
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



