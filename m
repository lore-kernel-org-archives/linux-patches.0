Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEAD15B112;
	Tue, 18 Jun 2024 12:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715112; cv=none; b=h6638BLANjRDVezirL/X7EQ1WXbZG6wZlNDhnlUDwRxWBNfZUpNdXxcV3YVBN/IJP0+rCRAZ07sDQkbHEkQLdvV7ZEeCDUCp5VDTxR9dianTANTJqYh+OCkokXlKMYH4eur44X9Nrpt6PMZBZ31guFNxikLQ+FTu4n4oGzvrG3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715112; c=relaxed/simple;
	bh=X3SClgCAYwcv0Nu9PMg74/r89N6gqZaUhnU8Eq5UtJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrpJEc/nnw7jqb5FO8ChiMq0zT2pChI68ljY7jEtRXRS2z2zxG7F8WLpwsKp8IYEI5ydb1TmZKApg+ki3th99hWwhD30L90W9hps4/vBfB2KUe/4lIhPIEYLDz8QNi9FO5te9UmOD/BpnuA8j+vpRpe1DbjczQ9LR06fuCYSdhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gx5uX0EN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gx5uX0EN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F92BC3277B;
	Tue, 18 Jun 2024 12:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715111;
	bh=X3SClgCAYwcv0Nu9PMg74/r89N6gqZaUhnU8Eq5UtJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gx5uX0ENh2ZzKTc12C9IIIYbbaLL8jWK1HSMeUeuXHaU17x/6CfeOIZkhpfSV8C7I
	 J3YFx21iCuPH1/uNGstUnYNwtvDtImLjkaT/v9JeMZ0KYX8gljpYRAc8nDLYPwjgoa
	 mtl1U1rKp7HSjnhM3bsl3DoYaaxUumu4kJz8tU/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/770] NFSD: Update the GETATTR3res encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:51 +0200
Message-ID: <20240618123414.919814195@linuxfoundation.org>
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

[ Upstream commit 2c42f804d30f6a8d86665eca84071b316821ea08 ]

As an additional clean up, some renaming is done to more closely
reflect the data type and variable names used in the NFSv3 XDR
definition provided in RFC 1813. "attrstat" is an NFSv2 thingie.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c |  2 +-
 fs/nfsd/nfs3xdr.c  | 95 ++++++++++++++++++++++++++++++++++++++++++----
 fs/nfsd/nfsfh.c    |  2 +-
 fs/nfsd/nfsfh.h    |  2 +-
 fs/nfsd/xdr3.h     |  2 +-
 5 files changed, 91 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 25f31a03c4f1b..1c3cf97ed95d2 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -741,7 +741,7 @@ static const struct svc_procedure nfsd_procedures3[22] = {
 	[NFS3PROC_GETATTR] = {
 		.pc_func = nfsd3_proc_getattr,
 		.pc_decode = nfs3svc_decode_fhandleargs,
-		.pc_encode = nfs3svc_encode_attrstatres,
+		.pc_encode = nfs3svc_encode_getattrres,
 		.pc_release = nfs3svc_release_fhandle,
 		.pc_argsize = sizeof(struct nfsd_fhandle),
 		.pc_ressize = sizeof(struct nfsd3_attrstatres),
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 9d9a01ce0b270..75739861d235e 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -20,7 +20,7 @@
 /*
  * Mapping of S_IF* types to NFS file types
  */
-static u32	nfs3_ftypes[] = {
+static const u32 nfs3_ftypes[] = {
 	NF3NON,  NF3FIFO, NF3CHR, NF3BAD,
 	NF3DIR,  NF3BAD,  NF3BLK, NF3BAD,
 	NF3REG,  NF3BAD,  NF3LNK, NF3BAD,
@@ -39,6 +39,15 @@ encode_time3(__be32 *p, struct timespec64 *time)
 	return p;
 }
 
+static __be32 *
+encode_nfstime3(__be32 *p, const struct timespec64 *time)
+{
+	*p++ = cpu_to_be32((u32)time->tv_sec);
+	*p++ = cpu_to_be32(time->tv_nsec);
+
+	return p;
+}
+
 static bool
 svcxdr_decode_nfstime3(struct xdr_stream *xdr, struct timespec64 *timep)
 {
@@ -82,6 +91,19 @@ svcxdr_decode_nfs_fh3(struct xdr_stream *xdr, struct svc_fh *fhp)
 	return true;
 }
 
+static bool
+svcxdr_encode_nfsstat3(struct xdr_stream *xdr, __be32 status)
+{
+	__be32 *p;
+
+	p = xdr_reserve_space(xdr, sizeof(status));
+	if (!p)
+		return false;
+	*p = status;
+
+	return true;
+}
+
 static __be32 *
 encode_fh(__be32 *p, struct svc_fh *fhp)
 {
@@ -253,6 +275,58 @@ svcxdr_decode_devicedata3(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 		svcxdr_decode_specdata3(xdr, args);
 }
 
+static bool
+svcxdr_encode_fattr3(struct svc_rqst *rqstp, struct xdr_stream *xdr,
+		     const struct svc_fh *fhp, const struct kstat *stat)
+{
+	struct user_namespace *userns = nfsd_user_namespace(rqstp);
+	__be32 *p;
+	u64 fsid;
+
+	p = xdr_reserve_space(xdr, XDR_UNIT * 21);
+	if (!p)
+		return false;
+
+	*p++ = cpu_to_be32(nfs3_ftypes[(stat->mode & S_IFMT) >> 12]);
+	*p++ = cpu_to_be32((u32)(stat->mode & S_IALLUGO));
+	*p++ = cpu_to_be32((u32)stat->nlink);
+	*p++ = cpu_to_be32((u32)from_kuid_munged(userns, stat->uid));
+	*p++ = cpu_to_be32((u32)from_kgid_munged(userns, stat->gid));
+	if (S_ISLNK(stat->mode) && stat->size > NFS3_MAXPATHLEN)
+		p = xdr_encode_hyper(p, (u64)NFS3_MAXPATHLEN);
+	else
+		p = xdr_encode_hyper(p, (u64)stat->size);
+
+	/* used */
+	p = xdr_encode_hyper(p, ((u64)stat->blocks) << 9);
+
+	/* rdev */
+	*p++ = cpu_to_be32((u32)MAJOR(stat->rdev));
+	*p++ = cpu_to_be32((u32)MINOR(stat->rdev));
+
+	switch(fsid_source(fhp)) {
+	case FSIDSOURCE_FSID:
+		fsid = (u64)fhp->fh_export->ex_fsid;
+		break;
+	case FSIDSOURCE_UUID:
+		fsid = ((u64 *)fhp->fh_export->ex_uuid)[0];
+		fsid ^= ((u64 *)fhp->fh_export->ex_uuid)[1];
+		break;
+	default:
+		fsid = (u64)huge_encode_dev(fhp->fh_dentry->d_sb->s_dev);
+	}
+	p = xdr_encode_hyper(p, fsid);
+
+	/* fileid */
+	p = xdr_encode_hyper(p, stat->ino);
+
+	p = encode_nfstime3(p, &stat->atime);
+	p = encode_nfstime3(p, &stat->mtime);
+	encode_nfstime3(p, &stat->ctime);
+
+	return true;
+}
+
 static __be32 *encode_fsid(__be32 *p, struct svc_fh *fhp)
 {
 	u64 f;
@@ -713,17 +787,22 @@ nfs3svc_decode_commitargs(struct svc_rqst *rqstp, __be32 *p)
 
 /* GETATTR */
 int
-nfs3svc_encode_attrstat(struct svc_rqst *rqstp, __be32 *p)
+nfs3svc_encode_getattrres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_attrstat *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	if (resp->status == 0) {
-		lease_get_mtime(d_inode(resp->fh.fh_dentry),
-				&resp->stat.mtime);
-		p = encode_fattr3(rqstp, p, &resp->fh, &resp->stat);
+	if (!svcxdr_encode_nfsstat3(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		lease_get_mtime(d_inode(resp->fh.fh_dentry), &resp->stat.mtime);
+		if (!svcxdr_encode_fattr3(rqstp, xdr, &resp->fh, &resp->stat))
+			return 0;
+		break;
 	}
-	return xdr_ressize_check(rqstp, p);
+
+	return 1;
 }
 
 /* SETATTR, REMOVE, RMDIR */
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 4744a276058d4..04930056222b7 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -710,7 +710,7 @@ char * SVCFH_fmt(struct svc_fh *fhp)
 	return buf;
 }
 
-enum fsid_source fsid_source(struct svc_fh *fhp)
+enum fsid_source fsid_source(const struct svc_fh *fhp)
 {
 	if (fhp->fh_handle.fh_version != 1)
 		return FSIDSOURCE_DEV;
diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index f58933519f380..aff2cda5c6c33 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -82,7 +82,7 @@ enum fsid_source {
 	FSIDSOURCE_FSID,
 	FSIDSOURCE_UUID,
 };
-extern enum fsid_source fsid_source(struct svc_fh *fhp);
+extern enum fsid_source fsid_source(const struct svc_fh *fhp);
 
 
 /*
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 3e1578953f544..0822981c61b93 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -280,7 +280,7 @@ int nfs3svc_decode_symlinkargs(struct svc_rqst *, __be32 *);
 int nfs3svc_decode_readdirargs(struct svc_rqst *, __be32 *);
 int nfs3svc_decode_readdirplusargs(struct svc_rqst *, __be32 *);
 int nfs3svc_decode_commitargs(struct svc_rqst *, __be32 *);
-int nfs3svc_encode_attrstat(struct svc_rqst *, __be32 *);
+int nfs3svc_encode_getattrres(struct svc_rqst *, __be32 *);
 int nfs3svc_encode_wccstat(struct svc_rqst *, __be32 *);
 int nfs3svc_encode_diropres(struct svc_rqst *, __be32 *);
 int nfs3svc_encode_accessres(struct svc_rqst *, __be32 *);
-- 
2.43.0



