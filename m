Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56113224B05;
	Tue, 21 Jul 2026 22:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674662; cv=none; b=Q0OatEbxU5GH7ivff7VkmuRZPT46PytgiLF5xGeAJWJo4qh/IKtVOGRM0HDeHATM9Vmq1mRC6NxUEXXFK1T1G3xc8hGvoBUcpWoNb2MDoFt8B/y9g5Fbz+YkDW527Wqn0/4fE5nHmJPmYlzKB59KdvLiUPNqwivW7jNcGGqUdJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674662; c=relaxed/simple;
	bh=m9uX1eQWKXEeOWShzNucoLZzE9Rz1FpO9VMkW/jwRjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbnCgsQrz6rKquCp3UDtQBzB6wor9K1lCTs0MqpBZW0hBy+B52zDaQ5CDntIwHSs10NAa3VSGMOPpbe2ps0YtZFpOdPiydVGIG9grO4Etq51quXEszg207i1RLfC3Ng6weJl6RJLHZV/l7yxNTTwvp6en4cbKcZw7YBZIKEpjHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXYQ3EeP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXYQ3EeP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CB11F000E9;
	Tue, 21 Jul 2026 22:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674661;
	bh=HsNkGoQaEkmnLDH45Lt29vCTiB/+PWJtlsFjZISLzJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXYQ3EePc5cSRFwBFuLS8n1sC4RdKdawiJLqLHaVi638+g5fbBBE+BF/leUmGJJa5
	 m1CbyCnVa7YH867GiPjbNNZUeM00T3UD7ory9YY+iJYrHAyasJU4h0/pg9OqSI/o7j
	 DMuy1whx3e3ZIDrnretcXDMpCA1IqRVhnvnKtnn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luka Gejak <luka.gejak@linux.dev>,
	Alexandru Hossu <hossu.alexandru@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 624/699] staging: rtl8723bs: fix OOB reads in IE loops in issue_assocreq() and join_cmd_hdl()
Date: Tue, 21 Jul 2026 17:26:23 +0200
Message-ID: <20260721152409.819846850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru Hossu <hossu.alexandru@gmail.com>

[ Upstream commit ef61d628dfad38fead1fd2e08979ae9126d011d5 ]

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
[ replaced sizeof(*pIE) with literal 2 (5.10's ndis_80211_var_ie still has data[1]) and used pre-rename field names IELength/IEs/ElementID/Length ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -3341,7 +3341,11 @@ void issue_assocreq(struct adapter *pada
 
 	/* vendor specific IE, such as WPA, WMM, WPS */
 	for (i = sizeof(struct ndis_802_11_fix_ie); i < pmlmeinfo->network.IELength;) {
+		if (i + 2 > pmlmeinfo->network.IELength)
+			break;
 		pIE = (struct ndis_80211_var_ie *)(pmlmeinfo->network.IEs + i);
+		if (i + 2 + pIE->Length > pmlmeinfo->network.IELength)
+			break;
 
 		switch (pIE->ElementID) {
 		case _VENDOR_SPECIFIC_IE_:
@@ -6105,7 +6109,11 @@ u8 join_cmd_hdl(struct adapter *padapter
 
 	/* sizeof(struct ndis_802_11_fix_ie) */
 	for (i = _FIXED_IE_LENGTH_; i < pnetwork->IELength;) {
+		if (i + 2 > pnetwork->IELength)
+			break;
 		pIE = (struct ndis_80211_var_ie *)(pnetwork->IEs + i);
+		if (i + 2 + pIE->Length > pnetwork->IELength)
+			break;
 
 		switch (pIE->ElementID) {
 		case _VENDOR_SPECIFIC_IE_:/* Get WMM IE. */


