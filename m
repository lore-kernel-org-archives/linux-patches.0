Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94183FF1AE;
	Sat, 12 Sep 2026 12:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216955; cv=none; b=mYQApLCDAPW0DRjkeiu0XnCd9eshyY5WxGn3giTEwh9oz2wG6MOL7J98AznSEgcaiVJLghXg1tbTE67Vh0t3O/Rr+Z5TVww/f0uycvoK/HJ0rX7oW40m1ud2lbuCaQ24mi7e8MGdGfqJxNUg9OZ/z8iSS/mA2iqvJUYjLqn7n6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216955; c=relaxed/simple;
	bh=Xb+yDzd+Iex2NymxaO3lDcrYelRX8gkdqtm03ozvZT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSnRuSyxn2eNBWWE6KujucZ4H+KRuoKTp8s6L5QvxzS+D8U18RjXnboIVm8xWHrfh639bFqfUZoGOei2oMZZe4pjFYY7O08MAPckkZdFCRBiPri7RV+CKITIkSVWMP48sXen7YLDQVyTg8j4d86eC+cap/VWaTA489GzlQkFBmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTK0bX/g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTK0bX/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035DA1F000FF;
	Sat, 12 Sep 2026 12:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216954;
	bh=v/tbGSt84e4P8K4Irmz09CrQAa8wk1FjkuN3PzckfCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTK0bX/g2RoZt42reFynzXbeiBGeLIyOtkQKxHUSk9GoKin6CJczNMrhs+cBmPo0S
	 91VKZEtRhv5AKer/IdEChLJYBzqnvl7ir+Jh5Sw2hCiqiGNEyxswdr8YflXQdoNmV/
	 oQlqrR7bqHsuO1XidHt8TxkwgZic6VgBqA3qeyb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0843/1376] wifi: mt76: mt7915: fix chainmask handling for non-dbdc phys on band 1
Date: Sat, 12 Sep 2026 08:54:29 +0200
Message-ID: <20260912065626.337473471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index b038568e0be91..93956d4020414 100644
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
index b065a8938dd5d..0e3ca0eb9f082 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -1072,7 +1072,7 @@ mt7915_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
 	struct mt7915_dev *dev = mt7915_hw_dev(hw);
 	struct mt7915_phy *phy = mt7915_hw_phy(hw);
 	int max_nss = hweight8(hw->wiphy->available_antennas_tx);
-	u8 chainshift = dev->chainshift;
+	u8 shift = mt7915_band_chainshift(phy);
 	u8 band = phy->mt76->band_idx;
 
 	if (!tx_ant || tx_ant != rx_ant || ffs(tx_ant) > max_nss)
@@ -1085,9 +1085,9 @@ mt7915_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
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
index 276cbc7693fef..343866dfc112b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2758,7 +2758,7 @@ int mt7915_mcu_set_chan_info(struct mt7915_phy *phy, int cmd)
 		.center_ch = ieee80211_frequency_to_channel(freq1),
 		.bw = mt76_connac_chan_bw(chandef),
 		.tx_path_num = hweight16(phy->mt76->chainmask),
-		.rx_path = phy->mt76->chainmask >> (dev->chainshift * band),
+		.rx_path = mt7915_band_chainmask(phy),
 		.band_idx = band,
 		.channel_band = ch_band[chandef->chan->band],
 	};
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index f49d6b2f81e42..623b3077ed6f6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -383,6 +383,24 @@ mt7915_ext_phy(struct mt7915_dev *dev)
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
index d534fff5c952b..2a9e5d9ff101c 100644
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



