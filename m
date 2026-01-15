Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6C73A7F5D;
	Thu, 15 Jan 2026 17:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496813; cv=none; b=Ysf0ylY1ZCl6/11oKOO/XGXIYcnyW9qd59jJy9DUQX4vQof058bWY06IoCZ9rIktSlYyDMrsgfNGH+VZQ6zrVFRJwD9w2XOlSqCpekeog8//dDffFrhIp03fg3jApBA4ROfwPpWh/VWIWdwWi0b6br35MLYJuhiHInud9us+zBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496813; c=relaxed/simple;
	bh=Dxmc8KeY9bBB/7AsRuOnvyF8p8lH8Eqj675cGMJPmaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sh8WvROOUNC8pwpDVz+Sb4mY3/J+SYg5qXEFIoUCJ5vwGPUQE4gD8tmGoRB6sAqx8NaD3muh5epCB3Hbfx+0M0g7+6sc/ch3/9GdC0/Zn+/nLvbn89iAep7BjLqgbzMYn0q+xov660Fi/XvEjNBO7Id/NWg8npz8CmU4yIV7MMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKNu5IGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKNu5IGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4CBC116D0;
	Thu, 15 Jan 2026 17:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496813;
	bh=Dxmc8KeY9bBB/7AsRuOnvyF8p8lH8Eqj675cGMJPmaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKNu5IGNarXbDg29f0Z8LdB5JyHT3YIii157iEMUriUlv++OKn8ddi6nOpK+oAcXe
	 6tKFVcGKeoOzeXiy88iXO5gPmNBmCx49jDrwi0OHosZ2bLkxFi1P9rWSLod4ZddDZv
	 qjM8D1QfN17IfbK6fUmCy/BQARZDVOGeCxturHw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 24/88] nfsd: Fix NFSv3 atomicity bugs in nfsd_setattr()
Date: Thu, 15 Jan 2026 17:48:07 +0100
Message-ID: <20260115164147.188341985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 24d92de9186ebc340687caf7356e1070773e67bc upstream.

The main point of the guarded SETATTR is to prevent races with other
WRITE and SETATTR calls. That requires that the check of the guard time
against the inode ctime be done after taking the inode lock.

Furthermore, we need to take into account the 32-bit nature of
timestamps in NFSv3, and the possibility that files may change at a
faster rate than once a second.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Stable-dep-of: 442d27ff09a2 ("nfsd: set security label during create operations")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs3proc.c  |    6 ++++--
 fs/nfsd/nfs3xdr.c   |    5 +----
 fs/nfsd/nfs4proc.c  |    3 +--
 fs/nfsd/nfs4state.c |    2 +-
 fs/nfsd/nfsproc.c   |    6 +++---
 fs/nfsd/vfs.c       |   20 +++++++++++++-------
 fs/nfsd/vfs.h       |    2 +-
 fs/nfsd/xdr3.h      |    2 +-
 8 files changed, 25 insertions(+), 21 deletions(-)

--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -71,13 +71,15 @@ nfsd3_proc_setattr(struct svc_rqst *rqst
 	struct nfsd_attrs attrs = {
 		.na_iattr	= &argp->attrs,
 	};
+	const struct timespec64 *guardtime = NULL;
 
 	dprintk("nfsd: SETATTR(3)  %s\n",
 				SVCFH_fmt(&argp->fh));
 
 	fh_copy(&resp->fh, &argp->fh);
-	resp->status = nfsd_setattr(rqstp, &resp->fh, &attrs,
-				    argp->check_guard, argp->guardtime);
+	if (argp->check_guard)
+		guardtime = &argp->guardtime;
+	resp->status = nfsd_setattr(rqstp, &resp->fh, &attrs, guardtime);
 	return rpc_success;
 }
 
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -295,17 +295,14 @@ svcxdr_decode_sattr3(struct svc_rqst *rq
 static bool
 svcxdr_decode_sattrguard3(struct xdr_stream *xdr, struct nfsd3_sattrargs *args)
 {
-	__be32 *p;
 	u32 check;
 
 	if (xdr_stream_decode_bool(xdr, &check) < 0)
 		return false;
 	if (check) {
-		p = xdr_inline_decode(xdr, XDR_UNIT * 2);
-		if (!p)
+		if (!svcxdr_decode_nfstime3(xdr, &args->guardtime))
 			return false;
 		args->check_guard = 1;
-		args->guardtime = be32_to_cpup(p);
 	} else
 		args->check_guard = 0;
 
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1160,8 +1160,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 		goto out;
 	save_no_wcc = cstate->current_fh.fh_no_wcc;
 	cstate->current_fh.fh_no_wcc = true;
-	status = nfsd_setattr(rqstp, &cstate->current_fh, &attrs,
-				0, (time64_t)0);
+	status = nfsd_setattr(rqstp, &cstate->current_fh, &attrs, NULL);
 	cstate->current_fh.fh_no_wcc = save_no_wcc;
 	if (!status)
 		status = nfserrno(attrs.na_labelerr);
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5225,7 +5225,7 @@ nfsd4_truncate(struct svc_rqst *rqstp, s
 		return 0;
 	if (!(open->op_share_access & NFS4_SHARE_ACCESS_WRITE))
 		return nfserr_inval;
-	return nfsd_setattr(rqstp, fh, &attrs, 0, (time64_t)0);
+	return nfsd_setattr(rqstp, fh, &attrs, NULL);
 }
 
 static __be32 nfs4_get_vfs_file(struct svc_rqst *rqstp, struct nfs4_file *fp,
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -103,7 +103,7 @@ nfsd_proc_setattr(struct svc_rqst *rqstp
 		}
 	}
 
-	resp->status = nfsd_setattr(rqstp, fhp, &attrs, 0, (time64_t)0);
+	resp->status = nfsd_setattr(rqstp, fhp, &attrs, NULL);
 	if (resp->status != nfs_ok)
 		goto out;
 
@@ -390,8 +390,8 @@ nfsd_proc_create(struct svc_rqst *rqstp)
 		 */
 		attr->ia_valid &= ATTR_SIZE;
 		if (attr->ia_valid)
-			resp->status = nfsd_setattr(rqstp, newfhp, &attrs, 0,
-						    (time64_t)0);
+			resp->status = nfsd_setattr(rqstp, newfhp, &attrs,
+						    NULL);
 	}
 
 out_unlock:
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -459,7 +459,6 @@ static int __nfsd_setattr(struct dentry
  * @rqstp: controlling RPC transaction
  * @fhp: filehandle of target
  * @attr: attributes to set
- * @check_guard: set to 1 if guardtime is a valid timestamp
  * @guardtime: do not act if ctime.tv_sec does not match this timestamp
  *
  * This call may adjust the contents of @attr (in particular, this
@@ -471,8 +470,7 @@ static int __nfsd_setattr(struct dentry
  */
 __be32
 nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
-	     struct nfsd_attrs *attr,
-	     int check_guard, time64_t guardtime)
+	     struct nfsd_attrs *attr, const struct timespec64 *guardtime)
 {
 	struct dentry	*dentry;
 	struct inode	*inode;
@@ -521,9 +519,6 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 
 	nfsd_sanitize_attrs(inode, iap);
 
-	if (check_guard && guardtime != inode_get_ctime_sec(inode))
-		return nfserr_notsync;
-
 	/*
 	 * The size case is special, it changes the file in addition to the
 	 * attributes, and file systems don't expect it to be mixed with
@@ -541,6 +536,16 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 	err = fh_fill_pre_attrs(fhp);
 	if (err)
 		goto out_unlock;
+
+	if (guardtime) {
+		struct timespec64 ctime = inode_get_ctime(inode);
+		if ((u32)guardtime->tv_sec != (u32)ctime.tv_sec ||
+		    guardtime->tv_nsec != ctime.tv_nsec) {
+			err = nfserr_notsync;
+			goto out_fill_attrs;
+		}
+	}
+
 	for (retries = 1;;) {
 		struct iattr attrs;
 
@@ -568,6 +573,7 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 		attr->na_aclerr = set_posix_acl(&nop_mnt_idmap,
 						dentry, ACL_TYPE_DEFAULT,
 						attr->na_dpacl);
+out_fill_attrs:
 	fh_fill_post_attrs(fhp);
 out_unlock:
 	inode_unlock(inode);
@@ -1374,7 +1380,7 @@ nfsd_create_setattr(struct svc_rqst *rqs
 	 * if the attributes have not changed.
 	 */
 	if (iap->ia_valid)
-		status = nfsd_setattr(rqstp, resfhp, attrs, 0, (time64_t)0);
+		status = nfsd_setattr(rqstp, resfhp, attrs, NULL);
 	else
 		status = nfserrno(commit_metadata(resfhp));
 
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -69,7 +69,7 @@ __be32		 nfsd_lookup_dentry(struct svc_r
 				const char *, unsigned int,
 				struct svc_export **, struct dentry **);
 __be32		nfsd_setattr(struct svc_rqst *, struct svc_fh *,
-				struct nfsd_attrs *, int, time64_t);
+			     struct nfsd_attrs *, const struct timespec64 *);
 int nfsd_mountpoint(struct dentry *, struct svc_export *);
 #ifdef CONFIG_NFSD_V4
 __be32		nfsd4_vfs_fallocate(struct svc_rqst *, struct svc_fh *,
--- a/fs/nfsd/xdr3.h
+++ b/fs/nfsd/xdr3.h
@@ -14,7 +14,7 @@ struct nfsd3_sattrargs {
 	struct svc_fh		fh;
 	struct iattr		attrs;
 	int			check_guard;
-	time64_t		guardtime;
+	struct timespec64	guardtime;
 };
 
 struct nfsd3_diropargs {


