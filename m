Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C55340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301073; cv=none; b=QZZte3/C/qa7yHKoHqg+1OOiV3ufN8TIx5SbmSUrQCQ6/ghTKzwdkT9h4Z+ns/1A6T5bH0q/ImaKTtE7MapqUA4vgze0ayJqGRUo96BHYSluIE6xj1gp4K29VME3T1VFi5NKsc5q4+yyy7wbf2sjmUYW2+vBldkmLBeRkbprF0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301073; c=relaxed/simple;
	bh=wFq4d3ALJG7o8NFf5E7PzDOA1+OuEiswcuwFfR4BW5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3j2AhcoWV1oH4N3Z7t1PE/Ttq5HsMGIcWjxTTI+8e4bx8hSdK29Kj8tEf16OXRq/PzF6vfULPAUIgPSnQXADYrpifYnf529+y3qFuZHzyhxzM3+XoidcSdStQO7RuL+8mQq4l5UYb9zYw8Fh94eDOO/4ecVYnfR5QnZmdmAOvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KFhZw7HW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KFhZw7HW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44238C116D0;
	Sat, 28 Feb 2026 17:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301073;
	bh=wFq4d3ALJG7o8NFf5E7PzDOA1+OuEiswcuwFfR4BW5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KFhZw7HWtpK2BNSQH4awadZwWzYvnX939m/si6KHXdmEIaDBKqH7W6SCk7JzVHbgt
	 128ZcRQWe7HYXCLRX7iQnqoTi1jdwzhKJMVVXWwK4gvZN27Yi3urptDL0b24DRBfNd
	 UwtyarZjv6Zilm1x3TGQz6C7t7MYsM/4fvTyInMZa+XqbsV7rs+8bzEnwmyhE7pxbu
	 QoQA4K+75uIx5NaLq/vEY4Hsph9WgDnPRVTPCUMkRTm3xNErETuRTYugC59GjkD8Y6
	 lGwuk9S9rX6YfGBio+URzrSVmq1r85XMyuDUqsomfWwVZW6lZ6x+K7pna+tK+V1qUE
	 dmPIbzoneDbbg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 219/752] wifi: rtw89: setting TBTT AGG number when mac port initialization
Date: Sat, 28 Feb 2026 12:38:50 -0500
Message-ID: <20260228174750.1542406-219-sashal@kernel.org>
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

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit 5e5f83fba48381098b26a8b2513a6d5fc5c66ccb ]

When initializing mac port, needs to set TBTT AGG number to trigger TBTT
related interrupts. Otherwise, after sending join info H2C command with
disconnection mode, firmware will clear TBTT AGG number. Without the
setting from mac port initialization after that, this port will not be
able to transmit beacons.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251223030651.480633-12-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 2de75d22c97f2..df429bdef7956 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -4262,6 +4262,7 @@ static void rtw89_mac_bcn_drop(struct rtw89_dev *rtwdev,
 #define BCN_HOLD_DEF 200
 #define BCN_MASK_DEF 0
 #define TBTT_ERLY_DEF 5
+#define TBTT_AGG_DEF 1
 #define BCN_SET_UNIT 32
 #define BCN_ERLY_SET_DLY (10 * 2)
 
@@ -4565,6 +4566,16 @@ static void rtw89_mac_port_cfg_tbtt_early(struct rtw89_dev *rtwdev,
 				B_AX_TBTTERLY_MASK, TBTT_ERLY_DEF);
 }
 
+static void rtw89_mac_port_cfg_tbtt_agg(struct rtw89_dev *rtwdev,
+					struct rtw89_vif_link *rtwvif_link)
+{
+	const struct rtw89_mac_gen_def *mac = rtwdev->chip->mac_def;
+	const struct rtw89_port_reg *p = mac->port_base;
+
+	rtw89_write16_port_mask(rtwdev, rtwvif_link, p->tbtt_agg,
+				B_AX_TBTT_AGG_NUM_MASK, TBTT_AGG_DEF);
+}
+
 static void rtw89_mac_port_cfg_bss_color(struct rtw89_dev *rtwdev,
 					 struct rtw89_vif_link *rtwvif_link)
 {
@@ -4825,6 +4836,7 @@ int rtw89_mac_port_update(struct rtw89_dev *rtwdev, struct rtw89_vif_link *rtwvi
 	rtw89_mac_port_cfg_bcn_hold_time(rtwdev, rtwvif_link);
 	rtw89_mac_port_cfg_bcn_mask_area(rtwdev, rtwvif_link);
 	rtw89_mac_port_cfg_tbtt_early(rtwdev, rtwvif_link);
+	rtw89_mac_port_cfg_tbtt_agg(rtwdev, rtwvif_link);
 	rtw89_mac_port_cfg_bss_color(rtwdev, rtwvif_link);
 	rtw89_mac_port_cfg_mbssid(rtwdev, rtwvif_link);
 	rtw89_mac_port_cfg_func_en(rtwdev, rtwvif_link, true);
-- 
2.51.0

