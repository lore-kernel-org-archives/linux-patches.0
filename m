Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4F1143C67;
	Thu, 13 Jun 2024 11:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279390; cv=none; b=gqfdw0pbfjT2Neh4Ecer+u0TihDFbFFzO7hNDTtw53vSZ7OMjxbHWChoUIu7bfGU6N8tWq0xfNCASyaeSDQMerHHyc4OeDvjERShCyCJGI++Zt6EQDKZ1CmgZJ3/uYiAshnqxsZg2HHBaOOgQxmHFR1q/9QkLvE2nass74pTdGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279390; c=relaxed/simple;
	bh=DwnMQR+/Tfg2eW6lL7DVXZkglm9ELKsnbaeRDlsYnL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnHnU4NtXUOjMQ/tILkdV8IvkYQUs2YEk0m8o596Dt87YvELXUuVtcfxYbaGe5H4RH02+0uBpcd7SN189Bym/NdavMI+1dZ8zAb3BnFnliKY1Dv6UluKROqyGgRQDNDwmFeiAMRGXJObhBWB5/9Dw1LcjtXLZmtnByzp2UlmUqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B99r9itF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B99r9itF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5BCC2BBFC;
	Thu, 13 Jun 2024 11:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279390;
	bh=DwnMQR+/Tfg2eW6lL7DVXZkglm9ELKsnbaeRDlsYnL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B99r9itFOHIUSBFlSgGu8JZQArF6NMW8Y/476yEhgm5pBq24kbq4SwrD0bGNLuQpw
	 IprkjlMs27fwqkmRxt7rjXb1+9D2Ggu8R6/ruD5ZfoObjSYNTo4uKFeBvQMApeTY6t
	 bJL3ytMthHfw3EKj6pkI+FbF5MOkFothvzHYAF1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.9 029/157] wifi: rtlwifi: rtl8192de: Fix low speed with WPA3-SAE
Date: Thu, 13 Jun 2024 13:32:34 +0200
Message-ID: <20240613113228.543639323@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -413,7 +413,8 @@ bool rtl92de_rx_query_desc(struct ieee80
 	stats->icv = (u16)get_rx_desc_icv(pdesc);
 	stats->crc = (u16)get_rx_desc_crc32(pdesc);
 	stats->hwerror = (stats->crc | stats->icv);
-	stats->decrypted = !get_rx_desc_swdec(pdesc);
+	stats->decrypted = !get_rx_desc_swdec(pdesc) &&
+			   get_rx_desc_enc_type(pdesc) != RX_DESC_ENC_NONE;
 	stats->rate = (u8)get_rx_desc_rxmcs(pdesc);
 	stats->shortpreamble = (u16)get_rx_desc_splcp(pdesc);
 	stats->isampdu = (bool)(get_rx_desc_paggr(pdesc) == 1);
@@ -426,8 +427,6 @@ bool rtl92de_rx_query_desc(struct ieee80
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


