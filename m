Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9E01BDA93;
	Tue, 27 Aug 2024 15:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772687; cv=none; b=JbnsJFohlbcG8PKAAkjeeCSt/sSok1Jv0BCpQC7FkS9M+pshEZqjib4KKKWiKdCyS2UXrJtIKi/PiM9MywNm0HUlDcfqnePvsHj++QxfGdsX0UwXZ1tCKmFwvY4fkKplEHSPkD9YaqWK563zY30sn/jPP0kP0VSvscOmGpDSD8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772687; c=relaxed/simple;
	bh=gtJPzsOCA3krRG+1jPvqFjHlke8EJObqryKw6G7OjkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmkmACueCpFBCn7lawBjIjLtdKlNAqcemLppSURZMfwz7p6z2RlVQBwMLDCOVZu4vygzCstvwqh7hKPIbJ7lfU+9mWY5Lz+bbgXior+Vw2ivUkSnijOEZsBBqnW8p7IHdF9iY67Y9iwtFvH8aQzxXwMTPgtx69mTm3VejsSokVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGidXUcD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGidXUcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F75C4DDF0;
	Tue, 27 Aug 2024 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772687;
	bh=gtJPzsOCA3krRG+1jPvqFjHlke8EJObqryKw6G7OjkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGidXUcDWyrFEE37KolVjYNhzfQddrtVs+JR0MHoq66kgucY3BbaSyKvhe4e5OmaR
	 xcx6dU9XBVybr0No3TppTvTTTmrWl6SC+koZGxLpPXBuX5gdC0XjKCh1uFfPuviH2m
	 jmeBJJ4v2NJ5MANR95tpYVDX/AxS2Bmb7OjRFBOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 289/321] nfsd: separate nfsd_last_thread() from nfsd_put()
Date: Tue, 27 Aug 2024 16:39:57 +0200
Message-ID: <20240827143849.250582461@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsd.h   |    7 ++++++-
 fs/nfsd/nfssvc.c |   52 +++++++++++++++++++---------------------------------
 2 files changed, 25 insertions(+), 34 deletions(-)

--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -97,7 +97,12 @@ int		nfsd_pool_stats_open(struct inode *
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
 
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -532,9 +532,14 @@ static struct notifier_block nfsd_inet6a
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
@@ -544,6 +549,8 @@ static void nfsd_last_thread(struct svc_
 #endif
 	}
 
+	svc_xprt_destroy_all(serv, net);
+
 	/*
 	 * write_ports can create the server without actually starting
 	 * any threads--if we get shut down before any threads are
@@ -634,7 +641,8 @@ void nfsd_shutdown_threads(struct net *n
 	svc_get(serv);
 	/* Kill outstanding nfsd threads */
 	svc_set_num_threads(serv, NULL, 0);
-	nfsd_put(net);
+	nfsd_last_thread(net);
+	svc_put(serv);
 	mutex_unlock(&nfsd_mutex);
 }
 
@@ -665,9 +673,6 @@ int nfsd_create_serv(struct net *net)
 	serv->sv_maxconn = nn->max_connections;
 	error = svc_bind(serv, net);
 	if (error < 0) {
-		/* NOT nfsd_put() as notifiers (see below) haven't
-		 * been set up yet.
-		 */
 		svc_put(serv);
 		return error;
 	}
@@ -710,29 +715,6 @@ int nfsd_get_nrthreads(int n, int *nthre
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
@@ -783,7 +765,7 @@ int nfsd_set_nrthreads(int n, int *nthre
 		if (err)
 			break;
 	}
-	nfsd_put(net);
+	svc_put(nn->nfsd_serv);
 	return err;
 }
 
@@ -798,6 +780,7 @@ nfsd_svc(int nrservs, struct net *net, c
 	int	error;
 	bool	nfsd_up_before;
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+	struct svc_serv *serv;
 
 	mutex_lock(&nfsd_mutex);
 	dprintk("nfsd: creating service\n");
@@ -817,22 +800,25 @@ nfsd_svc(int nrservs, struct net *net, c
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


