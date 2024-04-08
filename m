Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5953185954;
	Mon,  8 Apr 2024 13:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583311; cv=none; b=DKqmnzgiwB9mzfK5AcJCs0MC9nNd8zdgD8e5QZp13f9/VZXOwuF3EYP7l1Z3ytUpXkf+eneDYJuX3YK4voVunkF8XZeajKmAfTHUtH5uNaXfowcRBaTnQq8fBiv5jE/Akyp8rYoArCXGfx5lyQqeNE5n/HtqJpmGH8k5n0wXhzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583311; c=relaxed/simple;
	bh=kzQf1X0xxEbadvm3mAPs9L5DwWkdfOXXBsNUwQZ6eTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5sBJO7iB4KgFsuXuzNsW6I5YhX94N6zOxOkC64xwSWqv6ifyllYB84ziL9Ahc7JDqXzUO1vXZAekBPP2hyKQ5Ylm7zCbJ/EPUYEjIH7FiQ7t1/lZ9JOpVHmFvJgHudjAtK61hcWJ//PZqTLGXukeVWYt92qcfvPz2Hnj9weUq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LyA+XnU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LyA+XnU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43BBC433F1;
	Mon,  8 Apr 2024 13:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583311;
	bh=kzQf1X0xxEbadvm3mAPs9L5DwWkdfOXXBsNUwQZ6eTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyA+XnU1IPbatOKHNAgjjI0iLHN9L3mhRN0c4g6KplUuAxMYP3JWUNo6WHlTaGd4a
	 g2LY6A5yJfMto3Ua0XvMPkAGw+vb8LQMD9STfQSf1CDu0G+evyKef2+j0bIyio6avX
	 u+ViWKQVeZNEz7igdau1W4YxDFTkhYTE34wdgaVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 233/690] NFSD: Make it possible to use svc_set_num_threads_sync
Date: Mon,  8 Apr 2024 14:51:39 +0200
Message-ID: <20240408125408.064535466@linuxfoundation.org>
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

[ Upstream commit 3409e4f1e8f239f0ed81be0b068ecf4e73e2e826 ]

nfsd cannot currently use svc_set_num_threads_sync.  It instead
uses svc_set_num_threads which does *not* wait for threads to all
exit, and has a separate mechanism (nfsd_shutdown_complete) to wait
for completion.

The reason that nfsd is unlike other services is that nfsd threads can
exit separately from svc_set_num_threads being called - they die on
receipt of SIGKILL.  Also, when the last thread exits, the service must
be shut down (sockets closed).

For this, the nfsd_mutex needs to be taken, and as that mutex needs to
be held while svc_set_num_threads is called, the one cannot wait for
the other.

This patch changes the nfsd thread so that it can drop the ref on the
service without blocking on nfsd_mutex, so that svc_set_num_threads_sync
can be used:
 - if it can drop a non-last reference, it does that.  This does not
   trigger shutdown and does not require a mutex.  This will likely
   happen for all but the last thread signalled, and for all threads
   being shut down by nfsd_shutdown_threads()
 - if it can get the mutex without blocking (trylock), it does that
   and then drops the reference.  This will likely happen for the
   last thread killed by SIGKILL
 - Otherwise there might be an unrelated task holding the mutex,
   possibly in another network namespace, or nfsd_shutdown_threads()
   might be just about to get a reference on the service, after which
   we can drop ours safely.
   We cannot conveniently get wakeup notifications on these events,
   and we are unlikely to need to, so we sleep briefly and check again.

With this we can discard nfsd_shutdown_complete and
nfsd_complete_shutdown(), and switch to svc_set_num_threads_sync.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/netns.h            |  3 ---
 fs/nfsd/nfssvc.c           | 41 +++++++++++++++++++-------------------
 include/linux/sunrpc/svc.h | 13 ++++++++++++
 3 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index 08bcd8f23b013..1fd59eb0730bb 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -134,9 +134,6 @@ struct nfsd_net {
 	wait_queue_head_t ntf_wq;
 	atomic_t ntf_refcnt;
 
-	/* Allow umount to wait for nfsd state cleanup */
-	struct completion nfsd_shutdown_complete;
-
 	/*
 	 * clientid and stateid data for construction of net unique COPY
 	 * stateids.
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index eb8cc4d914fee..6b10415e4006b 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -593,20 +593,10 @@ static const struct svc_serv_ops nfsd_thread_sv_ops = {
 	.svo_shutdown		= nfsd_last_thread,
 	.svo_function		= nfsd,
 	.svo_enqueue_xprt	= svc_xprt_do_enqueue,
-	.svo_setup		= svc_set_num_threads,
+	.svo_setup		= svc_set_num_threads_sync,
 	.svo_module		= THIS_MODULE,
 };
 
-static void nfsd_complete_shutdown(struct net *net)
-{
-	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
-
-	WARN_ON(!mutex_is_locked(&nfsd_mutex));
-
-	nn->nfsd_serv = NULL;
-	complete(&nn->nfsd_shutdown_complete);
-}
-
 void nfsd_shutdown_threads(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
@@ -624,8 +614,6 @@ void nfsd_shutdown_threads(struct net *net)
 	serv->sv_ops->svo_setup(serv, NULL, 0);
 	nfsd_put(net);
 	mutex_unlock(&nfsd_mutex);
-	/* Wait for shutdown of nfsd_serv to complete */
-	wait_for_completion(&nn->nfsd_shutdown_complete);
 }
 
 bool i_am_nfsd(void)
@@ -650,7 +638,6 @@ int nfsd_create_serv(struct net *net)
 						&nfsd_thread_sv_ops);
 	if (nn->nfsd_serv == NULL)
 		return -ENOMEM;
-	init_completion(&nn->nfsd_shutdown_complete);
 
 	nn->nfsd_serv->sv_maxconn = nn->max_connections;
 	error = svc_bind(nn->nfsd_serv, net);
@@ -659,7 +646,7 @@ int nfsd_create_serv(struct net *net)
 		 * been set up yet.
 		 */
 		svc_put(nn->nfsd_serv);
-		nfsd_complete_shutdown(net);
+		nn->nfsd_serv = NULL;
 		return error;
 	}
 
@@ -715,7 +702,7 @@ void nfsd_put(struct net *net)
 	if (kref_put(&nn->nfsd_serv->sv_refcnt, nfsd_noop)) {
 		svc_shutdown_net(nn->nfsd_serv, net);
 		svc_destroy(&nn->nfsd_serv->sv_refcnt);
-		nfsd_complete_shutdown(net);
+		nn->nfsd_serv = NULL;
 	}
 }
 
@@ -743,7 +730,7 @@ int nfsd_set_nrthreads(int n, int *nthreads, struct net *net)
 	if (tot > NFSD_MAXSERVS) {
 		/* total too large: scale down requested numbers */
 		for (i = 0; i < n && tot > 0; i++) {
-		    	int new = nthreads[i] * NFSD_MAXSERVS / tot;
+			int new = nthreads[i] * NFSD_MAXSERVS / tot;
 			tot -= (nthreads[i] - new);
 			nthreads[i] = new;
 		}
@@ -989,10 +976,22 @@ nfsd(void *vrqstp)
 	/* Release the thread */
 	svc_exit_thread(rqstp);
 
-	/* Now if needed we call svc_destroy in appropriate context */
-	mutex_lock(&nfsd_mutex);
-	nfsd_put(net);
-	mutex_unlock(&nfsd_mutex);
+	/* We need to drop a ref, but may not drop the last reference
+	 * without holding nfsd_mutex, and we cannot wait for nfsd_mutex as that
+	 * could deadlock with nfsd_shutdown_threads() waiting for us.
+	 * So three options are:
+	 * - drop a non-final reference,
+	 * - get the mutex without waiting
+	 * - sleep briefly andd try the above again
+	 */
+	while (!svc_put_not_last(nn->nfsd_serv)) {
+		if (mutex_trylock(&nfsd_mutex)) {
+			nfsd_put(net);
+			mutex_unlock(&nfsd_mutex);
+			break;
+		}
+		msleep(20);
+	}
 
 	/* Release module */
 	module_put_and_kthread_exit(0);
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index fdc32ffef0184..d22bd62093146 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -141,6 +141,19 @@ static inline void svc_put(struct svc_serv *serv)
 	kref_put(&serv->sv_refcnt, svc_destroy);
 }
 
+/**
+ * svc_put_not_last - decrement non-final reference count on SUNRPC serv
+ * @serv:  the svc_serv to have count decremented
+ *
+ * Returns: %true is refcount was decremented.
+ *
+ * If the refcount is 1, it is not decremented and instead failure is reported.
+ */
+static inline bool svc_put_not_last(struct svc_serv *serv)
+{
+	return refcount_dec_not_one(&serv->sv_refcnt.refcount);
+}
+
 /*
  * Maximum payload size supported by a kernel RPC server.
  * This is use to determine the max number of pages nfsd is
-- 
2.43.0



