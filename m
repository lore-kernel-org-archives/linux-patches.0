Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2105B25A627;
	Tue, 27 May 2025 17:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368031; cv=none; b=URY163fZaTJeX7B+163grlZ56kecYW0q4IEcEqlr3+8fDzfUUu+8I+jZjUnRzVRclrIf85rw47PkB8rt82YMoMmTyU55YBv1PrVvsCyprxknP5vgL7BdA9mRtZ1SDQ33fgNMwPiiLgqHkpVwLOqt7+cgA6jWh/4hh6zx1ZvTrlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368031; c=relaxed/simple;
	bh=w5J0ORCLH7TqCGU2+HjLUIAGRwEvOcJMASOxwzSXyxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPyIdh4VOoJbt2FXkVUH9eEFSM6gdSdsmCwJDiPA85ntJ0+ijA1c9/8ay+85YdIXdltUlBt7GHqliCw7tnu9Xf+lJRLbVFdD/8jCxeMdKF8TnT93Cr88gVje/yAS0kmTyNECCCNsrJhx7sWycUrVf3tqBllEBhA3r7oPqkeBj+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LT0CkoV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LT0CkoV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0169C4CEE9;
	Tue, 27 May 2025 17:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368031;
	bh=w5J0ORCLH7TqCGU2+HjLUIAGRwEvOcJMASOxwzSXyxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LT0CkoV11SZTp4KK5gaL8LvT6Vq3Gtq9IGzo5b12S9MKevmhGYMigo1Q0cp1YiG7B
	 WkLuCN419xP4jbZZyyiXS9IrrsiY3ZgFc6SsNTotLc1/utH0TAPXeq1DWk9IXYD6sC
	 ibYJCxno8bW65qw5pGZnEZ8gdsEhPGrJ0oFfif3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 546/783] wifi: rtw89: call power_on ahead before selecting firmware
Date: Tue, 27 May 2025 18:25:43 +0200
Message-ID: <20250527162535.393485507@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit d078f5857a00c06fa0ddee26d3cb722e938e1688 ]

Driver selects firmware by hardware version, which normally can be read
from registers before selecting firmware. However, certain chips such as
RTL8851B, it needs to read hardware version from efuse while doing
power_on, but do power_on after selecting firmware in current flow.

To resolve this flow problem, move power_on out from
rtw89_mac_partial_init(), and call rtw89_mac_pwr_on() separately at
proper places to have expected flow.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250203072911.47313-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 23 +++++++++++-------
 drivers/net/wireless/realtek/rtw89/mac.c  | 29 ++++++++++++++++-------
 drivers/net/wireless/realtek/rtw89/mac.h  |  1 +
 3 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index c84446ec9e4f4..422cc3867f3bc 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -5086,8 +5086,6 @@ static int rtw89_chip_efuse_info_setup(struct rtw89_dev *rtwdev)
 
 	rtw89_hci_mac_pre_deinit(rtwdev);
 
-	rtw89_mac_pwr_off(rtwdev);
-
 	return 0;
 }
 
@@ -5168,36 +5166,45 @@ int rtw89_chip_info_setup(struct rtw89_dev *rtwdev)
 
 	rtw89_read_chip_ver(rtwdev);
 
+	ret = rtw89_mac_pwr_on(rtwdev);
+	if (ret) {
+		rtw89_err(rtwdev, "failed to power on\n");
+		return ret;
+	}
+
 	ret = rtw89_wait_firmware_completion(rtwdev);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to wait firmware completion\n");
-		return ret;
+		goto out;
 	}
 
 	ret = rtw89_fw_recognize(rtwdev);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to recognize firmware\n");
-		return ret;
+		goto out;
 	}
 
 	ret = rtw89_chip_efuse_info_setup(rtwdev);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = rtw89_fw_recognize_elements(rtwdev);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to recognize firmware elements\n");
-		return ret;
+		goto out;
 	}
 
 	ret = rtw89_chip_board_info_setup(rtwdev);
 	if (ret)
-		return ret;
+		goto out;
 
 	rtw89_core_setup_rfe_parms(rtwdev);
 	rtwdev->ps_mode = rtw89_update_ps_mode(rtwdev);
 
-	return 0;
+out:
+	rtw89_mac_pwr_off(rtwdev);
+
+	return ret;
 }
 EXPORT_SYMBOL(rtw89_chip_info_setup);
 
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 2c74d7781bd40..def12dbfe48d3 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -1495,6 +1495,21 @@ static int rtw89_mac_power_switch(struct rtw89_dev *rtwdev, bool on)
 #undef PWR_ACT
 }
 
+int rtw89_mac_pwr_on(struct rtw89_dev *rtwdev)
+{
+	int ret;
+
+	ret = rtw89_mac_power_switch(rtwdev, true);
+	if (ret) {
+		rtw89_mac_power_switch(rtwdev, false);
+		ret = rtw89_mac_power_switch(rtwdev, true);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 void rtw89_mac_pwr_off(struct rtw89_dev *rtwdev)
 {
 	rtw89_mac_power_switch(rtwdev, false);
@@ -3996,14 +4011,6 @@ int rtw89_mac_partial_init(struct rtw89_dev *rtwdev, bool include_bb)
 {
 	int ret;
 
-	ret = rtw89_mac_power_switch(rtwdev, true);
-	if (ret) {
-		rtw89_mac_power_switch(rtwdev, false);
-		ret = rtw89_mac_power_switch(rtwdev, true);
-		if (ret)
-			return ret;
-	}
-
 	rtw89_mac_ctrl_hci_dma_trx(rtwdev, true);
 
 	if (include_bb) {
@@ -4036,6 +4043,10 @@ int rtw89_mac_init(struct rtw89_dev *rtwdev)
 	bool include_bb = !!chip->bbmcu_nr;
 	int ret;
 
+	ret = rtw89_mac_pwr_on(rtwdev);
+	if (ret)
+		return ret;
+
 	ret = rtw89_mac_partial_init(rtwdev, include_bb);
 	if (ret)
 		goto fail;
@@ -4067,7 +4078,7 @@ int rtw89_mac_init(struct rtw89_dev *rtwdev)
 
 	return ret;
 fail:
-	rtw89_mac_power_switch(rtwdev, false);
+	rtw89_mac_pwr_off(rtwdev);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/realtek/rtw89/mac.h b/drivers/net/wireless/realtek/rtw89/mac.h
index 373366a602e0b..71574dbd8764e 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.h
+++ b/drivers/net/wireless/realtek/rtw89/mac.h
@@ -1145,6 +1145,7 @@ rtw89_write32_port_set(struct rtw89_dev *rtwdev, struct rtw89_vif_link *rtwvif_l
 	rtw89_write32_set(rtwdev, reg, bit);
 }
 
+int rtw89_mac_pwr_on(struct rtw89_dev *rtwdev);
 void rtw89_mac_pwr_off(struct rtw89_dev *rtwdev);
 int rtw89_mac_partial_init(struct rtw89_dev *rtwdev, bool include_bb);
 int rtw89_mac_init(struct rtw89_dev *rtwdev);
-- 
2.39.5



