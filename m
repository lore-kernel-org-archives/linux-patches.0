Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3A3633E6;
	Tue, 23 Jan 2024 01:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975013; cv=none; b=mi+UvIWZwYLjNIgcwXX9xjF8xcmCmNnBc4kATWvxqmfZcJXQP2dZHobofo2vdUiLjea2+hPycb9VbBHa8jElglJC1nDIITUN/+jbigitME7YnCIYnMREfr1gnBBc+fV6EKnADogEEA1Fc7pv/BjJE5jiOcZQPTp8OXgUmYBqLF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975013; c=relaxed/simple;
	bh=y3cau3qTDNrzUi1y1r8KqBvz5jJkiW4Tn+YylVRxl30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+ZwiQhw0iHfAgIuzrBv0UQXw2APwNQ8DR7Ya4CVqxUjIksXwbGtbJzYsbKK8lM7EdmQhHD23OPUutSquOWdSr4xqircB/Ah9ZrR6/+mVdYTeoo5Igsf/Lqqsc8y/TGVME5gOirz7S6ddn5sAQOVIYupoY2tcnYhxNEuiu4nSOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABQigaIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABQigaIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338A9C433F1;
	Tue, 23 Jan 2024 01:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975013;
	bh=y3cau3qTDNrzUi1y1r8KqBvz5jJkiW4Tn+YylVRxl30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABQigaIXRaFD+0ghzhG8v2wNyMURmsfBeAaBwMBcTjTlUo0KmVETRGDyAst8OfRLD
	 weKdUxPoC5oh0SsNYGfKJbuFDIUGzOl0ARK8GN4ywn8Z0nwf7I0USvLh1YGCPcJ0dD
	 LrxiMkviQ+i1251K5l6RDjX0jLNd5C8hG+Pg0H9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/583] wifi: rtlwifi: rtl8192de: using calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:54:07 -0800
Message-ID: <20240122235817.981821907@linuxfoundation.org>
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

[ Upstream commit b8b2baad2e652042cf8b6339939ac2f4e6f53de4 ]

Using calculate_bit_shift() to replace _rtl92d_phy_calculate_bit_shift().
And fix the undefined bitwise shift behavior problem.

Fixes: 7274a8c22980 ("rtlwifi: rtl8192de: Merge phy routines")
Signed-off-by: Su Hui <suhui@nfschina.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231219065739.1895666-8-suhui@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c  | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index d18c092b6142..d835a27429f0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -169,13 +169,6 @@ static const u8 channel_all[59] = {
 	157, 159, 161, 163, 165
 };
 
-static u32 _rtl92d_phy_calculate_bit_shift(u32 bitmask)
-{
-	u32 i = ffs(bitmask);
-
-	return i ? i - 1 : 32;
-}
-
 u32 rtl92d_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -198,7 +191,7 @@ u32 rtl92d_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
 	} else {
 		originalvalue = rtl_read_dword(rtlpriv, regaddr);
 	}
-	bitshift = _rtl92d_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	returnvalue = (originalvalue & bitmask) >> bitshift;
 	rtl_dbg(rtlpriv, COMP_RF, DBG_TRACE,
 		"BBR MASK=0x%x Addr[0x%x]=0x%x\n",
@@ -230,7 +223,7 @@ void rtl92d_phy_set_bb_reg(struct ieee80211_hw *hw,
 					dbi_direct);
 		else
 			originalvalue = rtl_read_dword(rtlpriv, regaddr);
-		bitshift = _rtl92d_phy_calculate_bit_shift(bitmask);
+		bitshift = calculate_bit_shift(bitmask);
 		data = ((originalvalue & (~bitmask)) | (data << bitshift));
 	}
 	if (rtlhal->during_mac1init_radioa || rtlhal->during_mac0init_radiob)
@@ -317,7 +310,7 @@ u32 rtl92d_phy_query_rf_reg(struct ieee80211_hw *hw,
 		regaddr, rfpath, bitmask);
 	spin_lock(&rtlpriv->locks.rf_lock);
 	original_value = _rtl92d_phy_rf_serial_read(hw, rfpath, regaddr);
-	bitshift = _rtl92d_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 	spin_unlock(&rtlpriv->locks.rf_lock);
 	rtl_dbg(rtlpriv, COMP_RF, DBG_TRACE,
@@ -343,7 +336,7 @@ void rtl92d_phy_set_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
 		if (bitmask != RFREG_OFFSET_MASK) {
 			original_value = _rtl92d_phy_rf_serial_read(hw,
 				rfpath, regaddr);
-			bitshift = _rtl92d_phy_calculate_bit_shift(bitmask);
+			bitshift = calculate_bit_shift(bitmask);
 			data = ((original_value & (~bitmask)) |
 				(data << bitshift));
 		}
-- 
2.43.0



