Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2207615A85E;
	Tue, 18 Jun 2024 13:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716807; cv=none; b=gC8aRlR/qzyRxsNw8Y2Y/Z/aD7I4bprB5yKiQTmuv+yWJo8BkB86EFwrRcSKhEMIx8P/sfUHHxjQa9ZZaB+y86Xeg0H2DFrejESM1J06IEgWwEINka1NJvrFiY6WYgfsJMmsrb+tr7PgwXXd5eWX0PTY3Kgs0yQ7QadIeCB1Dss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716807; c=relaxed/simple;
	bh=LRzSvrott0NObsJrfxZwPvE2uxtrpaVxWosO5q+lysU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBrPfTg3aTf3NTqvikqf0I/eZcHiBc2W99lKqsDtCnR/3z5n1EqZ2X43UFnkVH2xKuuCq6NJHEr8hdJUx+/32jUy8kae/LWCPto3AGH/OvhqwrPdz5AA6NznEgV4ojfXzKp5ietG4IMRcf6J3Z7XZn1vx4Oe3oQiLJN/cvERcdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uf8Veuv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uf8Veuv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A5CC32786;
	Tue, 18 Jun 2024 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716807;
	bh=LRzSvrott0NObsJrfxZwPvE2uxtrpaVxWosO5q+lysU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uf8Veuv2A9RsusTUQA/aQ0bUWMCc4NoB6hMYuzLhW6HBa4RGWZyvrNC2dvZPqmA7s
	 A9Hw74bp94KjpbI5eO06UwQ9ao/p8K+UGvSo50/eLRp4tTAzGmlmy9iusY56H2egxV
	 0NWmPHJfRuZU4cqaNkA09oGUJJpAelhqnOhBIaeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 770/770] nfsd: Fix a regression in nfsd_setattr()
Date: Tue, 18 Jun 2024 14:40:23 +0200
Message-ID: <20240618123436.995540911@linuxfoundation.org>
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
[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 4 ++++
 fs/nfsd/vfs.c      | 6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 8560a11daa47d..2c0de247083a9 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1107,6 +1107,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	};
 	struct inode *inode;
 	__be32 status = nfs_ok;
+	bool save_no_wcc;
 	int err;
 
 	if (setattr->sa_iattr.ia_valid & ATTR_SIZE) {
@@ -1132,8 +1133,11 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 
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
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 542a1adbbf2a1..0ea05ddff0d08 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -486,7 +486,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	int		accmode = NFSD_MAY_SATTR;
 	umode_t		ftype = 0;
 	__be32		err;
-	int		host_err;
+	int		host_err = 0;
 	bool		get_write_count;
 	bool		size_change = (iap->ia_valid & ATTR_SIZE);
 	int		retries;
@@ -544,6 +544,7 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	}
 
 	inode_lock(inode);
+	fh_fill_pre_attrs(fhp);
 	for (retries = 1;;) {
 		struct iattr attrs;
 
@@ -569,13 +570,14 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	    !attr->na_aclerr && attr->na_dpacl && S_ISDIR(inode->i_mode))
 		attr->na_aclerr = set_posix_acl(inode, ACL_TYPE_DEFAULT,
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
-- 
2.43.0



