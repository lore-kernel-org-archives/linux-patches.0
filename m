Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414FC3446CE;
	Tue, 16 Dec 2025 11:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886075; cv=none; b=MheCS8Up4kU1C0ZGk24C+YFOJieN25tbI+IV/P4WwjqllenyLHXAEAE7/Xq7is6NAWJGrzHIe3tC6471wprm3Kj5g93S5NhY7b6NUyimVkpS7o0YtmpfFwvjEBm0vAxLaNCmm9VwGXHpmptaMK7dkd0gFc7h/buWAkbRHmLH79U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886075; c=relaxed/simple;
	bh=Ja9zfZgjNWSlatuN43KaREtzFK7EFb8DHbFh2vxSucc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JktdXO42wDHD8aKsOWsA8dW+ctfrf8VkfFLxrs4q3wXcErfVhHEXmzNoxizw06ym7AS8L5UWcs8jTP+W+sF9SuSt7winwhhgzlR+lyl1izwccvR8aPPeoKQoBHDXror3U0/dgNTeaLBBQ4YT+OGtbc51ILLkRo/74ilsr5IED64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQMrpJnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQMrpJnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D895C4CEF1;
	Tue, 16 Dec 2025 11:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886075;
	bh=Ja9zfZgjNWSlatuN43KaREtzFK7EFb8DHbFh2vxSucc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQMrpJncxnOhRBupkrvoOcaozfPSHkedoe2hNVnLylUe7gsODEZgc2KDmf5wr3nXu
	 kiljAW9P/EnT/0Tm6OM89F2ZWJVcLZb2s9EBRwvpoJslof7VnCj0gFSuFEXFUW+FKy
	 xMusKXZ4PCDVrDbxyKRgb1vqb+6z3fF8oTLtvg4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 331/507] wifi: mt76: mt7996: set link_valid field when initializing wcid
Date: Tue, 16 Dec 2025 12:12:52 +0100
Message-ID: <20251216111357.457229974@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 7eaea3a8ba1e9bb58f87e3030f6ce18537e57e1f ]

This ensures the upper layer uses the correct link ID during packet
processing.

Fixes: dd82a9e02c05 ("wifi: mt76: mt7996: Rely on mt7996_sta_link in sta_add/sta_remove callbacks")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251106064203.1000505-7-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 5f90a385b4d38..b8bd2bda5172f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -346,6 +346,7 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 	INIT_LIST_HEAD(&msta_link->rc_list);
 	msta_link->wcid.idx = idx;
 	msta_link->wcid.link_id = link_conf->link_id;
+	msta_link->wcid.link_valid = ieee80211_vif_is_mld(vif);
 	msta_link->wcid.tx_info |= MT_WCID_TX_INFO_SET;
 	mt76_wcid_init(&msta_link->wcid, band_idx);
 
@@ -969,6 +970,7 @@ mt7996_mac_sta_init_link(struct mt7996_dev *dev,
 	msta_link->wcid.sta = 1;
 	msta_link->wcid.idx = idx;
 	msta_link->wcid.link_id = link_id;
+	msta_link->wcid.link_valid = !!sta->valid_links;
 	msta_link->wcid.def_wcid = &msta->deflink.wcid;
 
 	ewma_avg_signal_init(&msta_link->avg_ack_signal);
-- 
2.51.0



