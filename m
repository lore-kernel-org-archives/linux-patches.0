Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEE47C0B2;
	Mon,  8 Apr 2024 13:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583265; cv=none; b=DTr7EEvERcRls0fz/L43zSpQZrjRuDg4eq+L2JKzMG0s37zIwRxjrUYO58uIxa1Em/qjvS0M94zWMA/PnvVjD0jZf5xBhsmg4X/aI5WfA3xMLO7dTnKmgbEoNUOWgHOAWCOVcaTpId5/g/pSSKBuX2q24ry9nYhLWuRHmgsxz4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583265; c=relaxed/simple;
	bh=kezlHAH3skiAka9lZtpvGMBHYTXS53vPZDmyPkbgi0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvNwwMisc4Ld4b5cQrXU3aspe3Y1tXZ9ROOxWUWfXZDtGXvhHyL2dyxtMEMU1Lc3FddszrrTnpFnYwA6kgxwWHpq64DBiXE5yrfobrYr1o/1EydXUtqRF1D0EBxIkl0n2LFbP3QhS/w5zo4/7UNOXF5cPBIsLHCWMybU3Mrym/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxkBCIlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxkBCIlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DF6C433F1;
	Mon,  8 Apr 2024 13:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583264;
	bh=kezlHAH3skiAka9lZtpvGMBHYTXS53vPZDmyPkbgi0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxkBCIlZ2bMmq9O7yDoGVbub8yoR5yIfwWy8u6ldb0kl7PDrr6D3xEEZ/yr2slMnN
	 tJnbQ0+2Ony3Nx/yUfly8WoXkD3xIa+1LSCyavfBD8NRcvZT7FtkKTA2Hy4rmLmScQ
	 fwc3NRHcrwkGWuswvdobbWWTnCRCdY3Ab+tIeVR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 228/690] SUNRPC/NFSD: clean up get/put functions.
Date: Mon,  8 Apr 2024 14:51:34 +0200
Message-ID: <20240408125407.877614113@linuxfoundation.org>
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

[ Upstream commit 8c62d12740a1450d2e8456d5747f440e10db281a ]

svc_destroy() is poorly named - it doesn't necessarily destroy the svc,
it might just reduce the ref count.
nfsd_destroy() is poorly named for the same reason.

This patch:
 - removes the refcount functionality from svc_destroy(), moving it to
   a new svc_put().  Almost all previous callers of svc_destroy() now
   call svc_put().
 - renames nfsd_destroy() to nfsd_put() and improves the code, using
   the new svc_destroy() rather than svc_put()
 - removes a few comments that explain the important for balanced
   get/put calls.  This should be obvious.

The only non-trivial part of this is that svc_destroy() would call
svc_sock_update() on a non-final decrement.  It can no longer do that,
and svc_put() isn't really a good place of it.  This call is now made
from svc_exit_thread() which seems like a good place.  This makes the
call *before* sv_nrthreads is decremented rather than after.  This
is not particularly important as the call just sets a flag which
causes sv_nrthreads set be checked later.  A subsequent patch will
improve the ordering.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svc.c             |  6 +-----
 fs/nfs/callback.c          | 14 ++------------
 fs/nfsd/nfsctl.c           |  4 ++--
 fs/nfsd/nfsd.h             |  2 +-
 fs/nfsd/nfssvc.c           | 30 ++++++++++++++++--------------
 include/linux/sunrpc/svc.h | 26 +++++++++++++++++++++++---
 net/sunrpc/svc.c           | 19 +++++--------------
 7 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 2f50d5b2a8a42..135bd86ed3adb 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -431,10 +431,6 @@ static struct svc_serv *lockd_create_svc(void)
 	 * Check whether we're already up and running.
 	 */
 	if (nlmsvc_rqst)
-		/*
-		 * Note: increase service usage, because later in case of error
-		 * svc_destroy() will be called.
-		 */
 		return svc_get(nlmsvc_rqst->rq_server);
 
 	/*
@@ -495,7 +491,7 @@ int lockd_up(struct net *net, const struct cred *cred)
 	 * so we exit through here on both success and failure.
 	 */
 err_put:
-	svc_destroy(serv);
+	svc_put(serv);
 err_create:
 	mutex_unlock(&nlmsvc_mutex);
 	return error;
diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index 674198e0eb5e1..dddd66749a881 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -267,10 +267,6 @@ static struct svc_serv *nfs_callback_create_svc(int minorversion)
 	 * Check whether we're already up and running.
 	 */
 	if (cb_info->serv)
-		/*
-		 * Note: increase service usage, because later in case of error
-		 * svc_destroy() will be called.
-		 */
 		return svc_get(cb_info->serv);
 
 	switch (minorversion) {
@@ -333,16 +329,10 @@ int nfs_callback_up(u32 minorversion, struct rpc_xprt *xprt)
 		goto err_start;
 
 	cb_info->users++;
-	/*
-	 * svc_create creates the svc_serv with sv_nrthreads == 1, and then
-	 * svc_prepare_thread increments that. So we need to call svc_destroy
-	 * on both success and failure so that the refcount is 1 when the
-	 * thread exits.
-	 */
 err_net:
 	if (!cb_info->users)
 		cb_info->serv = NULL;
-	svc_destroy(serv);
+	svc_put(serv);
 err_create:
 	mutex_unlock(&nfs_callback_mutex);
 	return ret;
@@ -368,7 +358,7 @@ void nfs_callback_down(int minorversion, struct net *net)
 	if (cb_info->users == 0) {
 		svc_get(serv);
 		serv->sv_ops->svo_setup(serv, NULL, 0);
-		svc_destroy(serv);
+		svc_put(serv);
 		dprintk("nfs_callback_down: service destroyed\n");
 		cb_info->serv = NULL;
 	}
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 162866cfe83a2..5c8d985acf5fb 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -743,7 +743,7 @@ static ssize_t __write_ports_addfd(char *buf, struct net *net, const struct cred
 
 	err = svc_addsock(nn->nfsd_serv, fd, buf, SIMPLE_TRANSACTION_LIMIT, cred);
 	if (err < 0 && list_empty(&nn->nfsd_serv->sv_permsocks)) {
-		nfsd_destroy(net);
+		nfsd_put(net);
 		return err;
 	}
 
@@ -796,7 +796,7 @@ static ssize_t __write_ports_addxprt(char *buf, struct net *net, const struct cr
 	if (!list_empty(&nn->nfsd_serv->sv_permsocks))
 		nn->nfsd_serv->sv_nrthreads--;
 	 else
-		nfsd_destroy(net);
+		nfsd_put(net);
 	return err;
 }
 
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 498e5a4898260..3e5008b475ff0 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -97,7 +97,7 @@ int		nfsd_pool_stats_open(struct inode *, struct file *);
 int		nfsd_pool_stats_release(struct inode *, struct file *);
 void		nfsd_shutdown_threads(struct net *net);
 
-void		nfsd_destroy(struct net *net);
+void		nfsd_put(struct net *net);
 
 bool		i_am_nfsd(void);
 
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 0f84151011088..4aee1cfe0d1bb 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -623,7 +623,7 @@ void nfsd_shutdown_threads(struct net *net)
 	svc_get(serv);
 	/* Kill outstanding nfsd threads */
 	serv->sv_ops->svo_setup(serv, NULL, 0);
-	nfsd_destroy(net);
+	nfsd_put(net);
 	mutex_unlock(&nfsd_mutex);
 	/* Wait for shutdown of nfsd_serv to complete */
 	wait_for_completion(&nn->nfsd_shutdown_complete);
@@ -656,7 +656,10 @@ int nfsd_create_serv(struct net *net)
 	nn->nfsd_serv->sv_maxconn = nn->max_connections;
 	error = svc_bind(nn->nfsd_serv, net);
 	if (error < 0) {
-		svc_destroy(nn->nfsd_serv);
+		/* NOT nfsd_put() as notifiers (see below) haven't
+		 * been set up yet.
+		 */
+		svc_put(nn->nfsd_serv);
 		nfsd_complete_shutdown(net);
 		return error;
 	}
@@ -697,16 +700,16 @@ int nfsd_get_nrthreads(int n, int *nthreads, struct net *net)
 	return 0;
 }
 
-void nfsd_destroy(struct net *net)
+void nfsd_put(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
-	int destroy = (nn->nfsd_serv->sv_nrthreads == 1);
 
-	if (destroy)
+	nn->nfsd_serv->sv_nrthreads -= 1;
+	if (nn->nfsd_serv->sv_nrthreads == 0) {
 		svc_shutdown_net(nn->nfsd_serv, net);
-	svc_destroy(nn->nfsd_serv);
-	if (destroy)
+		svc_destroy(nn->nfsd_serv);
 		nfsd_complete_shutdown(net);
+	}
 }
 
 int nfsd_set_nrthreads(int n, int *nthreads, struct net *net)
@@ -758,7 +761,7 @@ int nfsd_set_nrthreads(int n, int *nthreads, struct net *net)
 		if (err)
 			break;
 	}
-	nfsd_destroy(net);
+	nfsd_put(net);
 	return err;
 }
 
@@ -795,7 +798,7 @@ nfsd_svc(int nrservs, struct net *net, const struct cred *cred)
 
 	error = nfsd_startup_net(net, cred);
 	if (error)
-		goto out_destroy;
+		goto out_put;
 	error = nn->nfsd_serv->sv_ops->svo_setup(nn->nfsd_serv,
 			NULL, nrservs);
 	if (error)
@@ -808,8 +811,8 @@ nfsd_svc(int nrservs, struct net *net, const struct cred *cred)
 out_shutdown:
 	if (error < 0 && !nfsd_up_before)
 		nfsd_shutdown_net(net);
-out_destroy:
-	nfsd_destroy(net);		/* Release server */
+out_put:
+	nfsd_put(net);
 out:
 	mutex_unlock(&nfsd_mutex);
 	return error;
@@ -982,7 +985,7 @@ nfsd(void *vrqstp)
 	/* Release the thread */
 	svc_exit_thread(rqstp);
 
-	nfsd_destroy(net);
+	nfsd_put(net);
 
 	/* Release module */
 	mutex_unlock(&nfsd_mutex);
@@ -1109,8 +1112,7 @@ int nfsd_pool_stats_release(struct inode *inode, struct file *file)
 	struct net *net = inode->i_sb->s_fs_info;
 
 	mutex_lock(&nfsd_mutex);
-	/* this function really, really should have been called svc_put() */
-	nfsd_destroy(net);
+	nfsd_put(net);
 	mutex_unlock(&nfsd_mutex);
 	return ret;
 }
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 80d44df8663db..b378e9ad141b4 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -114,8 +114,13 @@ struct svc_serv {
 #endif /* CONFIG_SUNRPC_BACKCHANNEL */
 };
 
-/*
- * We use sv_nrthreads as a reference count.  svc_destroy() drops
+/**
+ * svc_get() - increment reference count on a SUNRPC serv
+ * @serv:  the svc_serv to have count incremented
+ *
+ * Returns: the svc_serv that was passed in.
+ *
+ * We use sv_nrthreads as a reference count.  svc_put() drops
  * this refcount, so we need to bump it up around operations that
  * change the number of threads.  Horrible, but there it is.
  * Should be called with the "service mutex" held.
@@ -126,6 +131,22 @@ static inline struct svc_serv *svc_get(struct svc_serv *serv)
 	return serv;
 }
 
+void svc_destroy(struct svc_serv *serv);
+
+/**
+ * svc_put - decrement reference count on a SUNRPC serv
+ * @serv:  the svc_serv to have count decremented
+ *
+ * When the reference count reaches zero, svc_destroy()
+ * is called to clean up and free the serv.
+ */
+static inline void svc_put(struct svc_serv *serv)
+{
+	serv->sv_nrthreads -= 1;
+	if (serv->sv_nrthreads == 0)
+		svc_destroy(serv);
+}
+
 /*
  * Maximum payload size supported by a kernel RPC server.
  * This is use to determine the max number of pages nfsd is
@@ -517,7 +538,6 @@ struct svc_serv *  svc_create_pooled(struct svc_program *, unsigned int,
 int		   svc_set_num_threads(struct svc_serv *, struct svc_pool *, int);
 int		   svc_set_num_threads_sync(struct svc_serv *, struct svc_pool *, int);
 int		   svc_pool_stats_open(struct svc_serv *serv, struct file *file);
-void		   svc_destroy(struct svc_serv *);
 void		   svc_shutdown_net(struct svc_serv *, struct net *);
 int		   svc_process(struct svc_rqst *);
 int		   bc_svc_process(struct svc_serv *, struct rpc_rqst *,
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 36a3ad9336d6f..85f324418d175 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -528,17 +528,7 @@ EXPORT_SYMBOL_GPL(svc_shutdown_net);
 void
 svc_destroy(struct svc_serv *serv)
 {
-	dprintk("svc: svc_destroy(%s, %d)\n",
-				serv->sv_program->pg_name,
-				serv->sv_nrthreads);
-
-	if (serv->sv_nrthreads) {
-		if (--(serv->sv_nrthreads) != 0) {
-			svc_sock_update_bufs(serv);
-			return;
-		}
-	} else
-		printk("svc_destroy: no threads for serv=%p!\n", serv);
+	dprintk("svc: svc_destroy(%s)\n", serv->sv_program->pg_name);
 
 	del_timer_sync(&serv->sv_temptimer);
 
@@ -896,9 +886,10 @@ svc_exit_thread(struct svc_rqst *rqstp)
 
 	svc_rqst_free(rqstp);
 
-	/* Release the server */
-	if (serv)
-		svc_destroy(serv);
+	if (!serv)
+		return;
+	svc_sock_update_bufs(serv);
+	svc_destroy(serv);
 }
 EXPORT_SYMBOL_GPL(svc_exit_thread);
 
-- 
2.43.0



