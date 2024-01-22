Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6137312BF35;
	Tue, 23 Jan 2024 00:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968914; cv=none; b=kemI4FSZmaPm2zWXKFN6MCUPvGcaoep1Zzi7xgQb8bH1Xi2nW4wqdZc61Y/qYkdLnJmz/7ACGHLjTCrQB3UWE1IM2bG07wviQ+PNHLLTlo6vqtYRx004IGTrJr4U8L0ZnXRZ4ASHxp2cJQzwB969g0KCYpyhwxkFVnnShr5ZVYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968914; c=relaxed/simple;
	bh=H9uuzJsshk9QMe8DRBwsTudemLqFKF31Iiuru2O/xmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvQqMo1AoNilnLBuEITWSzoRQ/MugfJTZgFkx6Gfb61aGmArvXNEvq1Yx4GYsJ4V2KCqWyhLj2tj+ipjtEnMCMr1yNsjx0HAs2dnw+q8jH18Qjr+Yr4JYmaK3hiIi6mj6Kgj3TIFZhPr9O88EzGc3kWh5z/gOmbmHBNku/KMyjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tt2cYyV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tt2cYyV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04B7C433C7;
	Tue, 23 Jan 2024 00:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968913;
	bh=H9uuzJsshk9QMe8DRBwsTudemLqFKF31Iiuru2O/xmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tt2cYyV8V1H2D2K79jXQ+JzBqgghBRh7KohV1E+7XRHjFi03pGvv4s4M6Z/MBhbsn
	 w1WpfTc6XkOZDu0DNer47AW5dxk2GavpE+aFLsNEonJJBFpeHCpos7fTwMWDO2bvN1
	 624ol/2q9bUFhQFyKBfgeQh+2x3rAoN6mgpetamk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/194] wifi: rtlwifi: add calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:57:05 -0800
Message-ID: <20240122235723.306405135@linuxfoundation.org>
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
index 3bdda1c98339..abec9ceabe28 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -3230,4 +3230,11 @@ static inline struct ieee80211_sta *rtl_find_sta(struct ieee80211_hw *hw,
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



