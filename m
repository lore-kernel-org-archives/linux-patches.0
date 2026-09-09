Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86371566C78;
	Wed,  9 Sep 2026 14:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964764; cv=none; b=pLaT2BwVVOmdhk+rxmuFBD3P66FkQj4I8Q0GJkjqVYJ/xKzxDTYYnijtNy0o/WHV03azWlKxkC46u4fvMt9zIU0J5ql1nfDldDJxUcb3G6oq5lsRVBs0UUZ39OLF0gHc2eRrSYoH1IrUagoyJG89/qtO1my88CbKqgO7OO4Czok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964764; c=relaxed/simple;
	bh=JVE5gZf8Yc/Oc8K5D2ogwvRw8f6kNzTetpKLhvYsLxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqhW9y1X+8b4saQIJsVHj4L2YmnQfBpJM9nszV1JE0sljAmO34KyomQFuUE627bPPTL6kIOwa2ZfZ4gUnTKPOm9rAT39Zbr/LXxHHeW7Jb+gVyUvgjTJcXzzBnfxMpOytjIEG0pTdM0zLu+irZvi4YuNgH8nTbABB4PYhkF1jXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFuoYBD2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFuoYBD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA631F00A3D;
	Wed,  9 Sep 2026 14:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964763;
	bh=emQ8CVNDw+32nFjB4xSeC6b4Bo/jddCc3FuvO64L2o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFuoYBD2rwEkiPVWyjY0YTcUX/dfZ6Z7nXJASXxfrZEsD5uEDgMQ1LbndALfcMpsI
	 s729shKgbgFEA3kKPqQB3H7O1PfG2+/vpTgjtr1HtgZQB8Ueu5Rmxl10KQXinNhiie
	 HrV1HZwtxrMdyaIvO02qsJ6Z7Nnp65GXTVG8K258=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 535/583] nfsd: convert global state_lock to per-net deleg_lock
Date: Wed,  9 Sep 2026 15:43:40 +0200
Message-ID: <20260909134256.319309131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 8be12e0cf21110f1e0b7fd21711ff13fb75bee72 ]

Replace the global state_lock spinlock with a per-nfsd_net deleg_lock.
The state_lock was only used to protect delegation lifecycle operations
(the del_recall_lru list and delegation hash/unhash), all of which are
scoped to a single network namespace. Making the lock per-net removes
a source of unnecessary contention between containers.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 4683ca76b3b7 ("NFSD: Prevent client use-after-free during delegation revoke")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/netns.h     |    3 ++
 fs/nfsd/nfs4state.c |   53 ++++++++++++++++++++++++++--------------------------
 fs/nfsd/state.h     |    2 -
 3 files changed, 31 insertions(+), 27 deletions(-)

--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -101,6 +101,9 @@ struct nfsd_net {
 	 */
 	struct list_head client_lru;
 	struct list_head close_lru;
+
+	/* protects del_recall_lru and delegation hash/unhash */
+	spinlock_t deleg_lock ____cacheline_aligned;
 	struct list_head del_recall_lru;
 
 	/* protected by blocked_locks_lock */
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -91,13 +91,6 @@ static void deleg_reaper(struct nfsd_net
 
 /* Locking: */
 
-/*
- * Currently used for the del_recall_lru and file hash table.  In an
- * effort to decrease the scope of the client_mutex, this spinlock may
- * eventually cover more:
- */
-static DEFINE_SPINLOCK(state_lock);
-
 enum nfsd4_st_mutex_lock_subclass {
 	OPEN_STATEID_MUTEX = 0,
 	LOCK_STATEID_MUTEX = 1,
@@ -1350,8 +1343,9 @@ nfs4_delegation_exists(struct nfs4_clien
 {
 	struct nfs4_delegation *searchdp = NULL;
 	struct nfs4_client *searchclp = NULL;
+	struct nfsd_net *nn = net_generic(clp->net, nfsd_net_id);
 
-	lockdep_assert_held(&state_lock);
+	lockdep_assert_held(&nn->deleg_lock);
 	lockdep_assert_held(&fp->fi_lock);
 
 	list_for_each_entry(searchdp, &fp->fi_delegations, dl_perfile) {
@@ -1380,8 +1374,9 @@ static int
 hash_delegation_locked(struct nfs4_delegation *dp, struct nfs4_file *fp)
 {
 	struct nfs4_client *clp = dp->dl_stid.sc_client;
+	struct nfsd_net *nn = net_generic(clp->net, nfsd_net_id);
 
-	lockdep_assert_held(&state_lock);
+	lockdep_assert_held(&nn->deleg_lock);
 	lockdep_assert_held(&fp->fi_lock);
 	lockdep_assert_held(&clp->cl_lock);
 
@@ -1403,8 +1398,10 @@ static bool
 unhash_delegation_locked(struct nfs4_delegation *dp, unsigned short statusmask)
 {
 	struct nfs4_file *fp = dp->dl_stid.sc_file;
+	struct nfsd_net *nn = net_generic(dp->dl_stid.sc_client->net,
+					  nfsd_net_id);
 
-	lockdep_assert_held(&state_lock);
+	lockdep_assert_held(&nn->deleg_lock);
 
 	if (!delegation_hashed(dp))
 		return false;
@@ -1429,10 +1426,12 @@ unhash_delegation_locked(struct nfs4_del
 static void destroy_delegation(struct nfs4_delegation *dp)
 {
 	bool unhashed;
+	struct nfsd_net *nn = net_generic(dp->dl_stid.sc_client->net,
+					  nfsd_net_id);
 
-	spin_lock(&state_lock);
+	spin_lock(&nn->deleg_lock);
 	unhashed = unhash_delegation_locked(dp, SC_STATUS_CLOSED);
-	spin_unlock(&state_lock);
+	spin_unlock(&nn->deleg_lock);
 	if (unhashed)
 		destroy_unhashed_deleg(dp);
 }
@@ -1900,11 +1899,11 @@ void nfsd4_revoke_states(struct nfsd_net
 					 */
 					refcount_inc(&stid->sc_count);
 					dp = delegstateid(stid);
-					spin_lock(&state_lock);
+					spin_lock(&nn->deleg_lock);
 					if (!unhash_delegation_locked(
 						    dp, SC_STATUS_ADMIN_REVOKED))
 						dp = NULL;
-					spin_unlock(&state_lock);
+					spin_unlock(&nn->deleg_lock);
 					if (dp)
 						revoke_delegation(dp);
 					else
@@ -2570,13 +2569,13 @@ __destroy_client(struct nfs4_client *clp
 	struct nfs4_delegation *dp;
 	LIST_HEAD(reaplist);
 
-	spin_lock(&state_lock);
+	spin_lock(&nn->deleg_lock);
 	while (!list_empty(&clp->cl_delegations)) {
 		dp = list_entry(clp->cl_delegations.next, struct nfs4_delegation, dl_perclnt);
 		unhash_delegation_locked(dp, SC_STATUS_CLOSED);
 		list_add(&dp->dl_recall_lru, &reaplist);
 	}
-	spin_unlock(&state_lock);
+	spin_unlock(&nn->deleg_lock);
 	while (!list_empty(&reaplist)) {
 		dp = list_entry(reaplist.next, struct nfs4_delegation, dl_recall_lru);
 		list_del_init(&dp->dl_recall_lru);
@@ -5540,12 +5539,12 @@ static void nfsd4_cb_recall_prepare(stru
 	 * If the dl_time != 0, then we know that it has already been
 	 * queued for a lease break. Don't queue it again.
 	 */
-	spin_lock(&state_lock);
+	spin_lock(&nn->deleg_lock);
 	if (delegation_hashed(dp) && dp->dl_time == 0) {
 		dp->dl_time = ktime_get_boottime_seconds();
 		list_add_tail(&dp->dl_recall_lru, &nn->del_recall_lru);
 	}
-	spin_unlock(&state_lock);
+	spin_unlock(&nn->deleg_lock);
 }
 
 static int nfsd4_cb_recall_done(struct nfsd4_callback *cb,
@@ -6159,6 +6158,7 @@ nfs4_set_delegation(struct nfsd4_open *o
 {
 	bool deleg_ts = nfsd4_want_deleg_timestamps(open);
 	struct nfs4_client *clp = stp->st_stid.sc_client;
+	struct nfsd_net *nn = net_generic(clp->net, nfsd_net_id);
 	struct nfs4_file *fp = stp->st_stid.sc_file;
 	struct nfs4_clnt_odstate *odstate = stp->st_clnt_odstate;
 	struct nfs4_delegation *dp;
@@ -6218,7 +6218,7 @@ nfs4_set_delegation(struct nfsd4_open *o
 		return ERR_PTR(-EOPNOTSUPP);
 	}
 
-	spin_lock(&state_lock);
+	spin_lock(&nn->deleg_lock);
 	spin_lock(&fp->fi_lock);
 	if (nfs4_delegation_exists(clp, fp))
 		status = -EAGAIN;
@@ -6233,7 +6233,7 @@ nfs4_set_delegation(struct nfsd4_open *o
 	} else
 		fp->fi_delegees++;
 	spin_unlock(&fp->fi_lock);
-	spin_unlock(&state_lock);
+	spin_unlock(&nn->deleg_lock);
 	if (nf)
 		nfsd_file_put(nf);
 	if (status)
@@ -6277,13 +6277,13 @@ nfs4_set_delegation(struct nfsd4_open *o
 	if (fp->fi_had_conflict)
 		goto out_unlock;
 
-	spin_lock(&state_lock);
+	spin_lock(&nn->deleg_lock);
 	spin_lock(&clp->cl_lock);
 	spin_lock(&fp->fi_lock);
 	status = hash_delegation_locked(dp, fp);
 	spin_unlock(&fp->fi_lock);
 	spin_unlock(&clp->cl_lock);
-	spin_unlock(&state_lock);
+	spin_unlock(&nn->deleg_lock);
 
 	if (status)
 		goto out_unlock;
@@ -7075,7 +7075,7 @@ nfs4_laundromat(struct nfsd_net *nn)
 
 	nfs40_clean_admin_revoked(nn, &lt);
 
-	spin_lock(&state_lock);
+	spin_lock(&nn->deleg_lock);
 	list_for_each_safe(pos, next, &nn->del_recall_lru) {
 		dp = list_entry (pos, struct nfs4_delegation, dl_recall_lru);
 		if (!state_expired(&lt, dp->dl_time))
@@ -7084,7 +7084,7 @@ nfs4_laundromat(struct nfsd_net *nn)
 		unhash_delegation_locked(dp, SC_STATUS_REVOKED);
 		list_add(&dp->dl_recall_lru, &reaplist);
 	}
-	spin_unlock(&state_lock);
+	spin_unlock(&nn->deleg_lock);
 	while (!list_empty(&reaplist)) {
 		dp = list_first_entry(&reaplist, struct nfs4_delegation,
 					dl_recall_lru);
@@ -9129,6 +9129,7 @@ static int nfs4_state_create_net(struct
 	INIT_LIST_HEAD(&nn->client_lru);
 	INIT_LIST_HEAD(&nn->close_lru);
 	INIT_LIST_HEAD(&nn->del_recall_lru);
+	spin_lock_init(&nn->deleg_lock);
 	spin_lock_init(&nn->client_lock);
 	spin_lock_init(&nn->s2s_cp_lock);
 	idr_init(&nn->s2s_cp_stateids);
@@ -9263,13 +9264,13 @@ nfs4_state_shutdown_net(struct net *net)
 	locks_end_grace(&nn->nfsd4_manager);
 
 	INIT_LIST_HEAD(&reaplist);
-	spin_lock(&state_lock);
+	spin_lock(&nn->deleg_lock);
 	list_for_each_safe(pos, next, &nn->del_recall_lru) {
 		dp = list_entry (pos, struct nfs4_delegation, dl_recall_lru);
 		unhash_delegation_locked(dp, SC_STATUS_CLOSED);
 		list_add(&dp->dl_recall_lru, &reaplist);
 	}
-	spin_unlock(&state_lock);
+	spin_unlock(&nn->deleg_lock);
 	list_for_each_safe(pos, next, &reaplist) {
 		dp = list_entry (pos, struct nfs4_delegation, dl_recall_lru);
 		list_del_init(&dp->dl_recall_lru);
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -123,7 +123,7 @@ struct nfs4_stid {
 #define SC_TYPE_LAYOUT		BIT(3)
 	unsigned short		sc_type;
 
-/* state_lock protects sc_status for delegation stateids.
+/* nn->deleg_lock protects sc_status for delegation stateids.
  * ->cl_lock protects sc_status for open and lock stateids.
  * ->st_mutex also protect sc_status for open stateids.
  * ->ls_lock protects sc_status for layout stateids.


