Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579B32E405;
	Mon,  8 Apr 2024 13:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583713; cv=none; b=rgTohCQI7pcfJe2j+OfVupQ6zFO2LBFSqFSi0WBteqRnho10dRlKt409n/PxEbw0V+JmWEs1xqYVGgD6ymc3SBkY/r33GjYf0hHpa68+wI0b97zyF3rW4fpNAavTHZ40bfRd4l4SICqvMmBf23uh8q9ghbFXiNm1NOsI+ooy6HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583713; c=relaxed/simple;
	bh=cq7KfDku9Ql7nYuBiarzKOvRWVvrbcaR0YZBMVllqtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUs8+sMry64SChYoLFnDmFVzvCuss0MTJWvUfWacKXAYfz9gfnDuIXPAOssOb8Aa9Smo8QpU1KcLzfp1DKxaGJKBzCB19k0RsT8D9wrPpo3Crgl1o2bSLCcPvXd+f9h29opWfhq2IZ48KU6Um5BYDNcK64SFjA7uacv7rpbK2+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1ntwL+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1ntwL+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1746C433F1;
	Mon,  8 Apr 2024 13:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583713;
	bh=cq7KfDku9Ql7nYuBiarzKOvRWVvrbcaR0YZBMVllqtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1ntwL+IE7TjPkYQOzWI5zpwlRhuEC1jfQ10S9dvdbAe7u23mqt9/RzxQS+P4z5uO
	 XsDHfepMhRIKhXQvJTuUAHsXKp4nH/mhmYkSX/yqqD5iTjOS5Y3iGnxOx0R1+w4Fbm
	 kVmbkPlq7cnSiwGcSd0fBOItbezhb8w7//z7zzOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 277/690] SUNRPC: Remove svc_shutdown_net()
Date: Mon,  8 Apr 2024 14:52:23 +0200
Message-ID: <20240408125409.640397994@linuxfoundation.org>
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

[ Upstream commit c7d7ec8f043e53ad16e30f5ebb8b9df415ec0f2b ]

Clean up: svc_shutdown_net() now does nothing but call
svc_close_net(). Replace all external call sites.

svc_close_net() is renamed to be the inverse of svc_xprt_create().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svc.c                  | 4 ++--
 fs/nfs/callback.c               | 2 +-
 fs/nfsd/nfssvc.c                | 2 +-
 include/linux/sunrpc/svc.h      | 1 -
 include/linux/sunrpc/svc_xprt.h | 1 +
 net/sunrpc/svc.c                | 6 ------
 net/sunrpc/svc_xprt.c           | 9 +++++++--
 7 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index bba6f2b45b64a..c83ec4a375bc1 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -248,7 +248,7 @@ static int make_socks(struct svc_serv *serv, struct net *net,
 	if (warned++ == 0)
 		printk(KERN_WARNING
 			"lockd_up: makesock failed, error=%d\n", err);
-	svc_shutdown_net(serv, net);
+	svc_xprt_destroy_all(serv, net);
 	svc_rpcb_cleanup(serv, net);
 	return err;
 }
@@ -287,7 +287,7 @@ static void lockd_down_net(struct svc_serv *serv, struct net *net)
 			nlm_shutdown_hosts_net(net);
 			cancel_delayed_work_sync(&ln->grace_period_end);
 			locks_end_grace(&ln->lockd_manager);
-			svc_shutdown_net(serv, net);
+			svc_xprt_destroy_all(serv, net);
 			svc_rpcb_cleanup(serv, net);
 		}
 	} else {
diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index c1a8767100ae9..c98c68513590f 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -189,7 +189,7 @@ static void nfs_callback_down_net(u32 minorversion, struct svc_serv *serv, struc
 		return;
 
 	dprintk("NFS: destroy per-net callback data; net=%x\n", net->ns.inum);
-	svc_shutdown_net(serv, net);
+	svc_xprt_destroy_all(serv, net);
 }
 
 static int nfs_callback_up_net(int minorversion, struct svc_serv *serv,
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 5790b1eaff72b..38895372ec393 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -722,7 +722,7 @@ void nfsd_put(struct net *net)
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
 	if (kref_put(&nn->nfsd_serv->sv_refcnt, nfsd_noop)) {
-		svc_shutdown_net(nn->nfsd_serv, net);
+		svc_xprt_destroy_all(nn->nfsd_serv, net);
 		nfsd_last_thread(nn->nfsd_serv, net);
 		svc_destroy(&nn->nfsd_serv->sv_refcnt);
 		spin_lock(&nfsd_notifier_lock);
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 6ea779b66199f..fd7ccba415f51 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -510,7 +510,6 @@ struct svc_serv *  svc_create_pooled(struct svc_program *, unsigned int,
 			const struct svc_serv_ops *);
 int		   svc_set_num_threads(struct svc_serv *, struct svc_pool *, int);
 int		   svc_pool_stats_open(struct svc_serv *serv, struct file *file);
-void		   svc_shutdown_net(struct svc_serv *, struct net *);
 int		   svc_process(struct svc_rqst *);
 int		   bc_svc_process(struct svc_serv *, struct rpc_rqst *,
 			struct svc_rqst *);
diff --git a/include/linux/sunrpc/svc_xprt.h b/include/linux/sunrpc/svc_xprt.h
index 30c645583cd06..1f7368f5b4e72 100644
--- a/include/linux/sunrpc/svc_xprt.h
+++ b/include/linux/sunrpc/svc_xprt.h
@@ -131,6 +131,7 @@ int	svc_xprt_create(struct svc_serv *serv, const char *xprt_name,
 			struct net *net, const int family,
 			const unsigned short port, int flags,
 			const struct cred *cred);
+void	svc_xprt_destroy_all(struct svc_serv *serv, struct net *net);
 void	svc_xprt_received(struct svc_xprt *xprt);
 void	svc_xprt_enqueue(struct svc_xprt *xprt);
 void	svc_xprt_put(struct svc_xprt *xprt);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 6a52942c501c5..6f45f3f45514c 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -536,12 +536,6 @@ svc_create_pooled(struct svc_program *prog, unsigned int bufsize,
 }
 EXPORT_SYMBOL_GPL(svc_create_pooled);
 
-void svc_shutdown_net(struct svc_serv *serv, struct net *net)
-{
-	svc_close_net(serv, net);
-}
-EXPORT_SYMBOL_GPL(svc_shutdown_net);
-
 /*
  * Destroy an RPC service. Should be called with appropriate locking to
  * protect sv_permsocks and sv_tempsocks.
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 19c11b3253f8d..67ccf1a6459ae 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1150,7 +1150,11 @@ static void svc_clean_up_xprts(struct svc_serv *serv, struct net *net)
 	}
 }
 
-/*
+/**
+ * svc_xprt_destroy_all - Destroy transports associated with @serv
+ * @serv: RPC service to be shut down
+ * @net: target network namespace
+ *
  * Server threads may still be running (especially in the case where the
  * service is still running in other network namespaces).
  *
@@ -1162,7 +1166,7 @@ static void svc_clean_up_xprts(struct svc_serv *serv, struct net *net)
  * threads, we may need to wait a little while and then check again to
  * see if they're done.
  */
-void svc_close_net(struct svc_serv *serv, struct net *net)
+void svc_xprt_destroy_all(struct svc_serv *serv, struct net *net)
 {
 	int delay = 0;
 
@@ -1173,6 +1177,7 @@ void svc_close_net(struct svc_serv *serv, struct net *net)
 		msleep(delay++);
 	}
 }
+EXPORT_SYMBOL_GPL(svc_xprt_destroy_all);
 
 /*
  * Handle defer and revisit of requests
-- 
2.43.0



