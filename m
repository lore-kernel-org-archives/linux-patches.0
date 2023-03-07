Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE0CBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3CAC433D2;
	Tue,  7 Mar 2023 17:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209349;
	bh=nq2UfXBcl7AZfVeNq+TJuL3GUVqC2lF7UUL2F4RN0Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYibBR19P4yJ/ZdBWMP7QNPm6SYkKxeXERx6yJSVLYviaD34YDSNgbVbNDrWoLhKU
	 k0anPvA3mjmSNP8PbnfmvCaJg2kn4SO+dky4opEzGqBOYd3kiG9zi5okGZpCe00Ref
	 LRQdCWg7KrheRXL383jY5IBWCw4WLe8GX1KndzSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0158/1001] wifi: rtw89: 8852c: rfk: correct DPK settings
Date: Tue,  7 Mar 2023 17:48:50 +0100
Message-Id: <20230307170028.906964320@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 21b5f159a2ee47d30f418559f6ece0088c80199f ]

Some DPK settings are wrong, and causes bad TX performance occasionally.
So, fix them by internal suggestions.

Fixes: da4cea16cb13 ("rtw89: 8852c: rfk: add DPK")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221209020940.9573-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/reg.h          | 2 ++
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c | 9 ++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index 5324e645728bb..ca6f6c3e63095 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -3671,6 +3671,8 @@
 #define RR_TXRSV_GAPK BIT(19)
 #define RR_BIAS 0x5e
 #define RR_BIAS_GAPK BIT(19)
+#define RR_TXAC 0x5f
+#define RR_TXAC_IQG GENMASK(3, 0)
 #define RR_BIASA 0x60
 #define RR_BIASA_TXG GENMASK(15, 12)
 #define RR_BIASA_TXA GENMASK(19, 16)
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c b/drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c
index f5b0b57f33207..f3a07b0e672f7 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c
@@ -1872,12 +1872,11 @@ static void _dpk_rf_setting(struct rtw89_dev *rtwdev, u8 gain,
 			       0x50101 | BIT(rtwdev->dbcc_en));
 		rtw89_write_rf(rtwdev, path, RR_MOD_V1, RR_MOD_MASK, RF_DPK);
 
-		if (dpk->bp[path][kidx].band == RTW89_BAND_6G && dpk->bp[path][kidx].ch >= 161) {
+		if (dpk->bp[path][kidx].band == RTW89_BAND_6G && dpk->bp[path][kidx].ch >= 161)
 			rtw89_write_rf(rtwdev, path, RR_IQGEN, RR_IQGEN_BIAS, 0x8);
-			rtw89_write_rf(rtwdev, path, RR_LOGEN, RR_LOGEN_RPT, 0xd);
-		} else {
-			rtw89_write_rf(rtwdev, path, RR_LOGEN, RR_LOGEN_RPT, 0xd);
-		}
+
+		rtw89_write_rf(rtwdev, path, RR_LOGEN, RR_LOGEN_RPT, 0xd);
+		rtw89_write_rf(rtwdev, path, RR_TXAC, RR_TXAC_IQG, 0x8);
 
 		rtw89_write_rf(rtwdev, path, RR_RXA2, RR_RXA2_ATT, 0x0);
 		rtw89_write_rf(rtwdev, path, RR_TXIQK, RR_TXIQK_ATT2, 0x3);
-- 
2.39.2



