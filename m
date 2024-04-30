Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D3B12C46D;
	Tue, 30 Apr 2024 10:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474033; cv=none; b=PP09MN3hjo/Viw+l0tzkHkkD/vKQ8VCxxG+XOh44DyxsOlrT3aYA8IxcqN5q470pzFxl7OsEhiDfq1ECYLZIp7kyppZSAHKk39831EXb7KtQaJv0nVxDcFQF2f4Xwoyeo+++QwBjbYAgpda9vR1JEwHLVzomwgYarpd5/XKVxKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474033; c=relaxed/simple;
	bh=o0pKiMlUrlkzQ/xjY9ARA5RT3efWBJViFsZLnHH0PAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nts2Sy96lpcq7t56EmVfo21x1TwKOjECzSVZyquojkr4RX35Nb/s4n60qcqDUUkHvb7iLmm9GrYVoc0Afqkl0DDCkAwWYdrm0YmPppLX+m2Y9o0UrMGaI9JW+X1vWB9UADlILt9Crbk8JTwqv8WpYThKySm2exLlMaF2Hv9UBfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1skKSsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1skKSsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01917C4AF14;
	Tue, 30 Apr 2024 10:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474033;
	bh=o0pKiMlUrlkzQ/xjY9ARA5RT3efWBJViFsZLnHH0PAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1skKSsatWS5lYCMcU6Glmi41fniZQXpHt/wVa0ZtnBOGtN4NuyxfOYhTGGu9a+Ku
	 TwoJ7F3AckwPaykMN68DZkMlM1d3QaNFB9otaJNhLbGXqugJzTa0k03Vh5asDOgtgU
	 sVBcrWYnZQCAKECMlODfL4Nygt0+5Sh46eoQ4+yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@intel.com>,
	Simon Horman <horms@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 040/228] wifi: mac80211: clean up assignments to pointer cache.
Date: Tue, 30 Apr 2024 12:36:58 +0200
Message-ID: <20240430103104.971103549@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@intel.com>

[ Upstream commit ba4b1fa3128b2fbf14e167230315cbd9074b629b ]

The assignment to pointer cache in function mesh_fast_tx_gc can
be made at the declaration time rather than a later assignment.
There are also 3 functions where pointer cache is being initialized
at declaration time and later re-assigned again with the same
value, these are redundant and can be removed.

Cleans up code and three clang scan build warnings:
warning: Value stored to 'cache' during its initialization is never
read [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://msgid.link/20240215232151.2075483-1-colin.i.king@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 8c75cdcdf869 ("wifi: mac80211: split mesh fast tx cache into local/proxied/forwarded")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 735edde1bd819..91b55d6a68b97 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -600,11 +600,10 @@ void mesh_fast_tx_cache(struct ieee80211_sub_if_data *sdata,
 void mesh_fast_tx_gc(struct ieee80211_sub_if_data *sdata)
 {
 	unsigned long timeout = msecs_to_jiffies(MESH_FAST_TX_CACHE_TIMEOUT);
-	struct mesh_tx_cache *cache;
+	struct mesh_tx_cache *cache = &sdata->u.mesh.tx_cache;
 	struct ieee80211_mesh_fast_tx *entry;
 	struct hlist_node *n;
 
-	cache = &sdata->u.mesh.tx_cache;
 	if (atomic_read(&cache->rht.nelems) < MESH_FAST_TX_CACHE_THRESHOLD_SIZE)
 		return;
 
@@ -622,7 +621,6 @@ void mesh_fast_tx_flush_mpath(struct mesh_path *mpath)
 	struct ieee80211_mesh_fast_tx *entry;
 	struct hlist_node *n;
 
-	cache = &sdata->u.mesh.tx_cache;
 	spin_lock_bh(&cache->walk_lock);
 	hlist_for_each_entry_safe(entry, n, &cache->walk_head, walk_list)
 		if (entry->mpath == mpath)
@@ -637,7 +635,6 @@ void mesh_fast_tx_flush_sta(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_mesh_fast_tx *entry;
 	struct hlist_node *n;
 
-	cache = &sdata->u.mesh.tx_cache;
 	spin_lock_bh(&cache->walk_lock);
 	hlist_for_each_entry_safe(entry, n, &cache->walk_head, walk_list)
 		if (rcu_access_pointer(entry->mpath->next_hop) == sta)
@@ -651,7 +648,6 @@ void mesh_fast_tx_flush_addr(struct ieee80211_sub_if_data *sdata,
 	struct mesh_tx_cache *cache = &sdata->u.mesh.tx_cache;
 	struct ieee80211_mesh_fast_tx *entry;
 
-	cache = &sdata->u.mesh.tx_cache;
 	spin_lock_bh(&cache->walk_lock);
 	entry = rhashtable_lookup_fast(&cache->rht, addr, fast_tx_rht_params);
 	if (entry)
-- 
2.43.0



