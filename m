Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7565812DDA1;
	Mon, 18 Aug 2025 13:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522101; cv=none; b=PR9DgcVVUjh/jvmsu6zxfJg6kLJouMztbmWVm2pAosbM+NPdOf0RgShnsbDq3XB1j/jFnMRKDiJexswEsP9am+zMYsA/cJ2fVPHuhhTIaBpmuJMlH09wzslKtnU4c9xGVg/At1bRWiFZ4/v944+Q7OqRsWBFR1sDwOVZH34lbiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522101; c=relaxed/simple;
	bh=JDf33uweRbucOu1IMWHnEE2x6xQy/eX/0JIvd0F1Zag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mI5voHTnCbYmMslrqK2eWYWMFpsqnwNLB6QVWOTrkrFgOXEl63aAv3rOvGzn465RXSrUKuJxmd9bUhiN6A9rmh32tNMQDXcJfAAeCJsMhRmwJnRdsv/vAwwB0qIvoCXdWmoC0BsPM65tOUDW9GWHRe2iW4t/ziRsg9Yse79mX94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hb7YhcYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hb7YhcYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7E3C4CEEB;
	Mon, 18 Aug 2025 13:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522101;
	bh=JDf33uweRbucOu1IMWHnEE2x6xQy/eX/0JIvd0F1Zag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hb7YhcYn28UjwFSLmtqhVNtnn+T0Pnhx28J+Q16ZNzti1Se17LGMf3PQ50o3l5+ag
	 xzJxBwS6PCYOHgZ17Jmy/XsmfkJcFS3gB5CLycwCyvBMrZsioAIPiSvam6ZPfmUGU8
	 qwsU1bFojMbteBU2hjxb7pcQhxFJ3817048FYThc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 214/444] wifi: rtw89: Fix rtw89_mac_power_switch() for USB
Date: Mon, 18 Aug 2025 14:44:00 +0200
Message-ID: <20250818124456.870955109@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index 2188bca899e3..8b7ca63af7ed 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -1441,6 +1441,23 @@ void rtw89_mac_notify_wake(struct rtw89_dev *rtwdev)
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
@@ -1450,6 +1467,8 @@ static int rtw89_mac_power_switch(struct rtw89_dev *rtwdev, bool on)
 	int ret;
 	u8 val;
 
+	rtw89_mac_power_switch_boot_mode(rtwdev);
+
 	if (on) {
 		cfg_seq = chip->pwr_on_seq;
 		cfg_func = chip->ops->pwr_on_func;
diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index 9fbcc7fee290..7ec516979fe2 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -182,6 +182,7 @@
 
 #define R_AX_SYS_STATUS1 0x00F4
 #define B_AX_SEL_0XC0_MASK GENMASK(17, 16)
+#define B_AX_AUTO_WLPON BIT(10)
 #define B_AX_PAD_HCI_SEL_V2_MASK GENMASK(5, 3)
 #define MAC_AX_HCI_SEL_SDIO_UART 0
 #define MAC_AX_HCI_SEL_MULTI_USB 1
-- 
2.39.5



