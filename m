Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F75512C46D;
	Tue, 30 Apr 2024 10:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474039; cv=none; b=NE/v/HbLyGsuRWfHsFWf25RaSRlV3Si018V7S5X9LkcEhKrl7Y6eFc41E1Q9taHP5W7cTfl/fYl7LO1W8wmM16yMFQfgZD7dhqDr+LIfTfaCk78s/NJvnqZnPqADxe4rnqsvQkVyT88LpovjSzsLqotuJ50y39cTc55hBDZR5fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474039; c=relaxed/simple;
	bh=lsxcGM3wgK67IrGRXznTQUkd32gZsh3gCstpeZWV38U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2U68ZS92uuUVRnIe+L79guy9ip7ydLjYYD1eDesnIrfTD24CUEpx838UtED+J+1OLbcPh/4RJ7kaVotPbFKZv8stHuENUk5gWSVR7rOVI5vVy3/rblLp18OYk3LQny9yi591WR/5JnPySpYAob/MDggkZ/OSbrN7OIuyGSahz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2wcr7lb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2wcr7lb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37805C2BBFC;
	Tue, 30 Apr 2024 10:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474038;
	bh=lsxcGM3wgK67IrGRXznTQUkd32gZsh3gCstpeZWV38U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2wcr7lbSPtC2iz3sgv17Kouu/w4+0P9Tg5box9v+cLkYNbsffFjtk469IDG52yxx
	 /mFumOLwpzNwdioNcyAs/FAnUseMM1+BoXz8Z/QOhHy0iRsFGCgQj1ufOqJgRd6vVI
	 tuTE8Mnmk20bUOyDS/Ed/Nms7+ECBN4k0s4LKfuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 041/228] wifi: mac80211: split mesh fast tx cache into local/proxied/forwarded
Date: Tue, 30 Apr 2024 12:36:59 +0200
Message-ID: <20240430103104.999428973@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 8c75cdcdf869acabfdc7858827099dcde9f24e6c ]

Depending on the origin of the packets (and their SA), 802.11 + mesh headers
could be filled in differently. In order to properly deal with that, add a
new field to the lookup key, indicating the type (local, proxied or
forwarded). This can fix spurious packet drop issues that depend on the order
in which nodes/hosts communicate with each other.

Fixes: d5edb9ae8d56 ("wifi: mac80211: mesh fast xmit support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://msgid.link/20240415121811.13391-1-nbd@nbd.name
[use sizeof_field() for key_len]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh.c         |  8 +++++++-
 net/mac80211/mesh.h         | 36 +++++++++++++++++++++++++++++++++---
 net/mac80211/mesh_pathtbl.c | 31 ++++++++++++++++++++++---------
 net/mac80211/rx.c           | 13 ++++++++++---
 4 files changed, 72 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index fccbcde3359af..3d4806b7ff6c4 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -769,6 +769,9 @@ bool ieee80211_mesh_xmit_fast(struct ieee80211_sub_if_data *sdata,
 			      struct sk_buff *skb, u32 ctrl_flags)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct ieee80211_mesh_fast_tx_key key = {
+		.type = MESH_FAST_TX_TYPE_LOCAL
+	};
 	struct ieee80211_mesh_fast_tx *entry;
 	struct ieee80211s_hdr *meshhdr;
 	u8 sa[ETH_ALEN] __aligned(2);
@@ -804,7 +807,10 @@ bool ieee80211_mesh_xmit_fast(struct ieee80211_sub_if_data *sdata,
 			return false;
 	}
 
-	entry = mesh_fast_tx_get(sdata, skb->data);
+	ether_addr_copy(key.addr, skb->data);
+	if (!ether_addr_equal(skb->data + ETH_ALEN, sdata->vif.addr))
+		key.type = MESH_FAST_TX_TYPE_PROXIED;
+	entry = mesh_fast_tx_get(sdata, &key);
 	if (!entry)
 		return false;
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index ad8469293d712..58c619874ca6a 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -133,10 +133,39 @@ struct mesh_path {
 #define MESH_FAST_TX_CACHE_THRESHOLD_SIZE	384
 #define MESH_FAST_TX_CACHE_TIMEOUT		8000 /* msecs */
 
+/**
+ * enum ieee80211_mesh_fast_tx_type - cached mesh fast tx entry type
+ *
+ * @MESH_FAST_TX_TYPE_LOCAL: tx from the local vif address as SA
+ * @MESH_FAST_TX_TYPE_PROXIED: local tx with a different SA (e.g. bridged)
+ * @MESH_FAST_TX_TYPE_FORWARDED: forwarded from a different mesh point
+ * @NUM_MESH_FAST_TX_TYPE: number of entry types
+ */
+enum ieee80211_mesh_fast_tx_type {
+	MESH_FAST_TX_TYPE_LOCAL,
+	MESH_FAST_TX_TYPE_PROXIED,
+	MESH_FAST_TX_TYPE_FORWARDED,
+
+	/* must be last */
+	NUM_MESH_FAST_TX_TYPE
+};
+
+
+/**
+ * struct ieee80211_mesh_fast_tx_key - cached mesh fast tx entry key
+ *
+ * @addr: The Ethernet DA for this entry
+ * @type: cache entry type
+ */
+struct ieee80211_mesh_fast_tx_key {
+	u8 addr[ETH_ALEN] __aligned(2);
+	u16 type;
+};
+
 /**
  * struct ieee80211_mesh_fast_tx - cached mesh fast tx entry
  * @rhash: rhashtable pointer
- * @addr_key: The Ethernet DA which is the key for this entry
+ * @key: the lookup key for this cache entry
  * @fast_tx: base fast_tx data
  * @hdr: cached mesh and rfc1042 headers
  * @hdrlen: length of mesh + rfc1042
@@ -147,7 +176,7 @@ struct mesh_path {
  */
 struct ieee80211_mesh_fast_tx {
 	struct rhash_head rhash;
-	u8 addr_key[ETH_ALEN] __aligned(2);
+	struct ieee80211_mesh_fast_tx_key key;
 
 	struct ieee80211_fast_tx fast_tx;
 	u8 hdr[sizeof(struct ieee80211s_hdr) + sizeof(rfc1042_header)];
@@ -333,7 +362,8 @@ void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata);
 
 bool mesh_action_is_path_sel(struct ieee80211_mgmt *mgmt);
 struct ieee80211_mesh_fast_tx *
-mesh_fast_tx_get(struct ieee80211_sub_if_data *sdata, const u8 *addr);
+mesh_fast_tx_get(struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_mesh_fast_tx_key *key);
 bool ieee80211_mesh_xmit_fast(struct ieee80211_sub_if_data *sdata,
 			      struct sk_buff *skb, u32 ctrl_flags);
 void mesh_fast_tx_cache(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 91b55d6a68b97..a6b62169f0848 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -37,8 +37,8 @@ static const struct rhashtable_params mesh_rht_params = {
 static const struct rhashtable_params fast_tx_rht_params = {
 	.nelem_hint = 10,
 	.automatic_shrinking = true,
-	.key_len = ETH_ALEN,
-	.key_offset = offsetof(struct ieee80211_mesh_fast_tx, addr_key),
+	.key_len = sizeof_field(struct ieee80211_mesh_fast_tx, key),
+	.key_offset = offsetof(struct ieee80211_mesh_fast_tx, key),
 	.head_offset = offsetof(struct ieee80211_mesh_fast_tx, rhash),
 	.hashfn = mesh_table_hash,
 };
@@ -431,20 +431,21 @@ static void mesh_fast_tx_entry_free(struct mesh_tx_cache *cache,
 }
 
 struct ieee80211_mesh_fast_tx *
-mesh_fast_tx_get(struct ieee80211_sub_if_data *sdata, const u8 *addr)
+mesh_fast_tx_get(struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_mesh_fast_tx_key *key)
 {
 	struct ieee80211_mesh_fast_tx *entry;
 	struct mesh_tx_cache *cache;
 
 	cache = &sdata->u.mesh.tx_cache;
-	entry = rhashtable_lookup(&cache->rht, addr, fast_tx_rht_params);
+	entry = rhashtable_lookup(&cache->rht, key, fast_tx_rht_params);
 	if (!entry)
 		return NULL;
 
 	if (!(entry->mpath->flags & MESH_PATH_ACTIVE) ||
 	    mpath_expired(entry->mpath)) {
 		spin_lock_bh(&cache->walk_lock);
-		entry = rhashtable_lookup(&cache->rht, addr, fast_tx_rht_params);
+		entry = rhashtable_lookup(&cache->rht, key, fast_tx_rht_params);
 		if (entry)
 		    mesh_fast_tx_entry_free(cache, entry);
 		spin_unlock_bh(&cache->walk_lock);
@@ -489,18 +490,24 @@ void mesh_fast_tx_cache(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		return;
 
+	build.key.type = MESH_FAST_TX_TYPE_LOCAL;
 	if ((meshhdr->flags & MESH_FLAGS_AE) == MESH_FLAGS_AE_A5_A6) {
 		/* This is required to keep the mppath alive */
 		mppath = mpp_path_lookup(sdata, meshhdr->eaddr1);
 		if (!mppath)
 			return;
 		build.mppath = mppath;
+		if (!ether_addr_equal(meshhdr->eaddr2, sdata->vif.addr))
+			build.key.type = MESH_FAST_TX_TYPE_PROXIED;
 	} else if (ieee80211_has_a4(hdr->frame_control)) {
 		mppath = mpath;
 	} else {
 		return;
 	}
 
+	if (!ether_addr_equal(hdr->addr4, sdata->vif.addr))
+		build.key.type = MESH_FAST_TX_TYPE_FORWARDED;
+
 	/* rate limit, in case fast xmit can't be enabled */
 	if (mppath->fast_tx_check == jiffies)
 		return;
@@ -547,7 +554,7 @@ void mesh_fast_tx_cache(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	memcpy(build.addr_key, mppath->dst, ETH_ALEN);
+	memcpy(build.key.addr, mppath->dst, ETH_ALEN);
 	build.timestamp = jiffies;
 	build.fast_tx.band = info->band;
 	build.fast_tx.da_offs = offsetof(struct ieee80211_hdr, addr3);
@@ -646,12 +653,18 @@ void mesh_fast_tx_flush_addr(struct ieee80211_sub_if_data *sdata,
 			     const u8 *addr)
 {
 	struct mesh_tx_cache *cache = &sdata->u.mesh.tx_cache;
+	struct ieee80211_mesh_fast_tx_key key = {};
 	struct ieee80211_mesh_fast_tx *entry;
+	int i;
 
+	ether_addr_copy(key.addr, addr);
 	spin_lock_bh(&cache->walk_lock);
-	entry = rhashtable_lookup_fast(&cache->rht, addr, fast_tx_rht_params);
-	if (entry)
-		mesh_fast_tx_entry_free(cache, entry);
+	for (i = 0; i < NUM_MESH_FAST_TX_TYPE; i++) {
+		key.type = i;
+		entry = rhashtable_lookup_fast(&cache->rht, &key, fast_tx_rht_params);
+		if (entry)
+			mesh_fast_tx_entry_free(cache, entry);
+	}
 	spin_unlock_bh(&cache->walk_lock);
 }
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0bf72928ccfca..541b0f53c6c35 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2746,7 +2746,10 @@ ieee80211_rx_mesh_fast_forward(struct ieee80211_sub_if_data *sdata,
 			       struct sk_buff *skb, int hdrlen)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct ieee80211_mesh_fast_tx *entry = NULL;
+	struct ieee80211_mesh_fast_tx_key key = {
+		.type = MESH_FAST_TX_TYPE_FORWARDED
+	};
+	struct ieee80211_mesh_fast_tx *entry;
 	struct ieee80211s_hdr *mesh_hdr;
 	struct tid_ampdu_tx *tid_tx;
 	struct sta_info *sta;
@@ -2755,9 +2758,13 @@ ieee80211_rx_mesh_fast_forward(struct ieee80211_sub_if_data *sdata,
 
 	mesh_hdr = (struct ieee80211s_hdr *)(skb->data + sizeof(eth));
 	if ((mesh_hdr->flags & MESH_FLAGS_AE) == MESH_FLAGS_AE_A5_A6)
-		entry = mesh_fast_tx_get(sdata, mesh_hdr->eaddr1);
+		ether_addr_copy(key.addr, mesh_hdr->eaddr1);
 	else if (!(mesh_hdr->flags & MESH_FLAGS_AE))
-		entry = mesh_fast_tx_get(sdata, skb->data);
+		ether_addr_copy(key.addr, skb->data);
+	else
+		return false;
+
+	entry = mesh_fast_tx_get(sdata, &key);
 	if (!entry)
 		return false;
 
-- 
2.43.0



