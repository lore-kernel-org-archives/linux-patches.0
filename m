Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EFB192594;
	Tue,  8 Oct 2024 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390999; cv=none; b=ZN25HK105tq6+9BKVYoLY6oY6BbaS2IoCKlgLT8geAA4fEhbxx2yShsp9VJdEWn5/S3qVX9EtHpxETF+TDFwfHKVBuJa+tz4wdiOiMBve8JwKVGpu2jMon7vNK852xR7QETqtwWlZHWjsQsyRTLU0BBb5AM3ZoI0HJm6lrt3cgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390999; c=relaxed/simple;
	bh=WMofMWMtjfCeJGcrayBGUx2SWJWxnc/WOo5gmakumMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2/4wYVc6Lad6BfUb/Umq9yuBxNq12wmOnTA+oY1ENViGJZAD+wuyYsgyGukpfTM52I9cmkkSEUZZfwPxp3APmtmxaxBIf3o3VmfHR2dVbt1/KvVybkUYwFaSFtEhLaX1Etnc3O/hRPRTOQq5OTyoT7EeOJbtJz9w2i3NvKv8x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OEVsXTBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OEVsXTBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303D0C4CECD;
	Tue,  8 Oct 2024 12:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390998;
	bh=WMofMWMtjfCeJGcrayBGUx2SWJWxnc/WOo5gmakumMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OEVsXTBWQ0KoBSrkjXHQEZwnYSG1dOYB0Uv3AwlodozfscF5F1zXTrW1EOPL2XJwc
	 znezC3KKLvk8UwpLLL1X9urElGtI6xBQTx5wIKHuY6C7OmQtMD4gUTab9j5BUCxWX/
	 8I8ITR6vtIPz/C3rwx2HqrJntL8Gp07ofY3mYfLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 458/482] sunrpc: change sp_nrthreads from atomic_t to unsigned int.
Date: Tue,  8 Oct 2024 14:08:41 +0200
Message-ID: <20241008115706.539649865@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 60749cbe3d8ae572a6c7dda675de3e8b25797a18 ]

sp_nrthreads is only ever accessed under the service mutex
  nlmsvc_mutex nfs_callback_mutex nfsd_mutex
so these is no need for it to be an atomic_t.

The fact that all code using it is single-threaded means that we can
simplify svc_pool_victim and remove the temporary elevation of
sp_nrthreads.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: aadc3bbea163 ("NFSD: Limit the number of concurrent async COPY operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c           |  2 +-
 fs/nfsd/nfssvc.c           |  2 +-
 include/linux/sunrpc/svc.h |  4 ++--
 net/sunrpc/svc.c           | 31 +++++++++++--------------------
 4 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 0f9b4f7b56cd8..37f619ccafce0 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1746,7 +1746,7 @@ int nfsd_nl_threads_get_doit(struct sk_buff *skb, struct genl_info *info)
 			struct svc_pool *sp = &nn->nfsd_serv->sv_pools[i];
 
 			err = nla_put_u32(skb, NFSD_A_SERVER_THREADS,
-					  atomic_read(&sp->sp_nrthreads));
+					  sp->sp_nrthreads);
 			if (err)
 				goto err_unlock;
 		}
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 89d7918de7b1a..877f926356549 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -705,7 +705,7 @@ int nfsd_get_nrthreads(int n, int *nthreads, struct net *net)
 
 	if (serv)
 		for (i = 0; i < serv->sv_nrpools && i < n; i++)
-			nthreads[i] = atomic_read(&serv->sv_pools[i].sp_nrthreads);
+			nthreads[i] = serv->sv_pools[i].sp_nrthreads;
 	return 0;
 }
 
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 23617da0e565e..38a4fdf784e9a 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -33,9 +33,9 @@
  * node traffic on multi-node NUMA NFS servers.
  */
 struct svc_pool {
-	unsigned int		sp_id;	    	/* pool id; also node id on NUMA */
+	unsigned int		sp_id;		/* pool id; also node id on NUMA */
 	struct lwq		sp_xprts;	/* pending transports */
-	atomic_t		sp_nrthreads;	/* # of threads in pool */
+	unsigned int		sp_nrthreads;	/* # of threads in pool */
 	struct list_head	sp_all_threads;	/* all server threads */
 	struct llist_head	sp_idle_threads; /* idle server threads */
 
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index d9cda1e53a017..6a15b831589c0 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -682,7 +682,7 @@ svc_prepare_thread(struct svc_serv *serv, struct svc_pool *pool, int node)
 	serv->sv_nrthreads += 1;
 	spin_unlock_bh(&serv->sv_lock);
 
-	atomic_inc(&pool->sp_nrthreads);
+	pool->sp_nrthreads += 1;
 
 	/* Protected by whatever lock the service uses when calling
 	 * svc_set_num_threads()
@@ -737,31 +737,22 @@ svc_pool_victim(struct svc_serv *serv, struct svc_pool *target_pool,
 	struct svc_pool *pool;
 	unsigned int i;
 
-retry:
 	pool = target_pool;
 
-	if (pool != NULL) {
-		if (atomic_inc_not_zero(&pool->sp_nrthreads))
-			goto found_pool;
-		return NULL;
-	} else {
+	if (!pool) {
 		for (i = 0; i < serv->sv_nrpools; i++) {
 			pool = &serv->sv_pools[--(*state) % serv->sv_nrpools];
-			if (atomic_inc_not_zero(&pool->sp_nrthreads))
-				goto found_pool;
+			if (pool->sp_nrthreads)
+				break;
 		}
-		return NULL;
 	}
 
-found_pool:
-	set_bit(SP_VICTIM_REMAINS, &pool->sp_flags);
-	set_bit(SP_NEED_VICTIM, &pool->sp_flags);
-	if (!atomic_dec_and_test(&pool->sp_nrthreads))
+	if (pool && pool->sp_nrthreads) {
+		set_bit(SP_VICTIM_REMAINS, &pool->sp_flags);
+		set_bit(SP_NEED_VICTIM, &pool->sp_flags);
 		return pool;
-	/* Nothing left in this pool any more */
-	clear_bit(SP_NEED_VICTIM, &pool->sp_flags);
-	clear_bit(SP_VICTIM_REMAINS, &pool->sp_flags);
-	goto retry;
+	}
+	return NULL;
 }
 
 static int
@@ -840,7 +831,7 @@ svc_set_num_threads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 	if (!pool)
 		nrservs -= serv->sv_nrthreads;
 	else
-		nrservs -= atomic_read(&pool->sp_nrthreads);
+		nrservs -= pool->sp_nrthreads;
 
 	if (nrservs > 0)
 		return svc_start_kthreads(serv, pool, nrservs);
@@ -928,7 +919,7 @@ svc_exit_thread(struct svc_rqst *rqstp)
 
 	list_del_rcu(&rqstp->rq_all);
 
-	atomic_dec(&pool->sp_nrthreads);
+	pool->sp_nrthreads -= 1;
 
 	spin_lock_bh(&serv->sv_lock);
 	serv->sv_nrthreads -= 1;
-- 
2.43.0



