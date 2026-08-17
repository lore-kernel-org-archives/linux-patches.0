Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE2043F4A8;
	Mon, 17 Aug 2026 13:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975120; cv=none; b=F5LlDSP6F+JQz5qIEb/ZljEymeT+iruBRSV9glpoUDldJpHGqmrv9Koo/QDuvWGmfIQnckubiv73w9A487vzs0V6AuOnGq6bl/luU3aH4pRGj9MroPc5YtSE39xDHkzShMFxkfGMKKRvxXjoVdicksiuN6GTbu0ZlTy1V+Fmtfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975120; c=relaxed/simple;
	bh=7fKeBpYG8rE23ij/CJsw8Vg/atu2sJ19cdo9EVL8xok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GlCqD3mKqgJkGZN8A7YzV5poG/M7km0+nQ6aJG8yek7CKh/TR8g03AbxAP/bYbnOTA3LJc3rhv1ubb2xF0S6i4bFySOLPhHO6w3gmffwHCwR9EIquq11Gu7dQvv0zQgEhhuxb/cK7n3CGumIZFTi7N+Ew5cX3hCYKECBYAvZ/eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gchMnpf4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gchMnpf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D978B1F000E9;
	Mon, 17 Aug 2026 13:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975119;
	bh=ckOSgzM1adZbpwcvoBLtRnbA6uLfwIWgnNazuOrBoC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gchMnpf4T5XmqcAf9E6RqXv24WWd0aCxV7/oqUiGXbeR67TjRd/a6Fmqnq98skYc1
	 biHEydLO6uqqF2cOzgf/mKFfEOvWIYVmMDppneKntcHE/NARQmHzvidY1qd9bEpVjd
	 u0RNBayUrzHccQOfcAhPdxFWFi0T7rURTHA5nNlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Muhammad Bilal <meatuni001@gmail.com>
Subject: [PATCH 6.18 170/250] staging: rtl8723bs: fix OOB read in rtw_get_wpa_ie()
Date: Mon, 17 Aug 2026 15:32:11 +0200
Message-ID: <20260817132543.574936232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

commit 1c3e23e78862493e8cf1adad02b10ffcb8b9921c upstream.

rtw_get_wpa_ie() reads bytes at fixed offsets into a vendor-specific
information element without checking that the element is long enough,
causing an out-of-bounds read for a short trailing IE.

The function locates a vendor-specific IE (EID 221) with rtw_get_ie()
and then compares a 4-byte OUI+type at pbuf + 2 and reads a 2-byte
version word at pbuf + 6. Those accesses require the IE body to be at
least 6 bytes, but rtw_get_ie() only guarantees that the element fits
within the buffer; it does not enforce a minimum body length. A
vendor-specific IE whose length byte is 0 to 5, placed at the end of
the buffer, therefore makes these reads run past the end of the IE and
past the end of the buffer itself.

The buffer holds information elements taken from received management
frames and from the IE blob passed to rtw_cfg80211_set_wpa_ie(), which
is kmemdup'd to its exact length, so the read can run off the end of
the allocation.

The sibling helpers rtw_get_sec_ie(), rtw_get_wapi_ie() and
rtw_get_wps_ie() in this file already reject too-short vendor-specific
IEs before their OUI memcmp(); rtw_get_wpa_ie() was never brought in
line with them, and needs a minimum of 6 rather than 4 bytes because
of the version word. Add the missing length check.

Fixes: 554c0a3abf216 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260719030631.88254-1-meatuni001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -372,6 +372,9 @@ unsigned char *rtw_get_wpa_ie(unsigned c
 		pbuf = rtw_get_ie(pbuf, WLAN_EID_VENDOR_SPECIFIC, &len, limit_new);
 
 		if (pbuf) {
+			if (len < 6)
+				goto check_next_ie;
+
 			/* check if oui matches... */
 			if (memcmp((pbuf + 2), wpa_oui_type, sizeof(wpa_oui_type)))
 				goto check_next_ie;


