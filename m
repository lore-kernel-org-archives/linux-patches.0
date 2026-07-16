Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA304424D79;
	Thu, 16 Jul 2026 14:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210746; cv=none; b=mRlWxEEOGkJCUS4mEotxsgtjFD34mChLLS/5EBWGG3KsvOKhT60PA3Nwqt2bSQBFpB6T/Sqe2nATX4bdXCimXnnXveovUQ9MLl7Pjue4Lfqam3qDOwekCR+l9NvhzFDR5BnAmtlqBZD3mYdt0XR0+9vjK4UZ+lSq+nC4VMcgphU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210746; c=relaxed/simple;
	bh=TJbhyrLt4a99BNYU3UK8Lt2vpNlTAnNxOBt9VLddadw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i62tLN5UtglvEOhDDagiCAf1NWrwc8EqfAWL5XqPNqAmRaaDztkPKeIX8dwlqH0CAMw5SSYnkqOTWoWUhRAhoHCU14dWwXCmVJrSKtYWXHCaS3fhTAkXyxepHvCo8Hfxu9rCJ50s4Jd7lFlkivFjPnNCmhQ2fXEa9ftBXBIZWx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6zBvrQT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6zBvrQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF4F1F000E9;
	Thu, 16 Jul 2026 14:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210744;
	bh=K689z9V45qqHeU2LhwxeIRhXS3946gS5TYemPVLuWzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6zBvrQTuF7OCSMZwMQQPKRk8aV7svJaSybY4RBELQXytggvqAuagmndQEilrzrKN
	 ijv4azbBGQJrJs9CfIvvkBzuL9OidmapKx5jWZA4DfWFnM/eXFP995XaWOmEt9qdWX
	 wi3Lcf4fRzY9Bbv7C7FtWerWsUcHXIEe/gNDO5wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexandru Hossu <hossu.alexandru@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 6.18 164/480] staging: rtl8723bs: fix OOB read in OnAssocRsp() IE loop
Date: Thu, 16 Jul 2026 15:28:31 +0200
Message-ID: <20260716133048.257258873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru Hossu <hossu.alexandru@gmail.com>

commit f9654207e92283e0acac5d64fe5f8835383b5a23 upstream.

The IE parsing loop in OnAssocRsp() advances by (pIE->length + 2) each
iteration but only guards on i < pkt_len. When a malicious AP sends an
AssocResponse whose last IE has only one byte remaining in the frame
(the element_id byte lands at pkt_len-1), the loop reads pIE->length
from pframe[pkt_len], which is one byte past the allocated receive buffer.

Additionally, even when the header bytes are in bounds, pIE->length
itself can extend the data window beyond pkt_len, silently passing a
truncated IE to the handler functions.

Add two guards at the top of the loop body:
  1. Break if fewer than sizeof(*pIE) bytes remain (can't read header).
  2. Break if the IE's declared data extends past pkt_len.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Link: https://patch.msgid.link/20260522004531.1038924-6-hossu.alexandru@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -1430,7 +1430,11 @@ unsigned int OnAssocRsp(struct adapter *
 	/* to handle HT, WMM, rate adaptive, update MAC reg */
 	/* for not to handle the synchronous IO in the tasklet */
 	for (i = (6 + WLAN_HDR_A3_LEN); i < pkt_len;) {
+		if (i + sizeof(*pIE) > pkt_len)
+			break;
 		pIE = (struct ndis_80211_var_ie *)(pframe + i);
+		if (i + sizeof(*pIE) + pIE->length > pkt_len)
+			break;
 
 		switch (pIE->element_id) {
 		case WLAN_EID_VENDOR_SPECIFIC:


