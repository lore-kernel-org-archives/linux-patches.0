Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B53381E98;
	Sat, 12 Sep 2026 09:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207073; cv=none; b=tXKiqGnYNnCHbnk/kwaysoGTIjHLeA0ni02ac+Ckn1iN1jKH5lw6kZjCuAIRqd+OllNpfOfwX/Zb9qsViYsGL8MKJLPtHrYrSzeABcsv2jci4hc4qbSxAZko6qXt1YbCu3ywU3LrAzSmFFrIfQv/QbjrrC1QIrcXB42InzNEj/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207073; c=relaxed/simple;
	bh=wEUenb/u3QGbneJydFAQvM+yF5qcBWI7yHmuZDqCS2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B64Jgksg2XK4rggvNItUlOENJMM6W/6WCgk7X2BqwSqQPBfjvnPcRYAk6XwOi2P0OQE7THWMOmBwrHid99tnW613FcykjFZqspBv/kOwcFESlT+KxWGvCCGmRK5COfe3eenEt+bZVpU591Sz0QJm+rNBPxUEGrx0hnfQ+VH6pT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFnKak+x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFnKak+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6201F00893;
	Sat, 12 Sep 2026 09:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207072;
	bh=Ty7FSBpCbb+P097fyOUucyh+Xiz4eQc9PekhZUQqskQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DFnKak+xCaLdVAcKTrsRFQIyoYv4RlqA8cUTjBx/F1cVG/GfFR44CupAuVgXHouTH
	 6PSI95XFaWeTMVFhdmcLpCqnhRcYwHokDECmIGMgm4jzDFBww22Huhret6O3lFdzmO
	 lEp+Nd+kVfQTaUhsDqWmpMjbsDxkWS2wSnbJQxpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0338/1518] wifi: rtw89: 8852a: fix RSSI report when average beacon RSSI is not ready
Date: Sat, 12 Sep 2026 08:41:47 +0200
Message-ID: <20260912065631.117955129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a8b604adadddf..3defb38223e8b 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
@@ -2113,7 +2113,7 @@ static void rtw8852a_query_ppdu(struct rtw89_dev *rtwdev,
 	u8 raw;
 
 	if (!status->signal) {
-		if (phy_ppdu->to_self)
+		if (phy_ppdu->to_self && ewma_rssi_read(&bb->bcn_rssi))
 			raw = ewma_rssi_read(&bb->bcn_rssi);
 		else
 			raw = max(rx_power[RF_PATH_A], rx_power[RF_PATH_B]);
-- 
2.53.0



