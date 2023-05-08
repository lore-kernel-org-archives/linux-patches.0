Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CC5168C2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF9FC433EF;
	Mon,  8 May 2023 10:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541279;
	bh=icmRkMYTIlstnD7SbqUZ/G3o/EJJCt4XV6vmioMfYK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJVLFWtoZHdSDu3nIRhImmM2dGgZcNjUPNpWCgdPT213tvFHmCtcx6a7q0z4gGL26
	 FO1Z1N37+nwmvronQP59ukeFL2ttodoo8fBMwpD115hZFB1+WkZzxQBn128OBJj0PY
	 0mRygAkSeF28qk3ZwwwZwSh0DxTTCypAAyHMcsqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <echuang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.2 062/663] wifi: rtw89: correct 5 MHz mask setting
Date: Mon,  8 May 2023 11:38:08 +0200
Message-Id: <20230508094430.498910238@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Huang <echuang@realtek.com>

commit d33fc8d0368c180fe2338bfae4f5367a66a719f4 upstream.

Use primary channel index to determine which 5 MHz mask should be enable.
This mask is used to prevent noise from channel edge to effect CCA
threshold in wide bandwidth (>= 40 MHZ).

Fixes: 1b00e9236a71 ("rtw89: 8852c: add set channel of BB part")
Fixes: 6b0698984eb0 ("wifi: rtw89: 8852b: add chip_ops::set_channel")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Huang <echuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230406072841.8308-1-pkshih@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8852b.c |    9 +++++----
 drivers/net/wireless/realtek/rtw89/rtw8852c.c |    9 +++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
@@ -1284,7 +1284,7 @@ static void rtw8852b_ctrl_cck_en(struct
 static void rtw8852b_5m_mask(struct rtw89_dev *rtwdev, const struct rtw89_chan *chan,
 			     enum rtw89_phy_idx phy_idx)
 {
-	u8 pri_ch = chan->primary_channel;
+	u8 pri_ch = chan->pri_ch_idx;
 	bool mask_5m_low;
 	bool mask_5m_en;
 
@@ -1292,12 +1292,13 @@ static void rtw8852b_5m_mask(struct rtw8
 	case RTW89_CHANNEL_WIDTH_40:
 		/* Prich=1: Mask 5M High, Prich=2: Mask 5M Low */
 		mask_5m_en = true;
-		mask_5m_low = pri_ch == 2;
+		mask_5m_low = pri_ch == RTW89_SC_20_LOWER;
 		break;
 	case RTW89_CHANNEL_WIDTH_80:
 		/* Prich=3: Mask 5M High, Prich=4: Mask 5M Low, Else: Disable */
-		mask_5m_en = pri_ch == 3 || pri_ch == 4;
-		mask_5m_low = pri_ch == 4;
+		mask_5m_en = pri_ch == RTW89_SC_20_UPMOST ||
+			     pri_ch == RTW89_SC_20_LOWEST;
+		mask_5m_low = pri_ch == RTW89_SC_20_LOWEST;
 		break;
 	default:
 		mask_5m_en = false;
--- a/drivers/net/wireless/realtek/rtw89/rtw8852c.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852c.c
@@ -1445,18 +1445,19 @@ static void rtw8852c_5m_mask(struct rtw8
 			     const struct rtw89_chan *chan,
 			     enum rtw89_phy_idx phy_idx)
 {
-	u8 pri_ch = chan->primary_channel;
+	u8 pri_ch = chan->pri_ch_idx;
 	bool mask_5m_low;
 	bool mask_5m_en;
 
 	switch (chan->band_width) {
 	case RTW89_CHANNEL_WIDTH_40:
 		mask_5m_en = true;
-		mask_5m_low = pri_ch == 2;
+		mask_5m_low = pri_ch == RTW89_SC_20_LOWER;
 		break;
 	case RTW89_CHANNEL_WIDTH_80:
-		mask_5m_en = ((pri_ch == 3) || (pri_ch == 4));
-		mask_5m_low = pri_ch == 4;
+		mask_5m_en = pri_ch == RTW89_SC_20_UPMOST ||
+			     pri_ch == RTW89_SC_20_LOWEST;
+		mask_5m_low = pri_ch == RTW89_SC_20_LOWEST;
 		break;
 	default:
 		mask_5m_en = false;


