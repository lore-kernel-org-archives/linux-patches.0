Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AF1158D95;
	Tue, 18 Jun 2024 13:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716523; cv=none; b=P7cpL4zV9VrP4MRXf+qc3u6yZQvToRsyFSQd3W78bXKoAORfcZ8cnMxE894WoerxlScF/9C7Xt6QZ6EGlQ/NEXR1tC71LMhZ8UutRbsjb7itbeBYWpXeNtp3g1xxgCjI++xAM/x7IVlRETmZwEKujI12MkX/EkJCCIs8NSdU04k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716523; c=relaxed/simple;
	bh=e19bktzmpJImcYSPeWK1U0h1g78knWIXG6vhDOhcPfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCwJnDlseXlUAnmch74uZqlZPS8pr8ivU9qbVNweD6v4lr+QjQzBVzMpnCZRrkKm9lhjLYT7P2KNmHBLlUHm9MtnZ6636pcXnL4w4xnve1+7xTLuaK3WwPj/9tjyscLmb16E534LcC0gW2AX8xse75JqHPORvg4FOxNCFx3n81o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CE2GjEbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CE2GjEbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F7DC3277B;
	Tue, 18 Jun 2024 13:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716522;
	bh=e19bktzmpJImcYSPeWK1U0h1g78knWIXG6vhDOhcPfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CE2GjEbDiAPzQ31dKvNn/yFzaG56/SClGMjsQ9uORw7zZSVbn/e5cLi7ag9RWXShd
	 PF+xucUMZWcyb7Y3AP8u4I+1e0LRHIyJKjaBNI5OHRepNqKhnoUb3Lp039DWKAKeMZ
	 jR5jaeDnoX/lNvyoXmgRVnyKGXHIm2i6yeKTSb1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 673/770] nfsd: rework hashtable handling in nfsd_do_file_acquire
Date: Tue, 18 Jun 2024 14:38:46 +0200
Message-ID: <20240618123433.259051141@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 243a5263014a30436c93ed3f1f864c1da845455e ]

nfsd_file is RCU-freed, so we need to hold the rcu_read_lock long enough
to get a reference after finding it in the hash. Take the
rcu_read_lock() and call rhashtable_lookup directly.

Switch to using rhashtable_lookup_insert_key as well, and use the usual
retry mechanism if we hit an -EEXIST. Rename the "retry" bool to
open_retry, and eliminiate the insert_err goto target.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 52 +++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 30 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index a0d93e797cdce..0b19eb015c6c8 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1041,9 +1041,10 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		.need	= may_flags & NFSD_FILE_MAY_MASK,
 		.net	= SVC_NET(rqstp),
 	};
-	struct nfsd_file *nf, *new;
-	bool retry = true;
+	bool open_retry = true;
+	struct nfsd_file *nf;
 	__be32 status;
+	int ret;
 
 	status = fh_verify(rqstp, fhp, S_IFREG,
 				may_flags|NFSD_MAY_OWNER_OVERRIDE);
@@ -1053,35 +1054,33 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	key.cred = get_current_cred();
 
 retry:
-	/* Avoid allocation if the item is already in cache */
-	nf = rhashtable_lookup_fast(&nfsd_file_rhash_tbl, &key,
-				    nfsd_file_rhash_params);
+	rcu_read_lock();
+	nf = rhashtable_lookup(&nfsd_file_rhash_tbl, &key,
+			       nfsd_file_rhash_params);
 	if (nf)
 		nf = nfsd_file_get(nf);
+	rcu_read_unlock();
 	if (nf)
 		goto wait_for_construction;
 
-	new = nfsd_file_alloc(&key, may_flags);
-	if (!new) {
+	nf = nfsd_file_alloc(&key, may_flags);
+	if (!nf) {
 		status = nfserr_jukebox;
 		goto out_status;
 	}
 
-	nf = rhashtable_lookup_get_insert_key(&nfsd_file_rhash_tbl,
-					      &key, &new->nf_rhash,
-					      nfsd_file_rhash_params);
-	if (!nf) {
-		nf = new;
-		goto open_file;
-	}
-	if (IS_ERR(nf))
-		goto insert_err;
-	nf = nfsd_file_get(nf);
-	if (nf == NULL) {
-		nf = new;
+	ret = rhashtable_lookup_insert_key(&nfsd_file_rhash_tbl,
+					   &key, &nf->nf_rhash,
+					   nfsd_file_rhash_params);
+	if (likely(ret == 0))
 		goto open_file;
-	}
-	nfsd_file_slab_free(&new->nf_rcu);
+
+	nfsd_file_slab_free(&nf->nf_rcu);
+	if (ret == -EEXIST)
+		goto retry;
+	trace_nfsd_file_insert_err(rqstp, key.inode, may_flags, ret);
+	status = nfserr_jukebox;
+	goto out_status;
 
 wait_for_construction:
 	wait_on_bit(&nf->nf_flags, NFSD_FILE_PENDING, TASK_UNINTERRUPTIBLE);
@@ -1089,11 +1088,11 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	/* Did construction of this file fail? */
 	if (!test_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
 		trace_nfsd_file_cons_err(rqstp, key.inode, may_flags, nf);
-		if (!retry) {
+		if (!open_retry) {
 			status = nfserr_jukebox;
 			goto out;
 		}
-		retry = false;
+		open_retry = false;
 		nfsd_file_put_noref(nf);
 		goto retry;
 	}
@@ -1141,13 +1140,6 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	smp_mb__after_atomic();
 	wake_up_bit(&nf->nf_flags, NFSD_FILE_PENDING);
 	goto out;
-
-insert_err:
-	nfsd_file_slab_free(&new->nf_rcu);
-	trace_nfsd_file_insert_err(rqstp, key.inode, may_flags, PTR_ERR(nf));
-	nf = NULL;
-	status = nfserr_jukebox;
-	goto out_status;
 }
 
 /**
-- 
2.43.0



