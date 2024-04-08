Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE0D7CF34;
	Mon,  8 Apr 2024 13:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583993; cv=none; b=uhhYwbWUNe0T0f5kN6FLBBi3aGSLAIJ8AxI2J2vjIiBCZ8V0DFM9TRRjanvWa+7O6zWEnwwrVuFmFFEUwM5u9CzXXyHp5TN8JQpzCqfwARDY45igAEiNEtAsJKBMersbiKqbqTD/9sK4tV2FDV/kD/Sxgba+O4zcTnP3wOfYxME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583993; c=relaxed/simple;
	bh=iQYS2IpbvwnOYTmxJDFuG86OVoylxAtVyjo+SQQHHAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyQa8n7o5hDKc0DXcVJCgBiWosdp9t7d6FosIlF+wHjL83eIbVz5ltLoucf7v+IJot0phacwnQ/lohViMgKlNNca6bI8Z8wvJ8sOvIqO3kxwYTjUyDYO3meIstnpUUztk8ObLdy94eA64W3jkS50sIyHJNyBC6LZB1aRtMcRbEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hp07uLO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hp07uLO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E26C43390;
	Mon,  8 Apr 2024 13:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583992;
	bh=iQYS2IpbvwnOYTmxJDFuG86OVoylxAtVyjo+SQQHHAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hp07uLO7zuxoPqyItrVYpNYtNun2T2OWPC4stuePq7snaBBgHW9a5oN8AchypaqyY
	 6OViiotxG+hlTCSaDDMUydWlF1rh3hVDlXCObpTRF1lYkhQDPEr7cqXBQiWYASrp6I
	 lW1pV4k/9um3xM8FQUhyPTvAz+djX10Xb49D52Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 312/690] NFSD: add support for lock conflict to courteous server
Date: Mon,  8 Apr 2024 14:52:58 +0200
Message-ID: <20240408125410.897282854@linuxfoundation.org>
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
---
 fs/nfsd/nfs4state.c | 70 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 582c9c7ba60a8..447faa4348227 100644
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
@@ -6729,6 +6741,29 @@ nfsd4_lm_put_owner(fl_owner_t owner)
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
@@ -6755,9 +6790,12 @@ nfsd4_lm_notify(struct file_lock *fl)
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



