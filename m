Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B2A8614B;
	Mon,  8 Apr 2024 13:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583340; cv=none; b=SoEOOADP60tzNNRcWa0IJdjGWG0bNQ4BZC4AkItHwJBtt5UgCJ+FsdhSnUT1k/mO+fCeASToQNUYNr3pBb2++sUBikg0+PtsohVVmZm+UOACCzPB67+yaBr5GlLvgNkjO24EDIZ4JFQ2dDteTu6sGdg2auzLY6C9GFlLac0ElV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583340; c=relaxed/simple;
	bh=fZfVtwFNVN4Km2Uhlsbnp0Y70zDelqCJKUESG9H7vHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LnjlV/dmwGLiW9qa55+QyCTJZwb8JeB3WQGNXQ4XcjKXdMZPrvoLsi+JIFc74nrH2xOBnUB3EDIgXcRxsS8TcVACgc68AANB+54FQnqWm0LO00OpzMoOyKm61qPAQKVkWp5jiktAnJ+K5uT7ixr1mLI4clHqPhTW+lVlIoLRVcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yx/C8Gai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yx/C8Gai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FE8C433F1;
	Mon,  8 Apr 2024 13:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583340;
	bh=fZfVtwFNVN4Km2Uhlsbnp0Y70zDelqCJKUESG9H7vHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yx/C8GaivvS8BpkDmJM8Cqdn1hkefi+52pl6d2EGjZxBEOsoaRU+Bk/mf7BnKORQv
	 QnhevzlHrwBj/FtqYuQlx2y59UPYhVxSEbFOsZ+92AlJoh0Q5vYnL2SLl4Z+BE6wfC
	 0OQp0DOyftz8sM9c7SD1vFMRopGvTIZPpZGAf6b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 236/690] lockd: introduce nlmsvc_serv
Date: Mon,  8 Apr 2024 14:51:42 +0200
Message-ID: <20240408125408.172469794@linuxfoundation.org>
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

[ Upstream commit 2840fe864c91a0fe822169b1fbfddbcac9aeac43 ]

lockd has two globals - nlmsvc_task and nlmsvc_rqst - but mostly it
wants the 'struct svc_serv', and when it doesn't want it exactly it can
get to what it wants from the serv.

This patch is a first step to removing nlmsvc_task and nlmsvc_rqst.  It
introduces nlmsvc_serv to store the 'struct svc_serv*'.  This is set as
soon as the serv is created, and cleared only when it is destroyed.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svc.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index a9669b106dbde..83874878f41d8 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -54,6 +54,7 @@ EXPORT_SYMBOL_GPL(nlmsvc_ops);
 
 static DEFINE_MUTEX(nlmsvc_mutex);
 static unsigned int		nlmsvc_users;
+static struct svc_serv		*nlmsvc_serv;
 static struct task_struct	*nlmsvc_task;
 static struct svc_rqst		*nlmsvc_rqst;
 unsigned long			nlmsvc_timeout;
@@ -306,13 +307,12 @@ static int lockd_inetaddr_event(struct notifier_block *this,
 	    !atomic_inc_not_zero(&nlm_ntf_refcnt))
 		goto out;
 
-	if (nlmsvc_rqst) {
+	if (nlmsvc_serv) {
 		dprintk("lockd_inetaddr_event: removed %pI4\n",
 			&ifa->ifa_local);
 		sin.sin_family = AF_INET;
 		sin.sin_addr.s_addr = ifa->ifa_local;
-		svc_age_temp_xprts_now(nlmsvc_rqst->rq_server,
-			(struct sockaddr *)&sin);
+		svc_age_temp_xprts_now(nlmsvc_serv, (struct sockaddr *)&sin);
 	}
 	atomic_dec(&nlm_ntf_refcnt);
 	wake_up(&nlm_ntf_wq);
@@ -336,14 +336,13 @@ static int lockd_inet6addr_event(struct notifier_block *this,
 	    !atomic_inc_not_zero(&nlm_ntf_refcnt))
 		goto out;
 
-	if (nlmsvc_rqst) {
+	if (nlmsvc_serv) {
 		dprintk("lockd_inet6addr_event: removed %pI6\n", &ifa->addr);
 		sin6.sin6_family = AF_INET6;
 		sin6.sin6_addr = ifa->addr;
 		if (ipv6_addr_type(&sin6.sin6_addr) & IPV6_ADDR_LINKLOCAL)
 			sin6.sin6_scope_id = ifa->idev->dev->ifindex;
-		svc_age_temp_xprts_now(nlmsvc_rqst->rq_server,
-			(struct sockaddr *)&sin6);
+		svc_age_temp_xprts_now(nlmsvc_serv, (struct sockaddr *)&sin6);
 	}
 	atomic_dec(&nlm_ntf_refcnt);
 	wake_up(&nlm_ntf_wq);
@@ -423,15 +422,17 @@ static const struct svc_serv_ops lockd_sv_ops = {
 	.svo_enqueue_xprt	= svc_xprt_do_enqueue,
 };
 
-static struct svc_serv *lockd_create_svc(void)
+static int lockd_create_svc(void)
 {
 	struct svc_serv *serv;
 
 	/*
 	 * Check whether we're already up and running.
 	 */
-	if (nlmsvc_rqst)
-		return svc_get(nlmsvc_rqst->rq_server);
+	if (nlmsvc_serv) {
+		svc_get(nlmsvc_serv);
+		return 0;
+	}
 
 	/*
 	 * Sanity check: if there's no pid,
@@ -448,14 +449,15 @@ static struct svc_serv *lockd_create_svc(void)
 	serv = svc_create(&nlmsvc_program, LOCKD_BUFSIZE, &lockd_sv_ops);
 	if (!serv) {
 		printk(KERN_WARNING "lockd_up: create service failed\n");
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	}
+	nlmsvc_serv = serv;
 	register_inetaddr_notifier(&lockd_inetaddr_notifier);
 #if IS_ENABLED(CONFIG_IPV6)
 	register_inet6addr_notifier(&lockd_inet6addr_notifier);
 #endif
 	dprintk("lockd_up: service created\n");
-	return serv;
+	return 0;
 }
 
 /*
@@ -468,11 +470,10 @@ int lockd_up(struct net *net, const struct cred *cred)
 
 	mutex_lock(&nlmsvc_mutex);
 
-	serv = lockd_create_svc();
-	if (IS_ERR(serv)) {
-		error = PTR_ERR(serv);
+	error = lockd_create_svc();
+	if (error)
 		goto err_create;
-	}
+	serv = nlmsvc_serv;
 
 	error = lockd_up_net(serv, net, cred);
 	if (error < 0) {
@@ -487,6 +488,8 @@ int lockd_up(struct net *net, const struct cred *cred)
 	}
 	nlmsvc_users++;
 err_put:
+	if (nlmsvc_users == 0)
+		nlmsvc_serv = NULL;
 	svc_put(serv);
 err_create:
 	mutex_unlock(&nlmsvc_mutex);
@@ -501,7 +504,7 @@ void
 lockd_down(struct net *net)
 {
 	mutex_lock(&nlmsvc_mutex);
-	lockd_down_net(nlmsvc_rqst->rq_server, net);
+	lockd_down_net(nlmsvc_serv, net);
 	if (nlmsvc_users) {
 		if (--nlmsvc_users)
 			goto out;
@@ -519,6 +522,7 @@ lockd_down(struct net *net)
 	dprintk("lockd_down: service stopped\n");
 	lockd_svc_exit_thread();
 	dprintk("lockd_down: service destroyed\n");
+	nlmsvc_serv = NULL;
 	nlmsvc_task = NULL;
 	nlmsvc_rqst = NULL;
 out:
-- 
2.43.0



