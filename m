Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4551A00E9;
	Tue, 18 Jun 2024 13:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716129; cv=none; b=aXybaqK9NgCXDFU7mILwEcBuCZdjv39311Vk4hQk8NKXzxXtxOqNQO31THvT8V1senpvdI/xfFdCZFzvRQVuOsiQPgUnsUS/IhTP0Qo+OBfvr1+uXsEnYJQvZ5SEi++keHceL+KFrd2d+wD7v0yIxUwrLKsoRhj0W54kdYHSID0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716129; c=relaxed/simple;
	bh=DY+btYOqxNG4/GXyW959hgzUWO/bV1M3Rr1FN1FuuzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPdNtXo4Vsn1vze0j5VMJ8IsZrTBBnNtlMDhcKt333y/AHpFye9PLkzG18WMC7lcrUI/fTj91h6fxCLbRWVk3xMgnK62fpQAmUKfCtg/Ce9KscVW0W9p3eAxzWv9ghC+1wr4HjUU8XuLyiEx2FDHuh8F/7QHCQS5GsbVpyDbL5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQv+qCYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQv+qCYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFFFC4AF1D;
	Tue, 18 Jun 2024 13:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716129;
	bh=DY+btYOqxNG4/GXyW959hgzUWO/bV1M3Rr1FN1FuuzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQv+qCYZdd8MtIYThc4eFul5dDCgr04hreQi9WaZ6aRVdh0TOgVEgvE2hMjyp6crG
	 /GIyjtEhfdhw2n7qdcuKbjlkkV6/fEDS+cAfbY9GVxtr5XyaSEWdXjidOfI2TtOiu8
	 lwLzGGxM9TbQOqcse7b+lnYZACl/hOrLcaR0KnW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 515/770] NFSD: add support for lock conflict to courteous server
Date: Tue, 18 Jun 2024 14:36:08 +0200
Message-ID: <20240618123427.194135354@linuxfoundation.org>
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

[ Upstream commit 27431affb0dbc259ac6ffe6071243a576c8f38f1 ]

This patch allows expired client with lock state to be in COURTESY
state. Lock conflict with COURTESY client is resolved by the fs/lock
code using the lm_lock_expirable and lm_expire_lock callback in the
struct lock_manager_operations.

If conflict client is in COURTESY state, set it to EXPIRABLE and
schedule the laundromat to run immediately to expire the client. The
callback lm_expire_lock waits for the laundromat to flush its work
queue before returning to caller.

Reviewed-by: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 70 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 30ea1c7b6b9fd..6851fece3a760 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5731,39 +5731,51 @@ static void nfsd4_ssc_expire_umount(struct nfsd_net *nn)
 }
 #endif
 
+/* Check if any lock belonging to this lockowner has any blockers */
 static bool
-nfs4_has_any_locks(struct nfs4_client *clp)
+nfs4_lockowner_has_blockers(struct nfs4_lockowner *lo)
+{
+	struct file_lock_context *ctx;
+	struct nfs4_ol_stateid *stp;
+	struct nfs4_file *nf;
+
+	list_for_each_entry(stp, &lo->lo_owner.so_stateids, st_perstateowner) {
+		nf = stp->st_stid.sc_file;
+		ctx = nf->fi_inode->i_flctx;
+		if (!ctx)
+			continue;
+		if (locks_owner_has_blockers(ctx, lo))
+			return true;
+	}
+	return false;
+}
+
+static bool
+nfs4_anylock_blockers(struct nfs4_client *clp)
 {
 	int i;
 	struct nfs4_stateowner *so;
+	struct nfs4_lockowner *lo;
 
+	if (atomic_read(&clp->cl_delegs_in_recall))
+		return true;
 	spin_lock(&clp->cl_lock);
 	for (i = 0; i < OWNER_HASH_SIZE; i++) {
 		list_for_each_entry(so, &clp->cl_ownerstr_hashtbl[i],
 				so_strhash) {
 			if (so->so_is_open_owner)
 				continue;
-			spin_unlock(&clp->cl_lock);
-			return true;
+			lo = lockowner(so);
+			if (nfs4_lockowner_has_blockers(lo)) {
+				spin_unlock(&clp->cl_lock);
+				return true;
+			}
 		}
 	}
 	spin_unlock(&clp->cl_lock);
 	return false;
 }
 
-/*
- * place holder for now, no check for lock blockers yet
- */
-static bool
-nfs4_anylock_blockers(struct nfs4_client *clp)
-{
-	if (atomic_read(&clp->cl_delegs_in_recall) ||
-			!list_empty(&clp->async_copies) ||
-			nfs4_has_any_locks(clp))
-		return true;
-	return false;
-}
-
 static void
 nfs4_get_client_reaplist(struct nfsd_net *nn, struct list_head *reaplist,
 				struct laundry_time *lt)
@@ -6743,6 +6755,29 @@ nfsd4_lm_put_owner(fl_owner_t owner)
 		nfs4_put_stateowner(&lo->lo_owner);
 }
 
+/* return pointer to struct nfs4_client if client is expirable */
+static bool
+nfsd4_lm_lock_expirable(struct file_lock *cfl)
+{
+	struct nfs4_lockowner *lo = (struct nfs4_lockowner *)cfl->fl_owner;
+	struct nfs4_client *clp = lo->lo_owner.so_client;
+	struct nfsd_net *nn;
+
+	if (try_to_expire_client(clp)) {
+		nn = net_generic(clp->net, nfsd_net_id);
+		mod_delayed_work(laundry_wq, &nn->laundromat_work, 0);
+		return true;
+	}
+	return false;
+}
+
+/* schedule laundromat to run immediately and wait for it to complete */
+static void
+nfsd4_lm_expire_lock(void)
+{
+	flush_workqueue(laundry_wq);
+}
+
 static void
 nfsd4_lm_notify(struct file_lock *fl)
 {
@@ -6769,9 +6804,12 @@ nfsd4_lm_notify(struct file_lock *fl)
 }
 
 static const struct lock_manager_operations nfsd_posix_mng_ops  = {
+	.lm_mod_owner = THIS_MODULE,
 	.lm_notify = nfsd4_lm_notify,
 	.lm_get_owner = nfsd4_lm_get_owner,
 	.lm_put_owner = nfsd4_lm_put_owner,
+	.lm_lock_expirable = nfsd4_lm_lock_expirable,
+	.lm_expire_lock = nfsd4_lm_expire_lock,
 };
 
 static inline void
-- 
2.43.0



