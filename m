Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CBF367B60;
	Sat, 12 Sep 2026 08:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201001; cv=none; b=boMKibYxb8sDE5Hw3J2twYLgw/n8gnsLFJbLcqYGcE4UGKYNRuL/o6w136Pkfh7prQ4u67FRg74OgoNvSXqGSWL+bb/4j6D1Q2vcDJ0RcP2qVNAHWoFcMuyzluZkFyqRNmzSM8L71Zp1i9+jFyknGdKivN099fRPWlSOfYR1IXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201001; c=relaxed/simple;
	bh=v3kmYD/0A9ZlsALoC771i6iMc1CxVpizpaBZKmVNACY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4h+zKVWjP0MvJR33ZV9GGOr1zm4jy9Qlpw3Ur+tYrLjBvXoYbvALjGSeyWn9i3RDDaRGUoLVJuka8HcbJgdmfMSM5HnoNG9WVCTBbWkAjml4QnFw01nfKkL7QAJpc2irXjlnVws82ZHS8oYF1goY90aAyeDKF6OiGud07QbDlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysGAbIVu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysGAbIVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D996B1F000FF;
	Sat, 12 Sep 2026 08:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200999;
	bh=a6ZmW5yKyPO6MZ7po/ZDCrY7PeZnXu1QW+XwLfPmMx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysGAbIVuoo8NE+E5Z1ekLV1kLXQ78MhFwaiMoE/yNvuNyU/R9M7k7OZJIcCjQ2wAD
	 FMMOGVrzBz5aJ+WTlxJ9G5sDBfAnV8CrmxgXe2FJJ9/iW4hmA/hoM/R+kBW2xbtKSQ
	 loNFGTG9xUdtv2UZI49XUdntcZO1JZ0C/FF9C1kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0869/1815] wifi: mt76: mt7927: set band index for sniffer mode
Date: Sat, 12 Sep 2026 08:43:39 +0200
Message-ID: <20260912065709.323473116@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit c410102bbff0803c9dc44056b917aff90abcbaec ]

Use the active channel context to select the SNIFFER command band index on
MT7927, and fall back to the PHY chandef when no channel context is
available.

Also pass the same band index to the sniffer channel configuration. This
keeps monitor setup on the correct band, especially when multiple PHY band
contexts are present.

Fixes: 35a5dcc71735 ("wifi: mt76: mt7925: add MT7927 PCIe support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260613225144.2414283-1-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index cb265a6fc7adb..ba43826a25ecd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2174,6 +2174,8 @@ int mt7925_get_txpwr_info(struct mt792x_dev *dev, u8 band_idx, struct mt7925_txp
 int mt7925_mcu_set_sniffer(struct mt792x_dev *dev, struct ieee80211_vif *vif,
 			   bool enable)
 {
+	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
+	struct ieee80211_chanctx_conf *ctx = mvif->bss_conf.mt76.ctx;
 	struct {
 		struct {
 			u8 band_idx;
@@ -2196,6 +2198,15 @@ int mt7925_mcu_set_sniffer(struct mt792x_dev *dev, struct ieee80211_vif *vif,
 		},
 	};
 
+	if (is_mt7927(&dev->mt76)) {
+		struct ieee80211_channel *chan;
+
+		chan = ctx ? ctx->def.chan : mvif->phy->mt76->chandef.chan;
+
+		if (chan)
+			req.hdr.band_idx = mt7927_band_idx(chan->band);
+	}
+
 	return mt76_mcu_send_msg(&dev->mt76, MCU_UNI_CMD(SNIFFER), &req, sizeof(req),
 				 true);
 }
@@ -2255,6 +2266,9 @@ int mt7925_mcu_config_sniffer(struct mt792x_vif *vif,
 		},
 	};
 
+	if (is_mt7927(mphy->dev))
+		req.hdr.band_idx = mt7927_band_idx(chandef->chan->band);
+
 	if (chandef->chan->band < ARRAY_SIZE(ch_band))
 		req.tlv.ch_band = ch_band[chandef->chan->band];
 	if (chandef->width < ARRAY_SIZE(ch_width))
-- 
2.53.0



