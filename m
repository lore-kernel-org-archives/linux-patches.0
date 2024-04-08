Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E857E111;
	Mon,  8 Apr 2024 13:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583445; cv=none; b=a7SD751ym+r7Rsa4T8at2sy0LFtGo+dvB/yhEo/E2g3rThROkaF2GtQlOdAfqsRa7wJm/4rYq1tZV3K4JPxgTJZetfcJJHOtj6S8uROYmmbjwI5P/FjBcxV4H/nFhoqDef0rymYtl0XC1ZkYt2lAbNsYva1QaBcOnPnObHodbYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583445; c=relaxed/simple;
	bh=jzSGQ0GvXL6bQhMZJeIupZn8NofFZE0yt5QVmHsORG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKHDg1tB86xb4uTxt3fMNw8wVKKSlCRl5uFO60hf3JfP7/rXzDwt+zoX/SOc4sFVYXZgXardtwAi2THMlUaQEiwAwq+nARQjY9l/QHODZQtwYzVhnp9mIARnwuLtVUBbkFhe3rmaNQqOfLz5pCXNkfnb5FY84UdzCDCdP1hJMvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjjGIFUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjjGIFUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB59C433F1;
	Mon,  8 Apr 2024 13:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583445;
	bh=jzSGQ0GvXL6bQhMZJeIupZn8NofFZE0yt5QVmHsORG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjjGIFUCvtJDElt2Vb2+aad2xJ+fee4TXTCVRdEjyQ4VGoFt61M0neUdYNsbMm88e
	 bJeL2VJ/wA/u3Yo8Zp44/jkIhj3biRFQFqdUTVz/JEx7kAIktv/8N8miZIbJN1oELX
	 UkY4tFk1PgfTTELiWyVx/pDD5gj+iMxBQWrZ5cno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 248/690] NFSD: simplify per-net file cache management
Date: Mon,  8 Apr 2024 14:51:54 +0200
Message-ID: <20240408125408.604219954@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 fs/nfsd/filecache.c | 76 +++++++++------------------------------------
 fs/nfsd/netns.h     |  2 ++
 2 files changed, 17 insertions(+), 61 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index fbc0628c599af..b99852b30308a 100644
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
 
@@ -360,19 +355,13 @@ nfsd_file_list_remove_disposal(struct list_head *dst,
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
@@ -748,7 +737,7 @@ nfsd_file_cache_purge(struct net *net)
 }
 
 static struct nfsd_fcache_disposal *
-nfsd_alloc_fcache_disposal(struct net *net)
+nfsd_alloc_fcache_disposal(void)
 {
 	struct nfsd_fcache_disposal *l;
 
@@ -756,7 +745,6 @@ nfsd_alloc_fcache_disposal(struct net *net)
 	if (!l)
 		return NULL;
 	INIT_WORK(&l->work, nfsd_file_delayed_close);
-	l->net = net;
 	spin_lock_init(&l->lock);
 	INIT_LIST_HEAD(&l->freeme);
 	return l;
@@ -765,61 +753,27 @@ nfsd_alloc_fcache_disposal(struct net *net)
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



