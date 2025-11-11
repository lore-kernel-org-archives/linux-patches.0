Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A772DDAB;
	Tue, 11 Nov 2025 01:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824844; cv=none; b=OGlU2Yg+EZecj1pLQza9FUnBp7RZFhqjUjm93LW+lOmymXuVEagxJWkBnvk01qQnKG+P0dUT/lgZSUPgcHNW85hTA/zL5eQXHCgyNrjJTPkCPh7qimSx1QFtr+B/JNzc0OBm3ogzQQjbzaUN0lDMScQkqlBbGbFUI9bXgpXq2Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824844; c=relaxed/simple;
	bh=yZdWvsypXNECnwA9FCBTWMmlPO1dhZPmCvhN4m3khl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mENmZD1WojuUAYvH7qtGHzbEIagRVPrGEP4nO+ccjGqawXG1FLUEsvmWMT5+NfIDRd+UFMC+Wu46LDG/5D/oveypevkmOtL05Z/PgPny6jYaiWuih1E/+gxy3D/RO0L5piJ3cOVaLFhtAQyW1dR6sZo17E/ZKanmen9O88k49kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvARaakU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvARaakU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED06BC19421;
	Tue, 11 Nov 2025 01:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824844;
	bh=yZdWvsypXNECnwA9FCBTWMmlPO1dhZPmCvhN4m3khl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvARaakU8UCKEqbGhDz5Bzxs6cE41Rw+vniWcs17mDIsoJm6RkV4j/P7zJax+YqBQ
	 J1cYwy59jHFGo7IhSw3D57LR4vXjYLkehKGgOgFo6UantjhFhycDUPFB8auHrBsQyx
	 dU/7qmXkaE3C3Us5xTUv8iYSQXPjnDEVSmHiM9Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 583/849] wifi: rtw89: obtain RX path from ppdu status IE00
Date: Tue, 11 Nov 2025 09:42:33 +0900
Message-ID: <20251111004550.513133505@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 0f7a467671ca8..2cebea10cb99b 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1844,6 +1844,10 @@ static void rtw89_core_parse_phy_status_ie00(struct rtw89_dev *rtwdev,
 
 	tmp_rpl = le32_get_bits(ie->w0, RTW89_PHY_STS_IE00_W0_RPL);
 	phy_ppdu->rpl_avg = tmp_rpl >> 1;
+
+	if (!phy_ppdu->hdr_2_en)
+		phy_ppdu->rx_path_en =
+			le32_get_bits(ie->w3, RTW89_PHY_STS_IE00_W3_RX_PATH_EN);
 }
 
 static void rtw89_core_parse_phy_status_ie00_v2(struct rtw89_dev *rtwdev,
diff --git a/drivers/net/wireless/realtek/rtw89/txrx.h b/drivers/net/wireless/realtek/rtw89/txrx.h
index ec01bfc363da3..307b22ae13b2a 100644
--- a/drivers/net/wireless/realtek/rtw89/txrx.h
+++ b/drivers/net/wireless/realtek/rtw89/txrx.h
@@ -572,6 +572,7 @@ struct rtw89_phy_sts_ie00 {
 } __packed;
 
 #define RTW89_PHY_STS_IE00_W0_RPL GENMASK(15, 7)
+#define RTW89_PHY_STS_IE00_W3_RX_PATH_EN GENMASK(31, 28)
 
 struct rtw89_phy_sts_ie00_v2 {
 	__le32 w0;
-- 
2.51.0



