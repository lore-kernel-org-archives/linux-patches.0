Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D866251029;
	Tue, 23 Jan 2024 01:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974004; cv=none; b=HTT3AisJMEXosFbK36QeEP1fJx7ZpWrWDBiGg0VlJ/mHk8Far7EdkheZ2dXQnCt1t5j4wHRIOkC7bOkQC9013JIQvXxm4qorW3eF5sAR1LpcZDiR9uzsu3C5QzKuGcAWrrwHVudEvjgaY8ltXRfaFmJIsGytL70JWF3hlRSAU9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974004; c=relaxed/simple;
	bh=c48ejUes8Fu15iGOFP3b4pDfHzWaCxU+1wzJ2lXb+EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prDfcBDehIFVVBO7AexgbgAULGBxVcyhGrVRscqvPsj0S0TDIwysmnfEtn/uRk5QhRUKiHObrVHJ7JLyGtucrJdoJreIcZuOPde4ggY+AhNMs+VOCrGqeWsO+T9HV2AJwGMCUvoWp2Ew9vVVRrYaxp72fR0QwusZo5P2RYsvpzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUk34aoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUk34aoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5FAC43394;
	Tue, 23 Jan 2024 01:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974004;
	bh=c48ejUes8Fu15iGOFP3b4pDfHzWaCxU+1wzJ2lXb+EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUk34aoLwBWopqXMVIdJ1knLSWYtYk8rMcMSSALAdRfjgYV2sRnAQGKaxtB5U3Sz4
	 pSkUDYttjx96vy97WQSpkx9V6y+4rw/8c4dOOR08k5e0vVbPw0fMuXzm+HvaKp5+J7
	 gcOc3tR6rlgClx2hs5ZYNHrkYinCNcn7rDstvCEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/374] wifi: rtw88: fix RX filter in FIF_ALLMULTI flag
Date: Mon, 22 Jan 2024 15:56:13 -0800
Message-ID: <20240122235748.709437083@linuxfoundation.org>
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
index 6f5629852416..942bb2ab8b50 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -267,9 +267,9 @@ static void rtw_ops_configure_filter(struct ieee80211_hw *hw,
 
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



