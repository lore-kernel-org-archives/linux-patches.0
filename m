Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696B9433E87;
	Thu,  2 Jul 2026 17:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011694; cv=none; b=bEqJW7z+42XGJ6b54kzMeu2itmf8A+B+PjNP8Fy3yCwML3TQ8hnSDuq5duxqtSEARZoAoEBI2gKCA6xtGelHCvSuXvyak25Sqway5SC0bMSWiUZNJewvBSV0MYUtVPyw+5dMX88G0yrVxThmOWQGOMfMUo8XGIW3KaEJBGMULmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011694; c=relaxed/simple;
	bh=sCVNd6naJLCUwzsV8NCsy1y6Cn2NN2lCc9rdXJC8xxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8v9C0hVL0xx3c/cpRqgVtrKCvnXfI+x+SfcMqt48e6rbULreOVeIidTDga+2rWkXkfU8Qlat/Fy/WIlcZNeGT9IgT12w2E75Qi5ejmFRIuEmStQb+wca5Y+wdPAR5EN9h4QNcW6jOv+Rc9BJn3TWpPqQLjc4ox+dE0PNXig2Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzUs4U6v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzUs4U6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D103E1F000E9;
	Thu,  2 Jul 2026 17:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011693;
	bh=nYJTUtimY2sK9QIPwFICgDpowM2iK69n6S6vQVWMnAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WzUs4U6v4H6ZuqgLEq9LYo1XMalGUftnBlpsyY96CRUQIBfA3mtRkcBI4tUeGnHtq
	 L8NbWbehAnql7zinTB6j563K3RvFmRqXbqowxRLQ1OqJ+/mePtuuFw58mD2X1n6zbJ
	 qxnZ/iNKhniXzqWu1992ie3lXmKCMZ9d2JlLugM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 7.1 053/120] wifi: rtlwifi: rtl8821ae: Fix C2H bit location in RX descriptor
Date: Thu,  2 Jul 2026 18:20:49 +0200
Message-ID: <20260702155114.063262362@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit 83d38df6929118c3f996b9e3351c2d5014073d87 upstream.

Bit 28 of double word 2 in the RX descriptor indicates if the packet is
a normal 802.11 frame, or a message from the wifi firmware to the
driver (Card 2 Host).

Commit f5678bfe1cdc ("rtlwifi: rtl8821ae: Replace local bit manipulation
macros") mistakenly made the driver look for this bit in double word 1,
causing packet loss and Bluetooth coexistence problems.

Fixes: f5678bfe1cdc ("rtlwifi: rtl8821ae: Replace local bit manipulation macros")
Cc: <stable@vger.kernel.org>
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/04da7398-cedb-425a-a810-5772ab10139d@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h
@@ -291,7 +291,7 @@ static inline int get_rx_desc_paggr(__le
 
 static inline int get_rx_status_desc_rpt_sel(__le32 *__pdesc)
 {
-	return le32_get_bits(*(__pdesc + 1), BIT(28));
+	return le32_get_bits(*(__pdesc + 2), BIT(28));
 }
 
 static inline int get_rx_desc_rxmcs(__le32 *__pdesc)


