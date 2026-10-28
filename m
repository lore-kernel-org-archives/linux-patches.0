Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216076;
	b=A+/3sbegQ5O9aB6WESYF0NyWK4HphF7cx7DaAb8rkEY5/nsJabjPj1tWtD74nNPdSCLz
	 WrjQEKaGtnXbHEUARRX0JYGh6e0XHA+35vHLrm/0Wz7ujFl1lBPKggHCOpbSzDyT6uUys
	 oo8NLxnPkstzBwoNpEcuwLqt5BRvNhcAcr3JTySoyj3CONasx0DYG3YEZ1WujEJy5LzoG
	 y834PaapO4ENcIHw9Qluxui9e9tvW+w2tRJPPTBS0oE+6kk53yXP6vrntGWL6p9e7bfNS
	 fLS70GKlP81bTAGN0hnF+531PnSYt4660v2MqFvxUFOOEKIesj58IkZwAwDKgOWAO1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wyc1Qlk556BSdycGpXfzfBHx/WITmrTDOf/+BSpXvHM=;
	b=sOey39EUchV/4nPPy9Wa5TNhVOFzTk0qvv/Oeow/QwyZBxzzAB/DKKGesTCYSByJsU5G
	 hOkMQ4kizqJu9639T5QUI2IA8jEfTGKmqb6p/JtNw57DCGbl/FDi1aX0YCJ9nexKvnG3C
	 DfanykMDzbTHkJbU9S8l/16YYcggq6Cp5V968/Q+7Yk+yY1IZycgnDrJtMGgiaUFFAOAR
	 tkOvBTrwXvl1Rx1KbxMl++RgXxdSS5iFY0XD0OEsg7mgm/nLl4Z8VPbTtuOetaKVz3kfi
	 T4NdBkricHb1WDnl8RA5LcZ9kjvNosqML1S9fxpSTiNtT5HFo+wmh/2JYnXtpKGCLeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qrjhuMhT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C220A606A31C;
	Wed, 28 Oct 2026 19:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qrjhuMhT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9AF1F01825;
	Wed, 28 Oct 2026 19:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216075;
	bh=wyc1Qlk556BSdycGpXfzfBHx/WITmrTDOf/+BSpXvHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qrjhuMhTs28Vemvd9k+aW5pmtmFr+SESxg6Tgc63zlj8NZxbcF9u5qrRFhqZC6SDA
	 qgg+fI6eRG1E7rNvwfaVy6xARFa5uCB1uE7BhmWOplab0TGtgYHpfCHKN2SUbw+XNC
	 qULIZi+7ZSaiWE9kTEmZ7KxR3/eQau62hUzFt4rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1432/1887] nfsd: fix fcache_disposal UAF by inlining dispose state into nfsd_net
Date: Wed, 28 Oct 2026 17:58:48 +0100
Message-ID: <20261028170532.047231484@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/nfsd/filecache.c | 67 ++++++++++++---------------------------------
 fs/nfsd/netns.h     |  4 ++-
 2 files changed, 20 insertions(+), 51 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 46eb06e32f0cd..ae8343bdc0450 100644
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
@@ -825,44 +818,15 @@ __nfsd_file_cache_purge(struct net *net)
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
+	spin_lock_init(&nn->fcache_dispose_lock);
+	INIT_LIST_HEAD(&nn->fcache_dispose_list);
+	INIT_WORK(&nn->fcache_dispose_work, nfsd_file_delayed_close);
+	return 0;
 }
 
 /**
@@ -881,8 +845,11 @@ nfsd_file_cache_purge(struct net *net)
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
index b95ad49800533..6291cd57f38eb 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -207,7 +207,9 @@ struct nfsd_net {
 	/* utsname taken from the process that starts the server */
 	char			nfsd_name[UNX_MAXNODENAME+1];
 
-	struct nfsd_fcache_disposal *fcache_disposal;
+	spinlock_t		fcache_dispose_lock;
+	struct list_head	fcache_dispose_list;
+	struct work_struct	fcache_dispose_work;
 
 	siphash_key_t		siphash_key;
 
-- 
2.53.0



