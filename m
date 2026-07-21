Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A6D46EF87;
	Tue, 21 Jul 2026 18:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659490; cv=none; b=gmOGzGQaBXjVcydHs1ca+qtwJYfuew6msBp3+pilYpO3lW4JSxBsKvqQisshBvQTEYX/J0JzG1JoR46VYqEvboQrGh4Srqwwc5IkWWV3fZgwq+xxXaw98o/QVWeLYVERor3n4L2pWR0I2rRVlhNXVjD0Tn5W4a0qXkvBeL+5gUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659490; c=relaxed/simple;
	bh=h4uSqR1InLSZ1rSqJm7dwcmmikC4pjLl1ajmDJA02Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/s7Al/f7vccx8EHDT/7lfkfNEuGMLX5lOgAmyiZkj0CyMZ76xzJeIQScGsuEvT4UI53UgbPquFpTgQkJXIPjPNYWC79FEIWCLdI/j/9KFLT27+hEAQvHc/QEEIQJofdCqtRbTvhQWU0+L0MAHU4FheiEMJgEt4JhksXIHvH1i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFKN8bZR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFKN8bZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7703D1F00A3F;
	Tue, 21 Jul 2026 18:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659489;
	bh=iNRy3eHKFULB1l3YoSpskojOxkmslVPUsnbfEHcWwEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFKN8bZRv95+Ir+sNr0Bt7aA/xQhVS6evoqqUgqD/oWm3a1dq8lIqM72bdX9tZ0Ke
	 NpwfttKg98yJSWy+W8rGF8wCdm7bSOs4mocWsH27DtguMvWLsXnZ8fxjWPpQM8p8Nq
	 RUwb2dmpWwA4MlFSTHlPxCvoVR/AEeQ9ITyu+iYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexandru Hossu <hossu.alexandru@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1541/1611] staging: rtl8723bs: fix OOB reads in rtw_get_sec_ie(), rtw_get_wapi_ie(), and rtw_get_wps_attr()
Date: Tue, 21 Jul 2026 17:27:37 +0200
Message-ID: <20260721152550.109146480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 1463ca3ec6601cbb097d8d87dbf5dcf1cb86a344 ]

Three IE/attribute parsing functions have missing bounds checks.

rtw_get_sec_ie() and rtw_get_wapi_ie() iterate over a raw IE buffer
without verifying that the header bytes (tag + length) are within the
remaining buffer before reading them.  Additionally, rtw_get_sec_ie()
compares the 4-byte WPA OUI at cnt+2 without checking that at least
6 bytes remain, and rtw_get_wapi_ie() compares a 4-byte WAPI OUI at
cnt+6 without checking that at least 10 bytes remain.

rtw_get_wps_attr() reads wps_ie[0] and wps_ie+2 unconditionally at
entry, before verifying that wps_ielen is large enough to contain
the 6-byte WPS IE header (element_id + length + 4-byte OUI).  Inside
the attribute loop, get_unaligned_be16() is called on attr_ptr and
attr_ptr+2 without checking that 4 bytes remain in the buffer.

Add a cnt+2 bounds check before each loop body in rtw_get_sec_ie()
and rtw_get_wapi_ie(), guard each multi-byte comparison with a minimum
IE length requirement, add a wps_ielen < 6 early return in
rtw_get_wps_attr(), and add a 4-byte bounds check in its inner loop.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
Link: https://patch.msgid.link/20260522004531.1038924-8-hossu.alexandru@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -585,9 +585,14 @@ int rtw_get_wapi_ie(u8 *in_ie, uint in_l
 	cnt = (_TIMESTAMP_ + _BEACON_ITERVAL_ + _CAPABILITY_);
 
 	while (cnt < in_len) {
+		if (cnt + 2 > in_len)
+			break;
+		if (cnt + 2 + in_ie[cnt + 1] > in_len)
+			break;
 		authmode = in_ie[cnt];
 
 		if (authmode == WLAN_EID_BSS_AC_ACCESS_DELAY &&
+		    in_ie[cnt + 1] >= 8 &&
 		    (!memcmp(&in_ie[cnt + 6], wapi_oui1, 4) ||
 		     !memcmp(&in_ie[cnt + 6], wapi_oui2, 4))) {
 			if (wapi_ie)
@@ -620,9 +625,14 @@ void rtw_get_sec_ie(u8 *in_ie, uint in_l
 	cnt = (_TIMESTAMP_ + _BEACON_ITERVAL_ + _CAPABILITY_);
 
 	while (cnt < in_len) {
+		if (cnt + 2 > in_len)
+			break;
+		if (cnt + 2 + in_ie[cnt + 1] > in_len)
+			break;
 		authmode = in_ie[cnt];
 
 		if ((authmode == WLAN_EID_VENDOR_SPECIFIC) &&
+		    in_ie[cnt + 1] >= 4 &&
 		    (!memcmp(&in_ie[cnt + 2], &wpa_oui[0], 4))) {
 			if (wpa_ie)
 				memcpy(wpa_ie, &in_ie[cnt], in_ie[cnt + 1] + 2);
@@ -707,6 +717,9 @@ u8 *rtw_get_wps_attr(u8 *wps_ie, uint wp
 	if (len_attr)
 		*len_attr = 0;
 
+	if (wps_ielen < 6)
+		return attr_ptr;
+
 	if ((wps_ie[0] != WLAN_EID_VENDOR_SPECIFIC) ||
 		(memcmp(wps_ie + 2, wps_oui, 4))) {
 		return attr_ptr;
@@ -717,6 +730,8 @@ u8 *rtw_get_wps_attr(u8 *wps_ie, uint wp
 
 	while (attr_ptr - wps_ie < wps_ielen) {
 		/*  4 = 2(Attribute ID) + 2(Length) */
+		if (attr_ptr + 4 > wps_ie + wps_ielen)
+			break;
 		u16 attr_id = get_unaligned_be16(attr_ptr);
 		u16 attr_data_len = get_unaligned_be16(attr_ptr + 2);
 		u16 attr_len = attr_data_len + 4;


