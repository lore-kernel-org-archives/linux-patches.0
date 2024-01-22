Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5E464CCD;
	Tue, 23 Jan 2024 01:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975051; cv=none; b=Cfu0rYGHmWyymXhMyBXc/5FV2kHsbz4lp5gB+FBFIzG4WsAhoHy9HvLzhWCso1dz8X+VE6Xi47XtFvLqfgQCv4li7XL3M+SAw+nsezrspkLrAxW7LR3BvlESpeY1+bSRyMTvJq+OLj8mIs5KZ315jFJTy8SGN8XhVAk7oKxt95w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975051; c=relaxed/simple;
	bh=i+9/g249AA/4JdH0fo3BnwvYYTomP2FadM3f984gzW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODiRGd1fNeLx8b9GQt/Q4m0TXdo46ceUmjyLp9sKCAvyaduISuhkpcIIy2Gg9RLnbMVVlEF0k0WWlpznvJfhcYreOEokMSxMtNfrqDiV4pIPpe9BSFKb9d8ryA1PIbjsSffojFGzZmPxIHykk5pubwJZoHyHpGBzPylO89xsqiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgU3bkVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgU3bkVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7331C433F1;
	Tue, 23 Jan 2024 01:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975050;
	bh=i+9/g249AA/4JdH0fo3BnwvYYTomP2FadM3f984gzW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgU3bkVZelAneEJ7A+ImZO2ZoyhVaPjJPOekzNa9HG41ySy8akJPLhhJuH3yj3khA
	 9EBWybkUdh9BiEjjEh97Zu42H1n4Uun70tM+GVLiZynjRTPDk1QMThB6+uba0X605R
	 IsYEotIw90JE4NERWbNT6fbD5N50BTYpRHWG70mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/583] wifi: rtlwifi: add calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:54:02 -0800
Message-ID: <20240122235817.837197292@linuxfoundation.org>
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

[ Upstream commit 52221dfddbbfb5b4e029bb2efe9bb7da33ec1e46 ]

There are many same functions like _rtl88e_phy_calculate_bit_shift(),
_rtl92c_phy_calculate_bit_shift() and so on. And these functions can
cause undefined bitwise shift behavior. Add calculate_bit_shift() to
replace them and fix undefined behavior in subsequent patches.

Signed-off-by: Su Hui <suhui@nfschina.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231219065739.1895666-2-suhui@nfschina.com
Stable-dep-of: 969bc926f04b ("wifi: rtlwifi: rtl8188ee: phy: using calculate_bit_shift()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 2e7e04f91279..8cbf3fb38853 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -3080,4 +3080,11 @@ static inline struct ieee80211_sta *rtl_find_sta(struct ieee80211_hw *hw,
 	return ieee80211_find_sta(mac->vif, mac_addr);
 }
 
+static inline u32 calculate_bit_shift(u32 bitmask)
+{
+	if (WARN_ON_ONCE(!bitmask))
+		return 0;
+
+	return __ffs(bitmask);
+}
 #endif
-- 
2.43.0



