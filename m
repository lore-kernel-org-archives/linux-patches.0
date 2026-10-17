Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F284CF461;
	Sat, 17 Oct 2026 18:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260543; cv=none; b=kUlgLlVwqdTqMg61QF/YdBCTwJqQyF5uHraD5kGoklG1hbxVpBLohMl8vJnK2YvZjO7mZBI1gZ3ISgYPaL1X7RVKnbFEvSQpk3YCoGOUAJ1DzpD5urrttDtrMreV/ANOjFnBL23tutsMvp5LDIXu6sf/7R7ul+1MUkROGyjN6nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260543; c=relaxed/simple;
	bh=nHu0FWo5plqydj4W+g4CvDkFB6oz0ExbphTOP7jI3R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HP93YYvVq8CCkC3Z8qrmA5QVFtHHAr+r3A0JOdo6YjpfIPLVkTS5R1S7Z1dzJz4JkBqbTXsxwdG+kpbDVA1p0gw1LWJcLeV3kAKDvhxTDtECrpu52OOodgoikmho4Fs6ZKk/YyYJxYgvCj7d1s0HEzRGCeiDXDrwVmk/Mrr8B4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPsV+1SC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPsV+1SC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5121F000C4;
	Sat, 17 Oct 2026 18:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260541;
	bh=nfNM6xR/wKaN5T//MUwfvzOu896QhLUIjY04DRZzMIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPsV+1SCgD7ej+50T/jmS5kbuqkcEcnXmMDQYhwJ8Zc4MX0ADccwsGJ5+AGfQajJm
	 Tu2687ow2/CYFFH8d/w9Zorll1nbShV8zVatOFu2y006q0YYiINFpY9WYqTgDHUipJ
	 qPL3Odvvgvzy3PPuy1T3G+zCMY1rRFfyCi0h09zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1578/1674] nfsd: fix fcache_disposal UAF by inlining dispose state into nfsd_net
Date: Sat, 17 Oct 2026 18:04:10 +0200
Message-ID: <20261017160511.598604519@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit bbf13732f74351d21c5e0e8dd9bd8e1c48dc35d4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 74 +++++++++++++++------------------------------
 fs/nfsd/netns.h     |  4 ++-
 2 files changed, 27 insertions(+), 51 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 7d8ad34127d33..c3ce0c100446e 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -60,12 +60,6 @@ static DEFINE_PER_CPU(unsigned long, nfsd_file_releases);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_total_age);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_evictions);
 
-struct nfsd_fcache_disposal {
-	struct work_struct work;
-	spinlock_t lock;
-	struct list_head freeme;
-};
-
 static struct workqueue_struct *nfsd_filecache_wq __read_mostly;
 
 static struct kmem_cache		*nfsd_file_slab;
@@ -417,12 +411,11 @@ nfsd_file_dispose_list_delayed(struct list_head *dispose)
 		struct nfsd_file *nf = list_first_entry(dispose,
 						struct nfsd_file, nf_gc);
 		struct nfsd_net *nn = net_generic(nf->nf_net, nfsd_net_id);
-		struct nfsd_fcache_disposal *l = nn->fcache_disposal;
 
-		spin_lock(&l->lock);
-		list_move_tail(&nf->nf_gc, &l->freeme);
-		spin_unlock(&l->lock);
-		queue_work(nfsd_filecache_wq, &l->work);
+		spin_lock(&nn->fcache_dispose_lock);
+		list_move_tail(&nf->nf_gc, &nn->fcache_dispose_list);
+		spin_unlock(&nn->fcache_dispose_lock);
+		queue_work(nfsd_filecache_wq, &nn->fcache_dispose_work);
 	}
 }
 
@@ -651,12 +644,12 @@ static void
 nfsd_file_delayed_close(struct work_struct *work)
 {
 	LIST_HEAD(head);
-	struct nfsd_fcache_disposal *l = container_of(work,
-			struct nfsd_fcache_disposal, work);
+	struct nfsd_net *nn = container_of(work, struct nfsd_net,
+					   fcache_dispose_work);
 
-	spin_lock(&l->lock);
-	list_splice_init(&l->freeme, &head);
-	spin_unlock(&l->lock);
+	spin_lock(&nn->fcache_dispose_lock);
+	list_splice_init(&nn->fcache_dispose_list, &head);
+	spin_unlock(&nn->fcache_dispose_lock);
 
 	nfsd_file_dispose_list(&head);
 }
@@ -825,44 +818,22 @@ __nfsd_file_cache_purge(struct net *net)
 	nfsd_file_dispose_list(&dispose);
 }
 
-static struct nfsd_fcache_disposal *
-nfsd_alloc_fcache_disposal(void)
-{
-	struct nfsd_fcache_disposal *l;
-
-	l = kmalloc(sizeof(*l), GFP_KERNEL);
-	if (!l)
-		return NULL;
-	INIT_WORK(&l->work, nfsd_file_delayed_close);
-	spin_lock_init(&l->lock);
-	INIT_LIST_HEAD(&l->freeme);
-	return l;
-}
-
-static void
-nfsd_free_fcache_disposal(struct nfsd_fcache_disposal *l)
-{
-	cancel_work_sync(&l->work);
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
+	/*
+	 * The dispose state lives as long as the net namespace and may still
+	 * be reached by the shrinker after a previous shutdown, so only
+	 * initialize it once.
+	 */
+	if (!nn->fcache_dispose_work.func) {
+		INIT_WORK(&nn->fcache_dispose_work, nfsd_file_delayed_close);
+		spin_lock_init(&nn->fcache_dispose_lock);
+		INIT_LIST_HEAD(&nn->fcache_dispose_list);
+	}
+	return 0;
 }
 
 /**
@@ -881,8 +852,11 @@ nfsd_file_cache_purge(struct net *net)
 void
 nfsd_file_cache_shutdown_net(struct net *net)
 {
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+
 	nfsd_file_cache_purge(net);
-	nfsd_free_fcache_disposal_net(net);
+	cancel_work_sync(&nn->fcache_dispose_work);
+	nfsd_file_dispose_list(&nn->fcache_dispose_list);
 }
 
 void
diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index 443b7d2368f38..798f66da05365 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -211,7 +211,9 @@ struct nfsd_net {
 	/* utsname taken from the process that starts the server */
 	char			nfsd_name[UNX_MAXNODENAME+1];
 
-	struct nfsd_fcache_disposal *fcache_disposal;
+	spinlock_t		fcache_dispose_lock;
+	struct list_head	fcache_dispose_list;
+	struct work_struct	fcache_dispose_work;
 
 	siphash_key_t		siphash_key;
 
-- 
2.53.0



