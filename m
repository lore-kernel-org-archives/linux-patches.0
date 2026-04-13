Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754933161BF;
	Mon, 13 Apr 2026 16:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099163; cv=none; b=TCPjDjc5UARo2JumgDeOnU1VPwbfl4jnzkwZZmBnRWB8jiAem1qsT33e52ppn+6CTJlOvpuQL0Kzk28h/pT+0XcIWfp5yAmfyvMp86dlXaRbB9CX4KjIC7G+3pMG+AKBAvfYQBtih4Z2FSbDQe6uH30d9b8iF+tQuffm3CgHocE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099163; c=relaxed/simple;
	bh=rZH8pNFO63GLjfdWF7kayScRvn0FNQVx17R7lFWauwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5SofsBnxnOwbkLgZ6FpfWxPjUHWqoiTYatWFzMhIL4opRbRNFwsHnB/MD8H2eurl415aKCQTn/eMEjwZcImZiBgPa1ZUQTiq1rJ7GdUsSOg0mglNvwUWbaYSOk4AmkR3gtr98HzZn/6W06UOHpJS9sRgE3MOQw+YZWK0iWgUsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SvK1r7FS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SvK1r7FS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF64C2BCAF;
	Mon, 13 Apr 2026 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099163;
	bh=rZH8pNFO63GLjfdWF7kayScRvn0FNQVx17R7lFWauwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SvK1r7FSf49iQ54aWQ+sZnWnTczhj1lCmZJq0O10XgMyEOJAgNh6KkgG9aiueWOXR
	 I3JxxPU45db2Pgy/Gk6bB+OXdSCw21vJ4iFczE2WrWm7E47HOh0HujM2gB8Tftwknc
	 IUC5ndNjY3EMxyICxnpn2IvSNiTjXFpnUfpvPB9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	David Krehwinkel <davidkrehwinkel@gmail.com>
Subject: [PATCH 5.10 234/491] netfilter: nft_set_pipapo: split gc into unlink and reclaim phase
Date: Mon, 13 Apr 2026 17:57:59 +0200
Message-ID: <20260413155827.819278747@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: David Krehwinkel <davidkrehwinkel@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    5 ++++
 net/netfilter/nf_tables_api.c     |    5 ----
 net/netfilter/nft_set_pipapo.c    |   43 +++++++++++++++++++++++++++++---------
 net/netfilter/nft_set_pipapo.h    |    2 +
 4 files changed, 40 insertions(+), 15 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1570,6 +1570,11 @@ struct nft_trans_gc {
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
@@ -8334,11 +8334,6 @@ static void nft_trans_gc_queue_work(stru
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
@@ -1583,11 +1583,11 @@ static void nft_pipapo_gc_deactivate(str
 }
 
 /**
- * pipapo_gc() - Drop expired entries from set, destroy start and end elements
+ * pipapo_gc_scan() - Drop expired entries from set and link them to gc list
  * @_set:	nftables API set representation
  * @m:		Matching data
  */
-static void pipapo_gc(const struct nft_set *_set, struct nft_pipapo_match *m)
+static void pipapo_gc_scan(const struct nft_set *_set, struct nft_pipapo_match *m)
 {
 	struct nft_set *set = (struct nft_set *) _set;
 	struct nft_pipapo *priv = nft_set_priv(set);
@@ -1600,6 +1600,8 @@ static void pipapo_gc(const struct nft_s
 	if (!gc)
 		return;
 
+	list_add(&gc->list, &priv->gc_head);
+
 	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
 		union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 		struct nft_pipapo_field *f;
@@ -1629,9 +1631,13 @@ static void pipapo_gc(const struct nft_s
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
@@ -1645,9 +1651,21 @@ static void pipapo_gc(const struct nft_s
 		}
 	}
 
-	if (gc) {
+	priv->last_gc = jiffies;
+}
+
+/**
+ * pipapo_gc_queue() - Free expired elements after pointer swap
+ * @_set:	nftables API set representation
+ */
+static void pipapo_gc_queue(const struct nft_set *_set)
+{
+	struct nft_pipapo *priv = nft_set_priv(_set);
+	struct nft_trans_gc *gc, *next;
+
+	list_for_each_entry_safe(gc, next, &priv->gc_head, list) {
+		list_del(&gc->list);
 		nft_trans_gc_queue_sync_done(gc);
-		priv->last_gc = jiffies;
 	}
 }
 
@@ -1708,14 +1726,14 @@ static void nft_pipapo_commit(const stru
 	struct nft_pipapo_match *new_clone, *old;
 
 	if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
-		pipapo_gc(set, priv->clone);
+		pipapo_gc_scan(set, priv->clone);
 
 	if (!priv->dirty)
-		return;
+		goto out;
 
 	new_clone = pipapo_clone(priv->clone);
 	if (IS_ERR(new_clone))
-		return;
+		goto out;
 
 	priv->dirty = false;
 
@@ -1725,6 +1743,8 @@ static void nft_pipapo_commit(const stru
 		call_rcu(&old->rcu, pipapo_reclaim_match);
 
 	priv->clone = new_clone;
+out:
+	pipapo_gc_queue(set);
 }
 
 static void nft_pipapo_abort(const struct nft_set *set)
@@ -2189,6 +2209,7 @@ static int nft_pipapo_init(const struct
 
 	priv->dirty = false;
 
+	INIT_LIST_HEAD(&priv->gc_head);
 	rcu_assign_pointer(priv->match, m);
 
 	return 0;
@@ -2241,6 +2262,8 @@ static void nft_pipapo_destroy(const str
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
+ * @gc_head:	list of nft_trans_gc to queue for deferred reclaim
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


