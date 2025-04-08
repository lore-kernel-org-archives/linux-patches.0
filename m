Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D91F268FD5;
	Tue,  8 Apr 2025 11:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110565; cv=none; b=nY/GkYQtT59O1WelEtqA1ZZqwXtQI2v/HlQf4ZE0kre/MDNHkrK1qIjH/FOugEhoThaHLYEDOFBo3F3oSD8kNS0sQe4sycYcbeZXBDI03635X3XuK3Inp5QRTdOiUAOjK4iqO55jOO6x+DboR2ME0lk+QVStWM/mmjMDc8xiHsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110565; c=relaxed/simple;
	bh=/b0x0iVTnB2pInj3feWzGfylNQ9gxdDlH9EkG3fEzHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEwv8PdipZZI+3u2XrXikYSLURx5MOQK+BoMfPcvuF8Z4+3dbxx2Tsz/6W/GsYUi7WaNg1x8+/CXrZMIjQBSphtgp+PZ9RrkSxpuhOHZ/v02cM7sjMSXZZOfrtlQoCBHPOruBvFi70TmpNaUJjvcQuylsz5r37UOx5RiifEULrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDYhMa3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDYhMa3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2106C4CEE5;
	Tue,  8 Apr 2025 11:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110565;
	bh=/b0x0iVTnB2pInj3feWzGfylNQ9gxdDlH9EkG3fEzHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mDYhMa3KkYLNorwsClLHP4o0mUPEKBSw3K6u9IFluOUqxDaODEqa3fiDvbgokhdjO
	 DoY7KX3MR6I1WkMlpVnpSKBTEqY05nS8sDczvt57Gtk63HZv+kBlqYfoobvLUy7Ndc
	 T2PID+PR7OP1JB0KbZEb6oc4oVuXKKeNq2HEM9i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 111/731] wifi: rtw89: rtw8852b{t}: fix TSSI debug timestamps
Date: Tue,  8 Apr 2025 12:40:08 +0200
Message-ID: <20250408104916.858551445@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit bfc8e71ef6b7913f0129aff47951cab73a175259 ]

Since the vendor driver is claimed to measure 'tssi_alimk_time' of
'struct rtw89_tssi_info' in microseconds, adjust rtw8852b{t}-specific
'_tssi_alimentk()' to not mess the former with nanoseconds and print
both per-call and accumulated times. Compile tested only.

Fixes: 7f18a70d7b4d ("wifi: rtw89: 8852b: rfk: add TSSI")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250213095006.1308810-1-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.h          |  2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c  | 13 +++++++------
 drivers/net/wireless/realtek/rtw89/rtw8852bt_rfk.c | 13 +++++++------
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index ff4894c7fa8a5..93e41def81b40 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -5135,7 +5135,7 @@ struct rtw89_tssi_info {
 	u32 alignment_backup_by_ch[RF_PATH_MAX][TSSI_MAX_CH_NUM][TSSI_ALIMK_VALUE_NUM];
 	u32 alignment_value[RF_PATH_MAX][TSSI_ALIMK_MAX][TSSI_ALIMK_VALUE_NUM];
 	bool alignment_done[RF_PATH_MAX][TSSI_ALIMK_MAX];
-	u32 tssi_alimk_time;
+	u64 tssi_alimk_time;
 };
 
 struct rtw89_power_trim_info {
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c b/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c
index ef47a5facc836..fbf82d42687ba 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c
@@ -3585,9 +3585,10 @@ static void _tssi_alimentk(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy,
 	u8 ch_idx = _tssi_ch_to_idx(rtwdev, channel);
 	struct rtw8852bx_bb_tssi_bak tssi_bak;
 	s32 aliment_diff, tssi_cw_default;
-	u32 start_time, finish_time;
 	u32 bb_reg_backup[8] = {0};
+	ktime_t start_time;
 	const s16 *power;
+	s64 this_time;
 	u8 band;
 	bool ok;
 	u32 tmp;
@@ -3613,7 +3614,7 @@ static void _tssi_alimentk(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy,
 		return;
 	}
 
-	start_time = ktime_get_ns();
+	start_time = ktime_get();
 
 	if (chan->band_type == RTW89_BAND_2G)
 		power = power_2g;
@@ -3738,12 +3739,12 @@ static void _tssi_alimentk(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy,
 	rtw8852bx_bb_restore_tssi(rtwdev, phy, &tssi_bak);
 	rtw8852bx_bb_tx_mode_switch(rtwdev, phy, 0);
 
-	finish_time = ktime_get_ns();
-	tssi_info->tssi_alimk_time += finish_time - start_time;
+	this_time = ktime_us_delta(ktime_get(), start_time);
+	tssi_info->tssi_alimk_time += this_time;
 
 	rtw89_debug(rtwdev, RTW89_DBG_RFK,
-		    "[TSSI PA K] %s processing time = %d ms\n", __func__,
-		    tssi_info->tssi_alimk_time);
+		    "[TSSI PA K] %s processing time = %lld us (acc = %llu us)\n",
+		    __func__, this_time, tssi_info->tssi_alimk_time);
 }
 
 void rtw8852b_dpk_init(struct rtw89_dev *rtwdev)
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852bt_rfk.c b/drivers/net/wireless/realtek/rtw89/rtw8852bt_rfk.c
index 336a83e1d46be..6e6889eea9a0d 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852bt_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852bt_rfk.c
@@ -3663,9 +3663,10 @@ static void _tssi_alimentk(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy,
 	u8 ch_idx = _tssi_ch_to_idx(rtwdev, channel);
 	struct rtw8852bx_bb_tssi_bak tssi_bak;
 	s32 aliment_diff, tssi_cw_default;
-	u32 start_time, finish_time;
 	u32 bb_reg_backup[8] = {};
+	ktime_t start_time;
 	const s16 *power;
+	s64 this_time;
 	u8 band;
 	bool ok;
 	u32 tmp;
@@ -3675,7 +3676,7 @@ static void _tssi_alimentk(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy,
 		    "======> %s   channel=%d   path=%d\n", __func__, channel,
 		    path);
 
-	start_time = ktime_get_ns();
+	start_time = ktime_get();
 
 	if (chan->band_type == RTW89_BAND_2G)
 		power = power_2g;
@@ -3802,12 +3803,12 @@ static void _tssi_alimentk(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy,
 	rtw8852bx_bb_restore_tssi(rtwdev, phy, &tssi_bak);
 	rtw8852bx_bb_tx_mode_switch(rtwdev, phy, 0);
 
-	finish_time = ktime_get_ns();
-	tssi_info->tssi_alimk_time += finish_time - start_time;
+	this_time = ktime_us_delta(ktime_get(), start_time);
+	tssi_info->tssi_alimk_time += this_time;
 
 	rtw89_debug(rtwdev, RTW89_DBG_RFK,
-		    "[TSSI PA K] %s processing time = %d ms\n", __func__,
-		    tssi_info->tssi_alimk_time);
+		    "[TSSI PA K] %s processing time = %lld us (acc = %llu us)\n",
+		    __func__, this_time, tssi_info->tssi_alimk_time);
 }
 
 void rtw8852bt_dpk_init(struct rtw89_dev *rtwdev)
-- 
2.39.5



