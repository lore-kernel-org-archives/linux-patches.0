Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEEB59B54;
	Tue, 23 Jan 2024 01:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974085; cv=none; b=A0bbj4FX1o0y2ZQ8Gy/LZWVt4ZIQORUdAZNiPjq0VF3gFgyCgiYzVoU9W3NTt0e0xtt5Q8Kn0njqSVGm0gcFHV3aV1IdAkwqbhH/RsGQMB5N9IiI0yEsl+n8BACLWOThTIKszia0KNKu/uP7ur6uHFLLgB4uPK1cQ7205srPds8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974085; c=relaxed/simple;
	bh=qRrnlelJpGREqqo/v55oFyZpFwiKfsn0hDd8zlAoAPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFxQmQhmVvKl+mLi+XZWFG/nsfM6pTIkZinOpQzDsH4dboOR5B7JzBhUZzV7cNWt4/BhFdeI1abZSLC5PiBR7tIW1v7T7g0gjKaUbya2tfI7MDxCm7/uCMWbmFg8AnZQ/5YYGGLVv+rnbxaVp8Sd5brOA+0hR/wEvBDQ2ME7qAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cd8G6zLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cd8G6zLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFC8C433C7;
	Tue, 23 Jan 2024 01:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974084;
	bh=qRrnlelJpGREqqo/v55oFyZpFwiKfsn0hDd8zlAoAPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cd8G6zLS5ZGGqKyZMV4dQVRL+LEKKhvWRE5jtboI3BJ0++OXaS7iqr5RH47AYKNQN
	 BllEGotiS5ghBab1fdZDLzwWg8z2q7nitoi363VdDZNe8f3uKvTZAM6bRHw/os+24r
	 koe21gi3SpcYiu7t7YZLPOD53Fq/jOg4+UHk54Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/374] wifi: rtlwifi: rtl8192c: using calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:56:53 -0800
Message-ID: <20240122235750.073649984@linuxfoundation.org>
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

[ Upstream commit 1dedc3a6699d827d345019e921b8d8f37f694333 ]

Using calculate_bit_shift() to replace _rtl92c_phy_calculate_bit_shift().
And fix the undefined bitwise shift behavior problem.

Fixes: 4295cd254af3 ("rtlwifi: Move common parts of rtl8192ce/phy.c")
Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231219065739.1895666-5-suhui@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtlwifi/rtl8192c/phy_common.c   | 12 ++----------
 .../wireless/realtek/rtlwifi/rtl8192c/phy_common.h   |  1 -
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
index 3d29c8dbb255..144ee780e1b6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
@@ -17,7 +17,7 @@ u32 rtl92c_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
 	rtl_dbg(rtlpriv, COMP_RF, DBG_TRACE, "regaddr(%#x), bitmask(%#x)\n",
 		regaddr, bitmask);
 	originalvalue = rtl_read_dword(rtlpriv, regaddr);
-	bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	returnvalue = (originalvalue & bitmask) >> bitshift;
 
 	rtl_dbg(rtlpriv, COMP_RF, DBG_TRACE,
@@ -40,7 +40,7 @@ void rtl92c_phy_set_bb_reg(struct ieee80211_hw *hw,
 
 	if (bitmask != MASKDWORD) {
 		originalvalue = rtl_read_dword(rtlpriv, regaddr);
-		bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+		bitshift = calculate_bit_shift(bitmask);
 		data = ((originalvalue & (~bitmask)) | (data << bitshift));
 	}
 
@@ -143,14 +143,6 @@ void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(_rtl92c_phy_rf_serial_write);
 
-u32 _rtl92c_phy_calculate_bit_shift(u32 bitmask)
-{
-	u32 i = ffs(bitmask);
-
-	return i ? i - 1 : 32;
-}
-EXPORT_SYMBOL(_rtl92c_phy_calculate_bit_shift);
-
 static void _rtl92c_phy_bb_config_1t(struct ieee80211_hw *hw)
 {
 	rtl_set_bbreg(hw, RFPGA0_TXINFO, 0x3, 0x2);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h
index 75afa6253ad0..e64d377dfe9e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h
@@ -196,7 +196,6 @@ bool rtl92c_phy_set_rf_power_state(struct ieee80211_hw *hw,
 void rtl92ce_phy_set_rf_on(struct ieee80211_hw *hw);
 void rtl92c_phy_set_io(struct ieee80211_hw *hw);
 void rtl92c_bb_block_on(struct ieee80211_hw *hw);
-u32 _rtl92c_phy_calculate_bit_shift(u32 bitmask);
 long _rtl92c_phy_txpwr_idx_to_dbm(struct ieee80211_hw *hw,
 				  enum wireless_mode wirelessmode,
 				  u8 txpwridx);
-- 
2.43.0



