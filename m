Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CEB372B2F;
	Fri,  4 Sep 2026 05:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498830; cv=none; b=QLbha1+vhV/a3VYsyy8sHRJxdiEfv+71Lbr/M2Xugo8vgBDn1QUQBegR02yhCVbVbP91HvWpr3Q9GFqX2E7ZCTpksnydMiSHHdPUyNVI2UUqDtczoqFpiflbO3gbGxq1GgNZFyPkhX+Vw10PS1p2j85KufIR2+2fyFGU5ieJsRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498830; c=relaxed/simple;
	bh=uGtc72wZspC67nGIXfK/EleLzmTr59OVvOyxtSs5+F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExpNhlIdEwrjvRQ5zjOYgno9JBGReQoyj2MVecXt0TtLfPKBVp67Hm94FzxcCiuG/OJTYORixHVB0CFRLah1t5tfNelsmtieITl+KsXhGdPdtBHJfdpd8H5EjFY86G0mfrtHLm3Ne6jahnb7z8sH552qezCJD7IvwBKv9yPjJ1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lmVc/yt9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lmVc/yt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3871F00A3D;
	Fri,  4 Sep 2026 05:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498829;
	bh=tJIsBXx7AmM3eWUAEIXHgsYBHCwSnkpCWBzaFX6xF+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmVc/yt9bsr4yvm7Ao1LsdeZAVSIRK802nbyTL9PCU3qPz4IahTSdGHoAPeCDyIYH
	 GIGaurMUDvvYxu7QB+ZV+y8bTccU5tyPbyvus7MDWsSyYRN6Petap/yp6SPl28JW5y
	 UCxjwrBBrbLrbaE+qfIY/j7I/6hCCW2GzevFrzYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 201/713] nfsd: close shrinker/GC/fsnotify vs per-net shutdown race in filecache
Date: Fri,  4 Sep 2026 06:52:49 +0200
Message-ID: <20260904045808.317629198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 40162cfea79b9510380decfdd1795b754dc9f972 upstream.

The shrinker, GC worker, and fsnotify/lease callbacks can unhash an
nfsd_file from the rhashtable and then call
nfsd_file_dispose_list_delayed() to move it to the per-net dispose list.
If nfsd_file_cache_shutdown_net() runs concurrently, its rhashtable walk
misses the already-unhashed file, and its drain of the per-net dispose
list can run before the file has been queued.  The file then sits on
the per-net list with no thread to drain it, leaking both the file and
its associated state.

The GC worker and shrinker already hold nfsd_gc_lock while walking the
LRU, but in the original code they release it before calling
nfsd_file_dispose_list_delayed().  The fsnotify/lease path
(nfsd_file_close_inode) has no synchronization at all.

Fix this by:

  1. Widening nfsd_gc_lock in both nfsd_file_gc() and nfsd_file_lru_scan()
     to cover the nfsd_file_dispose_list_delayed() call.

  2. Wrapping nfsd_file_close_inode() in nfsd_gc_lock so that all three
     callers of nfsd_file_dispose_list_delayed() hold the lock.

  3. Adding a spin_lock/unlock(nfsd_gc_lock) barrier in
     nfsd_file_cache_shutdown_net() after the purge, so that any
     in-progress disposal has fully completed before the per-net list
     is drained.

All operations inside the lock are non-sleeping (rhashtable lookups,
atomic bit/refcount ops, list moves, svc_wake_up), so the spinlock is
appropriate.

Fixes: ffb402596147 ("nfsd: Don't leave work of closing files to a work queue")
Cc: stable@vger.kernel.org # v6.15+
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Link: https://patch.msgid.link/20260604-nfsd-testing-v4-1-3aeb1479c5bb@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |   38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -55,6 +55,17 @@
 /* We only care about NFSD_MAY_READ/WRITE for this cache */
 #define NFSD_FILE_MAY_MASK	(NFSD_MAY_READ|NFSD_MAY_WRITE|NFSD_MAY_LOCALIO)
 
+/* If the shrinker runs between calls to list_lru_walk_node() in
+ * nfsd_file_gc(), the "remaining" count will be wrong.  This could
+ * result in premature freeing of some files.  This may not matter much
+ * but is easy to fix with this spinlock which temporarily disables
+ * the shrinker.
+ *
+ * It also serializes callers of nfsd_file_dispose_list_delayed()
+ * against per-net shutdown.
+ */
+static DEFINE_SPINLOCK(nfsd_gc_lock);
+
 static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_allocations);
@@ -423,10 +434,16 @@ nfsd_file_dispose_list(struct list_head
  * Transfers each file to the dispose list in its nfsd_net and wakes an nfsd
  * thread to do the actual close.  This keeps the cost of fput() in the nfsd
  * threads rather than in the shrinker or GC worker.
+ *
+ * All callers must hold nfsd_gc_lock, so that nfsd_file_cache_shutdown_net()
+ * can synchronize against them before draining the per-net dispose list.
+ * This guarantees nf_net is still live when we call net_generic().
  */
 static void
 nfsd_file_dispose_list_delayed(struct list_head *dispose)
 {
+	lockdep_assert_held(&nfsd_gc_lock);
+
 	while (!list_empty(dispose)) {
 		struct nfsd_file *nf = list_first_entry(dispose,
 						struct nfsd_file, nf_gc);
@@ -557,13 +574,6 @@ nfsd_file_gc_cb(struct list_head *item,
 	return nfsd_file_lru_cb(item, lru, arg);
 }
 
-/* If the shrinker runs between calls to list_lru_walk_node() in
- * nfsd_file_gc(), the "remaining" count will be wrong.  This could
- * result in premature freeing of some files.  This may not matter much
- * but is easy to fix with this spinlock which temporarily disables
- * the shrinker.
- */
-static DEFINE_SPINLOCK(nfsd_gc_lock);
 static void
 nfsd_file_gc(void)
 {
@@ -586,9 +596,9 @@ nfsd_file_gc(void)
 				remaining = 0;
 		}
 	}
+	nfsd_file_dispose_list_delayed(&dispose);
 	spin_unlock(&nfsd_gc_lock);
 	trace_nfsd_file_gc_removed(ret, list_lru_count(&nfsd_file_lru));
-	nfsd_file_dispose_list_delayed(&dispose);
 }
 
 static void
@@ -616,9 +626,9 @@ nfsd_file_lru_scan(struct shrinker *s, s
 
 	ret = list_lru_shrink_walk(&nfsd_file_lru, sc,
 				   nfsd_file_lru_cb, &dispose);
+	nfsd_file_dispose_list_delayed(&dispose);
 	spin_unlock(&nfsd_gc_lock);
 	trace_nfsd_file_shrinker_removed(ret, list_lru_count(&nfsd_file_lru));
-	nfsd_file_dispose_list_delayed(&dispose);
 	return ret;
 }
 
@@ -704,8 +714,10 @@ nfsd_file_close_inode(struct inode *inod
 {
 	LIST_HEAD(dispose);
 
+	spin_lock(&nfsd_gc_lock);
 	nfsd_file_queue_for_close(inode, &dispose);
 	nfsd_file_dispose_list_delayed(&dispose);
+	spin_unlock(&nfsd_gc_lock);
 }
 
 /**
@@ -974,6 +986,14 @@ nfsd_file_cache_shutdown_net(struct net
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
 	nfsd_file_cache_purge(net);
+	/*
+	 * Ensure any in-progress shrinker, GC, or fsnotify/lease callback
+	 * (all of which hold nfsd_gc_lock while calling
+	 * nfsd_file_dispose_list_delayed()) has fully completed before
+	 * draining the per-net dispose list.
+	 */
+	spin_lock(&nfsd_gc_lock);
+	spin_unlock(&nfsd_gc_lock);
 	nfsd_file_dispose_list(&nn->fcache_dispose_list);
 }
 


