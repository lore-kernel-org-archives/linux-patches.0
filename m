Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF55332EC5;
	Wed, 23 Sep 2026 14:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175140; cv=none; b=oNvwc79dslzbC0e+kfuIpDJpen886NKP7alp92db4tOO51wnJwa4AlOw2pgZuKP/hvD0VR70vcpnAngVgSGN014i8py5xIvmOHo4Vo5nsPd+6/mh89dRSCEJ3w4v9bznbInivIoLEjN+08dQkgTlTLLobYnPNUwPbZL9uHrG6hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175140; c=relaxed/simple;
	bh=CO1v1otAD2Idv/swLkX0Qr8jk5Jqk4TQ6HUfe09XZ/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOu3wfRuILlxfY+VuVHG0XWWVZZNJIWBhc0bnwrrZyNJZ2vpr6b+dmsqzLbbPzG+0qCAXU3NFuvtmXqSwCYbWqXrxBXa2NHsh71Luihcfneud0Xb/aYP4RMV78Vi8lT0ATSGKHauWzuQsa8SXIKhzy/DWyVoBnX2TXu/naglxFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FwxPqSp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FwxPqSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD8C1F000FF;
	Wed, 23 Sep 2026 14:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175137;
	bh=u1LNR8KsFkv8L2BVXtoMymjK3mZ4JVOr0MstpEJbGKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FwxPqSpBkAuB7c4xMIFafpBpYrFfMXy87B8aHjaMtUJGZnM/5hHR3ADnnw0KlhON
	 YLHMJGU10B2G0Krb+xxxn4hflNhirDm0IEPKpePe2bD+qE9Cb0nZaHcJCGuX3/9qnp
	 kPCvO6ENnDBBpSRHYgXxKgXClfwlDtnL54/kr2aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 333/398] wifi: mwifiex: bound the pairwise-cipher OUI walk to the IE length
Date: Wed, 23 Sep 2026 16:06:47 +0200
Message-ID: <20260923140652.052363505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
@@ -104,12 +104,24 @@ has_vendor_hdr(struct ieee_types_vendor_
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
@@ -143,11 +155,14 @@ mwifiex_is_rsn_oui_present(struct mwifie
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
@@ -169,10 +184,14 @@ mwifiex_is_wpa_oui_present(struct mwifie
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


