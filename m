Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11E8187554;
	Tue, 26 Aug 2025 13:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214437; cv=none; b=GvqDP08wdlsTNeUFmdBjsu9e2SXAVn6eieexQotHz6QeRJJM4VA1JKBYI2au6sCg3K3urQMSJkwJg9FSK5AZLhgOd3vWWIV7IF8drHQZWaySVc71WyngPeszLRUKWxk9zn2hgxayixQqx6GTvG4b8XysSJDMoHsOIg7ziQipMRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214437; c=relaxed/simple;
	bh=jkCCGhCaTPKxcp9oL7W03OL1kZXSdCsRnPLV24GjlLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUzV39jrbWjhqR7UCqZTcY2cxLGarCrIrjY7TXq6ieEZ9+vmeVGEEROZl8SzirG3SJQW16s8S0ffWFG/trxfnRf3ZayMD4ervIg7RRZeGxdG5RAsD7qA9scC2GEq09XMRTTJ+zSZXEA5ITrQMyNVnsvL0IcaodAim4VKQR+EuS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjzN/Gq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjzN/Gq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5403FC4CEF1;
	Tue, 26 Aug 2025 13:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214437;
	bh=jkCCGhCaTPKxcp9oL7W03OL1kZXSdCsRnPLV24GjlLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjzN/Gq+aFZrC63R1w+Ebe8SXlI+tUBNimj1WCMn/cjVXfw+XhXv6TtWk9d2aElr3
	 rmKYe+IWb8s2BjUtgChi9FaVkEDVN17AoMUo33coCNhsgxnhn7cUmwBeSPHwp0smcz
	 yIv9BkRklXz/1ZpP148NCaag1dI6bbLWPo6zbUPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/482] wifi: rtw89: Fix rtw89_mac_power_switch() for USB
Date: Tue, 26 Aug 2025 13:06:30 +0200
Message-ID: <20250826110934.203292070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4a1c9e18c530..f15a2c6874cb 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -1093,6 +1093,23 @@ void rtw89_mac_notify_wake(struct rtw89_dev *rtwdev)
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
@@ -1102,6 +1119,8 @@ static int rtw89_mac_power_switch(struct rtw89_dev *rtwdev, bool on)
 	int ret;
 	u8 val;
 
+	rtw89_mac_power_switch_boot_mode(rtwdev);
+
 	if (on) {
 		cfg_seq = chip->pwr_on_seq;
 		cfg_func = chip->ops->pwr_on_func;
diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index 0291aff94016..52dd24a6216d 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -157,6 +157,7 @@
 
 #define R_AX_SYS_STATUS1 0x00F4
 #define B_AX_SEL_0XC0_MASK GENMASK(17, 16)
+#define B_AX_AUTO_WLPON BIT(10)
 #define B_AX_PAD_HCI_SEL_V2_MASK GENMASK(5, 3)
 #define MAC_AX_HCI_SEL_SDIO_UART 0
 #define MAC_AX_HCI_SEL_MULTI_USB 1
-- 
2.39.5



