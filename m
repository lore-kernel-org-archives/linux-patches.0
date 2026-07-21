Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FBF43B3DA;
	Tue, 21 Jul 2026 21:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668268; cv=none; b=G1mH09B6dLEEVP/5g3+SFcTVSKy4s+Ahnrzpxc3J5fIwUI9lLocUjrxd0HRssD5iX7itMwj9TXwqSnlCsEbd9Py5z1N5lDmOXmVQTIp3jWUQBdSB0UgyetVj++CqNadsBjsuYz03uS1AsMNG4qSPWtcovkMPvkT9mwx9GFO9Jvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668268; c=relaxed/simple;
	bh=AANQhzn1Wl2aL+9BjhUdsEE9569xMcmlneVeaNsVQkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNiK+iAjEDZqx0NbvaLAarrjc17LuE2o7KldD7koI4xbQlNB6Scp60SS1NK+EM5OEPiRBLuPZ5QIQtS+zXPddxfE49ZyrbePmS5W55lJvCLoXjPA/AkmsU5gYJ6qdZmCn/4pfU7rFdldbEIjZMcjF1pigeZT0wOijKwtBuIc3bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kaOkNpUb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaOkNpUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DEE1F000E9;
	Tue, 21 Jul 2026 21:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668266;
	bh=RR7RZu/y7Asxdzu5nj1tkexWrjfz9yp6llTkyevPwHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kaOkNpUbQGUE7jA1ANl+vdnmPXKSfLkq5A2VTVq64UncwezxS424y5Duvv6ibA4qD
	 7ZXgL1/bx90uRHoK2cyLA3eZu99jCBqCIfSDdakGLp4cLsByfwm8jV+yC3b1+tlL9O
	 l7kjXLGOcgVpC2cawfrtNijiFrMdjvmt1glU3QX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luka Gejak <luka.gejak@linux.dev>,
	Alexandru Hossu <hossu.alexandru@gmail.com>
Subject: [PATCH 6.1 0112/1067] staging: rtl8723bs: fix OOB reads in IE loops in issue_assocreq() and join_cmd_hdl()
Date: Tue, 21 Jul 2026 17:11:53 +0200
Message-ID: <20260721152427.095344706@linuxfoundation.org>
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

commit ef61d628dfad38fead1fd2e08979ae9126d011d5 upstream.

Two IE parsing loops are missing the header bounds checks before they
dereference pIE->length:

 - issue_assocreq() walks pmlmeinfo->network.ies to build the
   association request. If the stored IE data ends with only an
   element_id byte and no length byte, pIE->length is read one byte
   past the end of the buffer.

 - join_cmd_hdl() walks pnetwork->ies during station join and has
   the same problem under the same conditions.

Both buffers are filled from AP beacon and probe-response frames, so a
malicious AP that sends a truncated final IE can trigger the issue.

Apply the two-guard pattern established in update_beacon_info():
  1. Break if fewer than sizeof(*pIE) bytes remain.
  2. Break if the IE's declared data extends past the buffer end.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
Link: https://patch.msgid.link/20260522004531.1038924-3-hossu.alexandru@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -2968,7 +2968,11 @@ void issue_assocreq(struct adapter *pada
 
 	/* vendor specific IE, such as WPA, WMM, WPS */
 	for (i = sizeof(struct ndis_802_11_fix_ie); i < pmlmeinfo->network.ie_length;) {
+		if (i + sizeof(*pIE) > pmlmeinfo->network.ie_length)
+			break;
 		pIE = (struct ndis_80211_var_ie *)(pmlmeinfo->network.ies + i);
+		if (i + sizeof(*pIE) + pIE->length > pmlmeinfo->network.ie_length)
+			break;
 
 		switch (pIE->element_id) {
 		case WLAN_EID_VENDOR_SPECIFIC:
@@ -5373,7 +5377,11 @@ u8 join_cmd_hdl(struct adapter *padapter
 
 	/* sizeof(struct ndis_802_11_fix_ie) */
 	for (i = _FIXED_IE_LENGTH_; i < pnetwork->ie_length;) {
+		if (i + sizeof(*pIE) > pnetwork->ie_length)
+			break;
 		pIE = (struct ndis_80211_var_ie *)(pnetwork->ies + i);
+		if (i + sizeof(*pIE) + pIE->length > pnetwork->ie_length)
+			break;
 
 		switch (pIE->element_id) {
 		case WLAN_EID_VENDOR_SPECIFIC:/* Get WMM IE. */


