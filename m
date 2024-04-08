Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BDA6EB72;
	Mon,  8 Apr 2024 13:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584553; cv=none; b=ZOHDtOP8XgSnn93tLaxvhNMaxoyECpFu7tnxlGWmZLprq5ldPzfljdAF7mp4i27tQmVl+eXqHVQsLz7EMoSunHPG/IMxHWx23rEHCyd12XYJDNwej+QNswzLTFwsnO9grX3LlCYIiDVp4BnqejK7jJY/B9ESIbO7CdG5ATkw7pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584553; c=relaxed/simple;
	bh=Fy9WWaeHMKyBLlF63fhlrI7FdEXEqkU5FekW9pIK4+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1GDFQr/Nou3mSKXmqIJHOYx/feV/gvVwPwcM22USPeVBEKl8TeXxKnkVW2i0RhWY7gyFoCd7yvzH/VU5Wo1eI7jNAb7h2AyPg47Sv4dxrWRvHHrnCqfB/xAou8gcv66Silbq1mN1YmmqUwZsNnfc3riopiX/nWpkYI8aldHmqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLKqeEb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLKqeEb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC72C433C7;
	Mon,  8 Apr 2024 13:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584553;
	bh=Fy9WWaeHMKyBLlF63fhlrI7FdEXEqkU5FekW9pIK4+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLKqeEb+50qkzqWVSQutGf3HeNyhZUv9mGBhyE46Btqq8BpO8+JHuV93Ptdw93sKm
	 LvIYKR7+VAkU4Dbp/KZJcXEQopG9Y7U9ZxYlfG7TnLI1eR0W9SXUjiQPxqSSJCR+cN
	 KnF5G76Pf71temxMgrS4S6fYVGvn4fyBf9Rt54A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>
Subject: [PATCH 5.15 477/690] NFSD: Pass the target nfsd_file to nfsd_commit()
Date: Mon,  8 Apr 2024 14:55:43 +0200
Message-ID: <20240408125416.896296280@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c252849082ff525af18b4f253b3c9ece94e951ed ]

In a moment I'm going to introduce separate nfsd_file types, one of
which is garbage-collected; the other, not. The garbage-collected
variety is to be used by NFSv2 and v3, and the non-garbage-collected
variety is to be used by NFSv4.

nfsd_commit() is invoked by both NFSv3 and NFSv4 consumers. We want
nfsd_commit() to find and use the correct variety of cached
nfsd_file object for the NFS version that is in use.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs3proc.c | 10 +++++++++-
 fs/nfsd/nfs4proc.c | 11 ++++++++++-
 fs/nfsd/vfs.c      | 15 ++++-----------
 fs/nfsd/vfs.h      |  3 ++-
 4 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 923d9a80df92c..ff29205463332 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -13,6 +13,7 @@
 #include "cache.h"
 #include "xdr3.h"
 #include "vfs.h"
+#include "filecache.h"
 
 #define NFSDDBG_FACILITY		NFSDDBG_PROC
 
@@ -763,6 +764,7 @@ nfsd3_proc_commit(struct svc_rqst *rqstp)
 {
 	struct nfsd3_commitargs *argp = rqstp->rq_argp;
 	struct nfsd3_commitres *resp = rqstp->rq_resp;
+	struct nfsd_file *nf;
 
 	dprintk("nfsd: COMMIT(3)   %s %u@%Lu\n",
 				SVCFH_fmt(&argp->fh),
@@ -770,8 +772,14 @@ nfsd3_proc_commit(struct svc_rqst *rqstp)
 				(unsigned long long) argp->offset);
 
 	fh_copy(&resp->fh, &argp->fh);
-	resp->status = nfsd_commit(rqstp, &resp->fh, argp->offset,
+	resp->status = nfsd_file_acquire(rqstp, &resp->fh, NFSD_MAY_WRITE |
+					 NFSD_MAY_NOT_BREAK_LEASE, &nf);
+	if (resp->status)
+		goto out;
+	resp->status = nfsd_commit(rqstp, &resp->fh, nf, argp->offset,
 				   argp->count, resp->verf);
+	nfsd_file_put(nf);
+out:
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 2e8f8b9fa3aeb..6ed0baa119433 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -731,10 +731,19 @@ nfsd4_commit(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	     union nfsd4_op_u *u)
 {
 	struct nfsd4_commit *commit = &u->commit;
+	struct nfsd_file *nf;
+	__be32 status;
 
-	return nfsd_commit(rqstp, &cstate->current_fh, commit->co_offset,
+	status = nfsd_file_acquire(rqstp, &cstate->current_fh, NFSD_MAY_WRITE |
+				   NFSD_MAY_NOT_BREAK_LEASE, &nf);
+	if (status != nfs_ok)
+		return status;
+
+	status = nfsd_commit(rqstp, &cstate->current_fh, nf, commit->co_offset,
 			     commit->co_count,
 			     (__be32 *)commit->co_verf.data);
+	nfsd_file_put(nf);
+	return status;
 }
 
 static __be32
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 70a967789a611..3c43a51e17865 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1197,6 +1197,7 @@ nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
  * nfsd_commit - Commit pending writes to stable storage
  * @rqstp: RPC request being processed
  * @fhp: NFS filehandle
+ * @nf: target file
  * @offset: raw offset from beginning of file
  * @count: raw count of bytes to sync
  * @verf: filled in with the server's current write verifier
@@ -1213,19 +1214,13 @@ nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
  *   An nfsstat value in network byte order.
  */
 __be32
-nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, u64 offset,
-	    u32 count, __be32 *verf)
+nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
+	    u64 offset, u32 count, __be32 *verf)
 {
+	__be32			err = nfs_ok;
 	u64			maxbytes;
 	loff_t			start, end;
 	struct nfsd_net		*nn;
-	struct nfsd_file	*nf;
-	__be32			err;
-
-	err = nfsd_file_acquire(rqstp, fhp,
-			NFSD_MAY_WRITE|NFSD_MAY_NOT_BREAK_LEASE, &nf);
-	if (err)
-		goto out;
 
 	/*
 	 * Convert the client-provided (offset, count) range to a
@@ -1266,8 +1261,6 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, u64 offset,
 	} else
 		nfsd_copy_write_verifier(verf, nn);
 
-	nfsd_file_put(nf);
-out:
 	return err;
 }
 
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 8ddd687f83599..dbdfef7ae85bb 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -89,7 +89,8 @@ __be32		nfsd_access(struct svc_rqst *, struct svc_fh *, u32 *, u32 *);
 __be32		nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 				struct svc_fh *resfhp, struct nfsd_attrs *iap);
 __be32		nfsd_commit(struct svc_rqst *rqst, struct svc_fh *fhp,
-				u64 offset, u32 count, __be32 *verf);
+				struct nfsd_file *nf, u64 offset, u32 count,
+				__be32 *verf);
 #ifdef CONFIG_NFSD_V4
 __be32		nfsd_getxattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			    char *name, void **bufp, int *lenp);
-- 
2.43.0



