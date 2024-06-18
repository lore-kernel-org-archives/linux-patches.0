Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1FE13C69E;
	Tue, 18 Jun 2024 13:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716400; cv=none; b=dX8dBqAAKsRUWLiQVn6UPcwzrzE6RWDcaGUNwAGkoZoYBkxNkcYrKOUI58zcwH96ZKEOxg11Vk6VjFClKFVkFkvcRhmD2Epn1rneuGzzxDgv2rH7h4ACp2AhTpfAZbIi/Yeyzule5DJ+ka0o7qusojONYlhjVSecm4NemuyQCw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716400; c=relaxed/simple;
	bh=YoUT0ENpj7tN9MuOXK41UduGxHESgjCc6NhP0R+Gwr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pe44o3+5j1JJaKm8/wMVHNM+X6khH0b/FP4imhmlbd24iEC8+Xq74AOKIGvk+iFY8UDN8geZ/xJ2kFmwqJ+FPhKGuLNExNyoE3PFbCLivYA4ZnXmSWgMPrytGxzOJosts0wZWOCeFX/ijBzzSampFHlh03mRuSioZHUCJmx4cio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSDni/oI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSDni/oI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAC4C3277B;
	Tue, 18 Jun 2024 13:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716399;
	bh=YoUT0ENpj7tN9MuOXK41UduGxHESgjCc6NhP0R+Gwr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSDni/oIKjfMoEfQIwcYgnrJAIFVKvpzO1cMS/fdXn4INbrTssDM3pcSHZ+KMYOOu
	 /vRo6cYYgeIGWqhLRQRRFfFDzQOr1YmBoM6sKr21e6TNy2Z0fq7rIV8FwbgoMphEI0
	 X45O+oZ2mXnhFFqA11K5+3SAaXrXGW9MHvjuZSvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 616/770] NFSD: change nfsd_create()/nfsd_symlink() to unlock directory before returning.
Date: Tue, 18 Jun 2024 14:37:49 +0200
Message-ID: <20240618123431.067150816@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit 927bfc5600cd6333c9ef9f090f19e66b7d4c8ee1 ]

nfsd_create() usually returns with the directory still locked.
nfsd_symlink() usually returns with it unlocked.  This is clumsy.

Until recently nfsd_create() needed to keep the directory locked until
ACLs and security label had been set.  These are now set inside
nfsd_create() (in nfsd_setattr()) so this need is gone.

So change nfsd_create() and nfsd_symlink() to always unlock, and remove
any fh_unlock() calls that follow calls to these functions.

Signed-off-by: NeilBrown <neilb@suse.de>
[ cel: backported to 5.10.y, prior to idmapped mounts ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c |  2 --
 fs/nfsd/nfs4proc.c |  2 --
 fs/nfsd/vfs.c      | 38 +++++++++++++++++++++-----------------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 394f6fb201974..c71f0c359f7ae 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -388,7 +388,6 @@ nfsd3_proc_mkdir(struct svc_rqst *rqstp)
 	fh_init(&resp->fh, NFS3_FHSIZE);
 	resp->status = nfsd_create(rqstp, &resp->dirfh, argp->name, argp->len,
 				   &attrs, S_IFDIR, 0, &resp->fh);
-	fh_unlock(&resp->dirfh);
 	return rpc_success;
 }
 
@@ -469,7 +468,6 @@ nfsd3_proc_mknod(struct svc_rqst *rqstp)
 	type = nfs3_ftypes[argp->ftype];
 	resp->status = nfsd_create(rqstp, &resp->dirfh, argp->name, argp->len,
 				   &attrs, type, rdev, &resp->fh);
-	fh_unlock(&resp->dirfh);
 out:
 	return rpc_success;
 }
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 507a2aa967133..0396fa2c1cfe7 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -823,8 +823,6 @@ nfsd4_create(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		create->cr_bmval[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
 	if (attrs.na_aclerr)
 		create->cr_bmval[0] &= ~FATTR4_WORD0_ACL;
-
-	fh_unlock(&cstate->current_fh);
 	set_change_info(&create->cr_cinfo, &cstate->current_fh);
 	fh_dup2(&cstate->current_fh, &resfh);
 out:
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index bed542ba8ad8e..3d794533bbd4b 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1395,8 +1395,10 @@ nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	fh_lock_nested(fhp, I_MUTEX_PARENT);
 	dchild = lookup_one_len(fname, dentry, flen);
 	host_err = PTR_ERR(dchild);
-	if (IS_ERR(dchild))
-		return nfserrno(host_err);
+	if (IS_ERR(dchild)) {
+		err = nfserrno(host_err);
+		goto out_unlock;
+	}
 	err = fh_compose(resfhp, fhp->fh_export, dchild, fhp);
 	/*
 	 * We unconditionally drop our ref to dchild as fh_compose will have
@@ -1404,9 +1406,12 @@ nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	 */
 	dput(dchild);
 	if (err)
-		return err;
-	return nfsd_create_locked(rqstp, fhp, fname, flen, attrs, type,
-					rdev, resfhp);
+		goto out_unlock;
+	err = nfsd_create_locked(rqstp, fhp, fname, flen, attrs, type,
+				 rdev, resfhp);
+out_unlock:
+	fh_unlock(fhp);
+	return err;
 }
 
 /*
@@ -1483,16 +1488,19 @@ nfsd_symlink(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		goto out;
 
 	host_err = fh_want_write(fhp);
-	if (host_err)
-		goto out_nfserr;
+	if (host_err) {
+		err = nfserrno(host_err);
+		goto out;
+	}
 
 	fh_lock(fhp);
 	dentry = fhp->fh_dentry;
 	dnew = lookup_one_len(fname, dentry, flen);
-	host_err = PTR_ERR(dnew);
-	if (IS_ERR(dnew))
-		goto out_nfserr;
-
+	if (IS_ERR(dnew)) {
+		err = nfserrno(PTR_ERR(dnew));
+		fh_unlock(fhp);
+		goto out_drop_write;
+	}
 	host_err = vfs_symlink(d_inode(dentry), dnew, path);
 	err = nfserrno(host_err);
 	cerr = fh_compose(resfhp, fhp->fh_export, dnew, fhp);
@@ -1501,16 +1509,12 @@ nfsd_symlink(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	fh_unlock(fhp);
 	if (!err)
 		err = nfserrno(commit_metadata(fhp));
-	fh_drop_write(fhp);
-
 	dput(dnew);
 	if (err==0) err = cerr;
+out_drop_write:
+	fh_drop_write(fhp);
 out:
 	return err;
-
-out_nfserr:
-	err = nfserrno(host_err);
-	goto out;
 }
 
 /*
-- 
2.43.0



