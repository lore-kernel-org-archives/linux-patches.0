Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6D935AC14;
	Thu,  2 Jul 2026 16:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011122; cv=none; b=TtlyAWY9EH6Iyzb6W1lPvKs2zWc4SS0d+7Dks6MXlluaVzILZTR4UpZQcmaad1a1WSLtfyKu3v5lI/xi1jqC4/Sq/SI/yY7NFQGJwtvkSDNKDkevM1QxSsh7ABPTb0XB5ZxsK28SVRX5C3KsHX6JKoBkpfwDGElalSdKoX2+M4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011122; c=relaxed/simple;
	bh=/NB8viWqJ8JjYBWDcFSNVVR/6nmnQdGGcEfylAmQ3Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJItrQRe3HjWqLBKlyu/Mh/HlKdgpNqRAFILOeLO8YOpxJIE2U/qy2beZaRu9B5bL3ZWAukavBz2fbwbNbm5bMNb9QaA4BP6dQuzfWvCFeAok3YJ76XIUfufDiO9ZIxzO2kmKpto1U4ee/4GQN84Uz94/l3RarlSUgUA3Wx0s/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1nNfwTH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1nNfwTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303DE1F000E9;
	Thu,  2 Jul 2026 16:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011120;
	bh=pmEPEs3xVy1mxif6tVGNCJd9Wp1Pm80zOwwGGN+vYNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F1nNfwTHcaO2jTYwEjnaVuYPVj/Wub4lHs0QOnKRRhgeL1mUsO2Bh8Csr47mJmsVy
	 349j+W3t8X/1eN2xuM0E+W10TyvKungRK/YkP7N4lfqxr6j1fFeFRRSybIyOB4kMY/
	 1Mxl4rotibbKVNXlHGKZ9RyEML7smKnaYtwoz/cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 164/175] nfsd: fix posix_acl leak on SETACL decode failure
Date: Thu,  2 Jul 2026 18:21:05 +0200
Message-ID: <20260702155119.244219011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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
@@ -131,10 +131,7 @@ static __be32 nfsacld_proc_setacl(struct
 	resp->status = fh_getattr(fh, &resp->stat);
 
 out:
-	/* argp->acl_{access,default} may have been allocated in
-	   nfssvc_decode_setaclargs. */
-	posix_acl_release(argp->acl_access);
-	posix_acl_release(argp->acl_default);
+	/* argp->acl_{access,default} are released in nfsaclsvc_release_setacl. */
 	return rpc_success;
 
 out_drop_lock:
@@ -312,6 +309,16 @@ static void nfsaclsvc_release_access(str
 
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
@@ -345,7 +352,7 @@ static const struct svc_procedure nfsd_a
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
@@ -118,10 +118,7 @@ out_drop_lock:
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
 
@@ -225,6 +222,16 @@ static void nfs3svc_release_getacl(struc
 
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
@@ -258,7 +265,7 @@ static const struct svc_procedure nfsd_a
 		.pc_func = nfsd3_proc_setacl,
 		.pc_decode = nfs3svc_decode_setaclargs,
 		.pc_encode = nfs3svc_encode_setaclres,
-		.pc_release = nfs3svc_release_fhandle,
+		.pc_release = nfs3svc_release_setacl,
 		.pc_argsize = sizeof(struct nfsd3_setaclargs),
 		.pc_argzero = sizeof(struct nfsd3_setaclargs),
 		.pc_ressize = sizeof(struct nfsd3_attrstat),


