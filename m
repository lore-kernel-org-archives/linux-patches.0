Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DEB18EFD8;
	Tue, 18 Jun 2024 13:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715835; cv=none; b=g0p4Z6KT+qjdPgnr/QOxop8GEHq8WT8dQ/QoNznfm702YZQMTCegBgoRA5yFDHKpYuCr6i5ebz7hghavanHkYVbExy/REVg3yV+AOtYP1Nv+Um7v+saVLtCngSpLwlucfSMphYh6c/Mb1Y+IN4Z9ejoUHqg3uhlmfkJ4thd5KlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715835; c=relaxed/simple;
	bh=GBJETvFStbfCBnSNaMqntBmZdYnEdVOb0Y5okgDYW0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByHIiQikoScNN9qQljalNCXAvH+/OOZnaFw6L/aDC/EVyeN3KPYVtQlk2a4eIXllYkGUuWMCu/8+uD1pK5SXgq3BAz/ZT08j2FX7txgqCQxtFKKh9jeCoXm0sbDPKcbWfeKv9BX6xLSeFFiI/zfgeQEVHk8t82CZ3iRd9nxxOo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2y9xsP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2y9xsP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06B4C3277B;
	Tue, 18 Jun 2024 13:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715835;
	bh=GBJETvFStbfCBnSNaMqntBmZdYnEdVOb0Y5okgDYW0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2y9xsP7brbHuC7U04vuS58tbv3EqNn2t9+NuihA/e47FcCJxjF3md51X3J9TZXir
	 N9AxSMaCIpdfkHv6uPpms9OtHUtzyaEDDQuGgOPG8aM6Kn2Fhoa5SYoIvPtHd08BeW
	 06qY+3UeHAIX3oTDE+yOKx3FhqJ2Lbjdt9tCyC5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 441/770] NFSD: simplify per-net file cache management
Date: Tue, 18 Jun 2024 14:34:54 +0200
Message-ID: <20240618123424.310314731@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 1463b38e7cf34d4cc60f41daff459ad807b2e408 ]

We currently have a 'laundrette' for closing cached files - a different
work-item for each network-namespace.

These 'laundrettes' (aka struct nfsd_fcache_disposal) are currently on a
list, and are freed using rcu.

The list is not necessary as we have a per-namespace structure (struct
nfsd_net) which can hold a link to the nfsd_fcache_disposal.
The use of kfree_rcu is also unnecessary as the cache is cleaned of all
files associated with a given namespace, and no new files can be added,
before the nfsd_fcache_disposal is freed.

So add a '->fcache_disposal' link to nfsd_net, and discard the list
management and rcu usage.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 76 +++++++++------------------------------------
 fs/nfsd/netns.h     |  2 ++
 2 files changed, 17 insertions(+), 61 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 8cd7d5d6955a0..b6ef8256c9c64 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -44,12 +44,9 @@ struct nfsd_fcache_bucket {
 static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 
 struct nfsd_fcache_disposal {
-	struct list_head list;
 	struct work_struct work;
-	struct net *net;
 	spinlock_t lock;
 	struct list_head freeme;
-	struct rcu_head rcu;
 };
 
 static struct workqueue_struct *nfsd_filecache_wq __read_mostly;
@@ -62,8 +59,6 @@ static long				nfsd_file_lru_flags;
 static struct fsnotify_group		*nfsd_file_fsnotify_group;
 static atomic_long_t			nfsd_filecache_count;
 static struct delayed_work		nfsd_filecache_laundrette;
-static DEFINE_SPINLOCK(laundrette_lock);
-static LIST_HEAD(laundrettes);
 
 static void nfsd_file_gc(void);
 
@@ -366,19 +361,13 @@ nfsd_file_list_remove_disposal(struct list_head *dst,
 static void
 nfsd_file_list_add_disposal(struct list_head *files, struct net *net)
 {
-	struct nfsd_fcache_disposal *l;
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+	struct nfsd_fcache_disposal *l = nn->fcache_disposal;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(l, &laundrettes, list) {
-		if (l->net == net) {
-			spin_lock(&l->lock);
-			list_splice_tail_init(files, &l->freeme);
-			spin_unlock(&l->lock);
-			queue_work(nfsd_filecache_wq, &l->work);
-			break;
-		}
-	}
-	rcu_read_unlock();
+	spin_lock(&l->lock);
+	list_splice_tail_init(files, &l->freeme);
+	spin_unlock(&l->lock);
+	queue_work(nfsd_filecache_wq, &l->work);
 }
 
 static void
@@ -754,7 +743,7 @@ nfsd_file_cache_purge(struct net *net)
 }
 
 static struct nfsd_fcache_disposal *
-nfsd_alloc_fcache_disposal(struct net *net)
+nfsd_alloc_fcache_disposal(void)
 {
 	struct nfsd_fcache_disposal *l;
 
@@ -762,7 +751,6 @@ nfsd_alloc_fcache_disposal(struct net *net)
 	if (!l)
 		return NULL;
 	INIT_WORK(&l->work, nfsd_file_delayed_close);
-	l->net = net;
 	spin_lock_init(&l->lock);
 	INIT_LIST_HEAD(&l->freeme);
 	return l;
@@ -771,61 +759,27 @@ nfsd_alloc_fcache_disposal(struct net *net)
 static void
 nfsd_free_fcache_disposal(struct nfsd_fcache_disposal *l)
 {
-	rcu_assign_pointer(l->net, NULL);
 	cancel_work_sync(&l->work);
 	nfsd_file_dispose_list(&l->freeme);
-	kfree_rcu(l, rcu);
-}
-
-static void
-nfsd_add_fcache_disposal(struct nfsd_fcache_disposal *l)
-{
-	spin_lock(&laundrette_lock);
-	list_add_tail_rcu(&l->list, &laundrettes);
-	spin_unlock(&laundrette_lock);
-}
-
-static void
-nfsd_del_fcache_disposal(struct nfsd_fcache_disposal *l)
-{
-	spin_lock(&laundrette_lock);
-	list_del_rcu(&l->list);
-	spin_unlock(&laundrette_lock);
-}
-
-static int
-nfsd_alloc_fcache_disposal_net(struct net *net)
-{
-	struct nfsd_fcache_disposal *l;
-
-	l = nfsd_alloc_fcache_disposal(net);
-	if (!l)
-		return -ENOMEM;
-	nfsd_add_fcache_disposal(l);
-	return 0;
+	kfree(l);
 }
 
 static void
 nfsd_free_fcache_disposal_net(struct net *net)
 {
-	struct nfsd_fcache_disposal *l;
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+	struct nfsd_fcache_disposal *l = nn->fcache_disposal;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(l, &laundrettes, list) {
-		if (l->net != net)
-			continue;
-		nfsd_del_fcache_disposal(l);
-		rcu_read_unlock();
-		nfsd_free_fcache_disposal(l);
-		return;
-	}
-	rcu_read_unlock();
+	nfsd_free_fcache_disposal(l);
 }
 
 int
 nfsd_file_cache_start_net(struct net *net)
 {
-	return nfsd_alloc_fcache_disposal_net(net);
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+
+	nn->fcache_disposal = nfsd_alloc_fcache_disposal();
+	return nn->fcache_disposal ? 0 : -ENOMEM;
 }
 
 void
diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index 021acdc0d03bb..9e8b77d2a3a47 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -185,6 +185,8 @@ struct nfsd_net {
 
 	/* utsname taken from the process that starts the server */
 	char			nfsd_name[UNX_MAXNODENAME+1];
+
+	struct nfsd_fcache_disposal *fcache_disposal;
 };
 
 /* Simple check to find out if a given net was properly initialized */
-- 
2.43.0



