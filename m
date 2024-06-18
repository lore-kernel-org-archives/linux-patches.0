Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF401A2C14;
	Tue, 18 Jun 2024 13:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716355; cv=none; b=VhADYG2d8w+JBYzbt/8J0Y4LBqVflgHjI58Ey46l6lAojb/wzRT8LB2DsHzwcDuHSU94yYD5UZfcAybtVLMRUZZ/m0b4T7A6Ue7L7IXwNxdGorbD7eFbebgqoNIaC9IZDGbg8ejFRZncuJ01azSO0WWWakBgvsn/PXI+6IcQRcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716355; c=relaxed/simple;
	bh=Jq3MaVjV1dORrm+7Ds1GavJwFJkJgJ356X6oUfV7EN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DklREjPWVr0UwicxJEAuiCLbcJgvLtUujuGNvKSksEvV6qXL2WmUXwyxpb4+suIwphH8rQIx58gVcAV3OlgH9UOM2qvC1FWCJ3io/YtoWYhF1iuIpbRMV652QwVA4F+Pg2e4btKpMRU7tBz1oULdc+NOfojb5vqjHtu2LbcwRZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XodO36Fm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XodO36Fm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB1CC3277B;
	Tue, 18 Jun 2024 13:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716355;
	bh=Jq3MaVjV1dORrm+7Ds1GavJwFJkJgJ356X6oUfV7EN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XodO36FmZ6hyJF9f+iMXnrAlxpJTLkDKnoZZYy6yaZH5ctxDaEaTtoEr9I2FigUYf
	 2LvEGp0N6SgM98Ms2k+LiPtTKZg70hnY9Nk8NYZN9gq3XN2gvtBh50fqpAUcwYyPso
	 4BDSMffWhKQuKagWYsnVvbWS4d3YzLr1555drXoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 587/770] NFSD: limit the number of v4 clients to 1024 per 1GB of system memory
Date: Tue, 18 Jun 2024 14:37:20 +0200
Message-ID: <20240618123429.952315921@linuxfoundation.org>
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

[ Upstream commit 4271c2c0887562318a0afef97d32d8a71cbe0743 ]

Currently there is no limit on how many v4 clients are supported
by the system. This can be a problem in systems with small memory
configuration to function properly when a very large number of
clients exist that creates memory shortage conditions.

This patch enforces a limit of 1024 NFSv4 clients, including courtesy
clients, per 1GB of system memory.  When the number of the clients
reaches the limit, requests that create new clients are returned
with NFS4ERR_DELAY and the laundromat is kicked start to trim old
clients. Due to the overhead of the upcall to remove the client
record, the maximun number of clients the laundromat removes on
each run is limited to 128. This is done to ensure the laundromat
can still process the other tasks in a timely manner.

Since there is now a limit of the number of clients, the 24-hr
idle time limit of courtesy client is no longer needed and was
removed.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/netns.h     |  1 +
 fs/nfsd/nfs4state.c | 27 +++++++++++++++++++++------
 fs/nfsd/nfsd.h      |  2 ++
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index ce864f001a3ee..ffe17743cc74b 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -191,6 +191,7 @@ struct nfsd_net {
 	siphash_key_t		siphash_key;
 
 	atomic_t		nfs4_client_count;
+	int			nfs4_max_clients;
 };
 
 /* Simple check to find out if a given net was properly initialized */
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 5003d73fa9287..1babc08fcb88f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2072,6 +2072,10 @@ static struct nfs4_client *alloc_client(struct xdr_netobj name,
 	struct nfs4_client *clp;
 	int i;
 
+	if (atomic_read(&nn->nfs4_client_count) >= nn->nfs4_max_clients) {
+		mod_delayed_work(laundry_wq, &nn->laundromat_work, 0);
+		return NULL;
+	}
 	clp = kmem_cache_zalloc(client_slab, GFP_KERNEL);
 	if (clp == NULL)
 		return NULL;
@@ -4353,6 +4357,9 @@ nfsd4_init_slabs(void)
 
 void nfsd4_init_leases_net(struct nfsd_net *nn)
 {
+	struct sysinfo si;
+	u64 max_clients;
+
 	nn->nfsd4_lease = 90;	/* default lease time */
 	nn->nfsd4_grace = 90;
 	nn->somebody_reclaimed = false;
@@ -4363,6 +4370,10 @@ void nfsd4_init_leases_net(struct nfsd_net *nn)
 	nn->s2s_cp_cl_id = nn->clientid_counter++;
 
 	atomic_set(&nn->nfs4_client_count, 0);
+	si_meminfo(&si);
+	max_clients = (u64)si.totalram * si.mem_unit / (1024 * 1024 * 1024);
+	max_clients *= NFS4_CLIENTS_PER_GB;
+	nn->nfs4_max_clients = max_t(int, max_clients, NFS4_CLIENTS_PER_GB);
 }
 
 static void init_nfs4_replay(struct nfs4_replay *rp)
@@ -5828,9 +5839,12 @@ static void
 nfs4_get_client_reaplist(struct nfsd_net *nn, struct list_head *reaplist,
 				struct laundry_time *lt)
 {
+	unsigned int maxreap, reapcnt = 0;
 	struct list_head *pos, *next;
 	struct nfs4_client *clp;
 
+	maxreap = (atomic_read(&nn->nfs4_client_count) >= nn->nfs4_max_clients) ?
+			NFSD_CLIENT_MAX_TRIM_PER_RUN : 0;
 	INIT_LIST_HEAD(reaplist);
 	spin_lock(&nn->client_lock);
 	list_for_each_safe(pos, next, &nn->client_lru) {
@@ -5841,14 +5855,15 @@ nfs4_get_client_reaplist(struct nfsd_net *nn, struct list_head *reaplist,
 			break;
 		if (!atomic_read(&clp->cl_rpc_users))
 			clp->cl_state = NFSD4_COURTESY;
-		if (!client_has_state(clp) ||
-				ktime_get_boottime_seconds() >=
-				(clp->cl_time + NFSD_COURTESY_CLIENT_TIMEOUT))
+		if (!client_has_state(clp))
 			goto exp_client;
-		if (nfs4_anylock_blockers(clp)) {
+		if (!nfs4_anylock_blockers(clp))
+			if (reapcnt >= maxreap)
+				continue;
 exp_client:
-			if (!mark_client_expired_locked(clp))
-				list_add(&clp->cl_lru, reaplist);
+		if (!mark_client_expired_locked(clp)) {
+			list_add(&clp->cl_lru, reaplist);
+			reapcnt++;
 		}
 	}
 	spin_unlock(&nn->client_lock);
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index ef8087691138a..57a468ed85c35 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -341,6 +341,8 @@ void		nfsd_lockd_shutdown(void);
 
 #define NFSD_LAUNDROMAT_MINTIMEOUT      1   /* seconds */
 #define	NFSD_COURTESY_CLIENT_TIMEOUT	(24 * 60 * 60)	/* seconds */
+#define	NFSD_CLIENT_MAX_TRIM_PER_RUN	128
+#define	NFS4_CLIENTS_PER_GB		1024
 
 /*
  * The following attributes are currently not supported by the NFSv4 server:
-- 
2.43.0



