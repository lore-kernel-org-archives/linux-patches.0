Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7379546C4AC;
	Tue, 21 Jul 2026 17:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655278; cv=none; b=pf4zu49ZVsgEAh9wqPszpggC4kkMIWcHrBxDwRRsOQutboReAx/u45tL11aUWkJa8yDhp62o0W58dGIA8fE8HH9eJ3gpnpiRE/ctBe13r4bnMlEv0XXs6SHJsWfPBpcT5hHBMkOWNWCmFOSsR0gPg3p23Zk/I+9V6Z/tOVONwM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655278; c=relaxed/simple;
	bh=4JLVjFfUB1Sb5KxcgJT/3h2QOM1G+Oa4nZkxeKjS8ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blakhgri7qm/zFWfMG3saVz1MNdRnHyXLrzxIG23NpHgrLOQtt7tRSbcPyX6l9HusnstF3GsSjvTmKmBBrxEnT3Kz5ZPluvKCOdUtM3Pr2ZgDh3eN79ajCvHADg6f05RVa5TEIsXy8ZM2xBvIx1cqRQ8IPB2W2YugdygXaHanrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUkf2LU5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUkf2LU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB50C1F000E9;
	Tue, 21 Jul 2026 17:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655277;
	bh=fHHpuznd3bTjtVzd/RcnRIC1E7B9utqoPxsJPXjFxJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hUkf2LU5FRGjfr1ts4IzP8vmOd+14j+XbDkpziGxLwhCav0H3OIeBlMhJT/Z1yD7P
	 fAwLu/GmQ49XdUi9nJvXMBEeC0xAWrSftWEq9SU3kULKBMWiw8rg7jhtkhlHzLIR4v
	 gUKGXjn/0ofE21qc2RjGvnRMKsa21uJ3kfz7e7wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haofeng Li <lihaofeng@kylinos.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.1 2022/2077] wifi: cfg80211: validate EHT MLE before MLD ID read
Date: Tue, 21 Jul 2026 17:28:15 +0200
Message-ID: <20260721152640.392241940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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


