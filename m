Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2701C15A4AE;
	Tue, 18 Jun 2024 13:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716664; cv=none; b=Hz5KtbWivs2Fuq+mDqqXJhB3nIQlmmIIE/uhEoGexIe6Cgpux+1YQbuK55Upyt20/gWDtjz8KJ/pB3A1aWp1IBO8XdMcm0keQGjvKdjzTYLi+1r29M+tpjB8dxtLuyhufhqGjKuG4s8REpQnifXeqBR99myyZI1MOnGvFFaKBb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716664; c=relaxed/simple;
	bh=espDufNMALynVAals2E46iUf8ePZ/Gb/bhafchwb5Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNdakh90CjWcnAmOSxVzgGb8igHTyQbMtnPFdWN1JtNk28K5/e330RzM9AwNSkp5DSctrIkBGipeBfjUCAFVfgj9A2swvNBJ+dK+PYqNO22/hnldbZlLEPqrwdbdiJje/GRxionzxuCDYmGkKm+aCOeJ+PeTTa7xdI9fT/2W2nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iA7GKB53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iA7GKB53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D7AC3277B;
	Tue, 18 Jun 2024 13:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716664;
	bh=espDufNMALynVAals2E46iUf8ePZ/Gb/bhafchwb5Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iA7GKB538EZiYSTe/+c+uEdA9N3H1uQG899lJAShsHwPnjKpVoRoKR3mrBbsT9ILc
	 GMP+kTWS1gVw9760wu47L67FVIfdvq4eW+OtaU6ESyiwEjbo+fUbduiAN5s5YSOFGK
	 JG4ay+JsTUem0OGm20HeOT2pzbUg8rusAygonIEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 690/770] NFSD: Pass the target nfsd_file to nfsd_commit()
Date: Tue, 18 Jun 2024 14:39:03 +0200
Message-ID: <20240618123433.912184855@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 10 +++++++++-
 fs/nfsd/nfs4proc.c | 11 ++++++++++-
 fs/nfsd/vfs.c      | 15 ++++-----------
 fs/nfsd/vfs.h      |  3 ++-
 4 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index a9bf455aee821..a3a55b2be4f67 100644
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
index 50fd4ba04a3e0..3fe1966ed7358 100644
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
index 9bda56fe303cf..3278dddd11ba9 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1213,6 +1213,7 @@ nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
  * nfsd_commit - Commit pending writes to stable storage
  * @rqstp: RPC request being processed
  * @fhp: NFS filehandle
+ * @nf: target file
  * @offset: raw offset from beginning of file
  * @count: raw count of bytes to sync
  * @verf: filled in with the server's current write verifier
@@ -1229,19 +1230,13 @@ nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
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
@@ -1282,8 +1277,6 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, u64 offset,
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



