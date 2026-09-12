Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C524038DC59;
	Sat, 12 Sep 2026 10:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209123; cv=none; b=P6d20cHDhvSc07Axfx3FUCXbYji7gipvPgtzlu1rQZpqyv+Ff1JAqMCBhBtqjt5T6CuLue3zhUpg+mPUltU9qtAdZ2jQ6z4x5sZQfanjfH9fNQvCI6yoiDRY6++W9QOPS/8O51Q5e9xFjo9dvySsulJYFGFt6UCJXgcWtlLFEFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209123; c=relaxed/simple;
	bh=MMuZuFwAWRzzsvzDeffyPFlH23ZWMTanp5IsnQXhc4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDYEvdgeh1ikBZB+eFpNej6POCHq8AomDq4fz2zfNJcHRcKvWCx4MTc6VR+SdKeNF+fFd25jPM32CsSgu5q3wf7S04VhvOgSlj7SR7GTkGVUE9wF0Zng6Cs3UG9TAb8kQt+lidNp+POQ1/JnN5QVDT6PCSuGHMlYlgI+ZUiTmBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/VmLUoa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/VmLUoa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9815D1F000FF;
	Sat, 12 Sep 2026 10:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209122;
	bh=vUyWMfIQCRvLJmEFXGWpRAyJvag2o7B/+hj7g5BuXXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n/VmLUoanj8TyMOPOxgHNDbBGcoUhPa5wSekQ6rC3K96Y5DwxAOqi8xedF9YZuFe8
	 qCG/rek3vGb+a5Hmb/6XEtGc9l9HQfX4YVfusPejYC6jKtLaSIjSGNEqMKib67ZrVF
	 a7HX04tAyzEVZvidRmMdy+XZIE8hA05EcRkuNPq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0757/1518] wifi: mt76: mt7915: unwind state on add_interface failure
Date: Sat, 12 Sep 2026 08:48:46 +0200
Message-ID: <20260912065640.553410173@linuxfoundation.org>
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

[ Upstream commit 2fb6480c52f611338e1b0abe5e6219be1fc9ab75 ]

When mt76_wcid_alloc() fails, mt7915_add_interface() returned without
clearing the vif_mask/omac_mask bits it had already set, without removing
the firmware dev info added earlier, and without clearing a monitor_vif
pointer to the vif mac80211 is about to free. mac80211 does not call
remove_interface() for a failed add, so the indices and firmware dev
entry leaked permanently and testmode could dereference the stale
monitor_vif. Add a proper error unwind.

Fixes: b619e01380ee ("mt76: fix MBSS index condition in DBDC mode")
Link: https://patch.msgid.link/20260724124813.3961474-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 4b11e0845f568..3c1d388b200a0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -249,7 +249,7 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, mt7915_wtbl_size(dev));
 	if (idx < 0) {
 		ret = -ENOSPC;
-		goto out;
+		goto err;
 	}
 
 	INIT_LIST_HEAD(&mvif->sta.rc_list);
@@ -277,7 +277,17 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	mt7915_mcu_add_sta(dev, vif, NULL, CONN_STATE_PORT_SECURE, true);
 	rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->sta.wcid);
 
+	mutex_unlock(&dev->mt76.mutex);
+
+	return 0;
+
+err:
+	dev->mt76.vif_mask &= ~BIT_ULL(mvif->mt76.idx);
+	phy->omac_mask &= ~BIT_ULL(mvif->mt76.omac_idx);
+	mt7915_mcu_add_dev_info(phy, vif, false);
 out:
+	if (phy->monitor_vif == vif)
+		phy->monitor_vif = NULL;
 	mutex_unlock(&dev->mt76.mutex);
 
 	return ret;
-- 
2.53.0



