Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09D732E733;
	Wed, 17 Sep 2025 12:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113675; cv=none; b=h4T2T+tBpBYpJzl8ZSRPde/YRv4mZtfLQ3sVCTthDfU9B/QQjDOnRwe+b3Qs621yp7siTyYbgJwiCOigtgc4ZszPKlaYCmKy5MyBrXu78Ij8cBwiNjg6UMMgn5M+DlIoWTDKe9hkdoIkpioHxb2FxAj+c3qfHxRmgdTcrd6Zlsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113675; c=relaxed/simple;
	bh=sr/I3R4yNAJV10EYPkNVuZ3qPb2vnTiPbQZUBB6Kn+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7oYZnmE3rUkVdi5o/eYAraJ8YqMrn5IG4VrOJwWeVYSJ1amJw0YSJAvfo52c0/SxJjfix+lmyfo+j5ADSkfD/0WL6g6bncdvTLVY/UORgJNRjBEd2lexowUWpx5USaDGhECLGdmOMJquRsaCYzTfhV1SFNanj8QeEc/ClOwO2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4zHlbWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4zHlbWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710CDC4CEF0;
	Wed, 17 Sep 2025 12:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113674;
	bh=sr/I3R4yNAJV10EYPkNVuZ3qPb2vnTiPbQZUBB6Kn+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4zHlbWQxLyj+LSU6weQGkXHmhpZlZnsVaulyc1Clc4OAxEbJim9mBVeSb3skwfPH
	 obPXtPC4zypHpcGvIMkJmveq3WJ5FqsJMqFcD/vETlf3DoJW6pvyNm/TG+3XLG6Ew6
	 xhkl3QLC1mtvAMbYrjbMATlcfbdJCyPbCYJP/KCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/101] nfsd: Fix a regression in nfsd_setattr()
Date: Wed, 17 Sep 2025 14:33:47 +0200
Message-ID: <20250917123336.973574167@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
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
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: d7d8e3169b56 ("NFSD: nfsd_unlink() clobbers non-zero status returned from fh_fill_pre_attrs()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    4 ++++
 fs/nfsd/vfs.c      |    9 +++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1131,6 +1131,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 	};
 	struct inode *inode;
 	__be32 status = nfs_ok;
+	bool save_no_wcc;
 	int err;
 
 	if (setattr->sa_iattr.ia_valid & ATTR_SIZE) {
@@ -1156,8 +1157,11 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 
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
@@ -480,7 +480,7 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 	int		accmode = NFSD_MAY_SATTR;
 	umode_t		ftype = 0;
 	__be32		err;
-	int		host_err;
+	int		host_err = 0;
 	bool		get_write_count;
 	bool		size_change = (iap->ia_valid & ATTR_SIZE);
 	int		retries;
@@ -538,6 +538,9 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 	}
 
 	inode_lock(inode);
+	err = fh_fill_pre_attrs(fhp);
+	if (err)
+		goto out_unlock;
 	for (retries = 1;;) {
 		struct iattr attrs;
 
@@ -565,13 +568,15 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 		attr->na_aclerr = set_posix_acl(&nop_mnt_idmap,
 						dentry, ACL_TYPE_DEFAULT,
 						attr->na_dpacl);
+	fh_fill_post_attrs(fhp);
+out_unlock:
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


