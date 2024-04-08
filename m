Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E7E7C6C8;
	Mon,  8 Apr 2024 13:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583684; cv=none; b=j+9NHZRrFotNdIg+sFL54YPaNpo+6aqEReSWXraHEYNSaecGoByYAkYRFdEQ1jr/bLyMEFdduSugidInOXvQ6sQlUN4OflNA93jp8Z5FE4m9cxf1L5xYEYsv+QsaftCHRJDgcdA+uuBx1T7G7WFdH0xv/bjfJHu9FpmowCXySBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583684; c=relaxed/simple;
	bh=Qh7VbIFFKRhyGWDGUegiON67X1hNR+yrnNikcfrPErQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fONNZR6tno+eHuWQItiqxEJgRC35lIECJ46T/q83QBuLDyGD/eE+ufLV1yKEMP/kM7OQ1lL99SUwNemPOvrlC5zLOSF6xWsl/BjxP0eyV8KOiMlduUVKm6Qgtb6aNYcYEameC7xYnAgRZ5CjSaQ0cFA8cCxc5CoTwA3qvQfcrUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4oeZmsO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4oeZmsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68DCC433F1;
	Mon,  8 Apr 2024 13:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583684;
	bh=Qh7VbIFFKRhyGWDGUegiON67X1hNR+yrnNikcfrPErQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B4oeZmsO4+I7fM6xS/ViYnPtg0mj2C9e6w3cUCwPAB1ysLuYaQfaRaz4cBT3QnjcO
	 k1ufn+32yIXfDxlG3JSDI1Zrx2voN5ORQZe02/UAOVuEjgzgiaeGxcjbhEZkmws7sv
	 ejcPZOe955V1/UQ1wNNf0TWtlEQCI2vtILkUKTCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>
Subject: [PATCH 5.15 274/690] SUNRPC: Remove svo_shutdown method
Date: Mon,  8 Apr 2024 14:52:20 +0200
Message-ID: <20240408125409.549007292@linuxfoundation.org>
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

[ Upstream commit 87cdd8641c8a1ec6afd2468265e20840a57fd888 ]

Clean up. Neil observed that "any code that calls svc_shutdown_net()
knows what the shutdown function should be, and so can call it
directly."

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
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
index 2c1a80ec7c3dc..6ea779b66199f 100644
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
index f53ff8f2602f2..7c7cf0d4ffcb0 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -539,9 +539,6 @@ EXPORT_SYMBOL_GPL(svc_create_pooled);
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



