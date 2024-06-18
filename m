Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D19A13AD2F;
	Tue, 18 Jun 2024 12:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715171; cv=none; b=Km4Hhy8QGXUVMD/9aKYrLhQl/40gzKL37N2b4ZvqQktRvPTVzall39iQj/ZcExT7e2zpFyTpGXHvDp0DXw72rpqHvF52s8Ge+RDCPGDLJj+SOt4dEy7ZAmso0q1YjwdzPtNe9YTBzZhkgJQ77iDhLg4ubIZutVc+5b8eTTHtLsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715171; c=relaxed/simple;
	bh=nJKGz68VXTI4zHbuV3waZ5bgKMxjOehWDWJqVSJ5rmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucH5lACeFmQNC+sJXg0D69nIA2fD2YlTjYZ9YzbqsiN7HsSuHeqA946axDQFNMRPiSrHFoPTlC9YX/5Ummd2DKQIpSeCT7g6F4uON20+WIMZSY0ivz7YEpnDHvMAXdZz+NNbWDAib2m+nTdBjFLD6tU0Oru8mMOu0YH++l5awUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JR+Yrl7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JR+Yrl7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95975C32786;
	Tue, 18 Jun 2024 12:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715171;
	bh=nJKGz68VXTI4zHbuV3waZ5bgKMxjOehWDWJqVSJ5rmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JR+Yrl7AnPaDmUsC6yiRDHM2cokOZOgf18R05VNoZXFUyosqbY/og7Mki4JeQqDzf
	 AhwuPKLSQ46nZG2zezm+u2vkTzhulah7MpOaTYLI5xngqHveQOw13jPXZrrSWtrk94
	 EhQssEhgN+KszMjddGLr6V5w3ls+VvXNC9FeFiu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/770] NFSD: Update the NFSv2 attrstat encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:12 +0200
Message-ID: <20240618123415.735058751@linuxfoundation.org>
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

[ Upstream commit 92b54a4fa4224e6116eb0d87a39dd05af23fcdfa ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsproc.c |  6 ++--
 fs/nfsd/nfsxdr.c  | 90 ++++++++++++++++++++++++++++++++++++++++++-----
 fs/nfsd/xdr.h     |  2 +-
 3 files changed, 86 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 00eb722129ab3..2a30b27c9d9be 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -640,7 +640,7 @@ static const struct svc_procedure nfsd_procedures2[18] = {
 	[NFSPROC_GETATTR] = {
 		.pc_func = nfsd_proc_getattr,
 		.pc_decode = nfssvc_decode_fhandleargs,
-		.pc_encode = nfssvc_encode_attrstat,
+		.pc_encode = nfssvc_encode_attrstatres,
 		.pc_release = nfssvc_release_attrstat,
 		.pc_argsize = sizeof(struct nfsd_fhandle),
 		.pc_ressize = sizeof(struct nfsd_attrstat),
@@ -651,7 +651,7 @@ static const struct svc_procedure nfsd_procedures2[18] = {
 	[NFSPROC_SETATTR] = {
 		.pc_func = nfsd_proc_setattr,
 		.pc_decode = nfssvc_decode_sattrargs,
-		.pc_encode = nfssvc_encode_attrstat,
+		.pc_encode = nfssvc_encode_attrstatres,
 		.pc_release = nfssvc_release_attrstat,
 		.pc_argsize = sizeof(struct nfsd_sattrargs),
 		.pc_ressize = sizeof(struct nfsd_attrstat),
@@ -714,7 +714,7 @@ static const struct svc_procedure nfsd_procedures2[18] = {
 	[NFSPROC_WRITE] = {
 		.pc_func = nfsd_proc_write,
 		.pc_decode = nfssvc_decode_writeargs,
-		.pc_encode = nfssvc_encode_attrstat,
+		.pc_encode = nfssvc_encode_attrstatres,
 		.pc_release = nfssvc_release_attrstat,
 		.pc_argsize = sizeof(struct nfsd_writeargs),
 		.pc_ressize = sizeof(struct nfsd_attrstat),
diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 10cd120044b30..65c8f8f314443 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -14,7 +14,7 @@
 /*
  * Mapping of S_IF* types to NFS file types
  */
-static u32	nfs_ftypes[] = {
+static const u32 nfs_ftypes[] = {
 	NFNON,  NFCHR,  NFCHR, NFBAD,
 	NFDIR,  NFBAD,  NFBLK, NFBAD,
 	NFREG,  NFBAD,  NFLNK, NFBAD,
@@ -70,6 +70,17 @@ encode_fh(__be32 *p, struct svc_fh *fhp)
 	return p + (NFS_FHSIZE>> 2);
 }
 
+static __be32 *
+encode_timeval(__be32 *p, const struct timespec64 *time)
+{
+	*p++ = cpu_to_be32((u32)time->tv_sec);
+	if (time->tv_nsec)
+		*p++ = cpu_to_be32(time->tv_nsec / NSEC_PER_USEC);
+	else
+		*p++ = xdr_zero;
+	return p;
+}
+
 static bool
 svcxdr_decode_filename(struct xdr_stream *xdr, char **name, unsigned int *len)
 {
@@ -233,6 +244,64 @@ encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp,
 	return p;
 }
 
+static int
+svcxdr_encode_fattr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
+		    const struct svc_fh *fhp, const struct kstat *stat)
+{
+	struct user_namespace *userns = nfsd_user_namespace(rqstp);
+	struct dentry *dentry = fhp->fh_dentry;
+	int type = stat->mode & S_IFMT;
+	struct timespec64 time;
+	__be32 *p;
+	u32 fsid;
+
+	p = xdr_reserve_space(xdr, XDR_UNIT * 17);
+	if (!p)
+		return 0;
+
+	*p++ = cpu_to_be32(nfs_ftypes[type >> 12]);
+	*p++ = cpu_to_be32((u32)stat->mode);
+	*p++ = cpu_to_be32((u32)stat->nlink);
+	*p++ = cpu_to_be32((u32)from_kuid_munged(userns, stat->uid));
+	*p++ = cpu_to_be32((u32)from_kgid_munged(userns, stat->gid));
+
+	if (S_ISLNK(type) && stat->size > NFS_MAXPATHLEN)
+		*p++ = cpu_to_be32(NFS_MAXPATHLEN);
+	else
+		*p++ = cpu_to_be32((u32) stat->size);
+	*p++ = cpu_to_be32((u32) stat->blksize);
+	if (S_ISCHR(type) || S_ISBLK(type))
+		*p++ = cpu_to_be32(new_encode_dev(stat->rdev));
+	else
+		*p++ = cpu_to_be32(0xffffffff);
+	*p++ = cpu_to_be32((u32)stat->blocks);
+
+	switch (fsid_source(fhp)) {
+	case FSIDSOURCE_FSID:
+		fsid = (u32)fhp->fh_export->ex_fsid;
+		break;
+	case FSIDSOURCE_UUID:
+		fsid = ((u32 *)fhp->fh_export->ex_uuid)[0];
+		fsid ^= ((u32 *)fhp->fh_export->ex_uuid)[1];
+		fsid ^= ((u32 *)fhp->fh_export->ex_uuid)[2];
+		fsid ^= ((u32 *)fhp->fh_export->ex_uuid)[3];
+		break;
+	default:
+		fsid = new_encode_dev(stat->dev);
+		break;
+	}
+	*p++ = cpu_to_be32(fsid);
+
+	*p++ = cpu_to_be32((u32)stat->ino);
+	p = encode_timeval(p, &stat->atime);
+	time = stat->mtime;
+	lease_get_mtime(d_inode(dentry), &time);
+	p = encode_timeval(p, &time);
+	encode_timeval(p, &stat->ctime);
+
+	return 1;
+}
+
 /* Helper function for NFSv2 ACL code */
 __be32 *nfs2svc_encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp, struct kstat *stat)
 {
@@ -412,16 +481,21 @@ nfssvc_encode_statres(struct svc_rqst *rqstp, __be32 *p)
 }
 
 int
-nfssvc_encode_attrstat(struct svc_rqst *rqstp, __be32 *p)
+nfssvc_encode_attrstatres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd_attrstat *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	if (resp->status != nfs_ok)
-		goto out;
-	p = encode_fattr(rqstp, p, &resp->fh, &resp->stat);
-out:
-	return xdr_ressize_check(rqstp, p);
+	if (!svcxdr_encode_stat(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_fattr(rqstp, xdr, &resp->fh, &resp->stat))
+			return 0;
+		break;
+	}
+
+	return 1;
 }
 
 int
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index f040123373bf5..45aa6b75a5f87 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -148,7 +148,7 @@ int nfssvc_decode_linkargs(struct svc_rqst *, __be32 *);
 int nfssvc_decode_symlinkargs(struct svc_rqst *, __be32 *);
 int nfssvc_decode_readdirargs(struct svc_rqst *, __be32 *);
 int nfssvc_encode_statres(struct svc_rqst *, __be32 *);
-int nfssvc_encode_attrstat(struct svc_rqst *, __be32 *);
+int nfssvc_encode_attrstatres(struct svc_rqst *, __be32 *);
 int nfssvc_encode_diropres(struct svc_rqst *, __be32 *);
 int nfssvc_encode_readlinkres(struct svc_rqst *, __be32 *);
 int nfssvc_encode_readres(struct svc_rqst *, __be32 *);
-- 
2.43.0



