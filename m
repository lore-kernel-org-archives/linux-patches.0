Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E13443E;
	Tue, 23 Jan 2024 00:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968301; cv=none; b=n1x97vY1zSenGAYFCc167nfxnZjYJ5dz7ftwNOd2FnYLaS7lXSTML0kf302ZxMX2fuMdIht2qXd3kUch944EMq41Uawio4EZ4A0OuxE0oxDIpaN9wOL+0+RAgYxzxnkb10gd8qZonxvjXc51fZDxTTUvMHRywqTJAdx9GfOedRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968301; c=relaxed/simple;
	bh=4vO9dD+ori8OAaXfuO13e+wSgjliv08CF5ZpVKcZ42Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Abb5bs6e0xP6k3NzUjTiRVI6ftTP4rMfW581ov9lNhDP+F6k83HGioT3JKck61t/tqvt44IxGxqEt607zQcdUd6rdlMM3y5MARI906gf61D6l+UhWegvKDoZo/qU0U9R4uC9fTV3LAny2e+2SXFR6dgv3sse0goHposvuFEew6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qw9oSGGK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qw9oSGGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27EEC433F1;
	Tue, 23 Jan 2024 00:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968301;
	bh=4vO9dD+ori8OAaXfuO13e+wSgjliv08CF5ZpVKcZ42Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qw9oSGGKKAlnb/Wa3ysVIJhvDQqZgjVd2MEc2oNrbPepUGTBqtvaPnT3+9h3jVbD6
	 lXjuG06t+Cw6tK9axHi2/LGcr8/sr4lMpVgP+deXiFhRWN0VCO+iGTH/vcg94Ia0pN
	 KBQZvenANWOlhbQPxXs7v2JOgeZ5/0a5Wxz6jf2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 075/148] wifi: rtlwifi: rtl8188ee: phy: using calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:57:11 -0800
Message-ID: <20240122235715.422492092@linuxfoundation.org>
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
index 5bbb46f37e71..44cabfa1ca27 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
@@ -38,12 +38,6 @@ static u32 _rtl88e_phy_rf_serial_read(struct ieee80211_hw *hw,
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
@@ -73,7 +67,7 @@ u32 rtl88e_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
 		 "regaddr(%#x), bitmask(%#x)\n", regaddr, bitmask);
 	originalvalue = rtl_read_dword(rtlpriv, regaddr);
-	bitshift = _rtl88e_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	returnvalue = (originalvalue & bitmask) >> bitshift;
 
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
@@ -96,7 +90,7 @@ void rtl88e_phy_set_bb_reg(struct ieee80211_hw *hw,
 
 	if (bitmask != MASKDWORD) {
 		originalvalue = rtl_read_dword(rtlpriv, regaddr);
-		bitshift = _rtl88e_phy_calculate_bit_shift(bitmask);
+		bitshift = calculate_bit_shift(bitmask);
 		data = ((originalvalue & (~bitmask)) | (data << bitshift));
 	}
 
@@ -122,7 +116,7 @@ u32 rtl88e_phy_query_rf_reg(struct ieee80211_hw *hw,
 
 
 	original_value = _rtl88e_phy_rf_serial_read(hw, rfpath, regaddr);
-	bitshift = _rtl88e_phy_calculate_bit_shift(bitmask);
+	bitshift = calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 
 	spin_unlock_irqrestore(&rtlpriv->locks.rf_lock, flags);
@@ -151,7 +145,7 @@ void rtl88e_phy_set_rf_reg(struct ieee80211_hw *hw,
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



