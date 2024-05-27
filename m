Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8023317E90E;
	Mon, 27 May 2024 19:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836837; cv=none; b=T6fyyiUdhfPhc9KtnfhbKHEWe3NwB+UqU8yAKlWTF/PwgSqspitQsQW5KVKkgNmszQddGyxlKNEiO9dWHsn6E0cfZQD22JWfNT9yOgfU33m6FPZUjS+LT3BneuWoFfHlaeQQu5P7G3nAZuDrWqwodQueXyZQrvtfviuBOtceJsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836837; c=relaxed/simple;
	bh=k/lfzlRJyO7g/fuv2kmBL7JMpkR7FTcXLlIPc3HKuxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIbYo+lAH+G4AiiVnvsTz6uHGiyAFHPVIyometV67GrV1afKMNen3irLqCxD3ZVe+opUVMjBl1fOFAH8mssyzKuEJP6ofafsSNcRXVbTdhRmGcqrtyMmxHvvtDMRSsizeDYY7JrtbvYWQncl7LZEEccgtNb5RZcY0sZYFU5t+n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUs/kHQq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUs/kHQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141E2C32781;
	Mon, 27 May 2024 19:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836837;
	bh=k/lfzlRJyO7g/fuv2kmBL7JMpkR7FTcXLlIPc3HKuxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUs/kHQqzkP3fa6hZWnyKm/YMm2ZQlCSru+2xY7xblWexvwK+VTpSdFkThvHkWO++
	 oXdpwehL11w2MqcGHFxUyCO18cdvaGbDzmW5dHoEZSZCgsbsYX8uP8uJF2at8CGqGT
	 DoD/VitYIZD9Bh+cTNO/wqLs3PDDt1J4PlMR0RIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 207/427] wifi: rtw89: wow: refine WoWLAN flows of HCI interrupts and low power mode
Date: Mon, 27 May 2024 20:54:14 +0200
Message-ID: <20240527185621.652702240@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit baaf806e4632a259cc959fd1c516c2d9ed48df6d ]

After enabling packet offload, the TX will be stuck after resume from
WoWLAN mode. And the 8852c gets error messages like

rtw89_8852ce 0000:04:00.0: No busy txwd pages available
rtw89_8852ce 0000:04:00.0: queue 0 txwd 100 is not idle
rtw89_8852ce 0000:04:00.0: queue 0 txwd 101 is not idle
rtw89_8852ce 0000:04:00.0: queue 0 txwd 102 is not idle
rtw89_8852ce 0000:04:00.0: queue 0 txwd 103 is not idle

If suspend/resume many times that firmware will download failed and
disconnection.

To fix these issues, We removed the rtw89_hci_disable_intr() and
rtw89_hci_enable_intr() during rtw89_wow_swap_fw() to prevent add packet
offload can't receive c2h back due to interrupt disable. Only 8852C and
8922A needs to disable interrupt before downloading fw.

Furthermore, we avoid using low power HCI mode on WoWLAN mode, to prevent
interrupt enabled, then get interrupt and calculate RXBD mismatched due to
software RXBD index already reset but hardware RXBD index not yet.

Fixes: 5c12bb66b79d ("wifi: rtw89: refine packet offload flow")
Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/20240502022505.28966-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/ps.c  |  3 ++-
 drivers/net/wireless/realtek/rtw89/wow.c | 12 ++++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/ps.c b/drivers/net/wireless/realtek/rtw89/ps.c
index 31290d8cb7f7c..92074b73ebebd 100644
--- a/drivers/net/wireless/realtek/rtw89/ps.c
+++ b/drivers/net/wireless/realtek/rtw89/ps.c
@@ -55,7 +55,8 @@ static void rtw89_ps_power_mode_change_with_hci(struct rtw89_dev *rtwdev,
 
 static void rtw89_ps_power_mode_change(struct rtw89_dev *rtwdev, bool enter)
 {
-	if (rtwdev->chip->low_power_hci_modes & BIT(rtwdev->ps_mode))
+	if (rtwdev->chip->low_power_hci_modes & BIT(rtwdev->ps_mode) &&
+	    !test_bit(RTW89_FLAG_WOWLAN, rtwdev->flags))
 		rtw89_ps_power_mode_change_with_hci(rtwdev, enter);
 	else
 		rtw89_mac_power_mode_change(rtwdev, enter);
diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
index ccad026defb50..ca4835008b56e 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -457,14 +457,17 @@ static int rtw89_wow_swap_fw(struct rtw89_dev *rtwdev, bool wow)
 	struct rtw89_wow_param *rtw_wow = &rtwdev->wow;
 	struct ieee80211_vif *wow_vif = rtw_wow->wow_vif;
 	struct rtw89_vif *rtwvif = (struct rtw89_vif *)wow_vif->drv_priv;
+	enum rtw89_core_chip_id chip_id = rtwdev->chip->chip_id;
 	const struct rtw89_chip_info *chip = rtwdev->chip;
 	bool include_bb = !!chip->bbmcu_nr;
+	bool disable_intr_for_dlfw = false;
 	struct ieee80211_sta *wow_sta;
 	struct rtw89_sta *rtwsta = NULL;
 	bool is_conn = true;
 	int ret;
 
-	rtw89_hci_disable_intr(rtwdev);
+	if (chip_id == RTL8852C || chip_id == RTL8922A)
+		disable_intr_for_dlfw = true;
 
 	wow_sta = ieee80211_find_sta(wow_vif, rtwvif->bssid);
 	if (wow_sta)
@@ -472,12 +475,18 @@ static int rtw89_wow_swap_fw(struct rtw89_dev *rtwdev, bool wow)
 	else
 		is_conn = false;
 
+	if (disable_intr_for_dlfw)
+		rtw89_hci_disable_intr(rtwdev);
+
 	ret = rtw89_fw_download(rtwdev, fw_type, include_bb);
 	if (ret) {
 		rtw89_warn(rtwdev, "download fw failed\n");
 		return ret;
 	}
 
+	if (disable_intr_for_dlfw)
+		rtw89_hci_enable_intr(rtwdev);
+
 	rtw89_phy_init_rf_reg(rtwdev, true);
 
 	ret = rtw89_fw_h2c_role_maintain(rtwdev, rtwvif, rtwsta,
@@ -520,7 +529,6 @@ static int rtw89_wow_swap_fw(struct rtw89_dev *rtwdev, bool wow)
 	}
 
 	rtw89_mac_hw_mgnt_sec(rtwdev, wow);
-	rtw89_hci_enable_intr(rtwdev);
 
 	return 0;
 }
-- 
2.43.0



