Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F32192594;
	Tue,  8 Oct 2024 13:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393323; cv=none; b=T9PCwANxQkUjMVsPmvDGs985JZN+OS5h4lOme4mkhpLI16efToK1+NLBL5K0rIgukDog2AnesAzJUc07utoeoJQ/hrxjxyxuIrIBnG9Fh3CRpyf0E9saHL1iXwsTh3P/vm8IKTIUQH6hAeGukoyD/VOv+3XxZle5kjddhXJP1Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393323; c=relaxed/simple;
	bh=ccI5JElKTN9h3Qyj/5DlIQXdguSJpwZhWdxHxKWXUyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgl1VhbVDMvdJRf4nmDAqBZpbroDw9TaLuiUpMpv7JhPirdybzDRPU2yd+Cc5WoEtS8DzSVlaBJ7JlGhB5kAZSEiKqQB9WJf+tKpQGS93at4KBJZS5pi4nA1JerPHLsYNrYwYeXr6eRvLZ+heC/gHm9JFzd6vTJiwpCg0m5zjgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DeVSNGgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DeVSNGgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293FFC4CECC;
	Tue,  8 Oct 2024 13:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393323;
	bh=ccI5JElKTN9h3Qyj/5DlIQXdguSJpwZhWdxHxKWXUyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DeVSNGguPwBZkXlfFi/VDWa0JtNHyOAT1vgyt/KX/C51Y7Tu4G5CCb2kvqjLy6ArX
	 /nDOOyySxxVjPRbgZRKW0LRkyYvo0209g5FZrxGNl+iqKUzRDM5s/q4Lu/rzLh6Nxr
	 AAtLbZwu7fSkCbLDNe6jAdHpU+Iff5ZALhA8GLsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/386] wifi: rtw89: correct base HT rate mask for firmware
Date: Tue,  8 Oct 2024 14:05:35 +0200
Message-ID: <20241008115632.996071322@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 45742881f9eee2a4daeb6008e648a460dd3742cd ]

Coverity reported that u8 rx_mask << 24 will become signed 32 bits, which
casting to unsigned 64 bits will do sign extension. For example,
putting 0x80000000 (signed 32 bits) to a u64 variable will become
0xFFFFFFFF_80000000.

The real case we meet is:
  rx_mask[0...3] = ff ff 00 00
  ra_mask = 0xffffffff_ff0ff000

After this fix:
  rx_mask[0...3] = ff ff 00 00
  ra_mask = 0x00000000_ff0ff000

Fortunately driver does bitwise-AND with incorrect ra_mask and supported
rates (1ss and 2ss rate only) afterward, so the final rate mask of
original code is still correct.

Addresses-Coverity-ID: 1504762 ("Unintended sign extension")

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240809072012.84152-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index 7139146cb3fad..fac83b718a30c 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -284,8 +284,8 @@ static void rtw89_phy_ra_sta_update(struct rtw89_dev *rtwdev,
 		csi_mode = RTW89_RA_RPT_MODE_HT;
 		ra_mask |= ((u64)sta->deflink.ht_cap.mcs.rx_mask[3] << 48) |
 			   ((u64)sta->deflink.ht_cap.mcs.rx_mask[2] << 36) |
-			   (sta->deflink.ht_cap.mcs.rx_mask[1] << 24) |
-			   (sta->deflink.ht_cap.mcs.rx_mask[0] << 12);
+			   ((u64)sta->deflink.ht_cap.mcs.rx_mask[1] << 24) |
+			   ((u64)sta->deflink.ht_cap.mcs.rx_mask[0] << 12);
 		high_rate_masks = rtw89_ra_mask_ht_rates;
 		if (sta->deflink.ht_cap.cap & IEEE80211_HT_CAP_RX_STBC)
 			stbc_en = 1;
-- 
2.43.0



