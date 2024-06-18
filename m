Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FD615A4BC;
	Tue, 18 Jun 2024 13:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716676; cv=none; b=OarkPupw8kwRCA8AbR1fJPnklQNFpht+cRvUveBbSj7x6PEDsBiGuBIaK3jTjEzB4VHEx7xt4exKxY2uw6eaRo2XbwSYgPxBXoapSQ4nNmRxouIruEPhxWQEGMP/l/jZuLhbpfyBrK7Uz663Kp7xiBM0uRehUvkzDEBx4hGPPJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716676; c=relaxed/simple;
	bh=7QgKRdMZYlTUzEY9VUDGh6wNIOj1YJ2wUgY0eung4YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgAd/sPamBoPeHx04pAlK87JEAg7S47KHGdeZghjW3fI5UM1IakypmXNN8JjEIBqu+RpqScG2jp8sIRuly2LUppgN7Xa6YbTad+TfUKzDac5X3FkWGyjKhQGHA0Pz+FCJvCdqbIFFxPgIzssshdLT6hJDbKSESlzDWGvM4HOdpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qH7i3NUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qH7i3NUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6319C3277B;
	Tue, 18 Jun 2024 13:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716676;
	bh=7QgKRdMZYlTUzEY9VUDGh6wNIOj1YJ2wUgY0eung4YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qH7i3NUYKX0L0lHrC1h14s2fp9oA7uwpTcPrLnRp5wdItLBlwrs/sUQ5EjhoUWmzk
	 qD0GOj4ba1Gsp1RMvgB5dQnn0BySJG7lF6mfCMRNQ17RJUbfZpuS0vWyed726b9L4j
	 V1mo8Gz6W2epijzrofDNDEn7iA9MVUtTEZRLt+tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 718/770] NFSD: add delegation reaper to react to low memory condition
Date: Tue, 18 Jun 2024 14:39:31 +0200
Message-ID: <20240618123434.985188341@linuxfoundation.org>
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

[ Upstream commit 44df6f439a1790a5f602e3842879efa88f346672 ]

The delegation reaper is called by nfsd memory shrinker's on
the 'count' callback. It scans the client list and sends the
courtesy CB_RECALL_ANY to the clients that hold delegations.

To avoid flooding the clients with CB_RECALL_ANY requests, the
delegation reaper sends only one CB_RECALL_ANY request to each
client per 5 seconds.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
[ cel: moved definition of RCA4_TYPE_MASK_RDATA_DLG ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c  | 88 ++++++++++++++++++++++++++++++++++++++++++--
 fs/nfsd/state.h      |  5 +++
 include/linux/nfs4.h | 13 +++++++
 3 files changed, 102 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 8fdf5ab5b9e47..4e05ad774c861 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2144,6 +2144,7 @@ static void __free_client(struct kref *k)
 	kfree(clp->cl_nii_domain.data);
 	kfree(clp->cl_nii_name.data);
 	idr_destroy(&clp->cl_stateids);
+	kfree(clp->cl_ra);
 	kmem_cache_free(client_slab, clp);
 }
 
@@ -2871,6 +2872,36 @@ static const struct tree_descr client_files[] = {
 	[3] = {""},
 };
 
+static int
+nfsd4_cb_recall_any_done(struct nfsd4_callback *cb,
+				struct rpc_task *task)
+{
+	switch (task->tk_status) {
+	case -NFS4ERR_DELAY:
+		rpc_delay(task, 2 * HZ);
+		return 0;
+	default:
+		return 1;
+	}
+}
+
+static void
+nfsd4_cb_recall_any_release(struct nfsd4_callback *cb)
+{
+	struct nfs4_client *clp = cb->cb_clp;
+	struct nfsd_net *nn = net_generic(clp->net, nfsd_net_id);
+
+	spin_lock(&nn->client_lock);
+	clear_bit(NFSD4_CLIENT_CB_RECALL_ANY, &clp->cl_flags);
+	put_client_renew_locked(clp);
+	spin_unlock(&nn->client_lock);
+}
+
+static const struct nfsd4_callback_ops nfsd4_cb_recall_any_ops = {
+	.done		= nfsd4_cb_recall_any_done,
+	.release	= nfsd4_cb_recall_any_release,
+};
+
 static struct nfs4_client *create_client(struct xdr_netobj name,
 		struct svc_rqst *rqstp, nfs4_verifier *verf)
 {
@@ -2908,6 +2939,14 @@ static struct nfs4_client *create_client(struct xdr_netobj name,
 		free_client(clp);
 		return NULL;
 	}
+	clp->cl_ra = kzalloc(sizeof(*clp->cl_ra), GFP_KERNEL);
+	if (!clp->cl_ra) {
+		free_client(clp);
+		return NULL;
+	}
+	clp->cl_ra_time = 0;
+	nfsd4_init_cb(&clp->cl_ra->ra_cb, clp, &nfsd4_cb_recall_any_ops,
+			NFSPROC4_CLNT_CB_RECALL_ANY);
 	return clp;
 }
 
@@ -4363,14 +4402,16 @@ nfsd4_init_slabs(void)
 static unsigned long
 nfsd4_state_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
 {
-	int cnt;
+	int count;
 	struct nfsd_net *nn = container_of(shrink,
 			struct nfsd_net, nfsd_client_shrinker);
 
-	cnt = atomic_read(&nn->nfsd_courtesy_clients);
-	if (cnt > 0)
+	count = atomic_read(&nn->nfsd_courtesy_clients);
+	if (!count)
+		count = atomic_long_read(&num_delegations);
+	if (count)
 		mod_delayed_work(laundry_wq, &nn->nfsd_shrinker_work, 0);
-	return (unsigned long)cnt;
+	return (unsigned long)count;
 }
 
 static unsigned long
@@ -6159,6 +6200,44 @@ courtesy_client_reaper(struct nfsd_net *nn)
 	nfs4_process_client_reaplist(&reaplist);
 }
 
+static void
+deleg_reaper(struct nfsd_net *nn)
+{
+	struct list_head *pos, *next;
+	struct nfs4_client *clp;
+	struct list_head cblist;
+
+	INIT_LIST_HEAD(&cblist);
+	spin_lock(&nn->client_lock);
+	list_for_each_safe(pos, next, &nn->client_lru) {
+		clp = list_entry(pos, struct nfs4_client, cl_lru);
+		if (clp->cl_state != NFSD4_ACTIVE ||
+			list_empty(&clp->cl_delegations) ||
+			atomic_read(&clp->cl_delegs_in_recall) ||
+			test_bit(NFSD4_CLIENT_CB_RECALL_ANY, &clp->cl_flags) ||
+			(ktime_get_boottime_seconds() -
+				clp->cl_ra_time < 5)) {
+			continue;
+		}
+		list_add(&clp->cl_ra_cblist, &cblist);
+
+		/* release in nfsd4_cb_recall_any_release */
+		atomic_inc(&clp->cl_rpc_users);
+		set_bit(NFSD4_CLIENT_CB_RECALL_ANY, &clp->cl_flags);
+		clp->cl_ra_time = ktime_get_boottime_seconds();
+	}
+	spin_unlock(&nn->client_lock);
+
+	while (!list_empty(&cblist)) {
+		clp = list_first_entry(&cblist, struct nfs4_client,
+					cl_ra_cblist);
+		list_del_init(&clp->cl_ra_cblist);
+		clp->cl_ra->ra_keep = 0;
+		clp->cl_ra->ra_bmval[0] = BIT(RCA4_TYPE_MASK_RDATA_DLG);
+		nfsd4_run_cb(&clp->cl_ra->ra_cb);
+	}
+}
+
 static void
 nfsd4_state_shrinker_worker(struct work_struct *work)
 {
@@ -6167,6 +6246,7 @@ nfsd4_state_shrinker_worker(struct work_struct *work)
 				nfsd_shrinker_work);
 
 	courtesy_client_reaper(nn);
+	deleg_reaper(nn);
 }
 
 static inline __be32 nfs4_check_fh(struct svc_fh *fhp, struct nfs4_stid *stp)
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index e30882f8b8516..e94634d305912 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -368,6 +368,7 @@ struct nfs4_client {
 #define NFSD4_CLIENT_UPCALL_LOCK	(5)	/* upcall serialization */
 #define NFSD4_CLIENT_CB_FLAG_MASK	(1 << NFSD4_CLIENT_CB_UPDATE | \
 					 1 << NFSD4_CLIENT_CB_KILL)
+#define NFSD4_CLIENT_CB_RECALL_ANY	(6)
 	unsigned long		cl_flags;
 	const struct cred	*cl_cb_cred;
 	struct rpc_clnt		*cl_cb_client;
@@ -411,6 +412,10 @@ struct nfs4_client {
 
 	unsigned int		cl_state;
 	atomic_t		cl_delegs_in_recall;
+
+	struct nfsd4_cb_recall_any	*cl_ra;
+	time64_t		cl_ra_time;
+	struct list_head	cl_ra_cblist;
 };
 
 /* struct nfs4_client_reset
diff --git a/include/linux/nfs4.h b/include/linux/nfs4.h
index 5b4c67c91f56a..ea88d0f462c9d 100644
--- a/include/linux/nfs4.h
+++ b/include/linux/nfs4.h
@@ -717,4 +717,17 @@ enum nfs4_setxattr_options {
 	SETXATTR4_CREATE	= 1,
 	SETXATTR4_REPLACE	= 2,
 };
+
+enum {
+	RCA4_TYPE_MASK_RDATA_DLG	= 0,
+	RCA4_TYPE_MASK_WDATA_DLG	= 1,
+	RCA4_TYPE_MASK_DIR_DLG		= 2,
+	RCA4_TYPE_MASK_FILE_LAYOUT	= 3,
+	RCA4_TYPE_MASK_BLK_LAYOUT	= 4,
+	RCA4_TYPE_MASK_OBJ_LAYOUT_MIN	= 8,
+	RCA4_TYPE_MASK_OBJ_LAYOUT_MAX	= 9,
+	RCA4_TYPE_MASK_OTHER_LAYOUT_MIN	= 12,
+	RCA4_TYPE_MASK_OTHER_LAYOUT_MAX	= 15,
+};
+
 #endif
-- 
2.43.0



