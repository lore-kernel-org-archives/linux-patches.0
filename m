Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5A730CDAE;
	Mon, 13 Oct 2025 15:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368403; cv=none; b=Ah/kavKq/OQgxpLX0ZaszfPDYYKMluQpkTQX8xlEfwcD9RwU3WDToYgWqtYcgH1Jx8Tzzq6WuMFgHnYvENW4s30qD58crro8ff9+TLstC1hYEMsqfd5mERP3vk+y5LJnN25mUrXTmUrsQ9GPiRqz1EOr58d7a+dOsSOe8YslFpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368403; c=relaxed/simple;
	bh=KmtLCaZpDEofzXuaHglK+nW3BdRvcwPpu0rqnEJ7E8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPdXNImuL1dodeBdxIcwx2d+87JXEY7lTe0hud7OjAuvTvJ6KPQzGuVAChaTfA+rx2/xM+w+5wqxI5jp9ih2cWVJg5UDRXZ7lWik8eSzA8SLjW5wMp7fmEqS9CAuL017cJZTTp3oydZsO1iXOGGn9d2FmktFk8H6ofGa+ic0P4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbNUgARl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbNUgARl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B4FC4CEFE;
	Mon, 13 Oct 2025 15:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368403;
	bh=KmtLCaZpDEofzXuaHglK+nW3BdRvcwPpu0rqnEJ7E8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbNUgARloUnI9Wj2nG89mG8x6a/3bJhR0bwybN3Ua6zPq7j4z7w/pF4JXSIfHaI+w
	 a8C0eqNYbLxzyHaJU300WNyLdvi1Ly9Gf2Tot1TDowGStivD4oen4zcm/Lz+kSLAXm
	 sLRQfGgAS11iiya9y+9pqgFRTJy98WMVBw3N8npc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi-Jun You <hujy652@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/262] wifi: mt76: mt7915: fix mt7981 pre-calibration
Date: Mon, 13 Oct 2025 16:44:52 +0200
Message-ID: <20251013144331.523438630@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi-Jun You <hujy652@gmail.com>

[ Upstream commit 2b660ee10a0c25b209d7fda3c41b821b75dd85d9 ]

In vendor driver, size of group cal and dpd cal for mt7981 includes 6G
although the chip doesn't support it.

mt76 doesn't take this into account which results in reading from the
incorrect offset.

For devices with precal, this would lead to lower bitrate.

Fix this by aligning groupcal size with vendor driver and switch to
freq_list_v2 in mt7915_dpd_freq_idx in order to get the correct offset.

Below are iwinfo of the test device with two clients connected
(iPhone 16, Intel AX210).
Before :
	Mode: Master  Channel: 36 (5.180 GHz)  HT Mode: HE80
	Center Channel 1: 42 2: unknown
	Tx-Power: 23 dBm  Link Quality: 43/70
	Signal: -67 dBm  Noise: -92 dBm
	Bit Rate: 612.4 MBit/s
	Encryption: WPA3 SAE (CCMP)
	Type: nl80211  HW Mode(s): 802.11ac/ax/n
	Hardware: embedded [MediaTek MT7981]

After:
	Mode: Master  Channel: 36 (5.180 GHz)  HT Mode: HE80
	Center Channel 1: 42 2: unknown
	Tx-Power: 23 dBm  Link Quality: 43/70
	Signal: -67 dBm  Noise: -92 dBm
	Bit Rate: 900.6 MBit/s
	Encryption: WPA3 SAE (CCMP)
	Type: nl80211  HW Mode(s): 802.11ac/ax/n
	Hardware: embedded [MediaTek MT7981]

Tested-on: mt7981 20240823

Fixes: 19a954edec63 ("wifi: mt76: mt7915: add mt7986, mt7916 and mt7981 pre-calibration")
Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
Link: https://patch.msgid.link/20250909064824.16847-1-hujy652@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt7915/eeprom.h    |  6 ++--
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 29 +++++--------------
 2 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
index 509fb43d8a688..2908e8113e48a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h
@@ -50,9 +50,9 @@ enum mt7915_eeprom_field {
 #define MT_EE_CAL_GROUP_SIZE_7975		(54 * MT_EE_CAL_UNIT + 16)
 #define MT_EE_CAL_GROUP_SIZE_7976		(94 * MT_EE_CAL_UNIT + 16)
 #define MT_EE_CAL_GROUP_SIZE_7916_6G		(94 * MT_EE_CAL_UNIT + 16)
+#define MT_EE_CAL_GROUP_SIZE_7981		(144 * MT_EE_CAL_UNIT + 16)
 #define MT_EE_CAL_DPD_SIZE_V1			(54 * MT_EE_CAL_UNIT)
 #define MT_EE_CAL_DPD_SIZE_V2			(300 * MT_EE_CAL_UNIT)
-#define MT_EE_CAL_DPD_SIZE_V2_7981		(102 * MT_EE_CAL_UNIT)	/* no 6g dpd data */
 
 #define MT_EE_WIFI_CONF0_TX_PATH		GENMASK(2, 0)
 #define MT_EE_WIFI_CONF0_BAND_SEL		GENMASK(7, 6)
@@ -179,6 +179,8 @@ mt7915_get_cal_group_size(struct mt7915_dev *dev)
 		val = FIELD_GET(MT_EE_WIFI_CONF0_BAND_SEL, val);
 		return (val == MT_EE_V2_BAND_SEL_6GHZ) ? MT_EE_CAL_GROUP_SIZE_7916_6G :
 							 MT_EE_CAL_GROUP_SIZE_7916;
+	} else if (is_mt7981(&dev->mt76)) {
+		return MT_EE_CAL_GROUP_SIZE_7981;
 	} else if (mt7915_check_adie(dev, false)) {
 		return MT_EE_CAL_GROUP_SIZE_7976;
 	} else {
@@ -191,8 +193,6 @@ mt7915_get_cal_dpd_size(struct mt7915_dev *dev)
 {
 	if (is_mt7915(&dev->mt76))
 		return MT_EE_CAL_DPD_SIZE_V1;
-	else if (is_mt7981(&dev->mt76))
-		return MT_EE_CAL_DPD_SIZE_V2_7981;
 	else
 		return MT_EE_CAL_DPD_SIZE_V2;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 3398c25cb03c0..7b481aea76b6c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -3004,30 +3004,15 @@ static int mt7915_dpd_freq_idx(struct mt7915_dev *dev, u16 freq, u8 bw)
 		/* 5G BW160 */
 		5250, 5570, 5815
 	};
-	static const u16 freq_list_v2_7981[] = {
-		/* 5G BW20 */
-		5180, 5200, 5220, 5240,
-		5260, 5280, 5300, 5320,
-		5500, 5520, 5540, 5560,
-		5580, 5600, 5620, 5640,
-		5660, 5680, 5700, 5720,
-		5745, 5765, 5785, 5805,
-		5825, 5845, 5865, 5885,
-		/* 5G BW160 */
-		5250, 5570, 5815
-	};
-	const u16 *freq_list = freq_list_v1;
-	int n_freqs = ARRAY_SIZE(freq_list_v1);
-	int idx;
+	const u16 *freq_list;
+	int idx, n_freqs;
 
 	if (!is_mt7915(&dev->mt76)) {
-		if (is_mt7981(&dev->mt76)) {
-			freq_list = freq_list_v2_7981;
-			n_freqs = ARRAY_SIZE(freq_list_v2_7981);
-		} else {
-			freq_list = freq_list_v2;
-			n_freqs = ARRAY_SIZE(freq_list_v2);
-		}
+		freq_list = freq_list_v2;
+		n_freqs = ARRAY_SIZE(freq_list_v2);
+	} else {
+		freq_list = freq_list_v1;
+		n_freqs = ARRAY_SIZE(freq_list_v1);
 	}
 
 	if (freq < 4000) {
-- 
2.51.0



