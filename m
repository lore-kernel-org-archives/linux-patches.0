Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95BD6121;
	Tue, 23 Jan 2024 01:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974098; cv=none; b=OYXPHrFdjr035ErpT6Om2LErLa3x9oU+gBTXsuZiJYv3Vhy2Xxs4bB6dc9PpybPKf7zwX7+O/NULyH5clKszRRYRCvzZ1sygW6vacArnRs/vYmg9BthEALokqMgF+xKrYsacQWpTob+yp/Jhgauuv3I6U6HFpyeiajwmIbKRvSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974098; c=relaxed/simple;
	bh=6t8niMm2YGTwbS3Qt7VWhNPZuFZWS29Zg1DR0Wzg530=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UH1CvHVbajACqFbpGeC0qxvoOSnxCl3R/DMzBho9G8EpnMudpl/1F1+kJywzTM7TzHgV2GbLK/uBrevUKts93waQRcQQTisEzt8B9axadS/ZSPqGaxli0lT535wOctJOrmrc0oeeMC4ppMukK9hREcpXVNlfAL4EtPqM/ztTOJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dPteYbl5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPteYbl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB83C433C7;
	Tue, 23 Jan 2024 01:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974098;
	bh=6t8niMm2YGTwbS3Qt7VWhNPZuFZWS29Zg1DR0Wzg530=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPteYbl58aq5NWi+3VmJMDBVFdJ7gFEWKota9Z9EVHaNpIzQ2QnXVqH1qNhWsxwPX
	 PON6A90m5q619P5Us9N0cA2NMmundv6Nuqw12I4OamFuu/HZqneW7MrUXvwjfcQUpa
	 sR6MijZEDgXfUkGJFtuYQwFy8xPdmrDF0g0NqWwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/374] wifi: rtlwifi: rtl8192se: using calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:56:58 -0800
Message-ID: <20240122235750.244673728@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit ac32b9317063b101a8ff3d3e885f76f87a280419 ]

Using calculate_bit_shift() to replace _rtl92s_phy_calculate_bit_shift().
And fix the undefined bitwise shift behavior problem.

Fixes: d15853163bea ("rtlwifi: rtl8192se: Merge phy routines")
Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231219065739.1895666-10-suhui@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/realtek/rtlwifi/rtl8192se/phy.c  | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
index aaa004d4d6d0..0e2b9698088b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
@@ -14,13 +14,6 @@
 #include "hw.h"
 #include "table.h"
 
-static u32 _rtl92s_phy_calculate_bit_shift(u32 bitmask)
-{
-	u32 i = ffs(bitmask);
-
-	return i ? i - 1 : 32;
-}
-
 u32 rtl92s_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -30,7 +23,7 @@ u32 rtl92s_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
 		regaddr, bitmask);
 
 	originalvalue = rtl_read_dword(rtlpriv, regaddr);
-	bitshift = _rtl92s_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	returnvalue = (originalvalue & bitmask) >> bitshift;
 
 	rtl_dbg(rtlpriv, COMP_RF, DBG_TRACE, "BBR MASK=0x%x Addr[0x%x]=0x%x\n",
@@ -52,7 +45,7 @@ void rtl92s_phy_set_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask,
 
 	if (bitmask != MASKDWORD) {
 		originalvalue = rtl_read_dword(rtlpriv, regaddr);
-		bitshift = _rtl92s_phy_calculate_bit_shift(bitmask);
+		bitshift = calculate_bit_shift(bitmask);
 		data = ((originalvalue & (~bitmask)) | (data << bitshift));
 	}
 
@@ -160,7 +153,7 @@ u32 rtl92s_phy_query_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
 
 	original_value = _rtl92s_phy_rf_serial_read(hw, rfpath, regaddr);
 
-	bitshift = _rtl92s_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 
 	spin_unlock(&rtlpriv->locks.rf_lock);
@@ -191,7 +184,7 @@ void rtl92s_phy_set_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
 	if (bitmask != RFREG_OFFSET_MASK) {
 		original_value = _rtl92s_phy_rf_serial_read(hw, rfpath,
 							    regaddr);
-		bitshift = _rtl92s_phy_calculate_bit_shift(bitmask);
+		bitshift = calculate_bit_shift(bitmask);
 		data = ((original_value & (~bitmask)) | (data << bitshift));
 	}
 
-- 
2.43.0



