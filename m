Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D3860252;
	Tue, 23 Jan 2024 00:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970888; cv=none; b=MmGx64aChFKbi1N5GeVkvOpx8b+aHWUQnQzb194dGBcyQWjGLcL9czPVP8XMZxCCJ/Y22Jyczj6eWaTKL/aCZPzkZV5hMKK/A23609lItdimh1iGusHZZXPmQtwgm8f60xvW0SA7H7zXLvFWgVUusRAvXekQ9ohaEOZLifbQOwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970888; c=relaxed/simple;
	bh=oDwL1LKIWfXo+fOgGpHyE6w4e/1Ko1ikrJky2izpYcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWlKE2FdqxAdUDp1YYTGp+3IL0jouPUbMP8dqFVK+G21AERMkmdQKDR7FB3GYponPCp+hJT/2wbvsM53SZ1PByDQp5P1aiUmn1lbjePag8j3OsGPGkAjkEM3J1AQrBtfi/RY4roOyNpYfFu+wrxQogCTthWJ9N0YHhH4ZJqZZ+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PerrAPUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PerrAPUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDF1C433C7;
	Tue, 23 Jan 2024 00:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970888;
	bh=oDwL1LKIWfXo+fOgGpHyE6w4e/1Ko1ikrJky2izpYcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PerrAPUq4hoj2UX66XGw70VtjELbTwh7TrBirc9aC37LGas+NNMLF6cvJP79SuhF6
	 XqLFuMh67uCSGFeNJRYveoUuASHDltlt58M3G8luPawPyssYj7LDtxcxQ/ULLSWA+o
	 GRQsPkO9Wy16aX9lT2ZL5zYOE2J7a6IZC/f2jOnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/417] wifi: rtlwifi: add calculate_bit_shift()
Date: Mon, 22 Jan 2024 15:55:01 -0800
Message-ID: <20240122235756.432560507@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 31f9e9e5c680..0bac788ccd6e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -3105,4 +3105,11 @@ static inline struct ieee80211_sta *rtl_find_sta(struct ieee80211_hw *hw,
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



