Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73CD42A9B;
	Tue, 27 May 2025 17:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368104; cv=none; b=pjArOmf3lcmp1rh5fy0xI73z4lvgxDf0hjtAaM1ampnpUNmYlra27JufxP8cE8Wf6DpTmNNcHaYJkPqTlO3bBC1RfGEyNLGoDIO9X0rtI5LYl+ZZum97UqRJWh8757YQOW74zPQTCSICoSIW2uMJT9qQJNYQsJ6DXduYGYyX8kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368104; c=relaxed/simple;
	bh=u9bb5PJ7qn13Yvxh3KUE4si8BBJXEpd4vVpfJ7+b5+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wm0Z+Iwz1qeWbyBuXDEDtN2xwupnK4cjh81Jxb16QJm8+MfXeb+ZoIaS+IMJYbznT5+A6oyen9sr/i4TMTfScchxLD+kRYuhr3AHN/VFprFjq5ttL2rQnNKEfu1D/6/EXi3ED/QFx1SahtsZViJdC5ixGifJGxxXlVi0BkNjwhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztjFfIaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztjFfIaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C34C4CEE9;
	Tue, 27 May 2025 17:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368103;
	bh=u9bb5PJ7qn13Yvxh3KUE4si8BBJXEpd4vVpfJ7+b5+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ztjFfIaf5rdi44xC3UEUY/HIwpHpCCdsQzUSfFlDEn3oMTEfftiRQY5GPA3lPQCuc
	 QIQIp8H78OvHCfDdjji69L7vDqNbrQq3qrGzGbSqvM80IfBXXv2ErfG++oQahSiiiD
	 plIMctAIv5coizIFWhrci5MiW78AR+AdxbC9Ros0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 599/783] wifi: rtw88: Dont use static local variable in rtw8822b_set_tx_power_index_by_rate
Date: Tue, 27 May 2025 18:26:36 +0200
Message-ID: <20250527162537.532193720@linuxfoundation.org>
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

[ Upstream commit 00451eb3bec763f708e7e58326468c1e575e5a66 ]

Some users want to plug two identical USB devices at the same time.
This static variable could theoretically cause them to use incorrect
TX power values.

Move the variable to the caller and pass a pointer to it to
rtw8822b_set_tx_power_index_by_rate().

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/8a60f581-0ab5-4d98-a97d-dd83b605008f@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index 7f03903ddf4bb..23a29019752da 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -935,11 +935,11 @@ static void query_phy_status(struct rtw_dev *rtwdev, u8 *phy_status,
 }
 
 static void
-rtw8822b_set_tx_power_index_by_rate(struct rtw_dev *rtwdev, u8 path, u8 rs)
+rtw8822b_set_tx_power_index_by_rate(struct rtw_dev *rtwdev, u8 path,
+				    u8 rs, u32 *phy_pwr_idx)
 {
 	struct rtw_hal *hal = &rtwdev->hal;
 	static const u32 offset_txagc[2] = {0x1d00, 0x1d80};
-	static u32 phy_pwr_idx;
 	u8 rate, rate_idx, pwr_index, shift;
 	int j;
 
@@ -947,12 +947,12 @@ rtw8822b_set_tx_power_index_by_rate(struct rtw_dev *rtwdev, u8 path, u8 rs)
 		rate = rtw_rate_section[rs][j];
 		pwr_index = hal->tx_pwr_tbl[path][rate];
 		shift = rate & 0x3;
-		phy_pwr_idx |= ((u32)pwr_index << (shift * 8));
+		*phy_pwr_idx |= ((u32)pwr_index << (shift * 8));
 		if (shift == 0x3) {
 			rate_idx = rate & 0xfc;
 			rtw_write32(rtwdev, offset_txagc[path] + rate_idx,
-				    phy_pwr_idx);
-			phy_pwr_idx = 0;
+				    *phy_pwr_idx);
+			*phy_pwr_idx = 0;
 		}
 	}
 }
@@ -960,11 +960,13 @@ rtw8822b_set_tx_power_index_by_rate(struct rtw_dev *rtwdev, u8 path, u8 rs)
 static void rtw8822b_set_tx_power_index(struct rtw_dev *rtwdev)
 {
 	struct rtw_hal *hal = &rtwdev->hal;
+	u32 phy_pwr_idx = 0;
 	int rs, path;
 
 	for (path = 0; path < hal->rf_path_num; path++) {
 		for (rs = 0; rs < RTW_RATE_SECTION_MAX; rs++)
-			rtw8822b_set_tx_power_index_by_rate(rtwdev, path, rs);
+			rtw8822b_set_tx_power_index_by_rate(rtwdev, path, rs,
+							    &phy_pwr_idx);
 	}
 }
 
-- 
2.39.5



