Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F3D8529C;
	Mon,  8 Apr 2024 13:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583734; cv=none; b=S+68rsIguhFy4IM4QrveCSV5ruyfgb9k2LE1L9S7UeMj0mgKC5Cgs2cAmrRU/q37pR/dAjLtIHKc1j5gEwADJHJwue44F0aPSV8XSQvJ2AKEqxilCSerBrwMIpSOCk4oohNY9j6SOr4y7JP9vqDBTGfyRc9opLhRXyXqdGBIops=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583734; c=relaxed/simple;
	bh=PJQMLLsBdZPRcdy4CIQRHxTdjg/WgAQKgeflSa1SK1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrqJvwHvALszqZzNHtCBpCUBMR5wANqk1sQ/ioe/9SwOjqEgGBAMSZxD/jynXXlLjML+e0AuCh1nHM41oFGy9O9phwuE0m4nAKXOovu0UP56cAQcHeQHlkR9FglDnnxjXlCJkmZLC5K1eiSlblOaEczzzkPaztT5IetHk0BzcuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pj4V7HRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pj4V7HRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6941BC433F1;
	Mon,  8 Apr 2024 13:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583733;
	bh=PJQMLLsBdZPRcdy4CIQRHxTdjg/WgAQKgeflSa1SK1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pj4V7HRXBRpYwMdE6/H7J2IH0QtNArHze9BfIY81sr9AYxGWNIpX/sq29i4Kt0NPY
	 zsSvakM6vf4xd23WX4JEqOLkILY7JsXsl1MJYgdSuyPXd4LSrEm3+x1BM6Ia1GI32k
	 cfrchK3VUbQYp8dND9IeJKqtifiIQ6fO4X77hPac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 279/690] NFSD: Move svc_serv_ops::svo_function into struct svc_serv
Date: Mon,  8 Apr 2024 14:52:25 +0200
Message-ID: <20240408125409.709246705@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 37902c6313090235c847af89c5515591261ee338 ]

Hoist svo_function back into svc_serv and remove struct
svc_serv_ops, since the struct is now devoid of fields.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svc.c             |  6 +-----
 fs/nfs/callback.c          | 43 ++++++++++----------------------------
 fs/nfsd/nfssvc.c           |  7 +------
 include/linux/sunrpc/svc.h | 14 ++++---------
 net/sunrpc/svc.c           | 37 ++++++++++++++++++++++----------
 5 files changed, 43 insertions(+), 64 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index bfde31124f3af..59ef8a1f843f3 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -349,10 +349,6 @@ static struct notifier_block lockd_inet6addr_notifier = {
 };
 #endif
 
-static const struct svc_serv_ops lockd_sv_ops = {
-	.svo_function		= lockd,
-};
-
 static int lockd_get(void)
 {
 	struct svc_serv *serv;
@@ -376,7 +372,7 @@ static int lockd_get(void)
 		nlm_timeout = LOCKD_DFLT_TIMEO;
 	nlmsvc_timeout = nlm_timeout * HZ;
 
-	serv = svc_create(&nlmsvc_program, LOCKD_BUFSIZE, &lockd_sv_ops);
+	serv = svc_create(&nlmsvc_program, LOCKD_BUFSIZE, lockd);
 	if (!serv) {
 		printk(KERN_WARNING "lockd_up: create service failed\n");
 		return -ENOMEM;
diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index a494f9e7bd0a0..456af7d230cf1 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -231,29 +231,10 @@ static int nfs_callback_up_net(int minorversion, struct svc_serv *serv,
 	return ret;
 }
 
-static const struct svc_serv_ops nfs40_cb_sv_ops = {
-	.svo_function		= nfs4_callback_svc,
-};
-#if defined(CONFIG_NFS_V4_1)
-static const struct svc_serv_ops nfs41_cb_sv_ops = {
-	.svo_function		= nfs41_callback_svc,
-};
-
-static const struct svc_serv_ops *nfs4_cb_sv_ops[] = {
-	[0] = &nfs40_cb_sv_ops,
-	[1] = &nfs41_cb_sv_ops,
-};
-#else
-static const struct svc_serv_ops *nfs4_cb_sv_ops[] = {
-	[0] = &nfs40_cb_sv_ops,
-	[1] = NULL,
-};
-#endif
-
 static struct svc_serv *nfs_callback_create_svc(int minorversion)
 {
 	struct nfs_callback_data *cb_info = &nfs_callback_info[minorversion];
-	const struct svc_serv_ops *sv_ops;
+	int (*threadfn)(void *data);
 	struct svc_serv *serv;
 
 	/*
@@ -262,17 +243,6 @@ static struct svc_serv *nfs_callback_create_svc(int minorversion)
 	if (cb_info->serv)
 		return svc_get(cb_info->serv);
 
-	switch (minorversion) {
-	case 0:
-		sv_ops = nfs4_cb_sv_ops[0];
-		break;
-	default:
-		sv_ops = nfs4_cb_sv_ops[1];
-	}
-
-	if (sv_ops == NULL)
-		return ERR_PTR(-ENOTSUPP);
-
 	/*
 	 * Sanity check: if there's no task,
 	 * we should be the first user ...
@@ -281,7 +251,16 @@ static struct svc_serv *nfs_callback_create_svc(int minorversion)
 		printk(KERN_WARNING "nfs_callback_create_svc: no kthread, %d users??\n",
 			cb_info->users);
 
-	serv = svc_create(&nfs4_callback_program, NFS4_CALLBACK_BUFSIZE, sv_ops);
+	threadfn = nfs4_callback_svc;
+#if defined(CONFIG_NFS_V4_1)
+	if (minorversion)
+		threadfn = nfs41_callback_svc;
+#else
+	if (minorversion)
+		return ERR_PTR(-ENOTSUPP);
+#endif
+	serv = svc_create(&nfs4_callback_program, NFS4_CALLBACK_BUFSIZE,
+			  threadfn);
 	if (!serv) {
 		printk(KERN_ERR "nfs_callback_create_svc: create service failed\n");
 		return ERR_PTR(-ENOMEM);
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index d25d4c12a499a..2f74be98ff2d9 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -612,10 +612,6 @@ static int nfsd_get_default_max_blksize(void)
 	return ret;
 }
 
-static const struct svc_serv_ops nfsd_thread_sv_ops = {
-	.svo_function		= nfsd,
-};
-
 void nfsd_shutdown_threads(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
@@ -654,8 +650,7 @@ int nfsd_create_serv(struct net *net)
 	if (nfsd_max_blksize == 0)
 		nfsd_max_blksize = nfsd_get_default_max_blksize();
 	nfsd_reset_versions(nn);
-	serv = svc_create_pooled(&nfsd_program, nfsd_max_blksize,
-				 &nfsd_thread_sv_ops);
+	serv = svc_create_pooled(&nfsd_program, nfsd_max_blksize, nfsd);
 	if (serv == NULL)
 		return -ENOMEM;
 
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 61768495354a0..1d9a81bab3fa2 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -52,13 +52,6 @@ struct svc_pool {
 	unsigned long		sp_flags;
 } ____cacheline_aligned_in_smp;
 
-struct svc_serv;
-
-struct svc_serv_ops {
-	/* function for service threads to run */
-	int		(*svo_function)(void *);
-};
-
 /*
  * RPC service.
  *
@@ -91,7 +84,8 @@ struct svc_serv {
 
 	unsigned int		sv_nrpools;	/* number of thread pools */
 	struct svc_pool *	sv_pools;	/* array of thread pools */
-	const struct svc_serv_ops *sv_ops;	/* server operations */
+	int			(*sv_threadfn)(void *data);
+
 #if defined(CONFIG_SUNRPC_BACKCHANNEL)
 	struct list_head	sv_cb_list;	/* queue for callback requests
 						 * that arrive over the same
@@ -494,7 +488,7 @@ int svc_rpcb_setup(struct svc_serv *serv, struct net *net);
 void svc_rpcb_cleanup(struct svc_serv *serv, struct net *net);
 int svc_bind(struct svc_serv *serv, struct net *net);
 struct svc_serv *svc_create(struct svc_program *, unsigned int,
-			    const struct svc_serv_ops *);
+			    int (*threadfn)(void *data));
 struct svc_rqst *svc_rqst_alloc(struct svc_serv *serv,
 					struct svc_pool *pool, int node);
 void		   svc_rqst_replace_page(struct svc_rqst *rqstp,
@@ -502,7 +496,7 @@ void		   svc_rqst_replace_page(struct svc_rqst *rqstp,
 void		   svc_rqst_free(struct svc_rqst *);
 void		   svc_exit_thread(struct svc_rqst *);
 struct svc_serv *  svc_create_pooled(struct svc_program *, unsigned int,
-			const struct svc_serv_ops *);
+				     int (*threadfn)(void *data));
 int		   svc_set_num_threads(struct svc_serv *, struct svc_pool *, int);
 int		   svc_pool_stats_open(struct svc_serv *serv, struct file *file);
 int		   svc_process(struct svc_rqst *);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 239d10018216a..87da3ff46ce9a 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -448,7 +448,7 @@ __svc_init_bc(struct svc_serv *serv)
  */
 static struct svc_serv *
 __svc_create(struct svc_program *prog, unsigned int bufsize, int npools,
-	     const struct svc_serv_ops *ops)
+	     int (*threadfn)(void *data))
 {
 	struct svc_serv	*serv;
 	unsigned int vers;
@@ -465,7 +465,7 @@ __svc_create(struct svc_program *prog, unsigned int bufsize, int npools,
 		bufsize = RPCSVC_MAXPAYLOAD;
 	serv->sv_max_payload = bufsize? bufsize : 4096;
 	serv->sv_max_mesg  = roundup(serv->sv_max_payload + PAGE_SIZE, PAGE_SIZE);
-	serv->sv_ops = ops;
+	serv->sv_threadfn = threadfn;
 	xdrsize = 0;
 	while (prog) {
 		prog->pg_lovers = prog->pg_nvers-1;
@@ -511,22 +511,37 @@ __svc_create(struct svc_program *prog, unsigned int bufsize, int npools,
 	return serv;
 }
 
-struct svc_serv *
-svc_create(struct svc_program *prog, unsigned int bufsize,
-	   const struct svc_serv_ops *ops)
+/**
+ * svc_create - Create an RPC service
+ * @prog: the RPC program the new service will handle
+ * @bufsize: maximum message size for @prog
+ * @threadfn: a function to service RPC requests for @prog
+ *
+ * Returns an instantiated struct svc_serv object or NULL.
+ */
+struct svc_serv *svc_create(struct svc_program *prog, unsigned int bufsize,
+			    int (*threadfn)(void *data))
 {
-	return __svc_create(prog, bufsize, /*npools*/1, ops);
+	return __svc_create(prog, bufsize, 1, threadfn);
 }
 EXPORT_SYMBOL_GPL(svc_create);
 
-struct svc_serv *
-svc_create_pooled(struct svc_program *prog, unsigned int bufsize,
-		  const struct svc_serv_ops *ops)
+/**
+ * svc_create_pooled - Create an RPC service with pooled threads
+ * @prog: the RPC program the new service will handle
+ * @bufsize: maximum message size for @prog
+ * @threadfn: a function to service RPC requests for @prog
+ *
+ * Returns an instantiated struct svc_serv object or NULL.
+ */
+struct svc_serv *svc_create_pooled(struct svc_program *prog,
+				   unsigned int bufsize,
+				   int (*threadfn)(void *data))
 {
 	struct svc_serv *serv;
 	unsigned int npools = svc_pool_map_get();
 
-	serv = __svc_create(prog, bufsize, npools, ops);
+	serv = __svc_create(prog, bufsize, npools, threadfn);
 	if (!serv)
 		goto out_err;
 	return serv;
@@ -736,7 +751,7 @@ svc_start_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 		if (IS_ERR(rqstp))
 			return PTR_ERR(rqstp);
 
-		task = kthread_create_on_node(serv->sv_ops->svo_function, rqstp,
+		task = kthread_create_on_node(serv->sv_threadfn, rqstp,
 					      node, "%s", serv->sv_name);
 		if (IS_ERR(task)) {
 			svc_exit_thread(rqstp);
-- 
2.43.0



