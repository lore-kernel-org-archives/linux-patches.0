Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8054B2505B8;
	Mon, 24 Feb 2025 14:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407844; cv=none; b=CjQ/jzOBCI4ytfn5iMpIbxWEaOUc722Vs3GhQu5K/lED6BcqB7teBc45rAmOQ2lZ13edmnVe5YzEeDJ+4/i9u8buouHvVH93qRbbRZoGcUam3gO1tNqVTsLlFVPOCRc2uGrq/xvBTdHrqsG0eVrylpRM3Kd6Cvua/uqFM5OehW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407844; c=relaxed/simple;
	bh=jdp6Fbzfowyu3zEYhu0vfkMdOouF9E23zmH4UIK20wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4hx6MyndNERFuQWTw/3hh56pzb+R2s+R8aTGkTc0ExLkpZ5pWAWV4U+uDPHMaNEIFXVv6I/O4qrDYJJnhgqqR1Ns7ev1J+udmTt/+oy6ePU8pOKYBZ46DZAkKlqUzkq3MkF2WKwECHqsUy0VfKqFf+DSUkbVRqvHdYJhja/+XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7P0xDi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7P0xDi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A983C4CED6;
	Mon, 24 Feb 2025 14:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407844;
	bh=jdp6Fbzfowyu3zEYhu0vfkMdOouF9E23zmH4UIK20wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7P0xDi6ZZodjsJne4wRUeDhQO1vUxWZe8zmsdgU3r4xE6B5f4A0edNXTlcxZ9Eop
	 l/oBmdI/UI2cOnn7dynAQRrZn0uFHPEn3TNdvKb0XCvyu0rxMdyAdHtAPcq0itqjBs
	 DueMBnakPEN32cBWItBcNLa/nNAF1QBo2F4HCZEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 025/140] xfs: Check for delayed allocations before setting extsize
Date: Mon, 24 Feb 2025 15:33:44 +0100
Message-ID: <20250224142603.993806685@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

commit 2a492ff66673c38a77d0815d67b9a8cce2ef57f8 upstream.

Extsize should only be allowed to be set on files with no data in it.
For this, we check if the files have extents but miss to check if
delayed extents are present. This patch adds that check.

While we are at it, also refactor this check into a helper since
it's used in some other places as well like xfs_inactive() or
xfs_ioctl_setattr_xflags()

**Without the patch (SUCCEEDS)**

$ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'

wrote 1024/1024 bytes at offset 0
1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)

**With the patch (FAILS as expected)**

$ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'

wrote 1024/1024 bytes at offset 0
1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
xfs_io: FS_IOC_FSSETXATTR testfile: Invalid argument

Fixes: e94af02a9cd7 ("[XFS] fix old xfs_setattr mis-merge from irix; mostly harmless esp if not using xfs rt")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |    2 +-
 fs/xfs/xfs_inode.h |    5 +++++
 fs/xfs/xfs_ioctl.c |    4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1758,7 +1758,7 @@ xfs_inactive(
 
 	if (S_ISREG(VFS_I(ip)->i_mode) &&
 	    (ip->i_disk_size != 0 || XFS_ISIZE(ip) != 0 ||
-	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
+	     xfs_inode_has_filedata(ip)))
 		truncate = 1;
 
 	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -286,6 +286,11 @@ static inline bool xfs_is_metadata_inode
 		xfs_is_quota_inode(&mp->m_sb, ip->i_ino);
 }
 
+static inline bool xfs_inode_has_filedata(const struct xfs_inode *ip)
+{
+	return ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0;
+}
+
 /*
  * Check if an inode has any data in the COW fork.  This might be often false
  * even for inodes with the reflink flag when there is no pending COW operation.
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1126,7 +1126,7 @@ xfs_ioctl_setattr_xflags(
 
 	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
 		/* Can't change realtime flag if any extents are allocated. */
-		if (ip->i_df.if_nextents || ip->i_delayed_blks)
+		if (xfs_inode_has_filedata(ip))
 			return -EINVAL;
 
 		/*
@@ -1247,7 +1247,7 @@ xfs_ioctl_setattr_check_extsize(
 	if (!fa->fsx_valid)
 		return 0;
 
-	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
+	if (S_ISREG(VFS_I(ip)->i_mode) && xfs_inode_has_filedata(ip) &&
 	    XFS_FSB_TO_B(mp, ip->i_extsize) != fa->fsx_extsize)
 		return -EINVAL;
 


