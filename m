Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFBD155352;
	Mon,  6 Jan 2025 15:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178022; cv=none; b=RZRALO93Gju/1fxRnn9UDpRsQbdN7rlHr51jEk0r6SyQYqPvmdYfl0MNZ43wJ4HcF3we8eWMDcIYddvM6aWzsP8dqs/T3xYrSutiWv/5vY9cJtduXLd9O+zeDRvWO37t9NqrBe4p84xme6x1VK3k0iMkD7zT5DM9utDAJynnBiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178022; c=relaxed/simple;
	bh=YEhG7tSAAxB+1mT6werUkckV6UtZcj/xka7JawLp+1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsyID4VWGKN5ECANtbwHAj0FTOBo/oqwfRW7EQE0BX9xdk5mPX4rKECIoY0fULMaoUE0oNmgAiJBMR77FwDJ5QLelhhifNnDFFpBuBCqIB87UAXRYGp68MsdHX5TyNIE/rHE/Hz6iDl5DAwXMKKPNDUZsNpO8Q7ES8ZIPVT1SDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MqBzkjn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MqBzkjn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D403C4CED2;
	Mon,  6 Jan 2025 15:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178021;
	bh=YEhG7tSAAxB+1mT6werUkckV6UtZcj/xka7JawLp+1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MqBzkjn3sYKWxYSHIpqobnlPzrmybtWRQ6he2BRZm4hRTGjfLYSQ+GogEJqQjvxkQ
	 U1xV0NjOgOcTtUR77v3BQckA1+3j+d4ohT6UFXW57tvOxLlCG2QJPUn48WBG8jf/hy
	 8rq4xA/LilTrr1EAnDwJd1hRHv8uXUmNEfWoIMc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 135/156] wifi: iwlwifi: mvm: Fix __counted_by usage in cfg80211_wowlan_nd_*
Date: Mon,  6 Jan 2025 16:17:01 +0100
Message-ID: <20250106151146.817477004@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

commit cc0c53f4fac562efb3aca2bc493515e77642ae33 upstream.

Both struct cfg80211_wowlan_nd_match and struct cfg80211_wowlan_nd_info
pre-allocate space for channels and matches, but then may end up using
fewer that the full allocation. Shrink the associated counter
(n_channels and n_matches) after counting the results. This avoids
compile-time (and run-time) warnings from __counted_by. (The counter
member needs to be updated _before_ accessing the array index.)

Seen with coming GCC 15:

drivers/net/wireless/intel/iwlwifi/mvm/d3.c: In function 'iwl_mvm_query_set_freqs':
drivers/net/wireless/intel/iwlwifi/mvm/d3.c:2877:66: warning: operation on 'match->n_channels' may be undefined [-Wsequence-point]
 2877 |                                 match->channels[match->n_channels++] =
      |                                                 ~~~~~~~~~~~~~~~~~^~
drivers/net/wireless/intel/iwlwifi/mvm/d3.c:2885:66: warning: operation on 'match->n_channels' may be undefined [-Wsequence-point]
 2885 |                                 match->channels[match->n_channels++] =
      |                                                 ~~~~~~~~~~~~~~~~~^~
drivers/net/wireless/intel/iwlwifi/mvm/d3.c: In function 'iwl_mvm_query_netdetect_reasons':
drivers/net/wireless/intel/iwlwifi/mvm/d3.c:2982:58: warning: operation on 'net_detect->n_matches' may be undefined [-Wsequence-point]
 2982 |                 net_detect->matches[net_detect->n_matches++] = match;
      |                                     ~~~~~~~~~~~~~~~~~~~~~^~

Cc: stable@vger.kernel.org
Fixes: aa4ec06c455d ("wifi: cfg80211: use __counted_by where appropriate")
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://patch.msgid.link/20240619211233.work.355-kees@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2871,6 +2871,7 @@ static void iwl_mvm_query_set_freqs(stru
 				    int idx)
 {
 	int i;
+	int n_channels = 0;
 
 	if (fw_has_api(&mvm->fw->ucode_capa,
 		       IWL_UCODE_TLV_API_SCAN_OFFLOAD_CHANS)) {
@@ -2879,7 +2880,7 @@ static void iwl_mvm_query_set_freqs(stru
 
 		for (i = 0; i < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN * 8; i++)
 			if (matches[idx].matching_channels[i / 8] & (BIT(i % 8)))
-				match->channels[match->n_channels++] =
+				match->channels[n_channels++] =
 					mvm->nd_channels[i]->center_freq;
 	} else {
 		struct iwl_scan_offload_profile_match_v1 *matches =
@@ -2887,9 +2888,11 @@ static void iwl_mvm_query_set_freqs(stru
 
 		for (i = 0; i < SCAN_OFFLOAD_MATCHING_CHANNELS_LEN_V1 * 8; i++)
 			if (matches[idx].matching_channels[i / 8] & (BIT(i % 8)))
-				match->channels[match->n_channels++] =
+				match->channels[n_channels++] =
 					mvm->nd_channels[i]->center_freq;
 	}
+	/* We may have ended up with fewer channels than we allocated. */
+	match->n_channels = n_channels;
 }
 
 /**
@@ -2970,6 +2973,8 @@ static void iwl_mvm_query_netdetect_reas
 			     GFP_KERNEL);
 	if (!net_detect || !n_matches)
 		goto out_report_nd;
+	net_detect->n_matches = n_matches;
+	n_matches = 0;
 
 	for_each_set_bit(i, &matched_profiles, mvm->n_nd_match_sets) {
 		struct cfg80211_wowlan_nd_match *match;
@@ -2983,8 +2988,9 @@ static void iwl_mvm_query_netdetect_reas
 				GFP_KERNEL);
 		if (!match)
 			goto out_report_nd;
+		match->n_channels = n_channels;
 
-		net_detect->matches[net_detect->n_matches++] = match;
+		net_detect->matches[n_matches++] = match;
 
 		/* We inverted the order of the SSIDs in the scan
 		 * request, so invert the index here.
@@ -2999,6 +3005,8 @@ static void iwl_mvm_query_netdetect_reas
 
 		iwl_mvm_query_set_freqs(mvm, d3_data->nd_results, match, i);
 	}
+	/* We may have fewer matches than we allocated. */
+	net_detect->n_matches = n_matches;
 
 out_report_nd:
 	wakeup.net_detect = net_detect;


