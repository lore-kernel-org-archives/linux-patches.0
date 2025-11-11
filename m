Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF2230E82E;
	Tue, 11 Nov 2025 01:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823711; cv=none; b=sj0zEE1ttuoiy3UCYow34JFNqjVjQRaHIatJUtX3yGi9vUDwTUrnmHREwCCRzVkDutbRbQdBlZbnMHBjtl9MxVO/GGb4QG6C0U+qnbJlX1edCubjPd2PPRew3XHBw8bHoGjYc0upR9gwrFd5ekaWl1qW/oBAVP6nXQ+XbdCfpd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823711; c=relaxed/simple;
	bh=DeNMaefLrraRxYvZOAG68/Ca/UbIu1Jz7U9/SSmRQzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQvZKm/A9EQd1jqZrOmye8O1sxPSOdT0mP7eIYoYbfDFwxgHIJ6NMOeBfPFYPGAGhzQo64gfwgxBP66R9qK6ulB+7pW7eZhAHJb6evJYTjCwVJbXChGB1/nIAZbMTRVJDWtYCdC9y+DsGWtNd4i0fKMEE5yxFLSa1SuQYEScCMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zq8GsyT2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zq8GsyT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DC5C113D0;
	Tue, 11 Nov 2025 01:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823707;
	bh=DeNMaefLrraRxYvZOAG68/Ca/UbIu1Jz7U9/SSmRQzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zq8GsyT2Cn3vIOwkBQLUUqF482pj/Jpc0/J2voclOY9kG/XRa25/lHFNx7ESq2prz
	 iwHUg0Qkvw3GPJhjMGnojecPvLgKIYtbBoq18DI28JXUtONQJpT5rrXGtU12mxn/eB
	 IRlLW24LmddwD4zdbsJNuGh1Ldw/Fa3tzcWID9OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ching-Te Ku <ku920601@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 354/849] wifi: rtw89: coex: Limit Wi-Fi scan slot cost to avoid A2DP glitch
Date: Tue, 11 Nov 2025 09:38:44 +0900
Message-ID: <20251111004544.980152532@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ching-Te Ku <ku920601@realtek.com>

[ Upstream commit ebea22c7f1b2f06f4ff0719d76bd19830cf25c9f ]

When Wi-Fi is scanning at 2.4GHz, PTA will abort almost all the BT request.
Once the Wi-Fi slot stay too long, BT audio device can not get enough data,
audio glitch will happened. This patch limit 2.4Ghz Wi-Fi slot to 80ms
while Wi-Fi is scanning to avoid audio glitch.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250819034428.26307-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index e4e6daf51a1ba..0f7ae572ef915 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -93,7 +93,7 @@ static const struct rtw89_btc_fbtc_slot s_def[] = {
 	[CXST_E2G]	= __DEF_FBTC_SLOT(5,   0xea5a5a5a, SLOT_MIX),
 	[CXST_E5G]	= __DEF_FBTC_SLOT(5,   0xffffffff, SLOT_ISO),
 	[CXST_EBT]	= __DEF_FBTC_SLOT(5,   0xe5555555, SLOT_MIX),
-	[CXST_ENULL]	= __DEF_FBTC_SLOT(5,   0xaaaaaaaa, SLOT_ISO),
+	[CXST_ENULL]	= __DEF_FBTC_SLOT(5,   0x55555555, SLOT_MIX),
 	[CXST_WLK]	= __DEF_FBTC_SLOT(250, 0xea5a5a5a, SLOT_MIX),
 	[CXST_W1FDD]	= __DEF_FBTC_SLOT(50,  0xffffffff, SLOT_ISO),
 	[CXST_B1FDD]	= __DEF_FBTC_SLOT(50,  0xffffdfff, SLOT_ISO),
@@ -4153,6 +4153,7 @@ void rtw89_btc_set_policy_v1(struct rtw89_dev *rtwdev, u16 policy_type)
 				     s_def[CXST_EBT].cxtbl, s_def[CXST_EBT].cxtype);
 			_slot_set_le(btc, CXST_ENULL, s_def[CXST_ENULL].dur,
 				     s_def[CXST_ENULL].cxtbl, s_def[CXST_ENULL].cxtype);
+			_slot_set_dur(btc, CXST_EBT, dur_2);
 			break;
 		case BTC_CXP_OFFE_DEF2:
 			_slot_set(btc, CXST_E2G, 20, cxtbl[1], SLOT_ISO);
@@ -4162,6 +4163,7 @@ void rtw89_btc_set_policy_v1(struct rtw89_dev *rtwdev, u16 policy_type)
 				     s_def[CXST_EBT].cxtbl, s_def[CXST_EBT].cxtype);
 			_slot_set_le(btc, CXST_ENULL, s_def[CXST_ENULL].dur,
 				     s_def[CXST_ENULL].cxtbl, s_def[CXST_ENULL].cxtype);
+			_slot_set_dur(btc, CXST_EBT, dur_2);
 			break;
 		case BTC_CXP_OFFE_2GBWMIXB:
 			if (a2dp->exist)
@@ -4170,6 +4172,7 @@ void rtw89_btc_set_policy_v1(struct rtw89_dev *rtwdev, u16 policy_type)
 				_slot_set(btc, CXST_E2G, 5, tbl_w1, SLOT_MIX);
 			_slot_set_le(btc, CXST_EBT, cpu_to_le16(40),
 				     s_def[CXST_EBT].cxtbl, s_def[CXST_EBT].cxtype);
+			_slot_set_dur(btc, CXST_EBT, dur_2);
 			break;
 		case BTC_CXP_OFFE_WL: /* for 4-way */
 			_slot_set(btc, CXST_E2G, 5, cxtbl[1], SLOT_MIX);
-- 
2.51.0



