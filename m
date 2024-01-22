Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB3E12BE8D;
	Tue, 23 Jan 2024 00:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971344; cv=none; b=aPzNS9a9joWXXYJVFFgvT16eIBp/SZmWRwLRDMODEVbXjmX9Z9KjKG2rJUmuOvFq3lGHGQxni9oIhKptosZDthMhU5JaLhN5lNOtxQNPt/Lt+YXmlkRMDn2S2WNWokgGlfCacLMKe1sJxDoiG3Y4AQTlWOq1p7bcn3zc8AH29+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971344; c=relaxed/simple;
	bh=KJNdLBQj2HNoO05xONwtOMpL9ZyGzIIEDm55jAw9WZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvXDQuOqyPO19inn3AXe6hLIWWI+ikUUb+Y5D/JMcEWC1/8bYKSTIGqfyk0lmrK09Z+tsN7WJzGX84HFyI19R+dli89uRJZK6QEBCEED9GoTf34T2bNITGkHs4RrFxpQ8sCotbH+hB2BtzqWMX/S90J7uVuf3YcaDAPp3b3yavM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u19q9QCw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u19q9QCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF82C433F1;
	Tue, 23 Jan 2024 00:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971344;
	bh=KJNdLBQj2HNoO05xONwtOMpL9ZyGzIIEDm55jAw9WZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u19q9QCw/bU1f7i4dxibO3wNjyiqOrYJbN9h9Tx2sYrnH8lY0PG0Eg/rhqKg4F3+B
	 MyTMtPRrBhFIT8TtGikgsJw7CZmzm/cUg8AjJqW+88XGeSRAoQ51TnyaeGJe2Y9k5/
	 j8Arh03AEhne4tww1HFrcvLs+mtHdRNBWsdKH+U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/286] wifi: rtlwifi: rtl8192ee: using calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:57:23 -0800
Message-ID: <20240122235737.418478201@linuxfoundation.org>
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



