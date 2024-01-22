Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9A655C34;
	Tue, 23 Jan 2024 01:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974015; cv=none; b=FhrGq3yNraMl1E311RMfLzD4ewYdAt0EX6hvFFYIiNE1QnyxDIpp8AHZAcJozENQfchYblp3wcUJLdBRYOhDn2LCLussmwtsZmz8AOMlCfIhzrOJJeadIzWsie4jbWy9TgBVG/+K8IW7HAzEzJfyN27W6RQFd32c4vxuzK2eEuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974015; c=relaxed/simple;
	bh=0evuUFbXAMh1ItDyCk3/GI9Nu0DkgG7kThtcZoWXWaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqzFZvel61jEO1rS21oQeM+WXvdCLJwK5hCy8ufDWfQd1b4Je0lXc8GCdnSvROewCiPSQ60757vhnT3duGPJ26Knl1Rym93mSYAnwYbliAeszkHBi7K3Q5ofdW/6kR+OSjOaMFunvMZ71UKtYrzBRuhkkBrX+KyX25vheOyuOdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9CpZFLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9CpZFLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70381C433A6;
	Tue, 23 Jan 2024 01:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974014;
	bh=0evuUFbXAMh1ItDyCk3/GI9Nu0DkgG7kThtcZoWXWaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9CpZFLNjAATBfa8Cv16QnqutiCPm6wRDO9jHo7fOW16NMRId/F2EkOxD+sgsllNO
	 VoOcDxZdRVC3s6PPo/S90Qlzsr4PH1Jh3bzjGleGdvvFJMWZgL0GyDYTVBH89RJjqi
	 tY458dhPibWUeaMqpS86qKeOV18tPChhv0s1Y7Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/374] wifi: rtlwifi: rtl8821ae: phy: fix an undefined bitwise shift behavior
Date: Mon, 22 Jan 2024 15:56:22 -0800
Message-ID: <20240122235749.025386446@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit bc8263083af60e7e57c6120edbc1f75d6c909a35 ]

Clang static checker warns:

drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:184:49:
	The result of the left shift is undefined due to shifting by '32',
	which is greater or equal to the width of type 'u32'.
	[core.UndefinedBinaryOperatorResult]

If the value of the right operand is negative or is greater than or
equal to the width of the promoted left operand, the behavior is
undefined.[1][2]

For example, when using different gcc's compilation optimization options
(-O0 or -O2), the result of '(u32)data << 32' is different. One is 0, the
other is old value of data. Let _rtl8821ae_phy_calculate_bit_shift()'s
return value less than 32 to fix this problem. Warn if bitmask is zero.

[1] https://stackoverflow.com/questions/11270492/what-does-the-c-standard-say-about-bitshifting-more-bits-than-the-width-of-type
[2] https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf

Fixes: 21e4b0726dc6 ("rtlwifi: rtl8821ae: Move driver from staging to regular tree")
Signed-off-by: Su Hui <suhui@nfschina.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20231127013511.26694-2-suhui@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 5323ead30db0..fa1839d8ee55 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -29,9 +29,10 @@ static void _rtl8821ae_phy_rf_serial_write(struct ieee80211_hw *hw,
 					   u32 data);
 static u32 _rtl8821ae_phy_calculate_bit_shift(u32 bitmask)
 {
-	u32 i = ffs(bitmask);
+	if (WARN_ON_ONCE(!bitmask))
+		return 0;
 
-	return i ? i - 1 : 32;
+	return __ffs(bitmask);
 }
 static bool _rtl8821ae_phy_bb8821a_config_parafile(struct ieee80211_hw *hw);
 /*static bool _rtl8812ae_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);*/
-- 
2.43.0



