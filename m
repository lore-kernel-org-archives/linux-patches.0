Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901141F09BF;
	Tue, 26 Aug 2025 12:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212964; cv=none; b=DKf2EdU4kI351iplDGCnrp0LBULn6kjLsD6sff+GTTNBJCo+DwF35WVU9SX41IWSQee9fcx+87mTbChjDuyTR9aWZjKhUWxeq5CvKIWtAgmkefADZ1sIf9JrfS539azA67xnRYIjP1JJSwTbRnLa6UA6bOxxoOmIgyfNFL20+cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212964; c=relaxed/simple;
	bh=0ecDO2Verj5lA5yQxKcstBLp/sa7TA8TSpIVRSZkhJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXW2Cb+Z2hkUoFBMTipujxAMWwW5sHktOOeNqoOQmoIij5Tnv+wNi5vKzQFSCCoQmuVhEEFYq5qhu7bLkCZaDYgcg3ioYOkf1lYL0LSdQ/+Uy8UO9WKT0Kd3V5NRxof/k0x53xfHaWRSW8IdDrzugL7+CD8n0rtv5OdDqfjEVGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApPvRmWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApPvRmWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A99C4CEF4;
	Tue, 26 Aug 2025 12:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212964;
	bh=0ecDO2Verj5lA5yQxKcstBLp/sa7TA8TSpIVRSZkhJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ApPvRmWlr442KzflEZlqK7GOhNtV258I2nxzWhkeNrUiC3DKO5uYcbksxLxB45O0l
	 pyb6RB8p0+KkIZ7WRy3poqFLcJ+WP8Eq3cdl/SZFWSbq9SYYzEr0HYF9KNlpYM81HG
	 NJKj9DbhNsoNOjNKO1YjIwoR2ThqyPsQ8K0OlRCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/587] wifi: rtw89: Fix rtw89_mac_power_switch() for USB
Date: Tue, 26 Aug 2025 13:05:19 +0200
Message-ID: <20250826110957.271065662@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit e2b71603333a9dd73ee88347d8894fffc3456ac1 ]

Clear some bits in some registers in order to allow RTL8851BU to power
on. This is done both when powering on and when powering off because
that's what the vendor driver does.

Also tested with RTL8832BU and RTL8832CU.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/a39da939-d640-4486-ad38-f658f220afc8@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac.c | 19 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/reg.h |  1 +
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 3c818c4b4653..3d63f8b2770e 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -1301,6 +1301,23 @@ void rtw89_mac_notify_wake(struct rtw89_dev *rtwdev)
 	rtw89_mac_send_rpwm(rtwdev, state, true);
 }
 
+static void rtw89_mac_power_switch_boot_mode(struct rtw89_dev *rtwdev)
+{
+	u32 boot_mode;
+
+	if (rtwdev->hci.type != RTW89_HCI_TYPE_USB)
+		return;
+
+	boot_mode = rtw89_read32_mask(rtwdev, R_AX_GPIO_MUXCFG, B_AX_BOOT_MODE);
+	if (!boot_mode)
+		return;
+
+	rtw89_write32_clr(rtwdev, R_AX_SYS_PW_CTRL, B_AX_APFN_ONMAC);
+	rtw89_write32_clr(rtwdev, R_AX_SYS_STATUS1, B_AX_AUTO_WLPON);
+	rtw89_write32_clr(rtwdev, R_AX_GPIO_MUXCFG, B_AX_BOOT_MODE);
+	rtw89_write32_clr(rtwdev, R_AX_RSV_CTRL, B_AX_R_DIS_PRST);
+}
+
 static int rtw89_mac_power_switch(struct rtw89_dev *rtwdev, bool on)
 {
 #define PWR_ACT 1
@@ -1310,6 +1327,8 @@ static int rtw89_mac_power_switch(struct rtw89_dev *rtwdev, bool on)
 	int ret;
 	u8 val;
 
+	rtw89_mac_power_switch_boot_mode(rtwdev);
+
 	if (on) {
 		cfg_seq = chip->pwr_on_seq;
 		cfg_func = chip->ops->pwr_on_func;
diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index c0aac4d3678a..ef1162595042 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -172,6 +172,7 @@
 
 #define R_AX_SYS_STATUS1 0x00F4
 #define B_AX_SEL_0XC0_MASK GENMASK(17, 16)
+#define B_AX_AUTO_WLPON BIT(10)
 #define B_AX_PAD_HCI_SEL_V2_MASK GENMASK(5, 3)
 #define MAC_AX_HCI_SEL_SDIO_UART 0
 #define MAC_AX_HCI_SEL_MULTI_USB 1
-- 
2.39.5



