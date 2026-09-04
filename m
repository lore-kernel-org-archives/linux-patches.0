Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0759416869;
	Fri,  4 Sep 2026 05:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498766; cv=none; b=keqJlGDbWzNu9FS2zP4BCCMJosT3ah/wTiqhiIhodl8URY9y9pBWkhmSuPV1Nb+BkVyLxnjsZNhWE0PwXbyinZ7TqxnBEyNkn3/tUMld6wdoXG7bvvEtnHasoQBncB02Mi77iKG1FIrEkM2wxwrRtE24aXnSvMFjGLmEs8cVimA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498766; c=relaxed/simple;
	bh=ZdtV/ppNUUl47pgkyPjqDqZu2Ja1L6EA6D56wgshmLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xri8SmBONV8mID1fh1ietnax3LWx1e1Q0yKBc2yY7lBJxylqfGkVGHLX524NuwoAfE4F+Aw750mV27RJCVexTfKIIeg/+tx8yTNhe3+6+roEk4+zWg9RVuWvj39unK98vDMFdUS1P2O1o1HB+IVDnF2nwbRgH4l2TTPeXjLSTSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TpiFXMLa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TpiFXMLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D5F1F00A3D;
	Fri,  4 Sep 2026 05:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498764;
	bh=ZzSLzt6ybMIfzzwLfZPKxTlWDyVMftGtrQxzgGI04K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TpiFXMLa8kXJWqsaw3u6BophNhgAtbARbroPb2msYf88NY6+QJjM931X9fDhIEVIM
	 i+xjrrk24h0SYKdC9DzE0L5BejJpu53Xt1i9ImJrXk0UCCwyNrjddbfIbFQ/AX0Ba2
	 QUIcB5G57yG8ublf3FESol2Ldoop/Id+RuzZ7fJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 180/713] nfsd: fix fcache_disposal UAF by inlining dispose state into nfsd_net
Date: Fri,  4 Sep 2026 06:52:28 +0200
Message-ID: <20260904045807.853320412@linuxfoundation.org>
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

commit bbf13732f74351d21c5e0e8dd9bd8e1c48dc35d4 upstream.

nfsd_file_dispose_list_delayed() defers fput() to nfsd service threads
via a per-net freeme queue, preventing the shrinker and GC worker from
bearing the cost of closing files (see ffb402596147).  However, the
queue lives in a separately-allocated struct nfsd_fcache_disposal that
is freed by nfsd_free_fcache_disposal_net() during per-net teardown.
The global shrinker, laundrette, and fsnotify callbacks can still be
inside nfsd_file_dispose_list_delayed() dereferencing that pointer,
causing a use-after-free.

Inline the spinlock and freeme list directly into struct nfsd_net (as
fcache_dispose_lock and fcache_dispose_list), eliminating the separately
allocated struct nfsd_fcache_disposal entirely.  These fields now have
the same lifetime as the net namespace itself, so there is no dangling
pointer to chase.

nfsd_file_cache_start_net() now just initializes the inline fields and
cannot fail due to allocation.  nfsd_file_cache_shutdown_net() drains
the inline list directly instead of freeing a separate struct.  The
alloc/free helpers are removed.

Fixes: 1463b38e7cf3 ("NFSD: simplify per-net file cache management")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260602-nfsd-testing-v2-7-e4ea62e3cd5c@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/filecache.c |   77 ++++++++++++++--------------------------------------
 fs/nfsd/netns.h     |    3 +-
 2 files changed, 24 insertions(+), 56 deletions(-)

--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -62,11 +62,6 @@ static DEFINE_PER_CPU(unsigned long, nfs
 static DEFINE_PER_CPU(unsigned long, nfsd_file_total_age);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_evictions);
 
-struct nfsd_fcache_disposal {
-	spinlock_t lock;
-	struct list_head freeme;
-};
-
 static struct kmem_cache		*nfsd_file_slab;
 static struct kmem_cache		*nfsd_file_mark_slab;
 static struct list_lru			nfsd_file_lru;
@@ -419,25 +414,25 @@ nfsd_file_dispose_list(struct list_head
 }
 
 /**
- * nfsd_file_dispose_list_delayed - move list of dead files to net's freeme list
+ * nfsd_file_dispose_list_delayed - queue dead files for nfsd thread disposal
  * @dispose: list of nfsd_files to be disposed
  *
- * Transfers each file to the "freeme" list for its nfsd_net, to eventually
- * be disposed of by the per-net garbage collector.
+ * Transfers each file to the dispose list in its nfsd_net and wakes an nfsd
+ * thread to do the actual close.  This keeps the cost of fput() in the nfsd
+ * threads rather than in the shrinker or GC worker.
  */
 static void
 nfsd_file_dispose_list_delayed(struct list_head *dispose)
 {
-	while(!list_empty(dispose)) {
+	while (!list_empty(dispose)) {
 		struct nfsd_file *nf = list_first_entry(dispose,
 						struct nfsd_file, nf_gc);
 		struct nfsd_net *nn = net_generic(nf->nf_net, nfsd_net_id);
-		struct nfsd_fcache_disposal *l = nn->fcache_disposal;
 		struct svc_serv *serv;
 
-		spin_lock(&l->lock);
-		list_move_tail(&nf->nf_gc, &l->freeme);
-		spin_unlock(&l->lock);
+		spin_lock(&nn->fcache_dispose_lock);
+		list_move_tail(&nf->nf_gc, &nn->fcache_dispose_list);
+		spin_unlock(&nn->fcache_dispose_lock);
 
 		/*
 		 * The filecache laundrette is shut down after the
@@ -461,17 +456,15 @@ nfsd_file_dispose_list_delayed(struct li
  */
 void nfsd_file_net_dispose(struct nfsd_net *nn)
 {
-	struct nfsd_fcache_disposal *l = nn->fcache_disposal;
-
-	if (!list_empty(&l->freeme)) {
+	if (!list_empty(&nn->fcache_dispose_list)) {
 		LIST_HEAD(dispose);
 		int i;
 
-		spin_lock(&l->lock);
-		for (i = 0; i < 8 && !list_empty(&l->freeme); i++)
-			list_move(l->freeme.next, &dispose);
-		spin_unlock(&l->lock);
-		if (!list_empty(&l->freeme)) {
+		spin_lock(&nn->fcache_dispose_lock);
+		for (i = 0; i < 8 && !list_empty(&nn->fcache_dispose_list); i++)
+			list_move(nn->fcache_dispose_list.next, &dispose);
+		spin_unlock(&nn->fcache_dispose_lock);
+		if (!list_empty(&nn->fcache_dispose_list)) {
 			/*
 			 * Wake up another thread to share the work
 			 * *before* doing any actual disposing.
@@ -695,11 +688,11 @@ nfsd_file_queue_for_close(struct inode *
 }
 
 /**
- * nfsd_file_close_inode - attempt a delayed close of a nfsd_file
+ * nfsd_file_close_inode - attempt a deferred close of a nfsd_file
  * @inode: inode of the file to attempt to remove
  *
  * Close out any open nfsd_files that can be reaped for @inode. The
- * actual freeing is deferred to the dispose_list_delayed infrastructure.
+ * actual freeing is deferred to the nfsd service threads.
  *
  * This is used by the fsnotify callbacks and setlease notifier.
  */
@@ -949,42 +942,14 @@ __nfsd_file_cache_purge(struct net *net)
 	nfsd_file_dispose_list(&dispose);
 }
 
-static struct nfsd_fcache_disposal *
-nfsd_alloc_fcache_disposal(void)
-{
-	struct nfsd_fcache_disposal *l;
-
-	l = kmalloc_obj(*l);
-	if (!l)
-		return NULL;
-	spin_lock_init(&l->lock);
-	INIT_LIST_HEAD(&l->freeme);
-	return l;
-}
-
-static void
-nfsd_free_fcache_disposal(struct nfsd_fcache_disposal *l)
-{
-	nfsd_file_dispose_list(&l->freeme);
-	kfree(l);
-}
-
-static void
-nfsd_free_fcache_disposal_net(struct net *net)
-{
-	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
-	struct nfsd_fcache_disposal *l = nn->fcache_disposal;
-
-	nfsd_free_fcache_disposal(l);
-}
-
 int
 nfsd_file_cache_start_net(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
-	nn->fcache_disposal = nfsd_alloc_fcache_disposal();
-	return nn->fcache_disposal ? 0 : -ENOMEM;
+	spin_lock_init(&nn->fcache_dispose_lock);
+	INIT_LIST_HEAD(&nn->fcache_dispose_list);
+	return 0;
 }
 
 /**
@@ -1003,8 +968,10 @@ nfsd_file_cache_purge(struct net *net)
 void
 nfsd_file_cache_shutdown_net(struct net *net)
 {
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+
 	nfsd_file_cache_purge(net);
-	nfsd_free_fcache_disposal_net(net);
+	nfsd_file_dispose_list(&nn->fcache_dispose_list);
 }
 
 void
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -217,7 +217,8 @@ struct nfsd_net {
 	/* utsname taken from the process that starts the server */
 	char			nfsd_name[UNX_MAXNODENAME+1];
 
-	struct nfsd_fcache_disposal *fcache_disposal;
+	spinlock_t		fcache_dispose_lock;
+	struct list_head	fcache_dispose_list;
 
 	siphash_key_t		siphash_key;
 


