Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DFD1DE88F;
	Tue,  8 Oct 2024 13:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392850; cv=none; b=UYkZWMyJa+bztovKLdKtlNr8cy0sc4Cb7zXbtP57QRnDu7VOcvme1CHULzOV5KbMHCDXsHhgcnW/MhcJCzUzdOBe3P/HDjyZady74QFUQUDZsDmMTtR/7Dxru0knb3mJXgICNQVTTtxJVRa/iRjogKRFYQ3HCMCnWl3sDo9LBVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392850; c=relaxed/simple;
	bh=zNgC0l4B0gNOEmLQ6ySG9GD56m7nfCurqRttVlnNiBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxMaJKF5lyhskfvGwTAKY4xtAQKrd9y4+VnWw+TiA6TG0IyJZcnxlq3ozzOAfzhzgiIyZ3w5db7/D+EYY/oszOBQKYILp5xBGZ/n1FGQnDM4EE+Jv6riDGEkckwefgsEoDQmPZrZperemGxhzi0s2lNcJTitQtVPlnKj2D9D204=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnZ5bQPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnZ5bQPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC1FC4CEC7;
	Tue,  8 Oct 2024 13:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392849;
	bh=zNgC0l4B0gNOEmLQ6ySG9GD56m7nfCurqRttVlnNiBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnZ5bQPbRuAyIJYWxHkCytr7TJ+GVUbY6CJqVkdM5DMwM9QRdZ8eoEoL8IWOZKuIt
	 a8qZCKeTjyaVsWNP+zA5L3Y1ad8pfPgThfrEmxHa1UDZALgPGNYraCzFtyi6ILf1D7
	 e/64piOlp+rQrF7REUpqOaSxHq5pd6Jl833JQvzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 537/558] sunrpc: change sp_nrthreads from atomic_t to unsigned int.
Date: Tue,  8 Oct 2024 14:09:27 +0200
Message-ID: <20241008115723.365178179@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 34eb2c2cbcde3..e8704a4e848ca 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1762,7 +1762,7 @@ int nfsd_nl_threads_get_doit(struct sk_buff *skb, struct genl_info *info)
 			struct svc_pool *sp = &nn->nfsd_serv->sv_pools[i];
 
 			err = nla_put_u32(skb, NFSD_A_SERVER_THREADS,
-					  atomic_read(&sp->sp_nrthreads));
+					  sp->sp_nrthreads);
 			if (err)
 				goto err_unlock;
 		}
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 0bc8eaa5e0098..8103c3c90cd11 100644
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
index a7d0406b9ef59..6811681033c0f 100644
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
index 88a59cfa5583c..df06b152ed94e 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -713,7 +713,7 @@ svc_prepare_thread(struct svc_serv *serv, struct svc_pool *pool, int node)
 	serv->sv_nrthreads += 1;
 	spin_unlock_bh(&serv->sv_lock);
 
-	atomic_inc(&pool->sp_nrthreads);
+	pool->sp_nrthreads += 1;
 
 	/* Protected by whatever lock the service uses when calling
 	 * svc_set_num_threads()
@@ -768,31 +768,22 @@ svc_pool_victim(struct svc_serv *serv, struct svc_pool *target_pool,
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
@@ -871,7 +862,7 @@ svc_set_num_threads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 	if (!pool)
 		nrservs -= serv->sv_nrthreads;
 	else
-		nrservs -= atomic_read(&pool->sp_nrthreads);
+		nrservs -= pool->sp_nrthreads;
 
 	if (nrservs > 0)
 		return svc_start_kthreads(serv, pool, nrservs);
@@ -959,7 +950,7 @@ svc_exit_thread(struct svc_rqst *rqstp)
 
 	list_del_rcu(&rqstp->rq_all);
 
-	atomic_dec(&pool->sp_nrthreads);
+	pool->sp_nrthreads -= 1;
 
 	spin_lock_bh(&serv->sv_lock);
 	serv->sv_nrthreads -= 1;
-- 
2.43.0



