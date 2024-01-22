Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B0D64CFC;
	Tue, 23 Jan 2024 01:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975060; cv=none; b=EaJyz+kR9QB1ybInojWZZIxZbQu6dxwww7RWeMpZszQ2gPmXudUd02bf4tqwcLQ02LxivF85yB6pvFj3pmNdwMHdnoJuLJir2odbRv3CDoncWS8rgDk9uHtEzMh33pGPVvTwwe/9rIAl6JBcCSkPDATXehAHIOdfSrU4hMHWdbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975060; c=relaxed/simple;
	bh=+KgiAdmwrX+rC8/iDkWq5Dn9vrrKrIoLw8T2JWl6OtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+ZbftZbUd/c1KYX4q9rj8nmZF8FL589Og4InhrtRNHgagfR6ot3E4Q6FoY9aH/7BMVo+UYwXQiUqX4T72l94sTihgy3TyF/ft/VeYzTIWiBm2/QR6Im8s7o5xNHu1U5XnE7yaheLEtsE/rOwVpBz+6zCiVCVhRgIRq76VXCCTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+iCsRHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+iCsRHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9D5C433A6;
	Tue, 23 Jan 2024 01:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975060;
	bh=+KgiAdmwrX+rC8/iDkWq5Dn9vrrKrIoLw8T2JWl6OtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+iCsRHCZsXHlJIyWBlXRrLFoHqFYuqXvfw7P4JTkAOTVSj50ocg2ecEAZJiqadyn
	 ji1Deu38syO/LdRIokkL7qzkg/t/Awt0hsze6gEtxYFocg8oY2PIKOXoci6KX3g9sC
	 MTLUf1hD6btmpMKjYJzkJQ/9/yVq53sU5Qk9dPI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/583] wifi: rtlwifi: rtl8188ee: phy: using calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:54:03 -0800
Message-ID: <20240122235817.864081148@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 969bc926f04b438676768aeffffffb050e480b62 ]

Using calculate_bit_shift() to replace _rtl88e_phy_calculate_bit_shift().
And fix the undefined bitwise shift behavior problem.

Fixes: f0eb856e0b6c ("rtlwifi: rtl8188ee: Add new driver")
Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231219065739.1895666-4-suhui@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c   | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
index 12d0b3a87af7..0fab3a0c7d49 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
@@ -16,12 +16,6 @@ static u32 _rtl88e_phy_rf_serial_read(struct ieee80211_hw *hw,
 static void _rtl88e_phy_rf_serial_write(struct ieee80211_hw *hw,
 					enum radio_path rfpath, u32 offset,
 					u32 data);
-static u32 _rtl88e_phy_calculate_bit_shift(u32 bitmask)
-{
-	u32 i = ffs(bitmask);
-
-	return i ? i - 1 : 32;
-}
 static bool _rtl88e_phy_bb8188e_config_parafile(struct ieee80211_hw *hw);
 static bool _rtl88e_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
 static bool phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
@@ -51,7 +45,7 @@ u32 rtl88e_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
 	rtl_dbg(rtlpriv, COMP_RF, DBG_TRACE,
 		"regaddr(%#x), bitmask(%#x)\n", regaddr, bitmask);
 	originalvalue = rtl_read_dword(rtlpriv, regaddr);
-	bitshift = _rtl88e_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	returnvalue = (originalvalue & bitmask) >> bitshift;
 
 	rtl_dbg(rtlpriv, COMP_RF, DBG_TRACE,
@@ -74,7 +68,7 @@ void rtl88e_phy_set_bb_reg(struct ieee80211_hw *hw,
 
 	if (bitmask != MASKDWORD) {
 		originalvalue = rtl_read_dword(rtlpriv, regaddr);
-		bitshift = _rtl88e_phy_calculate_bit_shift(bitmask);
+		bitshift = calculate_bit_shift(bitmask);
 		data = ((originalvalue & (~bitmask)) | (data << bitshift));
 	}
 
@@ -99,7 +93,7 @@ u32 rtl88e_phy_query_rf_reg(struct ieee80211_hw *hw,
 
 
 	original_value = _rtl88e_phy_rf_serial_read(hw, rfpath, regaddr);
-	bitshift = _rtl88e_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 
 	spin_unlock(&rtlpriv->locks.rf_lock);
@@ -127,7 +121,7 @@ void rtl88e_phy_set_rf_reg(struct ieee80211_hw *hw,
 			original_value = _rtl88e_phy_rf_serial_read(hw,
 								    rfpath,
 								    regaddr);
-			bitshift = _rtl88e_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data =
 			    ((original_value & (~bitmask)) |
 			     (data << bitshift));
-- 
2.43.0



