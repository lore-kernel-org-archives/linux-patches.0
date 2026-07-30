Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60BD38DC50;
	Thu, 30 Jul 2026 14:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422916; cv=none; b=RibwTj7evX+glL/wpt17FXcyKE+dXMPz6Hl7xMZj9fyCLMkJubNfppGGEy8aFYz+idEtmnZeNkY9osISjik/TuaHD1XX1amx2LL7haDfqB25SgbT8KVNPCPIKUM6PjFBKxv0uopgUNP/1bO441qUaB8cnRzB5gnvp1f1ddvq4bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422916; c=relaxed/simple;
	bh=0jo0ZkDMSB3Var/WF8O+E3ZBrirhQDeRyyafzhLKdjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWhzv1dFkuXKiEg3TaanZJ0hIlsVpy7OixleXmUI1oRdOphug4Hb0j8p1YjAphIaJWuSlJnXFqNXQmqb+hFpf+QCg4dC/Veit9IYzczSBSPW07qSHJ1KVQv+HP95edfUJ06E7Tz8t9F9jF0Oj6evL9anaFH4YdG608OAx/J77JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Axr95uu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Axr95uu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7E51F000E9;
	Thu, 30 Jul 2026 14:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422915;
	bh=TvJ6vc6J9T0vePb0mRgD7BGZoGVM5ddGOp155fdbshE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Axr95uupLxi9KXQCB9CSB1DTWt+7NeiuDkeBhPrTXa/aajNFwcWSIpL2er97iIeW
	 9I87vS+hGul+E+E6SxNTo2Xu0Trwzp13Y51kvI0YPUrnliNvB6UhEI92vEC5sCBoGT
	 2b/ES8eoq7QGE6xaC1PfzAXphZF0wpLcxCiOSIBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Moksh Panicker <mokshpanicker.7@gmail.com>
Subject: [PATCH 7.1 556/744] staging: rtl8723bs: fix OOB reads in rtw_get_wps_ie()
Date: Thu, 30 Jul 2026 16:13:49 +0200
Message-ID: <20260730141456.099911715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Moksh Panicker <mokshpanicker.7@gmail.com>

commit 0e95ff792ae0aa6fbad9455943e9e1e4062670e9 upstream.

rtw_get_wps_ie() iterates over IE data from network frames without
validating that the IE header and payload fit within the remaining
buffer before reading them. Specifically:

- in_ie[cnt + 1] is read without checking cnt + 1 < in_len
- memcmp(&in_ie[cnt + 2], ...) accesses cnt + 2 without bounds check
- in_ie[cnt + 1] is used as length without verifying payload fits

Add bounds checks at the top of the loop body to break early if fewer
than 2 bytes remain for the IE header, or if the declared payload
extends past the end of the buffer. Also require at least 4 bytes of
payload before comparing the WPS OUI.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Moksh Panicker <mokshpanicker.7@gmail.com>
Link: https://patch.msgid.link/20260625202911.26782-1-mokshpanicker.7@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -671,7 +671,14 @@ u8 *rtw_get_wps_ie(u8 *in_ie, uint in_le
 	while (cnt < in_len) {
 		eid = in_ie[cnt];
 
-		if ((eid == WLAN_EID_VENDOR_SPECIFIC) && (!memcmp(&in_ie[cnt + 2], wps_oui, 4))) {
+		if (cnt + 2 > in_len)
+			break;
+
+		if (in_ie[cnt + 1] + 2 > in_len - cnt)
+			break;
+
+		if ((eid == WLAN_EID_VENDOR_SPECIFIC) && (in_ie[cnt + 1] >= 4) &&
+		    (!memcmp(&in_ie[cnt + 2], wps_oui, 4))) {
 			wpsie_ptr = &in_ie[cnt];
 
 			if (wps_ie)


