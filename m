Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2146315D53;
	Tue, 21 Jul 2026 18:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659370; cv=none; b=DCZy3x9ouj2DbPZt+hAUa/xMoxZPLCdq27EO+PSQXTkOildT06cXqlQHOQWLCvWGObZxq0d3iB4lEMiUv8uFfWjTkJUnxQpgSPMRp9rS1a03wMDe8P8Lpo1GqzUd8ZBINM97rwgXIzPFjdRCTaf8ZyLsy2ciCDGC1gad/2NW+9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659370; c=relaxed/simple;
	bh=xHj0t9QyLdLO2ZIXmyrcFEyoVi8ZkT+Y9sv6YAeYvXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0h/DNB6Tbe25/q/dCVXcbh6GqIOMw3Wx0DIf1i7dgeSQmaQpRN8dSY6jh1ruCmlkmpjqxQjdQoVojl/P9WTA53Z3VrA3xhU5GqD3tDGlCDKaVZyC3IqFbm1CEDoVGi9bYqJhgXJFRh5v+JTb8ukAnfiA5WahSI3EP6RwrgoKOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2E0OxIM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2E0OxIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441B41F000E9;
	Tue, 21 Jul 2026 18:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659369;
	bh=7rL9Enksv+2kW7e7wQB+e3deVefextUH4LfsbV0OLnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2E0OxIMyeND0iHAC7Mx4uvqjQAexPiLaxTWmLAGUIRxdaYTelqasEMylXC9yUst9
	 hWHoJzY006/flC6tbwz+6MhKvQB4IXTFBuQ/Mdj3JH/q/5BNjT4UB2/QntAWGJfnq3
	 bBZ9PWZS3m5lBQ7di+iEEzdqzhcvF1Gd9tOyuCs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haofeng Li <lihaofeng@kylinos.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 1496/1611] wifi: cfg80211: validate EHT MLE before MLD ID read
Date: Tue, 21 Jul 2026 17:26:52 +0200
Message-ID: <20260721152549.092082170@linuxfoundation.org>
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

From: Haofeng Li <lihaofeng@kylinos.cn>

commit 74e27cd1d98b546fdb276008a83708d062339661 upstream.

cfg80211_gen_new_ie() copies ML probe response elements from
the parent frame when the parent EHT multi-link element has an
MLD ID matching the nontransmitted BSSID index.

The code only checked that the extension element had more than
one byte before calling ieee80211_mle_get_mld_id(). That helper
assumes a BASIC MLE with enough common info and documents that
callers must first use ieee80211_mle_type_ok().

Attack chain:
malicious AP sends a short EHT MLE in an MBSSID beacon.
cfg80211_inform_bss_frame_data() stores the copied IE buffer.
cfg80211_parse_mbssid_data() builds the nontransmitted BSS IE.
cfg80211_gen_new_ie() sees the EHT MLE in the parent frame.
ieee80211_mle_get_mld_id() then reads past the IE boundary.

Validate the MLE type and size before reading the MLD ID. This
matches the contract required by the MLE helper and rejects the
short element before any internal MLE fields are accessed.

Cc: stable@vger.kernel.org
Fixes: 61dcfa8c2a8f ("wifi: cfg80211: copy multi-link element from the multi-link probe request's frame body to the generated elements")
Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
Link: https://patch.msgid.link/20260701093327.2680709-1-lihaofeng@kylinos.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -326,8 +326,11 @@ cfg80211_gen_new_ie(const u8 *ie, size_t
 		/* For ML probe response, match the MLE in the frame body with
 		 * MLD id being 'bssid_index'
 		 */
-		if (parent->id == WLAN_EID_EXTENSION && parent->datalen > 1 &&
+		if (parent->id == WLAN_EID_EXTENSION &&
 		    parent->data[0] == WLAN_EID_EXT_EHT_MULTI_LINK &&
+		    ieee80211_mle_type_ok(parent->data + 1,
+					  IEEE80211_ML_CONTROL_TYPE_BASIC,
+					  parent->datalen - 1) &&
 		    bssid_index == ieee80211_mle_get_mld_id(parent->data + 1)) {
 			if (!cfg80211_copy_elem_with_frags(parent,
 							   ie, ielen,


