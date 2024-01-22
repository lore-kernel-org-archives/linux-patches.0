Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B2163404;
	Tue, 23 Jan 2024 01:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975015; cv=none; b=Y8sFX+H9r0ge5akT0HohHcn6IJdX3kY9FszE0Hp4eDi0c89ubXjchvlQViDi+BLJZu+UD456798dwGPufyi/VGl54f6eSSMwHR9RUxIcq32hgsOiwhbwRTqcxy2iG77SSEvXPoi35MI0wkE1tipInGgn56vSQL9jZEanoRBYz2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975015; c=relaxed/simple;
	bh=nJZ4pOYag90ZdOEv//9l2lDMsZhuc5QPUPwIV/WQAMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlQToi7Ng3eUAPmX7xKWpL0fsdETUfNH4dFMZSAI33FijKGqsb4aAIYGWvZLkFw74js1JR2hVm40XPOB1+8GA8MLJ6pf8KnLJKewpGKGbr2mrLpjzHv/XqgHsigi8oLlJW9eCnjcUVMhWJbfQk+uY8Ex1wV9XMFIQFfqYbOwQmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxRutcWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxRutcWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A8CC433F1;
	Tue, 23 Jan 2024 01:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975015;
	bh=nJZ4pOYag90ZdOEv//9l2lDMsZhuc5QPUPwIV/WQAMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxRutcWlzz1Fnco3ayqFDktOzKHePw36UgNXpCju5zgguhlwEc11vNxVIw2as6El9
	 6aqIjG6n0qs1VFnUl3U4RoW3Dwx3ABgX2o74PV/MZCwb2Y4oqG7LL/ahtgHQXYj4li
	 mcwQuPrxzfKTo+KiJdBjFdmCUwtw5SurAIjd95t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/583] wifi: rtlwifi: rtl8192ee: using calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:54:08 -0800
Message-ID: <20240122235818.007108782@linuxfoundation.org>
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

[ Upstream commit 63526897fc0d086069bcab67c3a112caaec751cb ]

Using calculate_bit_shift() to replace _rtl92ee_phy_calculate_bit_shift().
And fix the undefined bitwise shift behavior problem.

Fixes: b1a3bfc97cd9 ("rtlwifi: rtl8192ee: Move driver from staging to the regular tree")
Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231219065739.1895666-9-suhui@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
index cc0bcaf13e96..73ef602bfb01 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
@@ -16,7 +16,6 @@ static u32 _rtl92ee_phy_rf_serial_read(struct ieee80211_hw *hw,
 static void _rtl92ee_phy_rf_serial_write(struct ieee80211_hw *hw,
 					 enum radio_path rfpath, u32 offset,
 					 u32 data);
-static u32 _rtl92ee_phy_calculate_bit_shift(u32 bitmask);
 static bool _rtl92ee_phy_bb8192ee_config_parafile(struct ieee80211_hw *hw);
 static bool _rtl92ee_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
 static bool phy_config_bb_with_hdr_file(struct ieee80211_hw *hw,
@@ -46,7 +45,7 @@ u32 rtl92ee_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
 	rtl_dbg(rtlpriv, COMP_RF, DBG_TRACE,
 		"regaddr(%#x), bitmask(%#x)\n", regaddr, bitmask);
 	originalvalue = rtl_read_dword(rtlpriv, regaddr);
-	bitshift = _rtl92ee_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	returnvalue = (originalvalue & bitmask) >> bitshift;
 
 	rtl_dbg(rtlpriv, COMP_RF, DBG_TRACE,
@@ -68,7 +67,7 @@ void rtl92ee_phy_set_bb_reg(struct ieee80211_hw *hw, u32 regaddr,
 
 	if (bitmask != MASKDWORD) {
 		originalvalue = rtl_read_dword(rtlpriv, regaddr);
-		bitshift = _rtl92ee_phy_calculate_bit_shift(bitmask);
+		bitshift = calculate_bit_shift(bitmask);
 		data = ((originalvalue & (~bitmask)) | (data << bitshift));
 	}
 
@@ -92,7 +91,7 @@ u32 rtl92ee_phy_query_rf_reg(struct ieee80211_hw *hw,
 	spin_lock(&rtlpriv->locks.rf_lock);
 
 	original_value = _rtl92ee_phy_rf_serial_read(hw , rfpath, regaddr);
-	bitshift = _rtl92ee_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 
 	spin_unlock(&rtlpriv->locks.rf_lock);
@@ -119,7 +118,7 @@ void rtl92ee_phy_set_rf_reg(struct ieee80211_hw *hw,
 
 	if (bitmask != RFREG_OFFSET_MASK) {
 		original_value = _rtl92ee_phy_rf_serial_read(hw, rfpath, addr);
-		bitshift = _rtl92ee_phy_calculate_bit_shift(bitmask);
+		bitshift = calculate_bit_shift(bitmask);
 		data = (original_value & (~bitmask)) | (data << bitshift);
 	}
 
@@ -201,13 +200,6 @@ static void _rtl92ee_phy_rf_serial_write(struct ieee80211_hw *hw,
 		pphyreg->rf3wire_offset, data_and_addr);
 }
 
-static u32 _rtl92ee_phy_calculate_bit_shift(u32 bitmask)
-{
-	u32 i = ffs(bitmask);
-
-	return i ? i - 1 : 32;
-}
-
 bool rtl92ee_phy_mac_config(struct ieee80211_hw *hw)
 {
 	return _rtl92ee_phy_config_mac_with_headerfile(hw);
-- 
2.43.0



