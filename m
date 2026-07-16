Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F55400972;
	Thu, 16 Jul 2026 13:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209404; cv=none; b=mMUqBdlWiXYeZQ8vAcAasOWcYJEHdvLLilytTA+Qb0JPrlrkVr43iScw65AS875ccYSGje5p1FUXLykzAXl13Cc3+cdhRBMOS5FZXbzYzGNUekac/rQgC1InkHqDBKdZn9JxE3+AD+fJY9rrHbM7zlEPO2jTmFVpm5mrhw0ZkfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209404; c=relaxed/simple;
	bh=raQAIAXs22vp7D6u5GBsChOA+ZtovtXHZoE81gRl+C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gyr53e+SgEihJJl92z0nLahBgRknJHuo3eah3r4xse6uMYnxt6NpvHTgRvloq1p/lN7rFyOiny7RI+6LIIXDFOKvSTQ9xxegjetk/aw4gQDo5k8HtinQLhN+qQpbYVvqVQRADRb+DQTeduR9Psx+FyWW4z/c7eOXnooRTFkwZNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPbDRmRE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPbDRmRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3911F000E9;
	Thu, 16 Jul 2026 13:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209403;
	bh=Zw0Pi3bT1DNW3ZF+YhL2KjJoIk3rCCsZcU6z7WAuAuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPbDRmRE4QqpoTCTZ3ZBMvIY3PRKGNETq0D3l0qM4TWk9azx03++7aEhVjwgl29nm
	 2JPSRCGkx00/2ipWp0folMv/W0e07HGbST4BkNtuB0SdQT/I12LX63ILF6HQ8peN0w
	 uhJwqn9vMe/Exdj3f/tyG+YIaCbyYDmWTf8zqMCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexandru Hossu <hossu.alexandru@gmail.com>
Subject: [PATCH 7.1 165/518] staging: rtl8723bs: fix OOB reads in is_ap_in_tkip() IE loop
Date: Thu, 16 Jul 2026 15:27:13 +0200
Message-ID: <20260716133051.451505932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Alexandru Hossu <hossu.alexandru@gmail.com>

commit 3bf39f711ff27c64be8680a8938bcc5001982e81 upstream.

The loop in is_ap_in_tkip() iterates over IEs without verifying that
enough bytes remain before dereferencing the IE header or its payload:

- pIE->element_id and pIE->length are read without checking that
  i + sizeof(*pIE) <= ie_length, so a truncated IE at the end of the
  buffer causes an OOB read.

- For WLAN_EID_VENDOR_SPECIFIC the code compares pIE->data + 12,
  which requires pIE->length >= 16.  For WLAN_EID_RSN it compares
  pIE->data + 8, requiring pIE->length >= 12.  Neither requirement
  is checked.

Add the missing IE header and payload bounds checks and guard each
data access with an explicit pIE->length minimum, matching the
pattern established in update_beacon_info().

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
Link: https://patch.msgid.link/20260522004531.1038924-7-hossu.alexandru@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
@@ -1334,15 +1334,23 @@ unsigned int is_ap_in_tkip(struct adapte
 		for (i = sizeof(struct ndis_802_11_fix_ie); i < pmlmeinfo->network.ie_length;) {
 			pIE = (struct ndis_80211_var_ie *)(pmlmeinfo->network.ies + i);
 
+			if (i + sizeof(*pIE) > pmlmeinfo->network.ie_length)
+				break;
+			if (i + sizeof(*pIE) + pIE->length > pmlmeinfo->network.ie_length)
+				break;
+
 			switch (pIE->element_id) {
 			case WLAN_EID_VENDOR_SPECIFIC:
-				if ((!memcmp(pIE->data, RTW_WPA_OUI, 4)) && (!memcmp((pIE->data + 12), WPA_TKIP_CIPHER, 4)))
+				if (pIE->length >= 16 &&
+				    !memcmp(pIE->data, RTW_WPA_OUI, 4) &&
+				    !memcmp((pIE->data + 12), WPA_TKIP_CIPHER, 4))
 					return true;
 
 				break;
 
 			case WLAN_EID_RSN:
-				if (!memcmp((pIE->data + 8), RSN_TKIP_CIPHER, 4))
+				if (pIE->length >= 12 &&
+				    !memcmp((pIE->data + 8), RSN_TKIP_CIPHER, 4))
 					return true;
 				break;
 
@@ -1350,7 +1358,7 @@ unsigned int is_ap_in_tkip(struct adapte
 				break;
 			}
 
-			i += (pIE->length + 2);
+			i += sizeof(*pIE) + pIE->length;
 		}
 
 		return false;


