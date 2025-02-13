Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF422281369;
	Thu, 13 Feb 2025 14:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457759; cv=none; b=Jg4MV82Li3Ihtl05Gds1OSNq3rAjgMmi0xniB+QECVk0Tcrclwk/QrtZk0fe00CIXg8ZFAYl6Nj2pqgJ4K0tPsSd0xkq3q/f3jggMSEVjPPGVWuz28fPSsck8x/3STCOhnjVec8celDw3qCTnBvLwJ4ZqswrlVFMXNsFr7PCg6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457759; c=relaxed/simple;
	bh=39Ga2weunWJpBVD/QDK+l+bvA3lOEAlQXGK8a2+PoW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5wgVTciyyixbyjfaFkEu+JGnkcccFdXLTlVWkYHsNRSKzPzW+HxRxpPupbNcHb4Rho5WICfQIYZmgM5mSDqamImhBXd42WwzvaLo50J72Rf9C8qA6OXbJikoEyLPGD82p7chrknLqcz97QEs6JtuXm2/xsojC9ErFctBBZVRHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKQ89lq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKQ89lq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CB7C4CED1;
	Thu, 13 Feb 2025 14:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457758;
	bh=39Ga2weunWJpBVD/QDK+l+bvA3lOEAlQXGK8a2+PoW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yKQ89lq5IAv5xNO2qHftmMkg3FGeKmJeFtX748RPaRQj8TwjQApyL5rv0n1NHm4U+
	 4rAxYucNOXe8zeWmkpxd7PiUpB9FpglEOkDF27rBDk6ryUlDNvLB2ZK2i+fZayu9PQ
	 IGIQN9+OZw3D+xviPvs90omdJXJLrxJtiqr1s6yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 206/422] wifi: mt76: mt7915: add module param to select 5 GHz or 6 GHz on MT7916
Date: Thu, 13 Feb 2025 15:25:55 +0100
Message-ID: <20250213142444.491089252@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shayne Chen <shayne.chen@mediatek.com>

commit 57af267d2b8f5d88485c6372761386d79c5e6a1a upstream.

Due to a limitation in available memory, the MT7916 firmware can only
handle either 5 GHz or 6 GHz at a time. It does not support runtime
switching without a full restart.

On older firmware, this accidentally worked to some degree due to missing
checks, but couldn't be supported properly, because it left the 6 GHz
channels uncalibrated.
Newer firmware refuses to start on either band if the passed EEPROM
data indicates support for both.

Deal with this limitation by using a module parameter to specify the
preferred band in case both are supported.

Fixes: b4d093e321bd ("mt76: mt7915: add 6 GHz support")
Cc: stable@vger.kernel.org
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20241010083816.51880-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   21 +++++++++++++++++++--
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |    4 ++--
 2 files changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -2,9 +2,14 @@
 /* Copyright (C) 2020 MediaTek Inc. */
 
 #include <linux/firmware.h>
+#include <linux/moduleparam.h>
 #include "mt7915.h"
 #include "eeprom.h"
 
+static bool enable_6ghz;
+module_param(enable_6ghz, bool, 0644);
+MODULE_PARM_DESC(enable_6ghz, "Enable 6 GHz instead of 5 GHz on hardware that supports both");
+
 static int mt7915_eeprom_load_precal(struct mt7915_dev *dev)
 {
 	struct mt76_dev *mdev = &dev->mt76;
@@ -170,8 +175,20 @@ static void mt7915_eeprom_parse_band_con
 			phy->mt76->cap.has_6ghz = true;
 			return;
 		case MT_EE_V2_BAND_SEL_5GHZ_6GHZ:
-			phy->mt76->cap.has_5ghz = true;
-			phy->mt76->cap.has_6ghz = true;
+			if (enable_6ghz) {
+				phy->mt76->cap.has_6ghz = true;
+				u8p_replace_bits(&eeprom[MT_EE_WIFI_CONF + band],
+						 MT_EE_V2_BAND_SEL_6GHZ,
+						 MT_EE_WIFI_CONF0_BAND_SEL);
+			} else {
+				phy->mt76->cap.has_5ghz = true;
+				u8p_replace_bits(&eeprom[MT_EE_WIFI_CONF + band],
+						 MT_EE_V2_BAND_SEL_5GHZ,
+						 MT_EE_WIFI_CONF0_BAND_SEL);
+			}
+			/* force to buffer mode */
+			dev->flash_mode = true;
+
 			return;
 		default:
 			phy->mt76->cap.has_2ghz = true;
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -1239,14 +1239,14 @@ int mt7915_register_device(struct mt7915
 	if (ret)
 		goto unreg_dev;
 
-	ieee80211_queue_work(mt76_hw(dev), &dev->init_work);
-
 	if (phy2) {
 		ret = mt7915_register_ext_phy(dev, phy2);
 		if (ret)
 			goto unreg_thermal;
 	}
 
+	ieee80211_queue_work(mt76_hw(dev), &dev->init_work);
+
 	dev->recovery.hw_init_done = true;
 
 	ret = mt7915_init_debugfs(&dev->phy);


