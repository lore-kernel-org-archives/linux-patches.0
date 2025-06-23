Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A800221FBE;
	Mon, 23 Jun 2025 21:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715722; cv=none; b=sOZwVVl5fWW3UyxeiRor05f+/epSyZADg5y5SGUjm9+NPiBTq5/enZekAs5PzoyVosrYgPxXPT+FDotimWEpRr01fonBsJdLM6ZtqxEuR1Al1ryemjeIeHx3/p+lTV5XD0kV15m/N9Q3py1xr1scQdhgag8SS9jIh09SjHIVVH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715722; c=relaxed/simple;
	bh=YoHDvgCRhkQlnHSiWaGLtxunlJseBfa6/rP1qQ8uoAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGGDg0k5IN73giv7ulgezuAPw9LTemVdhiKZciaOg0xEt6bUMKjCM83C/vWG+JeX5NtJDdvQ8/c6YnFEGEocadT/zsj9T9sp/tm4o5ltT0n8vtEfI0PSRy1Scs38hpN9x20xsOexmoZLb6lGOStA/bBWixVfVUPLaWsZ6Blnv0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WXgHSF/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WXgHSF/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F113C4CEF1;
	Mon, 23 Jun 2025 21:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715721;
	bh=YoHDvgCRhkQlnHSiWaGLtxunlJseBfa6/rP1qQ8uoAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXgHSF/mIeja7lSIVrp2ZLVQU8hOJ3b5weJiy0upcptDbZb2/DxqOZLENYDy9ArMy
	 fidxom59V/s4X11IjXwZ2N6LZLAffwKGFgRZxSex4Mx+UVCxSHnmzmPHnYiIhc3Ypk
	 +WzmTk5QP36mGVLXkZPJ5V3f/+TxaKCHHrkaKtFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Yen <leon.yen@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 203/414] wifi: mt76: mt7925: introduce thermal protection
Date: Mon, 23 Jun 2025 15:05:40 +0200
Message-ID: <20250623130647.083137209@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Leon Yen <leon.yen@mediatek.com>

[ Upstream commit 1d81e893b422a6f0ae70f8648867c2e73edfb413 ]

Add thermal protection to prevent the chip from possible overheating
due to prolonged high traffic and adverse operating conditions.

Signed-off-by: Leon Yen <leon.yen@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250509082117.453819-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/init.c  |  6 ++++++
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 20 ++++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7925/mcu.h   |  1 +
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/init.c b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
index 039949b344b98..14553dcc61c57 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
@@ -204,6 +204,12 @@ static void mt7925_init_work(struct work_struct *work)
 		return;
 	}
 
+	ret = mt7925_mcu_set_thermal_protect(dev);
+	if (ret) {
+		dev_err(dev->mt76.dev, "thermal protection enable failed\n");
+		return;
+	}
+
 	/* we support chip reset now */
 	dev->hw_init_done = true;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index a19c108ad4b5c..57a1db394dda4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -961,6 +961,23 @@ int mt7925_mcu_set_deep_sleep(struct mt792x_dev *dev, bool enable)
 }
 EXPORT_SYMBOL_GPL(mt7925_mcu_set_deep_sleep);
 
+int mt7925_mcu_set_thermal_protect(struct mt792x_dev *dev)
+{
+	char cmd[64];
+	int ret = 0;
+
+	snprintf(cmd, sizeof(cmd), "ThermalProtGband %d %d %d %d %d %d %d %d %d %d",
+		 0, 100, 90, 80, 30, 1, 1, 115, 105, 5);
+	ret = mt7925_mcu_chip_config(dev, cmd);
+
+	snprintf(cmd, sizeof(cmd), "ThermalProtAband %d %d %d %d %d %d %d %d %d %d",
+		 1, 100, 90, 80, 30, 1, 1, 115, 105, 5);
+	ret |= mt7925_mcu_chip_config(dev, cmd);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mt7925_mcu_set_thermal_protect);
+
 int mt7925_run_firmware(struct mt792x_dev *dev)
 {
 	int err;
@@ -3288,7 +3305,8 @@ int mt7925_mcu_fill_message(struct mt76_dev *mdev, struct sk_buff *skb,
 		else
 			uni_txd->option = MCU_CMD_UNI_EXT_ACK;
 
-		if (cmd == MCU_UNI_CMD(HIF_CTRL))
+		if (cmd == MCU_UNI_CMD(HIF_CTRL) ||
+		    cmd == MCU_UNI_CMD(CHIP_CONFIG))
 			uni_txd->option &= ~MCU_CMD_ACK;
 
 		goto exit;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
index 887427e0760ae..780c5921679aa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
@@ -635,6 +635,7 @@ int mt7925_mcu_add_bss_info(struct mt792x_phy *phy,
 int mt7925_mcu_set_timing(struct mt792x_phy *phy,
 			  struct ieee80211_bss_conf *link_conf);
 int mt7925_mcu_set_deep_sleep(struct mt792x_dev *dev, bool enable);
+int mt7925_mcu_set_thermal_protect(struct mt792x_dev *dev);
 int mt7925_mcu_set_channel_domain(struct mt76_phy *phy);
 int mt7925_mcu_set_radio_en(struct mt792x_phy *phy, bool enable);
 int mt7925_mcu_set_chctx(struct mt76_phy *phy, struct mt76_vif *mvif,
-- 
2.39.5



