Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25AE3B9950;
	Tue, 21 Jul 2026 21:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668265; cv=none; b=lm3/jScyDBues1eNI/y55YkVjbUXlbMS/gfRuslCTYcbrF3pk1XGfiDqBDIWUMdHI65AOGe+a1PcU77Ro9XEZGZKTYbNm3jHt3u5/rjVjp6sQiDfg95+b3+p0HhxfSYpcnFI6fb3b/MvaYAjBGczQm1A9JBb/I8Ta/z8fa51QWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668265; c=relaxed/simple;
	bh=jC5zyxPny8YCccgGuzBENVmEwidtGog0qr5VmR+9QEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hk7YhZwB3h6eC547bfAaA6+IUXLLZKTLTX9wXhXfyzPb9kEjONzwYl3jtyAnDpDNKm1glfm6NB910cWm7epr+apG1f9w55THgELdyb43xZ+SLPTr72NltDSr3sCWoXp9vDBmQj7bUj5p2L+fnzXcmuW1yKrh0+g4d4B53KU2SXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZuQ3B0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZuQ3B0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB7F1F000E9;
	Tue, 21 Jul 2026 21:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668263;
	bh=LmlxxAb+4Er6C6SkQ6ZefWI/cAQCszsAisQyL0bEd08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZuQ3B0xRuVZK1kWti+kYA8K4NgqOn3KGSIXDNaXwCTctVEXjCTm8U9/S/GxKTY9M
	 leDSj6UXEOdBfN4M0/uPNE7ZA+S9qWXA3kEChfZYhVHoGcaHvHtTf8Ajf5f641JQ/0
	 cg0mpadzeS35w4TwIHGjJeXtQz8NlDxHrkQbzf38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luka Gejak <luka.gejak@linux.dev>,
	Alexandru Hossu <hossu.alexandru@gmail.com>
Subject: [PATCH 6.1 0111/1067] staging: rtl8723bs: fix OOB read in update_beacon_info() IE loop
Date: Tue, 21 Jul 2026 17:11:52 +0200
Message-ID: <20260721152427.073235022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru Hossu <hossu.alexandru@gmail.com>

commit ed51de4a86e173c3b0ef78e039c2e49e08b11f16 upstream.

The IE parsing loop in update_beacon_info() advances by
(pIE->length + 2) each iteration but only guards on i < len.
When a malicious AP sends a Beacon whose last IE has only one byte
remaining in the frame (the element_id byte lands at len-1), the loop
reads pIE->length from one byte past the allocated receive buffer.

Additionally, even when the header bytes are in bounds, pIE->length
itself can extend the data window beyond len, passing a truncated IE
to the handler functions.

Add two guards at the top of the loop body:
  1. Break if fewer than sizeof(*pIE) bytes remain (can't read header).
  2. Break if the IE's declared data extends past len.

Also replace i += (pIE->length + 2) with i += sizeof(*pIE) + pIE->length
for consistency with the sizeof(*pIE) guards added above.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
Link: https://patch.msgid.link/20260522004531.1038924-2-hossu.alexandru@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
@@ -1336,7 +1336,11 @@ void update_beacon_info(struct adapter *
 	len = pkt_len - (_BEACON_IE_OFFSET_ + WLAN_HDR_A3_LEN);
 
 	for (i = 0; i < len;) {
+		if (i + sizeof(*pIE) > len)
+			break;
 		pIE = (struct ndis_80211_var_ie *)(pframe + (_BEACON_IE_OFFSET_ + WLAN_HDR_A3_LEN) + i);
+		if (i + sizeof(*pIE) + pIE->length > len)
+			break;
 
 		switch (pIE->element_id) {
 		case WLAN_EID_VENDOR_SPECIFIC:
@@ -1361,7 +1365,7 @@ void update_beacon_info(struct adapter *
 			break;
 		}
 
-		i += (pIE->length + 2);
+		i += sizeof(*pIE) + pIE->length;
 	}
 }
 


