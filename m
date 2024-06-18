Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E09157E88;
	Tue, 18 Jun 2024 13:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715939; cv=none; b=sNGBrKiCkNKtK+/pRjdTkD/iwv5KPDU0fzVL5hz8wP7HjS2reylxnyOA/8E8zxNZ2F4CwORjJdn+8aSC+TLKOLrYgUVrSVoBp65SVKfc7CqIAqfVgH+O+PpVK8snxi4zQdKEj254eGIYPvSH1SMndW1rQlcZmwhimS0mVVENmcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715939; c=relaxed/simple;
	bh=HFzf9tK4HzESyTzU8kUT1Rn2anjdAOkIC6I2sk7J2i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEBQ6Djyqu2xwddHufDVJNU4BUH4cUN6Oq83Wqf7X4KX8Xyrnhjj5l3UdeJbOQ0tom2IOdFM/tkxVf+vislSwC/jJ/NcPg4McPfAMC25VlQscGK5v8syKBZ9OVYIbPODoo+rLXygG/XLSMj7dijeTqMYZihTKQkgk1xfOadh7QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAPttXLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAPttXLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8782C3277B;
	Tue, 18 Jun 2024 13:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715938;
	bh=HFzf9tK4HzESyTzU8kUT1Rn2anjdAOkIC6I2sk7J2i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAPttXLEaTaJ27dJk1bJl2GmY8mfQ15Pca4TQpcPk/+yUy5rbQbJzSfSPNEjUMhQn
	 747aNEIaK/jQfjkUygjqKuFXrkiu+VvjepLrxD8pOkA4TN1HVAnBnIXORm7Twt8Sm8
	 1pBskG0abia5clAj/sY6j9BJP9OPTnrrsmaOnpYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 476/770] SUNRPC: Remove svo_shutdown method
Date: Tue, 18 Jun 2024 14:35:29 +0200
Message-ID: <20240618123425.689668826@linuxfoundation.org>
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

[ Upstream commit 87cdd8641c8a1ec6afd2468265e20840a57fd888 ]

Clean up. Neil observed that "any code that calls svc_shutdown_net()
knows what the shutdown function should be, and so can call it
directly."

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svc.c             | 5 ++---
 fs/nfsd/nfssvc.c           | 2 +-
 include/linux/sunrpc/svc.h | 3 ---
 net/sunrpc/svc.c           | 3 ---
 4 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 3a05af8736259..f5b688a844aa5 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -249,6 +249,7 @@ static int make_socks(struct svc_serv *serv, struct net *net,
 		printk(KERN_WARNING
 			"lockd_up: makesock failed, error=%d\n", err);
 	svc_shutdown_net(serv, net);
+	svc_rpcb_cleanup(serv, net);
 	return err;
 }
 
@@ -287,8 +288,7 @@ static void lockd_down_net(struct svc_serv *serv, struct net *net)
 			cancel_delayed_work_sync(&ln->grace_period_end);
 			locks_end_grace(&ln->lockd_manager);
 			svc_shutdown_net(serv, net);
-			dprintk("%s: per-net data destroyed; net=%x\n",
-				__func__, net->ns.inum);
+			svc_rpcb_cleanup(serv, net);
 		}
 	} else {
 		pr_err("%s: no users! net=%x\n",
@@ -351,7 +351,6 @@ static struct notifier_block lockd_inet6addr_notifier = {
 #endif
 
 static const struct svc_serv_ops lockd_sv_ops = {
-	.svo_shutdown		= svc_rpcb_cleanup,
 	.svo_function		= lockd,
 	.svo_module		= THIS_MODULE,
 };
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 3b79b97f2715d..a1765e751b739 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -613,7 +613,6 @@ static int nfsd_get_default_max_blksize(void)
 }
 
 static const struct svc_serv_ops nfsd_thread_sv_ops = {
-	.svo_shutdown		= nfsd_last_thread,
 	.svo_function		= nfsd,
 	.svo_module		= THIS_MODULE,
 };
@@ -724,6 +723,7 @@ void nfsd_put(struct net *net)
 
 	if (kref_put(&nn->nfsd_serv->sv_refcnt, nfsd_noop)) {
 		svc_shutdown_net(nn->nfsd_serv, net);
+		nfsd_last_thread(nn->nfsd_serv, net);
 		svc_destroy(&nn->nfsd_serv->sv_refcnt);
 		spin_lock(&nfsd_notifier_lock);
 		nn->nfsd_serv = NULL;
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 3c8ed018c6868..6f3ba5c514643 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -55,9 +55,6 @@ struct svc_pool {
 struct svc_serv;
 
 struct svc_serv_ops {
-	/* Callback to use when last thread exits. */
-	void		(*svo_shutdown)(struct svc_serv *, struct net *);
-
 	/* function for service threads to run */
 	int		(*svo_function)(void *);
 
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index d34d03b0bf76b..709118bac4c32 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -537,9 +537,6 @@ EXPORT_SYMBOL_GPL(svc_create_pooled);
 void svc_shutdown_net(struct svc_serv *serv, struct net *net)
 {
 	svc_close_net(serv, net);
-
-	if (serv->sv_ops->svo_shutdown)
-		serv->sv_ops->svo_shutdown(serv, net);
 }
 EXPORT_SYMBOL_GPL(svc_shutdown_net);
 
-- 
2.43.0



