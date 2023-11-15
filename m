Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D31D41A81
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmTXCcx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658DEC433C7;
	Wed, 15 Nov 2023 19:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077003;
	bh=TPZm0mSm6bjwztH4Lhz0nOJJlvGYksdwBXD7Nn/Iegc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmTXCcx/p+JoQpJtlFYw7/HJfPiOI/VSzsJw23EVQqetFMpzBU9H3g/QHBYEUKvmM
	 iklZ7OmIMgsKxfdMQaREja6KiGg6aPV5LgnwBB5yryLp/3aV419X+PDBhtRJZ1DT4u
	 wn6Jn9PObDYAJFqPxj1ycrkvVEm7Mr+tNYBq5FxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	David Ruth <druth@chromium.org>,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/603] wifi: mt76: mt7921: fix the wrong rate pickup for the chanctx driver
Date: Wed, 15 Nov 2023 14:10:40 -0500
Message-ID: <20231115191619.739257859@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 32b1000db221df33ec8b57794a091ba6075b6c28 ]

The variable band should be determined by the ieee80211_chanctx_conf when
the driver is a kind of chanctx one e.g mt7921 and mt7922 driver so we
added the extension to mt76_connac2_mac_tx_rate_val by distinguishing if
it can support chanctx to fix the incorrect rate pickup.

Fixes: 41ac53c899bd ("wifi: mt76: mt7921: introduce chanctx support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Reviewed-by: David Ruth <druth@chromium.org>
Tested-by: David Ruth <druth@chromium.org>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c        | 9 +++++++--
 drivers/net/wireless/mediatek/mt76/mt76.h            | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c | 7 +++++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index d158320bc15db..dbab400969202 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1697,11 +1697,16 @@ mt76_init_queue(struct mt76_dev *dev, int qid, int idx, int n_desc,
 }
 EXPORT_SYMBOL_GPL(mt76_init_queue);
 
-u16 mt76_calculate_default_rate(struct mt76_phy *phy, int rateidx)
+u16 mt76_calculate_default_rate(struct mt76_phy *phy,
+				struct ieee80211_vif *vif, int rateidx)
 {
+	struct mt76_vif *mvif = (struct mt76_vif *)vif->drv_priv;
+	struct cfg80211_chan_def *chandef = mvif->ctx ?
+					    &mvif->ctx->def :
+					    &phy->chandef;
 	int offset = 0;
 
-	if (phy->chandef.chan->band != NL80211_BAND_2GHZ)
+	if (chandef->chan->band != NL80211_BAND_2GHZ)
 		offset = 4;
 
 	/* pick the lowest rate for hidden nodes */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 13ed07c5ccc60..dae5410d67e83 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1101,7 +1101,8 @@ int mt76_get_of_eeprom(struct mt76_dev *dev, void *data, int offset, int len);
 struct mt76_queue *
 mt76_init_queue(struct mt76_dev *dev, int qid, int idx, int n_desc,
 		int ring_base, u32 flags);
-u16 mt76_calculate_default_rate(struct mt76_phy *phy, int rateidx);
+u16 mt76_calculate_default_rate(struct mt76_phy *phy,
+				struct ieee80211_vif *vif, int rateidx);
 static inline int mt76_init_tx_queue(struct mt76_phy *phy, int qid, int idx,
 				     int n_desc, int ring_base, u32 flags)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index 73db9e14db06c..87479c6c2b505 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -293,7 +293,10 @@ u16 mt76_connac2_mac_tx_rate_val(struct mt76_phy *mphy,
 				 struct ieee80211_vif *vif,
 				 bool beacon, bool mcast)
 {
-	u8 nss = 0, mode = 0, band = mphy->chandef.chan->band;
+	struct mt76_vif *mvif = (struct mt76_vif *)vif->drv_priv;
+	struct cfg80211_chan_def *chandef = mvif->ctx ?
+					    &mvif->ctx->def : &mphy->chandef;
+	u8 nss = 0, mode = 0, band = chandef->chan->band;
 	int rateidx = 0, mcast_rate;
 
 	if (!vif)
@@ -326,7 +329,7 @@ u16 mt76_connac2_mac_tx_rate_val(struct mt76_phy *mphy,
 		rateidx = ffs(vif->bss_conf.basic_rates) - 1;
 
 legacy:
-	rateidx = mt76_calculate_default_rate(mphy, rateidx);
+	rateidx = mt76_calculate_default_rate(mphy, vif, rateidx);
 	mode = rateidx >> 8;
 	rateidx &= GENMASK(7, 0);
 out:
-- 
2.42.0



