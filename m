Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67939145FFD;
	Thu, 13 Jun 2024 11:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279384; cv=none; b=jOQzDhoCLMtXBxk26Wjm8H9XlcaMolVOYRpUffPmDqEydgi6kDAHleyCwzgyQeOJxY1cEp0QFJl3XO4IMUSUGZeLZztitqtGAM2+lLTIcmyJDcfnTLhkf5/+IeiFc/vHt2FNDG09PJLuJDqEhCbWIhoRbAnYcNsIRRt6Wpz45fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279384; c=relaxed/simple;
	bh=lh5GT9dKMoMqvURpncxA7wzhVA6LiX6IKOCbgcR1lRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYSoRMZmGwTThaX7grCOA2N6malesCI32Hi3B5bMvt6sEXcx2BSmTMpGH9WnH3tolWTiFb5H6dC9RnPhXL9qALdWEyR6uDsg1DBqDwTlub1kTyhei028pdGiTrRUdpszoFXZ1cYYqNMVxfyGrzOjJLxLzq7MitYC2DtXT+5S1AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTvwJ6AB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTvwJ6AB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E260EC2BBFC;
	Thu, 13 Jun 2024 11:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279384;
	bh=lh5GT9dKMoMqvURpncxA7wzhVA6LiX6IKOCbgcR1lRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTvwJ6ABqvV4+ysPklZFk0CAoFlJuIPZdjqR95V1SQMNCsuZ9J9d48w9v1nkPu6ej
	 O3x4HV9oaWo5NPyIU/y8Z2KX2uRfxP+XjT4J8OYOFyk0KOhltBovRdNc1PCJzewt3z
	 jccTuD/5RyI/PTHMt4/1bBz/B7NM+uHRfXj45hTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaistra <martin.kaistra@linutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.9 027/157] wifi: rtl8xxxu: enable MFP support with security flag of RX descriptor
Date: Thu, 13 Jun 2024 13:32:32 +0200
Message-ID: <20240613113228.466419749@linuxfoundation.org>
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

From: Martin Kaistra <martin.kaistra@linutronix.de>

commit cbfbb4ddbc8503478e0a138f9a31f61686cc5f11 upstream.

In order to connect to networks which require 802.11w, add the
MFP_CAPABLE flag and let mac80211 do the actual crypto in software.

When a robust management frame is received, rx_dec->swdec is not set,
even though the HW did not decrypt it. Extend the check and don't set
RX_FLAG_DECRYPTED for these frames in order to use SW decryption.

Use the security flag in the RX descriptor for this purpose, like it is
done in the rtw88 driver.

Cc: stable@vger.kernel.org
Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/20240418071813.1883174-3-martin.kaistra@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h      |    9 +++++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c |    7 +++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -122,6 +122,15 @@ enum rtl8xxxu_rx_type {
 	RX_TYPE_ERROR = -1
 };
 
+enum rtl8xxxu_rx_desc_enc {
+	RX_DESC_ENC_NONE	= 0,
+	RX_DESC_ENC_WEP40	= 1,
+	RX_DESC_ENC_TKIP_WO_MIC	= 2,
+	RX_DESC_ENC_TKIP_MIC	= 3,
+	RX_DESC_ENC_AES		= 4,
+	RX_DESC_ENC_WEP104	= 5,
+};
+
 struct rtl8xxxu_rxdesc16 {
 #ifdef __LITTLE_ENDIAN
 	u32 pktlen:14;
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6468,7 +6468,8 @@ int rtl8xxxu_parse_rxdesc16(struct rtl8x
 			rx_status->mactime = rx_desc->tsfl;
 			rx_status->flag |= RX_FLAG_MACTIME_START;
 
-			if (!rx_desc->swdec)
+			if (!rx_desc->swdec &&
+			    rx_desc->security != RX_DESC_ENC_NONE)
 				rx_status->flag |= RX_FLAG_DECRYPTED;
 			if (rx_desc->crc32)
 				rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
@@ -6573,7 +6574,8 @@ int rtl8xxxu_parse_rxdesc24(struct rtl8x
 			rx_status->mactime = rx_desc->tsfl;
 			rx_status->flag |= RX_FLAG_MACTIME_START;
 
-			if (!rx_desc->swdec)
+			if (!rx_desc->swdec &&
+			    rx_desc->security != RX_DESC_ENC_NONE)
 				rx_status->flag |= RX_FLAG_DECRYPTED;
 			if (rx_desc->crc32)
 				rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
@@ -7993,6 +7995,7 @@ static int rtl8xxxu_probe(struct usb_int
 	ieee80211_hw_set(hw, HAS_RATE_CONTROL);
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
 
 	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 


