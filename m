Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3C71514ED;
	Tue, 18 Jun 2024 13:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715997; cv=none; b=jWe7kruPUS1nDfivCgZ81yD2lOg3mVuHnzaQE2MVCZheMXyh7/w/A6opEXw3ayxmBEmcY9WTQOdY0aXLDkkHw8q9YIzWCOtIwRWMq4bmJ1e171MRXF+ZpI362LE1dNi/IG2xsLwbmX+wYya2etV1KS/RJyHB5gUmjJdB0OXG8uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715997; c=relaxed/simple;
	bh=WaLpBp28Jvoina41psBi7XFawNza/Jt/ScsJ6be7d7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvecAzMj6TByrd1H/pOKCRe9xgOGujDCyeXkd4vwExddSrk55LOTegE3ohMnOJ/F3esSGW9syagziVaZCmpBT/IYKiHmBxszmIXOUQnohFfYSzqLwtx3uIB6cKkYFWp6/AsX7xtAK9DXVJoFO2bVrVzqt+pwHiu2vayyiA+CofU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UtZQSeZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtZQSeZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2E8C3277B;
	Tue, 18 Jun 2024 13:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715997;
	bh=WaLpBp28Jvoina41psBi7XFawNza/Jt/ScsJ6be7d7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtZQSeZUJ+IgGmpmEY/9TLXp02D/al60GRtiQDatIzbv+pVnpaLgxsCb7GtyBSVWp
	 W027qS+K22Cr5LF05KrfcVzodq1i2pf8l4wEHIXYGKGzOhG4pZhn9oZuS9brJUh2qr
	 YUDvce5vZaiNGoDBlsXQbXNncnNhSP0nQOyb0Nfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Brown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 480/770] NFSD: Remove svc_serv_ops::svo_module
Date: Tue, 18 Jun 2024 14:35:33 +0200
Message-ID: <20240618123425.843297738@linuxfoundation.org>
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

[ Upstream commit f49169c97fceb21ad6a0aaf671c50b0f520f15a5 ]

struct svc_serv_ops is about to be removed.

Neil Brown says:
> I suspect svo_module can go as well - I don't think the thread is
> ever the thing that primarily keeps a module active.

A random sample of kthread_create() callers shows sunrpc is the only
one that manages module reference count in this way.

Suggested-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svc.c             | 4 +---
 fs/nfs/callback.c          | 7 ++-----
 fs/nfs/nfs4state.c         | 1 -
 fs/nfsd/nfssvc.c           | 3 ---
 include/linux/sunrpc/svc.h | 5 -----
 kernel/module.c            | 2 +-
 net/sunrpc/svc.c           | 2 --
 7 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index c83ec4a375bc1..bfde31124f3af 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -184,8 +184,7 @@ lockd(void *vrqstp)
 	dprintk("lockd_down: service stopped\n");
 
 	svc_exit_thread(rqstp);
-
-	module_put_and_kthread_exit(0);
+	return 0;
 }
 
 static int create_lockd_listener(struct svc_serv *serv, const char *name,
@@ -352,7 +351,6 @@ static struct notifier_block lockd_inet6addr_notifier = {
 
 static const struct svc_serv_ops lockd_sv_ops = {
 	.svo_function		= lockd,
-	.svo_module		= THIS_MODULE,
 };
 
 static int lockd_get(void)
diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index c98c68513590f..a494f9e7bd0a0 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -17,7 +17,6 @@
 #include <linux/errno.h>
 #include <linux/mutex.h>
 #include <linux/freezer.h>
-#include <linux/kthread.h>
 #include <linux/sunrpc/svcauth_gss.h>
 #include <linux/sunrpc/bc_xprt.h>
 
@@ -92,8 +91,8 @@ nfs4_callback_svc(void *vrqstp)
 			continue;
 		svc_process(rqstp);
 	}
+
 	svc_exit_thread(rqstp);
-	module_put_and_kthread_exit(0);
 	return 0;
 }
 
@@ -136,8 +135,8 @@ nfs41_callback_svc(void *vrqstp)
 			finish_wait(&serv->sv_cb_waitq, &wq);
 		}
 	}
+
 	svc_exit_thread(rqstp);
-	module_put_and_kthread_exit(0);
 	return 0;
 }
 
@@ -234,12 +233,10 @@ static int nfs_callback_up_net(int minorversion, struct svc_serv *serv,
 
 static const struct svc_serv_ops nfs40_cb_sv_ops = {
 	.svo_function		= nfs4_callback_svc,
-	.svo_module		= THIS_MODULE,
 };
 #if defined(CONFIG_NFS_V4_1)
 static const struct svc_serv_ops nfs41_cb_sv_ops = {
 	.svo_function		= nfs41_callback_svc,
-	.svo_module		= THIS_MODULE,
 };
 
 static const struct svc_serv_ops *nfs4_cb_sv_ops[] = {
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index d8fc5d72a161c..ae2da65ffbafb 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2757,7 +2757,6 @@ static int nfs4_run_state_manager(void *ptr)
 		goto again;
 
 	nfs_put_client(clp);
-	module_put_and_kthread_exit(0);
 	return 0;
 }
 
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 38895372ec393..d25d4c12a499a 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -614,7 +614,6 @@ static int nfsd_get_default_max_blksize(void)
 
 static const struct svc_serv_ops nfsd_thread_sv_ops = {
 	.svo_function		= nfsd,
-	.svo_module		= THIS_MODULE,
 };
 
 void nfsd_shutdown_threads(struct net *net)
@@ -1018,8 +1017,6 @@ nfsd(void *vrqstp)
 		msleep(20);
 	}
 
-	/* Release module */
-	module_put_and_kthread_exit(0);
 	return 0;
 }
 
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 482a024156b11..c64db9b14a643 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -57,11 +57,6 @@ struct svc_serv;
 struct svc_serv_ops {
 	/* function for service threads to run */
 	int		(*svo_function)(void *);
-
-	/* optional module to count when adding threads.
-	 * Thread function must call module_put_and_kthread_exit() to exit.
-	 */
-	struct module	*svo_module;
 };
 
 /*
diff --git a/kernel/module.c b/kernel/module.c
index 9030ff8c08555..edc7b99cb16fa 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -334,7 +334,7 @@ static inline void add_taint_module(struct module *mod, unsigned flag,
 
 /*
  * A thread that wants to hold a reference to a module only while it
- * is running can call this to safely exit.  nfsd and lockd use this.
+ * is running can call this to safely exit.
  */
 void __noreturn __module_put_and_kthread_exit(struct module *mod, long code)
 {
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index c9195e40959c6..bdecc902cf998 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -734,11 +734,9 @@ svc_start_kthreads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 		if (IS_ERR(rqstp))
 			return PTR_ERR(rqstp);
 
-		__module_get(serv->sv_ops->svo_module);
 		task = kthread_create_on_node(serv->sv_ops->svo_function, rqstp,
 					      node, "%s", serv->sv_name);
 		if (IS_ERR(task)) {
-			module_put(serv->sv_ops->svo_module);
 			svc_exit_thread(rqstp);
 			return PTR_ERR(task);
 		}
-- 
2.43.0



