Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1382F4CDA2E;
	Tue, 13 Oct 2026 12:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894233; cv=none; b=VZE6AHEAQEXT1uY8EnOps7V+/FNE8QGVyh/xUoBkZzgLAaqFvFWkADeKH2ArhnkXAFL5uC2Xq7p9dTnj2aiMQcYKWqH6TppRql89BrVIwCVXHuACdNT/1JI4DhO79HoKDyGcK//8Fqt9pudaNebtGMZlwTSEEpkYhkwFqkTKcz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894233; c=relaxed/simple;
	bh=BhTZZiZA59ghWyAdcbtDmO9G8ZTmtJNyahsA1qvAIBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rju4cBOz+9jaOObqbJHM8Tc8lzuOe079QwuKfPhgiJ+sv1y1VU6Tf/MAwhLez+i6LtF/CY0INRHFX7wBINluympqetjf5yjc0R8U2SyoYEqvMdvK57HZqVHEzAd/iyPPJRewPO2/6tq3ayvwDKvHUNsI9I50T64l+e49OnJF2ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpDg425F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpDg425F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D951F000FF;
	Tue, 13 Oct 2026 12:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894231;
	bh=mqr5+cRKyY+J08jWKYSCHfJB4ctRTfW1dKYtfKR2PcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpDg425F/VH0U1a6+dpi9CzXM66cDEd/cv7G26YHbGAigq1djIwRayHW04B83fZ9N
	 42gDSVhn2783L0AJ/xgzrnHg6EPCAj6LAfVH95G12n2l6OzJs6n4YWQ9VT3yIb9FR/
	 chnl1NTIV2NTIT2UM9CChKCqM+DmOhAjuD7hAgzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 492/621] nfsd: use workqueue enable/disable APIs for v4_end_grace sync
Date: Tue, 13 Oct 2026 13:38:07 +0200
Message-ID: <20261013112932.503405216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

[ Upstream commit 27e383ddeb3c88e20874c545285f2dce1a98f56a ]

"nfsd: provide locking for v4_end_grace" introduced a
client_tracking_active flag protected by nn->client_lock to prevent
the laundromat from being scheduled before client tracking
initialization or after shutdown begins. That commit is suitable for
backporting to LTS kernels that predate commit 86898fa6b8cd
("workqueue: Implement disable/enable for (delayed) work items").

However, the workqueue subsystem in recent kernels provides
enable_delayed_work() and disable_delayed_work_sync() for this
purpose. Using this mechanism enable us to remove the
client_tracking_active flag and associated spinlock operations
while preserving the same synchronization guarantees, which is
a cleaner long-term approach.

Signed-off-by: NeilBrown <neil@brown.name>
Tested-by: Li Lingfeng <lilingfeng3@huawei.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 11a5fe42e181 ("nfsd: convert nfsd_net boolean flags to unsigned long flags word")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/netns.h     |  1 -
 fs/nfsd/nfs4state.c | 22 +++++++++-------------
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index f3b440ae98fed..41b49f86e5baa 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -67,7 +67,6 @@ struct nfsd_net {
 	struct lock_manager nfsd4_manager;
 	bool grace_ended;
 	bool grace_end_forced;
-	bool client_tracking_active;
 	time64_t boot_time;
 	time64_t boot_time_bt;	/* same instant in CLOCK_BOOTTIME */
 
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index fbaf2f1352748..57d235fc39ac8 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6805,14 +6805,14 @@ bool nfsd4_force_end_grace(struct nfsd_net *nn)
 {
 	if (!nn->client_tracking_ops)
 		return false;
-	spin_lock(&nn->client_lock);
-	if (nn->grace_ended || !nn->client_tracking_active) {
-		spin_unlock(&nn->client_lock);
+	if (READ_ONCE(nn->grace_ended))
 		return false;
-	}
+	/* laundromat_work must be initialised now, though it might be disabled */
 	WRITE_ONCE(nn->grace_end_forced, true);
+	/* mod_delayed_work() doesn't queue work after
+	 * nfs4_state_shutdown_net() has called disable_delayed_work_sync()
+	 */
 	mod_delayed_work(laundry_wq, &nn->laundromat_work, 0);
-	spin_unlock(&nn->client_lock);
 	return true;
 }
 
@@ -9201,7 +9201,6 @@ static int nfs4_state_create_net(struct net *net)
 	nn->boot_time_bt = ktime_get_boottime_seconds();
 	nn->grace_ended = false;
 	nn->grace_end_forced = false;
-	nn->client_tracking_active = false;
 	nn->nfsd4_manager.block_opens = true;
 	INIT_LIST_HEAD(&nn->nfsd4_manager.list);
 	INIT_LIST_HEAD(&nn->client_lru);
@@ -9217,6 +9216,8 @@ static int nfs4_state_create_net(struct net *net)
 	INIT_LIST_HEAD(&nn->blocked_locks_lru);
 
 	INIT_DELAYED_WORK(&nn->laundromat_work, laundromat_main);
+	/* Make sure this cannot run until client tracking is initialised */
+	disable_delayed_work(&nn->laundromat_work);
 	INIT_WORK(&nn->nfsd_shrinker_work, nfsd4_state_shrinker_worker);
 	get_net(net);
 
@@ -9284,9 +9285,7 @@ nfs4_state_start_net(struct net *net)
 	locks_start_grace(net, &nn->nfsd4_manager);
 	nfsd4_client_tracking_init(net);
 	/* safe for laundromat to run now */
-	spin_lock(&nn->client_lock);
-	nn->client_tracking_active = true;
-	spin_unlock(&nn->client_lock);
+	enable_delayed_work(&nn->laundromat_work);
 	if (nn->track_reclaim_completes && nn->reclaim_str_hashtbl_size == 0)
 		goto skip_grace;
 	printk(KERN_INFO "NFSD: starting %lld-second grace period (net %x)\n",
@@ -9335,10 +9334,7 @@ nfs4_state_shutdown_net(struct net *net)
 
 	shrinker_free(nn->nfsd_client_shrinker);
 	cancel_work_sync(&nn->nfsd_shrinker_work);
-	spin_lock(&nn->client_lock);
-	nn->client_tracking_active = false;
-	spin_unlock(&nn->client_lock);
-	cancel_delayed_work_sync(&nn->laundromat_work);
+	disable_delayed_work_sync(&nn->laundromat_work);
 	locks_end_grace(&nn->nfsd4_manager);
 
 	INIT_LIST_HEAD(&reaplist);
-- 
2.53.0



