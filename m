Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7827018A6D6;
	Tue, 30 Jul 2024 17:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359631; cv=none; b=XXNt2Ag2/zLewsdstRr67VI2CfSK6lXp+SZxU8qQs0ILTnsmtnpMRTuax2USZzHdicK4oV1DaO0yTdMmCcY/EiaGJuIvQ7eOFxrEBR+ycd0/sW0dflTg+VH/OkpTGRODhCADiKgE3cINNGiD9Z2i0sSi6qzTOml04PDxoSjptcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359631; c=relaxed/simple;
	bh=GIn5jxpjhwR81L265Vkn80WcqaHgOQb28lnvyP0PNjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keL5ornrwMfXkV+VkfEX8p9O0mXYfvGJR0/XzYD0MI3zocvO24twCmG0Op9XTUBZr0q6YaCNS+zFA5w8dxDS5eVgwpdxABmbu8FsSvfRhRaZHSwikjarlRHOd0/EiwpFZjk0gJmNEIl+i5yjvJwnEYYtNJlpd4NmAdB1ZMr36o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rg1rQVHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rg1rQVHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EFAC32782;
	Tue, 30 Jul 2024 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359631;
	bh=GIn5jxpjhwR81L265Vkn80WcqaHgOQb28lnvyP0PNjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rg1rQVHhDSEs00mLmIms1lVTOXMQFpM7DXlenBp2pwdG7+9uMJcOoM2m+Tsgkv+Uw
	 teNSXNcS2CXtZ4E3Z5VT6UUUgGPo15A5LLshXtseucNK8s1aWyDuEF3smhLiuL0I2U
	 5h8Z3GZom6gkk1u0C5hU7gao2VSiDHLTcdAvBQKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6.6 511/568] wifi: mac80211: track capability/opmode NSS separately
Date: Tue, 30 Jul 2024 17:50:18 +0200
Message-ID: <20240730151659.996531707@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit a8bca3e9371dc5e276af4168be099b2a05554c2a upstream.

We're currently tracking rx_nss for each station, and that
is meant to be initialized to the capability NSS and later
reduced by the operating mode notification NSS.

However, we're mixing up capabilities and operating mode
NSS in the same variable. This forces us to recalculate
the NSS capability on operating mode notification RX,
which is a bit strange; due to the previous fix I had to
never keep rx_nss as zero, it also means that the capa is
never taken into account properly.

Fix all this by storing the capability value, that can be
recalculated unconditionally whenever needed, and storing
the operating mode notification NSS separately, taking it
into account when assigning the final rx_nss value.

Cc: stable@vger.kernel.org
Fixes: dd6c064cfc3f ("wifi: mac80211: set station RX-NSS on reconfig")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240228120157.0e1c41924d1d.I0acaa234e0267227b7e3ef81a59117c8792116bc@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[Fixed trivial merge conflict in copyright year net/mac80211/sta_info.h]
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c         |    2 -
 net/mac80211/ieee80211_i.h |    2 -
 net/mac80211/rate.c        |    2 -
 net/mac80211/sta_info.h    |    6 ++++-
 net/mac80211/vht.c         |   46 +++++++++++++++++++++------------------------
 5 files changed, 30 insertions(+), 28 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1887,7 +1887,7 @@ static int sta_link_apply_parameters(str
 					      sband->band);
 	}
 
-	ieee80211_sta_set_rx_nss(link_sta);
+	ieee80211_sta_init_nss(link_sta);
 
 	return ret;
 }
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2150,7 +2150,7 @@ enum ieee80211_sta_rx_bandwidth
 ieee80211_sta_cap_rx_bw(struct link_sta_info *link_sta);
 enum ieee80211_sta_rx_bandwidth
 ieee80211_sta_cur_vht_bw(struct link_sta_info *link_sta);
-void ieee80211_sta_set_rx_nss(struct link_sta_info *link_sta);
+void ieee80211_sta_init_nss(struct link_sta_info *link_sta);
 enum ieee80211_sta_rx_bandwidth
 ieee80211_chan_width_to_rx_bw(enum nl80211_chan_width width);
 enum nl80211_chan_width
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -37,7 +37,7 @@ void rate_control_rate_init(struct sta_i
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 
-	ieee80211_sta_set_rx_nss(&sta->deflink);
+	ieee80211_sta_init_nss(&sta->deflink);
 
 	if (!ref)
 		return;
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -3,7 +3,7 @@
  * Copyright 2002-2005, Devicescape Software, Inc.
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
- * Copyright(c) 2020-2022 Intel Corporation
+ * Copyright(c) 2020-2024 Intel Corporation
  */
 
 #ifndef STA_INFO_H
@@ -485,6 +485,8 @@ struct ieee80211_fragment_cache {
  *	same for non-MLD STA. This is used as key for searching link STA
  * @link_id: Link ID uniquely identifying the link STA. This is 0 for non-MLD
  *	and set to the corresponding vif LinkId for MLD STA
+ * @op_mode_nss: NSS limit as set by operating mode notification, or 0
+ * @capa_nss: NSS limit as determined by local and peer capabilities
  * @link_hash_node: hash node for rhashtable
  * @sta: Points to the STA info
  * @gtk: group keys negotiated with this station, if any
@@ -521,6 +523,8 @@ struct link_sta_info {
 	u8 addr[ETH_ALEN];
 	u8 link_id;
 
+	u8 op_mode_nss, capa_nss;
+
 	struct rhlist_head link_hash_node;
 
 	struct sta_info *sta;
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -4,7 +4,7 @@
  *
  * Portions of this file
  * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
- * Copyright (C) 2018 - 2023 Intel Corporation
+ * Copyright (C) 2018 - 2024 Intel Corporation
  */
 
 #include <linux/ieee80211.h>
@@ -541,15 +541,11 @@ ieee80211_sta_cur_vht_bw(struct link_sta
 	return bw;
 }
 
-void ieee80211_sta_set_rx_nss(struct link_sta_info *link_sta)
+void ieee80211_sta_init_nss(struct link_sta_info *link_sta)
 {
 	u8 ht_rx_nss = 0, vht_rx_nss = 0, he_rx_nss = 0, eht_rx_nss = 0, rx_nss;
 	bool support_160;
 
-	/* if we received a notification already don't overwrite it */
-	if (link_sta->pub->rx_nss)
-		return;
-
 	if (link_sta->pub->eht_cap.has_eht) {
 		int i;
 		const u8 *rx_nss_mcs = (void *)&link_sta->pub->eht_cap.eht_mcs_nss_supp;
@@ -627,7 +623,15 @@ void ieee80211_sta_set_rx_nss(struct lin
 	rx_nss = max(vht_rx_nss, ht_rx_nss);
 	rx_nss = max(he_rx_nss, rx_nss);
 	rx_nss = max(eht_rx_nss, rx_nss);
-	link_sta->pub->rx_nss = max_t(u8, 1, rx_nss);
+	rx_nss = max_t(u8, 1, rx_nss);
+	link_sta->capa_nss = rx_nss;
+
+	/* that shouldn't be set yet, but we can handle it anyway */
+	if (link_sta->op_mode_nss)
+		link_sta->pub->rx_nss =
+			min_t(u8, rx_nss, link_sta->op_mode_nss);
+	else
+		link_sta->pub->rx_nss = rx_nss;
 }
 
 u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
@@ -637,7 +641,7 @@ u32 __ieee80211_vht_handle_opmode(struct
 	enum ieee80211_sta_rx_bandwidth new_bw;
 	struct sta_opmode_info sta_opmode = {};
 	u32 changed = 0;
-	u8 nss, cur_nss;
+	u8 nss;
 
 	/* ignore - no support for BF yet */
 	if (opmode & IEEE80211_OPMODE_NOTIF_RX_NSS_TYPE_BF)
@@ -647,23 +651,17 @@ u32 __ieee80211_vht_handle_opmode(struct
 	nss >>= IEEE80211_OPMODE_NOTIF_RX_NSS_SHIFT;
 	nss += 1;
 
-	if (link_sta->pub->rx_nss != nss) {
-		cur_nss = link_sta->pub->rx_nss;
-		/* Reset rx_nss and call ieee80211_sta_set_rx_nss() which
-		 * will set the same to max nss value calculated based on capability.
-		 */
-		link_sta->pub->rx_nss = 0;
-		ieee80211_sta_set_rx_nss(link_sta);
-		/* Do not allow an nss change to rx_nss greater than max_nss
-		 * negotiated and capped to APs capability during association.
-		 */
-		if (nss <= link_sta->pub->rx_nss) {
-			link_sta->pub->rx_nss = nss;
-			sta_opmode.rx_nss = nss;
-			changed |= IEEE80211_RC_NSS_CHANGED;
-			sta_opmode.changed |= STA_OPMODE_N_SS_CHANGED;
+	if (link_sta->op_mode_nss != nss) {
+		if (nss <= link_sta->capa_nss) {
+			link_sta->op_mode_nss = nss;
+
+			if (nss != link_sta->pub->rx_nss) {
+				link_sta->pub->rx_nss = nss;
+				changed |= IEEE80211_RC_NSS_CHANGED;
+				sta_opmode.rx_nss = link_sta->pub->rx_nss;
+				sta_opmode.changed |= STA_OPMODE_N_SS_CHANGED;
+			}
 		} else {
-			link_sta->pub->rx_nss = cur_nss;
 			pr_warn_ratelimited("Ignoring NSS change in VHT Operating Mode Notification from %pM with invalid nss %d",
 					    link_sta->pub->addr, nss);
 		}


