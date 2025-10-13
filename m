Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F63305043;
	Mon, 13 Oct 2025 15:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369769; cv=none; b=d5XqHrJR0bqS5/TLmHpA6N97My/kYhCphbug66DKzcmNkaPL6mK4N0XUw5MApNgdz0TGufhLp24k5aMm8QoO0TMissJIPUXmY2o9vNaaY4LzVP/vaRRT0tM1+ycM+S/d/V7Fa6RN3QbapzNkDdV57wSWzQDvTHvufU0ouKRiPWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369769; c=relaxed/simple;
	bh=ebzcmgxTGLMvVqTwX7UIy9nRl2YvK0Zek3B6BD943kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJV97+/FBkG8TJ+CD/SvSE5BlfHcGW2mqsH3LtaNSOFt0uXvycKGmOCZN751NKlfpsnv4A/1zT3xlz1AqjBjQqkYdkbVk5qZiKxUXXiBfU2sk1EXcfplH4NHNU9PKPw3XukfaGHOhvDbp+Vlda5G1xrSWZ9OXxh5c/eiGx1glGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DnSbfkmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DnSbfkmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C8CC4CEE7;
	Mon, 13 Oct 2025 15:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369768;
	bh=ebzcmgxTGLMvVqTwX7UIy9nRl2YvK0Zek3B6BD943kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DnSbfkmTAWzkVoB5SeNa/Yhi1E2LxpiHV9kyPGa5Faee6QT0rlEn/gbsCHDZIeSzp
	 x6MBlI1RqzNdt/YA+meTx4tjEZxUPn+zlR+9gklNqMV/F+FdWk0dIxrP2/okxGvhMZ
	 KKBd4Bb7l4fWKIUG637PW/TnSIdHUgs/goTdGH8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi-Jun You <hujy652@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 361/563] wifi: mt76: mt7915: fix mt7981 pre-calibration
Date: Mon, 13 Oct 2025 16:43:42 +0200
Message-ID: <20251013144424.357060040@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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
index 31aec0f40232a..73611c9d26e15 100644
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
 #define MT_EE_WIFI_CONF0_RX_PATH		GENMASK(5, 3)
@@ -180,6 +180,8 @@ mt7915_get_cal_group_size(struct mt7915_dev *dev)
 		val = FIELD_GET(MT_EE_WIFI_CONF0_BAND_SEL, val);
 		return (val == MT_EE_V2_BAND_SEL_6GHZ) ? MT_EE_CAL_GROUP_SIZE_7916_6G :
 							 MT_EE_CAL_GROUP_SIZE_7916;
+	} else if (is_mt7981(&dev->mt76)) {
+		return MT_EE_CAL_GROUP_SIZE_7981;
 	} else if (mt7915_check_adie(dev, false)) {
 		return MT_EE_CAL_GROUP_SIZE_7976;
 	} else {
@@ -192,8 +194,6 @@ mt7915_get_cal_dpd_size(struct mt7915_dev *dev)
 {
 	if (is_mt7915(&dev->mt76))
 		return MT_EE_CAL_DPD_SIZE_V1;
-	else if (is_mt7981(&dev->mt76))
-		return MT_EE_CAL_DPD_SIZE_V2_7981;
 	else
 		return MT_EE_CAL_DPD_SIZE_V2;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 2928e75b23976..c1fdd3c4f1ba6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -3052,30 +3052,15 @@ static int mt7915_dpd_freq_idx(struct mt7915_dev *dev, u16 freq, u8 bw)
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



