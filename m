Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7706121;
	Tue, 23 Jan 2024 01:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974081; cv=none; b=UoeI2XDmb0UxA/G/vmJVz5fhVkDb9+HL81sG/iYdQDqqNW+H3WNe8+yB+p2HYq6iAuQZCLDKW8GczaZZ5wS7laIy/XlyQOKTTvjpsO74pa5oy/RXswxr6cL2gguN5ZfuHfmmCYDt6tby+HuZ9xqkqQksT2Z3RAAuTmxABhYniCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974081; c=relaxed/simple;
	bh=ILQo4Ku2ySJdM45pb7NYipOw0+w3TRRYg0JYlQ/NQKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxO9fK7XZLPGFVUgMmBoxYyT6WbVBszOEkdXcgQ526zSqDhLgpr/q1HNn+MlLBiK/UnYCkjxuzyCkalk8eKvFDttIhVL+Pl9KGwynjoN2X1JkAQ/IOwo5wiDKChY9Ob9yhVFhC4wwnFdb8quKhLMTSt2yX2eXQpDkPYSocnoabA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxmY9zsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxmY9zsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31B2C43394;
	Tue, 23 Jan 2024 01:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974080;
	bh=ILQo4Ku2ySJdM45pb7NYipOw0+w3TRRYg0JYlQ/NQKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxmY9zsG5whqRTK9EpRAi314+3Jdt723BBYh0ai/pHxKWG3dc1Wfq1OppWsyZ9zaQ
	 TipgHiRLUS73PWU41WSyETK4zlfklRBZ9vPCmL++BFACyL/f5FYibk57ZPxUQOixZ8
	 pgpqrpB5Z0LVxdPVoXLUUuaQ4WvJqdRVk7NQsxRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 155/374] wifi: rtlwifi: add calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:56:51 -0800
Message-ID: <20240122235750.006541978@linuxfoundation.org>
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
index aa07856411b1..a1f223c8848b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -3106,4 +3106,11 @@ static inline struct ieee80211_sta *rtl_find_sta(struct ieee80211_hw *hw,
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



