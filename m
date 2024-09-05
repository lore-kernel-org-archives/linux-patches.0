Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE7719413B;
	Thu,  5 Sep 2024 10:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530571; cv=none; b=F7ygkukWeQEZ0+f2Umcf9MYfATbryKfLHlI4vCoSIaIuk6lTYLEvdED5kbGFDugSTRFhdY3W2urr5FSHEjEYGjb/MdZ3RERue2pW66oWiIAY7MIRbYdvuQUwrWYLPcayfhWHulIhnxROcLOk1r0dVzxCxUI8w3iRpMHcdNP21nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530571; c=relaxed/simple;
	bh=M0OUV7kbuOsyNLlDQnnkuV/oU7rrhp3I1dCrKENd42w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxtsMAB5oTbTyEKxah1aG1yKsq36QRePgiw54mEZPe0b97yrkdhlIeFCCC1T0jFFna/2DwE4iQHZmUPQsnZ7dZklwT/iRbzgmN0loyPeV39M+7KXTOpp5bOWtYqZ+2Lg62bmhf9JQDN2leTKe1pBcJbcO4vkLyyfR11wiiOpL4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXgT3ASB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXgT3ASB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCB5C4CEC3;
	Thu,  5 Sep 2024 10:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530571;
	bh=M0OUV7kbuOsyNLlDQnnkuV/oU7rrhp3I1dCrKENd42w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXgT3ASBSrTxN97zjk4lM1j8Zu5sI84Hyi93p60VX17Kooa61/FkRP4S7nJuhZsfD
	 EzQrWn8m/N38iSUp0lUd+piLWtvkIFGsrpLY77aZE2wEEjywgOIKd06JpxfY+xb7pm
	 bY0j8WqWNwpQ7WukFUjoRUV8UsOiWb2cOPfvRics=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/101] wifi: rtw89: ser: avoid multiple deinit on same CAM
Date: Thu,  5 Sep 2024 11:41:38 +0200
Message-ID: <20240905093718.722579815@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit cea4066588308fa932b6b03486c608efff1d761c ]

We did deinit CAM in STA iteration in VIF loop. But, the STA iteration
missed to restrict the target VIF. So, if there are multiple VIFs, we
would deinit a CAM multiple times. Now, fix it.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/20240509090646.35304-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/ser.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/ser.c b/drivers/net/wireless/realtek/rtw89/ser.c
index c1a4bc1c64d1..afb1b41e1a9a 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -304,9 +304,13 @@ static void ser_reset_vif(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 
 static void ser_sta_deinit_cam_iter(void *data, struct ieee80211_sta *sta)
 {
-	struct rtw89_vif *rtwvif = (struct rtw89_vif *)data;
-	struct rtw89_dev *rtwdev = rtwvif->rtwdev;
+	struct rtw89_vif *target_rtwvif = (struct rtw89_vif *)data;
 	struct rtw89_sta *rtwsta = (struct rtw89_sta *)sta->drv_priv;
+	struct rtw89_vif *rtwvif = rtwsta->rtwvif;
+	struct rtw89_dev *rtwdev = rtwvif->rtwdev;
+
+	if (rtwvif != target_rtwvif)
+		return;
 
 	if (rtwvif->net_type == RTW89_NET_TYPE_AP_MODE || sta->tdls)
 		rtw89_cam_deinit_addr_cam(rtwdev, &rtwsta->addr_cam);
-- 
2.43.0



