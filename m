Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A8E340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301081; cv=none; b=e/okBX0A7wxBvDKxb2b7KhoeMGeFpmiuSo+ihuyhdnBZrl4VyVyI54CojS5b1nB3IbwGjxw3JKKLw/6h8710LUSXNH6JlwyqwZhGa8Z4V2Y1uN7+j8s9nMAsnx14OrdMwErFa/nsGEGrPruJR0eeA9MWMnB0ekcHSsqwARusMXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301081; c=relaxed/simple;
	bh=YNl1ruKeNTu0Qjgg2uYFCwt3Hi3Kc4jaKDuPweeGFDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDj0RoBcQpynDp+eFZFqw0rl8CPXjuxEIE3Cz/pDLO1tVG4u1qlHzEHeNDLce+uOvZ77z0l1fLh4LTaDc7xvPQFM/Csx6PatSgtIdYOGQpH092m4LOZ80JBv/f2djwF5uvPpH7g6nf2su+FLckw3RCMIPL+sjZ6VTkgPBZvKtiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlgSJ7gL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlgSJ7gL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B92C19423;
	Sat, 28 Feb 2026 17:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301080;
	bh=YNl1ruKeNTu0Qjgg2uYFCwt3Hi3Kc4jaKDuPweeGFDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlgSJ7gLSlHcaITF7+w8TkibtvecM3/Y74GnPclXDg/kGBr17PkMrw4iYgjl6zfTR
	 U0Jhzeljkzw5ULgedxjElaUehnNqhpExq2V75hi42M5Uwd7OQUWfeJeBmxnwKlM3oT
	 b/N81pcdA91OtYbMAxDZS1oLzYQizzRGj1G/3oB2e19ppRcgyPBCDPvpUzQWZeifkR
	 ZXXpEQVZzh6iBLHG+30OlfIJggO40gTbz7JXslQTBRmw4NNRguPlv5yKOYF2Yz/IIi
	 kCpbzprDpemGKrrG/wX9uSI6MYoSXoKUB8Ja0o7m/5KOTJi5rqN35n+9XSvBuF9g2c
	 H8ygjQjli9e5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kuan-Chung Chen <damon.chen@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 228/752] wifi: rtw89: fix potential zero beacon interval in beacon tracking
Date: Sat, 28 Feb 2026 12:38:59 -0500
Message-ID: <20260228174750.1542406-228-sashal@kernel.org>
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

From: Kuan-Chung Chen <damon.chen@realtek.com>

[ Upstream commit eb57be32f438c57c88d6ce756101c1dfbcc03bba ]

During fuzz testing, it was discovered that bss_conf->beacon_int
might be zero, which could result in a division by zero error in
subsequent calculations. Set a default value of 100 TU if the
interval is zero to ensure stability.

Signed-off-by: Kuan-Chung Chen <damon.chen@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251231090647.56407-11-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 917b2adede61d..ed6018f54f20a 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2655,7 +2655,7 @@ static void rtw89_core_bcn_track_assoc(struct rtw89_dev *rtwdev,
 
 	rcu_read_lock();
 	bss_conf = rtw89_vif_rcu_dereference_link(rtwvif_link, true);
-	beacon_int = bss_conf->beacon_int;
+	beacon_int = bss_conf->beacon_int ?: 100;
 	dtim = bss_conf->dtim_period;
 	rcu_read_unlock();
 
@@ -2685,9 +2685,7 @@ static void rtw89_core_bcn_track_reset(struct rtw89_dev *rtwdev)
 	memset(&rtwdev->bcn_track, 0, sizeof(rtwdev->bcn_track));
 }
 
-static void rtw89_vif_rx_bcn_stat(struct rtw89_dev *rtwdev,
-				  struct ieee80211_bss_conf *bss_conf,
-				  struct sk_buff *skb)
+static void rtw89_vif_rx_bcn_stat(struct rtw89_dev *rtwdev, struct sk_buff *skb)
 {
 #define RTW89_APPEND_TSF_2GHZ 384
 #define RTW89_APPEND_TSF_5GHZ 52
@@ -2696,7 +2694,7 @@ static void rtw89_vif_rx_bcn_stat(struct rtw89_dev *rtwdev,
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	struct rtw89_beacon_stat *bcn_stat = &rtwdev->phystat.bcn_stat;
 	struct rtw89_beacon_track_info *bcn_track = &rtwdev->bcn_track;
-	u32 bcn_intvl_us = ieee80211_tu_to_usec(bss_conf->beacon_int);
+	u32 bcn_intvl_us = ieee80211_tu_to_usec(bcn_track->beacon_int);
 	u64 tsf = le64_to_cpu(mgmt->u.beacon.timestamp);
 	u8 wp, num = bcn_stat->num;
 	u16 append;
@@ -2704,6 +2702,10 @@ static void rtw89_vif_rx_bcn_stat(struct rtw89_dev *rtwdev,
 	if (!RTW89_CHK_FW_FEATURE(BEACON_TRACKING, &rtwdev->fw))
 		return;
 
+	/* Skip if not yet associated */
+	if (!bcn_intvl_us)
+		return;
+
 	switch (rx_status->band) {
 	default:
 	case NL80211_BAND_2GHZ:
@@ -2791,7 +2793,7 @@ static void rtw89_vif_rx_stats_iter(void *data, u8 *mac,
 		pkt_stat->beacon_rate = desc_info->data_rate;
 		pkt_stat->beacon_len = skb->len;
 
-		rtw89_vif_rx_bcn_stat(rtwdev, bss_conf, skb);
+		rtw89_vif_rx_bcn_stat(rtwdev, skb);
 	}
 
 	if (!ether_addr_equal(bss_conf->addr, hdr->addr1))
-- 
2.51.0

