Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C529D2222AF;
	Mon,  2 Jun 2025 14:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873200; cv=none; b=a0Ohk93TFr2i8tFoAQDoLt9/3w5KCDcep2ccloL5LosAQvUhCryTyJ6X5h1L1tiXhMpElaX6ir6kXZyCIg4MD25NzR8HBfFWhACM00a5jl1yIb7ojiQd9kOKHcV2cAm8cPL3CrP+oYP7zMDCamt9PTP6c1Bshk0KAVqHEQsyu10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873200; c=relaxed/simple;
	bh=QKhyTdyfGAZoN99BNsxVfAF2MLQnlMh2wLnNBUIsvS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4nCzcOnUSeyKli07dL2a0rnK3TDLn7OMdJS8xW8oIRSoYoDVKGmlz+6/3ULkjLGFnXcHsWIIsxQvjJw66ckllWAGpj5gjeS1sqUBfINRce83GEDl7Zsx8dt0UpY2IOLyrqpwmqca/kSaRD1witWkCo5CnVW+S/urwJnLKidyGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LjdSFAak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LjdSFAak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E3AC4CEEE;
	Mon,  2 Jun 2025 14:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873200;
	bh=QKhyTdyfGAZoN99BNsxVfAF2MLQnlMh2wLnNBUIsvS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjdSFAakv95ewmZhVt4xnMP0pyCTN3gH1iUGxSCZyJDTn0iBggQS9GL+0PjvwZRLS
	 So/8MU1ul2bXc7cChRgXF97GaMm9b9ynUKMHSHCr+yYgKMB8C8YosEcZ/ZUIL4/04H
	 5a+NCtubgSOyzBMIpDHfXrYioBYsStnRd5wfc5pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/444] wifi: mt76: only mark tx-status-failed frames as ACKed on mt76x0/2
Date: Mon,  2 Jun 2025 15:42:13 +0200
Message-ID: <20250602134343.716541076@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8b620d4fed439..df0ea638370b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -439,6 +439,7 @@ struct mt76_hw_cap {
 #define MT_DRV_RX_DMA_HDR		BIT(3)
 #define MT_DRV_HW_MGMT_TXQ		BIT(4)
 #define MT_DRV_AMSDU_OFFLOAD		BIT(5)
+#define MT_DRV_IGNORE_TXS_FAILED	BIT(6)
 
 struct mt76_driver_ops {
 	u32 drv_flags;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 9277ff38b7a22..57ae362dad50b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -152,7 +152,8 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
index 0422c332354a1..520fd46227a7b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -210,7 +210,8 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
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
index df85ebc6e1df0..7e2475b3c278e 100644
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
index d804309992196..70d3895762b4c 100644
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
index 1809b03292c3d..47cdccdbed6aa 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -100,7 +100,8 @@ __mt76_tx_status_skb_done(struct mt76_dev *dev, struct sk_buff *skb, u8 flags,
 		return;
 
 	/* Tx status can be unreliable. if it fails, mark the frame as ACKed */
-	if (flags & MT_TX_CB_TXS_FAILED) {
+	if (flags & MT_TX_CB_TXS_FAILED &&
+	    (dev->drv->drv_flags & MT_DRV_IGNORE_TXS_FAILED)) {
 		info->status.rates[0].count = 0;
 		info->status.rates[0].idx = -1;
 		info->flags |= IEEE80211_TX_STAT_ACK;
-- 
2.39.5



