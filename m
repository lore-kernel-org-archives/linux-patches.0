Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E84A29992B;
	Wed, 30 Sep 2026 15:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783644; cv=none; b=a9o43SdtMXAnn4E677GZZ3XwI2v/INhj4gCmIdTR7lNtTcVhiWBfNpl0gnguOoQPit2B7RY+xw4AVIQ9+83jeQJ9F1ng1Gl+rqcBEkXF3Sfe6ugnPnLPqXq0stFPu1cXP23HMM9Q66xCix/B77nZyIA6Ib6W9ksKKtq4F1eLiSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783644; c=relaxed/simple;
	bh=2KF1Sm223Pv/fjFtrvUFQ4f4mNlkNosR0b7ZsYkvxDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h30gHxGuFFhAcTdI2vSNilTRK/fToPXT5bY3wB/+AaKkRTKr09QeoFhEnaoE+Ik8UajZJhzAR92mVomTD0AyITq4x7WjwtrKq0UDqaW4UUhPwGgM0eLUJYNVp78G9w6/2l0iJ7/ZTEHUWBtuHfmfwKKKp1M1dXjblTuPxYt75tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wEkd5gv+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEkd5gv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F491F00898;
	Wed, 30 Sep 2026 15:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783639;
	bh=O1Vajajf7ZP7QAL4JK921RSnUm6ZAvTbsu0l/Vx5i50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wEkd5gv+c6F/kww59M6Vs9jXtRHoMa5AxM4ST2GC1ANsuxJr4X5mBg98WHfj3N8my
	 epDT+Tj2HUKHk+mSpHccmiZmqghsBs+TYsLdgEuTlAi1A5FuqYpGnD+sAlafq5OeuZ
	 tdQFvzXPOp/xoxFiNGnRziYYYDIIi0PXZSS7LSY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 470/595] wifi: mwifiex: bound the pairwise-cipher OUI walk to the IE length
Date: Wed, 30 Sep 2026 17:26:03 +0200
Message-ID: <20260930152357.786985953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit e667aee1c192d67d27c803007bfa9c6e0873e959 upstream.

mwifiex_search_oui_in_ie() reads a pairwise-cipher (PTK) count from a
beacon/probe-response RSN or WPA information element and then walks that
many 4-byte OUIs, comparing each with memcmp(). The count comes straight
from the (attacker-supplied) IE and is never checked against the
element's own length, and the callers admit the element on element_id
alone (has_ieee_hdr() / has_vendor_hdr(), no length check). A crafted
RSN/WPA IE with a large pairwise count therefore makes the walk read up
to 255 * 4 bytes past the element -- an out-of-bounds read of the
kmemdup()'d beacon buffer, reachable from any AP whose beacon/probe
response is processed during scan-result parsing.

Pass the number of IE bytes available at the OUI list and bound the walk
to the element. Keep the length signed and reject a negative value
before any unsigned arithmetic, so a small or zero IE length cannot
underflow to a large size_t and defeat the bound.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:multi-model
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Link: https://patch.msgid.link/20260814134704.85902-1-doruk@0sec.ai
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/scan.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -116,12 +116,24 @@ has_vendor_hdr(struct ieee_types_vendor_
  * a given oui in PTK.
  */
 static u8
-mwifiex_search_oui_in_ie(struct ie_body *iebody, u8 *oui)
+mwifiex_search_oui_in_ie(struct ie_body *iebody, u8 *oui, int ie_len)
 {
+	const size_t ptk_body_offset = offsetof(struct ie_body, ptk_body);
 	u8 count;
 
+	/* ie_len is the number of bytes available at iebody. Keep it signed
+	 * and reject a negative (underflowed) length before the unsigned
+	 * comparisons below, so a small or zero IE length cannot wrap.
+	 */
+	if (ie_len < 0 || (size_t)ie_len < ptk_body_offset)
+		return MWIFIEX_OUI_NOT_PRESENT;
+
 	count = iebody->ptk_cnt[0];
 
+	/* Reject an OUI count whose list would run past the element. */
+	if (ptk_body_offset + count * sizeof(iebody->ptk_body) > (size_t)ie_len)
+		return MWIFIEX_OUI_NOT_PRESENT;
+
 	/* There could be multiple OUIs for PTK hence
 	   1) Take the length.
 	   2) Check all the OUIs for AES.
@@ -155,11 +167,14 @@ mwifiex_is_rsn_oui_present(struct mwifie
 	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
 
 	if (has_ieee_hdr(bss_desc->bcn_rsn_ie, WLAN_EID_RSN)) {
+		int ie_len = (int)bss_desc->bcn_rsn_ie->ieee_hdr.len -
+			RSN_GTK_OUI_OFFSET;
+
 		iebody = (struct ie_body *)
 			 (((u8 *) bss_desc->bcn_rsn_ie->data) +
 			  RSN_GTK_OUI_OFFSET);
 		oui = &mwifiex_rsn_oui[cipher][0];
-		ret = mwifiex_search_oui_in_ie(iebody, oui);
+		ret = mwifiex_search_oui_in_ie(iebody, oui, ie_len);
 		if (ret)
 			return ret;
 	}
@@ -181,10 +196,14 @@ mwifiex_is_wpa_oui_present(struct mwifie
 	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
 
 	if (has_vendor_hdr(bss_desc->bcn_wpa_ie, WLAN_EID_VENDOR_SPECIFIC)) {
+		int ie_len = (int)bss_desc->bcn_wpa_ie->vend_hdr.len -
+			(int)sizeof(bss_desc->bcn_wpa_ie->vend_hdr.oui) -
+			WPA_GTK_OUI_OFFSET;
+
 		iebody = (struct ie_body *)((u8 *)bss_desc->bcn_wpa_ie->data +
 					    WPA_GTK_OUI_OFFSET);
 		oui = &mwifiex_wpa_oui[cipher][0];
-		ret = mwifiex_search_oui_in_ie(iebody, oui);
+		ret = mwifiex_search_oui_in_ie(iebody, oui, ie_len);
 		if (ret)
 			return ret;
 	}


