Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4439156F39;
	Tue, 18 Jun 2024 13:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715793; cv=none; b=Al8gy3wBJQpUjOFpOkT4Fj0AOIbRFuWQi6o4N4M/6bbRwIsoCMA9394DKJMigK7ZPHk6xBCYeZAunfb7Kbtro+52urkMAcHXIAwoNn5oXED/zsxus6Qv5EMVomOdXdM15Ryx7mIQ86tWVoDIi4fahU/AuN0ggMtE8E7PU+uqULY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715793; c=relaxed/simple;
	bh=j4eIXLX8LDJBNXbkzhccrkYdYMNSIESrutiykSLqYtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvbwLFt+k/aYHATcb0LxDtsuxmW9X4q6I4pwt7dr8jl2wp4gqX3sk/9ciVZWgNpGp/7r+q++YoQRdsuF1hYxkhHP2hC5ppgBMzk5CGJriqjI0Vh1xwnWkXzr8DCpXgEGiCnMTh154uVRVxnhL9Xi4+7WSdcYQCcUOfesnrm2FfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MD2tiPsO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MD2tiPsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A812C3277B;
	Tue, 18 Jun 2024 13:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715793;
	bh=j4eIXLX8LDJBNXbkzhccrkYdYMNSIESrutiykSLqYtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MD2tiPsOqECUMuwu/phPGQ4vFE7Ddub26j7nDaMK2D9U203qBXsDfotlUqtzPxdoG
	 aDK0mAQvaG90VzaLSnbV7Tq++wLwW+6g2/y89J75QaOrGK4EeHBZ81iDHRLuRGdstM
	 Iya9FaJHWpz+fIw02eXMMo+V3+pR7vqfzXaKI4G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 429/770] lockd: introduce nlmsvc_serv
Date: Tue, 18 Jun 2024 14:34:42 +0200
Message-ID: <20240618123423.843459863@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



