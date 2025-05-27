Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE8327FB02;
	Tue, 27 May 2025 17:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368160; cv=none; b=HC/aO9T8bfTdUnlwBIRsYXx66oHzxRdrAyVxvo6a3PgrKR4fiiooJABR0HzYadmfczHi40W19YaGZsA66CdqgNnl+5pfTcniPwTLJyLt4IrJ4tzmPRKPEzGAOPe0ksSyIasSKYPq+2RX0edDqSUomtLuBcczONfoAv5AKN4aQq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368160; c=relaxed/simple;
	bh=W5EhVjEykx08aCcuY06QOMixQrFPNmj/5GHdK+Z8RYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItYaEmy263v0uyXcpF9ZigNLn26Hup0J8vK7tiPArbniTdxjjVEJAyo/8dEI9jLxA7itLNeeEfYu1uxbec12GsB/TSJy3mhoKRRvyLOujmFQnZ2JbFclYt1Ip5z9v7uN2pBX9MT8CCAZFxacdeUBCKrGbibvZqjSvzg7Bcx6qS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbyxXIn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbyxXIn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6B8C4CEE9;
	Tue, 27 May 2025 17:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368159;
	bh=W5EhVjEykx08aCcuY06QOMixQrFPNmj/5GHdK+Z8RYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbyxXIn/Ng/X85vHT9QdAkN2aTbKEYusW3Gx/YZYTvR7M/swH4tyKz7lkeOSQ4lXc
	 THYDHIiepbUDaDWpQ/eErv4sych4ndvdoma2JGb+YdTv5w7N77+OqiChM9AnZTLCrr
	 TXb2tJakJsm7LceSl3MtpAWG/SqzdZZc7KHUs+hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ching-Te Ku <ku920601@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 618/783] wifi: rtw89: coex: Separated Wi-Fi connecting event from Wi-Fi scan event
Date: Tue, 27 May 2025 18:26:55 +0200
Message-ID: <20250527162538.319230846@linuxfoundation.org>
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

From: Ching-Te Ku <ku920601@realtek.com>

[ Upstream commit 4a57346652154bb339c48b41166df9154cff33f5 ]

Wi-Fi connecting process don't need to assign to firmware slot control,
if assign firmware slot control for Wi-Fi connecting event, firmware will
not toggle slots because driver don't tell the slot schedule to firmware.
Wi-Fi connecting event end should also cancel the 4way handshake status.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250110015416.10704-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index d94a028555e20..7b10ee97c6277 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -5406,7 +5406,8 @@ static void _action_wl_scan(struct rtw89_dev *rtwdev)
 	struct rtw89_btc_wl_info *wl = &btc->cx.wl;
 	struct rtw89_btc_wl_dbcc_info *wl_dinfo = &wl->dbcc_info;
 
-	if (RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD, &rtwdev->fw)) {
+	if (btc->cx.state_map != BTC_WLINKING &&
+	    RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD, &rtwdev->fw)) {
 		_action_wl_25g_mcc(rtwdev);
 		rtw89_debug(rtwdev, RTW89_DBG_BTC, "[BTC], Scan offload!\n");
 	} else if (rtwdev->dbcc_en) {
@@ -7221,6 +7222,8 @@ void rtw89_btc_ntfy_scan_finish(struct rtw89_dev *rtwdev, u8 phy_idx)
 		_fw_set_drv_info(rtwdev, CXDRVINFO_DBCC);
 	}
 
+	btc->dm.tdma_instant_excute = 1;
+
 	_run_coex(rtwdev, BTC_RSN_NTFY_SCAN_FINISH);
 }
 
@@ -7669,7 +7672,8 @@ void rtw89_btc_ntfy_role_info(struct rtw89_dev *rtwdev,
 	else
 		wl->status.map.connecting = 0;
 
-	if (state == BTC_ROLE_MSTS_STA_DIS_CONN)
+	if (state == BTC_ROLE_MSTS_STA_DIS_CONN ||
+	    state == BTC_ROLE_MSTS_STA_CONN_END)
 		wl->status.map._4way = false;
 
 	_run_coex(rtwdev, BTC_RSN_NTFY_ROLE_INFO);
-- 
2.39.5



