Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF36A12A17F;
	Tue, 23 Jan 2024 00:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968884; cv=none; b=HZEbCJLFh90UCvQiGihGBMsz0H5InUBECnKCt9UQSHk1ZZXZGaeYSrOrBBAr2ETgbB8Tx5nHbYfuU3BgrkSPfhqrrnwEjPHti3/vnUnc8W7uU2pIN5V5Vjw++u8dYywxgYJCYPQmW6nvLQQ1lakWgEZNWlYj5i0gJ7aXcn1XwQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968884; c=relaxed/simple;
	bh=xXGP+Mr+O8Lgj796fqQFpDLt97rXeuDSovBN0LEX2WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUQZKntBkuJvi81miPzVjYGH0Y2XptNwH0uqt4SQb+zSvT0A+RkUA55jPBF6Q4pb87Yjq5Qtd71epyEpoPzXfxF+Vp6/baSzZjrZzEGIeLOrrktziMgQF55tOJIJcUFz+3+L34tSgotKuW+QUIZvaMEtdjtACWaBOdNYdW0aI88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hlgxn9La; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hlgxn9La"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7958AC43601;
	Tue, 23 Jan 2024 00:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968884;
	bh=xXGP+Mr+O8Lgj796fqQFpDLt97rXeuDSovBN0LEX2WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlgxn9LaXBjdTY/A1OLeHcXHuhL475FOYt6cQjHESlu47B1iRIkWc9fH1E86AsUWZ
	 wh+VfoxgxQWsQ3imTusOl5zXCRoByhBt1ytYov6yN3ws48foYlKQGSOC3Q/bz/OURn
	 QDViiIdVNXesKg1ONFPFo3C9fp7+NBGS6xZUktuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/194] wifi: rtw88: fix RX filter in FIF_ALLMULTI flag
Date: Mon, 22 Jan 2024 15:56:50 -0800
Message-ID: <20240122235722.667674525@linuxfoundation.org>
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
index e5e3605bb693..efcfeccee15f 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -206,9 +206,9 @@ static void rtw_ops_configure_filter(struct ieee80211_hw *hw,
 
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



