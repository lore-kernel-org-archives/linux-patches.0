Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209253;
	b=EPz9cSilcf6uGgqCx3OXZ+UKbLvWevlwunvDIo/4oERk1ExStLw0diDUwSI0J3rTHe09
	 b0cN4DYPyslvgAkfUKDkJ9ZqxJyie5poNaNyRvHffxPGpKDM8xe8ge2R6I6h1VW4vbGPK
	 R+MLqs2LQZmrJQFmgnvhzF5iIK+3IEUK+b91SHCpTtT6Th4FJOsntDXXn8a0AidJ3kvKJ
	 tOHnCprItmsh+E8tQ7hhbLJi9OoKkyOsV0X73zhmpskmeFNZ3k71ICqf7SkTcJycCZ92H
	 RHkAQFIku0qG43ZIkg93ofObfYFy3ml3bTn/AuZbrURcOm3MkuaXGcQ2/l6azOpIcvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IcaKnIn/0BBw//KXfgukFC7yU3W1GURI3dBEMDEZh7Y=;
	b=JAeK/rGyTcndhEnnLTHr/AhxCGJZbEvTB9u1OLqIFBGTmd9xGu7epsYllLfOfbJqQQQw
	 eIFYZGYHygIYOQ1wfmBLgB/ganZ5QZXkh1Bi+5qViAKY7MDX5fivd5ttO1UJoqcV+S9Jv
	 ED3LfmxES8RAPona21mt2l9WCQzmvIKv/6BZtrRjObl8ZnhyRPudg7yYK3kxkeceW6BBM
	 oeWVttSX1Z1BZtmVsE/88gd7/tCZmEevoQFZ5pDjoMkfVc57juE1KgJ+clqVbWIGAbCZ4
	 bd5zKRJZGBKi7uP4LBt7UgolAL9lyW0RSx4Fml0d26eon8T1X0kc36O+Cf0umcXrBaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DnHNGZ32;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5647606A31C;
	Wed, 28 Oct 2026 17:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DnHNGZ32
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD481F01825;
	Wed, 28 Oct 2026 17:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209252;
	bh=IcaKnIn/0BBw//KXfgukFC7yU3W1GURI3dBEMDEZh7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DnHNGZ32fyV0BItdktOFcENXz8xUxIfIhUGWmOBE0AHfoNN78PEcqTa14UfSpsqCz
	 EntKLRU4ydir/BzwT+uY+PyN1gJ67FBUttR4A+gOIV0YGy9LJ6F5hN97U+0iNvWgp2
	 /AT1uWCpnmIRTMbO1eHOgA2f5r3dbdOAqb/QJ9wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 405/516] xfs: hoist recovered rmap intent checks out of xfs_rui_item_recover
Date: Wed, 28 Oct 2026 17:59:17 +0100
Message-ID: <20261028170013.075770677@linuxfoundation.org>
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

[ Upstream commit dda7ba65bf03b6f3a7502b9f85c2524a5ae5aa2e ]

When we recover a rmap intent from the log, we need to validate its
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
 fs/xfs/xfs_rmap_item.c | 67 ++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 20905953fe763..31cfd734962fd 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -460,6 +460,42 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 	.cancel_item	= xfs_rmap_update_cancel_item,
 };
 
+/* Is this recovered RUI ok? */
+static inline bool
+xfs_rui_validate_map(
+	struct xfs_mount		*mp,
+	struct xfs_map_extent		*rmap)
+{
+	xfs_fsblock_t			startblock_fsb;
+	bool				op_ok;
+
+	startblock_fsb = XFS_BB_TO_FSB(mp,
+			   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
+	switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
+	case XFS_RMAP_EXTENT_MAP:
+	case XFS_RMAP_EXTENT_MAP_SHARED:
+	case XFS_RMAP_EXTENT_UNMAP:
+	case XFS_RMAP_EXTENT_UNMAP_SHARED:
+	case XFS_RMAP_EXTENT_CONVERT:
+	case XFS_RMAP_EXTENT_CONVERT_SHARED:
+	case XFS_RMAP_EXTENT_ALLOC:
+	case XFS_RMAP_EXTENT_FREE:
+		op_ok = true;
+		break;
+	default:
+		op_ok = false;
+		break;
+	}
+	if (!op_ok || startblock_fsb == 0 ||
+	    rmap->me_len == 0 ||
+	    startblock_fsb >= mp->m_sb.sb_dblocks ||
+	    rmap->me_len >= mp->m_sb.sb_agblocks ||
+	    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
+		return false;
+
+	return true;
+}
+
 /*
  * Process an rmap update intent item that was recovered from the log.
  * We need to update the rmapbt.
@@ -475,10 +511,8 @@ xfs_rui_item_recover(
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
 	struct xfs_mount		*mp = lip->li_mountp;
-	xfs_fsblock_t			startblock_fsb;
 	enum xfs_rmap_intent_type	type;
 	xfs_exntst_t			state;
-	bool				op_ok;
 	int				i;
 	int				whichfork;
 	int				error = 0;
@@ -489,30 +523,13 @@ xfs_rui_item_recover(
 	 * just toss the RUI.
 	 */
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
-		rmap = &ruip->rui_format.rui_extents[i];
-		startblock_fsb = XFS_BB_TO_FSB(mp,
-				   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
-		switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
-		case XFS_RMAP_EXTENT_MAP:
-		case XFS_RMAP_EXTENT_MAP_SHARED:
-		case XFS_RMAP_EXTENT_UNMAP:
-		case XFS_RMAP_EXTENT_UNMAP_SHARED:
-		case XFS_RMAP_EXTENT_CONVERT:
-		case XFS_RMAP_EXTENT_CONVERT_SHARED:
-		case XFS_RMAP_EXTENT_ALLOC:
-		case XFS_RMAP_EXTENT_FREE:
-			op_ok = true;
-			break;
-		default:
-			op_ok = false;
-			break;
-		}
-		if (!op_ok || startblock_fsb == 0 ||
-		    rmap->me_len == 0 ||
-		    startblock_fsb >= mp->m_sb.sb_dblocks ||
-		    rmap->me_len >= mp->m_sb.sb_agblocks ||
-		    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
+		if (!xfs_rui_validate_map(mp,
+					&ruip->rui_format.rui_extents[i])) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					&ruip->rui_format,
+					sizeof(ruip->rui_format));
 			return -EFSCORRUPTED;
+		}
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-- 
2.53.0



