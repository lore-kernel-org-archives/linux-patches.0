Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CF14E77EC;
	Thu, 17 Sep 2026 16:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664233; cv=none; b=Ou6X1CI2SQAQdZ9kKs7Q4vuok08v96H+bTZQOkYYXbaCxXiaKPumOM8WxxK/wOMLgXO8UIZiFJDlZUYckCmO70GMe/fzAx47dhOWTWLovcxE+iOFKVSfNYXX6R94sUDMMWxX9ETIClBAWgMQQOKURbtIxR0LEoGSSDIj/Ek5PCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664233; c=relaxed/simple;
	bh=+RnPV8YJLpb2sTlSBOShZyiGXJFSG2YCra46/R7+nrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ctr/IJxR9bTrGN7+J63eeRDBjcupo5gJQI1nUEGkqIAuJniACHTw9mYtsOQQ6ggTbZFfFCA9AHRuNo8aj/5zUcunWHgmcWtz29l8YheRjWZEalwgrfB9VaeODIuN66T20NjzVtZ3gzwDte+oB1Tk9+agTUCYLRs12JEq/BW4VVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAbTeY0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAbTeY0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772F51F00893;
	Thu, 17 Sep 2026 16:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664232;
	bh=7xIrenKHTfUsbwnZcTKOZ3TtzgVKvo0XFwAwj2eOK94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zAbTeY0x89iJlgHXBZwUg7Qvw4P86mBGxIxxZAJBh3RmSVWhyQZqgMBi+pwXlsA10
	 1Pl8UcxcL4fzMb8IaCKm3GoogX7jUCCeI3+Pz6kcFatj+lLSjf7KIZkJudzZfIipmB
	 cXNawSgTuKbZm70hLrQDHn1n4HgYqFw+xhMtFjAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0304/1250] wifi: mac80211: clarify beacon parsing with MBSSID/EMA
Date: Thu, 17 Sep 2026 16:01:39 +0100
Message-ID: <20260917151600.354025328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 32e223198539bd8be5a84764df869f88bc56f25b ]

When connected to a non-transmitting BSS of multiple BSSID
set with EMA, the correct profile for the connection isn't
always present in the beacon. Indicate this in the parser
and use the information to not check everything in beacon
processing, since the information might not be correct if
taken only from the transmitted BSS.

Link: https://patch.msgid.link/20260529102644.97527a7dfd7b.Iecd0ef578b85a5a0057538cfff5fdff41d19b7ea@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h |  9 +++++
 net/mac80211/mlme.c        | 83 ++++++++++++++++++++++++++++----------
 net/mac80211/parse.c       |  4 ++
 3 files changed, 75 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5c0c833fcf7a9..b0e64cf346e2b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1864,6 +1864,15 @@ struct ieee802_11_elems {
 	struct ieee80211_mle_per_sta_profile *prof;
 	size_t sta_prof_len;
 
+	/*
+	 * When parsing the beacon with MBSSID (from a transmitted BSS), this
+	 * indicates that the profile the parser was instructed to look for
+	 * (via the bss value in &struct ieee80211_elems_parse_params) couldn't
+	 * be found (due to EMA, or perhaps broken AP) and the result cannot be
+	 * considered complete.
+	 */
+	bool mbssid_nontx_profile_missing;
+
 	/* whether/which parse error occurred while retrieving these elements */
 	u8 parse_error;
 };
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8d782c8782f98..40283b0951d27 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7400,8 +7400,6 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 	struct link_sta_info *link_sta;
 	struct sta_info *sta;
 	u64 changed = 0;
-	bool erp_valid;
-	u8 erp_value = 0;
 	u32 ncrc = 0;
 	u8 *bssid, *variable = mgmt->u.beacon.variable;
 	u8 deauth_buf[IEEE80211_DEAUTH_FRAME_LEN];
@@ -7521,6 +7519,13 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 	if (!elems)
 		return;
 
+	/*
+	 * Note: with MBSSID and an EMA (or broken) AP, we could fail to find
+	 * the correct multi-BSSID profile for the non-transmitting AP we're
+	 * connected to. The result's elems->mbssid_nontx_profile_missing is
+	 * indicating that, but some things must happen regardless.
+	 */
+
 	if (rx_status->flag & RX_FLAG_DECRYPTED &&
 	    ieee80211_mgd_ssid_mismatch(sdata, elems)) {
 		sdata_info(sdata, "SSID mismatch for AP %pM, disconnect\n",
@@ -7556,6 +7561,11 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 		}
 	}
 
+	/*
+	 * P2P will almost certainly not have MBSSID, but this just
+	 * assumes that it would at least always inherit NoA anyway
+	 * since it's absent from the channel.
+	 */
 	if (sdata->vif.p2p ||
 	    sdata->vif.driver_flags & IEEE80211_VIF_GET_NOA_UPDATE) {
 		struct ieee80211_p2p_noa_attr noa = {};
@@ -7613,23 +7623,17 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 
 	ieee80211_rx_bss_info(link, mgmt, len, rx_status);
 
+	/*
+	 * This assumes that all members of a multiple BSS set must be
+	 * switching together, so we can parse channel switch elements
+	 * from the transmitted BSS even if our non-transmitted one is
+	 * not present in this beacon (due to EMA.)
+	 */
 	ieee80211_sta_process_chanswitch(link, rx_status->mactime,
 					 rx_status->device_timestamp,
 					 elems, elems,
 					 IEEE80211_CSA_SOURCE_BEACON);
 
-	/* note that after this elems->ml_basic can no longer be used fully */
-	ieee80211_mgd_check_cross_link_csa(sdata, rx_status->link_id, elems);
-
-	ieee80211_mgd_update_bss_param_ch_cnt(sdata, bss_conf, elems);
-
-	if (!sdata->u.mgd.epcs.enabled &&
-	    !link->u.mgd.disable_wmm_tracking &&
-	    ieee80211_sta_wmm_params(local, link, elems->wmm_param,
-				     elems->wmm_param_len,
-				     elems->mu_edca_param_set))
-		changed |= BSS_CHANGED_QOS;
-
 	/*
 	 * If we haven't had a beacon before, tell the driver about the
 	 * DTIM period (and beacon timing if desired) now.
@@ -7646,17 +7650,53 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 		ieee80211_recalc_ps_vif(sdata);
 	}
 
-	if (elems->erp_info) {
-		erp_valid = true;
-		erp_value = elems->erp_info[0];
-	} else {
-		erp_valid = false;
-	}
+	/* RNR isn't inside an MBSSID profile */
+	ieee80211_mgd_update_bss_param_ch_cnt(sdata, bss_conf, elems);
+
+	/* assume ERP would be inherited anyway */
+	if (!ieee80211_is_s1g_beacon(hdr->frame_control)) {
+		u8 erp_value = 0;
+		bool erp_valid;
+
+		if (elems->erp_info) {
+			erp_valid = true;
+			erp_value = elems->erp_info[0];
+		} else {
+			erp_valid = false;
+		}
 
-	if (!ieee80211_is_s1g_beacon(hdr->frame_control))
 		changed |= ieee80211_handle_bss_capability(link,
 				le16_to_cpu(mgmt->u.beacon.capab_info),
 				erp_valid, erp_value);
+	}
+
+	/*
+	 * There are some other things that we can only do when the
+	 * real non-transmitted profile was actually parsed, so exit
+	 * here before doing those.
+	 */
+	if (elems->mbssid_nontx_profile_missing)
+		goto apply;
+
+	/*
+	 * This requires multi-link element, which is from the MBSSID profile.
+	 * Note that after this elems->ml_basic can no longer be used fully.
+	 *
+	 * Note also that currently the parsing is incorrect, so this will
+	 * never actually do anything.
+	 */
+	ieee80211_mgd_check_cross_link_csa(sdata, rx_status->link_id, elems);
+
+	/*
+	 * EDCA parameters should be the same, but perhaps ACM can differ
+	 * between BSSes in an MBSSID set.
+	 */
+	if (!sdata->u.mgd.epcs.enabled &&
+	    !link->u.mgd.disable_wmm_tracking &&
+	    ieee80211_sta_wmm_params(local, link, elems->wmm_param,
+				     elems->wmm_param_len,
+				     elems->mu_edca_param_set))
+		changed |= BSS_CHANGED_QOS;
 
 	sta = sta_info_get(sdata, sdata->vif.cfg.ap_addr);
 	if (WARN_ON(!sta)) {
@@ -7702,6 +7742,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 	ieee80211_process_adv_ttlm(sdata, elems,
 				      le64_to_cpu(mgmt->u.beacon.timestamp));
 
+apply:
 	ieee80211_link_info_change_notify(sdata, link, changed);
 free:
 	kfree(elems);
diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index b9ec99f51851a..b117572f8cb17 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -1032,6 +1032,10 @@ ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params)
 		sub.action = params->action;
 		sub.link_id = params->link_id;
 
+		/* indicate to consumer whether or not profile was found */
+		if (params->bss->transmitted_bss && !nontx_len)
+			elems->mbssid_nontx_profile_missing = true;
+
 		/* consume the space used for non-transmitted profile */
 		elems_parse->scratch_pos += nontx_len;
 
-- 
2.53.0



