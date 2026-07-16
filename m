Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1A4424668;
	Thu, 16 Jul 2026 14:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211901; cv=none; b=JCcV3wETlWiWHgilwd6Rhd8zqXM3q0nHojTS2SB0eMfwhHHQd8Th9cmxmMiTNlACCVV0f42iEvhjV2019dhG/LDUI1Fb3ee4Vpl8NbpivABDRPZQZuys+67UGjk5SEbTW+Z2iViVNexo53Yh4MUxcYXB7jg4WyHhW2dBRlcpVCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211901; c=relaxed/simple;
	bh=n9kM1eRsC/vQD76mqo3XeI8Ut3JaFtBLEJZ9Q2J3Vbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Px6QHP8odoVlgmTJfpqlCjH7vns80iP66l2Z4yQknjRmSxh/JX38tpZgKUm2dtuPXvN6GBXwkXt0S2XVx8/LHw2oK3M6n7mRup4UIwbaQYQN9Ea94SunQ071leJwrwp7vpKo3RJ93SQZ75eH377r9g0jofuKas8EoJK1TgbxzEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WiCQTbsm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WiCQTbsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF091F00A3D;
	Thu, 16 Jul 2026 14:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211900;
	bh=fZy2AiH4LAPQKaAdH0TtNJPdS5aTj3FGHQZVP9HMO8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WiCQTbsmsP9rpDedkYTjQzAE0DXM1vxX47yE6dJ+ibYq8bEzfRZw+fzPZLbJ9WojK
	 sFJe8TnixKRq+hH3TSndjp4KVPCM+dQKWHl/YrhD8LcwNFMOf4s8PKIJFU1+DIq55S
	 WvQkkthcVE8uv1TvWHvaK62y9oD+H0BZ+qoCWgI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luka Gejak <luka.gejak@linux.dev>,
	Alexandru Hossu <hossu.alexandru@gmail.com>
Subject: [PATCH 6.12 123/349] staging: rtl8723bs: fix OOB read in update_beacon_info() IE loop
Date: Thu, 16 Jul 2026 15:30:57 +0200
Message-ID: <20260716133036.110754166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1331,7 +1331,11 @@ void update_beacon_info(struct adapter *
 	len = pkt_len - (_BEACON_IE_OFFSET_ + WLAN_HDR_A3_LEN);
 
 	for (i = 0; i < len;) {
+		if (i + sizeof(*pIE) > len)
+			break;
 		pIE = (struct ndis_80211_var_ie *)(pframe + (_BEACON_IE_OFFSET_ + WLAN_HDR_A3_LEN) + i);
+		if (i + sizeof(*pIE) + pIE->length > len)
+			break;
 
 		switch (pIE->element_id) {
 		case WLAN_EID_VENDOR_SPECIFIC:
@@ -1356,7 +1360,7 @@ void update_beacon_info(struct adapter *
 			break;
 		}
 
-		i += (pIE->length + 2);
+		i += sizeof(*pIE) + pIE->length;
 	}
 }
 


