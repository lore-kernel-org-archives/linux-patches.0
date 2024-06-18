Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5E016A922;
	Tue, 18 Jun 2024 12:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715230; cv=none; b=ftYACZJprzkbCH8GP3zl+2+H5+xHF051K5Mqs+0DejuDAUUtfFuxf0Ln667juWsz0sX5/UXVqV8hgNtYJpsTSYHvP5CvOVQK75e+oZeqS4TdhntvUTnif3DMGWeiNdLLMLitCQVsvPkaYT1t0zZoUUGlrAiPgIVMXApIYaU85JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715230; c=relaxed/simple;
	bh=DSf+kGVGdLTT4AKckKcwBqU9WnP0uTERQAxT27GC7b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YE0Z3kUrY+77x8rF/X3zLYqtiRgmmWaRqR5K7jtsuScZQsUbNGvUkiImZNBGFM+vcbfRvEi2B3RyrTIGJqPN7yyGbzCqGkk38lQ3tRkl1dot/+Gv+NicoH2UwoNnlROo8gUrum+q869dFT3ZCeZh0Ef3eXo2E167Jv9QGrOEeLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hd+tGuW2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hd+tGuW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C15C3277B;
	Tue, 18 Jun 2024 12:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715230;
	bh=DSf+kGVGdLTT4AKckKcwBqU9WnP0uTERQAxT27GC7b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hd+tGuW2u8Z5M/4/NJ8Z4Zx7kwGsVWJDczZb/pH9wYJ67JJkSPzOkOOZ+2Y3/0XYK
	 rPu0IANjg2orYVYJQ2JhLsSy++HLL4JvnRMWWPlKB/8JywVoNREF1fKOAf0Q/oQV46
	 fUMl+pf+GhsXX73EMop/YjmVe3V3uJd6ntrm64dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 237/770] NFSD: Clean up after updating NFSv3 ACL encoders
Date: Tue, 18 Jun 2024 14:31:30 +0200
Message-ID: <20240618123416.427602428@linuxfoundation.org>
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

[ Upstream commit 1416f435303d81070c6bcf5a4a9b4ed0f7a9f013 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 86 -----------------------------------------------
 fs/nfsd/xdr3.h    |  2 --
 2 files changed, 88 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 941740a97f8f5..fcfa0d611b931 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -48,13 +48,6 @@ static const u32 nfs3_ftypes[] = {
  * Basic NFSv3 data types (RFC 1813 Sections 2.5 and 2.6)
  */
 
-static __be32 *
-encode_time3(__be32 *p, struct timespec64 *time)
-{
-	*p++ = htonl((u32) time->tv_sec); *p++ = htonl(time->tv_nsec);
-	return p;
-}
-
 static __be32 *
 encode_nfstime3(__be32 *p, const struct timespec64 *time)
 {
@@ -396,54 +389,6 @@ svcxdr_encode_fattr3(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	return true;
 }
 
-static __be32 *encode_fsid(__be32 *p, struct svc_fh *fhp)
-{
-	u64 f;
-	switch(fsid_source(fhp)) {
-	default:
-	case FSIDSOURCE_DEV:
-		p = xdr_encode_hyper(p, (u64)huge_encode_dev
-				     (fhp->fh_dentry->d_sb->s_dev));
-		break;
-	case FSIDSOURCE_FSID:
-		p = xdr_encode_hyper(p, (u64) fhp->fh_export->ex_fsid);
-		break;
-	case FSIDSOURCE_UUID:
-		f = ((u64*)fhp->fh_export->ex_uuid)[0];
-		f ^= ((u64*)fhp->fh_export->ex_uuid)[1];
-		p = xdr_encode_hyper(p, f);
-		break;
-	}
-	return p;
-}
-
-static __be32 *
-encode_fattr3(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp,
-	      struct kstat *stat)
-{
-	struct user_namespace *userns = nfsd_user_namespace(rqstp);
-	*p++ = htonl(nfs3_ftypes[(stat->mode & S_IFMT) >> 12]);
-	*p++ = htonl((u32) (stat->mode & S_IALLUGO));
-	*p++ = htonl((u32) stat->nlink);
-	*p++ = htonl((u32) from_kuid_munged(userns, stat->uid));
-	*p++ = htonl((u32) from_kgid_munged(userns, stat->gid));
-	if (S_ISLNK(stat->mode) && stat->size > NFS3_MAXPATHLEN) {
-		p = xdr_encode_hyper(p, (u64) NFS3_MAXPATHLEN);
-	} else {
-		p = xdr_encode_hyper(p, (u64) stat->size);
-	}
-	p = xdr_encode_hyper(p, ((u64)stat->blocks) << 9);
-	*p++ = htonl((u32) MAJOR(stat->rdev));
-	*p++ = htonl((u32) MINOR(stat->rdev));
-	p = encode_fsid(p, fhp);
-	p = xdr_encode_hyper(p, stat->ino);
-	p = encode_time3(p, &stat->atime);
-	p = encode_time3(p, &stat->mtime);
-	p = encode_time3(p, &stat->ctime);
-
-	return p;
-}
-
 static bool
 svcxdr_encode_wcc_attr(struct xdr_stream *xdr, const struct svc_fh *fhp)
 {
@@ -512,37 +457,6 @@ svcxdr_encode_post_op_attr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	return xdr_stream_encode_item_absent(xdr) > 0;
 }
 
-/*
- * Encode post-operation attributes.
- * The inode may be NULL if the call failed because of a stale file
- * handle. In this case, no attributes are returned.
- */
-static __be32 *
-encode_post_op_attr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
-{
-	struct dentry *dentry = fhp->fh_dentry;
-	if (!fhp->fh_no_wcc && dentry && d_really_is_positive(dentry)) {
-	        __be32 err;
-		struct kstat stat;
-
-		err = fh_getattr(fhp, &stat);
-		if (!err) {
-			*p++ = xdr_one;		/* attributes follow */
-			lease_get_mtime(d_inode(dentry), &stat.mtime);
-			return encode_fattr3(rqstp, p, fhp, &stat);
-		}
-	}
-	*p++ = xdr_zero;
-	return p;
-}
-
-/* Helper for NFSv3 ACLs */
-__be32 *
-nfs3svc_encode_post_op_attr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
-{
-	return encode_post_op_attr(rqstp, p, fhp);
-}
-
 /*
  * Encode weak cache consistency data
  */
diff --git a/fs/nfsd/xdr3.h b/fs/nfsd/xdr3.h
index 746c5f79964f1..933008382bbeb 100644
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -305,8 +305,6 @@ int nfs3svc_encode_entry3(void *data, const char *name, int namlen,
 int nfs3svc_encode_entryplus3(void *data, const char *name, int namlen,
 			      loff_t offset, u64 ino, unsigned int d_type);
 /* Helper functions for NFSv3 ACL code */
-__be32 *nfs3svc_encode_post_op_attr(struct svc_rqst *rqstp, __be32 *p,
-				struct svc_fh *fhp);
 bool svcxdr_decode_nfs_fh3(struct xdr_stream *xdr, struct svc_fh *fhp);
 bool svcxdr_encode_nfsstat3(struct xdr_stream *xdr, __be32 status);
 bool svcxdr_encode_post_op_attr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
-- 
2.43.0



