Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0532266593;
	Tue, 25 Mar 2025 12:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905640; cv=none; b=i9yhvJ6iqgR9Rd8yCaroAD4fo4Zg5g0nbHMPqMh1SkB78Vp8hPJj9eWC7P5Yyot8hysaHx3ex4spg/FpSyPrUR7ow83bnmp58zJ0T/zCeJedi/lSSUq/Tc4WfYb13hbyH7qB4hkn2ggU7eN7oHBV/byKtDtTs3EEQFvIWBB4YaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905640; c=relaxed/simple;
	bh=IWNUFybnnDSZEkb42UF6y+PecH8LX3bwJ/vatSgvetY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0JKQrPedgE4Av/G89VLETJGR6/7Lp1OOJdz8xdqmDhj18G4zPIvdpk7j1BETKlprGH1M9YC7w8N7yljcAL8Awqc3wcbcga82/8c7Zj1j8QmJuXfdZOenivRjBXK9TT7+jFSAevZR/pugqshq/cLueFEYOlvjNBY/qWh2nRJsqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Osd0bycE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Osd0bycE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27DCC4CEE9;
	Tue, 25 Mar 2025 12:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905639;
	bh=IWNUFybnnDSZEkb42UF6y+PecH8LX3bwJ/vatSgvetY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Osd0bycEqWpNf9z547EW1Jj81I9RbVSVt5OFlWC5WryuCphgQ5sA1Zo9BX3LmTj0N
	 klMGB1mAD6SDcxz178PucRv998Dbx2MH9xG4/GEzH5wXbJfIl+fFKMiQEnEKlFRcmg
	 4wpuiwzAknJJoVCvZzXd2T3zoJKXa9Wm9GOX0qHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 084/198] xfs: fix bounds check in xfs_defer_agfl_block()
Date: Tue, 25 Mar 2025 08:20:46 -0400
Message-ID: <20250325122158.847035604@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 2bed0d82c2f78b91a0a9a5a73da57ee883a0c070 ]

Need to happen before we allocate and then leak the xefi. Found by
coverity via an xfsprogs libxfs scan.

[djwong: This also fixes the type of the @agbno argument.]

Fixes: 7dfee17b13e5 ("xfs: validate block number being freed before adding to xefi")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2489,24 +2489,25 @@ static int
 xfs_defer_agfl_block(
 	struct xfs_trans		*tp,
 	xfs_agnumber_t			agno,
-	xfs_fsblock_t			agbno,
+	xfs_agblock_t			agbno,
 	struct xfs_owner_info		*oinfo)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent_free_item	*xefi;
+	xfs_fsblock_t			fsbno = XFS_AGB_TO_FSB(mp, agno, agbno);
 
 	ASSERT(xfs_extfree_item_cache != NULL);
 	ASSERT(oinfo != NULL);
 
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, fsbno)))
+		return -EFSCORRUPTED;
+
 	xefi = kmem_cache_zalloc(xfs_extfree_item_cache,
 			       GFP_KERNEL | __GFP_NOFAIL);
-	xefi->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
+	xefi->xefi_startblock = fsbno;
 	xefi->xefi_blockcount = 1;
 	xefi->xefi_owner = oinfo->oi_owner;
 
-	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, xefi->xefi_startblock)))
-		return -EFSCORRUPTED;
-
 	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
 
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &xefi->xefi_list);


