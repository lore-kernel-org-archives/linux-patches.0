Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E04A15E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFIvwsll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC29DC433C8;
	Mon, 23 Oct 2023 11:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060928;
	bh=tJlxqb0y78VnZYWonIPJsXnsylT5yiDHFMmgtAAwYq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFIvwsllY9QUaiTaJBmS36rUeJpqqN3ROgaj3mc2EyTzERZBHbBxJmm2fee//2lXC
	 Z/QSTnpr1ffg97VM/Dr4W5Ssk4Jtp9NIzTAYnhHKBaefJNLIQNyh7CiUX8gu4kkOYo
	 y6eKa8pert9AGmlKF3zQU7K0VOIfMk8Qfmj6JhLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Kent <raven@themaw.net>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 003/137] xfs: dont expose internal symlink metadata buffers to the vfs
Date: Mon, 23 Oct 2023 12:56:00 +0200
Message-ID: <20231023104820.980891981@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 7b7820b83f230036fc48c3e7fb280c48c58adebf upstream.

Ian Kent reported that for inline symlinks, it's possible for
vfs_readlink to hang on to the target buffer returned by
_vn_get_link_inline long after it's been freed by xfs inode reclaim.
This is a layering violation -- we should never expose XFS internals to
the VFS.

When the symlink has a remote target, we allocate a separate buffer,
copy the internal information, and let the VFS manage the new buffer's
lifetime.  Let's adapt the inline code paths to do this too.  It's
less efficient, but fixes the layering violation and avoids the need to
adapt the if_data lifetime to rcu rules.  Clearly I don't care about
readlink benchmarks.

As a side note, this fixes the minor locking violation where we can
access the inode data fork without taking any locks; proper locking (and
eliminating the possibility of having to switch inode_operations on a
live inode) is essential to online repair coordinating repairs
correctly.

Reported-by: Ian Kent <raven@themaw.net>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Chandan Babu R <chandanbabu@kernel.org>
Acked-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iops.c    |   34 +---------------------------------
 fs/xfs/xfs_symlink.c |   29 +++++++++++++++++++----------
 2 files changed, 20 insertions(+), 43 deletions(-)

--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -511,27 +511,6 @@ xfs_vn_get_link(
 	return ERR_PTR(error);
 }
 
-STATIC const char *
-xfs_vn_get_link_inline(
-	struct dentry		*dentry,
-	struct inode		*inode,
-	struct delayed_call	*done)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	char			*link;
-
-	ASSERT(ip->i_df.if_format == XFS_DINODE_FMT_LOCAL);
-
-	/*
-	 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED if
-	 * if_data is junk.
-	 */
-	link = ip->i_df.if_u1.if_data;
-	if (XFS_IS_CORRUPT(ip->i_mount, !link))
-		return ERR_PTR(-EFSCORRUPTED);
-	return link;
-}
-
 static uint32_t
 xfs_stat_blksize(
 	struct xfs_inode	*ip)
@@ -1200,14 +1179,6 @@ static const struct inode_operations xfs
 	.update_time		= xfs_vn_update_time,
 };
 
-static const struct inode_operations xfs_inline_symlink_inode_operations = {
-	.get_link		= xfs_vn_get_link_inline,
-	.getattr		= xfs_vn_getattr,
-	.setattr		= xfs_vn_setattr,
-	.listxattr		= xfs_vn_listxattr,
-	.update_time		= xfs_vn_update_time,
-};
-
 /* Figure out if this file actually supports DAX. */
 static bool
 xfs_inode_supports_dax(
@@ -1358,10 +1329,7 @@ xfs_setup_iops(
 		inode->i_fop = &xfs_dir_file_operations;
 		break;
 	case S_IFLNK:
-		if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL)
-			inode->i_op = &xfs_inline_symlink_inode_operations;
-		else
-			inode->i_op = &xfs_symlink_inode_operations;
+		inode->i_op = &xfs_symlink_inode_operations;
 		break;
 	default:
 		inode->i_op = &xfs_inode_operations;
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
+#include "xfs_error.h"
 
 /* ----- Kernel only functions below ----- */
 int
@@ -96,17 +97,15 @@ xfs_readlink_bmap_ilocked(
 
 int
 xfs_readlink(
-	struct xfs_inode *ip,
-	char		*link)
+	struct xfs_inode	*ip,
+	char			*link)
 {
-	struct xfs_mount *mp = ip->i_mount;
-	xfs_fsize_t	pathlen;
-	int		error = 0;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fsize_t		pathlen;
+	int			error = -EFSCORRUPTED;
 
 	trace_xfs_readlink(ip);
 
-	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_LOCAL);
-
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
@@ -121,12 +120,22 @@ xfs_readlink(
 			 __func__, (unsigned long long) ip->i_ino,
 			 (long long) pathlen);
 		ASSERT(0);
-		error = -EFSCORRUPTED;
 		goto out;
 	}
 
-
-	error = xfs_readlink_bmap_ilocked(ip, link);
+	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		/*
+		 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED
+		 * if if_data is junk.
+		 */
+		if (XFS_IS_CORRUPT(ip->i_mount, !ip->i_df.if_u1.if_data))
+			goto out;
+
+		memcpy(link, ip->i_df.if_u1.if_data, pathlen + 1);
+		error = 0;
+	} else {
+		error = xfs_readlink_bmap_ilocked(ip, link);
+	}
 
  out:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);


