Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A9B15ACB
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNkWgV/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8CAC433CA;
	Mon, 23 Oct 2023 11:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060335;
	bh=bYj9fRVFkj9WjCM/wwqVppLvRzJGI11Bar5q2KjuVL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNkWgV/Ul0ueSChc2XQj/GYY3hwGcyZgG5CvwN7ZCPQ2fbVx4XTdAQqe/hcT4/wAf
	 pmoMxWWqUb3YPeqw7Ovzv5CJPBYWZ91rsWzVeloowATleIVgfSZIgQ2Puz+Ok/5bs+
	 1MAq7U4bTSWGCFQs4bOS+VmKhCCA6VGGeNps0XF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/196] wifi: mac80211: work around Cisco AP 9115 VHT MPDU length
Date: Mon, 23 Oct 2023 12:56:16 +0200
Message-ID: <20231023104831.662581089@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0167413d56972..ee9f455bb2d18 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1748,7 +1748,8 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 	/* VHT can override some HT caps such as the A-MSDU max length */
 	if (params->vht_capa)
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
-						    params->vht_capa, link_sta);
+						    params->vht_capa, NULL,
+						    link_sta);
 
 	if (params->he_capa)
 		ieee80211_he_cap_ie_to_sta_he_cap(sdata, sband,
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 9dffc30795887..79d2c55052897 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1068,7 +1068,7 @@ static void ieee80211_update_sta_info(struct ieee80211_sub_if_data *sdata,
 						   &chandef);
 			memcpy(&cap_ie, elems->vht_cap_elem, sizeof(cap_ie));
 			ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
-							    &cap_ie,
+							    &cap_ie, NULL,
 							    &sta->deflink);
 			if (memcmp(&cap, &sta->sta.deflink.vht_cap, sizeof(cap)))
 				rates_updated |= true;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 27479bbb093ac..99a976ea17498 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2062,6 +2062,7 @@ void
 ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_supported_band *sband,
 				    const struct ieee80211_vht_cap *vht_cap_ie,
+				    const struct ieee80211_vht_cap *vht_cap_ie2,
 				    struct link_sta_info *link_sta);
 enum ieee80211_sta_rx_bandwidth
 ieee80211_sta_cap_rx_bw(struct link_sta_info *link_sta);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index ddfe5102b9a43..bd0b7c189adfa 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -443,7 +443,7 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 		changed |= IEEE80211_RC_BW_CHANGED;
 
 	ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
-					    elems->vht_cap_elem,
+					    elems->vht_cap_elem, NULL,
 					    &sta->deflink);
 
 	ieee80211_he_cap_ie_to_sta_he_cap(sdata, sband, elems->he_cap,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dc9e7eb7dd857..c07645c999f9a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4083,10 +4083,33 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
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
index 803de58814852..f7526be8a1c7e 100644
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



