Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831252;
	b=UeAHR/DM5ZxAq54diVgpbbljNtwegK0MHJkvSxS5hKieNh8Yl/+GsNvART/yujSdfcib
	 i0S7CsiHgCmka3ATIX8mtCog6+rQrIATbQHj824Ld5RrKISMXo142FOtepQmZP/K0Gvdk
	 nJ2InuJViQzmQDi0TA2awnOXJa4RAQgc2PVJwhTPE/avUn1Z+/664Q4442VIYSpIfJRyw
	 toAnjBPg4lbiEx+AegNqvJOAL0ypEWCNd/l12rG96xLO+N9a4mG+MDMGLRHUMy+bDxj42
	 pSNbmWuL2CjYYZ/l73lg8D9x3o5IZlBkAZtUGho6Vm9nhJTKiBH61ZtNFUgrtIY0kQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bn/59gm+3kpuRf+GRKa8FUGw5V+VtApXq8zBj8EzOhk=;
	b=Vnyfh/YerSPNJDGLoA4x7HC7lJUgdGvOIUTRclOklSzg+eaQa/LraqzjWfwSekdfSEh4
	 Uoe2a/+RjkM/EDDt/1RDzENxnxvaiPguTRzcRkr7Sh7qvMwwkEygYaINM++I6k5M03/b9
	 ixG4/cnHDxNqpn/yb2IYhtG1JCP1XNy93wlR1r7J3PAFaSuwMNoTxlB+xqcCnZzBiTdxK
	 DYuV/K4ae2clCi3anMAGmpegR+pWAe7Bttuon//qBavYNYM7MDF4al4fn/0KTn+RAO0VK
	 094PRfKPeOXwj3Qpn7P8QkbMUye8xfeY48MmyFqddhPnWAwCoKEx2AJI3+2AdB8GVZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IP5xHELR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4B5606B382;
	Wed,  4 Nov 2026 22:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IP5xHELR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0C41F00919;
	Wed,  4 Nov 2026 22:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831252;
	bh=bn/59gm+3kpuRf+GRKa8FUGw5V+VtApXq8zBj8EzOhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IP5xHELRW80cRn1/fprVR0SViEXRk1Q1W3PL6yoF2rpaYaDXyeqR7L33eMuWm0jaG
	 am4KEziuHwBrsB01Msm9bSmhI12FSljqDvQvQak/zRg6vAv1fpZAmDQ2KDZVlZMRw9
	 o2trMlUduPI9mzOkJJVSscuWdU4Zm/TAIEqVD5Qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0553/1005] nfsd: dedup nfs4_client_to_reclaim inserts
Date: Wed,  4 Nov 2026 16:04:46 -0500
Message-ID: <20261104211059.382824604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 9b57793863f69c608691c98e57c2f9be2db9dfed ]

nfs4_client_to_reclaim() unconditionally allocates a new
nfs4_client_reclaim, prepends it to reclaim_str_hashtbl[], and bumps
reclaim_str_hashtbl_size with no check for an existing entry for the
same client name.  After a reboot with a populated recovery directory
that inflates the counter by one for every client that reclaims:

    boot:    load_recdir()
               nfs4_client_to_reclaim(name)   /* entry #1, size++ */

    grace:   RECLAIM_COMPLETE
               __nfsd4_create_reclaim_record_grace()
                 nfs4_client_to_reclaim(name) /* entry #2, size++ */

inc_reclaim_complete() ends the grace period early only when

    atomic_inc_return(&nn->nr_reclaim_complete) ==
        nn->reclaim_str_hashtbl_size

With reclaim_str_hashtbl_size at 2N and nr_reclaim_complete capped at
N, the equality never holds and the fast end-of-grace path is dead.
The grace period always runs out the full 90-second laundromat timer,
and the shadow entry left in the hash table carries a dangling cr_clp
for any reader that walks it.

Fix nfs4_client_to_reclaim() to look the name up with
nfsd4_find_reclaim_client() first and, on a hit, fold the new
princhash into the existing record (if it lacks one) and return that
record without allocating or touching reclaim_str_hashtbl_size.  On
kmemdup() failure during the fold-in, return NULL so
__cld_pipe_inprogress_downcall() surfaces -EFAULT to nfsdcld, matching
the miss-path contract.

Add an rw_semaphore (reclaim_str_hashtbl_lock) to struct nfsd_net that
serialises all access to reclaim_str_hashtbl[] and
reclaim_str_hashtbl_size.  Writers (nfs4_client_to_reclaim,
nfs4_remove_reclaim_record callers) hold the write side; readers
(nfsd4_cld_check*, inc_reclaim_complete, clients_still_reclaiming,
nfs4_has_reclaimed_state, nfsd4_check_legacy_client) hold the read
side.  All call sites are in sleepable context, and none is a hot
path, so the rwsem cost is negligible.

Reported-by: Chris Mason <clm@meta.com>
Fixes: 362063a595be ("nfsd: keep a tally of RECLAIM_COMPLETE operations when using nfsdcld")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260530-nfsd-fixes-v2-4-f27e8eb4d974@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/netns.h       |  6 ++++-
 fs/nfsd/nfs4recover.c | 36 ++++++++++++++++++++-----
 fs/nfsd/nfs4state.c   | 61 ++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 89 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index b9485b24df0a5..ccb0256b9366e 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -93,6 +93,7 @@ struct nfsd_net {
 	 */
 	struct list_head *reclaim_str_hashtbl;
 	int reclaim_str_hashtbl_size;
+	struct rw_semaphore reclaim_str_hashtbl_lock;
 	struct list_head *conf_id_hashtbl;
 	struct rb_root conf_name_tree;
 	struct list_head *unconf_id_hashtbl;
@@ -105,7 +106,10 @@ struct nfsd_net {
 	 * close_lru holds (open) stateowner queue ordered by nfs4_stateowner.so_time
 	 * for last close replay.
 	 *
-	 * All of the above fields are protected by the client_mutex.
+	 * reclaim_str_hashtbl[], reclaim_str_hashtbl_size are protected by
+	 * reclaim_str_hashtbl_lock.
+	 *
+	 * All of the remaining fields are protected by the client_lock.
 	 */
 	struct list_head client_lru;
 	struct list_head close_lru;
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 37006d0776ebd..b78b41fbbd4ff 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -337,10 +337,12 @@ __nfsd4_remove_reclaim_record_grace(const char *dname, int len,
 		return;
 	}
 	name.len = len;
+	down_write(&nn->reclaim_str_hashtbl_lock);
 	crp = nfsd4_find_reclaim_client(name, nn);
-	kfree(name.data);
 	if (crp)
 		nfs4_remove_reclaim_record(crp, nn);
+	up_write(&nn->reclaim_str_hashtbl_lock);
+	kfree(name.data);
 }
 
 static void
@@ -541,6 +543,7 @@ nfs4_legacy_state_init(struct net *net)
 	for (i = 0; i < CLIENT_HASH_SIZE; i++)
 		INIT_LIST_HEAD(&nn->reclaim_str_hashtbl[i]);
 	nn->reclaim_str_hashtbl_size = 0;
+	init_rwsem(&nn->reclaim_str_hashtbl_lock);
 
 	return 0;
 }
@@ -660,13 +663,16 @@ nfsd4_check_legacy_client(struct nfs4_client *clp)
 		goto out_enoent;
 	}
 	name.len = HEXDIR_LEN;
+	down_read(&nn->reclaim_str_hashtbl_lock);
 	crp = nfsd4_find_reclaim_client(name, nn);
-	kfree(name.data);
 	if (crp) {
 		set_bit(NFSD4_CLIENT_STABLE, &clp->cl_flags);
 		crp->cr_clp = clp;
-		return 0;
 	}
+	up_read(&nn->reclaim_str_hashtbl_lock);
+	kfree(name.data);
+	if (crp)
+		return 0;
 
 out_enoent:
 	return -ENOENT;
@@ -1238,6 +1244,7 @@ nfsd4_cld_check(struct nfs4_client *clp)
 		return 0;
 
 	/* look for it in the reclaim hashtable otherwise */
+	down_read(&nn->reclaim_str_hashtbl_lock);
 	crp = nfsd4_find_reclaim_client(clp->cl_name, nn);
 	if (crp)
 		goto found;
@@ -1256,6 +1263,7 @@ nfsd4_cld_check(struct nfs4_client *clp)
 		if (!name.data) {
 			dprintk("%s: failed to allocate memory for name.data!\n",
 				__func__);
+			up_read(&nn->reclaim_str_hashtbl_lock);
 			return -ENOENT;
 		}
 		name.len = HEXDIR_LEN;
@@ -1266,9 +1274,11 @@ nfsd4_cld_check(struct nfs4_client *clp)
 
 	}
 #endif
+	up_read(&nn->reclaim_str_hashtbl_lock);
 	return -ENOENT;
 found:
 	crp->cr_clp = clp;
+	up_read(&nn->reclaim_str_hashtbl_lock);
 	return 0;
 }
 
@@ -1280,6 +1290,7 @@ nfsd4_cld_check_v2(struct nfs4_client *clp)
 	struct cld_net *cn = nn->cld_net;
 #endif
 	struct nfs4_client_reclaim *crp;
+	unsigned int princhashlen;
 	char *principal = NULL;
 
 	/* did we already find that this client is stable? */
@@ -1287,6 +1298,7 @@ nfsd4_cld_check_v2(struct nfs4_client *clp)
 		return 0;
 
 	/* look for it in the reclaim hashtable otherwise */
+	down_read(&nn->reclaim_str_hashtbl_lock);
 	crp = nfsd4_find_reclaim_client(clp->cl_name, nn);
 	if (crp)
 		goto found;
@@ -1305,6 +1317,7 @@ nfsd4_cld_check_v2(struct nfs4_client *clp)
 		if (!name.data) {
 			dprintk("%s: failed to allocate memory for name.data\n",
 					__func__);
+			up_read(&nn->reclaim_str_hashtbl_lock);
 			return -ENOENT;
 		}
 		name.len = HEXDIR_LEN;
@@ -1315,23 +1328,31 @@ nfsd4_cld_check_v2(struct nfs4_client *clp)
 
 	}
 #endif
+	up_read(&nn->reclaim_str_hashtbl_lock);
 	return -ENOENT;
 found:
-	if (crp->cr_princhash.len) {
+	princhashlen = crp->cr_princhash.len;
+	if (princhashlen) {
 		u8 digest[SHA256_DIGEST_SIZE];
+		u8 *pdata;
 
 		if (clp->cl_cred.cr_raw_principal)
 			principal = clp->cl_cred.cr_raw_principal;
 		else if (clp->cl_cred.cr_principal)
 			principal = clp->cl_cred.cr_principal;
-		if (principal == NULL)
+		if (principal == NULL) {
+			up_read(&nn->reclaim_str_hashtbl_lock);
 			return -ENOENT;
+		}
 		sha256(principal, strlen(principal), digest);
-		if (memcmp(crp->cr_princhash.data, digest,
-				crp->cr_princhash.len))
+		pdata = crp->cr_princhash.data;
+		if (memcmp(pdata, digest, princhashlen)) {
+			up_read(&nn->reclaim_str_hashtbl_lock);
 			return -ENOENT;
+		}
 	}
 	crp->cr_clp = clp;
+	up_read(&nn->reclaim_str_hashtbl_lock);
 	return 0;
 }
 
@@ -1431,6 +1452,7 @@ nfs4_cld_state_init(struct net *net)
 	for (i = 0; i < CLIENT_HASH_SIZE; i++)
 		INIT_LIST_HEAD(&nn->reclaim_str_hashtbl[i]);
 	nn->reclaim_str_hashtbl_size = 0;
+	init_rwsem(&nn->reclaim_str_hashtbl_lock);
 	set_bit(NFSD_NET_TRACK_RECLAIM_COMPLETES, &nn->flags);
 	atomic_set(&nn->nr_reclaim_complete, 0);
 
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index b3ad502d89eb3..f5671861ef7e7 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2689,14 +2689,21 @@ static void inc_reclaim_complete(struct nfs4_client *clp)
 
 	if (!test_bit(NFSD_NET_TRACK_RECLAIM_COMPLETES, &nn->flags))
 		return;
-	if (!nfsd4_find_reclaim_client(clp->cl_name, nn))
+
+	down_read(&nn->reclaim_str_hashtbl_lock);
+	if (!nfsd4_find_reclaim_client(clp->cl_name, nn)) {
+		up_read(&nn->reclaim_str_hashtbl_lock);
 		return;
+	}
 	if (atomic_inc_return(&nn->nr_reclaim_complete) ==
 			nn->reclaim_str_hashtbl_size) {
+		up_read(&nn->reclaim_str_hashtbl_lock);
 		printk(KERN_INFO "NFSD: all clients done reclaiming, ending NFSv4 grace period (net %x)\n",
 				clp->net->ns.inum);
 		nfsd4_end_grace(nn);
+		return;
 	}
+	up_read(&nn->reclaim_str_hashtbl_lock);
 }
 
 static void expire_client(struct nfs4_client *clp)
@@ -6840,10 +6847,15 @@ static bool clients_still_reclaiming(struct nfsd_net *nn)
 
 	if (test_bit(NFSD_NET_GRACE_END_FORCED, &nn->flags))
 		return false;
-	if (test_bit(NFSD_NET_TRACK_RECLAIM_COMPLETES, &nn->flags) &&
-			atomic_read(&nn->nr_reclaim_complete) ==
-			nn->reclaim_str_hashtbl_size)
-		return false;
+	if (test_bit(NFSD_NET_TRACK_RECLAIM_COMPLETES, &nn->flags)) {
+		int size;
+
+		down_read(&nn->reclaim_str_hashtbl_lock);
+		size = nn->reclaim_str_hashtbl_size;
+		up_read(&nn->reclaim_str_hashtbl_lock);
+		if (atomic_read(&nn->nr_reclaim_complete) == size)
+			return false;
+	}
 	if (!test_bit(NFSD_NET_SOMEBODY_RECLAIMED, &nn->flags))
 		return false;
 	clear_bit(NFSD_NET_SOMEBODY_RECLAIMED, &nn->flags);
@@ -9056,9 +9068,13 @@ bool
 nfs4_has_reclaimed_state(struct xdr_netobj name, struct nfsd_net *nn)
 {
 	struct nfs4_client_reclaim *crp;
+	bool found;
 
+	down_read(&nn->reclaim_str_hashtbl_lock);
 	crp = nfsd4_find_reclaim_client(name, nn);
-	return (crp && crp->cr_clp);
+	found = (crp && crp->cr_clp);
+	up_read(&nn->reclaim_str_hashtbl_lock);
+	return found;
 }
 
 /*
@@ -9071,10 +9087,39 @@ nfs4_client_to_reclaim(struct xdr_netobj name, struct xdr_netobj princhash,
 	unsigned int strhashval;
 	struct nfs4_client_reclaim *crp;
 
+	down_write(&nn->reclaim_str_hashtbl_lock);
+
+	/*
+	 * A reclaim record for this client name may already exist (for
+	 * example, populated at boot from the recovery directory before
+	 * an in-grace RECLAIM_COMPLETE or an nfsdcld downcall delivers
+	 * the same name). Dedup here so reclaim_str_hashtbl_size stays
+	 * equal to the number of distinct client names; inc_reclaim_complete
+	 * relies on that equality to end the grace period via the fast path.
+	 */
+	crp = nfsd4_find_reclaim_client(name, nn);
+	if (crp) {
+		if (princhash.len && crp->cr_princhash.len == 0) {
+			void *pdata = kmemdup(princhash.data, princhash.len,
+					      GFP_KERNEL);
+			if (pdata) {
+				crp->cr_princhash.data = pdata;
+				crp->cr_princhash.len = princhash.len;
+			} else {
+				dprintk("%s: failed to allocate memory for princhash.data!\n",
+					__func__);
+				crp = NULL;
+			}
+		}
+		up_write(&nn->reclaim_str_hashtbl_lock);
+		return crp;
+	}
+
 	name.data = kmemdup(name.data, name.len, GFP_KERNEL);
 	if (!name.data) {
 		dprintk("%s: failed to allocate memory for name.data!\n",
 			__func__);
+		up_write(&nn->reclaim_str_hashtbl_lock);
 		return NULL;
 	}
 	if (princhash.len) {
@@ -9083,6 +9128,7 @@ nfs4_client_to_reclaim(struct xdr_netobj name, struct xdr_netobj princhash,
 			dprintk("%s: failed to allocate memory for princhash.data!\n",
 				__func__);
 			kfree(name.data);
+			up_write(&nn->reclaim_str_hashtbl_lock);
 			return NULL;
 		}
 	} else
@@ -9102,6 +9148,7 @@ nfs4_client_to_reclaim(struct xdr_netobj name, struct xdr_netobj princhash,
 		kfree(name.data);
 		kfree(princhash.data);
 	}
+	up_write(&nn->reclaim_str_hashtbl_lock);
 	return crp;
 }
 
@@ -9121,6 +9168,7 @@ nfs4_release_reclaim(struct nfsd_net *nn)
 	struct nfs4_client_reclaim *crp = NULL;
 	int i;
 
+	down_write(&nn->reclaim_str_hashtbl_lock);
 	for (i = 0; i < CLIENT_HASH_SIZE; i++) {
 		while (!list_empty(&nn->reclaim_str_hashtbl[i])) {
 			crp = list_entry(nn->reclaim_str_hashtbl[i].next,
@@ -9129,6 +9177,7 @@ nfs4_release_reclaim(struct nfsd_net *nn)
 		}
 	}
 	WARN_ON_ONCE(nn->reclaim_str_hashtbl_size);
+	up_write(&nn->reclaim_str_hashtbl_lock);
 }
 
 /*
-- 
2.53.0



