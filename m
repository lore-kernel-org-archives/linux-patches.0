Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE321607A2;
	Mon, 27 May 2024 19:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838127; cv=none; b=GBRfYhNvRMTm2swCdp9EH++nGAgWRDvAewumeXsC5qVXL0QO7QcW4Blh93VwYWROTRxtWSYg6DvWRMTfCvggB2Ejebv3IHCWBLm9P5yGr4ajjOif5YVZbu2gwW2fhXZarKqN4rgjLfhZpo/r6EWgoZIltZ/i1TR+HjVeSoM8K+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838127; c=relaxed/simple;
	bh=TNyvqMRDHubCvk8T/pOQ0kHq5SYgnRN9BIfxM2OS0vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/C09i21O6qQLt9dHF0nRRwU7JGSq6sV/FW9mjcjcCig/Tof7nvhJKdPKyjHQoyK5Rkss+e07LZL7zCbPCc7qXz+5ZZGjK7PJ+rxnKR/K1HN92zJkKstvQrUhJlK5ZYEvtcoQ2eA4f/XZ2CwZOa3kCP0+vvODP2yuKlhrvQKwqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1z6DCIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1z6DCIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD202C2BBFC;
	Mon, 27 May 2024 19:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838127;
	bh=TNyvqMRDHubCvk8T/pOQ0kHq5SYgnRN9BIfxM2OS0vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1z6DCIlQqItrNExM9laICY+8a57mjW5AqvRJ5ZW/nbMbsVBrWeLNZYm5m6LPS4TD
	 IbXvyyubEF9JeoKsDktmi6ATX9+GwwOKqUTIiEK0nxWvFTH3uXVw7TGGJxJOuHFqXO
	 fj5TAfixncc/MpbeQnYUrmvCNAuAQYYTlYB/Bmd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 277/493] wifi: rtw89: wow: refine WoWLAN flows of HCI interrupts and low power mode
Date: Mon, 27 May 2024 20:54:39 +0200
Message-ID: <20240527185639.362109375@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 917c01e5e9eda..e86d5588ec609 100644
--- a/drivers/net/wireless/realtek/rtw89/ps.c
+++ b/drivers/net/wireless/realtek/rtw89/ps.c
@@ -54,7 +54,8 @@ static void rtw89_ps_power_mode_change_with_hci(struct rtw89_dev *rtwdev,
 
 static void rtw89_ps_power_mode_change(struct rtw89_dev *rtwdev, bool enter)
 {
-	if (rtwdev->chip->low_power_hci_modes & BIT(rtwdev->ps_mode))
+	if (rtwdev->chip->low_power_hci_modes & BIT(rtwdev->ps_mode) &&
+	    !test_bit(RTW89_FLAG_WOWLAN, rtwdev->flags))
 		rtw89_ps_power_mode_change_with_hci(rtwdev, enter);
 	else
 		rtw89_mac_power_mode_change(rtwdev, enter);
diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
index 5c7ca36c09b6b..abb4d1cc55d0e 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -489,14 +489,17 @@ static int rtw89_wow_swap_fw(struct rtw89_dev *rtwdev, bool wow)
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
@@ -504,12 +507,18 @@ static int rtw89_wow_swap_fw(struct rtw89_dev *rtwdev, bool wow)
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
@@ -552,7 +561,6 @@ static int rtw89_wow_swap_fw(struct rtw89_dev *rtwdev, bool wow)
 	}
 
 	rtw89_mac_hw_mgnt_sec(rtwdev, wow);
-	rtw89_hci_enable_intr(rtwdev);
 
 	return 0;
 }
-- 
2.43.0



