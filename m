Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F431848;
	Sat, 13 Jan 2024 10:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZLeSMVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90908C433C7;
	Sat, 13 Jan 2024 10:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705140150;
	bh=RYJ0zOVeHGV6RMrx+kt2x0lZrPn5TUnEbJBUXnr91wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZLeSMVHlT7lBHxH35E5xp7DiyWERiLb+Oucxmo5f7mdD9XmyiOpDRVOz7l+U+wec
	 mv34aQaik6ViAk8HnGPIt276mA7WV32/eVSpjHZDjvpF0vZuRr3RqYBfQT+/SL7UYb
	 d/ZQVEBP+Q8TTvaL7PlrEQC+KuKOKr6XxDg0jzhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	email200202 <email200202@yahoo.com>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 3/4] Revert "nfsd: separate nfsd_last_thread() from nfsd_put()"
Date: Sat, 13 Jan 2024 10:50:41 +0100
Message-ID: <20240113094204.144145096@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094204.017594027@linuxfoundation.org>
References: <20240113094204.017594027@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 03d68ffc48b94cc1e15bbf3b4f16f1e1e4fa286a which is
commit 9f28a971ee9fdf1bf8ce8c88b103f483be610277 upstream.

It is reported to cause issues, so revert it.

Reported-by: email200202 <email200202@yahoo.com>
Link: https://lore.kernel.org/r/e341cb408b5663d8c91b8fa57b41bb984be43448.camel@kernel.org
Cc: NeilBrown <neilb@suse.de>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsd.h   |    7 +------
 fs/nfsd/nfssvc.c |   52 +++++++++++++++++++++++++++++++++-------------------
 2 files changed, 34 insertions(+), 25 deletions(-)

--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -97,12 +97,7 @@ int		nfsd_pool_stats_open(struct inode *
 int		nfsd_pool_stats_release(struct inode *, struct file *);
 void		nfsd_shutdown_threads(struct net *net);
 
-static inline void nfsd_put(struct net *net)
-{
-	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
-
-	svc_put(nn->nfsd_serv);
-}
+void		nfsd_put(struct net *net);
 
 bool		i_am_nfsd(void);
 
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -523,14 +523,9 @@ static struct notifier_block nfsd_inet6a
 /* Only used under nfsd_mutex, so this atomic may be overkill: */
 static atomic_t nfsd_notifier_refcount = ATOMIC_INIT(0);
 
-static void nfsd_last_thread(struct net *net)
+static void nfsd_last_thread(struct svc_serv *serv, struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
-	struct svc_serv *serv = nn->nfsd_serv;
-
-	spin_lock(&nfsd_notifier_lock);
-	nn->nfsd_serv = NULL;
-	spin_unlock(&nfsd_notifier_lock);
 
 	/* check if the notifier still has clients */
 	if (atomic_dec_return(&nfsd_notifier_refcount) == 0) {
@@ -540,8 +535,6 @@ static void nfsd_last_thread(struct net
 #endif
 	}
 
-	svc_xprt_destroy_all(serv, net);
-
 	/*
 	 * write_ports can create the server without actually starting
 	 * any threads--if we get shut down before any threads are
@@ -632,8 +625,7 @@ void nfsd_shutdown_threads(struct net *n
 	svc_get(serv);
 	/* Kill outstanding nfsd threads */
 	svc_set_num_threads(serv, NULL, 0);
-	nfsd_last_thread(net);
-	svc_put(serv);
+	nfsd_put(net);
 	mutex_unlock(&nfsd_mutex);
 }
 
@@ -663,6 +655,9 @@ int nfsd_create_serv(struct net *net)
 	serv->sv_maxconn = nn->max_connections;
 	error = svc_bind(serv, net);
 	if (error < 0) {
+		/* NOT nfsd_put() as notifiers (see below) haven't
+		 * been set up yet.
+		 */
 		svc_put(serv);
 		return error;
 	}
@@ -705,6 +700,29 @@ int nfsd_get_nrthreads(int n, int *nthre
 	return 0;
 }
 
+/* This is the callback for kref_put() below.
+ * There is no code here as the first thing to be done is
+ * call svc_shutdown_net(), but we cannot get the 'net' from
+ * the kref.  So do all the work when kref_put returns true.
+ */
+static void nfsd_noop(struct kref *ref)
+{
+}
+
+void nfsd_put(struct net *net)
+{
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+
+	if (kref_put(&nn->nfsd_serv->sv_refcnt, nfsd_noop)) {
+		svc_xprt_destroy_all(nn->nfsd_serv, net);
+		nfsd_last_thread(nn->nfsd_serv, net);
+		svc_destroy(&nn->nfsd_serv->sv_refcnt);
+		spin_lock(&nfsd_notifier_lock);
+		nn->nfsd_serv = NULL;
+		spin_unlock(&nfsd_notifier_lock);
+	}
+}
+
 int nfsd_set_nrthreads(int n, int *nthreads, struct net *net)
 {
 	int i = 0;
@@ -755,7 +773,7 @@ int nfsd_set_nrthreads(int n, int *nthre
 		if (err)
 			break;
 	}
-	svc_put(nn->nfsd_serv);
+	nfsd_put(net);
 	return err;
 }
 
@@ -770,7 +788,6 @@ nfsd_svc(int nrservs, struct net *net, c
 	int	error;
 	bool	nfsd_up_before;
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
-	struct svc_serv *serv;
 
 	mutex_lock(&nfsd_mutex);
 	dprintk("nfsd: creating service\n");
@@ -790,25 +807,22 @@ nfsd_svc(int nrservs, struct net *net, c
 		goto out;
 
 	nfsd_up_before = nn->nfsd_net_up;
-	serv = nn->nfsd_serv;
 
 	error = nfsd_startup_net(net, cred);
 	if (error)
 		goto out_put;
-	error = svc_set_num_threads(serv, NULL, nrservs);
+	error = svc_set_num_threads(nn->nfsd_serv, NULL, nrservs);
 	if (error)
 		goto out_shutdown;
-	error = serv->sv_nrthreads;
-	if (error == 0)
-		nfsd_last_thread(net);
+	error = nn->nfsd_serv->sv_nrthreads;
 out_shutdown:
 	if (error < 0 && !nfsd_up_before)
 		nfsd_shutdown_net(net);
 out_put:
 	/* Threads now hold service active */
 	if (xchg(&nn->keep_active, 0))
-		svc_put(serv);
-	svc_put(serv);
+		nfsd_put(net);
+	nfsd_put(net);
 out:
 	mutex_unlock(&nfsd_mutex);
 	return error;


