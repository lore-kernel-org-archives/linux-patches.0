Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915F12DA76C;
	Tue, 21 Jul 2026 20:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665030; cv=none; b=TfUkCLYsX95QLjYGa55kd6/sePubiKZhbDN92dTl3KR73Iz/DKFQ3PEvemw/SKHW0eKQGv31KWTQmKTMdRc5g0lrI5zuDc//PXYK2iXlIPL/kDvEFNgtN46KJBO0QyT1vhjEtcHzs+uUPRQUfYbv2VicQXDKVzvm6iDf5wEPBMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665030; c=relaxed/simple;
	bh=uBtrqU7z6AsdErDUf9K8uc5WNHZboOAZhzPFVDkgg+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+Ev752Xm/XB4IEs/Un8vKCvsXBewb8zvjmLZOiScWyist9VzMmQN+FIPKqiEq3oThNORxVV955dBBEHxqgVJySSUDvsvbBCZFJmMwL9X9oiE/FeUyYSyOLp3rnx1x1fw2Ii/oSpDDQdn8WGOvjKYwd2uJcrF1Ov1uJAARkz9JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwTjME0s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwTjME0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F164A1F000E9;
	Tue, 21 Jul 2026 20:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665029;
	bh=agmvivkHxjdv7cB9HC9aBDjxthFmWKh1wzpvj8biwJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwTjME0sZBh0m96mtoMpcI1TOSMEoT/b2w0K+sak4eARJB0t+Ck2aP7+lOzS19tFG
	 wQYz9+MhTtUngfvBCuDxp8fEQBuIK6xJe8I5373J1C0H5RWFwNlorhoPam7h3NE3wG
	 44lXetXUGofdwZp3UrUnsQqWgOVehvh3sexVjne0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexandru Hossu <hossu.alexandru@gmail.com>
Subject: [PATCH 6.6 0151/1266] staging: rtl8723bs: fix OOB reads in is_ap_in_tkip() IE loop
Date: Tue, 21 Jul 2026 17:09:48 +0200
Message-ID: <20260721152445.186094810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1377,15 +1377,23 @@ unsigned int is_ap_in_tkip(struct adapte
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
 
@@ -1393,7 +1401,7 @@ unsigned int is_ap_in_tkip(struct adapte
 				break;
 			}
 
-			i += (pIE->length + 2);
+			i += sizeof(*pIE) + pIE->length;
 		}
 
 		return false;


