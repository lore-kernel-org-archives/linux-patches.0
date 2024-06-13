Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9681A1C32;
	Thu, 13 Jun 2024 12:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282693; cv=none; b=hRU6m4IwM2L9VYuwQ68yrsxxJOs2/aSnC2sjWr4p/1r4yfOjXsU7BzeGXx6OKx0HOkGYvd03a5uwO8J+jVneTa1nr7aPM8AQilDjyCTN0Smth3Da614i4Z3Xb74H4LYqZ7b/k+84FF+iHESPb3MGQbOqloocUbMUaxoLjzM5Ngo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282693; c=relaxed/simple;
	bh=2Bfe2X06KL/Rjr5tQh7WOez8JXfcKuSy/sjTG6r5rXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AV9jUq52xYurgvA6/sumfxcQsyQu6oSDrT9dz+HLlBqfMFPHCwTf1Mintk6QCDcTwsvIWooxNTQJ3ccJxu2SIAcC2dyO7FukfRnNMM/ey3aV166m5L9xZA9/gtY8RahPYSz5MIyuMsvnjdqcQRWSAGBXZsKJWIqO40AB8DjFm/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRTtC8jD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRTtC8jD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04A7C4AF1A;
	Thu, 13 Jun 2024 12:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282693;
	bh=2Bfe2X06KL/Rjr5tQh7WOez8JXfcKuSy/sjTG6r5rXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRTtC8jDpN8NR7IkU1Ck3jE0tdNKF5ufaXLZSCFFyP6eA9Z+Jk31EjCrKi+rnZR0n
	 WfDkilZl74NMH2kL2MHrAXX63a0raNB529+YObNBfbbdnzR73TTPP6tTKhMPYTCXjR
	 kSI5hOrfbn3COJgvcF1Quv8Z/Vp1zuOabNXcSaks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 5.15 364/402] wifi: rtlwifi: rtl8192de: Fix low speed with WPA3-SAE
Date: Thu, 13 Jun 2024 13:35:21 +0200
Message-ID: <20240613113316.336606045@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit a7c0f48410f546772ac94a0f7b7291a15c4fc173 upstream.

Some (all?) management frames are incorrectly reported to mac80211 as
decrypted when actually the hardware did not decrypt them. This results
in speeds 3-5 times lower than expected, 20-30 Mbps instead of 100
Mbps.

Fix this by checking the encryption type field of the RX descriptor.
rtw88 does the same thing.

This fix was tested only with rtl8192du, which will use the same code.

Cc: stable@vger.kernel.org
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/4d600435-f0ea-46b0-bdb4-e60f173da8dd@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c |    5 ++---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
@@ -414,7 +414,8 @@ bool rtl92de_rx_query_desc(struct ieee80
 	stats->icv = (u16)get_rx_desc_icv(pdesc);
 	stats->crc = (u16)get_rx_desc_crc32(pdesc);
 	stats->hwerror = (stats->crc | stats->icv);
-	stats->decrypted = !get_rx_desc_swdec(pdesc);
+	stats->decrypted = !get_rx_desc_swdec(pdesc) &&
+			   get_rx_desc_enc_type(pdesc) != RX_DESC_ENC_NONE;
 	stats->rate = (u8)get_rx_desc_rxmcs(pdesc);
 	stats->shortpreamble = (u16)get_rx_desc_splcp(pdesc);
 	stats->isampdu = (bool)(get_rx_desc_paggr(pdesc) == 1);
@@ -427,8 +428,6 @@ bool rtl92de_rx_query_desc(struct ieee80
 	rx_status->band = hw->conf.chandef.chan->band;
 	if (get_rx_desc_crc32(pdesc))
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
-	if (!get_rx_desc_swdec(pdesc))
-		rx_status->flag |= RX_FLAG_DECRYPTED;
 	if (get_rx_desc_bw(pdesc))
 		rx_status->bw = RATE_INFO_BW_40;
 	if (get_rx_desc_rxht(pdesc))
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h
@@ -14,6 +14,15 @@
 #define USB_HWDESC_HEADER_LEN			32
 #define CRCLENGTH				4
 
+enum rtl92d_rx_desc_enc {
+	RX_DESC_ENC_NONE	= 0,
+	RX_DESC_ENC_WEP40	= 1,
+	RX_DESC_ENC_TKIP_WO_MIC	= 2,
+	RX_DESC_ENC_TKIP_MIC	= 3,
+	RX_DESC_ENC_AES		= 4,
+	RX_DESC_ENC_WEP104	= 5,
+};
+
 /* macros to read/write various fields in RX or TX descriptors */
 
 static inline void set_tx_desc_pkt_size(__le32 *__pdesc, u32 __val)
@@ -246,6 +255,11 @@ static inline u32 get_rx_desc_drv_info_s
 	return le32_get_bits(*__pdesc, GENMASK(19, 16));
 }
 
+static inline u32 get_rx_desc_enc_type(__le32 *__pdesc)
+{
+	return le32_get_bits(*__pdesc, GENMASK(22, 20));
+}
+
 static inline u32 get_rx_desc_shift(__le32 *__pdesc)
 {
 	return le32_get_bits(*__pdesc, GENMASK(25, 24));


