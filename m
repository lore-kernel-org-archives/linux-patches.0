Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209258;
	b=Ge3lPvVaq1tX+FfVAkachCS114YPSONxYrK2cSgesQExF804dLv8gvz3qfnn+vUySTNk
	 T4pVP5Er+bkZJsRVwVZrNccviiqAZTi5qYRobw1TM4SqTUbDt3KqU9SkhCOzppwjDb8kD
	 UEvQL6UStxKOQh3nXspnSiCnXwM/SvOQEckvNzubwoJYyQ6qPX0Nv/Z92YNVUOOGkxkPi
	 mAgUu6mzeWsSvvfkEzBDS2Wg/nLl+aCn1VWIs30u+3ecanBZJ/I/EGcPjPw4kdTKVP2Nl
	 Q3BoJrzvhg2QD/DF9Lb0RkTDjEuBuTHDk07hFQ2aV/b4zKEO798cdaT83NSc3igwEBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rOoLDE0Nss4Iq6M3Obf/d32DM/WsvkRbOTaa19EMzgs=;
	b=awWMghyNOgNyy0uJb88sCm41fkkmbp8yCHktwfDmhk2VsOdNeIc9TzCuJW28iltsZGyw
	 ka/NiQsVf47+UpSSFwmSOaNMVLWZ1BJb9tNn1mYBkpFVhhaf/ovw/kLGQOD8/TMHdWN/e
	 WylOeF+kPP9htpLw4XN3x3+HIuRS/17feyYfefFmbPz496Ozb5o8r28d/UpkR3gIJQXC2
	 05uDot0OVh8tYdBd6J52k3kdJO415FR2I0dR+LYY3jojQxJv4T+HYJFHh+Vj0czHHvaCU
	 spx1Fk17aUQj48zrPcGpKJjbbrFUowgoV1JsfJJp/H9rW2RZImYes785HRDQJj+3bNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mtOQa6CJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC97606A31F;
	Wed, 28 Oct 2026 17:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mtOQa6CJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C361F01828;
	Wed, 28 Oct 2026 17:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209258;
	bh=rOoLDE0Nss4Iq6M3Obf/d32DM/WsvkRbOTaa19EMzgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mtOQa6CJTmhs9adG2HrYjMon+bJct8q1zr0X/02JyNHpRougHDeQKimVTG5hOW52o
	 kkc9KaCJzBTzyCjg0x3igOhI+ln/3+yUBq+i0iMUio7SFNsDmF7oLP8uOtQtZfFdT/
	 H//F9NCiB9ukfA/yGp/Rz1oqRWGeevn+qxFCEfzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 407/516] xfs: hoist recovered refcount intent checks out of xfs_cui_item_recover
Date: Wed, 28 Oct 2026 17:59:19 +0100
Message-ID: <20261028170013.126300361@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit ed64f8343aafa62e762c74dfb400f640b6fa6c15 ]

When we recover a refcount intent from the log, we need to validate its
contents before we try to replay them.  Hoist the checking code into a
separate function in preparation to refactor this code to use validation
helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_refcount_item.c | 59 ++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 0dee316283a90..83dddec08f3cc 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -417,6 +417,38 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.cancel_item	= xfs_refcount_update_cancel_item,
 };
 
+/* Is this recovered CUI ok? */
+static inline bool
+xfs_cui_validate_phys(
+	struct xfs_mount		*mp,
+	struct xfs_phys_extent		*refc)
+{
+	xfs_fsblock_t			startblock_fsb;
+	bool				op_ok;
+
+	startblock_fsb = XFS_BB_TO_FSB(mp,
+			   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
+	switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
+	case XFS_REFCOUNT_INCREASE:
+	case XFS_REFCOUNT_DECREASE:
+	case XFS_REFCOUNT_ALLOC_COW:
+	case XFS_REFCOUNT_FREE_COW:
+		op_ok = true;
+		break;
+	default:
+		op_ok = false;
+		break;
+	}
+	if (!op_ok || startblock_fsb == 0 ||
+	    refc->pe_len == 0 ||
+	    startblock_fsb >= mp->m_sb.sb_dblocks ||
+	    refc->pe_len >= mp->m_sb.sb_agblocks ||
+	    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
+		return false;
+
+	return true;
+}
+
 /*
  * Process a refcount update intent item that was recovered from the log.
  * We need to update the refcountbt.
@@ -433,11 +465,9 @@ xfs_cui_item_recover(
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
 	struct xfs_mount		*mp = lip->li_mountp;
-	xfs_fsblock_t			startblock_fsb;
 	xfs_fsblock_t			new_fsb;
 	xfs_extlen_t			new_len;
 	unsigned int			refc_type;
-	bool				op_ok;
 	bool				requeue_only = false;
 	enum xfs_refcount_intent_type	type;
 	int				i;
@@ -449,26 +479,13 @@ xfs_cui_item_recover(
 	 * just toss the CUI.
 	 */
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
-		refc = &cuip->cui_format.cui_extents[i];
-		startblock_fsb = XFS_BB_TO_FSB(mp,
-				   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
-		switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
-		case XFS_REFCOUNT_INCREASE:
-		case XFS_REFCOUNT_DECREASE:
-		case XFS_REFCOUNT_ALLOC_COW:
-		case XFS_REFCOUNT_FREE_COW:
-			op_ok = true;
-			break;
-		default:
-			op_ok = false;
-			break;
-		}
-		if (!op_ok || startblock_fsb == 0 ||
-		    refc->pe_len == 0 ||
-		    startblock_fsb >= mp->m_sb.sb_dblocks ||
-		    refc->pe_len >= mp->m_sb.sb_agblocks ||
-		    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
+		if (!xfs_cui_validate_phys(mp,
+					&cuip->cui_format.cui_extents[i])) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					&cuip->cui_format,
+					sizeof(cuip->cui_format));
 			return -EFSCORRUPTED;
+		}
 	}
 
 	/*
-- 
2.53.0



