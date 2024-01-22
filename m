Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C774E56B;
	Tue, 23 Jan 2024 00:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968334; cv=none; b=Z6qHIxWNc+dPwRQv9gg56kjxxUVl2OO1FF1gE4J5ZeHCV5WzXPhD3QhXrTME4BPNpgG34iytRNt93PA+S6kkOwCI0RKEz35SKaBC9Oa0MrytyROESRaMkb/XYlFp7Z+GgBIRG0Cp/O4LhirI178DHJELaMcxdhVQz9lORqm8vvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968334; c=relaxed/simple;
	bh=5pDAicGktSineutPuEG2WEzvhtxuuX1TWT8+jA6syac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVIawq2Mv3BLG6AH/UdyOtMWieT4bN+xVYSg3M1AouHAJrHyMUmAJ63BbimQ8WDHTYWurormK8MbQTMbJVO7wAWE8/5CgIWOIzp37AZHRzE1aH3DcSC5btZslSfohNxAhyau4OBapF9htq/RONBljvdUAT/Pw+QUr/Isy6nGm9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpxKG8W5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpxKG8W5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E5DC433F1;
	Tue, 23 Jan 2024 00:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968334;
	bh=5pDAicGktSineutPuEG2WEzvhtxuuX1TWT8+jA6syac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpxKG8W57FsD1AxtzFD15TPDHAfaKex2PtpRCZQebNj/7cE3qN4CA6CSFj+owM0g1
	 7yKIVoVMK4aTOTVH7k3x4vipi+9SFxxtUHpW1vkW/LUzDl6i3RyVyMyO2/+449x96q
	 ABI349cYevsF0/Y4U9EWeY/jryxE3TqnYwxEqZJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/148] wifi: rtlwifi: rtl8192ee: using calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:57:17 -0800
Message-ID: <20240122235715.684394197@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 7aeff442bd06..9a3e88d6a570 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
@@ -38,7 +38,6 @@ static u32 _rtl92ee_phy_rf_serial_read(struct ieee80211_hw *hw,
 static void _rtl92ee_phy_rf_serial_write(struct ieee80211_hw *hw,
 					 enum radio_path rfpath, u32 offset,
 					 u32 data);
-static u32 _rtl92ee_phy_calculate_bit_shift(u32 bitmask);
 static bool _rtl92ee_phy_bb8192ee_config_parafile(struct ieee80211_hw *hw);
 static bool _rtl92ee_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
 static bool phy_config_bb_with_hdr_file(struct ieee80211_hw *hw,
@@ -68,7 +67,7 @@ u32 rtl92ee_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
 		 "regaddr(%#x), bitmask(%#x)\n", regaddr, bitmask);
 	originalvalue = rtl_read_dword(rtlpriv, regaddr);
-	bitshift = _rtl92ee_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	returnvalue = (originalvalue & bitmask) >> bitshift;
 
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
@@ -90,7 +89,7 @@ void rtl92ee_phy_set_bb_reg(struct ieee80211_hw *hw, u32 regaddr,
 
 	if (bitmask != MASKDWORD) {
 		originalvalue = rtl_read_dword(rtlpriv, regaddr);
-		bitshift = _rtl92ee_phy_calculate_bit_shift(bitmask);
+		bitshift = calculate_bit_shift(bitmask);
 		data = ((originalvalue & (~bitmask)) | (data << bitshift));
 	}
 
@@ -115,7 +114,7 @@ u32 rtl92ee_phy_query_rf_reg(struct ieee80211_hw *hw,
 	spin_lock_irqsave(&rtlpriv->locks.rf_lock, flags);
 
 	original_value = _rtl92ee_phy_rf_serial_read(hw , rfpath, regaddr);
-	bitshift = _rtl92ee_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 
 	spin_unlock_irqrestore(&rtlpriv->locks.rf_lock, flags);
@@ -143,7 +142,7 @@ void rtl92ee_phy_set_rf_reg(struct ieee80211_hw *hw,
 
 	if (bitmask != RFREG_OFFSET_MASK) {
 		original_value = _rtl92ee_phy_rf_serial_read(hw, rfpath, addr);
-		bitshift = _rtl92ee_phy_calculate_bit_shift(bitmask);
+		bitshift = calculate_bit_shift(bitmask);
 		data = (original_value & (~bitmask)) | (data << bitshift);
 	}
 
@@ -226,13 +225,6 @@ static void _rtl92ee_phy_rf_serial_write(struct ieee80211_hw *hw,
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



