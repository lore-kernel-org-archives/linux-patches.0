Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA47BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179C7C433EF;
	Tue,  7 Mar 2023 17:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209747;
	bh=qrBxi3nMFJBVIywAN+Yj6aeDCNvyqPxrGsA+MzpZM+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bg80vrqOJluZdGX4V6LM6bCQeZ5HuRYUjY0H2tH4P/McEtoSmvJ6afi9wvI5LV5JK
	 5zIvf654B64V26L7yEvzO/YrcpXyOflREG1znTJvysxACgMWqSMpWICqbprxUnEpDt
	 nGb+J8jeK/OYjtSfKf7SLchTtBgvDFWFFDVy5dkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0291/1001] wifi: rtw89: fix parsing offset for MCC C2H
Date: Tue,  7 Mar 2023 17:51:03 +0100
Message-Id: <20230307170034.251826868@linuxfoundation.org>
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

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 24d72944d79e6795ba4330c114de0387386bf3aa ]

A 8-byte offset is missed during parsing C2Hs (chip to host packets)
of MCC (multi-channel concurrent) series.
So, we fix it.

Fixes: ef9dff4cb491 ("wifi: rtw89: mac: process MCC related C2H")
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230119064342.65391-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.h | 34 ++++++++++++-------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index 4d2f9ea9e0022..2e4ca1cc5cae9 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -3209,16 +3209,16 @@ static inline struct rtw89_fw_c2h_attr *RTW89_SKB_C2H_CB(struct sk_buff *skb)
 	le32_get_bits(*((const __le32 *)(c2h) + 5), GENMASK(25, 24))
 
 #define RTW89_GET_MAC_C2H_MCC_RCV_ACK_GROUP(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h)), GENMASK(1, 0))
+	le32_get_bits(*((const __le32 *)(c2h) + 2), GENMASK(1, 0))
 #define RTW89_GET_MAC_C2H_MCC_RCV_ACK_H2C_FUNC(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h)), GENMASK(15, 8))
+	le32_get_bits(*((const __le32 *)(c2h) + 2), GENMASK(15, 8))
 
 #define RTW89_GET_MAC_C2H_MCC_REQ_ACK_GROUP(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h)), GENMASK(1, 0))
+	le32_get_bits(*((const __le32 *)(c2h) + 2), GENMASK(1, 0))
 #define RTW89_GET_MAC_C2H_MCC_REQ_ACK_H2C_RETURN(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h)), GENMASK(7, 2))
+	le32_get_bits(*((const __le32 *)(c2h) + 2), GENMASK(7, 2))
 #define RTW89_GET_MAC_C2H_MCC_REQ_ACK_H2C_FUNC(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h)), GENMASK(15, 8))
+	le32_get_bits(*((const __le32 *)(c2h) + 2), GENMASK(15, 8))
 
 struct rtw89_mac_mcc_tsf_rpt {
 	u32 macid_x;
@@ -3232,30 +3232,30 @@ struct rtw89_mac_mcc_tsf_rpt {
 static_assert(sizeof(struct rtw89_mac_mcc_tsf_rpt) <= RTW89_COMPLETION_BUF_SIZE);
 
 #define RTW89_GET_MAC_C2H_MCC_TSF_RPT_MACID_X(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h)), GENMASK(7, 0))
+	le32_get_bits(*((const __le32 *)(c2h) + 2), GENMASK(7, 0))
 #define RTW89_GET_MAC_C2H_MCC_TSF_RPT_MACID_Y(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h)), GENMASK(15, 8))
+	le32_get_bits(*((const __le32 *)(c2h) + 2), GENMASK(15, 8))
 #define RTW89_GET_MAC_C2H_MCC_TSF_RPT_GROUP(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h)), GENMASK(17, 16))
+	le32_get_bits(*((const __le32 *)(c2h) + 2), GENMASK(17, 16))
 #define RTW89_GET_MAC_C2H_MCC_TSF_RPT_TSF_LOW_X(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h) + 1), GENMASK(31, 0))
+	le32_get_bits(*((const __le32 *)(c2h) + 3), GENMASK(31, 0))
 #define RTW89_GET_MAC_C2H_MCC_TSF_RPT_TSF_HIGH_X(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h) + 2), GENMASK(31, 0))
+	le32_get_bits(*((const __le32 *)(c2h) + 4), GENMASK(31, 0))
 #define RTW89_GET_MAC_C2H_MCC_TSF_RPT_TSF_LOW_Y(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h) + 3), GENMASK(31, 0))
+	le32_get_bits(*((const __le32 *)(c2h) + 5), GENMASK(31, 0))
 #define RTW89_GET_MAC_C2H_MCC_TSF_RPT_TSF_HIGH_Y(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h) + 4), GENMASK(31, 0))
+	le32_get_bits(*((const __le32 *)(c2h) + 6), GENMASK(31, 0))
 
 #define RTW89_GET_MAC_C2H_MCC_STATUS_RPT_STATUS(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h)), GENMASK(5, 0))
+	le32_get_bits(*((const __le32 *)(c2h) + 2), GENMASK(5, 0))
 #define RTW89_GET_MAC_C2H_MCC_STATUS_RPT_GROUP(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h)), GENMASK(7, 6))
+	le32_get_bits(*((const __le32 *)(c2h) + 2), GENMASK(7, 6))
 #define RTW89_GET_MAC_C2H_MCC_STATUS_RPT_MACID(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h)), GENMASK(15, 8))
+	le32_get_bits(*((const __le32 *)(c2h) + 2), GENMASK(15, 8))
 #define RTW89_GET_MAC_C2H_MCC_STATUS_RPT_TSF_LOW(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h) + 1), GENMASK(31, 0))
+	le32_get_bits(*((const __le32 *)(c2h) + 3), GENMASK(31, 0))
 #define RTW89_GET_MAC_C2H_MCC_STATUS_RPT_TSF_HIGH(c2h) \
-	le32_get_bits(*((const __le32 *)(c2h) + 2), GENMASK(31, 0))
+	le32_get_bits(*((const __le32 *)(c2h) + 4), GENMASK(31, 0))
 
 #define RTW89_FW_HDR_SIZE 32
 #define RTW89_FW_SECTION_HDR_SIZE 16
-- 
2.39.2



