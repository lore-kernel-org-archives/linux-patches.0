Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE44C156F3F;
	Tue, 18 Jun 2024 13:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715799; cv=none; b=W7RfOB5zVYYrXWK9n45psYwKlGQNsteAU7T6Tp7EpDogEgP2zu3Kl/4YG3FIojZeY9TTGE4BLndjz/O4OQhppjMRec65gLp/sbfRWFYziQyG/T+LsEr5q86aQkDpJ3laAAAQV6DTJggWsdjpKfkeoCeRIBYfjVSmeqwx0mRplQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715799; c=relaxed/simple;
	bh=R2PptO4ZPkb+30pMwtQZ0oxQLuMaKSLjIzX/GTHLhVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJXb4cddyYK/Vb/bwb+7+x5MeMIekRLozBpxHuEXSwj5381vs826kPxmXfBIITkFNZogurLZBMryU1Y3GVFaKuy36WWZQyW5ZzpS9wW2H4/dl6Q/OM1OD3QBhbr6IEGB5jLV2wNwM3nFzj+ZPdcYGD5aR5vpRMJUjcR5fJteJlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zcw5mzDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zcw5mzDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46134C3277B;
	Tue, 18 Jun 2024 13:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715799;
	bh=R2PptO4ZPkb+30pMwtQZ0oxQLuMaKSLjIzX/GTHLhVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zcw5mzDKkDt6aWBC+nxWyeTAc2voJwdgJEaUdFz8AMfK0wZitiIWePYVMcTotoQc9
	 W6e2wrYQpI2qZpP9wQMo+GYk1Y62pK6GOsQknqtQkXfcNRfOWflofEBl8BUx7uA/7t
	 1Za72wj6JGcxe6K7xZWkS/Zw1SW95o2+/6B+2/Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 430/770] lockd: simplify management of network status notifiers
Date: Tue, 18 Jun 2024 14:34:43 +0200
Message-ID: <20240618123423.883168627@linuxfoundation.org>
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

[ Upstream commit 5a8a7ff57421b7de3ae72019938ffb5daaee36e7 ]

Now that the network status notifiers use nlmsvc_serv rather then
nlmsvc_rqst the management can be simplified.

Notifier unregistration synchronises with any pending notifications so
providing we unregister before nlm_serv is freed no further interlock
is required.

So we move the unregister call to just before the thread is killed
(which destroys the service) and just before the service is destroyed in
the failure-path of lockd_up().

Then nlm_ntf_refcnt and nlm_ntf_wq can be removed.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svc.c | 35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 83874878f41d8..20cebb191350f 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -59,9 +59,6 @@ static struct task_struct	*nlmsvc_task;
 static struct svc_rqst		*nlmsvc_rqst;
 unsigned long			nlmsvc_timeout;
 
-static atomic_t nlm_ntf_refcnt = ATOMIC_INIT(0);
-static DECLARE_WAIT_QUEUE_HEAD(nlm_ntf_wq);
-
 unsigned int lockd_net_id;
 
 /*
@@ -303,8 +300,7 @@ static int lockd_inetaddr_event(struct notifier_block *this,
 	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
 	struct sockaddr_in sin;
 
-	if ((event != NETDEV_DOWN) ||
-	    !atomic_inc_not_zero(&nlm_ntf_refcnt))
+	if (event != NETDEV_DOWN)
 		goto out;
 
 	if (nlmsvc_serv) {
@@ -314,8 +310,6 @@ static int lockd_inetaddr_event(struct notifier_block *this,
 		sin.sin_addr.s_addr = ifa->ifa_local;
 		svc_age_temp_xprts_now(nlmsvc_serv, (struct sockaddr *)&sin);
 	}
-	atomic_dec(&nlm_ntf_refcnt);
-	wake_up(&nlm_ntf_wq);
 
 out:
 	return NOTIFY_DONE;
@@ -332,8 +326,7 @@ static int lockd_inet6addr_event(struct notifier_block *this,
 	struct inet6_ifaddr *ifa = (struct inet6_ifaddr *)ptr;
 	struct sockaddr_in6 sin6;
 
-	if ((event != NETDEV_DOWN) ||
-	    !atomic_inc_not_zero(&nlm_ntf_refcnt))
+	if (event != NETDEV_DOWN)
 		goto out;
 
 	if (nlmsvc_serv) {
@@ -344,8 +337,6 @@ static int lockd_inet6addr_event(struct notifier_block *this,
 			sin6.sin6_scope_id = ifa->idev->dev->ifindex;
 		svc_age_temp_xprts_now(nlmsvc_serv, (struct sockaddr *)&sin6);
 	}
-	atomic_dec(&nlm_ntf_refcnt);
-	wake_up(&nlm_ntf_wq);
 
 out:
 	return NOTIFY_DONE;
@@ -362,14 +353,6 @@ static void lockd_unregister_notifiers(void)
 #if IS_ENABLED(CONFIG_IPV6)
 	unregister_inet6addr_notifier(&lockd_inet6addr_notifier);
 #endif
-	wait_event(nlm_ntf_wq, atomic_read(&nlm_ntf_refcnt) == 0);
-}
-
-static void lockd_svc_exit_thread(void)
-{
-	atomic_dec(&nlm_ntf_refcnt);
-	lockd_unregister_notifiers();
-	svc_exit_thread(nlmsvc_rqst);
 }
 
 static int lockd_start_svc(struct svc_serv *serv)
@@ -388,11 +371,9 @@ static int lockd_start_svc(struct svc_serv *serv)
 		printk(KERN_WARNING
 			"lockd_up: svc_rqst allocation failed, error=%d\n",
 			error);
-		lockd_unregister_notifiers();
 		goto out_rqst;
 	}
 
-	atomic_inc(&nlm_ntf_refcnt);
 	svc_sock_update_bufs(serv);
 	serv->sv_maxconn = nlm_max_connections;
 
@@ -410,7 +391,7 @@ static int lockd_start_svc(struct svc_serv *serv)
 	return 0;
 
 out_task:
-	lockd_svc_exit_thread();
+	svc_exit_thread(nlmsvc_rqst);
 	nlmsvc_task = NULL;
 out_rqst:
 	nlmsvc_rqst = NULL;
@@ -477,7 +458,6 @@ int lockd_up(struct net *net, const struct cred *cred)
 
 	error = lockd_up_net(serv, net, cred);
 	if (error < 0) {
-		lockd_unregister_notifiers();
 		goto err_put;
 	}
 
@@ -488,8 +468,10 @@ int lockd_up(struct net *net, const struct cred *cred)
 	}
 	nlmsvc_users++;
 err_put:
-	if (nlmsvc_users == 0)
+	if (nlmsvc_users == 0) {
+		lockd_unregister_notifiers();
 		nlmsvc_serv = NULL;
+	}
 	svc_put(serv);
 err_create:
 	mutex_unlock(&nlmsvc_mutex);
@@ -518,13 +500,14 @@ lockd_down(struct net *net)
 		printk(KERN_ERR "lockd_down: no lockd running.\n");
 		BUG();
 	}
+	lockd_unregister_notifiers();
 	kthread_stop(nlmsvc_task);
 	dprintk("lockd_down: service stopped\n");
-	lockd_svc_exit_thread();
+	svc_exit_thread(nlmsvc_rqst);
+	nlmsvc_rqst = NULL;
 	dprintk("lockd_down: service destroyed\n");
 	nlmsvc_serv = NULL;
 	nlmsvc_task = NULL;
-	nlmsvc_rqst = NULL;
 out:
 	mutex_unlock(&nlmsvc_mutex);
 }
-- 
2.43.0



