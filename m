Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730DE38D6A2;
	Sat, 12 Sep 2026 08:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201160; cv=none; b=RpsJ2eZZ+RAvGb4LDnUZD8SyG7gcQyVz2/Th2BENqccPXVlrCy7rHWvbFDhTEoG8YPpFTghgWh+7SSJ3nCq4qtgaRfkhvN97J5ffkiNjuQArIPg/g/u5CHWncxcf17l/uA2hjxSSEaitkxQq5YHj1iRis3YVvCnRra7lX6z1AdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201160; c=relaxed/simple;
	bh=m8qQ8lKWil/FsahKs3xbFdx9jPoUieN3smNslmzrhZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDn5VsoqRYz0P6p6/B6a7RouUjwHSrtC7snLJov11HnSN2r/e/mgBs2+wEa/zDu4uR3mLw40vcrRSbNRGQz2yr+cJ540qp/Ly4HJpV/4KHdnEaytdB8R8MZPRj8SbjUKAhvJLa4LVgALVNdQlB1W2UZPSTSPwXz5a3LzxOW8ihQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNMiMiCm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNMiMiCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4031F000FF;
	Sat, 12 Sep 2026 08:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201159;
	bh=5gVQfwbPwxcLKGUz7r6T5sLFn93hGOXlcKheS4q++Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNMiMiCmlDGNxPHAK6L2/HeHUY5i/K3IdZfQwjD75SNI5mHfCEY+gSIXmBwjSkw9W
	 vHpYGfseA2tIKPEhgZ+VSN0qcuXF0LdZWFQ7v5fA6Ef6lP2LwElCQGCzFxyBQ7zvGv
	 luLdZOUZKorutqt2FyXs6KXfP+D2TXB392IEi6Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0939/1815] wifi: mt76: set MT76_SCANNING when starting a hw scan
Date: Sat, 12 Sep 2026 08:44:49 +0200
Message-ID: <20260912065711.000956816@linuxfoundation.org>
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

[ Upstream commit 6ff1c217a00335c92aa6a9b35b3ff3b128efbfea ]

The scan state bit is cleared by mt76_scan_complete(), but nothing ever
sets it: mt76_sw_scan() is only called for drivers without hw scan
support. As a result, all MT76_SCANNING checks are inert for drivers
using mt76_hw_scan(), including the DFS state handling in
mt76_phy_dfs_state() and the guard against manually triggered radar
detection while scanning.

Set the bit when the scan request is accepted. Since every channel
programmed while scanning now evaluates the DFS state as disabled and
stops the radar detector, re-program the operating channel at scan
completion regardless of the off-channel state, after the scanning bit
has been cleared. Otherwise a scan whose last visited channel was the
operating channel, or one that returned to it early because of
associated stations, would leave radar detection stopped until the
next channel switch.

Fixes: 31083e38548f ("wifi: mt76: add code for emulating hardware scanning")
Link: https://patch.msgid.link/20260724124813.3961474-27-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/scan.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 325638d587c96..3cb11689d4bf2 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -16,10 +16,17 @@ static void mt76_scan_complete(struct mt76_dev *dev, bool abort)
 
 	clear_bit(MT76_SCANNING, &phy->state);
 
-	if (dev->scan.chan && phy->main_chandef.chan && phy->offchannel &&
+	/* Re-program the operating channel even when the scan never left it:
+	 * any channel set during the scan ran with MT76_SCANNING held, which
+	 * left DFS radar detection disabled
+	 */
+	if (phy->main_chandef.chan &&
 	    !test_bit(MT76_MCU_RESET, &dev->phy.state)) {
+		bool offchannel = phy->offchannel;
+
 		mt76_set_channel(phy, &phy->main_chandef, false);
-		mt76_offchannel_notify(phy, false);
+		if (offchannel)
+			mt76_offchannel_notify(phy, false);
 	}
 	mt76_put_vif_phy_link(phy, dev->scan.vif, dev->scan.mlink);
 	memset(&dev->scan, 0, sizeof(dev->scan));
@@ -211,6 +218,7 @@ int mt76_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	dev->scan.vif = vif;
 	dev->scan.phy = phy;
 	dev->scan.mlink = mlink;
+	set_bit(MT76_SCANNING, &phy->state);
 	ieee80211_queue_delayed_work(dev->phy.hw, &dev->scan_work, 0);
 
 out:
-- 
2.53.0



