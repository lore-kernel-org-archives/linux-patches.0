Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB3B3803C3;
	Sat, 12 Sep 2026 08:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201202; cv=none; b=QqeJ1oUQbLxt2dk75ApTbBxtDp6tHGxGQC9V928z8XuCaDbPDnUWqEYt5oCFwvx2DzLzshhsuLnooSslXWffoyK6Eh2UDGkUBBLhMGuvsk+q1vuG5u+BRZd3NXRpMN6KB3nE3ibPqOmWb0j+xNBc4Sdyv1quMrHhVmqSpelFl50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201202; c=relaxed/simple;
	bh=dJ3/IFh6w7Cd0X8sZ6nuRJk4gAQryQIBTzWGDmGimec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myGj1c1665UnFK0A3xswmhAl0jElXsCX1qIKhIGY8ODn10YTPvcpe95j2PmSDalTNYWVVUwjl5ewXeT7gzVlJ9MvoABGm5lIx1cU6zu8GHkVRJ35j+PS8KEET1zrtOf1GoXn0Fml0M5Qy2GTy3eu07fVyYkTIw93d4QFhol8UDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuzqTUlO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuzqTUlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677611F000FF;
	Sat, 12 Sep 2026 08:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201201;
	bh=FfZjIUG6JrbV4qpV5bJBtdsIVeKXQAgV+zsV91sMHVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uuzqTUlOBzPhLNTrqCwUXffiRhyLrsyOHZSXCDWStjjEGfu7eZtlv+UDK9KP6Sfct
	 i3MCQCicjVK55ZUhbpIKcfp8kdDU9UTMDVdkZIAe0xtoRbpJ2vB0AgnJiKoP7srjq6
	 U04n8ZRc5A6pCiZAlQe4pIk8b7JdAoDa4w8rhMa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0947/1815] wifi: mt76: mt7915: fix chainmask handling for non-dbdc phys on band 1
Date: Sat, 12 Sep 2026 08:44:57 +0200
Message-ID: <20260912065711.190221066@linuxfoundation.org>
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

[ Upstream commit ea891799eccc9e43ebba0dc157d4b197ad6c1a0e ]

On single-adie mt7986 the only phy is bound to band 1, but its chainmask
is stored unshifted, because dev->chainshift is still zero while the
eeprom is parsed for the main phy. mt7915_set_antenna() on the other
hand shifts by chainshift * band_idx, so the representation of the
chainmask changed as soon as the antenna configuration was touched.
Until then, mt7915_mcu_set_chan_info() passed rx_path = 0 to the
firmware, since shifting the unshifted mask down clears all bits.

Keep the unshifted form for that case and add helpers for the band local
chainmask, so that only the band 1 phy of a dbdc device uses the shifted
form.

Fixes: 3eb50cc90534 ("wifi: mt76: mt7915: rely on band_idx of mt76_phy")
Link: https://patch.msgid.link/20260727150434.1778520-8-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/eeprom.c |  2 +-
 .../net/wireless/mediatek/mt76/mt7915/main.c   |  6 +++---
 .../net/wireless/mediatek/mt76/mt7915/mcu.c    |  2 +-
 .../net/wireless/mediatek/mt76/mt7915/mt7915.h | 18 ++++++++++++++++++
 .../wireless/mediatek/mt76/mt7915/testmode.c   |  5 +----
 5 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index eb92cbf1a284b..fe7b29ebc0bfb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -257,7 +257,7 @@ void mt7915_eeprom_parse_hw_cap(struct mt7915_dev *dev,
 	nss = min_t(u8, min_t(u8, nss_max, nss), path);
 
 	mphy->chainmask = BIT(path) - 1;
-	if (band)
+	if (band && dev->dbdc_support)
 		mphy->chainmask <<= dev->chainshift;
 	mphy->antenna_mask = BIT(nss) - 1;
 	dev->chainmask |= mphy->chainmask;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index d2130226de648..4783e5f52d229 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -1138,7 +1138,7 @@ mt7915_set_antenna(struct ieee80211_hw *hw, int radio_idx, u32 tx_ant, u32 rx_an
 	struct mt7915_dev *dev = mt7915_hw_dev(hw);
 	struct mt7915_phy *phy = mt7915_hw_phy(hw);
 	int max_nss = hweight8(hw->wiphy->available_antennas_tx);
-	u8 chainshift = dev->chainshift;
+	u8 shift = mt7915_band_chainshift(phy);
 	u8 band = phy->mt76->band_idx;
 
 	if (!tx_ant || tx_ant != rx_ant || ffs(tx_ant) > max_nss)
@@ -1151,9 +1151,9 @@ mt7915_set_antenna(struct ieee80211_hw *hw, int radio_idx, u32 tx_ant, u32 rx_an
 	/* handle a variant of mt7916/mt7981 which has 3T3R but nss2 on 5 GHz band */
 	if ((is_mt7916(&dev->mt76) || is_mt7981(&dev->mt76)) &&
 	    band && hweight8(tx_ant) == max_nss)
-		phy->mt76->chainmask = (dev->chainmask >> chainshift) << chainshift;
+		phy->mt76->chainmask = (dev->chainmask >> shift) << shift;
 	else
-		phy->mt76->chainmask = tx_ant << (chainshift * band);
+		phy->mt76->chainmask = tx_ant << shift;
 
 	mt76_set_stream_caps(phy->mt76, true);
 	mt7915_set_stream_vht_txbf_caps(phy);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 75eb6d2610332..88955aed62e2b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2804,7 +2804,7 @@ int mt7915_mcu_set_chan_info(struct mt7915_phy *phy, int cmd)
 		.center_ch = ieee80211_frequency_to_channel(freq1),
 		.bw = mt76_connac_chan_bw(chandef),
 		.tx_path_num = hweight16(phy->mt76->chainmask),
-		.rx_path = phy->mt76->chainmask >> (dev->chainshift * band),
+		.rx_path = mt7915_band_chainmask(phy),
 		.band_idx = band,
 		.channel_band = ch_band[chandef->chan->band],
 	};
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index bf1d915a3ca23..43479f6487ede 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -397,6 +397,24 @@ mt7915_ext_phy(struct mt7915_dev *dev)
 	return phy->priv;
 }
 
+/* without dbdc, the chainmask is stored unshifted, even if the phy is
+ * bound to band 1
+ */
+static inline u8 mt7915_band_chainshift(struct mt7915_phy *phy)
+{
+	struct mt7915_dev *dev = phy->dev;
+
+	if (!dev->dbdc_support)
+		return 0;
+
+	return phy->mt76->band_idx * dev->chainshift;
+}
+
+static inline u16 mt7915_band_chainmask(struct mt7915_phy *phy)
+{
+	return phy->mt76->chainmask >> mt7915_band_chainshift(phy);
+}
+
 static inline u32 mt7915_check_adie(struct mt7915_dev *dev, bool sku)
 {
 	u32 mask = sku ? MT_CONNINFRA_SKU_MASK : MT_ADIE_TYPE_MASK;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
index 618a5c2bdd29f..7576973f4d4ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
@@ -694,9 +694,7 @@ mt7915_tm_set_params(struct mt76_phy *mphy, struct nlattr **tb,
 {
 	struct mt76_testmode_data *td = &mphy->test;
 	struct mt7915_phy *phy = mphy->priv;
-	struct mt7915_dev *dev = phy->dev;
-	u32 chainmask = mphy->chainmask, changed = 0;
-	bool ext_phy = phy != &dev->phy;
+	u32 chainmask = mt7915_band_chainmask(phy), changed = 0;
 	int i;
 
 	BUILD_BUG_ON(NUM_TM_CHANGED >= 32);
@@ -705,7 +703,6 @@ mt7915_tm_set_params(struct mt76_phy *mphy, struct nlattr **tb,
 	    td->state == MT76_TM_STATE_OFF)
 		return 0;
 
-	chainmask = ext_phy ? chainmask >> dev->chainshift : chainmask;
 	if (td->tx_antenna_mask > chainmask)
 		return -EINVAL;
 
-- 
2.53.0



