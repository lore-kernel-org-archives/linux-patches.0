Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DB413C3CF;
	Tue, 18 Jun 2024 13:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715805; cv=none; b=VA6Mz38+szQ3HWFtY19d/4fv3+PBnEGVvM6lvqTse8Q9TpOcGZJKNFAHvm0KD5UP/YDPGHhoH4mWNa3uq7ES2BPexam17ZMlomr8qq/U/WTZOmOZ395JcEtyR1Lh9L7kLTJvf7oZhZC5ycj+p1jBr2Ss68u8/nUyjo1jak0cDw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715805; c=relaxed/simple;
	bh=/eQ3sgTuszLSCZLmIzOlLthkgviubF8MH5D4ovSK3Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJ3riNVZSCsSgNw8ZbuYrevlBIbKcMg9je+c8TjWaG0wsI4o8eD4xuNPWs7HIiI7JhFdh9nFVmiyB2wRZ68PhCqQQbyVwmLkAOD0EW7p1qtTcGqLorXDvQ3Zlt21SQTvu7WXhir+8WB1CnLVutLJ3iwlUMKDVsBwinPf6qGHq4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0SFbPp9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0SFbPp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF12C3277B;
	Tue, 18 Jun 2024 13:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715805;
	bh=/eQ3sgTuszLSCZLmIzOlLthkgviubF8MH5D4ovSK3Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0SFbPp9UCxN1iWLVAArGjGlMaNAlPgbdFi0nNxvX7EUvBEROn3sy8Rn5IxA/Sic+
	 KgA77sYA+g0QZx3ZAODQ0Ry0MMgsdU7/XdRkqmbnR/vBFFX6yvdwdyO6/IoxCZflBA
	 nAYl0oqFCdp4xwm1tDnJsjf+wKgk0Y5+9Yg+T3yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 432/770] lockd: move svc_exit_thread() into the thread
Date: Tue, 18 Jun 2024 14:34:45 +0200
Message-ID: <20240618123423.959832835@linuxfoundation.org>
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

[ Upstream commit 6a4e2527a63620a820c4ebf3596b57176da26fb3 ]

The normal place to call svc_exit_thread() is from the thread itself
just before it exists.
Do this for lockd.

This means that nlmsvc_rqst is not used out side of lockd_start_svc(),
so it can be made local to that function, and renamed to 'rqst'.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svc.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 91e7c839841ec..9aa499a761591 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -56,7 +56,6 @@ static DEFINE_MUTEX(nlmsvc_mutex);
 static unsigned int		nlmsvc_users;
 static struct svc_serv		*nlmsvc_serv;
 static struct task_struct	*nlmsvc_task;
-static struct svc_rqst		*nlmsvc_rqst;
 unsigned long			nlmsvc_timeout;
 
 unsigned int lockd_net_id;
@@ -182,6 +181,11 @@ lockd(void *vrqstp)
 	nlm_shutdown_hosts();
 	cancel_delayed_work_sync(&ln->grace_period_end);
 	locks_end_grace(&ln->lockd_manager);
+
+	dprintk("lockd_down: service stopped\n");
+
+	svc_exit_thread(rqstp);
+
 	return 0;
 }
 
@@ -358,13 +362,14 @@ static void lockd_unregister_notifiers(void)
 static int lockd_start_svc(struct svc_serv *serv)
 {
 	int error;
+	struct svc_rqst *rqst;
 
 	/*
 	 * Create the kernel thread and wait for it to start.
 	 */
-	nlmsvc_rqst = svc_prepare_thread(serv, &serv->sv_pools[0], NUMA_NO_NODE);
-	if (IS_ERR(nlmsvc_rqst)) {
-		error = PTR_ERR(nlmsvc_rqst);
+	rqst = svc_prepare_thread(serv, &serv->sv_pools[0], NUMA_NO_NODE);
+	if (IS_ERR(rqst)) {
+		error = PTR_ERR(rqst);
 		printk(KERN_WARNING
 			"lockd_up: svc_rqst allocation failed, error=%d\n",
 			error);
@@ -374,24 +379,23 @@ static int lockd_start_svc(struct svc_serv *serv)
 	svc_sock_update_bufs(serv);
 	serv->sv_maxconn = nlm_max_connections;
 
-	nlmsvc_task = kthread_create(lockd, nlmsvc_rqst, "%s", serv->sv_name);
+	nlmsvc_task = kthread_create(lockd, rqst, "%s", serv->sv_name);
 	if (IS_ERR(nlmsvc_task)) {
 		error = PTR_ERR(nlmsvc_task);
 		printk(KERN_WARNING
 			"lockd_up: kthread_run failed, error=%d\n", error);
 		goto out_task;
 	}
-	nlmsvc_rqst->rq_task = nlmsvc_task;
+	rqst->rq_task = nlmsvc_task;
 	wake_up_process(nlmsvc_task);
 
 	dprintk("lockd_up: service started\n");
 	return 0;
 
 out_task:
-	svc_exit_thread(nlmsvc_rqst);
+	svc_exit_thread(rqst);
 	nlmsvc_task = NULL;
 out_rqst:
-	nlmsvc_rqst = NULL;
 	return error;
 }
 
@@ -500,9 +504,6 @@ lockd_down(struct net *net)
 	}
 	lockd_unregister_notifiers();
 	kthread_stop(nlmsvc_task);
-	dprintk("lockd_down: service stopped\n");
-	svc_exit_thread(nlmsvc_rqst);
-	nlmsvc_rqst = NULL;
 	dprintk("lockd_down: service destroyed\n");
 	nlmsvc_serv = NULL;
 	nlmsvc_task = NULL;
-- 
2.43.0



