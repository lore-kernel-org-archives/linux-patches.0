Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15684149010;
	Tue, 23 Jan 2024 00:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969204; cv=none; b=TQkE5nmbZ7BCzTZuFspm9QBtT18X00fK9tF0YKvk8eXj1xnww6079rwOWeuZiHgqx21Vd+SUtilwxZ04CvYMlf7ouQQPh84xwpvfbOCdU0KtE1eBhgWLuwj+PWJNfwWcVsGCOEjEBRt3giUl16fMkJAaXRBgCSuXMzdavKCv/vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969204; c=relaxed/simple;
	bh=rd7a+CKBDhMJNlfZTwRAKJww2MI3XH3dI45YpHUrJyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+zNqIAQqOVT2/M+40RelIpP/gWLUTMHXenLTosdk1A0a9RxnlYmKjGeLJAeBjc4pLjbeAGwQ39reSJW6DEluGnzkiQzmh6vrumIED5LRJn1C9/Xr3x2nAWIazYA42PNEoSrO/ipKJ9KN8E6l6x9S5GRImyica4CadWt7DiVC4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2zEIkZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2zEIkZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE472C433F1;
	Tue, 23 Jan 2024 00:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969203;
	bh=rd7a+CKBDhMJNlfZTwRAKJww2MI3XH3dI45YpHUrJyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2zEIkZz8o5dhhPYvDEe3G62dGiGfsJqnOMhuRzWV0tYSgSFJytzHk+YPfsuVSVTd
	 qG5n/DasguGwBDl/GROZReGmWVfbFGm5xV0yMYaP5d6jjr+OywfrCB4bkLOLcmU/cB
	 IaFpkE4u4LUBGpODDZWDT+bul4peLPjH8XuTe4zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 097/641] wifi: rtw88: fix RX filter in FIF_ALLMULTI flag
Date: Mon, 22 Jan 2024 15:50:01 -0800
Message-ID: <20240122235821.072542896@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



