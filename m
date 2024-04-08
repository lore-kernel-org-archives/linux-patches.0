Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5776EB72;
	Mon,  8 Apr 2024 13:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583666; cv=none; b=mZpmhVEfwceltBWoEJ1PkcjttGZtUDYLrxhQPv+TfC/StxVwEQCW+SftWU6vKK2VxFdaavckcXSFtxqFOAN9VwOtGfTQgY9Yk8tVcZZDV6N23f1m+uBjIzQ3Jcm1T+SCvWm1rYXQNMHK1Z8IA9jjgs95E4TXXB2lEfEi1wo+JjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583666; c=relaxed/simple;
	bh=D0d37B+tBMamtD4/jB4IEstHGPD80OuLnlgBXzSZEoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShYL88ZzRM9BI36si1bx+GiVM8QWO8scU2hIjWAn6OLAxePvxFKRlLLH396a075/fnf3fx90lmVw3dCZzlrpDR/eCWXOcU7S3+aj0btm1z3DQhvZD64ODdr9ooY4DivyIeySjZGSelkHV4p1OTPI7F1wUvCRdhr4sHKeir2OZwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ic6AoFa9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ic6AoFa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232F8C43390;
	Mon,  8 Apr 2024 13:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583666;
	bh=D0d37B+tBMamtD4/jB4IEstHGPD80OuLnlgBXzSZEoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ic6AoFa9l83LuzHQ9ru4HFTtfrYJckEkslleeJruyVnUoi89PrGYXjSZPUsIktVEF
	 Rd0KK5AP12GTD/DVo4Kn4LbBqc6fEHVH1fEiI0cwBW8curaljCDChlPT27+paHaOV0
	 gEzShX7V0R+z1WCpaJVcOr9lWsMQIIVl0HYk+AlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 272/690] SUNRPC: Remove the .svo_enqueue_xprt method
Date: Mon,  8 Apr 2024 14:52:18 +0200
Message-ID: <20240408125409.486583562@linuxfoundation.org>
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

[ Upstream commit a9ff2e99e9fa501ec965da03c18a5422b37a2f44 ]

We have never been able to track down and address the underlying
cause of the performance issues with workqueue-based service
support. svo_enqueue_xprt is called multiple times per RPC, so
it adds instruction path length, but always ends up at the same
function: svc_xprt_do_enqueue(). We do not anticipate needing
this flexibility for dynamic nfsd thread management support.

As a micro-optimization, remove .svo_enqueue_xprt because
Spectre/Meltdown makes virtual function calls more costly.

This change essentially reverts commit b9e13cdfac70 ("nfsd/sunrpc:
turn enqueueing a svc_xprt into a svc_serv operation").

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svc.c                  |  1 -
 fs/nfs/callback.c               |  2 --
 fs/nfsd/nfssvc.c                |  1 -
 include/linux/sunrpc/svc.h      |  3 ---
 include/linux/sunrpc/svc_xprt.h |  1 -
 net/sunrpc/svc_xprt.c           | 10 +++++-----
 6 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 0475c5a5d061e..3a05af8736259 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -353,7 +353,6 @@ static struct notifier_block lockd_inet6addr_notifier = {
 static const struct svc_serv_ops lockd_sv_ops = {
 	.svo_shutdown		= svc_rpcb_cleanup,
 	.svo_function		= lockd,
-	.svo_enqueue_xprt	= svc_xprt_do_enqueue,
 	.svo_module		= THIS_MODULE,
 };
 
diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index 054cc1255fac6..7a810f8850632 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -234,13 +234,11 @@ static int nfs_callback_up_net(int minorversion, struct svc_serv *serv,
 
 static const struct svc_serv_ops nfs40_cb_sv_ops = {
 	.svo_function		= nfs4_callback_svc,
-	.svo_enqueue_xprt	= svc_xprt_do_enqueue,
 	.svo_module		= THIS_MODULE,
 };
 #if defined(CONFIG_NFS_V4_1)
 static const struct svc_serv_ops nfs41_cb_sv_ops = {
 	.svo_function		= nfs41_callback_svc,
-	.svo_enqueue_xprt	= svc_xprt_do_enqueue,
 	.svo_module		= THIS_MODULE,
 };
 
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 2efe9d33a2827..3b79b97f2715d 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -615,7 +615,6 @@ static int nfsd_get_default_max_blksize(void)
 static const struct svc_serv_ops nfsd_thread_sv_ops = {
 	.svo_shutdown		= nfsd_last_thread,
 	.svo_function		= nfsd,
-	.svo_enqueue_xprt	= svc_xprt_do_enqueue,
 	.svo_module		= THIS_MODULE,
 };
 
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index be535cc4fea07..2c1a80ec7c3dc 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -61,9 +61,6 @@ struct svc_serv_ops {
 	/* function for service threads to run */
 	int		(*svo_function)(void *);
 
-	/* queue up a transport for servicing */
-	void		(*svo_enqueue_xprt)(struct svc_xprt *);
-
 	/* optional module to count when adding threads.
 	 * Thread function must call module_put_and_kthread_exit() to exit.
 	 */
diff --git a/include/linux/sunrpc/svc_xprt.h b/include/linux/sunrpc/svc_xprt.h
index 154eee6bc6a01..05a3ccd837f57 100644
--- a/include/linux/sunrpc/svc_xprt.h
+++ b/include/linux/sunrpc/svc_xprt.h
@@ -131,7 +131,6 @@ int	svc_create_xprt(struct svc_serv *, const char *, struct net *,
 			const int, const unsigned short, int,
 			const struct cred *);
 void	svc_xprt_received(struct svc_xprt *xprt);
-void	svc_xprt_do_enqueue(struct svc_xprt *xprt);
 void	svc_xprt_enqueue(struct svc_xprt *xprt);
 void	svc_xprt_put(struct svc_xprt *xprt);
 void	svc_xprt_copy_addrs(struct svc_rqst *rqstp, struct svc_xprt *xprt);
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 5ff8f902f14d2..795dc8eb2e1d5 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -31,6 +31,7 @@ static int svc_deferred_recv(struct svc_rqst *rqstp);
 static struct cache_deferred_req *svc_defer(struct cache_req *req);
 static void svc_age_temp_xprts(struct timer_list *t);
 static void svc_delete_xprt(struct svc_xprt *xprt);
+static void svc_xprt_do_enqueue(struct svc_xprt *xprt);
 
 /* apparently the "standard" is that clients close
  * idle connections after 5 minutes, servers after
@@ -267,12 +268,12 @@ void svc_xprt_received(struct svc_xprt *xprt)
 	trace_svc_xprt_received(xprt);
 
 	/* As soon as we clear busy, the xprt could be closed and
-	 * 'put', so we need a reference to call svc_enqueue_xprt with:
+	 * 'put', so we need a reference to call svc_xprt_do_enqueue with:
 	 */
 	svc_xprt_get(xprt);
 	smp_mb__before_atomic();
 	clear_bit(XPT_BUSY, &xprt->xpt_flags);
-	xprt->xpt_server->sv_ops->svo_enqueue_xprt(xprt);
+	svc_xprt_do_enqueue(xprt);
 	svc_xprt_put(xprt);
 }
 EXPORT_SYMBOL_GPL(svc_xprt_received);
@@ -424,7 +425,7 @@ static bool svc_xprt_ready(struct svc_xprt *xprt)
 	return false;
 }
 
-void svc_xprt_do_enqueue(struct svc_xprt *xprt)
+static void svc_xprt_do_enqueue(struct svc_xprt *xprt)
 {
 	struct svc_pool *pool;
 	struct svc_rqst	*rqstp = NULL;
@@ -468,7 +469,6 @@ void svc_xprt_do_enqueue(struct svc_xprt *xprt)
 	put_cpu();
 	trace_svc_xprt_do_enqueue(xprt, rqstp);
 }
-EXPORT_SYMBOL_GPL(svc_xprt_do_enqueue);
 
 /*
  * Queue up a transport with data pending. If there are idle nfsd
@@ -479,7 +479,7 @@ void svc_xprt_enqueue(struct svc_xprt *xprt)
 {
 	if (test_bit(XPT_BUSY, &xprt->xpt_flags))
 		return;
-	xprt->xpt_server->sv_ops->svo_enqueue_xprt(xprt);
+	svc_xprt_do_enqueue(xprt);
 }
 EXPORT_SYMBOL_GPL(svc_xprt_enqueue);
 
-- 
2.43.0



