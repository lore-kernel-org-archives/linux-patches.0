Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB55217723;
	Thu, 30 Jul 2026 15:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424761; cv=none; b=LLO+VbYIoZOQkA0JvlkZGu4KaVLccE9+ADn/hcs2ShzYnPIuY2pn+3dJtiNt4vj5McyfyPKxqRGJdJTmgjvdTu9YQBqi1AWLkBv0+jLIaUsjojfUX9sZ86y+lXdKLwHUTBdINDfBb9Y3nETkjSo+ILNaB9Mp+yLvMGT2/HuZPcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424761; c=relaxed/simple;
	bh=m9GfUbMkwCPvsXNQ24mhSiIEgzInRJT+L5IigdgHIFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIfTz2WyjijyW4c+CKf3iOacfslUppnhN69m2BIyEddoiEiTkXxoARGn+McHSVr0H95boCEtBWCWCurgdbCaEKBlsmNiS3v95ovyZa/uvdcAk5mRMCwRvwdXHP8roDGWHQCEZmgDZeF6as2hHFh8BKT+S0KHrp/Kk/R6yXB80Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dwOBDFlD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwOBDFlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152CD1F000E9;
	Thu, 30 Jul 2026 15:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424760;
	bh=Z8ova62jwIPw13h+daF+hLFO8F7x7QCCCF04BIum/hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dwOBDFlDEuAmMDgmlVcjWGodHzeJTZJE7aNfRxOebPkoeXHuPZ4GnKvJGai0r23RS
	 TCwlSDCYRoUw9gId4nz0NFRdmVPI0h71Gof4hJ94ajlvaH6Fx9L9w+EznOfjlVLY0K
	 uGawAAnzKKxvURVD8owrhO8vJT5AJP0dwjY0Q5zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Moksh Panicker <mokshpanicker.7@gmail.com>
Subject: [PATCH 6.18 462/675] staging: rtl8723bs: fix OOB reads in rtw_get_wps_ie()
Date: Thu, 30 Jul 2026 16:13:12 +0200
Message-ID: <20260730141454.949672024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -679,7 +679,14 @@ u8 *rtw_get_wps_ie(u8 *in_ie, uint in_le
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


