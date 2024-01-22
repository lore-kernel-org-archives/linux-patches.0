Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF1C12BE9A;
	Tue, 23 Jan 2024 00:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971349; cv=none; b=pmF0npW1cBJY2eaIwNo/qb6UOhURPLaD5064r7hsD6JGr09Gn7GhAhJGothhM6Iv+A2/sSFPMDKi1oe3AiJAA9bIXvUfEWaXO+8Iqi+zu/YmbWqjOFiKBD4hFpa/k5E+Tqx252cmOwjEOANdrDJfvuE1c2h8MJss365LkJNszZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971349; c=relaxed/simple;
	bh=V95U7RPQI4O3lFWGllgNkDCeSFv2jz3iaTi0yycKeVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwZYD2DyoMt9pvhCFtatbN9EycgZdSrvTWwgV+ywOZiQPAT96rVvQGDR52atFDcsGTuXUjp0ZCLdgOYv1qyX9dyHjPNgdBn/uO+PASOuHXWJytB4Mct66M0dJkk61h7nQGa+VPTR2CHSZrIXCZNdnxBsdqdhnTZuE3SlVVeyeJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdXcqF2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdXcqF2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE21C433F1;
	Tue, 23 Jan 2024 00:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971348;
	bh=V95U7RPQI4O3lFWGllgNkDCeSFv2jz3iaTi0yycKeVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdXcqF2syCNSLHM3DxE3dVM48kMo2TUjQ8dNcoAWi1ncDYRxyazCGIoleXD/rmuw6
	 6W9BzLWFh4L8vUQOtoDMT5xbtt/ruZjBGy+q8H5D1pkRtteoxi2vsc2vCaefG/5AYL
	 5mzcpZkn8UWi55+3B34tGAePxIe3Dci+MXP5cq40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/286] wifi: rtlwifi: rtl8192se: using calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:57:24 -0800
Message-ID: <20240122235737.451836676@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 63283d9e7485..cd735d61f630 100644
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



