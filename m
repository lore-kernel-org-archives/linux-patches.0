Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E23346AE3;
	Sat, 12 Sep 2026 07:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198259; cv=none; b=mKsrLguDpX2uKeZSZ2qQ9LQ2hSRvx0e8d7HuK3wv4TBWozMc476VQ2+T5FFDdLJ6trDrR+Mz5IaJlEznE8FkymAV5+CEX6WdlnLrC9pis4AIDGLQWmMsIqFP+nbvfYAf6CA2n99XdqJjcTctRyrk+gBOlG8n3VAT4dCBLpPRkCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198259; c=relaxed/simple;
	bh=yBnNBrJCVTkjIueIzQR4AZzfPF3QDHACNywJqByII7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/ww/2ExB75+OWKlNl3/kbEeK834wOPDKX+8Apfezv9zLhuZd4REKDS7ImW/0gDctNFYMVug5NQfIhPwmRgIURgA2c6rg+leckWHiyaLTywsawn+iv1kpaInt29kiOonu61yzVkIiqDtYqQ4E9ahh+XUbWJhZUcac5uLNx4irjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAkYhgzk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAkYhgzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3179F1F000FF;
	Sat, 12 Sep 2026 07:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198257;
	bh=bZ8iw8jS/jIUxZtaiS2pVoWRn0S5j/ubhly8KJzVbCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xAkYhgzkUcqw+B3HZvx8hsar3XivQEgDWGy394dndag4CbzBuyS8uAUB2vdpFa1OW
	 dcGw0DTbgEAbEaKOpb11DHUzcFqBY8dsWsSYFE/sm08WEfKsx6fjbZrAPmSz41n2I6
	 rDK68izBec3Qc0IWY7z6OPAP4b2b9N5UldHZymwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0343/1815] wifi: rtw89: 8852a: fix RSSI report when average beacon RSSI is not ready
Date: Sat, 12 Sep 2026 08:34:53 +0200
Message-ID: <20260912065656.965509767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit 9bf6bd6ed5accb57544d04ded911a2ef1642d48f ]

8852A uses the average beacon RSSI to smooth the RSSI. However, before
the average beacon RSSI is available, the RSSI should use the PPDU
status RSSI of the received packet to avoid reporting the RSSI as -110 dBm.

Fixes: f0f3bf4b370c ("wifi: rtw89: 8852a: report average RSSI to avoid unnecessary scanning")
Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260707091056.42771-13-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8852a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852a.c b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
index 2c1f166e687f0..e27a81bd8b77d 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
@@ -2212,7 +2212,7 @@ static void rtw8852a_query_ppdu(struct rtw89_dev *rtwdev,
 	u8 raw;
 
 	if (!status->signal) {
-		if (phy_ppdu->to_self)
+		if (phy_ppdu->to_self && ewma_rssi_read(&bb->bcn_rssi))
 			raw = ewma_rssi_read(&bb->bcn_rssi);
 		else
 			raw = max(rx_power[RF_PATH_A], rx_power[RF_PATH_B]);
-- 
2.53.0



