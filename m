Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8980D3009E1;
	Thu, 16 Jul 2026 13:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209525; cv=none; b=Mrad5P+Wxh4Vki8B2cVncybNNPr43xGlqr1LbLfPLdPNJl2FhqeltLp1bjz75MWiVFjHWGN3Sq6FkLflnzR749N2lD0wQdieFx2/PSzsGscjOiODOYok0JB44BQjilF3cJMHQYgInoZbitLYMHSUT4T1Iel9idLRRd+O7JxjBZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209525; c=relaxed/simple;
	bh=xIX3YW99XDtikc/wkt7a1P6DPlp8jlkGjwaFgebI/y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UhzbprHFPIgd+w1zYZJSn7figiSnFxmX3FQ2bDAJxXWgxQUaqxcK0/NgjhuAWepHyo2azPUL3WkKk2MX0NkWYnabT77w89Ixy2CdPXpJ0BNfoz7axH0QLMKxGRs5f0AeDcY3Ywq9PN6wwPe5wZHUd5ITlJPQLWFyt50CGOJCk6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7t8FqS+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7t8FqS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DEA1F000E9;
	Thu, 16 Jul 2026 13:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209523;
	bh=j7gvdarG/paqLmDYJ5eKBK/tR7ww9euZQhc7bzy+Miw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d7t8FqS+gvF2cG87L0DaE+LRnDTYMAE1BUlDkWdrC4AOe1zIZ0eq1AU8eJ/ees8bg
	 UwWn9lg74RQpWG7YmOHzXIhoMqwgsrshWYsOyWDy4e0MHJQuRhfFuERq/70AR8OIHC
	 UnoBRdQa061ygQ4vLf9LYV4Izn3KxpJhZe23tnOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luka Gejak <luka.gejak@linux.dev>,
	Alexandru Hossu <hossu.alexandru@gmail.com>
Subject: [PATCH 7.1 164/518] staging: rtl8723bs: fix OOB reads in IE loops in issue_assocreq() and join_cmd_hdl()
Date: Thu, 16 Jul 2026 15:27:12 +0200
Message-ID: <20260716133051.429531992@linuxfoundation.org>
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
@@ -2935,7 +2935,11 @@ void issue_assocreq(struct adapter *pada
 
 	/* vendor specific IE, such as WPA, WMM, WPS */
 	for (i = sizeof(struct ndis_802_11_fix_ie); i < pmlmeinfo->network.ie_length;) {
+		if (i + sizeof(*pIE) > pmlmeinfo->network.ie_length)
+			break;
 		pIE = (struct ndis_80211_var_ie *)(pmlmeinfo->network.ies + i);
+		if (i + sizeof(*pIE) + pIE->length > pmlmeinfo->network.ie_length)
+			break;
 
 		switch (pIE->element_id) {
 		case WLAN_EID_VENDOR_SPECIFIC:
@@ -5328,7 +5332,11 @@ u8 join_cmd_hdl(struct adapter *padapter
 
 	/* sizeof(struct ndis_802_11_fix_ie) */
 	for (i = _FIXED_IE_LENGTH_; i < pnetwork->ie_length;) {
+		if (i + sizeof(*pIE) > pnetwork->ie_length)
+			break;
 		pIE = (struct ndis_80211_var_ie *)(pnetwork->ies + i);
+		if (i + sizeof(*pIE) + pIE->length > pnetwork->ie_length)
+			break;
 
 		switch (pIE->element_id) {
 		case WLAN_EID_VENDOR_SPECIFIC:/* Get WMM IE. */


