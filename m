Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81A11A38E4;
	Tue, 18 Jun 2024 13:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716443; cv=none; b=VETCpiXOj063whm6g7I9KzGSrng7JgEr3G52tpyb5RbbXIG31/utEPWBrK2XSrcW1zNOnRh+8H+oYX4dX2CKM8XoIfFrvyrssDsYKEYqut1L4fNkq4qga1q86jXXJMRxYt27bKCWjxqd9HBUfFoM3bVMc3SXzaEo3mioCOU1hnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716443; c=relaxed/simple;
	bh=el9+lZBSZn4etfJx8wTMbz90q97gj5adf4CbHp8bMDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6OXkeBEDkAx6HJA9lPA08gfC41XZtvjv7++xFXcRuVwOxQquGZ8Bk4cvHVheESQ9JIxECNJ5vkYONdSREBM8TYwKgRDISPtzCY1ZdB1xZnVgDQKJH4GoKYZj9CQmTqdRF2xmzBXWmSu4FjXjCTNjFSFfHugMkzPnKwD+vA44OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqniKobi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqniKobi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A5EC3277B;
	Tue, 18 Jun 2024 13:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716443;
	bh=el9+lZBSZn4etfJx8wTMbz90q97gj5adf4CbHp8bMDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqniKobin7qeCMg0GVghHROqFLyNiJFL6C9pw/iqOJqHGH6U3LqiOxjXC1iM/B/mt
	 TKvoKTXGtQC8q6nd4rwnYdl/En34+0WcOQVZW43m7dZLTNlXd6/mSoVoxCogXkHK4h
	 zL0RW6AXJ0gQOJUaravufdP4lRfOHgQMf4MSz/UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 647/770] NFSD: keep track of the number of courtesy clients in the system
Date: Tue, 18 Jun 2024 14:38:20 +0200
Message-ID: <20240618123432.263622876@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 3a4ea23d86a317c4b68b9a69d51f7e84e1e04357 ]

Add counter nfs4_courtesy_client_count to nfsd_net to keep track
of the number of courtesy clients in the system.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/netns.h     |  2 ++
 fs/nfsd/nfs4state.c | 17 ++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index ffe17743cc74b..55c7006d6109a 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -192,6 +192,8 @@ struct nfsd_net {
 
 	atomic_t		nfs4_client_count;
 	int			nfs4_max_clients;
+
+	atomic_t		nfsd_courtesy_clients;
 };
 
 /* Simple check to find out if a given net was properly initialized */
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 2bb78ab4f6c31..9930c5f9440c7 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -160,6 +160,13 @@ static bool is_client_expired(struct nfs4_client *clp)
 	return clp->cl_time == 0;
 }
 
+static void nfsd4_dec_courtesy_client_count(struct nfsd_net *nn,
+					struct nfs4_client *clp)
+{
+	if (clp->cl_state != NFSD4_ACTIVE)
+		atomic_add_unless(&nn->nfsd_courtesy_clients, -1, 0);
+}
+
 static __be32 get_client_locked(struct nfs4_client *clp)
 {
 	struct nfsd_net *nn = net_generic(clp->net, nfsd_net_id);
@@ -169,6 +176,7 @@ static __be32 get_client_locked(struct nfs4_client *clp)
 	if (is_client_expired(clp))
 		return nfserr_expired;
 	atomic_inc(&clp->cl_rpc_users);
+	nfsd4_dec_courtesy_client_count(nn, clp);
 	clp->cl_state = NFSD4_ACTIVE;
 	return nfs_ok;
 }
@@ -190,6 +198,7 @@ renew_client_locked(struct nfs4_client *clp)
 
 	list_move_tail(&clp->cl_lru, &nn->client_lru);
 	clp->cl_time = ktime_get_boottime_seconds();
+	nfsd4_dec_courtesy_client_count(nn, clp);
 	clp->cl_state = NFSD4_ACTIVE;
 }
 
@@ -2248,6 +2257,7 @@ __destroy_client(struct nfs4_client *clp)
 	if (clp->cl_cb_conn.cb_xprt)
 		svc_xprt_put(clp->cl_cb_conn.cb_xprt);
 	atomic_add_unless(&nn->nfs4_client_count, -1, 0);
+	nfsd4_dec_courtesy_client_count(nn, clp);
 	free_client(clp);
 	wake_up_all(&expiry_wq);
 }
@@ -4375,6 +4385,8 @@ void nfsd4_init_leases_net(struct nfsd_net *nn)
 	max_clients = (u64)si.totalram * si.mem_unit / (1024 * 1024 * 1024);
 	max_clients *= NFS4_CLIENTS_PER_GB;
 	nn->nfs4_max_clients = max_t(int, max_clients, NFS4_CLIENTS_PER_GB);
+
+	atomic_set(&nn->nfsd_courtesy_clients, 0);
 }
 
 static void init_nfs4_replay(struct nfs4_replay *rp)
@@ -5928,8 +5940,11 @@ nfs4_get_client_reaplist(struct nfsd_net *nn, struct list_head *reaplist,
 			goto exp_client;
 		if (!state_expired(lt, clp->cl_time))
 			break;
-		if (!atomic_read(&clp->cl_rpc_users))
+		if (!atomic_read(&clp->cl_rpc_users)) {
+			if (clp->cl_state == NFSD4_ACTIVE)
+				atomic_inc(&nn->nfsd_courtesy_clients);
 			clp->cl_state = NFSD4_COURTESY;
+		}
 		if (!client_has_state(clp))
 			goto exp_client;
 		if (!nfs4_anylock_blockers(clp))
-- 
2.43.0



