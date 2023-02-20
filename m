Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9F663B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC958C433EF;
	Mon, 20 Feb 2023 13:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900914;
	bh=Jppj5QP2ywOl0V0YLDbBQHJOfMK+dyKMYVkjO2SHzYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCfdfjtS4AbXGX/rEpg/joej8RfrbOjwHfdEvYzAGuvQejqVZtKhrNX8gg1Qna1hH
	 1nwzyepmr+dCb+Mjqqr9ZGZ6CBqGVgHwoeD4RJRxxV53Vu2yXcfBSJ7G3G1eyL173d
	 rmniqhacqw+ZGWl6a6ihu15VmW/+h/K0yDze1DEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.4 116/156] xfs: clean up xfs_bui_item_recover iget/trans_alloc/ilock ordering
Date: Mon, 20 Feb 2023 14:36:00 +0100
Message-Id: <20230220133607.399106289@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 64a3f3315bc60f710a0a25c1798ac0ea58c6fa1f upstream.

In most places in XFS, we have a specific order in which we gather
resources: grab the inode, allocate a transaction, then lock the inode.
xfs_bui_item_recover doesn't do it in that order, so fix it to be more
consistent.  This also makes the error bailout code a bit less weird.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_bmap_item.c |   38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -22,6 +22,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_error.h"
+#include "xfs_quota.h"
 
 kmem_zone_t	*xfs_bui_zone;
 kmem_zone_t	*xfs_bud_zone;
@@ -488,21 +489,26 @@ xfs_bui_recover(
 		return -EFSCORRUPTED;
 	}
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
+	/* Grab the inode. */
+	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);
 	if (error)
 		return error;
 
-	budp = xfs_trans_get_bud(tp, buip);
-
-	/* Grab the inode. */
-	error = xfs_iget(mp, tp, bmap->me_owner, 0, XFS_ILOCK_EXCL, &ip);
+	error = xfs_qm_dqattach(ip);
 	if (error)
-		goto err_inode;
+		goto err_rele;
 
 	if (VFS_I(ip)->i_nlink == 0)
 		xfs_iflags_set(ip, XFS_IRECOVERY);
 
+	/* Allocate transaction and do the work. */
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
+	if (error)
+		goto err_rele;
+
+	budp = xfs_trans_get_bud(tp, buip);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
 	count = bmap->me_len;
@@ -510,7 +516,7 @@ xfs_bui_recover(
 			whichfork, bmap->me_startoff, bmap->me_startblock,
 			&count, state);
 	if (error)
-		goto err_inode;
+		goto err_cancel;
 
 	if (count > 0) {
 		ASSERT(bui_type == XFS_BMAP_UNMAP);
@@ -522,16 +528,20 @@ xfs_bui_recover(
 	}
 
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
+	/* Commit transaction, which frees the transaction. */
 	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
+	if (error)
+		goto err_unlock;
+
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
-	return error;
+	return 0;
 
-err_inode:
+err_cancel:
 	xfs_trans_cancel(tp);
-	if (ip) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_irele(ip);
-	}
+err_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+err_rele:
+	xfs_irele(ip);
 	return error;
 }


