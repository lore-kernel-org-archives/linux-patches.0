Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38720238D27;
	Mon, 13 Apr 2026 16:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097842; cv=none; b=GrzTTzVEUjVwavaDEYPYkFIOJxshinZXgLQ8juz8XD0Uttm4GeBr+sdtsy6dBR/XYDT2TSAOxpzYUz5NXqpQSOiQsg9DvkSUoq/qRDZmt1T3JaJ1YeGStxeqOQbKnxQuJCIQcPNlpxwqJQKBeTEichOMTtotYnM2dmKlO6CmFjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097842; c=relaxed/simple;
	bh=Gasimw/TIwhC0jJ2XdTo2pB50Lm7u5ffF4lxH4kyW0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAA28PEAgBR/DbnFYmrk3g9H3YMnlzcsSHRM5MphUWJfd9R4h/5MuG1gD8108F9jNEUgbHEg9hk9wi/9rT91PAQAaOoyf3c7Srk9rKoFtWTUUkQLBuVonWVA+hEUxeB5AuD1OgliU4wgxamX3qqnzgA6o9xHja7W1cs5SrZ9Aqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTA/Kh9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTA/Kh9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41B1C2BCAF;
	Mon, 13 Apr 2026 16:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097842;
	bh=Gasimw/TIwhC0jJ2XdTo2pB50Lm7u5ffF4lxH4kyW0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTA/Kh9GLyl4goANw31AkkAy4dq+84I+JRdMYU0K2Ic1QPDTBwDwvrzP3pk/alvFI
	 TPjjFoEBzmfNuohwRabKWSZj3YYgCXoAdenM8U14sz8CsuyRxL6fcigsnkaOifiRUv
	 +GJpnOBjNB0L3QCq0QJ0iF655RwVWrikPA//0O9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.15 292/570] netfilter: nft_set_pipapo: split gc into unlink and reclaim phase
Date: Mon, 13 Apr 2026 17:57:03 +0200
Message-ID: <20260413155841.440882087@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 9df95785d3d8302f7c066050117b04cd3c2048c2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    5 +++
 net/netfilter/nf_tables_api.c     |    5 ---
 net/netfilter/nft_set_pipapo.c    |   51 ++++++++++++++++++++++++++++++++------
 net/netfilter/nft_set_pipapo.h    |    2 +
 4 files changed, 50 insertions(+), 13 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1655,6 +1655,11 @@ struct nft_trans_gc {
 	struct rcu_head		rcu;
 };
 
+static inline int nft_trans_gc_space(const struct nft_trans_gc *trans)
+{
+	return NFT_TRANS_GC_BATCHCOUNT - trans->count;
+}
+
 struct nft_trans_gc *nft_trans_gc_alloc(struct nft_set *set,
 					unsigned int gc_seq, gfp_t gfp);
 void nft_trans_gc_destroy(struct nft_trans_gc *trans);
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9146,11 +9146,6 @@ static void nft_trans_gc_queue_work(stru
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
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1586,11 +1586,11 @@ static void nft_pipapo_gc_deactivate(str
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
@@ -1603,6 +1603,8 @@ static void pipapo_gc(struct nft_set *se
 	if (!gc)
 		return;
 
+	list_add(&gc->list, &priv->gc_head);
+
 	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
 		union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 		const struct nft_pipapo_field *f;
@@ -1632,9 +1634,13 @@ static void pipapo_gc(struct nft_set *se
 		if (__nft_set_elem_expired(&e->ext, tstamp)) {
 			priv->dirty = true;
 
-			gc = nft_trans_gc_queue_sync(gc, GFP_ATOMIC);
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
@@ -1648,10 +1654,30 @@ static void pipapo_gc(struct nft_set *se
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
 
@@ -1705,6 +1731,10 @@ static void pipapo_reclaim_match(struct
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
@@ -1712,7 +1742,7 @@ static void nft_pipapo_commit(struct nft
 	struct nft_pipapo_match *new_clone, *old;
 
 	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
-		pipapo_gc(set, priv->clone);
+		pipapo_gc_scan(set, priv->clone);
 
 	if (!priv->dirty)
 		return;
@@ -1729,6 +1759,8 @@ static void nft_pipapo_commit(struct nft
 		call_rcu(&old->rcu, pipapo_reclaim_match);
 
 	priv->clone = new_clone;
+
+	pipapo_gc_queue(set);
 }
 
 static bool nft_pipapo_transaction_mutex_held(const struct nft_set *set)
@@ -2204,6 +2236,7 @@ static int nft_pipapo_init(const struct
 
 	priv->dirty = false;
 
+	INIT_LIST_HEAD(&priv->gc_head);
 	rcu_assign_pointer(priv->match, m);
 
 	return 0;
@@ -2256,6 +2289,8 @@ static void nft_pipapo_destroy(const str
 	struct nft_pipapo_match *m;
 	int cpu;
 
+	WARN_ON_ONCE(!list_empty(&priv->gc_head));
+
 	m = rcu_dereference_protected(priv->match, true);
 	if (m) {
 		rcu_barrier();
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -165,6 +165,7 @@ struct nft_pipapo_match {
  * @width:	Total bytes to be matched for one packet, including padding
  * @dirty:	Working copy has pending insertions or deletions
  * @last_gc:	Timestamp of last garbage collection run, jiffies
+ * @gc_head:	list of nft_trans_gc to queue up for mem reclaim
  */
 struct nft_pipapo {
 	struct nft_pipapo_match __rcu *match;
@@ -172,6 +173,7 @@ struct nft_pipapo {
 	int width;
 	bool dirty;
 	unsigned long last_gc;
+	struct list_head gc_head;
 };
 
 struct nft_pipapo_elem;


