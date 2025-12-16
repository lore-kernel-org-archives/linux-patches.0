Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF93A1E0E14;
	Tue, 16 Dec 2025 12:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887985; cv=none; b=Omm5Y26lIr7E05OMWz+pqneH6iRLAnT/JdpI0GYG1N1ZYa3M+IkLjwShjuG75MbS5XzicnQRTMWUTcB4Z2omLfUr+KFKJpaGwfB5bI7vM2DwVsWciaOSUA/qtb6bZHJbBVl2i0KMTrPA0JZwFTBCrcKCwynsjoyEBt09F3lOims=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887985; c=relaxed/simple;
	bh=BEz0JI1/QY2MgBOx1XI/XhZgwoWrrnA5IT7ki4tFq2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3tBXDjRiceCE56XojC+0xpGpNSOW/cHAs4dQ1SM4yg1Rkwn2S4KEyTLobiqks8riRFP/REtqxD+Yq578NcOgydb/Dno5cxgNpkNwOWO6Sl6bba7NjX+U4FZhXjQBSskWzcK18mOOBgxvZWSIE8ikQL5lXfeFqoT2tJJ2zKbDzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5U2XV1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5U2XV1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6D0C4CEF1;
	Tue, 16 Dec 2025 12:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887985;
	bh=BEz0JI1/QY2MgBOx1XI/XhZgwoWrrnA5IT7ki4tFq2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5U2XV1KP+uXnjRhPr6I8Oi7QfFmjTOg/yDeIwO/1LOXmE/cHV8KpVP5LLs9QnJ6/
	 /H3zu5dIkuhj13gD4RHC/fw6Kv8iL97x1uwArfkBeSRTSmQvR18ip66PbZerVukmuc
	 3lcLDteaUBlL2beIBXAmxaet1nm9ozWcpKYRRtOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 398/614] wifi: mt76: Move mt76_abort_scan out of mt76_reset_device()
Date: Tue, 16 Dec 2025 12:12:45 +0100
Message-ID: <20251216111415.794692751@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 6aaaaeacf18b2dc2b0f78f241800e0ea680938c7 ]

Move mt76_abort_scan routine out of mt76_reset_device() in order to
avoid a possible deadlock since mt76_reset_device routine is running
with mt76 mutex help and mt76_abort_scan_complete() can grab mt76 mutex
in some cases.

Fixes: b36d55610215a ("wifi: mt76: abort scan/roc on hw restart")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Tested-by: Ben Greear <greearb@candelatech.com>
Link: https://patch.msgid.link/20251114-mt76-fix-missing-mtx-v1-3-259ebf11f654@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c   | 2 --
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 2 ++
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 5ceaf78c9ea06..5e75861bf6f99 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -847,8 +847,6 @@ void mt76_reset_device(struct mt76_dev *dev)
 	}
 	rcu_read_unlock();
 
-	mt76_abort_scan(dev);
-
 	INIT_LIST_HEAD(&dev->wcid_list);
 	INIT_LIST_HEAD(&dev->sta_poll_list);
 	dev->vif_mask = 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 1c0d310146d63..5caf818e82834 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1451,6 +1451,8 @@ mt7915_mac_full_reset(struct mt7915_dev *dev)
 	if (ext_phy)
 		cancel_delayed_work_sync(&ext_phy->mac_work);
 
+	mt76_abort_scan(&dev->mt76);
+
 	mutex_lock(&dev->mt76.mutex);
 	for (i = 0; i < 10; i++) {
 		if (!mt7915_mac_restart(dev))
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index b06728a98a691..cfad46a532bb7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2424,6 +2424,8 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 	mt7996_for_each_phy(dev, phy)
 		cancel_delayed_work_sync(&phy->mt76->mac_work);
 
+	mt76_abort_scan(&dev->mt76);
+
 	mutex_lock(&dev->mt76.mutex);
 	for (i = 0; i < 10; i++) {
 		if (!mt7996_mac_restart(dev))
-- 
2.51.0



