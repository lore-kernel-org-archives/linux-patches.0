Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A983431EC;
	Tue, 11 Nov 2025 01:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824085; cv=none; b=JRsDVQl9mvU114tBnSgv/rj4MEdeMfR7buGK1+e3U5G9V+dZH4gkF1MaTjY2IEC42bH/mtjgh6RuiySI6Gbp81waTxkam0ZlBX18jvASilFrAbSIOawqSt4iVjGHqS46LVKqX5ouPnToxtwey1zdSO7/lQxj9HKdFO6KRXfRvuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824085; c=relaxed/simple;
	bh=osZhLOcvFpzxvJfnYe2YnGiYCLjpmfaOorH0mU+tCys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tv7USQeEW/ggAA8TvHA6oaHBwb5h5Q8gHrui8Ns6vVvrc6E4EUxoG2Zlwlf3FUOfq/hvjjhGAqhRBPe03hgH3h6cJen8AAnNJKF57wU71Ed7Z4q7JRbezGviD2xHeoebeXwrWN1RXqtreYnmrly9KYyXIQ4zytp6oPBDsLPGIpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJXMpXU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJXMpXU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE81C16AAE;
	Tue, 11 Nov 2025 01:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824085;
	bh=osZhLOcvFpzxvJfnYe2YnGiYCLjpmfaOorH0mU+tCys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJXMpXU7D92XhFw0o9rp/enLtiz6LBPY07EcQVgZreIse4oElRHqOXBPrgUa8B8Ty
	 Rv4Co+bO1PVUYOMOmeVMwAc5M4zfZ7syWwxG7oXYDmJ9tC7FTgLDU5y81tyqElUnpl
	 EtZ1otXen4B0wp9oqoJG51QAA05LOBZbpjwvtCNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 384/565] wifi: rtw89: obtain RX path from ppdu status IE00
Date: Tue, 11 Nov 2025 09:44:00 +0900
Message-ID: <20251111004535.509511766@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit e156d2ab36d7e47aec36845705e4ecb1e4e89976 ]

The header v2 of ppdu status is optional, If it is not enabled, the RX
path must be obtained from IE00 or IE01. Append the IE00 part.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250915065213.38659-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 4 ++++
 drivers/net/wireless/realtek/rtw89/txrx.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 1147abf771547..3584445b27387 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1710,6 +1710,10 @@ static void rtw89_core_parse_phy_status_ie00(struct rtw89_dev *rtwdev,
 
 	tmp_rpl = le32_get_bits(ie->w0, RTW89_PHY_STS_IE00_W0_RPL);
 	phy_ppdu->rpl_avg = tmp_rpl >> 1;
+
+	if (!phy_ppdu->hdr_2_en)
+		phy_ppdu->rx_path_en =
+			le32_get_bits(ie->w3, RTW89_PHY_STS_IE00_W3_RX_PATH_EN);
 }
 
 static void rtw89_core_parse_phy_status_ie00_v2(struct rtw89_dev *rtwdev,
diff --git a/drivers/net/wireless/realtek/rtw89/txrx.h b/drivers/net/wireless/realtek/rtw89/txrx.h
index b2e47829983fe..3a3b6154db458 100644
--- a/drivers/net/wireless/realtek/rtw89/txrx.h
+++ b/drivers/net/wireless/realtek/rtw89/txrx.h
@@ -568,6 +568,7 @@ struct rtw89_phy_sts_ie00 {
 } __packed;
 
 #define RTW89_PHY_STS_IE00_W0_RPL GENMASK(15, 7)
+#define RTW89_PHY_STS_IE00_W3_RX_PATH_EN GENMASK(31, 28)
 
 struct rtw89_phy_sts_ie00_v2 {
 	__le32 w0;
-- 
2.51.0



