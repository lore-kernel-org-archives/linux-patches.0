Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BAA4BD7BC;
	Wed, 30 Sep 2026 18:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793979; cv=none; b=XB5lFHYHuF0Qhs2BQ3E7+EWs61hm1Y+T1Q1j3taQzhc89OJYIpRtN6uXQUodVQmBGqoCwHL6f7rLdz2zFrHzpDzFcqVYwaAtxtKzPxNhi6rckZFI9z3OWOj1It0QT5wpSEr4bFko5Hr4KdSr/gLqD13nJf58/OB5TbJ4XB/AHRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793979; c=relaxed/simple;
	bh=ih2+IKlpG7Ghe03T/Q7DWKegcJBphQYWudt8rpD+WB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+iCRsfskeWZFB1zDWYX5dgW5XZM9jBpfjdkrQN6YCwg5uxx1tfinj0+UpcHaze0Evlc0ZS57GH0uFKe6Q6uNctKFKuwmxA41St/oglCG8XSONg32dU6cT2ld3qdX3fGbcY3Sj8a2i4np0nxZMy/2RGIH95wszdcEIGprCgJ0kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17xAWhTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17xAWhTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786581F000FF;
	Wed, 30 Sep 2026 18:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793978;
	bh=iIaKE7GEicMcHkVwmxTt3bA1DbTkD0wM4D2NIA8v1oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=17xAWhTJdoKLU8eHcNf8TlFcPpqcg8OjiS2XT0CYXWyEo1zOswQRam1j7V31Qan9j
	 iK0rAP7g7LmKV989woKGvycO+7zLK+hSrB/V3mGKBrUOq82bmSly2bYXia3RFvrWTQ
	 S+JHMTbYcgG4t2e3i3R4YILS7xhmdR7TigKKyIGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0047/1193] wifi: rtw89: phy: check length before parsing PHY status IE
Date: Wed, 30 Sep 2026 17:12:11 +0200
Message-ID: <20260930152435.327855996@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c172ef13c9540..a31bfb81818cd 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1423,13 +1423,15 @@ static int rtw89_core_rx_parse_phy_sts(struct rtw89_dev *rtwdev,
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
 
 	rtw89_phy_antdiv_parse(rtwdev, phy_ppdu);
-- 
2.53.0



