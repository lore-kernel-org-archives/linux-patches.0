Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE734F8AE;
	Tue, 23 Jan 2024 01:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974402; cv=none; b=f7nN9lHNpTnvvVo06wx2tqV3m98UKOtosc5e1VOgP78uMjW9JvtdCK0YMo2a6Dqm2mr9TmWWB8VOAhaL2mDt1fkTgd2nSrV4+FHMTK50SF1Ch80FVuRbBEKdCrjCJrryfkckPDuBWSeUIXuav4TKwWt4K0JxFPPAQmcYiesQJxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974402; c=relaxed/simple;
	bh=LbIYW61W5RziZ8fKB1QDaCJXdF3nOWi58w/3WCfKLZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyx+7zOx1Yb0Lpipi9TArih76oj6A7dIm08uWQNPoeUarhH+JWrQdjQqpMPIgqEGjHswGEq9aBhipGHT++meFVm0zlgR6gjX6PLAr7yCH593M0ftJdAMoG5Zu86BRwCErlVJ8flww4A516EvqxCAMWleSg/I7vTuHvPBTejaAoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5psUq5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5psUq5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72495C433F1;
	Tue, 23 Jan 2024 01:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974402;
	bh=LbIYW61W5RziZ8fKB1QDaCJXdF3nOWi58w/3WCfKLZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5psUq5pgKa5WxwoeFkuN0d7Zcwnr4xOZt+sGZVFONp/cj1k7k72ICvsqF7h6Rayd
	 znVNaL+TUIcLXdlQ3m+4klkfvRdS1j6SJaK59+rSLC2t9a76WqtPRPk3epQV4H7yQG
	 B6NA8eldPLdTQgs7YeZnYqrZmhHYFkfUKBtwawXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/583] wifi: rtw88: fix RX filter in FIF_ALLMULTI flag
Date: Mon, 22 Jan 2024 15:52:18 -0800
Message-ID: <20240122235814.831343487@linuxfoundation.org>
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

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit 53ee0b3b99edc6a47096bffef15695f5a895386f ]

The broadcast packets will be filtered in the FIF_ALLMULTI flag in
the original code, which causes beacon packets to be filtered out
and disconnection. Therefore, we fix it.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20231103020851.102238-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index a99b53d44267..d8d68f16014e 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -280,9 +280,9 @@ static void rtw_ops_configure_filter(struct ieee80211_hw *hw,
 
 	if (changed_flags & FIF_ALLMULTI) {
 		if (*new_flags & FIF_ALLMULTI)
-			rtwdev->hal.rcr |= BIT_AM | BIT_AB;
+			rtwdev->hal.rcr |= BIT_AM;
 		else
-			rtwdev->hal.rcr &= ~(BIT_AM | BIT_AB);
+			rtwdev->hal.rcr &= ~(BIT_AM);
 	}
 	if (changed_flags & FIF_FCSFAIL) {
 		if (*new_flags & FIF_FCSFAIL)
-- 
2.43.0



