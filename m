Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06D6339B0
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3ZrstCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6F8C433C9;
	Mon,  9 Oct 2023 13:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859073;
	bh=R2Bxs++StwPescDV36BWg/q6EdtZmaQfv5J3k1qlnEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3ZrstCXXXvKEY12NjpxikvDx7/pbEtKGfdRz+yGg5u9PhffnTW+sAbKutiCkTG/7
	 uDuY57nYY5ziyGcjJ1IZlaBZRLVH+L7SE+zCbj0/JzWSdWRkLpZMxR9xwj5ZHVXN+t
	 hzeFGVpwwYnSuh/sppCOizisDEMtNk9Y3JABV+9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Felix Fietkau <nbd@nbd.name>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/226] wifi: mt76: mt76x02: fix MT76x0 external LNA gain handling
Date: Mon,  9 Oct 2023 15:02:32 +0200
Message-ID: <20231009130131.600232680@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 684e45e120b82deccaf8b85633905304a3bbf56d ]

On MT76x0, LNA gain should be applied for both external and internal LNA.
On MT76x2, LNA gain should be treated as 0 for external LNA.
Move the LNA type based logic to mt76x2 in order to fix mt76x0.

Fixes: 2daa67588f34 ("mt76x0: unify lna_gain parsing")
Reported-by: Shiji Yang <yangshiji66@outlook.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230919194747.31647-1-nbd@nbd.name
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c |  7 -------
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c  | 13 +++++++++++--
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
index 0acabba2d1a50..5d402cf2951cb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
@@ -131,15 +131,8 @@ u8 mt76x02_get_lna_gain(struct mt76x02_dev *dev,
 			s8 *lna_2g, s8 *lna_5g,
 			struct ieee80211_channel *chan)
 {
-	u16 val;
 	u8 lna;
 
-	val = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_1);
-	if (val & MT_EE_NIC_CONF_1_LNA_EXT_2G)
-		*lna_2g = 0;
-	if (val & MT_EE_NIC_CONF_1_LNA_EXT_5G)
-		memset(lna_5g, 0, sizeof(s8) * 3);
-
 	if (chan->band == NL80211_BAND_2GHZ)
 		lna = *lna_2g;
 	else if (chan->hw_value <= 64)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
index 410ffce3bafff..60478116014f8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
@@ -256,7 +256,8 @@ void mt76x2_read_rx_gain(struct mt76x02_dev *dev)
 	struct ieee80211_channel *chan = dev->mphy.chandef.chan;
 	int channel = chan->hw_value;
 	s8 lna_5g[3], lna_2g;
-	u8 lna;
+	bool use_lna;
+	u8 lna = 0;
 	u16 val;
 
 	if (chan->band == NL80211_BAND_2GHZ)
@@ -275,7 +276,15 @@ void mt76x2_read_rx_gain(struct mt76x02_dev *dev)
 	dev->cal.rx.mcu_gain |= (lna_5g[1] & 0xff) << 16;
 	dev->cal.rx.mcu_gain |= (lna_5g[2] & 0xff) << 24;
 
-	lna = mt76x02_get_lna_gain(dev, &lna_2g, lna_5g, chan);
+	val = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_1);
+	if (chan->band == NL80211_BAND_2GHZ)
+		use_lna = !(val & MT_EE_NIC_CONF_1_LNA_EXT_2G);
+	else
+		use_lna = !(val & MT_EE_NIC_CONF_1_LNA_EXT_5G);
+
+	if (use_lna)
+		lna = mt76x02_get_lna_gain(dev, &lna_2g, lna_5g, chan);
+
 	dev->cal.rx.lna_gain = mt76x02_sign_extend(lna, 8);
 }
 EXPORT_SYMBOL_GPL(mt76x2_read_rx_gain);
-- 
2.40.1



