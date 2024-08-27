Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2881C6893;
	Tue, 27 Aug 2024 15:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772704; cv=none; b=uR504WEBVaOB+Kyr9cKne88AouExKIM/AR8pg/glT/cFh4FzI6pRLoENLqyWi4HQ68XqfjQoY4uPKqGEnYPe59wrnKGHisOaY7/LrIeoqC64xNoxKl5pZ6hIo3+hC5XXLmKW1sYfQ4hG+F4QE5Dr4955bkO7+4QJxFFeQdkGZGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772704; c=relaxed/simple;
	bh=qx93A7GAfX4yAZlm3pVu5QJDdfly2zk8Y65FEV3TJUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AN1FURuD3D3b3RxN9dj1um9vuqLbjLYOhNLzcdBOMq7XziLNc3+u4PWX/Iw2Q/0Cm1BDijHm6pvEUroReF8sY6JIHoNYcP8/IVIAiK4EaU1704w6cb+v6i2FN2axnpTZkwwKrmWV/v1rIk/UOGY8PmVmtIB9L2WbJVjr5ZaGjcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oz8p5eD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oz8p5eD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A189C4DDFC;
	Tue, 27 Aug 2024 15:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772704;
	bh=qx93A7GAfX4yAZlm3pVu5QJDdfly2zk8Y65FEV3TJUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oz8p5eD378szJvWXHE0yltS5YZOtSiJ/p3sKOpuhrPzS/aEeG9zKtitNs94CrDGGz
	 pA5kqlPvJGMH4iHHG9ijdyaP87O93lVzZqbOW1uAL25s4LYetx5DkZuwjTFbmy3ycs
	 ZdoSm42bvW4n6yxNAkgszBWD1tmzIPPNpzGuMHGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 294/321] nfsd: Fix a regression in nfsd_setattr()
Date: Tue, 27 Aug 2024 16:40:02 +0200
Message-ID: <20240827143849.446834316@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 6412e44c40aaf8f1d7320b2099c5bdd6cb9126ac ]

Commit bb4d53d66e4b ("NFSD: use (un)lock_inode instead of
fh_(un)lock for file operations") broke the NFSv3 pre/post op
attributes behaviour when doing a SETATTR rpc call by stripping out
the calls to fh_fill_pre_attrs() and fh_fill_post_attrs().

Fixes: bb4d53d66e4b ("NFSD: use (un)lock_inode instead of fh_(un)lock for file operations")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Message-ID: <20240216012451.22725-1-trondmy@kernel.org>
[ cel: adjusted to apply to v6.1.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    4 ++++
 fs/nfsd/vfs.c      |    6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1106,6 +1106,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 	};
 	struct inode *inode;
 	__be32 status = nfs_ok;
+	bool save_no_wcc;
 	int err;
 
 	if (setattr->sa_iattr.ia_valid & ATTR_SIZE) {
@@ -1131,8 +1132,11 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 
 	if (status)
 		goto out;
+	save_no_wcc = cstate->current_fh.fh_no_wcc;
+	cstate->current_fh.fh_no_wcc = true;
 	status = nfsd_setattr(rqstp, &cstate->current_fh, &attrs,
 				0, (time64_t)0);
+	cstate->current_fh.fh_no_wcc = save_no_wcc;
 	if (!status)
 		status = nfserrno(attrs.na_labelerr);
 	if (!status)
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -475,7 +475,7 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 	int		accmode = NFSD_MAY_SATTR;
 	umode_t		ftype = 0;
 	__be32		err;
-	int		host_err;
+	int		host_err = 0;
 	bool		get_write_count;
 	bool		size_change = (iap->ia_valid & ATTR_SIZE);
 	int		retries;
@@ -533,6 +533,7 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 	}
 
 	inode_lock(inode);
+	fh_fill_pre_attrs(fhp);
 	for (retries = 1;;) {
 		struct iattr attrs;
 
@@ -560,13 +561,14 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 		attr->na_aclerr = set_posix_acl(&init_user_ns,
 						inode, ACL_TYPE_DEFAULT,
 						attr->na_dpacl);
+	fh_fill_post_attrs(fhp);
 	inode_unlock(inode);
 	if (size_change)
 		put_write_access(inode);
 out:
 	if (!host_err)
 		host_err = commit_metadata(fhp);
-	return nfserrno(host_err);
+	return err != 0 ? err : nfserrno(host_err);
 }
 
 #if defined(CONFIG_NFSD_V4)


