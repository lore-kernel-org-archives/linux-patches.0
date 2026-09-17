Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B722538D80;
	Thu, 17 Sep 2026 16:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661189; cv=none; b=OsO+iMyX3nyzrKqZeqwEesFCFr1qG8DEKpDeSERaDKDq4BTNpIQLiMAekYaVnqCE0LMTf6Mly4ihO2xUVT1v81z1qs6ZbGeS6bkLAIhgsmEYxqPehnwaT47UFWweTqIBMde/Cu/qf1uT5YuVhoGagIMPbTPC23OkNVY6Tm7w2V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661189; c=relaxed/simple;
	bh=r7qb0sMnv85ZcFoDynz1si5B4H5Q/5j/P/gCo6aO4FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6SZXY4dUA3m9fbsHIzKEY16S6sQB6gQlyw4Asr6BzG2fKzjTQbekvskwgfKJB4WI9wXaKxxrnj/XSYs/MC1ofkCm86feWFwGMuTzJVkmMcRDodvuJSCow5xVc5hW5VuzWe8bmoT/DTW++cCB9R2JiqWMuR5euvilW5DsS7eDpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHwnvuRr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHwnvuRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A129D1F000FF;
	Thu, 17 Sep 2026 16:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661188;
	bh=qwbQBRfaFiUVbCBHgWpIzPZOk4m1E8D6wg98/DyVJGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHwnvuRrhoPqeMr6tfJWTjzLpdYPWzv2I83+u8PTw9MpUQKYkZ7YDNaYdK98rrXHN
	 RWvyGSBzBNwS8DIF9d6cOt5Gy2FU7vsfEHopzoRDK5SObhrbYl2dZNYG133Nnax/Dh
	 6G/j6AQBVybDBCQGqAJJYgk9vK/nWD5i2hsgv/XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0111/1250] wifi: rtw89: phy: check length before parsing PHY status IE
Date: Thu, 17 Sep 2026 15:58:26 +0100
Message-ID: <20260917151555.019757102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 884495c39de1a02f42bd40051b921e2311d6ac91 ]

Hardware might report PHY status IE with unexpected length, and parser
might access out of range. Check the length ahead.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260506131000.1706298-12-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index fa277c8e899fd..def596703c371 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2026,13 +2026,15 @@ static int rtw89_core_rx_parse_phy_sts(struct rtw89_dev *rtwdev,
 		const struct rtw89_phy_sts_iehdr *iehdr = pos;
 
 		ie_len = rtw89_core_get_phy_status_ie_len(rtwdev, iehdr);
-		rtw89_core_process_phy_status_ie(rtwdev, iehdr, phy_ppdu);
 		pos += ie_len;
 		if (pos > end || ie_len == 0) {
 			rtw89_debug(rtwdev, RTW89_DBG_TXRX,
 				    "phy status parse failed\n");
+
 			return -EINVAL;
 		}
+
+		rtw89_core_process_phy_status_ie(rtwdev, iehdr, phy_ppdu);
 	}
 
 	rtw89_chip_convert_rpl_to_rssi(rtwdev, phy_ppdu);
-- 
2.53.0



