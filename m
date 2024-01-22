Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926C75D8FB;
	Tue, 23 Jan 2024 00:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970617; cv=none; b=MFFppXLa+b1BDreJchErILYF7FAIUkh8fd8nNIcCajDLPEG1Q8QAEqA4R1RkQQN9kZ3BFKdsmGkkwM78AhkYSpJ5jhxqkvrtto483OwWBd1MGYSb3SOJdwFkT5oin/xvb671tpbtth8fFQwrw9N6Ob0vuNxh0v5BkjLm/EanGmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970617; c=relaxed/simple;
	bh=yErAR4BWXqd/mtpdqpk+InwGTsRfN/Tco9bSt68DF3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFKbS0GdM9j8uxfbNayiF24oV6kJTMrWziiBhSXGVhp6Zh7qjMgc2OrCkJreoR3DzNiDlHULXzc+2NTGx63wsZRb18aXNGMSYYRb7J4J6/HcQ5953VDlXgExTF4X3+lOrcklsKemyUOPBypZ+0BsN+PtiPDBff2aPueBR02DevE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIh2rbcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIh2rbcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869FFC433C7;
	Tue, 23 Jan 2024 00:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970617;
	bh=yErAR4BWXqd/mtpdqpk+InwGTsRfN/Tco9bSt68DF3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIh2rbcKmhN3BB/iQ5KmqxKXinRhuR8IQxxBKKCvzAw3ciO37WOrpSiWn8CCMzr0k
	 Tn2e8LJVGqYSeYsJUFWTJz5mCjepHTZVbmwgJ7VnU5OpQa1mTZmuh+4nj1vSiz93+B
	 6FUen6KqIRSjQuVM9bfXglOjIMQGuyZKbzjVHe6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/417] wifi: rtw88: fix RX filter in FIF_ALLMULTI flag
Date: Mon, 22 Jan 2024 15:53:57 -0800
Message-ID: <20240122235754.095112369@linuxfoundation.org>
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
index fabca307867a..0970d6bcba43 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -266,9 +266,9 @@ static void rtw_ops_configure_filter(struct ieee80211_hw *hw,
 
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



