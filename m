Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019252;
	b=rGbCWRaeP3xLNp0tfPFTuLx6Y4kKkJbKodTXlxmMSYyxapdN5CAOXptHkBoaL4lC5o+K
	 TJdLE541jYBal/tmDxqUMUNAIGgESltESHXoIvnkttUF4WJECxzqIFJ30+5UFFKCktTqv
	 gN31yY0w+GsvMgdVjDlU6NXIhBNWsA6Ar4UVgG3po632BC9I0y7rwZ1JaHS6dxVIXvg8e
	 gTD6rI7sToYqE6mQ+06UHbkDKKxoAwyKiaCfJNtpMC6DFB/3iiyKsufN+Z2217xVJ8WiL
	 XTJlOH/co+vKalPPQWVzJgataC+2YpQcHXyFLGVMFtx03F1PCEZNNw1T9J+ovCjke1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fv1O8HEqwb0Ki74/TRaZVoyRSY0GsTvb6uc09/5c4YU=;
	b=MRwLDeoh2IjQeIYlay3hsYfUMT55EzNzslh23/7n86aRWoVPOu0KRgDxg2rviQ2TqUAx
	 fmg7quyc5oNgFXf396wcVZZHmsDW9fOIjIcuzw7suzRBrKePsNxdQkss5ivn9oGXT0f+z
	 wBnrWlUhcxA0OThf1+DYFryb4hnRo3MmQtkg4ga8KeHl8GkR+hGQHWGg+b/oN8V3MSVHl
	 6bvBE/5N+je2t/UZjmRe3WbsCFvho6wZaaD+2oubbQDFQF+YB1looy8t5hfMQbiyEOi3K
	 BJ7BCBj+No1mYSsm1JTMoCFXSKEBl8NCyqIzFDygxQHSXry4/zDbsoD4cCPd1WPxt0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W1WhpEl1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8190760A261A;
	Wed, 18 Nov 2026 16:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W1WhpEl1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861B21F000C4;
	Wed, 18 Nov 2026 16:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019252;
	bh=Fv1O8HEqwb0Ki74/TRaZVoyRSY0GsTvb6uc09/5c4YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1WhpEl1ENvea8BAo5HCMH/GzTB90vtCoadzJow59kVh2fAkPQ26VpVK/DdIUgQSJ
	 /m8arE/U/+jyXR2DmK98Nb7lawYsq6Xib14+O6mEci0c+q8p+JS7rlIdQbK8WxVDge
	 77eHLBwlPb5rIAlfwSTSGcDFI4r7X89n+kM4OXyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1489/2651] wifi: mt76: mt7996: refuse scan and ROC until the hardware restart is done
Date: Wed, 18 Nov 2026 15:45:29 +0100
Message-ID: <20261118150341.621724532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/wireless/mediatek/mt76/channel.c     | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c  | 1 +
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 2 ++
 drivers/net/wireless/mediatek/mt76/scan.c        | 3 ++-
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 8d4daa76be541..ce1824da75631 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -382,7 +382,8 @@ int mt76_remain_on_channel(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_lock(&dev->mutex);
 
 	if (phy->roc_vif || dev->scan.phy == phy ||
-	    test_bit(MT76_MCU_RESET, &dev->phy.state)) {
+	    test_bit(MT76_MCU_RESET, &dev->phy.state) ||
+	    test_bit(MT76_RESTART, &dev->phy.state)) {
 		ret = -EBUSY;
 		goto out;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index c4e82b1e259c2..ce1e4773bddd2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2467,6 +2467,7 @@ mt7996_mac_full_reset(struct mt7996_dev *dev)
 
 	dev->recovery.hw_full_reset = true;
 
+	set_bit(MT76_RESTART, &dev->mphy.state);
 	set_bit(MT76_MCU_RESET, &dev->mphy.state);
 	wake_up(&dev->mt76.mcu.wait);
 	ieee80211_stop_queues(hw);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index cc65964abbef9..335612c967dd0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -59,6 +59,8 @@ static int mt7996_start(struct ieee80211_hw *hw)
 
 	flush_work(&dev->init_work);
 
+	clear_bit(MT76_RESTART, &dev->mphy.state);
+
 	mutex_lock(&dev->mt76.mutex);
 	ret = mt7996_mcu_set_hdr_trans(dev, true);
 	if (!ret && !is_mt7996(&dev->mt76)) {
diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index c8c4d096c809d..7bf9b7d4a8d7b 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -216,7 +216,8 @@ int mt76_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_lock(&dev->mutex);
 
 	if (dev->scan.req || phy->roc_vif ||
-	    test_bit(MT76_MCU_RESET, &dev->phy.state)) {
+	    test_bit(MT76_MCU_RESET, &dev->phy.state) ||
+	    test_bit(MT76_RESTART, &dev->phy.state)) {
 		ret = -EBUSY;
 		goto out;
 	}
-- 
2.53.0



