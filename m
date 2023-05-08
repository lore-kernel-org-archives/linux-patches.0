Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351AF125DF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3527C433EF;
	Mon,  8 May 2023 10:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542298;
	bh=J7z4Szlhuq7ocDEtfQqQ76/huNk6UBi491crF9XH6lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FLfh6Uk+0v1FaVA29BUGy5U13kUv9P98wnHXI2NTcxvx4iI+x7rWkaxyNZ/hAKv7L
	 6lit/X9mj3nTB/cUHAKKYYrsjBo9CSOWd5fZukoNk6BuWfBRSprhPlucVIZRZ38sBo
	 y70MQgm+Sbg5QHA3/H3+TnkxkUVm4DkQzMkDM1xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 391/663] wifi: mt76: mt7915: add error message in mt7915_thermal_set_cur_throttle_state()
Date: Mon,  8 May 2023 11:43:37 +0200
Message-Id: <20230508094440.794016952@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit 2f2d86309e228adfe658c9c0a23c726d8b3ce475 ]

Add dev_err so that it is easier to see invalid setting while looking at
dmesg.

Co-developed-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 9c97df11dfe6 ("wifi: mt76: mt7915: rework init flow in mt7915_thermal_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   | 12 +++++++-----
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |  2 ++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 916d6c7c569d3..db0a35974ca7e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -146,8 +146,11 @@ mt7915_thermal_set_cur_throttle_state(struct thermal_cooling_device *cdev,
 	u8 throttling = MT7915_THERMAL_THROTTLE_MAX - state;
 	int ret;
 
-	if (state > MT7915_CDEV_THROTTLE_MAX)
+	if (state > MT7915_CDEV_THROTTLE_MAX) {
+		dev_err(phy->dev->mt76.dev,
+			"please specify a valid throttling state\n");
 		return -EINVAL;
+	}
 
 	if (state == phy->cdev_state)
 		return 0;
@@ -176,7 +179,7 @@ static void mt7915_unregister_thermal(struct mt7915_phy *phy)
 	struct wiphy *wiphy = phy->mt76->hw->wiphy;
 
 	if (!phy->cdev)
-	    return;
+		return;
 
 	sysfs_remove_link(&wiphy->dev.kobj, "cooling_device");
 	thermal_cooling_device_unregister(phy->cdev);
@@ -210,8 +213,8 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 		return PTR_ERR(hwmon);
 
 	/* initialize critical/maximum high temperature */
-	phy->throttle_temp[MT7915_CRIT_TEMP_IDX] = 110;
-	phy->throttle_temp[MT7915_MAX_TEMP_IDX] = 120;
+	phy->throttle_temp[MT7915_CRIT_TEMP_IDX] = MT7915_CRIT_TEMP;
+	phy->throttle_temp[MT7915_MAX_TEMP_IDX] = MT7915_MAX_TEMP;
 
 	return 0;
 }
@@ -1112,7 +1115,6 @@ static void mt7915_stop_hardware(struct mt7915_dev *dev)
 		mt7986_wmac_disable(dev);
 }
 
-
 int mt7915_register_device(struct mt7915_dev *dev)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index e58650bbbd14a..942d70c538254 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -72,6 +72,8 @@
 
 #define MT7915_CRIT_TEMP_IDX		0
 #define MT7915_MAX_TEMP_IDX		1
+#define MT7915_CRIT_TEMP		110
+#define MT7915_MAX_TEMP			120
 
 struct mt7915_vif;
 struct mt7915_sta;
-- 
2.39.2



