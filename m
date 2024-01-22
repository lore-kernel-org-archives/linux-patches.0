Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295E812BF35;
	Tue, 23 Jan 2024 00:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968917; cv=none; b=fpIZjhE6dygsLBfdmBiENYNBTRKAiU32DhMyrxujqsdtWMQWj5Ecf5qRJGu2vkjuwCOmdCGjTPX+2ZWEm0iKlXPDLm3Ng+Ct08RdA5Kck1N4r7fxXV5hlbEQnqdqYkh0J5DNb7p6MaSsPp15CadoaGEKRtSgBNL9NpSC2zFN4PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968917; c=relaxed/simple;
	bh=lt0PPBw8FcFVLSWosE2+WtXustfKa4AQjoBbMj+VPj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRN6CNGq3M7TOaCHYz3BfSYpP7PvFpxbDciXuwOpRyXMxk94+0enWX0DxIMusbfqtJiKbh6I/rtXElnG3l7Ptdi9sftBGNzvpi1gnz+JLLj34FZG25xEBDwqaCvFxc1VM1/D+OSTgOpYIJGQWllamz74HQLY5izjSx1XCtLLqS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOsV6Y5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOsV6Y5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1F1C433C7;
	Tue, 23 Jan 2024 00:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968917;
	bh=lt0PPBw8FcFVLSWosE2+WtXustfKa4AQjoBbMj+VPj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oOsV6Y5EzbwSa6BghZe4RrXHg4DTDiHNR738HMSCu08h2ATfjBi9Y1/DMQwzBW/I6
	 M6eAl0N4/KQE7asfSw5zTxW2K1Bf3y2zLeBguX7qCSVZUH0nzdmUxyFw3ceS0SmaPu
	 jz1LKmlbDGqrgXsGCIgXGMmu5Fcdd5NEpA6YKXho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/194] wifi: rtlwifi: rtl8192c: using calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:57:07 -0800
Message-ID: <20240122235723.388848718@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1145cb0ca4af..62ed75d6e2d3 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
@@ -17,7 +17,7 @@ u32 rtl92c_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE, "regaddr(%#x), bitmask(%#x)\n",
 		 regaddr, bitmask);
 	originalvalue = rtl_read_dword(rtlpriv, regaddr);
-	bitshift = _rtl92c_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	returnvalue = (originalvalue & bitmask) >> bitshift;
 
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
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



