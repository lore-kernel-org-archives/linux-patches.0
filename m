Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828990;
	b=hR4qUSaVcrdCsPjEo6qhosLBixmUncg2QN0mPtXJsHyJ8Ty41DzkPLufy5+k5HZvWvN6
	 Z4TlcsrhZHYGmQYhG/GcWHG3XdPRg4aS/N0MWK/5jHu0KrzQwtbV2vRS1qKblOUDxMv56
	 iLlAVfjWzm996XI+m5y+FsK+S67H0Rif7niypxn0TRINXxGoOK7/yB1fO3VBpQaTsELOE
	 tVknA+rr5id2Qx46IUCZnczi965ccTdpba9alcKAOUQxTxg22Ai2dr+glS+oeZ0cyulw/
	 i4yiBovcze2oPOMzvMzWxs++Ni34Nu6TfKoo4JPP6oEXyhNdYjPISSnVFrkl9wiuZJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zikyHDtCFVJpzvMEjJnPg/E4cmDbv5CTPeqDnJf3/k0=;
	b=qqUK3nge5uhoIYpIqt5YDVD47MMRw889yNbqAYcHlOQFwHwvkXKNIK+PRbAY45A2UljZ
	 sX1auT1+UQD7SaLb28xGBi92+RIMYsxXwoXzgicg8PJX95dXIoZR5cMvv1g5tpqj8K30o
	 AltDS7kyDxxEr9F32ctLv521ZL1zGxSjy+qYO0krpYxmIwTCDTv0ODIJrsjWvWfWZnG6n
	 71/mVKawPTFGa1KR8J5ywwwDTJR1qxEvYz9LVESDBAglPxBSOOuTygAnipinvesAsOdfy
	 3K35N395KiSHUc8Nu7BNQRD8XWclaPbzEupFfTfc8CWCckGVGhbw5uENIZo8ZyY2Gew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HhPm+ru8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05E4607F281;
	Wed,  4 Nov 2026 21:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HhPm+ru8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F721F000C1;
	Wed,  4 Nov 2026 21:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828989;
	bh=zikyHDtCFVJpzvMEjJnPg/E4cmDbv5CTPeqDnJf3/k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HhPm+ru8V+eMLYxwFWjANYNhWWxqepk7w/XLIW8rGXs34GVlHpx5YczKjLOgxlgI/
	 W4FVc5YcNgT2NEWzzPR5G3N0eATtK9zSFAXObcp3tmF5dlFsTwKwGaKqkk/kB2qbBt
	 /VIEM8JtVk3uMOEtnaKcuctaC/E1ccdT++iNG2PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 373/547] xfs: reattach dquots after changing inode ids
Date: Wed,  4 Nov 2026 16:09:17 -0500
Message-ID: <20261104211048.900298324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 2f528e4a8f89daa6d0cc64b044f6f94c018fe9ae upstream.

LOLLM noticed that xrep_inode_ids can change the user, group, or project
id of any given file.  When this happens, we need to detach any existing
incore dquot and attach the correct ones.

Cc: stable@vger.kernel.org # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |  133 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 132 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -41,6 +41,8 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -1766,6 +1768,20 @@ xrep_inode_ids(
 
 	trace_xrep_inode_ids(sc);
 
+	/*
+	 * We changed one of the file IDs, so we must detach the dquots to
+	 * prevent further changes from being accounted to them, and try to
+	 * attach the dquot for the new id to absorb any other block usage
+	 * changes.  We can't do that right now because the existing dquots
+	 * might be attached to the scrub transaction and we're in the middle
+	 * of fixing the inode, so we'll switch the incore dquot pointers
+	 * later.
+	 *
+	 * Schedule a quotacheck so the accounting discrepancies will get fixed
+	 * eventually.  We'll have to repeat this later when we do the actual
+	 * switch.
+	 */
+
 	if (!uid_valid(VFS_I(sc->ip)->i_uid)) {
 		i_uid_write(VFS_I(sc->ip), 0);
 		dirty = true;
@@ -2075,6 +2091,113 @@ xrep_inode_unlinked(
 	return 0;
 }
 
+#ifdef CONFIG_XFS_QUOTA
+static inline bool
+xrep_inode_need_reset_dquots(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_inode	*ip = sc->ip;
+
+	if (!XFS_IS_QUOTA_ON(mp))
+		return false;
+	if (xfs_is_quota_inode(&mp->m_sb, I_INO(ip)))
+		return false;
+	if (xfs_is_metadir_inode(ip))
+		return false;
+
+	if (XFS_IS_UQUOTA_ON(sc->mp) &&
+	    (!ip->i_udquot || ip->i_udquot->q_id != i_uid_read(VFS_I(ip))))
+		return true;
+	if (XFS_IS_GQUOTA_ON(sc->mp) &&
+	    (!ip->i_gdquot || ip->i_gdquot->q_id != i_gid_read(VFS_I(ip))))
+		return true;
+	if (XFS_IS_PQUOTA_ON(sc->mp) &&
+	    (!ip->i_pdquot || ip->i_pdquot->q_id != ip->i_projid))
+		return true;
+
+	return false;
+}
+
+/* Switch dquot, return dqtype if we need quotacheck */
+static xfs_dqtype_t
+xrep_inode_switch_dquot(
+	struct xfs_scrub	*sc,
+	xfs_dqtype_t		type,
+	struct xfs_dquot	**dqp)
+{
+	xfs_dqtype_t		ret = 0;
+	xfs_dqid_t		id = xfs_qm_id_for_quotatype(sc->ip, type);
+
+	if (*dqp != NULL && (*dqp)->q_id != id) {
+		xfs_qm_dqrele(*dqp);
+		*dqp = NULL;
+	}
+
+	if (!*dqp) {
+		xfs_qm_dqget_inode(sc->ip, type, true, dqp);
+		ret = type;
+	}
+	return ret;
+}
+
+static int
+xrep_inode_reset_dquots(
+	struct xfs_scrub	*sc)
+{
+	xfs_dqtype_t		need = 0;
+	int			error;
+
+	/*
+	 * If we changed the file IDs, then we need to drop the transaction so
+	 * that we can detach the dquots and attach new ones.
+	 *
+	 * Commit the scrub transaction so that there are no dangling
+	 * references to any dquots that might get detached, and retain the
+	 * ILOCK, as required by the dqattach code.
+	 *
+	 * Note that dqattach can cycle the ILOCK when creating a new dquot, so
+	 * this must be the very last thing that the repair function does.
+	 */
+	error = xrep_trans_commit(sc);
+	if (error)
+		return error;
+
+	if (XFS_IS_UQUOTA_ON(sc->mp))
+		need |= xrep_inode_switch_dquot(sc, XFS_DQTYPE_USER,
+				&sc->ip->i_udquot);
+	if (XFS_IS_GQUOTA_ON(sc->mp))
+		need |= xrep_inode_switch_dquot(sc, XFS_DQTYPE_GROUP,
+				&sc->ip->i_gdquot);
+	if (XFS_IS_PQUOTA_ON(sc->mp))
+		need |= xrep_inode_switch_dquot(sc, XFS_DQTYPE_PROJ,
+				&sc->ip->i_pdquot);
+
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+
+	/*
+	 * Now that we've updated the dquots, force quotacheck once again.
+	 * In theory we could be racing against a concurrent quotacheck.
+	 * Note that we can't hold the ILOCK when allocating a transaction.
+	 */
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+
+	if (need & XFS_DQTYPE_USER)
+		xrep_force_quotacheck(sc, XFS_DQTYPE_USER);
+	if (need & XFS_DQTYPE_GROUP)
+		xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
+	if (need & XFS_DQTYPE_PROJ)
+		xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
+
+	return 0;
+}
+#else
+# define xrep_inode_need_reset_dquots(sc)	(false)
+# define xrep_inode_reset_dquots(sc)		(0)
+#endif
+
 /* Repair an inode's fields. */
 int
 xrep_inode(
@@ -2129,5 +2252,13 @@ xrep_inode(
 	if (error)
 		return error;
 
-	return xrep_defer_finish(sc);
+	error = xrep_defer_finish(sc);
+	if (error)
+		return error;
+
+	/* Must come last */
+	if (xrep_inode_need_reset_dquots(sc))
+		return xrep_inode_reset_dquots(sc);
+
+	return 0;
 }


