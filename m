Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FA31FB3;
	Tue, 27 May 2025 17:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367918; cv=none; b=EQBEaTXx5XNeX597ulU+/mxutEfYbs3Dsobo2YjX52qMd/BQvdvmPmx6bfu9Rq1+kKknHMNhhRqD1zj0DAypoGtjZoPKqF6QmIMo6NlvNpr1rgKDkFILQi7ZekhZZDKMX004SfM/Y/JBX10Q1r9jfwqDvQmtqvCdq1hypK8Gra0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367918; c=relaxed/simple;
	bh=3jPYP2D9MHHNZ8TULLSgrlCYOpC2tR6eCnz+jN3UpoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOY4UeHfYEZtDTuSzJ1XzDD+a2psJb9St7uMiGkggO9/IqUzZMICAgngm86FLUGIR50r3g9fcD0vPOAfnFx/gsvfsKf1sihVAI+IaKLi4ODDoy9lUNYhgKwifFhy5rYAuM+VTRmASVBWmMlFJ7dgwbFUUhuTzUDipf4r+Tahsf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFAJDZwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFAJDZwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8607C4CEE9;
	Tue, 27 May 2025 17:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367918;
	bh=3jPYP2D9MHHNZ8TULLSgrlCYOpC2tR6eCnz+jN3UpoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFAJDZwRX9XVkyWDXOb+bhNxmgFE9sAnz/YGG8V7ssZQEQtIEWzHTDstd+h+imCRI
	 q/+vCWRPsApTI11cYvDMR09xrLbDs8kjRkm3wF82Em0xAKOb9r+5FS+1FNqzlgEUMo
	 yU8gWneXnTVuj1+30z3O54at5gUq1r0mwxGGA3Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 539/783] wifi: rtw88: Fix rtw_update_sta_info() for RTL8814AU
Date: Tue, 27 May 2025 18:25:36 +0200
Message-ID: <20250527162535.112126873@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 9f00e2218e15a2ea3c284567424a100c10b6fb85 ]

This function tells the firmware what rates it can use.

Put the 3SS and 4SS HT rates supported by the other station into the
rate mask.

Remove the 3SS and 4SS rates from the rate mask if the hardware only has
2 spatial streams.

And finally, select the right rate ID (a parameter for the firmware)
when the hardware has 3 spatial streams.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/48d1d90f-2aeb-4ec5-9a24-0980e10eae1e@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index f4ee4e922afa7..9b9e76eebce95 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1234,7 +1234,9 @@ void rtw_update_sta_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si,
 		if (sta->deflink.vht_cap.cap & IEEE80211_VHT_CAP_RXLDPC)
 			ldpc_en = VHT_LDPC_EN;
 	} else if (sta->deflink.ht_cap.ht_supported) {
-		ra_mask |= (sta->deflink.ht_cap.mcs.rx_mask[1] << 20) |
+		ra_mask |= ((u64)sta->deflink.ht_cap.mcs.rx_mask[3] << 36) |
+			   ((u64)sta->deflink.ht_cap.mcs.rx_mask[2] << 28) |
+			   (sta->deflink.ht_cap.mcs.rx_mask[1] << 20) |
 			   (sta->deflink.ht_cap.mcs.rx_mask[0] << 12);
 		if (sta->deflink.ht_cap.cap & IEEE80211_HT_CAP_RX_STBC)
 			stbc_en = HT_STBC_EN;
@@ -1244,6 +1246,9 @@ void rtw_update_sta_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si,
 
 	if (efuse->hw_cap.nss == 1 || rtwdev->hal.txrx_1ss)
 		ra_mask &= RA_MASK_VHT_RATES_1SS | RA_MASK_HT_RATES_1SS;
+	else if (efuse->hw_cap.nss == 2)
+		ra_mask &= RA_MASK_VHT_RATES_2SS | RA_MASK_HT_RATES_2SS |
+			   RA_MASK_VHT_RATES_1SS | RA_MASK_HT_RATES_1SS;
 
 	if (hal->current_band_type == RTW_BAND_5G) {
 		ra_mask |= (u64)sta->deflink.supp_rates[NL80211_BAND_5GHZ] << 4;
@@ -1302,10 +1307,9 @@ void rtw_update_sta_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si,
 		break;
 	}
 
-	if (sta->deflink.vht_cap.vht_supported && ra_mask & 0xffc00000)
-		tx_num = 2;
-	else if (sta->deflink.ht_cap.ht_supported && ra_mask & 0xfff00000)
-		tx_num = 2;
+	if (sta->deflink.vht_cap.vht_supported ||
+	    sta->deflink.ht_cap.ht_supported)
+		tx_num = efuse->hw_cap.nss;
 
 	rate_id = get_rate_id(wireless_set, bw_mode, tx_num);
 
-- 
2.39.5



