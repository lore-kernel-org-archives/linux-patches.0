Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41489157A4D;
	Tue, 18 Jun 2024 13:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715912; cv=none; b=k5nlj1HTF6FvWAhq9IPaTtQzd01x54gmJgn2dew4R37TMSxcq/efe/wwLBnEEXN1I4x/IM98KWO5ACgo4pO9kighPgBE+Ofa+GB79hCtnJ7NsHa5NPoOygyPvEy0M//6cH6HSacgVjvBOBOUP2sOO9vWhyx61hAt8IDxGjLHCSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715912; c=relaxed/simple;
	bh=8TymIPl6h31Ypoqd8tEUIcUC1OX1pwf0QM/5BCdEXWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ud+zWbpgGrZgPDWEzPQbdZEVziRxdEx/z5lVV0dHPgcGX8y89eG/tm0/AEwMNQESYKmqO4CfsuBb8Prxld1Cf8KuVauFPo4ukJnYEb6ibtZ5zHw97Uh1KOOBgMyps6quWGyiIOCTgeDDOHQHOLYR7bp1VZI7IHweofWkL17kOPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBCvLUP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBCvLUP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4CFC32786;
	Tue, 18 Jun 2024 13:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715911;
	bh=8TymIPl6h31Ypoqd8tEUIcUC1OX1pwf0QM/5BCdEXWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBCvLUP42ik1Knqr3wBzL7XRoCaEUN1bAlHa7A4Z67kussetSp27JlZmAzP+1iSQz
	 lXmnR5gQjqbBGMg0qO9FH52Rq4RVaUksDWsRsX/BrZMNMhZjyDAHKxtGbUwk/uDqFx
	 CSP4OpLE/LL9XIA1uyXFuttnAZ2aSpGkpuDT5TLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Aloni <dan.aloni@vastdata.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Bruce Fields <bfields@fieldses.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 468/770] NFSD: COMMIT operations must not return NFS?ERR_INVAL
Date: Tue, 18 Jun 2024 14:35:21 +0200
Message-ID: <20240618123425.380800541@linuxfoundation.org>
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

[ Upstream commit 3f965021c8bc38965ecb1924f570c4842b33d408 ]

Since, well, forever, the Linux NFS server's nfsd_commit() function
has returned nfserr_inval when the passed-in byte range arguments
were non-sensical.

However, according to RFC 1813 section 3.3.21, NFSv3 COMMIT requests
are permitted to return only the following non-zero status codes:

      NFS3ERR_IO
      NFS3ERR_STALE
      NFS3ERR_BADHANDLE
      NFS3ERR_SERVERFAULT

NFS3ERR_INVAL is not included in that list. Likewise, NFS4ERR_INVAL
is not listed in the COMMIT row of Table 6 in RFC 8881.

RFC 7530 does permit COMMIT to return NFS4ERR_INVAL, but does not
specify when it can or should be used.

Instead of dropping or failing a COMMIT request in a byte range that
is not supported, turn it into a valid request by treating one or
both arguments as zero. Offset zero means start-of-file, count zero
means until-end-of-file, so we only ever extend the commit range.
NFS servers are always allowed to commit more and sooner than
requested.

The range check is no longer bounded by NFS_OFFSET_MAX, but rather
by the value that is returned in the maxfilesize field of the NFSv3
FSINFO procedure or the NFSv4 maxfilesize file attribute.

Note that this change results in a new pynfs failure:

CMT4     st_commit.testCommitOverflow                             : RUNNING
CMT4     st_commit.testCommitOverflow                             : FAILURE
           COMMIT with offset + count overflow should return
           NFS4ERR_INVAL, instead got NFS4_OK

IMO the test is not correct as written: RFC 8881 does not allow the
COMMIT operation to return NFS4ERR_INVAL.

Reported-by: Dan Aloni <dan.aloni@vastdata.com>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Bruce Fields <bfields@fieldses.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c |  6 ------
 fs/nfsd/vfs.c      | 53 +++++++++++++++++++++++++++++++---------------
 fs/nfsd/vfs.h      |  4 ++--
 3 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index b540489ea240d..936eebd4c56dc 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -660,15 +660,9 @@ nfsd3_proc_commit(struct svc_rqst *rqstp)
 				argp->count,
 				(unsigned long long) argp->offset);
 
-	if (argp->offset > NFS_OFFSET_MAX) {
-		resp->status = nfserr_inval;
-		goto out;
-	}
-
 	fh_copy(&resp->fh, &argp->fh);
 	resp->status = nfsd_commit(rqstp, &resp->fh, argp->offset,
 				   argp->count, resp->verf);
-out:
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 09e4a0af6fb43..89c50ccedf4d3 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1140,42 +1140,61 @@ nfsd_write(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t offset,
 }
 
 #ifdef CONFIG_NFSD_V3
-/*
- * Commit all pending writes to stable storage.
+/**
+ * nfsd_commit - Commit pending writes to stable storage
+ * @rqstp: RPC request being processed
+ * @fhp: NFS filehandle
+ * @offset: raw offset from beginning of file
+ * @count: raw count of bytes to sync
+ * @verf: filled in with the server's current write verifier
  *
- * Note: we only guarantee that data that lies within the range specified
- * by the 'offset' and 'count' parameters will be synced.
+ * Note: we guarantee that data that lies within the range specified
+ * by the 'offset' and 'count' parameters will be synced. The server
+ * is permitted to sync data that lies outside this range at the
+ * same time.
  *
  * Unfortunately we cannot lock the file to make sure we return full WCC
  * data to the client, as locking happens lower down in the filesystem.
+ *
+ * Return values:
+ *   An nfsstat value in network byte order.
  */
 __be32
-nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp,
-               loff_t offset, unsigned long count, __be32 *verf)
+nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, u64 offset,
+	    u32 count, __be32 *verf)
 {
+	u64			maxbytes;
+	loff_t			start, end;
 	struct nfsd_net		*nn;
 	struct nfsd_file	*nf;
-	loff_t			end = LLONG_MAX;
-	__be32			err = nfserr_inval;
-
-	if (offset < 0)
-		goto out;
-	if (count != 0) {
-		end = offset + (loff_t)count - 1;
-		if (end < offset)
-			goto out;
-	}
+	__be32			err;
 
 	err = nfsd_file_acquire(rqstp, fhp,
 			NFSD_MAY_WRITE|NFSD_MAY_NOT_BREAK_LEASE, &nf);
 	if (err)
 		goto out;
+
+	/*
+	 * Convert the client-provided (offset, count) range to a
+	 * (start, end) range. If the client-provided range falls
+	 * outside the maximum file size of the underlying FS,
+	 * clamp the sync range appropriately.
+	 */
+	start = 0;
+	end = LLONG_MAX;
+	maxbytes = (u64)fhp->fh_dentry->d_sb->s_maxbytes;
+	if (offset < maxbytes) {
+		start = offset;
+		if (count && (offset + count - 1 < maxbytes))
+			end = offset + count - 1;
+	}
+
 	nn = net_generic(nf->nf_net, nfsd_net_id);
 	if (EX_ISSYNC(fhp->fh_export)) {
 		errseq_t since = READ_ONCE(nf->nf_file->f_wb_err);
 		int err2;
 
-		err2 = vfs_fsync_range(nf->nf_file, offset, end, 0);
+		err2 = vfs_fsync_range(nf->nf_file, start, end, 0);
 		switch (err2) {
 		case 0:
 			nfsd_copy_write_verifier(verf, nn);
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 9f56dcb22ff72..2c43d10e3cab4 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -74,8 +74,8 @@ __be32		do_nfsd_create(struct svc_rqst *, struct svc_fh *,
 				char *name, int len, struct iattr *attrs,
 				struct svc_fh *res, int createmode,
 				u32 *verifier, bool *truncp, bool *created);
-__be32		nfsd_commit(struct svc_rqst *, struct svc_fh *,
-				loff_t, unsigned long, __be32 *verf);
+__be32		nfsd_commit(struct svc_rqst *rqst, struct svc_fh *fhp,
+				u64 offset, u32 count, __be32 *verf);
 #endif /* CONFIG_NFSD_V3 */
 #ifdef CONFIG_NFSD_V4
 __be32		nfsd_getxattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
-- 
2.43.0



