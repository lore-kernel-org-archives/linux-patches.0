Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D09612D74D;
	Tue, 18 Jun 2024 13:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716831; cv=none; b=qtKSAQgEDS7E8P6S5dIKVx6/VTcCp66lr1Lox7JVsFQc5ILC0+6Nvfic0ymQ+4emd7GCPjIESrIrfu4XZQu5Exgf5491FZtz5ypNpoT01RhcGWN6u3p0nxvBVPnhqz4h4/Y2KjJBl8SKiZ6Mts1Cd0ppNueRxrgQCeq/a/wSIKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716831; c=relaxed/simple;
	bh=b96oyU0PaHK3pdDD+6K5InWmbA1Skc8gZXHoWj5+nmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDrDjU3HOdG38txH0PAoQzYDBJnLNtuVi1FC5ZraalXbnql2V4SK+PGBr5CSYxgOEo2IxgJCk8evJJk6QYA7aNd0wZEfrU4lme55/m9/f64RWz8GYQqtpCYuTGAepdrX9j802G7o99cPsRc1626hfoBn96IPwMXYuCJToAdcBLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXD7fYxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXD7fYxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1FAC32786;
	Tue, 18 Jun 2024 13:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716830;
	bh=b96oyU0PaHK3pdDD+6K5InWmbA1Skc8gZXHoWj5+nmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXD7fYxJqHzzOrWZuG/R245wQD83upuRDobz7NkhxthQHqSqbMHxpkNfTU06alNFO
	 cKvwxXTsF2uuCNWTw4lU/Ak0uCcDpRc/dUHQ8i2lSOCc9u5Dla/lsF45gEkCUj1Ecu
	 VPB1pbX4ZWPMM5GlesizWNnLT76tCAD1YyIIFW5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 760/770] nfsd: dont allow nfsd threads to be signalled.
Date: Tue, 18 Jun 2024 14:40:13 +0200
Message-ID: <20240618123436.608102331@linuxfoundation.org>
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

[ Upstream commit 3903902401451b1cd9d797a8c79769eb26ac7fe5 ]

The original implementation of nfsd used signals to stop threads during
shutdown.
In Linux 2.3.46pre5 nfsd gained the ability to shutdown threads
internally it if was asked to run "0" threads.  After this user-space
transitioned to using "rpc.nfsd 0" to stop nfsd and sending signals to
threads was no longer an important part of the API.

In commit 3ebdbe5203a8 ("SUNRPC: discard svo_setup and rename
svc_set_num_threads_sync()") (v5.17-rc1~75^2~41) we finally removed the
use of signals for stopping threads, using kthread_stop() instead.

This patch makes the "obvious" next step and removes the ability to
signal nfsd threads - or any svc threads.  nfsd stops allowing signals
and we don't check for their delivery any more.

This will allow for some simplification in later patches.

A change worth noting is in nfsd4_ssc_setup_dul().  There was previously
a signal_pending() check which would only succeed when the thread was
being shut down.  It should really have tested kthread_should_stop() as
well.  Now it just does the latter, not the former.

Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback.c     | 11 ++---------
 fs/nfsd/nfs4proc.c    |  8 ++++----
 fs/nfsd/nfssvc.c      | 12 ------------
 net/sunrpc/svc_xprt.c | 20 ++++++++------------
 4 files changed, 14 insertions(+), 37 deletions(-)

diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index 456af7d230cf1..8fe143cad4a2b 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -80,9 +80,6 @@ nfs4_callback_svc(void *vrqstp)
 	set_freezable();
 
 	while (!kthread_freezable_should_stop(NULL)) {
-
-		if (signal_pending(current))
-			flush_signals(current);
 		/*
 		 * Listen for a request on the socket
 		 */
@@ -112,11 +109,7 @@ nfs41_callback_svc(void *vrqstp)
 	set_freezable();
 
 	while (!kthread_freezable_should_stop(NULL)) {
-
-		if (signal_pending(current))
-			flush_signals(current);
-
-		prepare_to_wait(&serv->sv_cb_waitq, &wq, TASK_INTERRUPTIBLE);
+		prepare_to_wait(&serv->sv_cb_waitq, &wq, TASK_IDLE);
 		spin_lock_bh(&serv->sv_cb_lock);
 		if (!list_empty(&serv->sv_cb_list)) {
 			req = list_first_entry(&serv->sv_cb_list,
@@ -131,7 +124,7 @@ nfs41_callback_svc(void *vrqstp)
 		} else {
 			spin_unlock_bh(&serv->sv_cb_lock);
 			if (!kthread_should_stop())
-				schedule();
+				freezable_schedule();
 			finish_wait(&serv->sv_cb_waitq, &wq);
 		}
 	}
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 9c51c10bcf080..8560a11daa47d 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/namei.h>
+#include <linux/freezer.h>
 
 #include <linux/sunrpc/addr.h>
 #include <linux/nfs_ssc.h>
@@ -1313,13 +1314,12 @@ static __be32 nfsd4_ssc_setup_dul(struct nfsd_net *nn, char *ipaddr,
 		/* found a match */
 		if (ni->nsui_busy) {
 			/*  wait - and try again */
-			prepare_to_wait(&nn->nfsd_ssc_waitq, &wait,
-				TASK_INTERRUPTIBLE);
+			prepare_to_wait(&nn->nfsd_ssc_waitq, &wait, TASK_IDLE);
 			spin_unlock(&nn->nfsd_ssc_lock);
 
 			/* allow 20secs for mount/unmount for now - revisit */
-			if (signal_pending(current) ||
-					(schedule_timeout(20*HZ) == 0)) {
+			if (kthread_should_stop() ||
+					(freezable_schedule_timeout(20*HZ) == 0)) {
 				finish_wait(&nn->nfsd_ssc_waitq, &wait);
 				kfree(work);
 				return nfserr_eagain;
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index a0ecec54d3d7d..8063fab2c0279 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -952,15 +952,6 @@ nfsd(void *vrqstp)
 
 	current->fs->umask = 0;
 
-	/*
-	 * thread is spawned with all signals set to SIG_IGN, re-enable
-	 * the ones that will bring down the thread
-	 */
-	allow_signal(SIGKILL);
-	allow_signal(SIGHUP);
-	allow_signal(SIGINT);
-	allow_signal(SIGQUIT);
-
 	atomic_inc(&nfsdstats.th_cnt);
 
 	set_freezable();
@@ -985,9 +976,6 @@ nfsd(void *vrqstp)
 		validate_process_creds();
 	}
 
-	/* Clear signals before calling svc_exit_thread() */
-	flush_signals(current);
-
 	atomic_dec(&nfsdstats.th_cnt);
 
 out:
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 000b737784bd9..d1eacf3358b81 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -674,13 +674,13 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
 		while (rqstp->rq_pages[i] == NULL) {
 			struct page *p = alloc_page(GFP_KERNEL);
 			if (!p) {
-				set_current_state(TASK_INTERRUPTIBLE);
-				if (signalled() || kthread_should_stop()) {
+				set_current_state(TASK_IDLE);
+				if (kthread_should_stop()) {
 					set_current_state(TASK_RUNNING);
 					return -EINTR;
 				}
-				schedule_timeout(msecs_to_jiffies(500));
 			}
+			freezable_schedule_timeout(msecs_to_jiffies(500));
 			rqstp->rq_pages[i] = p;
 		}
 	rqstp->rq_page_end = &rqstp->rq_pages[i];
@@ -713,7 +713,7 @@ rqst_should_sleep(struct svc_rqst *rqstp)
 		return false;
 
 	/* are we shutting down? */
-	if (signalled() || kthread_should_stop())
+	if (kthread_should_stop())
 		return false;
 
 	/* are we freezing? */
@@ -735,18 +735,14 @@ static struct svc_xprt *svc_get_next_xprt(struct svc_rqst *rqstp, long timeout)
 	if (rqstp->rq_xprt)
 		goto out_found;
 
-	/*
-	 * We have to be able to interrupt this wait
-	 * to bring down the daemons ...
-	 */
-	set_current_state(TASK_INTERRUPTIBLE);
+	set_current_state(TASK_IDLE);
 	smp_mb__before_atomic();
 	clear_bit(SP_CONGESTED, &pool->sp_flags);
 	clear_bit(RQ_BUSY, &rqstp->rq_flags);
 	smp_mb__after_atomic();
 
 	if (likely(rqst_should_sleep(rqstp)))
-		time_left = schedule_timeout(timeout);
+		time_left = freezable_schedule_timeout(timeout);
 	else
 		__set_current_state(TASK_RUNNING);
 
@@ -761,7 +757,7 @@ static struct svc_xprt *svc_get_next_xprt(struct svc_rqst *rqstp, long timeout)
 	if (!time_left)
 		atomic_long_inc(&pool->sp_stats.threads_timedout);
 
-	if (signalled() || kthread_should_stop())
+	if (kthread_should_stop())
 		return ERR_PTR(-EINTR);
 	return ERR_PTR(-EAGAIN);
 out_found:
@@ -860,7 +856,7 @@ int svc_recv(struct svc_rqst *rqstp, long timeout)
 	try_to_freeze();
 	cond_resched();
 	err = -EINTR;
-	if (signalled() || kthread_should_stop())
+	if (kthread_should_stop())
 		goto out;
 
 	xprt = svc_get_next_xprt(rqstp, timeout);
-- 
2.43.0



