Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA4F3AF647;
	Sat, 12 Sep 2026 18:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237368; cv=none; b=pw2GwWZ88DetXVweDRZkbRmkSn+krekCuTnvtTcEcv5S6YI360R4GsMlHMedKxMV09GIRpK8g+/J/cO3UZrIxpEqJcZaQuIQOHKMHLYoYt5E1ZTPMkLB/rX9sf/48NikZqrHAO3mlmatgPD0UeiW80ImnGcY3Ny5ThqalwCagJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237368; c=relaxed/simple;
	bh=7ZNEesjKPPSzIfA3n/NFzAEjaavXlLh4JMQ95jPghEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Na/E5c/+RA/waOz01wDLTpXszlXXZz7Y1xX46F1YwQ+qEArVEF6AAejA7wXf10T6+UCdCeKW9/i9LVRA3FnLHDHuNlhTRPV87eRooPg/SUN8XvUAnHzdzdBELLI9kG9VP4qIvNiMr6tEO/xk9hyJHdWNtHFOYGZ3SQGDe7hynno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHyb5JGS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHyb5JGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93751F0089A;
	Sat, 12 Sep 2026 18:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237366;
	bh=oQmqag/fgQfyZH/l9oQGDlsB1CVy1lEHAaecQYxfR/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HHyb5JGS3USON+t+qH1alt/JchxnISiM9t/0Xy9ic8pZH/jqbypVX3p8//1ltWOLg
	 +aZ8cumrAR9qj7+45goM8BdosyV2YBx9gb3JpNUOoDWz+lE/gIkvd0zHLTA9Y9WVS1
	 RFZamWI6LleaQ+cbKSoR6xtvPEjXaDdjVtXUoLN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH 5.15 243/935] staging: rtl8723bs: fix OOB read / stack overflow in rtw_get_wps_attr()
Date: Sat, 12 Sep 2026 08:54:33 +0200
Message-ID: <20260912065532.398345874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

commit 99aa998dec83ba180822f70e6d48a514fc81c20d upstream.

rtw_get_wps_attr() walks WPS attributes inside a WPS IE taken from
a wireless management frame. For each candidate attribute it only
checks that the fixed 4-byte attribute header (2-byte ID + 2-byte
length) fits inside the IE:

	if (attr_ptr + 4 > wps_ie + wps_ielen)
		break;
	u16 attr_id = get_unaligned_be16(attr_ptr);
	u16 attr_data_len = get_unaligned_be16(attr_ptr + 2);
	u16 attr_len = attr_data_len + 4;

attr_data_len (and therefore attr_len) is read directly from the
wire and is never checked against the remaining bytes in the IE
before being used as the size of:

	memcpy(buf_attr, attr_ptr, attr_len);

Since attr_len is fully attacker controlled (0 to 65535+4), this is
both a heap OOB read of wps_ie, and, more seriously, a stack buffer
overflow at several call sites where buf_attr is a single-byte
stack variable, e.g. rtw_get_wps_attr_content()'s callers passing
WPS_ATTR_SELECTED_REGISTRAR into a stack "u8 sr"/"u8
selected_registrar" (drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c,
drivers/staging/rtl8723bs/core/rtw_mlme_ext.c). A crafted WPS IE in a
beacon or probe response processed during scanning can therefore
smash the stack of the parsing thread.

rtw_get_wps_attr_content() itself has no independent length check
and simply trusts the attr_len it gets back from rtw_get_wps_attr(),
so fixing the bound here also fixes that caller.

The "attr_ptr + 4 > wps_ie + wps_ielen" header check above was added
by commit 1463ca3ec6601 ("staging: rtl8723bs: fix OOB reads in
rtw_get_sec_ie(), rtw_get_wapi_ie(), and rtw_get_wps_attr()"), which
bounded the fixed header but never extended the check to cover the
variable-length attribute data that follows it. Add that missing
check before attr_len is used as a memcpy() length or accepted as a
match.

Fixes: 554c0a3abf216 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260728125456.32359-2-meatuni001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -762,6 +762,10 @@ u8 *rtw_get_wps_attr(u8 *wps_ie, uint wp
 		if (attr_ptr + 4 > wps_ie + wps_ielen)
 			break;
 
+		/* Reject attributes whose claimed length runs past the IE */
+		if (attr_ptr + attr_len > wps_ie + wps_ielen)
+			break;
+
 		if (attr_id == target_attr_id) {
 			target_attr_ptr = attr_ptr;
 


