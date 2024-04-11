Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7291442F7;
	Thu, 11 Apr 2024 10:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830025; cv=none; b=MGd7xAmOQiD/DuMD7vSB1EMOEG+sC2lVPo80hBPHVjidbe3MKaRAz5x4dbNSHWainPijHthoAFhAKj/GMgWhSzoDzPXMo2UalZxCm993WcAGBcUK87S0OAbunL4vsIFlzZRWbnVWtrmtUrabVWluC+RlSQAapScHkKdz+5uJhME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830025; c=relaxed/simple;
	bh=EcvyI0tLq0J3KXmVagfs47f35aDPFOPjI1hOznYTLuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhV1T5bECFKdZ9enIDLEjGLlWikOwuMaX5q1WRhQaFdWvRlfWDXthTjDPgWjIKGxqTf7KgzPlWeEYuHI5gpJjivcW7gVoT546dmA5pTQ7SPedpeJcWr6mIiVQD7e/vIngXXanUDJVj6/ZCX25SOabqxlsJXoCDX5gW9aT3TTLl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNYovGmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNYovGmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E63C433F1;
	Thu, 11 Apr 2024 10:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830025;
	bh=EcvyI0tLq0J3KXmVagfs47f35aDPFOPjI1hOznYTLuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNYovGmQqjgp6u+z0zPK9/4EHVQ1L8iNxe/Xo/hKDOfWfHzD/L4SVpqLCxRsOu/DE
	 /gtfvIz5rEvcccnK/lUYFTiLndFg+CJ55hWYfb+wEhuWBMPa2gfNK+mphjgyqmwnlf
	 o+QlfTQxgTVPV1+InqU5n+ApQZgAfQ2C8FPTsQTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Po-Hao Huang <phhuang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 002/143] wifi: rtw89: fix null pointer access when abort scan
Date: Thu, 11 Apr 2024 11:54:30 +0200
Message-ID: <20240411095420.980876023@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit 7e11a2966f51695c0af0b1f976a32d64dee243b2 ]

During cancel scan we might use vif that weren't scanning.
Fix this by using the actual scanning vif.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240119081501.25223-6-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 93889d2fface1..956a06c8cdaab 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -441,7 +441,7 @@ static void rtw89_ops_bss_info_changed(struct ieee80211_hw *hw,
 			 * when disconnected by peer
 			 */
 			if (rtwdev->scanning)
-				rtw89_hw_scan_abort(rtwdev, vif);
+				rtw89_hw_scan_abort(rtwdev, rtwdev->scan_info.scanning_vif);
 		}
 	}
 
@@ -990,7 +990,7 @@ static int rtw89_ops_remain_on_channel(struct ieee80211_hw *hw,
 	}
 
 	if (rtwdev->scanning)
-		rtw89_hw_scan_abort(rtwdev, vif);
+		rtw89_hw_scan_abort(rtwdev, rtwdev->scan_info.scanning_vif);
 
 	if (type == IEEE80211_ROC_TYPE_MGMT_TX)
 		roc->state = RTW89_ROC_MGMT;
-- 
2.43.0



