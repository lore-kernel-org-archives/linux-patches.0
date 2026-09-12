Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAB519E7F7;
	Sat, 12 Sep 2026 08:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201151; cv=none; b=q7E2eTZUpJw3/rQhQrVrxR+uhPFYUg+6bU1yMff2eiUE2GzBJkJNcqUHcnarNJv7/y5kZSjKtTZPUbWfmbDN/ztjpfAZNVYCqi7hkYWh2Ii1pK2zVi/2U+SIHeMjmMiMpG7cQ5W138fxktJVhXj0oal/exCgOLXYaHsoHn7Dqfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201151; c=relaxed/simple;
	bh=f41gqgq8IFV28j1nnIYsu36p/INw/gMj/H6bBg2jnDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCn7PDKW53tNIdD31xckgKq8yA4fZKmtdL2U2HiWXu2odyoXDrjdasKsFp5hMK+oV5UgKIXLUAX2b12WSFzk/t/su9dPHCpgtArIwfuqQUFTPhms7FcRXtzhIDjMM4D4cShL8qxqXZ/3yT7fL4lkybbU4uRC/4VbZVxerj8gje0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSSZOLvY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSSZOLvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AD61F000FF;
	Sat, 12 Sep 2026 08:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201150;
	bh=H9lTxm03KGokMs+b1A+3xKWO7YCQBKIXVCnYgEu02gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSSZOLvYBhUiCyhZ53m04L5R/rvb5CDQYDEcv42/4ZGhWVV1v+oJjCBa5qeXhns8n
	 CDOXid6rNqhaXq7OrXLNK5ulZCryGuRHM4t+z875qGqAZVhXD8/0Arvl22f62EWHBd
	 T4j1ouhUtFRSVPySohJZhV4bdmfSQWBok+MVstwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0937/1815] wifi: mt76: mt7996: free vif links after clearing wcid entries on full reset
Date: Sat, 12 Sep 2026 08:44:47 +0200
Message-ID: <20260912065710.952300515@linuxfoundation.org>
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
index 3d11ce226e898..a9d298a163abb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2487,10 +2487,10 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
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



