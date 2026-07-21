Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0A2394783;
	Tue, 21 Jul 2026 20:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665033; cv=none; b=B3kKrvS+t6IwMXaLqjkYu95/rRno6nmf0khQYePCdxf6AeoF3JYo1P+NFW97mb7/VQ+tqQukjRz9UJ8Y5HSLJgaJcUOEh0xgjJqScjtjx0KBcjtX21DrmA5IaEA2yLDFzR+XOQvdFZ2av1cc4VwPDnimaWI6rVHekK1OOaChDBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665033; c=relaxed/simple;
	bh=sTMRMHEVy3IQvEbkTzhaPp+2T1wnxe5jVmK/SxBP4fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4CslDdBovO1zxLGW4vEWNIFgmuILRdgIv5QaUT6UP6NIW508EQ0XsAp8gAME5upNUZnyDzcHpE/xBEaAqIlwDgBjbyh3OhL4xf1SNqAP4Zp7fz94mqfNo4Fya8fsOS4lIvbY78x7lXISXm17zmN9UVT3bIwjUC3LCs1ivOQUFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLbUuVKr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLbUuVKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7A91F000E9;
	Tue, 21 Jul 2026 20:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665032;
	bh=0+Y0xQHrXvS7GEydLvAiwUW29/wMb5mAFV2fRNoXKm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLbUuVKr9zoboc9Ja+WvDOIrWEmpf3Pp9/6njs7VVLHvzjTj1R5zy3Pc0jZ62nIKH
	 RN5mbruW4VBv8bS1wnfN4FTjcCerNtWlqvDYGCR+WPy2u6+aNlStxFfdPCnQN6WsRy
	 +xaBMMPGvSmXUo0vQsi2B9k1gv8CsAGrxEe5+RtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexandru Hossu <hossu.alexandru@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 6.6 0152/1266] staging: rtl8723bs: fix OOB write in HT_caps_handler()
Date: Tue, 21 Jul 2026 17:09:49 +0200
Message-ID: <20260721152445.208366627@linuxfoundation.org>
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

commit f8001e1a516ba3b495728c65b61f799cbfad6bd0 upstream.

HT_caps_handler() iterates pIE->length bytes and writes into
HT_caps.u.HT_cap[], which is a fixed 26-byte array (sizeof struct
HT_caps_element). Because pIE->length is a raw u8 from an over-the-air
802.11 AssocResponse frame and is never validated, a malicious AP can
set it up to 255, causing up to 229 bytes of out-of-bounds writes into
adjacent fields of struct mlme_ext_info.

Truncate the iteration count to the size of HT_caps.u.HT_cap using
umin() so that data from a longer-than-expected IE is silently ignored
rather than written out of bounds, preserving interoperability with APs
that pad the element. An early return on oversized IEs was considered
but rejected: it would bypass the pmlmeinfo->HT_caps_enable = 1
assignment that precedes the loop, silently disabling HT mode for APs
that append extra bytes to the HT Capabilities IE.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Link: https://patch.msgid.link/20260522004531.1038924-5-hossu.alexandru@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723bs/core/rtw_wlan_util.c
@@ -979,7 +979,8 @@ void HT_caps_handler(struct adapter *pad
 
 	pmlmeinfo->HT_caps_enable = 1;
 
-	for (i = 0; i < (pIE->length); i++) {
+	for (i = 0; i < umin(pIE->length,
+			     sizeof(pmlmeinfo->HT_caps.u.HT_cap)); i++) {
 		if (i != 2) {
 			/* Commented by Albert 2010/07/12 */
 			/* Got the endian issue here. */


