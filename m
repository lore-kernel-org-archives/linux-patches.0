Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804B025228F;
	Mon, 23 Jun 2025 13:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684353; cv=none; b=kQZyY6R6b07g4GGCcRna3TDJFjHUxLiOBJehRqVgoBSgZMRRmoA38igLVzrtOtUWFR/FshhaW3S2bFy6mZvLAUNDbmtow4ETD+EfOMFmwbsd5FYHLt4lcwFM0Cg9V0llXW0h4W/QgMC/fCVe3EnQ91cV6VpPmlooCqaXehY9uYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684353; c=relaxed/simple;
	bh=Zxv7U0YdTzqbCS7qCUcym+79sE7pgQO/Mfhf+KpRgqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWcYoeCiKSmglK7FfDYE9dmjkdmfD8tF5883uwsD1ITCdIOxqOSNYYk/4MfhJOKyDatmR3u5uJ1BreyHdHL2N3XtmwJG+vEi6RZ2dfGoNEp3UIrahyQ68jTxQMAX0edVzDhLLiyc0KBF0RADvxep8bwGmq0XQ3hEc5tpzXo7hJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aakoMcS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aakoMcS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F17C4CEF0;
	Mon, 23 Jun 2025 13:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684353;
	bh=Zxv7U0YdTzqbCS7qCUcym+79sE7pgQO/Mfhf+KpRgqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aakoMcS7piINqVvazEVl+maN+R89clZD4xkdk/sl0rvJSQWoO5ttnVOPb04JBp+fb
	 VeooxHKKKUhgLBvZPE/SPzVgTQkKXBOyKBVlglxnYefVS8v5wOl51Q9o0nGOK1xZD/
	 B0KRh6+ayddSZHRaYuoiHG33TT9kX313HGeaSR3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.15 037/592] wifi: rtw88: usb: Upload the firmware in bigger chunks
Date: Mon, 23 Jun 2025 14:59:55 +0200
Message-ID: <20250623130701.128769459@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit 80fe0bc1659c0ccc79d082e426fa376be5df9c04 upstream.

RTL8811AU stops responding during the firmware download on some systems:

[  809.256440] rtw_8821au 5-2.1:1.0: Firmware version 42.4.0, H2C version 0
[  812.759142] rtw_8821au 5-2.1:1.0 wlp48s0f4u2u1: renamed from wlan0
[  837.315388] rtw_8821au 1-4:1.0: write register 0x1ef4 failed with -110
[  867.524259] rtw_8821au 1-4:1.0: write register 0x1ef8 failed with -110
[  868.930976] rtw_8821au 5-2.1:1.0 wlp48s0f4u2u1: entered promiscuous mode
[  897.730952] rtw_8821au 1-4:1.0: write register 0x1efc failed with -110

Maybe it takes too long when writing the firmware 4 bytes at a time.

Write 196 bytes at a time for RTL8821AU, RTL8811AU, and RTL8812AU,
and 254 bytes at a time for RTL8723DU. These are the sizes used in
their official drivers. Tested with all these chips.

Cc: stable@vger.kernel.org
Link: https://github.com/lwfinger/rtw88/issues/344
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/43f1daad-3ec0-4a3b-a50c-9cd9eb2c2f52@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/hci.h  |    8 ++++
 drivers/net/wireless/realtek/rtw88/mac.c  |   11 +++---
 drivers/net/wireless/realtek/rtw88/mac.h  |    2 +
 drivers/net/wireless/realtek/rtw88/pci.c  |    2 +
 drivers/net/wireless/realtek/rtw88/sdio.c |    2 +
 drivers/net/wireless/realtek/rtw88/usb.c  |   55 ++++++++++++++++++++++++++++++
 6 files changed, 76 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/hci.h
+++ b/drivers/net/wireless/realtek/rtw88/hci.h
@@ -19,6 +19,8 @@ struct rtw_hci_ops {
 	void (*link_ps)(struct rtw_dev *rtwdev, bool enter);
 	void (*interface_cfg)(struct rtw_dev *rtwdev);
 	void (*dynamic_rx_agg)(struct rtw_dev *rtwdev, bool enable);
+	void (*write_firmware_page)(struct rtw_dev *rtwdev, u32 page,
+				    const u8 *data, u32 size);
 
 	int (*write_data_rsvd_page)(struct rtw_dev *rtwdev, u8 *buf, u32 size);
 	int (*write_data_h2c)(struct rtw_dev *rtwdev, u8 *buf, u32 size);
@@ -79,6 +81,12 @@ static inline void rtw_hci_dynamic_rx_ag
 		rtwdev->hci.ops->dynamic_rx_agg(rtwdev, enable);
 }
 
+static inline void rtw_hci_write_firmware_page(struct rtw_dev *rtwdev, u32 page,
+					       const u8 *data, u32 size)
+{
+	rtwdev->hci.ops->write_firmware_page(rtwdev, page, data, size);
+}
+
 static inline int
 rtw_hci_write_data_rsvd_page(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 {
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -856,8 +856,8 @@ fwdl_ready:
 	}
 }
 
-static void
-write_firmware_page(struct rtw_dev *rtwdev, u32 page, const u8 *data, u32 size)
+void rtw_write_firmware_page(struct rtw_dev *rtwdev, u32 page,
+			     const u8 *data, u32 size)
 {
 	u32 val32;
 	u32 block_nr;
@@ -887,6 +887,7 @@ write_firmware_page(struct rtw_dev *rtwd
 		rtw_write32(rtwdev, write_addr, le32_to_cpu(remain_data));
 	}
 }
+EXPORT_SYMBOL(rtw_write_firmware_page);
 
 static int
 download_firmware_legacy(struct rtw_dev *rtwdev, const u8 *data, u32 size)
@@ -904,11 +905,13 @@ download_firmware_legacy(struct rtw_dev
 	rtw_write8_set(rtwdev, REG_MCUFW_CTRL, BIT_FWDL_CHK_RPT);
 
 	for (page = 0; page < total_page; page++) {
-		write_firmware_page(rtwdev, page, data, DLFW_PAGE_SIZE_LEGACY);
+		rtw_hci_write_firmware_page(rtwdev, page, data,
+					    DLFW_PAGE_SIZE_LEGACY);
 		data += DLFW_PAGE_SIZE_LEGACY;
 	}
 	if (last_page_size)
-		write_firmware_page(rtwdev, page, data, last_page_size);
+		rtw_hci_write_firmware_page(rtwdev, page, data,
+					    last_page_size);
 
 	if (!check_hw_ready(rtwdev, REG_MCUFW_CTRL, BIT_FWDL_CHK_RPT, 1)) {
 		rtw_err(rtwdev, "failed to check download firmware report\n");
--- a/drivers/net/wireless/realtek/rtw88/mac.h
+++ b/drivers/net/wireless/realtek/rtw88/mac.h
@@ -34,6 +34,8 @@ int rtw_pwr_seq_parser(struct rtw_dev *r
 		       const struct rtw_pwr_seq_cmd * const *cmd_seq);
 int rtw_mac_power_on(struct rtw_dev *rtwdev);
 void rtw_mac_power_off(struct rtw_dev *rtwdev);
+void rtw_write_firmware_page(struct rtw_dev *rtwdev, u32 page,
+			     const u8 *data, u32 size);
 int rtw_download_firmware(struct rtw_dev *rtwdev, struct rtw_fw_state *fw);
 int rtw_mac_init(struct rtw_dev *rtwdev);
 void rtw_mac_flush_queues(struct rtw_dev *rtwdev, u32 queues, bool drop);
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -12,6 +12,7 @@
 #include "fw.h"
 #include "ps.h"
 #include "debug.h"
+#include "mac.h"
 
 static bool rtw_disable_msi;
 static bool rtw_pci_disable_aspm;
@@ -1602,6 +1603,7 @@ static const struct rtw_hci_ops rtw_pci_
 	.link_ps = rtw_pci_link_ps,
 	.interface_cfg = rtw_pci_interface_cfg,
 	.dynamic_rx_agg = NULL,
+	.write_firmware_page = rtw_write_firmware_page,
 
 	.read8 = rtw_pci_read8,
 	.read16 = rtw_pci_read16,
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -10,6 +10,7 @@
 #include <linux/mmc/host.h>
 #include <linux/mmc/sdio_func.h>
 #include "main.h"
+#include "mac.h"
 #include "debug.h"
 #include "fw.h"
 #include "ps.h"
@@ -1154,6 +1155,7 @@ static const struct rtw_hci_ops rtw_sdio
 	.link_ps = rtw_sdio_link_ps,
 	.interface_cfg = rtw_sdio_interface_cfg,
 	.dynamic_rx_agg = NULL,
+	.write_firmware_page = rtw_write_firmware_page,
 
 	.read8 = rtw_sdio_read8,
 	.read16 = rtw_sdio_read16,
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -165,6 +165,60 @@ static void rtw_usb_write32(struct rtw_d
 	rtw_usb_write(rtwdev, addr, val, 4);
 }
 
+static void rtw_usb_write_firmware_page(struct rtw_dev *rtwdev, u32 page,
+					const u8 *data, u32 size)
+{
+	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
+	struct usb_device *udev = rtwusb->udev;
+	u32 addr = FW_START_ADDR_LEGACY;
+	u8 *data_dup, *buf;
+	u32 n, block_size;
+	int ret;
+
+	switch (rtwdev->chip->id) {
+	case RTW_CHIP_TYPE_8723D:
+		block_size = 254;
+		break;
+	default:
+		block_size = 196;
+		break;
+	}
+
+	data_dup = kmemdup(data, size, GFP_KERNEL);
+	if (!data_dup)
+		return;
+
+	buf = data_dup;
+
+	rtw_write32_mask(rtwdev, REG_MCUFW_CTRL, BIT_ROM_PGE, page);
+
+	while (size > 0) {
+		if (size >= block_size)
+			n = block_size;
+		else if (size >= 8)
+			n = 8;
+		else
+			n = 1;
+
+		ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+				      RTW_USB_CMD_REQ, RTW_USB_CMD_WRITE,
+				      addr, 0, buf, n, 500);
+		if (ret != n) {
+			if (ret != -ENODEV)
+				rtw_err(rtwdev,
+					"write 0x%x len %d failed: %d\n",
+					addr, n, ret);
+			break;
+		}
+
+		addr += n;
+		buf += n;
+		size -= n;
+	}
+
+	kfree(data_dup);
+}
+
 static int dma_mapping_to_ep(enum rtw_dma_mapping dma_mapping)
 {
 	switch (dma_mapping) {
@@ -891,6 +945,7 @@ static const struct rtw_hci_ops rtw_usb_
 	.link_ps = rtw_usb_link_ps,
 	.interface_cfg = rtw_usb_interface_cfg,
 	.dynamic_rx_agg = rtw_usb_dynamic_rx_agg,
+	.write_firmware_page = rtw_usb_write_firmware_page,
 
 	.write8  = rtw_usb_write8,
 	.write16 = rtw_usb_write16,


