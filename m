Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025891;
	b=AytYf729n8guK94ALTfOjdUXE5dYfDeQDeNl8dRxHvCAdidZPSMXYf6qQBrK1Q2+4UPi
	 EbaUvPicGR8xWt4Eb1GLwo7QRyMNl7b7iD6iLKkoAAsMxZaJJbaaulW7OuNqapOyxBo3Q
	 Oj8VXNRCX+tRU+zpXCGlahwecdQXJBzY0D/J8r9YC6gXbnUAhFZ+C9dOAQk6BVh/O7YS5
	 VA5YbbUkCA4jNP+wH/gkSF8Q6UANmdJc+eY8W3HA6A2e58zdMjBUp+ZfLbxWiHGU9friv
	 pcGtBzDp+FxWk2IbpDiB3Wlo4QRMRSO5l/IY4UYUFOTINgrk6DhD5am3vjpwMVkv9Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8/UJ7mr1lbVC8TgTPdpKMSRtNiqA0V0bUrURQqgVoPY=;
	b=28dP8TyBuphfpmU3SzSgMGb2FgomOgGrUNboL3ZF2D3ME5YEidzeQyUUU7bxLhKvXDaf
	 TeMccpv+f6wxcnJe0/WGRNP+75m4wGCilDR4r5Z1DhLAK8GUq0zkSv3oMQWELuLI1K32a
	 6LtupNYlCqML00i4T68zkgF8nRrkShcOKZUXWzqwoUt+rlQdsMfwv0Z0KkWwxt7Bzsyl9
	 ssF6XmXRRK1PbRsaSdGo4AVC+KjtL11GGr0HyHRKDU36hjnQb2PPjMTL4bw3bIxpKxq7D
	 LR7T4mazGopqYBcOYLOHo3WvAyNkuQJ5/DE/tZUbrZFVG3x3fdxrfossEDUYwg93ARg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jRhEvu/G";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAC2606A325;
	Wed, 18 Nov 2026 18:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jRhEvu/G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7931F000C6;
	Wed, 18 Nov 2026 18:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025890;
	bh=8/UJ7mr1lbVC8TgTPdpKMSRtNiqA0V0bUrURQqgVoPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jRhEvu/Gk50jDfJe8upHNEvOyY/c6aO6BwfthkKf81liCdLzGLTViw2W6eklcuoPM
	 5BPbU6+nKFGUkGo/2VoQO3Joe96sZ0zjDhx/oP8dIJYWqjyPRQjpydKBeDXXLOD9i9
	 T6otTAqkl805GKD7Kes+eFIDHZ7oyznZVo1Gvv6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1238/2151] wifi: mt76: mt7996: refuse scan and ROC until the hardware restart is done
Date: Wed, 18 Nov 2026 15:49:33 +0100
Message-ID: <20261118150207.275420925@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 3807d0bfeef650d2b3b567e36d218b4cb3e31d4b ]

mt7996_mac_restart() clears MT76_MCU_RESET before it loads the firmware
again, and mac80211 adds the interfaces back only later, in
ieee80211_reconfig() after ieee80211_restart_hw(). A scan or remain on
channel that reaches mt76_hw_scan() or mt76_remain_on_channel() in
between, for example a request that waited for dev->mutex during the
reset, runs on a device that has no interfaces configured.

Mark a full reset with MT76_RESTART and refuse a scan or remain on
channel while it is set. Clear the flag in .start: ieee80211_reconfig()
adds the interfaces back before it releases the wiphy lock, so no
request runs in between. .reconfig_complete is not suitable, because
mac80211 skips it when no interface is open, and the flag would then
stay set.

Fixes: c56d6edebc1f ("wifi: mt76: mt7996: use emulated hardware scan support")
Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Link: https://patch.msgid.link/20261007112419.1277594-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c     |    3 ++-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c  |    1 +
 drivers/net/wireless/mediatek/mt76/mt7996/main.c |    2 ++
 drivers/net/wireless/mediatek/mt76/scan.c        |    3 ++-
 4 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -386,7 +386,8 @@ int mt76_remain_on_channel(struct ieee80
 	mutex_lock(&dev->mutex);
 
 	if (phy->roc_vif || dev->scan.phy == phy ||
-	    test_bit(MT76_MCU_RESET, &dev->phy.state)) {
+	    test_bit(MT76_MCU_RESET, &dev->phy.state) ||
+	    test_bit(MT76_RESTART, &dev->phy.state)) {
 		ret = -EBUSY;
 		goto out;
 	}
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2525,6 +2525,7 @@ mt7996_mac_full_reset(struct mt7996_dev
 
 	dev->recovery.hw_full_reset = true;
 
+	set_bit(MT76_RESTART, &dev->mphy.state);
 	set_bit(MT76_MCU_RESET, &dev->mphy.state);
 	wake_up(&dev->mt76.mcu.wait);
 	ieee80211_stop_queues(hw);
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -59,6 +59,8 @@ static int mt7996_start(struct ieee80211
 
 	flush_work(&dev->init_work);
 
+	clear_bit(MT76_RESTART, &dev->mphy.state);
+
 	mutex_lock(&dev->mt76.mutex);
 	ret = mt7996_mcu_set_hdr_trans(dev, true);
 	if (!ret && is_mt7992(&dev->mt76)) {
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -210,7 +210,8 @@ int mt76_hw_scan(struct ieee80211_hw *hw
 	mutex_lock(&dev->mutex);
 
 	if (dev->scan.req || phy->roc_vif ||
-	    test_bit(MT76_MCU_RESET, &dev->phy.state)) {
+	    test_bit(MT76_MCU_RESET, &dev->phy.state) ||
+	    test_bit(MT76_RESTART, &dev->phy.state)) {
 		ret = -EBUSY;
 		goto out;
 	}


