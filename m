Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6994B44C0;
	Thu, 17 Sep 2026 19:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671607; cv=none; b=J8kREjRkiRqc4XCiCAkvL76UkhY2hXZ54RldE3jUnW2ox6gY0AABbynjgcRtMrXRBsWEIz0N1ZYx/yy9Fz0hnA9EPH9W6ZlIlEDkQqu8wYD9Mj/kKl9cG27hkZEwn4uOclGZoThbWhOXXKSbbAZmQaktAsR+gZPdrks+9ORHjWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671607; c=relaxed/simple;
	bh=RCmHLxlDH7mEsRnEI38djnNjJwNJYVDsZp5erdkjR44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qs6yCxVVFUI8Z2LjQ1jAAsfH+rbSDyka2w5MJGGX/49/UO7V/VoPrl42x3AgojwoTgO/cw6NpiSbjykEmZGt6w0yr8HvEfiKDnc0HLDLknGA6syp1PLLh3wRRLUon10lk2eUGp+QhPuXhGEl2BRKkv6s7YMBxVljS//PzfDiJ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K452pd4Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K452pd4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4421F000FF;
	Thu, 17 Sep 2026 19:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671605;
	bh=/p3BrbjBHZIqysfbFOCZV7ND9qoCPmQGvcC4KJjSgzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K452pd4Y7O2mqZAcio45jfwemaItce5VwrmQ49ahWPXfZeBpDxLgOhsqT4f9L1jNv
	 I5GoAo0aU9lzBSrFtCspFtl9jaJm0fnTzeBfMSylNCsZ3sKJvUcNcgpppiWWmnINx6
	 ulsQFGxYRMbt3FANJaKpFGD+9ugI601ij2MiIc0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1031/1102] nfsd: close shrinker/GC/fsnotify vs per-net shutdown race in filecache
Date: Thu, 17 Sep 2026 16:16:14 +0100
Message-ID: <20260917151606.656627266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 40162cfea79b9510380decfdd1795b754dc9f972 ]

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
[ adapted inline disposal fields to the older allocated fcache_disposal queue while retaining the existing LRU implementation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |   34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -54,6 +54,12 @@
 /* We only care about NFSD_MAY_READ/WRITE for this cache */
 #define NFSD_FILE_MAY_MASK	(NFSD_MAY_READ|NFSD_MAY_WRITE|NFSD_MAY_LOCALIO)
 
+/*
+ * Serialize callers of nfsd_file_dispose_list_delayed() against per-net
+ * shutdown.
+ */
+static DEFINE_SPINLOCK(nfsd_gc_lock);
+
 static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_allocations);
@@ -436,11 +442,17 @@ nfsd_file_dispose_list(struct list_head
  *
  * Transfers each file to the "freeme" list for its nfsd_net, to eventually
  * be disposed of by the per-net garbage collector.
+ *
+ * All callers must hold nfsd_gc_lock, so that nfsd_file_cache_shutdown_net()
+ * can synchronize against them before draining the per-net dispose list.
+ * This guarantees nf_net is still live when we call net_generic().
  */
 static void
 nfsd_file_dispose_list_delayed(struct list_head *dispose)
 {
-	while(!list_empty(dispose)) {
+	lockdep_assert_held(&nfsd_gc_lock);
+
+	while (!list_empty(dispose)) {
 		struct nfsd_file *nf = list_first_entry(dispose,
 						struct nfsd_file, nf_gc);
 		struct nfsd_net *nn = net_generic(nf->nf_net, nfsd_net_id);
@@ -565,10 +577,12 @@ nfsd_file_gc(void)
 	LIST_HEAD(dispose);
 	unsigned long ret;
 
+	spin_lock(&nfsd_gc_lock);
 	ret = list_lru_walk(&nfsd_file_lru, nfsd_file_lru_cb,
 			    &dispose, list_lru_count(&nfsd_file_lru));
-	trace_nfsd_file_gc_removed(ret, list_lru_count(&nfsd_file_lru));
 	nfsd_file_dispose_list_delayed(&dispose);
+	spin_unlock(&nfsd_gc_lock);
+	trace_nfsd_file_gc_removed(ret, list_lru_count(&nfsd_file_lru));
 }
 
 static void
@@ -591,10 +605,14 @@ nfsd_file_lru_scan(struct shrinker *s, s
 	LIST_HEAD(dispose);
 	unsigned long ret;
 
+	if (!spin_trylock(&nfsd_gc_lock))
+		return SHRINK_STOP;
+
 	ret = list_lru_shrink_walk(&nfsd_file_lru, sc,
 				   nfsd_file_lru_cb, &dispose);
-	trace_nfsd_file_shrinker_removed(ret, list_lru_count(&nfsd_file_lru));
 	nfsd_file_dispose_list_delayed(&dispose);
+	spin_unlock(&nfsd_gc_lock);
+	trace_nfsd_file_shrinker_removed(ret, list_lru_count(&nfsd_file_lru));
 	return ret;
 }
 
@@ -680,8 +698,10 @@ nfsd_file_close_inode(struct inode *inod
 {
 	LIST_HEAD(dispose);
 
+	spin_lock(&nfsd_gc_lock);
 	nfsd_file_queue_for_close(inode, &dispose);
 	nfsd_file_dispose_list_delayed(&dispose);
+	spin_unlock(&nfsd_gc_lock);
 }
 
 /**
@@ -927,6 +947,14 @@ void
 nfsd_file_cache_shutdown_net(struct net *net)
 {
 	nfsd_file_cache_purge(net);
+	/*
+	 * Ensure any in-progress shrinker, GC, or fsnotify/lease callback
+	 * (all of which hold nfsd_gc_lock while calling
+	 * nfsd_file_dispose_list_delayed()) has fully completed before
+	 * draining the per-net dispose list.
+	 */
+	spin_lock(&nfsd_gc_lock);
+	spin_unlock(&nfsd_gc_lock);
 	nfsd_free_fcache_disposal_net(net);
 }
 


