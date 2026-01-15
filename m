Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2D13195F9;
	Thu, 15 Jan 2026 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496810; cv=none; b=REAyzzwbByGsQoCqDzoY8FJMXpNh4oFihJKu+/pfhHMOtsUwnWls3uJKLZ53ULAvD4wtL4BDtOyiyWSm7ikdrBKpPyClUN25bcGYtrAGIzbYrn5D1kOgat3Etew5dCWeolRWY6dxiE96rNurRvFEgBX12hHw6jizg6LgCGJZ+kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496810; c=relaxed/simple;
	bh=5eIrqEN3BbD8feXTnioCR1bfDegJWYei1M64zc2btmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Buwiay0ee06HGs1Y4N6C+T57OXz1/XLkUgnS0DclJF3kRKi4ZkjUIHY6GnnFf0l8tYrXmGMiwbwoqFcX4RAqevbXEKUmm94Zb9JlXHjHcI6nn3IaYAy/lWVNAw31jRoA+a2Cwg4D/d16kotRL3CXJ4gwBdAGgPjMOZbESCpTDyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrM/YKjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrM/YKjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D326C116D0;
	Thu, 15 Jan 2026 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496810;
	bh=5eIrqEN3BbD8feXTnioCR1bfDegJWYei1M64zc2btmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrM/YKjjO8GWeT7Zzg5uVH8IYduUGRTbJlivbyxuBTfTUE0EQ8xIIQNIjJYdLxpEo
	 rIpgMPvy/hVuPpjZ7g8L31qPe3xmiyy83C4sr6DTQfuCM/ye9jE3N13w6Gny6MN6Iq
	 c3/YwPQGYV/dxtZsk6aHKjugDpgBCgsCfPcynxGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 23/88] nfsd: convert to new timestamp accessors
Date: Thu, 15 Jan 2026 17:48:06 +0100
Message-ID: <20260115164147.153345894@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 11fec9b9fb04fd1b3330a3b91ab9dcfa81ad5ad3 upstream.

Convert to using the new inode timestamp accessor functions.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20231004185347.80880-50-jlayton@kernel.org
Stable-dep-of: 24d92de9186e ("nfsd: Fix NFSv3 atomicity bugs in nfsd_setattr()")
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ cel: d68886bae76a has already been applied ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/blocklayout.c |    3 ++-
 fs/nfsd/nfs3proc.c    |    4 ++--
 fs/nfsd/nfs4proc.c    |    8 ++++----
 fs/nfsd/nfsctl.c      |    2 +-
 fs/nfsd/vfs.c         |    2 +-
 5 files changed, 10 insertions(+), 9 deletions(-)

--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -119,11 +119,12 @@ static __be32
 nfsd4_block_commit_blocks(struct inode *inode, struct nfsd4_layoutcommit *lcp,
 		struct iomap *iomaps, int nr_iomaps)
 {
+	struct timespec64 mtime = inode_get_mtime(inode);
 	struct iattr iattr = { .ia_valid = 0 };
 	int error;
 
 	if (lcp->lc_mtime.tv_nsec == UTIME_NOW ||
-	    timespec64_compare(&lcp->lc_mtime, &inode->i_mtime) < 0)
+	    timespec64_compare(&lcp->lc_mtime, &mtime) < 0)
 		lcp->lc_mtime = current_time(inode);
 	iattr.ia_valid |= ATTR_ATIME | ATTR_CTIME | ATTR_MTIME;
 	iattr.ia_atime = iattr.ia_ctime = iattr.ia_mtime = lcp->lc_mtime;
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -294,8 +294,8 @@ nfsd3_create_file(struct svc_rqst *rqstp
 			status = nfserr_exist;
 			break;
 		case NFS3_CREATE_EXCLUSIVE:
-			if (d_inode(child)->i_mtime.tv_sec == v_mtime &&
-			    d_inode(child)->i_atime.tv_sec == v_atime &&
+			if (inode_get_mtime_sec(d_inode(child)) == v_mtime &&
+			    inode_get_atime_sec(d_inode(child)) == v_atime &&
 			    d_inode(child)->i_size == 0) {
 				break;
 			}
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -322,8 +322,8 @@ nfsd4_create_file(struct svc_rqst *rqstp
 			status = nfserr_exist;
 			break;
 		case NFS4_CREATE_EXCLUSIVE:
-			if (d_inode(child)->i_mtime.tv_sec == v_mtime &&
-			    d_inode(child)->i_atime.tv_sec == v_atime &&
+			if (inode_get_mtime_sec(d_inode(child)) == v_mtime &&
+			    inode_get_atime_sec(d_inode(child)) == v_atime &&
 			    d_inode(child)->i_size == 0) {
 				open->op_created = true;
 				break;		/* subtle */
@@ -331,8 +331,8 @@ nfsd4_create_file(struct svc_rqst *rqstp
 			status = nfserr_exist;
 			break;
 		case NFS4_CREATE_EXCLUSIVE4_1:
-			if (d_inode(child)->i_mtime.tv_sec == v_mtime &&
-			    d_inode(child)->i_atime.tv_sec == v_atime &&
+			if (inode_get_mtime_sec(d_inode(child)) == v_mtime &&
+			    inode_get_atime_sec(d_inode(child)) == v_atime &&
 			    d_inode(child)->i_size == 0) {
 				open->op_created = true;
 				goto set_attr;	/* subtle */
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1139,7 +1139,7 @@ static struct inode *nfsd_get_inode(stru
 	/* Following advice from simple_fill_super documentation: */
 	inode->i_ino = iunique(sb, NFSD_MaxReserved);
 	inode->i_mode = mode;
-	inode->i_atime = inode->i_mtime = inode_set_ctime_current(inode);
+	simple_inode_init_ts(inode);
 	switch (mode & S_IFMT) {
 	case S_IFDIR:
 		inode->i_fop = &simple_dir_operations;
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -521,7 +521,7 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 
 	nfsd_sanitize_attrs(inode, iap);
 
-	if (check_guard && guardtime != inode_get_ctime(inode).tv_sec)
+	if (check_guard && guardtime != inode_get_ctime_sec(inode))
 		return nfserr_notsync;
 
 	/*


