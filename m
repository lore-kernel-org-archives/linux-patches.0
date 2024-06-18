Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC9F1581E9;
	Tue, 18 Jun 2024 13:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715965; cv=none; b=aUE6m9LwkPOgsMvhO3fmt0TfL6AEh+LXjBaYUejhqzqpn7p+UBpI9nE4aCCX+qUPzUJLTpc15kJsBmT98keK5dg6q4PVHJ3gRZDChFlg+FqKv/gM2F/kCR4q/xvuL3rs9I3Osj25ihC8tGlGSoFRECBoAmvfxn7C3G/2ATcxdJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715965; c=relaxed/simple;
	bh=ZE+79+nIPC5Cp6UneULk8ypzIfXNooJsR/dixEodUb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fpx3nigrzymz6Y/fsZ01tSDz2WJyP2L8KnZIJE3Yf/TtIemDFQyRMm1PoOkTjPrW5T8As4qng1kB88z3MkRLyRqROUAdjttFyMlu7U/8/OTcSUbVsgJbBNT7o2yuNm1z6uG3Um/EhUK+UT+QSv7KpPzjXsCj4b4WCDtb7PrWAFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAT3xZNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAT3xZNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97921C3277B;
	Tue, 18 Jun 2024 13:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715965;
	bh=ZE+79+nIPC5Cp6UneULk8ypzIfXNooJsR/dixEodUb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAT3xZNiMblf739z5S51KQNTx3SVwmF+H+kCGqs0RlomNuK1XESbtRJzVUTasRRfx
	 lUcUmaEBJmQMViz+N36q6C/ReInC/qB+AJmFIGhTc3fLHLiMXmU60Qi6OGOfr3NhIH
	 CwtWzxzRx1UvHhxQHe3cgSkxkQT6Hf+GdlT2FsKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 479/770] SUNRPC: Remove svc_shutdown_net()
Date: Tue, 18 Jun 2024 14:35:32 +0200
Message-ID: <20240618123425.804968825@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c7d7ec8f043e53ad16e30f5ebb8b9df415ec0f2b ]

Clean up: svc_shutdown_net() now does nothing but call
svc_close_net(). Replace all external call sites.

svc_close_net() is renamed to be the inverse of svc_xprt_create().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index 6f3ba5c514643..482a024156b11 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -511,7 +511,6 @@ struct svc_serv *  svc_create_pooled(struct svc_program *, unsigned int,
 			const struct svc_serv_ops *);
 int		   svc_set_num_threads(struct svc_serv *, struct svc_pool *, int);
 int		   svc_pool_stats_open(struct svc_serv *serv, struct file *file);
-void		   svc_shutdown_net(struct svc_serv *, struct net *);
 int		   svc_process(struct svc_rqst *);
 int		   bc_svc_process(struct svc_serv *, struct rpc_rqst *,
 			struct svc_rqst *);
diff --git a/include/linux/sunrpc/svc_xprt.h b/include/linux/sunrpc/svc_xprt.h
index f614f8e248e11..dbffb92511ef2 100644
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
index 9126e1b7d0769..c9195e40959c6 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -534,12 +534,6 @@ svc_create_pooled(struct svc_program *prog, unsigned int bufsize,
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
index ee4a6d57056f5..000b737784bd9 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1128,7 +1128,11 @@ static void svc_clean_up_xprts(struct svc_serv *serv, struct net *net)
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
@@ -1140,7 +1144,7 @@ static void svc_clean_up_xprts(struct svc_serv *serv, struct net *net)
  * threads, we may need to wait a little while and then check again to
  * see if they're done.
  */
-void svc_close_net(struct svc_serv *serv, struct net *net)
+void svc_xprt_destroy_all(struct svc_serv *serv, struct net *net)
 {
 	int delay = 0;
 
@@ -1151,6 +1155,7 @@ void svc_close_net(struct svc_serv *serv, struct net *net)
 		msleep(delay++);
 	}
 }
+EXPORT_SYMBOL_GPL(svc_xprt_destroy_all);
 
 /*
  * Handle defer and revisit of requests
-- 
2.43.0



