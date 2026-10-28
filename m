Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210062;
	b=5VOqcbKEXfNX9mWHR8yKpIAs0NnXl1OKIz02r0R3xF6ME+F0XBAnULYrnkpLo5cpls7y
	 5rukf+BK7oxJyFK6VO2Od9pO14CLio42yfF80rt6JLj3DXvWe5UKv/CfQhUHdu7jqfhwG
	 nAiAoO7RVSl7Xtak7QIebvqHNv06bm0SbWdMp6pk8gopJ76a2cBk5Dwavq9kROEmZzCS3
	 gxwLb31IhE2YFpPXRpEZgxFVspvouk5felwxY+vG95ocvn0lH2ixSJelXm4cM9hs0RKBU
	 +9KmneMc5ENLh2saLfEcqh6MyQdKUdUdMcklNA1cx+eh5FyN6pagkTlUMF9QO5dx/Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ku17ubIoFioPm3RpnKhwGt/zpQUY918FYQyxktfet88=;
	b=zq+N1S61WW6ogicGFxLmYtoogz+wybhifkHpZaiinp0sP3v55GIiV4rWgRNgSdVVZdvQ
	 s+hKYm3PtYO+vEDF+odaAKaf3kROtnRhopBn+54IT+EGhQxxPXko+jEvI264plXIfYTyJ
	 hP8OyWiFWVJkhe5ACHyx1XUKlwAVzjYRW2K1Bo25+TWs9Kpl9jNjCq7Y+vmkNdwCSMeKp
	 WkcHLlveOtzmZ7SXUOBgEUd5JUgcT99ZPXtAQOfZBPNDHn/9hDfDeojTuQs9+m0lVqk5N
	 I5s4rZ5M5kcylcbbzbc86k8C+jsEbquAqPCz2oWahUIR5dBhwmp/WqGeLWaROHsRamg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fxg4vLC9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48730606A31C;
	Wed, 28 Oct 2026 17:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fxg4vLC9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6848D1F01825;
	Wed, 28 Oct 2026 17:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210061;
	bh=Ku17ubIoFioPm3RpnKhwGt/zpQUY918FYQyxktfet88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fxg4vLC9BpE4/EzYsizsv6fvEXWbf+1EkilaqqIydBMKZHqoZd5EAfrDyj5Io5Lm0
	 iWbesJVZ+GqIwGU1qrJnQpygzRBqWc77YTTv6IiSTtau9XxpEcY6bPO3eDgSgqAiBX
	 cpMufa1gH/zK+q9KzTOm1Sy12VYma8/oVudnpxFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heyang Tan <thy15333007817@163.com>,
	Christian Lamparter <chunkeey@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 064/168] wifi: p54: validate firmware record lengths
Date: Wed, 28 Oct 2026 18:00:00 +0100
Message-ID: <20261028165944.597430805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heyang Tan <thy15333007817@163.com>

commit db7b86bd97b380ece8fa39cfdd7502a9fd35e56f upstream.

The p54 firmware parser accesses component ID and component version
records without checking that their lengths cover the fields being read.
A malformed record can therefore make the parser read past the record.

Validate the component ID and component version record lengths before
accessing their data. The descriptor record is also checked against the
shortest descriptor length found in the supported firmware images.

Reject descriptor values that underflow the RX offset or produce an empty
RX range before updating the driver state.

Assisted-by: LLM Codex
Signed-off-by: Heyang Tan <thy15333007817@163.com>
Tested-by: Christian Lamparter <chunkeey@gmail.com>
Link: https://patch.msgid.link/20260918083349.891-1-thy15333007817@163.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intersil/p54/fwio.c |   42 +++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/intersil/p54/fwio.c
+++ b/drivers/net/wireless/intersil/p54/fwio.c
@@ -52,6 +52,13 @@ int p54_parse_firmware(struct ieee80211_
 		u32 code = le32_to_cpu(bootrec->code);
 		switch (code) {
 		case BR_CODE_COMPONENT_ID:
+			if (len < sizeof(struct bootrec_comp_id) /
+				sizeof(*bootrec->data)) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware component ID is too short\n");
+				return -EINVAL;
+			}
+
 			priv->fw_interface = be32_to_cpup((__be32 *)
 					     bootrec->data);
 			switch (priv->fw_interface) {
@@ -72,16 +79,41 @@ int p54_parse_firmware(struct ieee80211_
 			}
 			break;
 		case BR_CODE_COMPONENT_VERSION:
+			if (len < DIV_ROUND_UP(sizeof(struct bootrec_comp_ver),
+					       sizeof(*bootrec->data))) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware component version is too short\n");
+				return -EINVAL;
+			}
+
 			/* 24 bytes should be enough for all firmwares */
-			if (strnlen((unsigned char *) bootrec->data, 24) < 24)
-				fw_version = (unsigned char *) bootrec->data;
+			if (strnlen((unsigned char *)bootrec->data,
+				    sizeof(struct bootrec_comp_ver)) <
+				    sizeof(struct bootrec_comp_ver))
+				fw_version = (unsigned char *)bootrec->data;
 			break;
 		case BR_CODE_DESCR: {
 			struct bootrec_desc *desc =
 				(struct bootrec_desc *)bootrec->data;
-			priv->rx_start = le32_to_cpu(desc->rx_start);
-			/* FIXME add sanity checking */
-			priv->rx_end = le32_to_cpu(desc->rx_end) - 0x3500;
+			u32 rx_start, rx_end;
+
+			/* 0xa is the shortest descriptor in supported firmware. */
+			if (len < 0xa) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware descriptor is too short\n");
+				return -EINVAL;
+			}
+
+			rx_start = le32_to_cpu(desc->rx_start);
+			rx_end = le32_to_cpu(desc->rx_end);
+			if (rx_end < 0x3500 || rx_end - 0x3500 <= rx_start) {
+				wiphy_err(priv->hw->wiphy,
+					  "firmware descriptor has invalid RX range\n");
+				return -EINVAL;
+			}
+
+			priv->rx_start = rx_start;
+			priv->rx_end = rx_end - 0x3500;
 			priv->headroom = desc->headroom;
 			priv->tailroom = desc->tailroom;
 			priv->privacy_caps = desc->privacy_caps;


