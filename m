Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31725AD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7840C433C1;
	Thu, 27 Oct 2022 17:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890603;
	bh=voZfHeseJeONE9yxzdyIMq/teIrWkXpsO1Q2JozkLok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKARqVhAvtfotro5W65SqpOf/zU9g1h0AUfPm/yEluZgywjaYkFJTtyTYT9/Mzikh
	 LiRotFhTYuLtS1t5DEo7XBUJ2Wn+qI2m3QuIA/ngNueC5AiA7E2Ll97P0WX5Q/X4uo
	 ZNfLgoWZRKJ73EwZM1/d+1j6So5xdMSawIwiER9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 23/53] xfs: factor out a new xfs_log_force_inode helper
Date: Thu, 27 Oct 2022 18:56:11 +0200
Message-Id: <20221027165050.705333071@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
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

commit 54fbdd1035e3a4e4f4082c335b095426cdefd092 upstream.

Create a new helper to force the log up to the last LSN touching an
inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_export.c |   14 +-------------
 fs/xfs/xfs_file.c   |   12 +-----------
 fs/xfs/xfs_inode.c  |   19 +++++++++++++++++++
 fs/xfs/xfs_inode.h  |    1 +
 4 files changed, 22 insertions(+), 24 deletions(-)

--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -15,7 +15,6 @@
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_icache.h"
-#include "xfs_log.h"
 #include "xfs_pnfs.h"
 
 /*
@@ -221,18 +220,7 @@ STATIC int
 xfs_fs_nfs_commit_metadata(
 	struct inode		*inode)
 {
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_lsn_t		lsn = 0;
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip))
-		lsn = ip->i_itemp->ili_last_lsn;
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	if (!lsn)
-		return 0;
-	return xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
+	return xfs_log_force_inode(XFS_I(inode));
 }
 
 const struct export_operations xfs_export_operations = {
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -80,19 +80,9 @@ xfs_dir_fsync(
 	int			datasync)
 {
 	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_lsn_t		lsn = 0;
 
 	trace_xfs_dir_fsync(ip);
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip))
-		lsn = ip->i_itemp->ili_last_lsn;
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	if (!lsn)
-		return 0;
-	return xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
+	return xfs_log_force_inode(ip);
 }
 
 STATIC int
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3973,3 +3973,22 @@ xfs_irele(
 	trace_xfs_irele(ip, _RET_IP_);
 	iput(VFS_I(ip));
 }
+
+/*
+ * Ensure all commited transactions touching the inode are written to the log.
+ */
+int
+xfs_log_force_inode(
+	struct xfs_inode	*ip)
+{
+	xfs_lsn_t		lsn = 0;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	if (xfs_ipincount(ip))
+		lsn = ip->i_itemp->ili_last_lsn;
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	if (!lsn)
+		return 0;
+	return xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC, NULL);
+}
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -441,6 +441,7 @@ int		xfs_itruncate_extents_flags(struct
 				struct xfs_inode *, int, xfs_fsize_t, int);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
 
+int		xfs_log_force_inode(struct xfs_inode *ip);
 void		xfs_iunpin_wait(xfs_inode_t *);
 #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
 


