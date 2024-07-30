Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A051A76D4;
	Tue, 30 Jul 2024 17:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360115; cv=none; b=bHuHxRWmfThuJHnt4XDY0f+oXzl+WFo3n26DCSFkXCfyeMfHGMiK7JGaMwOkt1csWDR95nXBttQEMbnV2F6ztxfb8gWWp8lW5OEBlFb5pP/uXwuThw4FmqzMFK1Q0tB9stsMio6ryhOIT0EPYD8BmOCSaMAIMLXt5cGRD5S/pdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360115; c=relaxed/simple;
	bh=TqwViGbU9xWdeJuwH6KYzfg3zYmnQDBIaGvDAGdCMM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6yr221QuJztCYOkcVKN9kAntMISlBxCcrarJsbKnWRvZSOwyUg16E+UW7gER5y5xLeg4h0tioMY0Lx/oOTVASkG+lHqDDSDflOqt7y9Wd9yrScu23SubCt309PJq+UIojRmJkX9n2c1t4tk6lPVQU5g+f36qVif2Pj2B0s0BZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMWKhyVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMWKhyVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079E3C32782;
	Tue, 30 Jul 2024 17:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360115;
	bh=TqwViGbU9xWdeJuwH6KYzfg3zYmnQDBIaGvDAGdCMM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMWKhyVRG+iY6dgcbGwq9otaqGaFhfgYpQJDZjsLFD7bGQW4u0K1YhMhwHEiNpfeu
	 o/F0q6xQkx+v8DeNs2qpQREnHRyrRsIaSzzzUAvSLmsin9J9uu0aVH8ZJMyB4FLdDS
	 8MALUrDQY9zLYDqaad1arFo/GfpkfczUTOBWGea4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.10 602/809] wifi: rtw88: usb: Further limit the TX aggregation
Date: Tue, 30 Jul 2024 17:47:58 +0200
Message-ID: <20240730151748.610503808@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit d7dd13ea54af8496aca2762a758d817d6813e81c upstream.

Currently the number of frames sent to the chip in a single USB Request
Block is limited only by the size of the TX buffer, which is 20 KiB.
Testing reveals that as many as 13 frames get aggregated. This is more
than what any of the chips would like to receive. RTL8822CU, RTL8822BU,
and RTL8821CU want at most 3 frames, and RTL8723DU wants only 1 frame
per URB.

RTL8723DU in particular reliably malfunctions during a speed test if it
receives more than 1 frame per URB. All traffic seems to stop. Pinging
the AP no longer works.

Fix this problem by limiting the number of frames sent to the chip in a
single URB according to what each chip likes.

Also configure RTL8822CU, RTL8822BU, and RTL8821CU to expect 3 frames
per URB.

RTL8703B may or may not be found in USB devices. Declare that it wants
only 1 frame per URB, just in case.

Tested with RTL8723DU and RTL8811CU.

Cc: stable@vger.kernel.org
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/cb46ea35-7e59-4742-9c1f-01ceeaad36fb@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/mac.c      |    9 +++++++++
 drivers/net/wireless/realtek/rtw88/main.h     |    2 ++
 drivers/net/wireless/realtek/rtw88/reg.h      |    1 +
 drivers/net/wireless/realtek/rtw88/rtw8703b.c |    1 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c |    1 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c |    1 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c |    1 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c |    1 +
 drivers/net/wireless/realtek/rtw88/usb.c      |    4 +++-
 9 files changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -1201,6 +1201,15 @@ static int __priority_queue_cfg(struct r
 	rtw_write16(rtwdev, REG_FIFOPAGE_CTRL_2 + 2, fifo->rsvd_boundary);
 	rtw_write16(rtwdev, REG_BCNQ1_BDNY_V1, fifo->rsvd_boundary);
 	rtw_write32(rtwdev, REG_RXFF_BNDY, chip->rxff_size - C2H_PKT_BUF - 1);
+
+	if (rtwdev->hci.type == RTW_HCI_TYPE_USB) {
+		rtw_write8_mask(rtwdev, REG_AUTO_LLT_V1, BIT_MASK_BLK_DESC_NUM,
+				chip->usb_tx_agg_desc_num);
+
+		rtw_write8(rtwdev, REG_AUTO_LLT_V1 + 3, chip->usb_tx_agg_desc_num);
+		rtw_write8_set(rtwdev, REG_TXDMA_OFFSET_CHK + 1, BIT(1));
+	}
+
 	rtw_write8_set(rtwdev, REG_AUTO_LLT_V1, BIT_AUTO_INIT_LLT_V1);
 
 	if (!check_hw_ready(rtwdev, REG_AUTO_LLT_V1, BIT_AUTO_INIT_LLT_V1, 0))
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1197,6 +1197,8 @@ struct rtw_chip_info {
 	u16 fw_fifo_addr[RTW_FW_FIFO_MAX];
 	const struct rtw_fwcd_segs *fwcd_segs;
 
+	u8 usb_tx_agg_desc_num;
+
 	u8 default_1ss_tx_path;
 
 	bool path_div_supported;
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -270,6 +270,7 @@
 #define BIT_MASK_BCN_HEAD_1_V1	0xfff
 #define REG_AUTO_LLT_V1		0x0208
 #define BIT_AUTO_INIT_LLT_V1	BIT(0)
+#define BIT_MASK_BLK_DESC_NUM	GENMASK(7, 4)
 #define REG_DWBCN0_CTRL		0x0208
 #define BIT_BCN_VALID		BIT(16)
 #define REG_TXDMA_OFFSET_CHK	0x020C
--- a/drivers/net/wireless/realtek/rtw88/rtw8703b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8703b.c
@@ -2013,6 +2013,7 @@ const struct rtw_chip_info rtw8703b_hw_s
 	.tx_stbc = false,
 	.max_power_index = 0x3f,
 	.ampdu_density = IEEE80211_HT_MPDU_DENSITY_16,
+	.usb_tx_agg_desc_num = 1, /* Not sure if this chip has USB interface */
 
 	.path_div_supported = false,
 	.ht_supported = true,
--- a/drivers/net/wireless/realtek/rtw88/rtw8723d.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723d.c
@@ -2171,6 +2171,7 @@ const struct rtw_chip_info rtw8723d_hw_s
 	.band = RTW_BAND_2G,
 	.page_size = TX_PAGE_SIZE,
 	.dig_min = 0x20,
+	.usb_tx_agg_desc_num = 1,
 	.ht_supported = true,
 	.vht_supported = false,
 	.lps_deep_mode_supported = 0,
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -2008,6 +2008,7 @@ const struct rtw_chip_info rtw8821c_hw_s
 	.band = RTW_BAND_2G | RTW_BAND_5G,
 	.page_size = TX_PAGE_SIZE,
 	.dig_min = 0x1c,
+	.usb_tx_agg_desc_num = 3,
 	.ht_supported = true,
 	.vht_supported = true,
 	.lps_deep_mode_supported = BIT(LPS_DEEP_MODE_LCLK),
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -2548,6 +2548,7 @@ const struct rtw_chip_info rtw8822b_hw_s
 	.band = RTW_BAND_2G | RTW_BAND_5G,
 	.page_size = TX_PAGE_SIZE,
 	.dig_min = 0x1c,
+	.usb_tx_agg_desc_num = 3,
 	.ht_supported = true,
 	.vht_supported = true,
 	.lps_deep_mode_supported = BIT(LPS_DEEP_MODE_LCLK),
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -5366,6 +5366,7 @@ const struct rtw_chip_info rtw8822c_hw_s
 	.band = RTW_BAND_2G | RTW_BAND_5G,
 	.page_size = TX_PAGE_SIZE,
 	.dig_min = 0x20,
+	.usb_tx_agg_desc_num = 3,
 	.default_1ss_tx_path = BB_PATH_A,
 	.path_div_supported = true,
 	.ht_supported = true,
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -379,7 +379,9 @@ static bool rtw_usb_tx_agg_skb(struct rt
 
 		skb_iter = skb_peek(list);
 
-		if (skb_iter && skb_iter->len + skb_head->len <= RTW_USB_MAX_XMITBUF_SZ)
+		if (skb_iter &&
+		    skb_iter->len + skb_head->len <= RTW_USB_MAX_XMITBUF_SZ &&
+		    agg_num < rtwdev->chip->usb_tx_agg_desc_num)
 			__skb_unlink(skb_iter, list);
 		else
 			skb_iter = NULL;


