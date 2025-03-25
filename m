Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094FF1D959B;
	Tue, 25 Mar 2025 12:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905688; cv=none; b=nlQH5f67any/lj/QhEbH6fietk8R8MzuvwYwgez06CKYNDo7BGW4tZRSu/OGRAnLeZRy+m50ERzortceeoUhu2V0XIvHWr3KjO798c5evpWsngpZAjPYncTLHiWu6zBdOqdUxqZOXjcRqdq1Mz4IoYsR4+m+OiAQxYFfjC9RDnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905688; c=relaxed/simple;
	bh=Gp5+iyj2pO1me/+I/zwk7JUWb2k6zPZBONmuSePc7HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHzJ7h2HOqBZ35uBVs6pXQRcyGnpyf4f4s5afztj+geRs2ba+++NPQlv8F5HJLSO2QLnIgUu0Ph00wQPEq2dFtjB8ydA2x9DebigAgku4qqZgbmVTvIlubC5ZCbukY6PffxBw1k0/0hvyaj3F0sFECZmz9aXD9UWsbL2LFv18fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHY6HK/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHY6HK/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4AFC4CEE4;
	Tue, 25 Mar 2025 12:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905687;
	bh=Gp5+iyj2pO1me/+I/zwk7JUWb2k6zPZBONmuSePc7HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHY6HK/RfFP+I1FMswNy4PUVrzuZU1CZvrP2xajqKM6JHB3skJA7e1ECqLSNgCsIV
	 VcboLx/F2sXJ4qaYGME2Miwdj9P5MQVHbNAjC2YM/zbFSb77IbDE4Hc4h1xb6MASL2
	 iiAYdDxs+/ItPsfdo4m8svfOA6hGsqLM7OMMFyyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 079/198] xfs: pass xfs_extent_free_item directly through the log intent code
Date: Tue, 25 Mar 2025 08:20:41 -0400
Message-ID: <20250325122158.713829157@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 72ba455599ad13d08c29dafa22a32360e07b1961 ]

Pass the incore xfs_extent_free_item through the EFI logging code
instead of repeatedly boxing and unboxing parameters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_extfree_item.c |   55 +++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -345,23 +345,30 @@ static int
 xfs_trans_free_extent(
 	struct xfs_trans		*tp,
 	struct xfs_efd_log_item		*efdp,
-	xfs_fsblock_t			start_block,
-	xfs_extlen_t			ext_len,
-	const struct xfs_owner_info	*oinfo,
-	bool				skip_discard)
+	struct xfs_extent_free_item	*free)
 {
+	struct xfs_owner_info		oinfo = { };
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent		*extp;
 	uint				next_extent;
-	xfs_agnumber_t			agno = XFS_FSB_TO_AGNO(mp, start_block);
+	xfs_agnumber_t			agno = XFS_FSB_TO_AGNO(mp,
+							free->xefi_startblock);
 	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp,
-								start_block);
+							free->xefi_startblock);
 	int				error;
 
-	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno, ext_len);
+	oinfo.oi_owner = free->xefi_owner;
+	if (free->xefi_flags & XFS_EFI_ATTR_FORK)
+		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
+	if (free->xefi_flags & XFS_EFI_BMBT_BLOCK)
+		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
+
+	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno,
+			free->xefi_blockcount);
 
-	error = __xfs_free_extent(tp, start_block, ext_len,
-				  oinfo, XFS_AG_RESV_NONE, skip_discard);
+	error = __xfs_free_extent(tp, free->xefi_startblock,
+			free->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
+			free->xefi_flags & XFS_EFI_SKIP_DISCARD);
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
@@ -375,8 +382,8 @@ xfs_trans_free_extent(
 	next_extent = efdp->efd_next_extent;
 	ASSERT(next_extent < efdp->efd_format.efd_nextents);
 	extp = &(efdp->efd_format.efd_extents[next_extent]);
-	extp->ext_start = start_block;
-	extp->ext_len = ext_len;
+	extp->ext_start = free->xefi_startblock;
+	extp->ext_len = free->xefi_blockcount;
 	efdp->efd_next_extent++;
 
 	return error;
@@ -463,20 +470,12 @@ xfs_extent_free_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_owner_info		oinfo = { };
 	struct xfs_extent_free_item	*free;
 	int				error;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	oinfo.oi_owner = free->xefi_owner;
-	if (free->xefi_flags & XFS_EFI_ATTR_FORK)
-		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
-	if (free->xefi_flags & XFS_EFI_BMBT_BLOCK)
-		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
-	error = xfs_trans_free_extent(tp, EFD_ITEM(done),
-			free->xefi_startblock,
-			free->xefi_blockcount,
-			&oinfo, free->xefi_flags & XFS_EFI_SKIP_DISCARD);
+
+	error = xfs_trans_free_extent(tp, EFD_ITEM(done), free);
 	kmem_cache_free(xfs_extfree_item_cache, free);
 	return error;
 }
@@ -599,7 +598,6 @@ xfs_efi_item_recover(
 	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_efd_log_item		*efdp;
 	struct xfs_trans		*tp;
-	struct xfs_extent		*extp;
 	int				i;
 	int				error = 0;
 
@@ -624,10 +622,17 @@ xfs_efi_item_recover(
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
 
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
+		struct xfs_extent_free_item	fake = {
+			.xefi_owner		= XFS_RMAP_OWN_UNKNOWN,
+		};
+		struct xfs_extent		*extp;
+
 		extp = &efip->efi_format.efi_extents[i];
-		error = xfs_trans_free_extent(tp, efdp, extp->ext_start,
-					      extp->ext_len,
-					      &XFS_RMAP_OINFO_ANY_OWNER, false);
+
+		fake.xefi_startblock = extp->ext_start;
+		fake.xefi_blockcount = extp->ext_len;
+
+		error = xfs_trans_free_extent(tp, efdp, &fake);
 		if (error == -EFSCORRUPTED)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					extp, sizeof(*extp));


