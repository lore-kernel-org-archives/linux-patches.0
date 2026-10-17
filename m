Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551683B71A7;
	Sat, 17 Oct 2026 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259980; cv=none; b=Ou/FnAel2I7Z5pILLY7Sp8NzUFZiWdGnGVySFxAxKFrfRx70mBkCkBncPBsAr95dlH2wTIadMtsbGFeXxVidILSL7LBAP/cb4hfRSzK4Sp4a9UhNKHoTklTpSJiKoxD+YlVWqo0YjKCoppz/an7aeObDVmPzMhmzmSxVUaAuErQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259980; c=relaxed/simple;
	bh=owxnRr5IF9vjl4l99aDA1XmTxlxA6tN+L2X1oFbBSVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcXZEvo4SqXcQ74SVkuZ334gCSF5M0hR2pxOYh6aY5UaT/6pLVWxKuVPoVarkmEp/3Kff//z0WGZqE+Rrfda8qTxxRVWHv8/WIq+OhZRJhVzvQ1tX/8oqV3T9Nzdm8m6y0udtSfO2n5bRpf7bGtgMy4dV9xZzsC4SjB9wdGTzss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lK38DLDX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lK38DLDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E771F000C4;
	Sat, 17 Oct 2026 17:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259979;
	bh=HHy+5X8429kcamFj+0uGGPHWkO+cZY7BFmsfwMQWcQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lK38DLDXJqqydlvYHO+bsMirXXQTuKpi1GTr46TSxHhB79PgwE3Vrpy2Lo0zrqbHX
	 AK2N47yGmDR2Ozu0rc2X+kX35+GcPOgE1o2GUZ8dXhy1EnUPepn6EjaGxmwN7M9twi
	 SXRSdQ9UHk6MWKSUs5y3Sm4NQuEyueubGG3TtydM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1366/1674] NFSD: Prevent client use-after-free during blocked-lock reaping
Date: Sat, 17 Oct 2026 18:00:38 +0200
Message-ID: <20261017160506.218617053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 9026932ac8be4d0ae01db47f23619a98cc57b671 ]

A bare lock owner -- its only remaining reference a blocked lock on
nn->blocked_locks_lru -- holds a raw pointer to its nfs4_client but
no reference keeping the client alive. When the per-net laundromat
reaps such a lock, freeing the nbl drops the owner reference
held through flc_owner, and the final nfs4_put_stateowner()
takes the client's cl_lock. Because the laundromat detaches the
nbl first, __destroy_client() no longer finds it, so a concurrent
force_expire_client() can free the client before nfs4_put_stateowner()
runs, dereferencing cl_lock in freed memory.

Pin the client with cl_rpc_users before dropping
nn->blocked_locks_lock, and skip clients already expiring, whose
blocked locks __destroy_client() frees while holding an owner
reference. Take nn->client_lock outside nn->blocked_locks_lock.
Every other site holds nn->blocked_locks_lock as a leaf, acquiring
no further lock, so placing nn->client_lock outside it cannot form
a lock-order cycle.

Fixes: 7919d0a27f1e ("nfsd: add a LRU list for blocked locks")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260709-cel-v4-7-1d519d9be0cb@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 473368a78434c..2d57a042f3bf1 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -329,6 +329,16 @@ free_blocked_lock(struct nfsd4_blocked_lock *nbl)
 	kref_put(&nbl->nbl_kref, free_nbl);
 }
 
+/* A blocked lock's fl_owner is its nfs4_lockowner. */
+static struct nfs4_client *
+nbl_client(struct nfsd4_blocked_lock *nbl)
+{
+	struct nfs4_lockowner *lo;
+
+	lo = (struct nfs4_lockowner *)nbl->nbl_lock.fl_owner;
+	return lo->lo_owner.so_client;
+}
+
 static void
 remove_blocked_locks(struct nfs4_lockowner *lo)
 {
@@ -6392,22 +6402,33 @@ nfs4_laundromat(struct nfsd_net *nn)
 	 * indefinitely once the lock does become free.
 	 */
 	BUG_ON(!list_empty(&reaplist));
+	spin_lock(&nn->client_lock);
 	spin_lock(&nn->blocked_locks_lock);
-	while (!list_empty(&nn->blocked_locks_lru)) {
-		nbl = list_first_entry(&nn->blocked_locks_lru,
-					struct nfsd4_blocked_lock, nbl_lru);
+	list_for_each_safe(pos, next, &nn->blocked_locks_lru) {
+		nbl = list_entry(pos, struct nfsd4_blocked_lock, nbl_lru);
 		if (!state_expired(&lt, nbl->nbl_time))
 			break;
+		clp = nbl_client(nbl);
+		if (is_client_expired(clp))
+			continue;
+		atomic_inc(&clp->cl_rpc_users);
 		list_move(&nbl->nbl_lru, &reaplist);
 		list_del_init(&nbl->nbl_list);
 	}
 	spin_unlock(&nn->blocked_locks_lock);
+	spin_unlock(&nn->client_lock);
 
 	while (!list_empty(&reaplist)) {
 		nbl = list_first_entry(&reaplist,
 					struct nfsd4_blocked_lock, nbl_lru);
+		clp = nbl_client(nbl);
 		list_del_init(&nbl->nbl_lru);
 		free_blocked_lock(nbl);
+		if (atomic_dec_and_lock(&clp->cl_rpc_users, &nn->client_lock)) {
+			if (is_client_expired(clp))
+				wake_up_all(&expiry_wq);
+			spin_unlock(&nn->client_lock);
+		}
 	}
 #ifdef CONFIG_NFSD_V4_2_INTER_SSC
 	/* service the server-to-server copy delayed unmount list */
-- 
2.53.0



