Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EBA14A62D;
	Thu, 23 May 2024 13:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470311; cv=none; b=Vl4y0W7FkfSQqv5zbq22FCUSfBaGPDMG2fluU875eORw/jhasxsPtkIhxCQKv+9BMeIGlkVeGUPkQPWs7WgTSf+JZMpJgAtUHIPD0ns6tmRcqpzClYTSGNGCn0oDsyNWegPOeQt4t9y0/GGm3hvpAljDjne9jlo5rhr9FwsOFnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470311; c=relaxed/simple;
	bh=kHJZrClg4f2xjg8mFPR3cngLsh0FLDz9aY3CWx3CJn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlPRb/UlS4q6TtLDdrr8VlJyu9FK7Hy5//LpIbmkoQMm/MCSsec9ovbzjoumS2FpcOVqGmWjad3pu89RelYGb4L6BUkqXQCiozQeFm9AOyG8NRt18BLDMbmTosaa4e01OzBLuZ1Lvc27dZT7MFiTkepDE3ixqDa4P3xUe+zKjDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcobkIst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcobkIst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44682C32786;
	Thu, 23 May 2024 13:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470311;
	bh=kHJZrClg4f2xjg8mFPR3cngLsh0FLDz9aY3CWx3CJn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OcobkIstbl3h4UVHEtrlptlvQWc1fim5Bn7R2SseAnwpu1jmNqiIxjXQ4UdWS75ua
	 ZfvFgnx1XtTvlGZpp9gvi9OFisKXZsv84nTyV9YtS3LWRhX9nVFRKIJoDhYdij1BtK
	 lBQL/HyKoAcSFYTBePhOcCtOrSVUg8lay0ZGDWZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 03/23] nfsd: dont allow nfsd threads to be signalled.
Date: Thu, 23 May 2024 15:12:59 +0200
Message-ID: <20240523130328.087334492@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
References: <20240523130327.956341021@linuxfoundation.org>
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

commit 3903902401451b1cd9d797a8c79769eb26ac7fe5 upstream.

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
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/callback.c     |    9 +--------
 fs/nfsd/nfs4proc.c    |    5 ++---
 fs/nfsd/nfssvc.c      |   12 ------------
 net/sunrpc/svc_xprt.c |   16 ++++++----------
 4 files changed, 9 insertions(+), 33 deletions(-)

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
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1317,12 +1317,11 @@ try_again:
 		/* found a match */
 		if (ni->nsui_busy) {
 			/*  wait - and try again */
-			prepare_to_wait(&nn->nfsd_ssc_waitq, &wait,
-				TASK_INTERRUPTIBLE);
+			prepare_to_wait(&nn->nfsd_ssc_waitq, &wait, TASK_IDLE);
 			spin_unlock(&nn->nfsd_ssc_lock);
 
 			/* allow 20secs for mount/unmount for now - revisit */
-			if (signal_pending(current) ||
+			if (kthread_should_stop() ||
 					(schedule_timeout(20*HZ) == 0)) {
 				finish_wait(&nn->nfsd_ssc_waitq, &wait);
 				kfree(work);
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -938,15 +938,6 @@ nfsd(void *vrqstp)
 
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
@@ -971,9 +962,6 @@ nfsd(void *vrqstp)
 		validate_process_creds();
 	}
 
-	/* Clear signals before calling svc_exit_thread() */
-	flush_signals(current);
-
 	atomic_dec(&nfsdstats.th_cnt);
 
 out:
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -700,8 +700,8 @@ static int svc_alloc_arg(struct svc_rqst
 			/* Made progress, don't sleep yet */
 			continue;
 
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (signalled() || kthread_should_stop()) {
+		set_current_state(TASK_IDLE);
+		if (kthread_should_stop()) {
 			set_current_state(TASK_RUNNING);
 			return -EINTR;
 		}
@@ -736,7 +736,7 @@ rqst_should_sleep(struct svc_rqst *rqstp
 		return false;
 
 	/* are we shutting down? */
-	if (signalled() || kthread_should_stop())
+	if (kthread_should_stop())
 		return false;
 
 	/* are we freezing? */
@@ -758,11 +758,7 @@ static struct svc_xprt *svc_get_next_xpr
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
@@ -784,7 +780,7 @@ static struct svc_xprt *svc_get_next_xpr
 	if (!time_left)
 		atomic_long_inc(&pool->sp_stats.threads_timedout);
 
-	if (signalled() || kthread_should_stop())
+	if (kthread_should_stop())
 		return ERR_PTR(-EINTR);
 	return ERR_PTR(-EAGAIN);
 out_found:
@@ -882,7 +878,7 @@ int svc_recv(struct svc_rqst *rqstp, lon
 	try_to_freeze();
 	cond_resched();
 	err = -EINTR;
-	if (signalled() || kthread_should_stop())
+	if (kthread_should_stop())
 		goto out;
 
 	xprt = svc_get_next_xprt(rqstp, timeout);


