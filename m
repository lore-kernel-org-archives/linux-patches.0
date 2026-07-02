Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF4849252E;
	Thu,  2 Jul 2026 16:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009522; cv=none; b=CuioupJidnN9nRk9mBMrlEmnLl6NDi25B+n1LPYltIkyc2ZmE6GyfTVlG7xGHUc2Y1TSWOg7sXaJURfQvVQhUuIwFQTC+25//p5u3SlnDLNz056NXxOiuP90xXsLn/9eYNh4sKAwU0snHFH/YJBc4IzW9LBFl/hBt7J5SXqJlto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009522; c=relaxed/simple;
	bh=mjGUxXxPiuOjR0WmAas6YQbHnAcYMMl07dFuY2MTIX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMPFPBrZ5ZMr3curoGMP4wQ8wn54lJtwiUgpVm5+Wc7vY8YuKZvAM40Q1a30ubaJ03gNzYv4xKeztcaa6j1SGdPUKzWfIBmLR4k5OtrNaNQ40OrtGVk7vBoLTmiNmsP0oYa/egRFnwLFujqt9ipJdgxr5qy/omzQeqtp26xS+Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V521GtGW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V521GtGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407E11F000E9;
	Thu,  2 Jul 2026 16:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009515;
	bh=MB0VKDR85Zw2+SnJZ+ARQRY4Y8883AAhwYPwExhOmME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V521GtGWle6iAHzOruE2aH9Jr10nEcSwu/ZwaR7nP6rNqWa5DqetQM9sIO4tWz6cD
	 n8yGJqV8KQpOqXELTFny9QmwuQiOJJ3IA6OhqeoBDMF4sBwHwYLLmWrX5luVY/ATcT
	 8a+G7rRi6u++z0IoEOFzoiCSIGPLt8CnKDsKF4k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 80/96] nfsd: fix posix_acl leak on SETACL decode failure
Date: Thu,  2 Jul 2026 18:20:12 +0200
Message-ID: <20260702155110.663230582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 0853ac544c590880d797b04daa33fcb72b6be0e1 upstream.

nfsaclsvc_decode_setaclargs() and nfs3svc_decode_setaclargs() each
call nfs_stream_decode_acl() twice, first for NFS_ACL and then for
NFS_DFACL.  Each successful call transfers ownership of a freshly
allocated posix_acl into argp->acl_access or argp->acl_default.  If
the first call succeeds but the second fails, the decoder returns
false and argp->acl_access is left dangling.

ACLPROC2_SETACL.pc_release was wired to nfssvc_release_attrstat and
ACLPROC3_SETACL.pc_release was wired to nfs3svc_release_fhandle.
Both only call fh_put() and have no knowledge of the ACL fields on
argp.  The posix_acl_release() pairs sat at the out: labels inside
nfsacld_proc_setacl() and nfsd3_proc_setacl(), but svc_process()
skips pc_func when pc_decode returns false, so that cleanup is
unreachable on decode failure:

    svc_process_common()
      pc_decode()                  /* decode_setaclargs: false */
      /* pc_func skipped */
      pc_release()                 /* fh_put only -- ACLs leaked */

The orphaned posix_acl is leaked for the lifetime of the server.

Fix by adding nfsaclsvc_release_setacl() and nfs3svc_release_setacl(),
which release both argp->acl_access and argp->acl_default in addition
to fh_put(), and wiring them as pc_release for their respective SETACL
procedures.  pc_release runs on every path svc_process() takes after
decode, including decode failure, so the posix_acl_release() pairs are
removed from the proc functions' out: labels to keep ownership in one
place.  This matches the existing release_getacl() pattern used by
the sibling GETACL procedures.

Fixes: a257cdd0e217 ("[PATCH] NFSD: Add server support for NFSv3 ACLs.")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs2acl.c |   17 ++++++++++++-----
 fs/nfsd/nfs3acl.c |   17 ++++++++++++-----
 2 files changed, 24 insertions(+), 10 deletions(-)

--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -129,10 +129,7 @@ static __be32 nfsacld_proc_setacl(struct
 	resp->status = fh_getattr(fh, &resp->stat);
 
 out:
-	/* argp->acl_{access,default} may have been allocated in
-	   nfssvc_decode_setaclargs. */
-	posix_acl_release(argp->acl_access);
-	posix_acl_release(argp->acl_default);
+	/* argp->acl_{access,default} are released in nfsaclsvc_release_setacl. */
 	return rpc_success;
 
 out_drop_lock:
@@ -310,6 +307,16 @@ static void nfsaclsvc_release_access(str
 
 struct nfsd3_voidargs { int dummy; };
 
+static void nfsaclsvc_release_setacl(struct svc_rqst *rqstp)
+{
+	struct nfsd3_setaclargs *argp = rqstp->rq_argp;
+	struct nfsd_attrstat *resp = rqstp->rq_resp;
+
+	fh_put(&resp->fh);
+	posix_acl_release(argp->acl_access);
+	posix_acl_release(argp->acl_default);
+}
+
 #define ST 1		/* status*/
 #define AT 21		/* attributes */
 #define pAT (1+AT)	/* post attributes - conditional */
@@ -343,7 +350,7 @@ static const struct svc_procedure nfsd_a
 		.pc_func = nfsacld_proc_setacl,
 		.pc_decode = nfsaclsvc_decode_setaclargs,
 		.pc_encode = nfssvc_encode_attrstatres,
-		.pc_release = nfssvc_release_attrstat,
+		.pc_release = nfsaclsvc_release_setacl,
 		.pc_argsize = sizeof(struct nfsd3_setaclargs),
 		.pc_argzero = sizeof(struct nfsd3_setaclargs),
 		.pc_ressize = sizeof(struct nfsd_attrstat),
--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -116,10 +116,7 @@ out_drop_lock:
 out_errno:
 	resp->status = nfserrno(error);
 out:
-	/* argp->acl_{access,default} may have been allocated in
-	   nfs3svc_decode_setaclargs. */
-	posix_acl_release(argp->acl_access);
-	posix_acl_release(argp->acl_default);
+	/* argp->acl_{access,default} are released in nfs3svc_release_setacl. */
 	return rpc_success;
 }
 
@@ -223,6 +220,16 @@ static void nfs3svc_release_getacl(struc
 
 struct nfsd3_voidargs { int dummy; };
 
+static void nfs3svc_release_setacl(struct svc_rqst *rqstp)
+{
+	struct nfsd3_setaclargs *argp = rqstp->rq_argp;
+	struct nfsd3_attrstat *resp = rqstp->rq_resp;
+
+	fh_put(&resp->fh);
+	posix_acl_release(argp->acl_access);
+	posix_acl_release(argp->acl_default);
+}
+
 #define ST 1		/* status*/
 #define AT 21		/* attributes */
 #define pAT (1+AT)	/* post attributes - conditional */
@@ -256,7 +263,7 @@ static const struct svc_procedure nfsd_a
 		.pc_func = nfsd3_proc_setacl,
 		.pc_decode = nfs3svc_decode_setaclargs,
 		.pc_encode = nfs3svc_encode_setaclres,
-		.pc_release = nfs3svc_release_fhandle,
+		.pc_release = nfs3svc_release_setacl,
 		.pc_argsize = sizeof(struct nfsd3_setaclargs),
 		.pc_argzero = sizeof(struct nfsd3_setaclargs),
 		.pc_ressize = sizeof(struct nfsd3_attrstat),


