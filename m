Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AAA14263
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giMIwbhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D00BC433C8;
	Mon, 23 Oct 2023 11:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059351;
	bh=qeesca6EtELJlz/QtnlmN5QKFNThm0MQIkqT8/0Lx/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giMIwbhDFb1n0Yk/BjljUwXjDy69h+u3yjSfu5EhMc1ZmYOBqxPYTM9OkPDhWlsaK
	 TBNBPqph3Y5pcqNcS8KPeIFpVLh0Q3//A2Y5JxV9eYdNGaf+8WNsfvm/s/74UAAs2b
	 l30TDTORZt4fVCoPVGoSwQ3pnp6QJM1v0dRpJ2jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 122/241] wifi: mac80211: work around Cisco AP 9115 VHT MPDU length
Date: Mon, 23 Oct 2023 12:55:08 +0200
Message-ID: <20231023104836.851391610@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 084cf2aeca97566db4fa15d55653c1cba2db83ed ]

Cisco AP module 9115 with FW 17.3 has a bug and sends a too
large maximum MPDU length in the association response
(indicating 12k) that it cannot actually process.

Work around that by taking the minimum between what's in the
association response and the BSS elements (from beacon or
probe response).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230918140607.d1966a9a532e.I090225babb7cd4d1081ee9acd40e7de7e41c15ae@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c         |  3 ++-
 net/mac80211/ibss.c        |  2 +-
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mesh_plink.c  |  2 +-
 net/mac80211/mlme.c        | 27 +++++++++++++++++++++++++--
 net/mac80211/vht.c         | 16 ++++++++++++++--
 6 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e883c41a2163b..0e3a1753a51c6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1860,7 +1860,8 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 	/* VHT can override some HT caps such as the A-MSDU max length */
 	if (params->vht_capa)
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
-						    params->vht_capa, link_sta);
+						    params->vht_capa, NULL,
+						    link_sta);
 
 	if (params->he_capa)
 		ieee80211_he_cap_ie_to_sta_he_cap(sdata, sband,
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index e1900077bc4b9..5542c93edfba0 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1072,7 +1072,7 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
 						   &chandef);
 			memcpy(&cap_ie, elems->vht_cap_elem, sizeof(cap_ie));
 			ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
-							    &cap_ie,
+							    &cap_ie, NULL,
 							    &sta->deflink);
 			if (memcmp(&cap, &sta->sta.deflink.vht_cap, sizeof(cap)))
 				rates_updated |= true;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f8cd94ba55ccc..2cce9eba6a120 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2142,6 +2142,7 @@ void
 ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_supported_band *sband,
 				    const struct ieee80211_vht_cap *vht_cap_ie,
+				    const struct ieee80211_vht_cap *vht_cap_ie2,
 				    struct link_sta_info *link_sta);
 enum ieee80211_sta_rx_bandwidth
 ieee80211_sta_cap_rx_bw(struct link_sta_info *link_sta);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index f3d5bb0a59f10..a1e526419e9d2 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -451,7 +451,7 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 		changed |= IEEE80211_RC_BW_CHANGED;
 
 	ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
-					    elems->vht_cap_elem,
+					    elems->vht_cap_elem, NULL,
 					    &sta->deflink);
 
 	ieee80211_he_cap_ie_to_sta_he_cap(sdata, sband, elems->he_cap,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 24b2833e0e475..0c9198997482b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4202,10 +4202,33 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 						  elems->ht_cap_elem,
 						  link_sta);
 
-	if (elems->vht_cap_elem && !(link->u.mgd.conn_flags & IEEE80211_CONN_DISABLE_VHT))
+	if (elems->vht_cap_elem &&
+	    !(link->u.mgd.conn_flags & IEEE80211_CONN_DISABLE_VHT)) {
+		const struct ieee80211_vht_cap *bss_vht_cap = NULL;
+		const struct cfg80211_bss_ies *ies;
+
+		/*
+		 * Cisco AP module 9115 with FW 17.3 has a bug and sends a
+		 * too large maximum MPDU length in the association response
+		 * (indicating 12k) that it cannot actually process ...
+		 * Work around that.
+		 */
+		rcu_read_lock();
+		ies = rcu_dereference(cbss->ies);
+		if (ies) {
+			const struct element *elem;
+
+			elem = cfg80211_find_elem(WLAN_EID_VHT_CAPABILITY,
+						  ies->data, ies->len);
+			if (elem && elem->datalen >= sizeof(*bss_vht_cap))
+				bss_vht_cap = (const void *)elem->data;
+		}
+
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
 						    elems->vht_cap_elem,
-						    link_sta);
+						    bss_vht_cap, link_sta);
+		rcu_read_unlock();
+	}
 
 	if (elems->he_operation && !(link->u.mgd.conn_flags & IEEE80211_CONN_DISABLE_HE) &&
 	    elems->he_cap) {
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index c1250aa478083..b3a5c3e96a720 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -4,7 +4,7 @@
  *
  * Portions of this file
  * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
- * Copyright (C) 2018 - 2022 Intel Corporation
+ * Copyright (C) 2018 - 2023 Intel Corporation
  */
 
 #include <linux/ieee80211.h>
@@ -116,12 +116,14 @@ void
 ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_supported_band *sband,
 				    const struct ieee80211_vht_cap *vht_cap_ie,
+				    const struct ieee80211_vht_cap *vht_cap_ie2,
 				    struct link_sta_info *link_sta)
 {
 	struct ieee80211_sta_vht_cap *vht_cap = &link_sta->pub->vht_cap;
 	struct ieee80211_sta_vht_cap own_cap;
 	u32 cap_info, i;
 	bool have_80mhz;
+	u32 mpdu_len;
 
 	memset(vht_cap, 0, sizeof(*vht_cap));
 
@@ -317,11 +319,21 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 
 	link_sta->pub->bandwidth = ieee80211_sta_cur_vht_bw(link_sta);
 
+	/*
+	 * Work around the Cisco 9115 FW 17.3 bug by taking the min of
+	 * both reported MPDU lengths.
+	 */
+	mpdu_len = vht_cap->cap & IEEE80211_VHT_CAP_MAX_MPDU_MASK;
+	if (vht_cap_ie2)
+		mpdu_len = min_t(u32, mpdu_len,
+				 le32_get_bits(vht_cap_ie2->vht_cap_info,
+					       IEEE80211_VHT_CAP_MAX_MPDU_MASK));
+
 	/*
 	 * FIXME - should the amsdu len be per link? store per link
 	 * and maintain a minimum?
 	 */
-	switch (vht_cap->cap & IEEE80211_VHT_CAP_MAX_MPDU_MASK) {
+	switch (mpdu_len) {
 	case IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454:
 		link_sta->pub->agg.max_amsdu_len = IEEE80211_MAX_MPDU_LEN_VHT_11454;
 		break;
-- 
2.40.1



