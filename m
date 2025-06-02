Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FBB232368;
	Mon,  2 Jun 2025 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875957; cv=none; b=Ps2k6RcRxP/TqoflyvW9tboUNCDtE7hFGiU7zzmRNk94x8c3JETA18xqwgPN0q49+wCAJGC58BkEL9XgcmCbHZevrj0AxlQ/e0ZllQetBeXvymv8mz0YJEAI/oBWr1Pxu9w332ppx6viZys3Eu6sT9sqC9G7hPsFSrDb9vu55Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875957; c=relaxed/simple;
	bh=MmiQW32QBguyznkgPcieA+53rLTbWUJy1835+c2Cvyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBv9VgnYdk1aXWowEU0F6jKuGVQH6SZqM/MnmY5VBSithDC15qAnOgJV5U4Ww6PzI9NAR0JXeKIhXTWnHTvEC4J5vTHAfWIIEVNaSF3IYLql7voAcO2t+81GQovTIlLpYlnDwwSpVdJe0dOLQsYr2VQhpFUrtfS+iOpXF5y8VIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffVMRq6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffVMRq6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCE6C4CEEB;
	Mon,  2 Jun 2025 14:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875957;
	bh=MmiQW32QBguyznkgPcieA+53rLTbWUJy1835+c2Cvyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffVMRq6SzT+miErxYJjKCzmbi2TQzusdd7WlQzHpeaJg7eyNSGwAidURuZTzgMsBQ
	 KcBUaF13su+5CmfMsVttZTTSETTaOqi/pXVb98p5mBPons4JH1KR2lLIK1RA5laGSf
	 +KmgypUB9FqSWeoufScG0tlIlBsRxDTdazgzrwIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/207] wifi: mt76: only mark tx-status-failed frames as ACKed on mt76x0/2
Date: Mon,  2 Jun 2025 15:46:39 +0200
Message-ID: <20250602134259.833871418@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 0c5a89ceddc1728a40cb3313948401dd70e3c649 ]

The interrupt status polling is unreliable, which can cause status events
to get lost. On all newer chips, txs-timeout is an indication that the
packet was either never sent, or never acked.
Fixes issues with inactivity polling.

Link: https://patch.msgid.link/20250311103646.43346-6-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h       | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c | 3 ++-
 drivers/net/wireless/mediatek/mt76/tx.c         | 3 ++-
 6 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 27f04fb2796d7..5a90fa556203f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -345,6 +345,7 @@ struct mt76_hw_cap {
 #define MT_DRV_RX_DMA_HDR		BIT(3)
 #define MT_DRV_HW_MGMT_TXQ		BIT(4)
 #define MT_DRV_AMSDU_OFFLOAD		BIT(5)
+#define MT_DRV_IGNORE_TXS_FAILED	BIT(6)
 
 struct mt76_driver_ops {
 	u32 drv_flags;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index b795e7245c075..3255f9c0ef71f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -151,7 +151,8 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	static const struct mt76_driver_ops drv_ops = {
 		.txwi_size = sizeof(struct mt76x02_txwi),
 		.drv_flags = MT_DRV_TX_ALIGNED4_SKBS |
-			     MT_DRV_SW_RX_AIRTIME,
+			     MT_DRV_SW_RX_AIRTIME |
+			     MT_DRV_IGNORE_TXS_FAILED,
 		.survey_flags = SURVEY_INFO_TIME_TX,
 		.update_survey = mt76x02_update_channel,
 		.tx_prepare_skb = mt76x02_tx_prepare_skb,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index f2b2fa7338457..7a4d62bff28ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -209,7 +209,8 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 			 const struct usb_device_id *id)
 {
 	static const struct mt76_driver_ops drv_ops = {
-		.drv_flags = MT_DRV_SW_RX_AIRTIME,
+		.drv_flags = MT_DRV_SW_RX_AIRTIME |
+			     MT_DRV_IGNORE_TXS_FAILED,
 		.survey_flags = SURVEY_INFO_TIME_TX,
 		.update_survey = mt76x02_update_channel,
 		.tx_prepare_skb = mt76x02u_tx_prepare_skb,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
index 5cd0379d86de8..4e369bd87c900 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
@@ -22,7 +22,8 @@ mt76x2e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	static const struct mt76_driver_ops drv_ops = {
 		.txwi_size = sizeof(struct mt76x02_txwi),
 		.drv_flags = MT_DRV_TX_ALIGNED4_SKBS |
-			     MT_DRV_SW_RX_AIRTIME,
+			     MT_DRV_SW_RX_AIRTIME |
+			     MT_DRV_IGNORE_TXS_FAILED,
 		.survey_flags = SURVEY_INFO_TIME_TX,
 		.update_survey = mt76x02_update_channel,
 		.tx_prepare_skb = mt76x02_tx_prepare_skb,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index 9369515f36a3a..09b01e09bcfe0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -29,7 +29,8 @@ static int mt76x2u_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
 	static const struct mt76_driver_ops drv_ops = {
-		.drv_flags = MT_DRV_SW_RX_AIRTIME,
+		.drv_flags = MT_DRV_SW_RX_AIRTIME |
+			     MT_DRV_IGNORE_TXS_FAILED,
 		.survey_flags = SURVEY_INFO_TIME_TX,
 		.update_survey = mt76x02_update_channel,
 		.tx_prepare_skb = mt76x02u_tx_prepare_skb,
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 134a735a06329..3fbf0153d13ca 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -93,7 +93,8 @@ __mt76_tx_status_skb_done(struct mt76_dev *dev, struct sk_buff *skb, u8 flags,
 	__skb_unlink(skb, &dev->status_list);
 
 	/* Tx status can be unreliable. if it fails, mark the frame as ACKed */
-	if (flags & MT_TX_CB_TXS_FAILED) {
+	if (flags & MT_TX_CB_TXS_FAILED &&
+	    (dev->drv->drv_flags & MT_DRV_IGNORE_TXS_FAILED)) {
 		info->status.rates[0].count = 0;
 		info->status.rates[0].idx = -1;
 		info->flags |= IEEE80211_TX_STAT_ACK;
-- 
2.39.5



