Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2618E2DE717
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301109; cv=none; b=qyJu4Y32e4/SZYt6KNd7gAugWq9GRt2EZ/gp9HcklRFM4enWQv7RljBUJfBpsAznCxuUv7PV6UrIwQIfRVkVpfEhQPJTpNurscbeaFLjOiuwoaURRhDzxM0rjCTFdBn8yaRgYGKlIi7xPoH2I49L+cjHgVRJYUXZ8I3Nmmb14GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301109; c=relaxed/simple;
	bh=LdrVkIQv8aPAJVZRIakDY6g9NKU6Qt7ODTGijZEzq9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lO+WfujPnrHk+8mMK00azYmtfnKnUGIeyJMOZDqsOPQVUp0Vpd6c90RHBn0NKgdpFZlJrSAHTWV349E87wC2mpCq+FQVCHFPI3acb2odoGTh5L/qFkxujyrFtpLcuw9/JXYEFEVRjXKbg5g1t5UfhIYtVYldC4Qr+AD8RRG87Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGeAgbYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGeAgbYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E674C116D0;
	Sat, 28 Feb 2026 17:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301108;
	bh=LdrVkIQv8aPAJVZRIakDY6g9NKU6Qt7ODTGijZEzq9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGeAgbYlSBtDfhlxsvATQxns6PjB+hJ+1KOEnYjtAKKsoV+wyWPg0a1d1czXVhVwy
	 9ukYEV0SINicnVHIxHYgblTq1p8x3b2+kxs0DKGc3fu/6CLHjBbFW5rCvELbEOS6Je
	 5S2yMLlw9XCG4FRd3NAYfY3Y3XhoS4K20JsPobsYa0N66P7Fq1ue9fgZZnBwPmytEk
	 kN2Grr22iUBwuGYvHNyA86QzFUQFibMrqA+wWF7nZnHpw3iTc8oPlr1GSb4cbvF1yT
	 v32h6KZ6oAwDyoFQ/Q4SiDiLuF9vEBFMSKzN8cGC4WZs998m+f4fm7VjYBqEw6Kbpx
	 c15WuJ+cgWe0Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Po-Hao Huang <phhuang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 263/752] wifi: rtw89: 8922a: add digital compensation for 2GHz
Date: Sat, 28 Feb 2026 12:39:34 -0500
Message-ID: <20260228174750.1542406-263-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit 8da7e88682d58a7c2e2c2101e49d3c9c9ac481b0 ]

This fixes transmit power too low under 2GHz connection. Previously
we missed the settings of 2GHz, add the according calibrated tables.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260117044157.2392958-10-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8922a.c | 57 +++++++++++++++----
 1 file changed, 47 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922a.c b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
index 757dedd1a11d5..730e5d0d65750 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
@@ -1770,6 +1770,32 @@ static int rtw8922a_ctrl_rx_path_tmac(struct rtw89_dev *rtwdev,
 }
 
 #define DIGITAL_PWR_COMP_REG_NUM 22
+static const u32 rtw8922a_digital_pwr_comp_2g_s0_val[][DIGITAL_PWR_COMP_REG_NUM] = {
+	{0x012C0064, 0x04B00258, 0x00432710, 0x019000A7, 0x06400320,
+	 0x0D05091D, 0x14D50FA0, 0x00000000, 0x01010000, 0x00000101,
+	 0x01010101, 0x02020201, 0x02010000, 0x03030202, 0x00000303,
+	 0x03020101, 0x06060504, 0x01010000, 0x06050403, 0x01000606,
+	 0x05040202, 0x07070706},
+	{0x012C0064, 0x04B00258, 0x00432710, 0x019000A7, 0x06400320,
+	 0x0D05091D, 0x14D50FA0, 0x00000000, 0x01010100, 0x00000101,
+	 0x01000000, 0x01010101, 0x01010000, 0x02020202, 0x00000404,
+	 0x03020101, 0x04040303, 0x02010000, 0x03030303, 0x00000505,
+	 0x03030201, 0x05050303},
+};
+
+static const u32 rtw8922a_digital_pwr_comp_2g_s1_val[][DIGITAL_PWR_COMP_REG_NUM] = {
+	{0x012C0064, 0x04B00258, 0x00432710, 0x019000A7, 0x06400320,
+	 0x0D05091D, 0x14D50FA0, 0x01010000, 0x01010101, 0x00000101,
+	 0x01010100, 0x01010101, 0x01010000, 0x02020202, 0x01000202,
+	 0x02020101, 0x03030202, 0x02010000, 0x05040403, 0x01000606,
+	 0x05040302, 0x07070605},
+	{0x012C0064, 0x04B00258, 0x00432710, 0x019000A7, 0x06400320,
+	 0x0D05091D, 0x14D50FA0, 0x00000000, 0x01010100, 0x00000101,
+	 0x01010000, 0x02020201, 0x02010100, 0x03030202, 0x01000404,
+	 0x04030201, 0x05050404, 0x01010100, 0x04030303, 0x01000505,
+	 0x03030101, 0x05050404},
+};
+
 static const u32 rtw8922a_digital_pwr_comp_val[][DIGITAL_PWR_COMP_REG_NUM] = {
 	{0x012C0096, 0x044C02BC, 0x00322710, 0x015E0096, 0x03C8028A,
 	 0x0BB80708, 0x17701194, 0x02020100, 0x03030303, 0x01000303,
@@ -1784,7 +1810,7 @@ static const u32 rtw8922a_digital_pwr_comp_val[][DIGITAL_PWR_COMP_REG_NUM] = {
 };
 
 static void rtw8922a_set_digital_pwr_comp(struct rtw89_dev *rtwdev,
-					  bool enable, u8 nss,
+					  u8 band, u8 nss,
 					  enum rtw89_rf_path path)
 {
 	static const u32 ltpc_t0[2] = {R_BE_LTPC_T0_PATH0, R_BE_LTPC_T0_PATH1};
@@ -1792,14 +1818,25 @@ static void rtw8922a_set_digital_pwr_comp(struct rtw89_dev *rtwdev,
 	u32 addr, val;
 	u32 i;
 
-	if (nss == 1)
-		digital_pwr_comp = rtw8922a_digital_pwr_comp_val[0];
-	else
-		digital_pwr_comp = rtw8922a_digital_pwr_comp_val[1];
+	if (nss == 1) {
+		if (band == RTW89_BAND_2G)
+			digital_pwr_comp = path == RF_PATH_A ?
+				rtw8922a_digital_pwr_comp_2g_s0_val[0] :
+				rtw8922a_digital_pwr_comp_2g_s1_val[0];
+		else
+			digital_pwr_comp = rtw8922a_digital_pwr_comp_val[0];
+	} else {
+		if (band == RTW89_BAND_2G)
+			digital_pwr_comp = path == RF_PATH_A ?
+				rtw8922a_digital_pwr_comp_2g_s0_val[1] :
+				rtw8922a_digital_pwr_comp_2g_s1_val[1];
+		else
+			digital_pwr_comp = rtw8922a_digital_pwr_comp_val[1];
+	}
 
 	addr = ltpc_t0[path];
 	for (i = 0; i < DIGITAL_PWR_COMP_REG_NUM; i++, addr += 4) {
-		val = enable ? digital_pwr_comp[i] : 0;
+		val = digital_pwr_comp[i];
 		rtw89_phy_write32(rtwdev, addr, val);
 	}
 }
@@ -1808,7 +1845,7 @@ static void rtw8922a_digital_pwr_comp(struct rtw89_dev *rtwdev,
 				      enum rtw89_phy_idx phy_idx)
 {
 	const struct rtw89_chan *chan = rtw89_chan_get(rtwdev, RTW89_CHANCTX_0);
-	bool enable = chan->band_type != RTW89_BAND_2G;
+	u8 band = chan->band_type;
 	u8 path;
 
 	if (rtwdev->mlo_dbcc_mode == MLO_1_PLUS_1_1RF) {
@@ -1816,10 +1853,10 @@ static void rtw8922a_digital_pwr_comp(struct rtw89_dev *rtwdev,
 			path = RF_PATH_A;
 		else
 			path = RF_PATH_B;
-		rtw8922a_set_digital_pwr_comp(rtwdev, enable, 1, path);
+		rtw8922a_set_digital_pwr_comp(rtwdev, band, 1, path);
 	} else {
-		rtw8922a_set_digital_pwr_comp(rtwdev, enable, 2, RF_PATH_A);
-		rtw8922a_set_digital_pwr_comp(rtwdev, enable, 2, RF_PATH_B);
+		rtw8922a_set_digital_pwr_comp(rtwdev, band, 2, RF_PATH_A);
+		rtw8922a_set_digital_pwr_comp(rtwdev, band, 2, RF_PATH_B);
 	}
 }
 
-- 
2.51.0

