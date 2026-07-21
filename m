Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E1835C681;
	Tue, 21 Jul 2026 21:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668273; cv=none; b=IGDPiB/7przlIEVwyXbqV1B9lM5c+IPu0rER8/rxC6d4rqyeqSgQ+HFjU2g3cthH5AUuFRxIFpIRle6dFFXBFR1FvGUt4Ba8xxmnv/DRbCtyzkYTJqfv74qukkoHKcsAI63KJ413O1aAAm3xuiqCcuJLaPCsNM+mkStc1vpuHgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668273; c=relaxed/simple;
	bh=A4QZZLCjn17O4G5sPBepo74c9ik9X88V4JzPj8MzEz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=niIlsS7RM+go8yaOd2qocVaURe31JZeNl+PqY0DGFY2fL+GyCxX0SKUb7vcToHyh+qj9uK2iHWWKl/By0s3FzS5JxocHqzpjmYi3aZF0FHxRJX9r6ZOACL+Avpnqh/05s1rUVy+mZbfNy63WN2znPvg+tQxZrYHBJUkpNkCtWE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvgNjpud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvgNjpud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454301F000E9;
	Tue, 21 Jul 2026 21:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668271;
	bh=pEpCOgjVWqbbwFQf/lqCWgQS7YVjIRiKfjeB7bAOYu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zvgNjpudDh8NFF1IhWvy4w85PpJCGANqW7Fpf91yrd6uT27/Viy9Lz0OgA7cw86Vj
	 bnJ+bZRoWOuXjtZMteFC2oJ4ziXDBgKQe5lVKtbSfCmHLyuTHU8fBWldIuDJP5gKK+
	 xAAH7+NQLuSVvYG8b6k2kUG61h7edKbDpAzW4tBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexandru Hossu <hossu.alexandru@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH 6.1 0114/1067] staging: rtl8723bs: fix OOB write in HT_caps_handler()
Date: Tue, 21 Jul 2026 17:11:55 +0200
Message-ID: <20260721152427.139688251@linuxfoundation.org>
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


