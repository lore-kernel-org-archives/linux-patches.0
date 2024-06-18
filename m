Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440D715E5A5;
	Tue, 18 Jun 2024 12:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714855; cv=none; b=sdfdPZXK8GOn9HiIgiYHevNvw4JrhtuMOi5ChvuqF39/ca4cpjgTOmCPBUiERG2s4EpJ2Kqh7usz6eJuBtV7bNgz4dMhoV+hPbooM8EmX5GH8W0LitT2FWdZtS18XW6Jw/OhGBDyD/RCrTighXdx3Xq8krubF4ppbvjbPrLxtg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714855; c=relaxed/simple;
	bh=3MrnSUfnChRNsVyPGBslRA+fpNjvpO39Akwy5TvXl+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmedEIWnLTjmEJcID3ew6+O4J760KEuc+5ZmdFqaxxcdcoIBosdwPvGVrVTWOlwt4+HRZKBZlWw82XGdpS7pdvlxP7qrNn1W9FY1pj9TfGgsX1TCcAUn55R2L09+lUDLdgC4orjcl6Ou0KZ+aO+JzxNpWLW/6oP+kq6JMvIHsY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trFQmoLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trFQmoLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF629C3277B;
	Tue, 18 Jun 2024 12:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714855;
	bh=3MrnSUfnChRNsVyPGBslRA+fpNjvpO39Akwy5TvXl+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trFQmoLlyIj+aeOfiY6SUxfS/Xd6mqWg9iGk3UYrpA2F1aMl1jN9AbbG1THCFG40S
	 d9S12zrTpS4qdToFNMiFJsiDfoxu83VBdarsaqH/l3tVfDkRqge1iahZaXawl1unVY
	 t73xnYK5UF1Y+Ujo0Tiucneysmx8pdb+txOuZMDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/770] nfsd: Set PF_LOCAL_THROTTLE on local filesystems only
Date: Tue, 18 Jun 2024 14:29:17 +0200
Message-ID: <20240618123411.289851573@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 01cbf3853959feec40ec9b9a399e12a021cd4d81 ]

Don't set PF_LOCAL_THROTTLE on remote filesystems like NFS, since they
aren't expected to ever be subject to double buffering.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/export.c          |  3 ++-
 fs/nfsd/vfs.c            | 13 +++++++++++--
 include/linux/exportfs.h |  1 +
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index 5428713af5fee..48b879cfe6e3b 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -171,5 +171,6 @@ const struct export_operations nfs_export_ops = {
 	.encode_fh = nfs_encode_fh,
 	.fh_to_dentry = nfs_fh_to_dentry,
 	.get_parent = nfs_get_parent,
-	.flags = EXPORT_OP_NOWCC|EXPORT_OP_NOSUBTREECHK|EXPORT_OP_CLOSE_BEFORE_UNLINK,
+	.flags = EXPORT_OP_NOWCC|EXPORT_OP_NOSUBTREECHK|
+		EXPORT_OP_CLOSE_BEFORE_UNLINK|EXPORT_OP_REMOTE_FS,
 };
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index fb4e6c57ce0bb..a515cbd0a7d8f 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -986,6 +986,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 				__be32 *verf)
 {
 	struct file		*file = nf->nf_file;
+	struct super_block	*sb = file_inode(file)->i_sb;
 	struct svc_export	*exp;
 	struct iov_iter		iter;
 	errseq_t		since;
@@ -993,12 +994,18 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	int			host_err;
 	int			use_wgather;
 	loff_t			pos = offset;
+	unsigned long		exp_op_flags = 0;
 	unsigned int		pflags = current->flags;
 	rwf_t			flags = 0;
+	bool			restore_flags = false;
 
 	trace_nfsd_write_opened(rqstp, fhp, offset, *cnt);
 
-	if (test_bit(RQ_LOCAL, &rqstp->rq_flags))
+	if (sb->s_export_op)
+		exp_op_flags = sb->s_export_op->flags;
+
+	if (test_bit(RQ_LOCAL, &rqstp->rq_flags) &&
+	    !(exp_op_flags & EXPORT_OP_REMOTE_FS)) {
 		/*
 		 * We want throttling in balance_dirty_pages()
 		 * and shrink_inactive_list() to only consider
@@ -1007,6 +1014,8 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 		 * the client's dirty pages or its congested queue.
 		 */
 		current->flags |= PF_LOCAL_THROTTLE;
+		restore_flags = true;
+	}
 
 	exp = fhp->fh_export;
 	use_wgather = (rqstp->rq_vers == 2) && EX_WGATHER(exp);
@@ -1062,7 +1071,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 		trace_nfsd_write_err(rqstp, fhp, offset, host_err);
 		nfserr = nfserrno(host_err);
 	}
-	if (test_bit(RQ_LOCAL, &rqstp->rq_flags))
+	if (restore_flags)
 		current_restore_flags(pflags, PF_LOCAL_THROTTLE);
 	return nfserr;
 }
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 846df3c96730f..d93e8a6737bb0 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -216,6 +216,7 @@ struct export_operations {
 #define	EXPORT_OP_NOWCC			(0x1) /* don't collect v3 wcc data */
 #define	EXPORT_OP_NOSUBTREECHK		(0x2) /* no subtree checking */
 #define	EXPORT_OP_CLOSE_BEFORE_UNLINK	(0x4) /* close files before unlink */
+#define EXPORT_OP_REMOTE_FS		(0x8) /* Filesystem is remote */
 	unsigned long	flags;
 };
 
-- 
2.43.0



