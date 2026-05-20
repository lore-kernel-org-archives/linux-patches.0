Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705F435C1A0;
	Wed, 20 May 2026 17:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297633; cv=none; b=NROyuXCCiVWo4+MxglWqTUM175GpalObsy/Nkb7bpcwgq2Rzy8C/jMzw10+tKAVkdn7pjiJkCbPpX0ZV4qIgUd4taQWQAVLw4Eb3lciz/W/f0SQ2EgmaSVA4X0wnrZt/cVqQkd2HMjNKG+Esc46PM3QVXvBhvp+INcp1y+LTXkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297633; c=relaxed/simple;
	bh=i7M6l+Aqg/JLS3krqp7QFHlx/Zy4sr0yd1HLMd9rvwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfZ1WEoqnULnmq/82zfKplGwrH22++IC8zd1Q4KPBsnpWV6H5iP2MC7ofqYBa/FPycmsjnYiYwL/yF/vyl9xrOKLA2JHa/oHurtgfcppnONPMh9VXb89syl+pf69yreWo8ILk74CufpMgHRcPSNMmrhzWPW4E1Cwh/W5dkjMhpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07nsA6ha; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07nsA6ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E711F000E9;
	Wed, 20 May 2026 17:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297632;
	bh=+EPLsaoYjrFemFDK4ulajI9HaQoOM3zXfxid2UV5+UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=07nsA6haUaPP0+0cQteNYgSsMiUtb6Yk0NjCxKdv6H7sFD3v3DbbsKc3hx1/gzRnA
	 AFHNZd+23Sgs9j43X/maGEz2TMPR/gf8JlahtH6rMaw7HfFT4eei6jalm/Vu/n1z/6
	 UekMgzTVb2CcWlS1BXsA+wiaun2ZcSHKqoi1drDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad@monroe.io>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 105/957] wifi: mt76: fix multi-radio on-channel scanning
Date: Wed, 20 May 2026 18:09:48 +0200
Message-ID: <20260520162136.839087132@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Chad Monroe <chad@monroe.io>

[ Upstream commit 0420180df092419a96351fb2afec1e2a74d385c3 ]

avoid unnecessary channel switch when performing an on-channel scan
using a multi-radio device.

Fixes: c56d6edebc1f ("wifi: mt76: mt7996: use emulated hardware scan support")
Signed-off-by: Chad Monroe <chad@monroe.io>
Link: https://patch.msgid.link/20251118102723.47997-1-nbd@nbd.name
Link: https://patch.msgid.link/20260309060730.87840-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/scan.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 3d9cf6f5e137f..efcf79d9d60e0 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -16,7 +16,7 @@ static void mt76_scan_complete(struct mt76_dev *dev, bool abort)
 
 	clear_bit(MT76_SCANNING, &phy->state);
 
-	if (dev->scan.chan && phy->main_chandef.chan &&
+	if (dev->scan.chan && phy->main_chandef.chan && phy->offchannel &&
 	    !test_bit(MT76_MCU_RESET, &dev->phy.state))
 		mt76_set_channel(phy, &phy->main_chandef, false);
 	mt76_put_vif_phy_link(phy, dev->scan.vif, dev->scan.mlink);
@@ -85,6 +85,7 @@ void mt76_scan_work(struct work_struct *work)
 	struct cfg80211_chan_def chandef = {};
 	struct mt76_phy *phy = dev->scan.phy;
 	int duration = HZ / 9; /* ~110 ms */
+	bool offchannel = true;
 	int i;
 
 	if (dev->scan.chan_idx >= req->n_channels) {
@@ -92,7 +93,7 @@ void mt76_scan_work(struct work_struct *work)
 		return;
 	}
 
-	if (dev->scan.chan && phy->num_sta) {
+	if (dev->scan.chan && phy->num_sta && phy->offchannel) {
 		dev->scan.chan = NULL;
 		mt76_set_channel(phy, &phy->main_chandef, false);
 		goto out;
@@ -100,20 +101,26 @@ void mt76_scan_work(struct work_struct *work)
 
 	dev->scan.chan = req->channels[dev->scan.chan_idx++];
 	cfg80211_chandef_create(&chandef, dev->scan.chan, NL80211_CHAN_HT20);
-	mt76_set_channel(phy, &chandef, true);
+	if (phy->main_chandef.chan == dev->scan.chan) {
+		chandef = phy->main_chandef;
+		offchannel = false;
+	}
+
+	mt76_set_channel(phy, &chandef, offchannel);
 
 	if (!req->n_ssids ||
 	    chandef.chan->flags & (IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_RADAR))
 		goto out;
 
-	duration = HZ / 16; /* ~60 ms */
+	if (phy->offchannel)
+		duration = HZ / 16; /* ~60 ms */
 	local_bh_disable();
 	for (i = 0; i < req->n_ssids; i++)
 		mt76_scan_send_probe(dev, &req->ssids[i]);
 	local_bh_enable();
 
 out:
-	if (dev->scan.chan)
+	if (dev->scan.chan && phy->offchannel)
 		duration = max_t(int, duration,
 			         msecs_to_jiffies(req->duration +
 						  (req->duration >> 5)));
-- 
2.53.0



