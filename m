Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4F835BDDB;
	Fri,  9 Oct 2026 14:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557322; cv=none; b=XPZoBQIaK1g8ptt4X4r9tCIGsGIy9J11w9/24yB3Nl/Zys08mCIJojs7tGZms+Y++FoPsLWDGp14q8crRsYyBvELJqJ/9FOPXKF/QINSf6e+1EIznt4deWZ9IW2uu0Vmqie7MYfRnK0VYsbTyMiAWLWB6rOopiO2dcBZlUdiInY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557322; c=relaxed/simple;
	bh=UZfXd39iChUdUzBuQDtVImMQnQnCnQOplOgOcvMG6lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5/ciAQ4NOKyCmKHczzxP56sSFV/Fog5aEh/vLhBCZgForE+ysYrmEbOanUAfYkXX1J1w8Q0iApU6XWCO+CCzi86ME2coCAkLYlnzwdZZby7a0XgcXONdPHWgqkklGK/3uWSnzRHBR8+izxG2aOAn8+AZULP/2OHigvTvAiVXEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3yyB2Vf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3yyB2Vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987231F000FF;
	Fri,  9 Oct 2026 14:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557320;
	bh=zKMxIZE75go/zgOtkd10Lp7kfqqCyZrZka60zQTp2vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E3yyB2VfA11YADcAMn0qCG++ZFun6dNosYmU1iic8zdkptfhcKC06gKJdkOTxG/1/
	 wCQXViluthbwu/XtmTjeJTqBtIAr3p2TvxvH934WjC7wok03oZhoupT5+vQrhhSzKN
	 hoAKzZKKo3uALgwqQvR/bjgVNu22uaWU5EnUugvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 337/428] wifi: mac80211: fix mesh fast xmit path deletion UAF
Date: Fri,  9 Oct 2026 16:11:14 +0200
Message-ID: <20261009140953.547367871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -577,6 +577,12 @@ void mesh_fast_tx_cache(struct ieee80211
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
@@ -808,7 +814,8 @@ static void mesh_path_free_rcu(struct me
 	struct ieee80211_sub_if_data *sdata = mpath->sdata;
 
 	spin_lock_bh(&mpath->state_lock);
-	mpath->flags |= MESH_PATH_RESOLVING | MESH_PATH_DELETED;
+	WRITE_ONCE(mpath->flags,
+		   mpath->flags | MESH_PATH_RESOLVING | MESH_PATH_DELETED);
 	mesh_gate_del(tbl, mpath);
 	spin_unlock_bh(&mpath->state_lock);
 	timer_shutdown_sync(&mpath->timer);
@@ -822,6 +829,9 @@ static void __mesh_path_del(struct mesh_
 {
 	hlist_del_rcu(&mpath->walk_list);
 	rhashtable_remove_fast(&tbl->rhead, &mpath->rhash, mesh_rht_params);
+	spin_lock_bh(&mpath->state_lock);
+	WRITE_ONCE(mpath->flags, mpath->flags | MESH_PATH_DELETED);
+	spin_unlock_bh(&mpath->state_lock);
 	if (tbl == &mpath->sdata->u.mesh.mpp_paths)
 		mesh_fast_tx_flush_addr(mpath->sdata, mpath->dst);
 	else


