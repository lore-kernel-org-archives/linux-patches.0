Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E21140E3D;
	Thu, 11 Apr 2024 10:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831131; cv=none; b=ZKhJJ8p/mByErprrvsgVmCF5YsTKS7zNFRWIMlkhJk8r/td+Np2UE+k+HDfVOPQz6MKx5fieyJFlOlpGj7Pp1p7p7y9mZmFiQnJLZ/wMvwg1zklTRO40hGe5rlX8NGFXW0nZwyQYK8f5o7hHB3Wh+SrHmNjQzmV1aUSQ1mpRHWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831131; c=relaxed/simple;
	bh=FK6iNNZKAFWoQF6Pwvw+/vMlwUZ1Ozto8HUy/kpOzrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/0sRFmSiRlltYSM1M1CYrcppPTdiaLth02JuXO5WH4AwEPfX2c/D/fQQf4jR8YxnHmhWDxYK7cJuFlohyMcdLeyTiyfeMDkwRHFFek5/NKFpS0GPLSJ+p/kfK6rrJUVSbsSb8voaF27tF1ZvmnbcrwYitfBla2hBFFIs/tTLyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArSebLjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArSebLjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29129C433F1;
	Thu, 11 Apr 2024 10:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831131;
	bh=FK6iNNZKAFWoQF6Pwvw+/vMlwUZ1Ozto8HUy/kpOzrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ArSebLjOxOjkRdqT/ZGM9EQ36zLD9W5ctdE3fyxv/ZbztwGKKsl8ry86KX11xwJZb
	 9mqAdjwjkcjldIPNqfF56hYukvRnmh1m136cTND2LS+wI09FnrJfCSdsDcUUUJhvZG
	 AAciUr+xeOWVe/j4msZwgONKt4/gqFikY7Z1ch3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Po-Hao Huang <phhuang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/114] wifi: rtw89: fix null pointer access when abort scan
Date: Thu, 11 Apr 2024 11:55:29 +0200
Message-ID: <20240411095416.932648929@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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
index e70757e4dc2c1..8aed0d101bf3b 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -422,7 +422,7 @@ static void rtw89_ops_bss_info_changed(struct ieee80211_hw *hw,
 			 * when disconnected by peer
 			 */
 			if (rtwdev->scanning)
-				rtw89_hw_scan_abort(rtwdev, vif);
+				rtw89_hw_scan_abort(rtwdev, rtwdev->scan_info.scanning_vif);
 		}
 	}
 
@@ -971,7 +971,7 @@ static int rtw89_ops_remain_on_channel(struct ieee80211_hw *hw,
 	}
 
 	if (rtwdev->scanning)
-		rtw89_hw_scan_abort(rtwdev, vif);
+		rtw89_hw_scan_abort(rtwdev, rtwdev->scan_info.scanning_vif);
 
 	if (type == IEEE80211_ROC_TYPE_MGMT_TX)
 		roc->state = RTW89_ROC_MGMT;
-- 
2.43.0



