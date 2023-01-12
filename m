Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87153749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F47C433D2;
	Thu, 12 Jan 2023 14:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532779;
	bh=MZO7xTw40vn4EbxHtzDFGrss77dn2iPOEfV9pHB8Pz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UqThDdzFEZhDqIOUsGlzJ+LZwV7U08xv+WDbfinXKIHoC9IIEITxmYPbgjX4zdEoY
	 uB/1kze9XwlreLo93M7GBX/KFcOH9shm/uW37rx3zlL3MC2l2a1+4UwVV3Vwfc8UB9
	 FRJ2K3fZrmupMxGAr597s0kRHKl/PrZm/D19QeWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 243/783] wifi: rtl8xxxu: Fix the channel width reporting
Date: Thu, 12 Jan 2023 14:49:19 +0100
Message-Id: <20230112135535.653246610@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 76c16af2cb10282274596e21add2c9f0b95c941b ]

The gen 2 chips RTL8192EU and RTL8188FU periodically send the driver
reports about the TX rate, and the driver passes these reports to
sta_statistics. The reports from RTL8192EU may or may not include the
channel width. The reports from RTL8188FU do not include it.

Only access the c2h->ra_report.bw field if the report (skb) is big
enough.

The other problem fixed here is that the code was actually never
changing the channel width initially reported by
rtl8xxxu_bss_info_changed because the value of RATE_INFO_BW_20 is 0.

Fixes: 0985d3a410ac ("rtl8xxxu: Feed current txrate information for mac80211")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/5b41f1ae-72e7-6b7a-2459-b736399a1c40@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 43898f105bb7..9a12f1d38007 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5520,7 +5520,6 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 			rarpt->txrate.flags = 0;
 			rate = c2h->ra_report.rate;
 			sgi = c2h->ra_report.sgi;
-			bw = c2h->ra_report.bw;
 
 			if (rate < DESC_RATE_MCS0) {
 				rarpt->txrate.legacy =
@@ -5537,8 +5536,13 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 						RATE_INFO_FLAGS_SHORT_GI;
 				}
 
-				if (bw == RATE_INFO_BW_20)
-					rarpt->txrate.bw |= RATE_INFO_BW_20;
+				if (skb->len >= offsetofend(typeof(*c2h), ra_report.bw)) {
+					if (c2h->ra_report.bw == RTL8XXXU_CHANNEL_WIDTH_40)
+						bw = RATE_INFO_BW_40;
+					else
+						bw = RATE_INFO_BW_20;
+					rarpt->txrate.bw = bw;
+				}
 			}
 			bit_rate = cfg80211_calculate_bitrate(&rarpt->txrate);
 			rarpt->bit_rate = bit_rate;
-- 
2.35.1



