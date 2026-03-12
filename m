Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8A726F288;
	Thu, 12 Mar 2026 20:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347211; cv=none; b=WurmKUhEf5rVlkJDJFPmYhkQ0T7mjh4IMJigTB9QgCM6AzKshRTt/Xi2CFPys6v0siV/8HcMViHUS2vpKlgBqAItm/MCMdMApD2bdEWuBH3GM53oAJETiA85LGdM2PybaSG8sRGL4U92EDEsM1Lc8wFF6tC97kqdgEDk7siiRLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347211; c=relaxed/simple;
	bh=p5tad9g/v9SWo15QNfXxNocVOlvzgW81KLxx8jKUR1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFBq0X33mdt32rCeT3KaiCqTL3pSZrY/adDg+V9Bz60kS8/RSHQz0jjGJ1LO4iwF/AaoN+lYiDCDaZPAhur7ApUBHNUhbqbBs5dk2v1XOJCUD6T41IOkOZLRzu+CCS7JQCuqdNrc3wUEmSR8tAxsSOM6St9Y7AMY0CwTVrnqYoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wP4PhLii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wP4PhLii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0A2C4CEF7;
	Thu, 12 Mar 2026 20:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347210;
	bh=p5tad9g/v9SWo15QNfXxNocVOlvzgW81KLxx8jKUR1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wP4PhLiiFvdxjLjH9w6PUxgJpkXuP4i2erTjAzwNfbCchi5mEdnB2eQ3PePFdZRkq
	 cI61nvmzP8fXbOsIKgTlxI5BdzFWuqnwbfaa1seRyUIDBiBaZmhaZN7kB/H1uw0tpR
	 keN5MBT9xiVYJgJT3vPOPFciEXCTI6zoRBr+OvPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 234/265] netfilter: nft_set_pipapo: split gc into unlink and reclaim phase
Date: Thu, 12 Mar 2026 21:10:21 +0100
Message-ID: <20260312201026.782787792@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 9df95785d3d8302f7c066050117b04cd3c2048c2 ]

Yiming Qian reports Use-after-free in the pipapo set type:
  Under a large number of expired elements, commit-time GC can run for a very
  long time in a non-preemptible context, triggering soft lockup warnings and
  RCU stall reports (local denial of service).

We must split GC in an unlink and a reclaim phase.

We cannot queue elements for freeing until pointers have been swapped.
Expired elements are still exposed to both the packet path and userspace
dumpers via the live copy of the data structure.

call_rcu() does not protect us: dump operations or element lookups starting
after call_rcu has fired can still observe the free'd element, unless the
commit phase has made enough progress to swap the clone and live pointers
before any new reader has picked up the old version.

This a similar approach as done recently for the rbtree backend in commit
35f83a75529a ("netfilter: nft_set_rbtree: don't gc elements on insert").

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  5 +++
 net/netfilter/nf_tables_api.c     |  5 ---
 net/netfilter/nft_set_pipapo.c    | 51 ++++++++++++++++++++++++++-----
 net/netfilter/nft_set_pipapo.h    |  2 ++
 4 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d440583aa4b24..79296ed87b9b3 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1851,6 +1851,11 @@ struct nft_trans_gc {
 	struct rcu_head		rcu;
 };
 
+static inline int nft_trans_gc_space(const struct nft_trans_gc *trans)
+{
+	return NFT_TRANS_GC_BATCHCOUNT - trans->count;
+}
+
 static inline void nft_ctx_update(struct nft_ctx *ctx,
 				  const struct nft_trans *trans)
 {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8dccd3598166b..c1b9b00907bbb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10151,11 +10151,6 @@ static void nft_trans_gc_queue_work(struct nft_trans_gc *trans)
 	schedule_work(&trans_gc_work);
 }
 
-static int nft_trans_gc_space(struct nft_trans_gc *trans)
-{
-	return NFT_TRANS_GC_BATCHCOUNT - trans->count;
-}
-
 struct nft_trans_gc *nft_trans_gc_queue_async(struct nft_trans_gc *gc,
 					      unsigned int gc_seq, gfp_t gfp)
 {
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 642152e9c3227..ab5045bf3e599 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1667,11 +1667,11 @@ static void nft_pipapo_gc_deactivate(struct net *net, struct nft_set *set,
 }
 
 /**
- * pipapo_gc() - Drop expired entries from set, destroy start and end elements
+ * pipapo_gc_scan() - Drop expired entries from set and link them to gc list
  * @set:	nftables API set representation
  * @m:		Matching data
  */
-static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
+static void pipapo_gc_scan(struct nft_set *set, struct nft_pipapo_match *m)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct net *net = read_pnet(&set->net);
@@ -1684,6 +1684,8 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 	if (!gc)
 		return;
 
+	list_add(&gc->list, &priv->gc_head);
+
 	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
 		union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 		const struct nft_pipapo_field *f;
@@ -1711,9 +1713,13 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 		 * NFT_SET_ELEM_DEAD_BIT.
 		 */
 		if (__nft_set_elem_expired(&e->ext, tstamp)) {
-			gc = nft_trans_gc_queue_sync(gc, GFP_KERNEL);
-			if (!gc)
-				return;
+			if (!nft_trans_gc_space(gc)) {
+				gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
+				if (!gc)
+					return;
+
+				list_add(&gc->list, &priv->gc_head);
+			}
 
 			nft_pipapo_gc_deactivate(net, set, e);
 			pipapo_drop(m, rulemap);
@@ -1727,10 +1733,30 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
 		}
 	}
 
-	gc = nft_trans_gc_catchall_sync(gc);
+	priv->last_gc = jiffies;
+}
+
+/**
+ * pipapo_gc_queue() - Free expired elements
+ * @set:	nftables API set representation
+ */
+static void pipapo_gc_queue(struct nft_set *set)
+{
+	struct nft_pipapo *priv = nft_set_priv(set);
+	struct nft_trans_gc *gc, *next;
+
+	/* always do a catchall cycle: */
+	gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
 	if (gc) {
+		gc = nft_trans_gc_catchall_sync(gc);
+		if (gc)
+			nft_trans_gc_queue_sync_done(gc);
+	}
+
+	/* always purge queued gc elements. */
+	list_for_each_entry_safe(gc, next, &priv->gc_head, list) {
+		list_del(&gc->list);
 		nft_trans_gc_queue_sync_done(gc);
-		priv->last_gc = jiffies;
 	}
 }
 
@@ -1784,6 +1810,10 @@ static void pipapo_reclaim_match(struct rcu_head *rcu)
  *
  * We also need to create a new working copy for subsequent insertions and
  * deletions.
+ *
+ * After the live copy has been replaced by the clone, we can safely queue
+ * expired elements that have been collected by pipapo_gc_scan() for
+ * memory reclaim.
  */
 static void nft_pipapo_commit(struct nft_set *set)
 {
@@ -1794,7 +1824,7 @@ static void nft_pipapo_commit(struct nft_set *set)
 		return;
 
 	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
-		pipapo_gc(set, priv->clone);
+		pipapo_gc_scan(set, priv->clone);
 
 	old = rcu_replace_pointer(priv->match, priv->clone,
 				  nft_pipapo_transaction_mutex_held(set));
@@ -1802,6 +1832,8 @@ static void nft_pipapo_commit(struct nft_set *set)
 
 	if (old)
 		call_rcu(&old->rcu, pipapo_reclaim_match);
+
+	pipapo_gc_queue(set);
 }
 
 static void nft_pipapo_abort(const struct nft_set *set)
@@ -2259,6 +2291,7 @@ static int nft_pipapo_init(const struct nft_set *set,
 		f->mt = NULL;
 	}
 
+	INIT_LIST_HEAD(&priv->gc_head);
 	rcu_assign_pointer(priv->match, m);
 
 	return 0;
@@ -2308,6 +2341,8 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 	struct nft_pipapo *priv = nft_set_priv(set);
 	struct nft_pipapo_match *m;
 
+	WARN_ON_ONCE(!list_empty(&priv->gc_head));
+
 	m = rcu_dereference_protected(priv->match, true);
 
 	if (priv->clone) {
diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index 4a2ff85ce1c43..49000f5510b28 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -156,12 +156,14 @@ struct nft_pipapo_match {
  * @clone:	Copy where pending insertions and deletions are kept
  * @width:	Total bytes to be matched for one packet, including padding
  * @last_gc:	Timestamp of last garbage collection run, jiffies
+ * @gc_head:	list of nft_trans_gc to queue up for mem reclaim
  */
 struct nft_pipapo {
 	struct nft_pipapo_match __rcu *match;
 	struct nft_pipapo_match *clone;
 	int width;
 	unsigned long last_gc;
+	struct list_head gc_head;
 };
 
 struct nft_pipapo_elem;
-- 
2.51.0



