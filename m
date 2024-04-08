Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21477D413;
	Mon,  8 Apr 2024 13:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584779; cv=none; b=XOdAKs9PG/8amIyuASeBCN55w5dOrvzAGcZ5wx75GOPJ1IBTY+ZoukF6jRGYWQpuDmEvbXsLRjyIxUS4YhhSm/m7iFqFAYT5R42DIA1An8H05Pd8ghADpsqdBC7eJa2ZHo4D/QKA/xqDkQq05seWyrcZLgj7D+6nz3gerpdn8OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584779; c=relaxed/simple;
	bh=j38klbHkCPFY0NpaPmSrrEFCCm2R0dmNfCaFUJdtcC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyNXOCdPaUkNJRlaamEvzKZXx7m926ECrVOx77lhIWCRexy39rGzDXTYYt7oW/WtRu6xIzWkET0ofFhu4TKJuURdWsZJF5bLbY5J8uWMu5CcBYOUiiPR4tjOpr2QI3RntkEqQM/ags4NkE6QOoVC36Vmi9eOtDUFOIG3lHdttyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBA425Dp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBA425Dp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC4BC433F1;
	Mon,  8 Apr 2024 13:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584779;
	bh=j38klbHkCPFY0NpaPmSrrEFCCm2R0dmNfCaFUJdtcC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBA425DpinAWfV9wDT+w1pT37q89IyGGUbvJHyPXHeW6OTaq5Ss+Hs7ElWIEM/NAv
	 M5TYpc0F4+BAQmwgPTQ77uX9/rgg+LPCNNPdZlkW+P/mFwE3V//G4VrHhZFucIe3T/
	 4FjhCIcoendLSykxop5eQAzza/fk7Co6J7fWyhbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 547/690] nfsd: separate nfsd_last_thread() from nfsd_put()
Date: Mon,  8 Apr 2024 14:56:53 +0200
Message-ID: <20240408125419.458791731@linuxfoundation.org>
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

[ Upstream commit 9f28a971ee9fdf1bf8ce8c88b103f483be610277 ]

Now that the last nfsd thread is stopped by an explicit act of calling
svc_set_num_threads() with a count of zero, we only have a limited
number of places that can happen, and don't need to call
nfsd_last_thread() in nfsd_put()

So separate that out and call it at the two places where the number of
threads is set to zero.

Move the clearing of ->nfsd_serv and the call to svc_xprt_destroy_all()
into nfsd_last_thread(), as they are really part of the same action.

nfsd_put() is now a thin wrapper around svc_put(), so make it a static
inline.

nfsd_put() cannot be called after nfsd_last_thread(), so in a couple of
places we have to use svc_put() instead.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsd.h   |  7 ++++++-
 fs/nfsd/nfssvc.c | 52 ++++++++++++++++++------------------------------
 2 files changed, 25 insertions(+), 34 deletions(-)

diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index fa0144a742678..867dcfd64d426 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -96,7 +96,12 @@ int		nfsd_pool_stats_open(struct inode *, struct file *);
 int		nfsd_pool_stats_release(struct inode *, struct file *);
 void		nfsd_shutdown_threads(struct net *net);
 
-void		nfsd_put(struct net *net);
+static inline void nfsd_put(struct net *net)
+{
+	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+
+	svc_put(nn->nfsd_serv);
+}
 
 bool		i_am_nfsd(void);
 
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 8907dba22c3f2..ee5713fca1870 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -529,9 +529,14 @@ static struct notifier_block nfsd_inet6addr_notifier = {
 /* Only used under nfsd_mutex, so this atomic may be overkill: */
 static atomic_t nfsd_notifier_refcount = ATOMIC_INIT(0);
 
-static void nfsd_last_thread(struct svc_serv *serv, struct net *net)
+static void nfsd_last_thread(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+	struct svc_serv *serv = nn->nfsd_serv;
+
+	spin_lock(&nfsd_notifier_lock);
+	nn->nfsd_serv = NULL;
+	spin_unlock(&nfsd_notifier_lock);
 
 	/* check if the notifier still has clients */
 	if (atomic_dec_return(&nfsd_notifier_refcount) == 0) {
@@ -541,6 +546,8 @@ static void nfsd_last_thread(struct svc_serv *serv, struct net *net)
 #endif
 	}
 
+	svc_xprt_destroy_all(serv, net);
+
 	/*
 	 * write_ports can create the server without actually starting
 	 * any threads--if we get shut down before any threads are
@@ -631,7 +638,8 @@ void nfsd_shutdown_threads(struct net *net)
 	svc_get(serv);
 	/* Kill outstanding nfsd threads */
 	svc_set_num_threads(serv, NULL, 0);
-	nfsd_put(net);
+	nfsd_last_thread(net);
+	svc_put(serv);
 	mutex_unlock(&nfsd_mutex);
 }
 
@@ -661,9 +669,6 @@ int nfsd_create_serv(struct net *net)
 	serv->sv_maxconn = nn->max_connections;
 	error = svc_bind(serv, net);
 	if (error < 0) {
-		/* NOT nfsd_put() as notifiers (see below) haven't
-		 * been set up yet.
-		 */
 		svc_put(serv);
 		return error;
 	}
@@ -706,29 +711,6 @@ int nfsd_get_nrthreads(int n, int *nthreads, struct net *net)
 	return 0;
 }
 
-/* This is the callback for kref_put() below.
- * There is no code here as the first thing to be done is
- * call svc_shutdown_net(), but we cannot get the 'net' from
- * the kref.  So do all the work when kref_put returns true.
- */
-static void nfsd_noop(struct kref *ref)
-{
-}
-
-void nfsd_put(struct net *net)
-{
-	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
-
-	if (kref_put(&nn->nfsd_serv->sv_refcnt, nfsd_noop)) {
-		svc_xprt_destroy_all(nn->nfsd_serv, net);
-		nfsd_last_thread(nn->nfsd_serv, net);
-		svc_destroy(&nn->nfsd_serv->sv_refcnt);
-		spin_lock(&nfsd_notifier_lock);
-		nn->nfsd_serv = NULL;
-		spin_unlock(&nfsd_notifier_lock);
-	}
-}
-
 int nfsd_set_nrthreads(int n, int *nthreads, struct net *net)
 {
 	int i = 0;
@@ -779,7 +761,7 @@ int nfsd_set_nrthreads(int n, int *nthreads, struct net *net)
 		if (err)
 			break;
 	}
-	nfsd_put(net);
+	svc_put(nn->nfsd_serv);
 	return err;
 }
 
@@ -794,6 +776,7 @@ nfsd_svc(int nrservs, struct net *net, const struct cred *cred)
 	int	error;
 	bool	nfsd_up_before;
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+	struct svc_serv *serv;
 
 	mutex_lock(&nfsd_mutex);
 	dprintk("nfsd: creating service\n");
@@ -813,22 +796,25 @@ nfsd_svc(int nrservs, struct net *net, const struct cred *cred)
 		goto out;
 
 	nfsd_up_before = nn->nfsd_net_up;
+	serv = nn->nfsd_serv;
 
 	error = nfsd_startup_net(net, cred);
 	if (error)
 		goto out_put;
-	error = svc_set_num_threads(nn->nfsd_serv, NULL, nrservs);
+	error = svc_set_num_threads(serv, NULL, nrservs);
 	if (error)
 		goto out_shutdown;
-	error = nn->nfsd_serv->sv_nrthreads;
+	error = serv->sv_nrthreads;
+	if (error == 0)
+		nfsd_last_thread(net);
 out_shutdown:
 	if (error < 0 && !nfsd_up_before)
 		nfsd_shutdown_net(net);
 out_put:
 	/* Threads now hold service active */
 	if (xchg(&nn->keep_active, 0))
-		nfsd_put(net);
-	nfsd_put(net);
+		svc_put(serv);
+	svc_put(serv);
 out:
 	mutex_unlock(&nfsd_mutex);
 	return error;
-- 
2.43.0



