Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9D07D408;
	Mon,  8 Apr 2024 13:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583323; cv=none; b=THAl4ug9+5fEcltELg2rXVIgi/y36QRLl0TFDD7cbh6hSUqzwUjCRWP3PvR5PmBdTDBTRn7vidWBhjP1BvX4g7bobkZwj1HbGXam6j2DUkfIZLujldgEZfR9UiatS45T4jxGUj5Gy2MA6Ppi00yj30WESZhTs3SZySrvZVJuB0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583323; c=relaxed/simple;
	bh=rJKwWTbv5AZqniT1xTeJrMjhn5ZGIiide8msjI8NrJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T06Rh5Yk+32NatCvzNI4nKzK4udTbnFuxdGuVhaXAR/OlAs+o+OMUpkWEiaOKAJFTVq72DbUtZhbm19Nc52WyLqTAO1ztLkQE91V1ZO7wDNyPgFUVwzPdcXB80XJnPw4RhaXvsX1VsDHRd5arOEeRS3GUJ5ELbytkugcyHiUsEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7G4+wrh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7G4+wrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E6AC433F1;
	Mon,  8 Apr 2024 13:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583323;
	bh=rJKwWTbv5AZqniT1xTeJrMjhn5ZGIiide8msjI8NrJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7G4+wrhsxRmDUHhLaphv9yDbSHiS3MYnB6bFk1b16+gltFeU2klvlsZGjpyh93oM
	 HcttUXh0pnyVBl2WXF6Th4x9mRN4/4flL5xngCHnWQ313An/RNKdByOXDTU6fi6gEM
	 v7fYIcLGVBscpheM08rDwAzjxK2ZqcNijbqv6HLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 234/690] SUNRPC: discard svo_setup and rename svc_set_num_threads_sync()
Date: Mon,  8 Apr 2024 14:51:40 +0200
Message-ID: <20240408125408.099322784@linuxfoundation.org>
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

[ Upstream commit 3ebdbe5203a874614819700d3f470724cb803709 ]

The ->svo_setup callback serves no purpose.  It is always called from
within the same module that chooses which callback is needed.  So
discard it and call the relevant function directly.

Now that svc_set_num_threads() is no longer used remove it and rename
svc_set_num_threads_sync() to remove the "_sync" suffix.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfs/callback.c          |  8 +++----
 fs/nfsd/nfssvc.c           | 11 ++++-----
 include/linux/sunrpc/svc.h |  4 ----
 net/sunrpc/svc.c           | 49 ++------------------------------------
 4 files changed, 10 insertions(+), 62 deletions(-)

diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index 09ec60b99f65e..422055a1092f0 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -172,9 +172,9 @@ static int nfs_callback_start_svc(int minorversion, struct rpc_xprt *xprt,
 	if (serv->sv_nrthreads == nrservs)
 		return 0;
 
-	ret = serv->sv_ops->svo_setup(serv, NULL, nrservs);
+	ret = svc_set_num_threads(serv, NULL, nrservs);
 	if (ret) {
-		serv->sv_ops->svo_setup(serv, NULL, 0);
+		svc_set_num_threads(serv, NULL, 0);
 		return ret;
 	}
 	dprintk("nfs_callback_up: service started\n");
@@ -235,14 +235,12 @@ static int nfs_callback_up_net(int minorversion, struct svc_serv *serv,
 static const struct svc_serv_ops nfs40_cb_sv_ops = {
 	.svo_function		= nfs4_callback_svc,
 	.svo_enqueue_xprt	= svc_xprt_do_enqueue,
-	.svo_setup		= svc_set_num_threads_sync,
 	.svo_module		= THIS_MODULE,
 };
 #if defined(CONFIG_NFS_V4_1)
 static const struct svc_serv_ops nfs41_cb_sv_ops = {
 	.svo_function		= nfs41_callback_svc,
 	.svo_enqueue_xprt	= svc_xprt_do_enqueue,
-	.svo_setup		= svc_set_num_threads_sync,
 	.svo_module		= THIS_MODULE,
 };
 
@@ -357,7 +355,7 @@ void nfs_callback_down(int minorversion, struct net *net)
 	cb_info->users--;
 	if (cb_info->users == 0) {
 		svc_get(serv);
-		serv->sv_ops->svo_setup(serv, NULL, 0);
+		svc_set_num_threads(serv, NULL, 0);
 		svc_put(serv);
 		dprintk("nfs_callback_down: service destroyed\n");
 		cb_info->serv = NULL;
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 6b10415e4006b..8d49dfbe03f85 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -593,7 +593,6 @@ static const struct svc_serv_ops nfsd_thread_sv_ops = {
 	.svo_shutdown		= nfsd_last_thread,
 	.svo_function		= nfsd,
 	.svo_enqueue_xprt	= svc_xprt_do_enqueue,
-	.svo_setup		= svc_set_num_threads_sync,
 	.svo_module		= THIS_MODULE,
 };
 
@@ -611,7 +610,7 @@ void nfsd_shutdown_threads(struct net *net)
 
 	svc_get(serv);
 	/* Kill outstanding nfsd threads */
-	serv->sv_ops->svo_setup(serv, NULL, 0);
+	svc_set_num_threads(serv, NULL, 0);
 	nfsd_put(net);
 	mutex_unlock(&nfsd_mutex);
 }
@@ -750,8 +749,9 @@ int nfsd_set_nrthreads(int n, int *nthreads, struct net *net)
 	/* apply the new numbers */
 	svc_get(nn->nfsd_serv);
 	for (i = 0; i < n; i++) {
-		err = nn->nfsd_serv->sv_ops->svo_setup(nn->nfsd_serv,
-				&nn->nfsd_serv->sv_pools[i], nthreads[i]);
+		err = svc_set_num_threads(nn->nfsd_serv,
+					  &nn->nfsd_serv->sv_pools[i],
+					  nthreads[i]);
 		if (err)
 			break;
 	}
@@ -793,8 +793,7 @@ nfsd_svc(int nrservs, struct net *net, const struct cred *cred)
 	error = nfsd_startup_net(net, cred);
 	if (error)
 		goto out_put;
-	error = nn->nfsd_serv->sv_ops->svo_setup(nn->nfsd_serv,
-			NULL, nrservs);
+	error = svc_set_num_threads(nn->nfsd_serv, NULL, nrservs);
 	if (error)
 		goto out_shutdown;
 	error = nn->nfsd_serv->sv_nrthreads;
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index d22bd62093146..71b3a9e3fc4a8 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -64,9 +64,6 @@ struct svc_serv_ops {
 	/* queue up a transport for servicing */
 	void		(*svo_enqueue_xprt)(struct svc_xprt *);
 
-	/* set up thread (or whatever) execution context */
-	int		(*svo_setup)(struct svc_serv *, struct svc_pool *, int);
-
 	/* optional module to count when adding threads (pooled svcs only) */
 	struct module	*svo_module;
 };
@@ -543,7 +540,6 @@ void		   svc_pool_map_put(void);
 struct svc_serv *  svc_create_pooled(struct svc_program *, unsigned int,
 			const struct svc_serv_ops *);
 int		   svc_set_num_threads(struct svc_serv *, struct svc_pool *, int);
-int		   svc_set_num_threads_sync(struct svc_serv *, struct svc_pool *, int);
 int		   svc_pool_stats_open(struct svc_serv *serv, struct file *file);
 void		   svc_shutdown_net(struct svc_serv *, struct net *);
 int		   svc_process(struct svc_rqst *);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index c8a0649e5cdf1..07443f7e2d870 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -743,58 +743,13 @@ svc_start_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 	return 0;
 }
 
-
-/* destroy old threads */
-static int
-svc_signal_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
-{
-	struct task_struct *task;
-	unsigned int state = serv->sv_nrthreads-1;
-
-	/* destroy old threads */
-	do {
-		task = choose_victim(serv, pool, &state);
-		if (task == NULL)
-			break;
-		send_sig(SIGINT, task, 1);
-		nrservs++;
-	} while (nrservs < 0);
-
-	return 0;
-}
-
 /*
  * Create or destroy enough new threads to make the number
  * of threads the given number.  If `pool' is non-NULL, applies
  * only to threads in that pool, otherwise round-robins between
  * all pools.  Caller must ensure that mutual exclusion between this and
  * server startup or shutdown.
- *
- * Destroying threads relies on the service threads filling in
- * rqstp->rq_task, which only the nfs ones do.  Assumes the serv
- * has been created using svc_create_pooled().
- *
- * Based on code that used to be in nfsd_svc() but tweaked
- * to be pool-aware.
  */
-int
-svc_set_num_threads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
-{
-	if (pool == NULL) {
-		nrservs -= serv->sv_nrthreads;
-	} else {
-		spin_lock_bh(&pool->sp_lock);
-		nrservs -= pool->sp_nrthreads;
-		spin_unlock_bh(&pool->sp_lock);
-	}
-
-	if (nrservs > 0)
-		return svc_start_kthreads(serv, pool, nrservs);
-	if (nrservs < 0)
-		return svc_signal_kthreads(serv, pool, nrservs);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(svc_set_num_threads);
 
 /* destroy old threads */
 static int
@@ -819,7 +774,7 @@ svc_stop_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 }
 
 int
-svc_set_num_threads_sync(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
+svc_set_num_threads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 {
 	if (pool == NULL) {
 		nrservs -= serv->sv_nrthreads;
@@ -835,7 +790,7 @@ svc_set_num_threads_sync(struct svc_serv *serv, struct svc_pool *pool, int nrser
 		return svc_stop_kthreads(serv, pool, nrservs);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(svc_set_num_threads_sync);
+EXPORT_SYMBOL_GPL(svc_set_num_threads);
 
 /**
  * svc_rqst_replace_page - Replace one page in rq_pages[]
-- 
2.43.0



