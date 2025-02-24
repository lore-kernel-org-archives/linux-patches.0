Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FE424EF64;
	Mon, 24 Feb 2025 14:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407820; cv=none; b=aWs9OX0mBRwwS0D+FPHRhQWIHxCwLfGHOUJObHouc2VwptiJ+Wz3PPSacEe7Ff8azrL95MRvZ2NtB872Ox3lLK+yFKeI+iu3rJh+yuoHe1CwgmgP5pstTtHBW3j0Q2wCD7lvygonVg1oRXljQemPz/NNBRr88mjLy6fyb/YYDa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407820; c=relaxed/simple;
	bh=9HRe/AFoY3x7BLm3xrute9XOdoAjHb7TtYfJqKPnBF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8DZ0fVdQZP8OZXIAPiAQSMTwUvgMtmnhED1EPEJOnvJvNxAjKgsZfcyoF64+P+2Esnl2z7nU1OBnqZRX1c4i/MdtS7cO5rk+zKB6CLUcch9bLxij4PLR7iHWhc1B8UI5Of6abxAS+qNoJxZX3gzpKuWOeQ2YC/7O58JNOCKj8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPVQvTsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPVQvTsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED7EC4CED6;
	Mon, 24 Feb 2025 14:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407819;
	bh=9HRe/AFoY3x7BLm3xrute9XOdoAjHb7TtYfJqKPnBF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPVQvTsYbaOZNx1F9j1Pwu7M2vuJ/mkBnbXjBRjOBnsWPnbb/SsVinMeHxd6gD2M6
	 WYeG5oucqllyKw85vC93EWVLX1vJyVPuKhWZQAwMjR8tJXAq6wyzfcL2P/Y9xETW1N
	 epulVuRMa7JfYwtkEvrsjRAdFdM+TO7o9TEn8INk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 019/140] xfs: update the file system geometry after recoverying superblock buffers
Date: Mon, 24 Feb 2025 15:33:38 +0100
Message-ID: <20250224142603.759712204@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 6a18765b54e2e52aebcdb84c3b4f4d1f7cb2c0ca upstream.

Primary superblock buffers that change the file system geometry after a
growfs operation can affect the operation of later CIL checkpoints that
make use of the newly added space and allocation groups.

Apply the changes to the in-memory structures as part of recovery pass 2,
to ensure recovery works fine for such cases.

In the future we should apply the logic to other updates such as features
bits as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf_item_recover.c |   52 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c      |    8 ------
 2 files changed, 52 insertions(+), 8 deletions(-)

--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -22,6 +22,9 @@
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_quota.h"
+#include "xfs_alloc.h"
+#include "xfs_ag.h"
+#include "xfs_sb.h"
 
 /*
  * This is the number of entries in the l_buf_cancel_table used during
@@ -685,6 +688,49 @@ xlog_recover_do_inode_buffer(
 }
 
 /*
+ * Update the in-memory superblock and perag structures from the primary SB
+ * buffer.
+ *
+ * This is required because transactions running after growfs may require the
+ * updated values to be set in a previous fully commit transaction.
+ */
+static int
+xlog_recover_do_primary_sb_buffer(
+	struct xfs_mount		*mp,
+	struct xlog_recover_item	*item,
+	struct xfs_buf			*bp,
+	struct xfs_buf_log_format	*buf_f,
+	xfs_lsn_t			current_lsn)
+{
+	struct xfs_dsb			*dsb = bp->b_addr;
+	xfs_agnumber_t			orig_agcount = mp->m_sb.sb_agcount;
+	int				error;
+
+	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
+
+	/*
+	 * Update the in-core super block from the freshly recovered on-disk one.
+	 */
+	xfs_sb_from_disk(&mp->m_sb, dsb);
+
+	/*
+	 * Initialize the new perags, and also update various block and inode
+	 * allocator setting based off the number of AGs or total blocks.
+	 * Because of the latter this also needs to happen if the agcount did
+	 * not change.
+	 */
+	error = xfs_initialize_perag(mp, orig_agcount,
+			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks,
+			&mp->m_maxagi);
+	if (error) {
+		xfs_warn(mp, "Failed recovery per-ag init: %d", error);
+		return error;
+	}
+	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+	return 0;
+}
+
+/*
  * V5 filesystems know the age of the buffer on disk being recovered. We can
  * have newer objects on disk than we are replaying, and so for these cases we
  * don't want to replay the current change as that will make the buffer contents
@@ -967,6 +1013,12 @@ xlog_recover_buf_commit_pass2(
 		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
 		if (!dirty)
 			goto out_release;
+	} else if ((xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) &&
+			xfs_buf_daddr(bp) == 0) {
+		error = xlog_recover_do_primary_sb_buffer(mp, item, bp, buf_f,
+				current_lsn);
+		if (error)
+			goto out_release;
 	} else {
 		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
 	}
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3317,7 +3317,6 @@ xlog_do_recover(
 	struct xfs_mount	*mp = log->l_mp;
 	struct xfs_buf		*bp = mp->m_sb_bp;
 	struct xfs_sb		*sbp = &mp->m_sb;
-	xfs_agnumber_t		orig_agcount = sbp->sb_agcount;
 	int			error;
 
 	trace_xfs_log_recover(log, head_blk, tail_blk);
@@ -3366,13 +3365,6 @@ xlog_do_recover(
 	/* re-initialise in-core superblock and geometry structures */
 	mp->m_features |= xfs_sb_version_to_features(sbp);
 	xfs_reinit_percpu_counters(mp);
-	error = xfs_initialize_perag(mp, orig_agcount, sbp->sb_agcount,
-			sbp->sb_dblocks, &mp->m_maxagi);
-	if (error) {
-		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
-		return error;
-	}
-	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
 	/* Normal transactions can now occur */
 	clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);


