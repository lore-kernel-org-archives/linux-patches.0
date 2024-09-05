Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F501991AE;
	Thu,  5 Sep 2024 09:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529686; cv=none; b=rqkMziV6naNsq2hSpKux3F2t/KlafBMDvN4prWjNMAG8dleo7Q87k8jxfU832yZPF1EM792QVdQj1U9726Kci4uRYA3QfzbH3B8Ogm1u8IxzPHZcBv0EbcTpZ0CsKaR8WFzPRWNXbjsb4oSeRmZTVeqlBJkbCwq1m/EVmNjPKJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529686; c=relaxed/simple;
	bh=yLA9+es+mxzz9xoDLPRvdwcNfxRjpja8upFH5ygU+Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nlgg+drfUd5m809Y2UeueJKOp0UuTY3eoMhTDs+1yE68+I/uvnix1n4DxlJ2FXm2UPptU9aNwYukR2kVcc76OByrSsxSw4gMWMn3PQ2I5Dlx6uEgou1ewwb1xk8J5dpVEIPD/1Rr0WIhn0sUM+9wpcmPN/Z7Qs7K6Jbv0okFKgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOjh/QR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOjh/QR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA953C4CEC3;
	Thu,  5 Sep 2024 09:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529686;
	bh=yLA9+es+mxzz9xoDLPRvdwcNfxRjpja8upFH5ygU+Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOjh/QR3t7Vxo8XEYdyORFe92K2teCLFuW/gymGV1RngN4Y8A4u6KC0PblMRXYCj3
	 vTEcwTkoeNj6NmGKRFNIWW0O6Jk2nbkpc+7KjB0xZJtUZsJVN4oEUeIoGCaIU57e+/
	 OTzhu8FZRWbsHJBYWIjVxyvzX2jozEUWQY9APZtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 111/184] wifi: rtw89: ser: avoid multiple deinit on same CAM
Date: Thu,  5 Sep 2024 11:40:24 +0200
Message-ID: <20240905093736.566328186@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 99896d85d2f8..5fc2faa9ba5a 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -308,9 +308,13 @@ static void ser_reset_vif(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 
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



