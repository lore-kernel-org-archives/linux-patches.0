Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276612566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DE2C4339B;
	Tue, 18 Apr 2023 12:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821088;
	bh=fPMVpcUOIDP+2ehlCYF+LjGptLRcd32g/q7TmXHKLzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lwb8YWFg9qWX8mBGJj1+9MIlrgiwurLyM1gSc/lcXMcpBRQEm6rwDGTCDBjbmpQgi
	 wZR2dHDnISF+6w3ztX/I3h+0atx5OfSFgVzWEbS9O3DEgtL4KKtm/VAkt4CNfqM/Xe
	 3n7Lf9dMux1sijvCvp827YVrMlue5OIX8UBPvQ7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 86/92] xfs: fix up non-directory creation in SGID directories
Date: Tue, 18 Apr 2023 14:22:01 +0200
Message-Id: <20230418120307.790949945@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

commit 01ea173e103edd5ec41acec65b9261b87e123fc2 upstream.

XFS always inherits the SGID bit if it is set on the parent inode, while
the generic inode_init_owner does not do this in a few cases where it can
create a possible security problem, see commit 0fa3ecd87848
("Fix up non-directory creation in SGID directories") for details.

Switch XFS to use the generic helper for the normal path to fix this,
just keeping the simple field inheritance open coded for the case of the
non-sgid case with the bsdgrpid mount option.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -750,6 +750,7 @@ xfs_ialloc(
 	xfs_buf_t	**ialloc_context,
 	xfs_inode_t	**ipp)
 {
+	struct inode	*dir = pip ? VFS_I(pip) : NULL;
 	struct xfs_mount *mp = tp->t_mountp;
 	xfs_ino_t	ino;
 	xfs_inode_t	*ip;
@@ -795,18 +796,17 @@ xfs_ialloc(
 		return error;
 	ASSERT(ip != NULL);
 	inode = VFS_I(ip);
-	inode->i_mode = mode;
 	set_nlink(inode, nlink);
-	inode->i_uid = current_fsuid();
 	inode->i_rdev = rdev;
 	ip->i_d.di_projid = prid;
 
-	if (pip && XFS_INHERIT_GID(pip)) {
-		inode->i_gid = VFS_I(pip)->i_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
-			inode->i_mode |= S_ISGID;
+	if (dir && !(dir->i_mode & S_ISGID) &&
+	    (mp->m_flags & XFS_MOUNT_GRPID)) {
+		inode->i_uid = current_fsuid();
+		inode->i_gid = dir->i_gid;
+		inode->i_mode = mode;
 	} else {
-		inode->i_gid = current_fsgid();
+		inode_init_owner(inode, dir, mode);
 	}
 
 	/*


