Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C59E5225;
	Tue, 23 Jan 2024 00:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968299; cv=none; b=Huoj4FpGGnybOBgqfIFJ3/JSgBCiXNs2+ZXXxVz6miiA3S59CSob0WlNO4fIIAcefSqhuNNbph5brPjceyGAI8v1XdE/hT8EDCcxNID+f0gs9YbSzfXk4CS93xIzRNI8CGEDdonKnbiEpgGmZ5d96t7dnvd4Q3sE3RNGz9/yChU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968299; c=relaxed/simple;
	bh=2izmk2ifgxTQYJZqXzOryFwYrOXhcwX2UNx10mjnlkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ik8qFYKavBckn9AkTTuSRSh1WXp2VEIGFEuJEwGLibAFNtunKfZyd7egvOem+u+r7Z6dJJjR/JUdQre8Xn599d7DStJcSuz+vlStaRfJaRgTY69xEkbQ/Ci82+GneSH8C22h+GX+DOXaQ42OSsNSFyBDjkQhTqSj29aimp86OvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvAiTtBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvAiTtBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DA2C433C7;
	Tue, 23 Jan 2024 00:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968299;
	bh=2izmk2ifgxTQYJZqXzOryFwYrOXhcwX2UNx10mjnlkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvAiTtBDA0jBdd4yd5Ik83ytuNkgFTy34jN85LEClxRZkxnVR17Isn9/YcL6NbVBD
	 nWN//wWt5KGl7diXaTLU5wZjVYeiF+BHgZtCbfsTXsvHWWm+g/VKWaXoi8w3/dmznS
	 s+mofyN0Bz+EgzFlRK1RpkwJ7CcDVpIfWCtLB0XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/148] wifi: rtlwifi: add calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:57:10 -0800
Message-ID: <20240122235715.388903981@linuxfoundation.org>
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
index 0f3b98c5227f..0287cbb9a719 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -3251,4 +3251,11 @@ static inline struct ieee80211_sta *rtl_find_sta(struct ieee80211_hw *hw,
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



