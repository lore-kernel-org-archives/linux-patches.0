Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDFB42046;
	Mon,  8 Apr 2024 13:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584501; cv=none; b=vAIRB6uCy6VXVhjrjRJspPOmWk/+NmR7t7WAD8D4xUVQnNugJMYwdnmYWJISC5+X5C9SKeUnBJz6Jn2fzLXGjiicreyTI4tl9AlsRvBYogFLIFlLEmobkUuh3bxgYZip5EUnulxLKZsX0KNjGOlRYHp2KwAaKuiGSPWz5nLxLVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584501; c=relaxed/simple;
	bh=XcLawigW5NARb7ki/Nd/3pOkD/lilKPCz8okykQ9+EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+KZv1jkKPIrYn/KH+67XwHNTf57VvsHQ0f3MomJzOlNt956ilgyLcpxQJ7bMJNACJ4cbh2Mp5eWCp6/tOsqbmRbWsvK/s4j7g1p3lVWkrE51QGtTBiRUQdkgG6eTHRakjxDJhb7+1LoF8YzVNAM8xVjZGfZNf0nW2urarmiLI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQgZoxl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQgZoxl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F03AC433F1;
	Mon,  8 Apr 2024 13:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584501;
	bh=XcLawigW5NARb7ki/Nd/3pOkD/lilKPCz8okykQ9+EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQgZoxl1gBVOUbE5eHEZo5ULPf+C4d/R5Au1oA6Cy4CkAZrhHvglrgKMm2jzQfRYb
	 Z+WoUkTNx9hbMb+xduvu4Wmc8AY8dtQc6UJn3/8XFgHH9y9tzq2u5Bl0odCEuT4p7W
	 iX42t8FQCV0vLAethGAItVtjp5LTRXeV2CsrwwBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 460/690] nfsd: rework hashtable handling in nfsd_do_file_acquire
Date: Mon,  8 Apr 2024 14:55:26 +0200
Message-ID: <20240408125416.283064114@linuxfoundation.org>
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



