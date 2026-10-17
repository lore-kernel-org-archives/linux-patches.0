Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2C13AF66D;
	Sat, 17 Oct 2026 17:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256686; cv=none; b=MMe9i54yOUOocMMYwnmQ89mfVTHQALe7ImW3/gvHS3HBK7kryCiys1I6MW93BCX9WRtzTUv+Yadq6UGF4p5oFm/qjkKfJgKztRW6XE3yYhLYrClhsDUItH6bv8vOpLa6AwrWj8OHuz8ApliNfHYHvUhQ9zNBXF0s5lf8Di4oY9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256686; c=relaxed/simple;
	bh=7bwWemvAZWnI2h67epMuCWcn39Mef2bTtMa46i3eNPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evYb7wu4d5pWZsiUIQsuE8DotQGnmbapBGpDatkrc6m44ydP/Oaw2dbXU75KjgT00YiARo1InCkKZKm2p5UiUuMS3TRxy8eFVKDF3Fkhjb4nq3RfwXHBwoqPpa4aOhS8ASGR9hH90Nco8QaqPkWtyKIQFh/s6PBd/qXxXs2+R6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rl/e2mNj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rl/e2mNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163141F000C4;
	Sat, 17 Oct 2026 17:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256685;
	bh=N6/+63bDqzIiW+9hHOIOzt58wWxxw2QgwKbl5t43a/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rl/e2mNjVbrrseU8A/wGVKofaBdNNkDcY/ketmrMiGwG3MpiZLdOelv2DCvuRETzE
	 rMUNm6znSxzKkJczH3rJk34OCKwqo5IQKyKckG9lohrFvT+Lqy/5Fl6y1nsrXOzAJH
	 uzvx2XelQo/jGy4Wsp6Xwlb29yZ9sQ47xWIWkeog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 0318/1674] wifi: mac80211: fix mesh fast xmit path deletion UAF
Date: Sat, 17 Oct 2026 17:43:10 +0200
Message-ID: <20261017160439.280098274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

commit ee3aadc43ea69d98f666431e787137ac0badbb85 upstream.

mesh_fast_tx_cache() stores raw mesh_path pointers. Path deletion
flushes the cache and then frees the path with kfree_rcu(), but a
lookup that already holds the path can insert a new cache entry
after the flush. The cache then points at freed memory.

Set MESH_PATH_DELETED before flushing, and skip inserting a cache
entry if the path or MPP path is already deleted. Check this under
the cache walk lock so it is ordered with the flush. Use WRITE_ONCE()
for the deletion flag updates because the cache check reads flags
without taking state_lock.

Fixes: d5edb9ae8d56 ("wifi: mac80211: mesh fast xmit support")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Link: https://patch.msgid.link/1daa7a98199fe6965c2da7c42717073a6fd39a0b.1789615568.git.zihanx@nebusec.ai
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mesh_pathtbl.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -572,6 +572,12 @@ void mesh_fast_tx_cache(struct ieee80211
 		goto unlock_sta;
 
 	spin_lock(&cache->walk_lock);
+	if ((READ_ONCE(mpath->flags) & MESH_PATH_DELETED) ||
+	    (mppath && (READ_ONCE(mppath->flags) & MESH_PATH_DELETED))) {
+		kfree(entry);
+		goto unlock_cache;
+	}
+
 	prev = rhashtable_lookup_get_insert_fast(&cache->rht,
 						 &entry->rhash,
 						 fast_tx_rht_params);
@@ -803,7 +809,8 @@ static void mesh_path_free_rcu(struct me
 	struct ieee80211_sub_if_data *sdata = mpath->sdata;
 
 	spin_lock_bh(&mpath->state_lock);
-	mpath->flags |= MESH_PATH_RESOLVING | MESH_PATH_DELETED;
+	WRITE_ONCE(mpath->flags,
+		   mpath->flags | MESH_PATH_RESOLVING | MESH_PATH_DELETED);
 	mesh_gate_del(tbl, mpath);
 	spin_unlock_bh(&mpath->state_lock);
 	timer_shutdown_sync(&mpath->timer);
@@ -817,6 +824,9 @@ static void __mesh_path_del(struct mesh_
 {
 	hlist_del_rcu(&mpath->walk_list);
 	rhashtable_remove_fast(&tbl->rhead, &mpath->rhash, mesh_rht_params);
+	spin_lock_bh(&mpath->state_lock);
+	WRITE_ONCE(mpath->flags, mpath->flags | MESH_PATH_DELETED);
+	spin_unlock_bh(&mpath->state_lock);
 	if (tbl == &mpath->sdata->u.mesh.mpp_paths)
 		mesh_fast_tx_flush_addr(mpath->sdata, mpath->dst);
 	else


