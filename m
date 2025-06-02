Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0D11D8DFB;
	Mon,  2 Jun 2025 14:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874871; cv=none; b=o7QHOqUaFyAQqhKBEO6+hs4t7XKa+QpB/LNm9u76Ta6ZcoBttrqtn8WG2VbzJlpgEnsaaKwERpDRdttIbf1ZLKIh+iwOUXzFGt6JY1BuGjaZw4KAV6jCgggr8xybqitnEQpvZzywJlrVsbUg4crLhqqpUQnIFA6UBR3SsqEg/VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874871; c=relaxed/simple;
	bh=IvQm4MA8SioyNYpCh+yl4cAe9iUftG5RZSPA+slWmdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBlK9Crodw8iVMRjmVkCdoC12tssv3kguLvcFvmlVKym6lfcA7VttlLf8R77mEOep+Tn5E2YbAkS2Jy+5YAavME0qUhSCYXXC9kOif1irRPcDepgxAFuWnuYkiz8qNHOPLJj+PyitJhw4cheWjTm1WGv3XqJ8AyDZeYkKMIVNFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KnYVE+/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KnYVE+/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6956DC4CEEB;
	Mon,  2 Jun 2025 14:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874870;
	bh=IvQm4MA8SioyNYpCh+yl4cAe9iUftG5RZSPA+slWmdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KnYVE+/nn5mEnBR4Z+7DSMOTmt5CxicEY8jw3Z8E9uLO7SgxOpHIzCAzDMNSJbABs
	 dfa+cqgoP00A+mTplroTo1ZVQil0PWrCCOZyyMwTre5c/MRdF4moMMTOt6E9vFo6IV
	 bxjBhWXhi1HZQywprE6nzFsZzGSEZ1/mz26LHMw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 161/204] wifi: rtw88: Dont use static local variable in rtw8822b_set_tx_power_index_by_rate
Date: Mon,  2 Jun 2025 15:48:14 +0200
Message-ID: <20250602134301.982651632@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 63abda3b0ebfc..004a85448ce99 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -864,11 +864,11 @@ static void rtw8822b_query_rx_desc(struct rtw_dev *rtwdev, u8 *rx_desc,
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
 
@@ -876,12 +876,12 @@ rtw8822b_set_tx_power_index_by_rate(struct rtw_dev *rtwdev, u8 path, u8 rs)
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
@@ -889,11 +889,13 @@ rtw8822b_set_tx_power_index_by_rate(struct rtw_dev *rtwdev, u8 path, u8 rs)
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



