Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF9114B06C;
	Tue, 10 Sep 2024 10:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964939; cv=none; b=U+XCJ2NVqF9GoziY50swVh9zYjGTmF2G9ZSpGFf4BQ4rlIA0P0U4EhVZZMlxwsv8dPNEQWH/vfr1yovf8DwMnq88Uuz0XOaj56D/IOqxkgK5qE6mmPWDJppxFWYhaF65KxfKluNTVln78ka8a/qFVDE1/KB6g3dsO/NEHKwwYQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964939; c=relaxed/simple;
	bh=EqAuxrqzIz5bA1vhmURPaoOvdF7/CwScEIyVsGSlwls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFAVRDm//eCgqblnDyNCey3NKx3QzW3hRQwVLIkjQWYuHPQ2wPPju+15RRi/c3S0GgCWKBTbQv0mzT4BiLXXuJuKL//wwsQeoYGYZfUSuBPIHp3GkhLM8ERSTa6o0gMdw6hQ9zx07QleozCuckl8E2isnTkMrrDcCg5cfbt4Vto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyuntP6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyuntP6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5520CC4CEC3;
	Tue, 10 Sep 2024 10:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964939;
	bh=EqAuxrqzIz5bA1vhmURPaoOvdF7/CwScEIyVsGSlwls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wyuntP6xAIUUZ21a/F9b7g8tsM1TfpVWx6J1Hbr9EbfEc4UoBRGsK4KzaDI0k5oTO
	 zeWCxT9SnEfeOQfOlRNzyOlxAeTbOoijihNVph7xqTnBZb5CQ+mx/8Irdb1kQvX3O8
	 Xdt+CbgMBO0duu5c17NQz8JRLl0mG7tM+Gk/0HL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 082/186] NFSD: Replace nfsd_prune_bucket()
Date: Tue, 10 Sep 2024 11:32:57 +0200
Message-ID: <20240910092557.892101282@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit a9507f6af1450ed26a4a36d979af518f5bb21e5d ]

Enable nfsd_prune_bucket() to drop the bucket lock while calling
kfree(). Use the same pattern that Jeff recently introduced in the
NFSD filecache.

A few percpu operations are moved outside the lock since they
temporarily disable local IRQs which is expensive and does not
need to be done while the lock is held.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Stable-dep-of: c135e1269f34 ("NFSD: Refactor the duplicate reply cache shrinker")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfscache.c |   78 ++++++++++++++++++++++++++++++++++++++++++-----------
 fs/nfsd/trace.h    |   22 ++++++++++++++
 2 files changed, 85 insertions(+), 15 deletions(-)

--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -117,6 +117,21 @@ static void nfsd_cacherep_free(struct sv
 	kmem_cache_free(drc_slab, rp);
 }
 
+static unsigned long
+nfsd_cacherep_dispose(struct list_head *dispose)
+{
+	struct svc_cacherep *rp;
+	unsigned long freed = 0;
+
+	while (!list_empty(dispose)) {
+		rp = list_first_entry(dispose, struct svc_cacherep, c_lru);
+		list_del(&rp->c_lru);
+		nfsd_cacherep_free(rp);
+		freed++;
+	}
+	return freed;
+}
+
 static void
 nfsd_cacherep_unlink_locked(struct nfsd_net *nn, struct nfsd_drc_bucket *b,
 			    struct svc_cacherep *rp)
@@ -259,6 +274,41 @@ nfsd_cache_bucket_find(__be32 xid, struc
 	return &nn->drc_hashtbl[hash];
 }
 
+/*
+ * Remove and return no more than @max expired entries in bucket @b.
+ * If @max is zero, do not limit the number of removed entries.
+ */
+static void
+nfsd_prune_bucket_locked(struct nfsd_net *nn, struct nfsd_drc_bucket *b,
+			 unsigned int max, struct list_head *dispose)
+{
+	unsigned long expiry = jiffies - RC_EXPIRE;
+	struct svc_cacherep *rp, *tmp;
+	unsigned int freed = 0;
+
+	lockdep_assert_held(&b->cache_lock);
+
+	/* The bucket LRU is ordered oldest-first. */
+	list_for_each_entry_safe(rp, tmp, &b->lru_head, c_lru) {
+		/*
+		 * Don't free entries attached to calls that are still
+		 * in-progress, but do keep scanning the list.
+		 */
+		if (rp->c_state == RC_INPROG)
+			continue;
+
+		if (atomic_read(&nn->num_drc_entries) <= nn->max_drc_entries &&
+		    time_before(expiry, rp->c_timestamp))
+			break;
+
+		nfsd_cacherep_unlink_locked(nn, b, rp);
+		list_add(&rp->c_lru, dispose);
+
+		if (max && ++freed > max)
+			break;
+	}
+}
+
 static long prune_bucket(struct nfsd_drc_bucket *b, struct nfsd_net *nn,
 			 unsigned int max)
 {
@@ -282,11 +332,6 @@ static long prune_bucket(struct nfsd_drc
 	return freed;
 }
 
-static long nfsd_prune_bucket(struct nfsd_drc_bucket *b, struct nfsd_net *nn)
-{
-	return prune_bucket(b, nn, 3);
-}
-
 /*
  * Walk the LRU list and prune off entries that are older than RC_EXPIRE.
  * Also prune the oldest ones when the total exceeds the max number of entries.
@@ -442,6 +487,8 @@ int nfsd_cache_lookup(struct svc_rqst *r
 	__wsum			csum;
 	struct nfsd_drc_bucket	*b;
 	int type = rqstp->rq_cachetype;
+	unsigned long freed;
+	LIST_HEAD(dispose);
 	int rtn = RC_DOIT;
 
 	rqstp->rq_cacherep = NULL;
@@ -466,20 +513,18 @@ int nfsd_cache_lookup(struct svc_rqst *r
 	found = nfsd_cache_insert(b, rp, nn);
 	if (found != rp)
 		goto found_entry;
-
-	nfsd_stats_rc_misses_inc();
 	rqstp->rq_cacherep = rp;
 	rp->c_state = RC_INPROG;
+	nfsd_prune_bucket_locked(nn, b, 3, &dispose);
+	spin_unlock(&b->cache_lock);
 
+	freed = nfsd_cacherep_dispose(&dispose);
+	trace_nfsd_drc_gc(nn, freed);
+
+	nfsd_stats_rc_misses_inc();
 	atomic_inc(&nn->num_drc_entries);
 	nfsd_stats_drc_mem_usage_add(nn, sizeof(*rp));
-
-	nfsd_prune_bucket(b, nn);
-
-out_unlock:
-	spin_unlock(&b->cache_lock);
-out:
-	return rtn;
+	goto out;
 
 found_entry:
 	/* We found a matching entry which is either in progress or done. */
@@ -517,7 +562,10 @@ found_entry:
 
 out_trace:
 	trace_nfsd_drc_found(nn, rqstp, rtn);
-	goto out_unlock;
+out_unlock:
+	spin_unlock(&b->cache_lock);
+out:
+	return rtn;
 }
 
 /**
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -1171,6 +1171,28 @@ TRACE_EVENT(nfsd_drc_mismatch,
 		__entry->ingress)
 );
 
+TRACE_EVENT_CONDITION(nfsd_drc_gc,
+	TP_PROTO(
+		const struct nfsd_net *nn,
+		unsigned long freed
+	),
+	TP_ARGS(nn, freed),
+	TP_CONDITION(freed > 0),
+	TP_STRUCT__entry(
+		__field(unsigned long long, boot_time)
+		__field(unsigned long, freed)
+		__field(int, total)
+	),
+	TP_fast_assign(
+		__entry->boot_time = nn->boot_time;
+		__entry->freed = freed;
+		__entry->total = atomic_read(&nn->num_drc_entries);
+	),
+	TP_printk("boot_time=%16llx total=%d freed=%lu",
+		__entry->boot_time, __entry->total, __entry->freed
+	)
+);
+
 TRACE_EVENT(nfsd_cb_args,
 	TP_PROTO(
 		const struct nfs4_client *clp,


