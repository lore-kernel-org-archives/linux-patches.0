Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45CE1667E2;
	Mon, 27 May 2024 19:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836554; cv=none; b=NoO+FF8eYNSEUqhYqoLoo9AIeqiB9ezKMHIAGcI32pBzftXAXoruC4xNioQw9zfT4rXmDSGQNsb/cLMvjG1mIvrEf3PMZIsDKHrN0FjR/gL0sFGJMiMDRTXwP4T6OIlmn9QdwgneRdIVKFP6wxLBYhepXXO6MTMfp3AvOgzdorI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836554; c=relaxed/simple;
	bh=DePCuo7XFu/F0pWsHZw5UumxYkw2UKL9pTpbXv3VzyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIjkR1viEqjtNFSETCbh0T7D3J2PsytL5knhfHQ3+ASTLcGIU0HdDlUANMxiN0Lko3y0i0OYsTKtVtrOoRDfTeqXHtD/C3E3bOImXlllT6vn8z09ZJbIH8GmX9b5lppbLldbv3K6XGpA0gm1jRLlVcYDOuA+aPDNL76uZjXAdGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9afQvJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9afQvJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1549C32782;
	Mon, 27 May 2024 19:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836554;
	bh=DePCuo7XFu/F0pWsHZw5UumxYkw2UKL9pTpbXv3VzyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9afQvJBFWNdfDYmTGhN9ZvYzHceVuAaF28XT/RHO6wgR2u1/0sVg+lGH0Gtb3PRZ
	 e/Y1XxrtzkhAjH5tNgfNZSjKPJ9YQDEQKiGvkpj2fc/eLy6gG0TWkyk9Zlboj/NW2q
	 3vwG9i2/ypBhWzqgkVyaEFQL/Q8crzchKm+fzQSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 100/427] wifi: cfg80211: ignore non-TX BSSs in per-STA profile
Date: Mon, 27 May 2024 20:52:27 +0200
Message-ID: <20240527185611.130332861@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 97f8df4db4c8ef50b659d8b228c1f42fe111e7c8 ]

If a non-TX BSS is included in a per-STA profile, then we cannot set
transmitted_bss for it. Even worse, if we do things properly we should
be configuring both bssid_index and max_bssid_indicator correctly. We do
not actually have both pieces of information (and, some APs currently
do not include either).

So, ignore any per-STA profile where the RNR says that the BSS is not
transmitted. Also fix transmitted_bss to never be set for per-STA
profiles.

This fixes issues where mac80211 was setting the reference BSSID to an
incorrect value.

Fixes: 2481b5da9c6b ("wifi: cfg80211: handle BSS data contained in ML probe responses")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240318184907.6a0babed655a.Iad447fea417c63f683da793556b97c31d07a4aab@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 47 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 5a5dd3ce497fc..9b0dbcd6cf79a 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2207,12 +2207,16 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 	tmp.pub.use_for = data->use_for;
 	tmp.pub.cannot_use_reasons = data->cannot_use_reasons;
 
-	if (data->bss_source != BSS_SOURCE_DIRECT) {
+	switch (data->bss_source) {
+	case BSS_SOURCE_MBSSID:
 		tmp.pub.transmitted_bss = data->source_bss;
+		fallthrough;
+	case BSS_SOURCE_STA_PROFILE:
 		ts = bss_from_pub(data->source_bss)->ts;
 		tmp.pub.bssid_index = data->bssid_index;
 		tmp.pub.max_bssid_indicator = data->max_bssid_indicator;
-	} else {
+		break;
+	case BSS_SOURCE_DIRECT:
 		ts = jiffies;
 
 		if (channel->band == NL80211_BAND_60GHZ) {
@@ -2227,6 +2231,7 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 				regulatory_hint_found_beacon(wiphy, channel,
 							     gfp);
 		}
+		break;
 	}
 
 	/*
@@ -2655,6 +2660,7 @@ struct tbtt_info_iter_data {
 	u8 param_ch_count;
 	u32 use_for;
 	u8 mld_id, link_id;
+	bool non_tx;
 };
 
 static enum cfg80211_rnr_iter_ret
@@ -2665,14 +2671,20 @@ cfg802121_mld_ap_rnr_iter(void *_data, u8 type,
 	const struct ieee80211_rnr_mld_params *mld_params;
 	struct tbtt_info_iter_data *data = _data;
 	u8 link_id;
+	bool non_tx = false;
 
 	if (type == IEEE80211_TBTT_INFO_TYPE_TBTT &&
 	    tbtt_info_len >= offsetofend(struct ieee80211_tbtt_info_ge_11,
-					 mld_params))
-		mld_params = (void *)(tbtt_info +
-				      offsetof(struct ieee80211_tbtt_info_ge_11,
-					       mld_params));
-	else if (type == IEEE80211_TBTT_INFO_TYPE_MLD &&
+					 mld_params)) {
+		const struct ieee80211_tbtt_info_ge_11 *tbtt_info_ge_11 =
+			(void *)tbtt_info;
+
+		non_tx = (tbtt_info_ge_11->bss_params &
+			  (IEEE80211_RNR_TBTT_PARAMS_MULTI_BSSID |
+			   IEEE80211_RNR_TBTT_PARAMS_TRANSMITTED_BSSID)) ==
+			 IEEE80211_RNR_TBTT_PARAMS_MULTI_BSSID;
+		mld_params = &tbtt_info_ge_11->mld_params;
+	} else if (type == IEEE80211_TBTT_INFO_TYPE_MLD &&
 		 tbtt_info_len >= sizeof(struct ieee80211_rnr_mld_params))
 		mld_params = (void *)tbtt_info;
 	else
@@ -2691,6 +2703,7 @@ cfg802121_mld_ap_rnr_iter(void *_data, u8 type,
 	data->param_ch_count =
 		le16_get_bits(mld_params->params,
 			      IEEE80211_RNR_MLD_PARAMS_BSS_CHANGE_COUNT);
+	data->non_tx = non_tx;
 
 	if (type == IEEE80211_TBTT_INFO_TYPE_TBTT)
 		data->use_for = NL80211_BSS_USE_FOR_ALL;
@@ -2702,7 +2715,7 @@ cfg802121_mld_ap_rnr_iter(void *_data, u8 type,
 static u8
 cfg80211_rnr_info_for_mld_ap(const u8 *ie, size_t ielen, u8 mld_id, u8 link_id,
 			     const struct ieee80211_neighbor_ap_info **ap_info,
-			     u8 *param_ch_count)
+			     u8 *param_ch_count, bool *non_tx)
 {
 	struct tbtt_info_iter_data data = {
 		.mld_id = mld_id,
@@ -2713,6 +2726,7 @@ cfg80211_rnr_info_for_mld_ap(const u8 *ie, size_t ielen, u8 mld_id, u8 link_id,
 
 	*ap_info = data.ap_info;
 	*param_ch_count = data.param_ch_count;
+	*non_tx = data.non_tx;
 
 	return data.use_for;
 }
@@ -2892,6 +2906,7 @@ cfg80211_parse_ml_elem_sta_data(struct wiphy *wiphy,
 		ssize_t profile_len;
 		u8 param_ch_count;
 		u8 link_id, use_for;
+		bool non_tx;
 
 		if (!ieee80211_mle_basic_sta_prof_size_ok((u8 *)mle->sta_prof[i],
 							  mle->sta_prof_len[i]))
@@ -2937,10 +2952,24 @@ cfg80211_parse_ml_elem_sta_data(struct wiphy *wiphy,
 						       tx_data->ielen,
 						       mld_id, link_id,
 						       &ap_info,
-						       &param_ch_count);
+						       &param_ch_count,
+						       &non_tx);
 		if (!use_for)
 			continue;
 
+		/*
+		 * As of 802.11be_D5.0, the specification does not give us any
+		 * way of discovering both the MaxBSSID and the Multiple-BSSID
+		 * Index. It does seem like the Multiple-BSSID Index element
+		 * may be provided, but section 9.4.2.45 explicitly forbids
+		 * including a Multiple-BSSID Element (in this case without any
+		 * subelements).
+		 * Without both pieces of information we cannot calculate the
+		 * reference BSSID, so simply ignore the BSS.
+		 */
+		if (non_tx)
+			continue;
+
 		/* We could sanity check the BSSID is included */
 
 		if (!ieee80211_operating_class_to_band(ap_info->op_class,
-- 
2.43.0



