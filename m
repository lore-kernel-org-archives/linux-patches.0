Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4E951C057;
	Thu, 17 Sep 2026 17:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667394; cv=none; b=i6NEIvyW6x0VkhgQKvFk30gmEaR6m9wPSBRH7lLgogoefBAv9JPzioJavQafOREu4g6G8ywoa4M9g+lbapzxsPrcgy+ym2tjDLubOIch07F2MYujSMgKEUEvbp+s0mjKDFMA/Kkfke5cxyal4jHccZqoQt0x8B9e4bKNzKlbtWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667394; c=relaxed/simple;
	bh=xfCwYG6OKEm6wmOL2sDjY1+WnzMUliwcl3Qqxh3V+4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BorHZw30vM7widwkvERyYW0fya4Y00HK+ZwG4Q53txilyAoUwyJTshOBmaWGIbmr0IHyUCPr0vR65/iONZJ3PSCdUre3OrGiFNQj1UDRI1F0HyPtUOC2WAGvZD8bBM5IwuStMAJLjKoBKB8BA56sg0TZquaM7abbf4DjCYzub5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1cUo/Mg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1cUo/Mg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51231F000FF;
	Thu, 17 Sep 2026 17:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667393;
	bh=syC/+dfdoVxp5qYtW66mriBA7n68NvYp/I8lQ5YMMKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n1cUo/MgcR6614288060fN9+l+OqG+vckF/gvvyAS3ZSNZx2TicWY1IcVt44G7ZDL
	 hV9NHerjJF2ioRe2t7b952cHsVjeDmElz2sdXjVFokmY+xE7sfDD9PbfjRMm73DsBt
	 7s/hL5LUmxFA44XvS4JMEyn4sOU/9jCZdbn5G4xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0077/1102] wifi: rtw89: phy: check length before parsing PHY status IE
Date: Thu, 17 Sep 2026 16:00:20 +0100
Message-ID: <20260917151541.402797511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index faa764d5c1a01..12bb293fafd31 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1824,13 +1824,15 @@ static int rtw89_core_rx_parse_phy_sts(struct rtw89_dev *rtwdev,
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



