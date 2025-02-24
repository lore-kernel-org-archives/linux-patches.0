Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132C218A6C5;
	Mon, 24 Feb 2025 14:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407803; cv=none; b=bCbHEvZpkYwweBzm6pdeLs+g57zen1954lWsk1t2q/j5mscigr2ULIvcdD5bVUW6QJtpc6oskZXtFP8mzTWM2Q7PLbGdC02kI16aPwIV79wq7P4iMnOSiO46k1Olyae1WzZApz/DzGlV0Tnk5JzncrQW2kSBijzNevrKLSWJ/FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407803; c=relaxed/simple;
	bh=qU5HrH2r33ezbco8TMWgz2HVUtUfXRRGXM1gjxKScDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adiN+gH/k6FeFslDdeuDXgdidz5t0krMqw++2LGCT7VVj3MIB0ceWnIOxpjG0lD3fA5hzE/CF/xvOHRvwlGw5PUSwoeIDrwN/QcGDL2kybAs5wqFEqE+gbHs1ufRhKFUFqtGi8NUEo4qDF5Uczi5aGrk4DrJT4sfiLNqlJeaQkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ixqU29Ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ixqU29Ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9BDC4CED6;
	Mon, 24 Feb 2025 14:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407802;
	bh=qU5HrH2r33ezbco8TMWgz2HVUtUfXRRGXM1gjxKScDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixqU29OtNZRkaLExt9t8oJQD7teno5Ttc9B5cCAJSzWNCDB3DC1zQYrl8i0B8sLuJ
	 Mgel8anwxIuE1uf+ASGpcoiZx77U+X1aqhGKcUNp6uWnBRkrlp5M+eUKkyFAJDCH4o
	 zBfSpF0BpJpfLITfvmyplREYAFyUO0dpg/tX0eN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 014/140] xfs: call xfs_bmap_exact_minlen_extent_alloc from xfs_bmap_btalloc
Date: Mon, 24 Feb 2025 15:33:33 +0100
Message-ID: <20250224142603.569830545@linuxfoundation.org>
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

commit 405ee87c6938f67e6ab62a3f8f85b3c60a093886 upstream.

[backport: dependency of 6aac770]

xfs_bmap_exact_minlen_extent_alloc duplicates the args setup in
xfs_bmap_btalloc.  Switch to call it from xfs_bmap_btalloc after
doing the basic setup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   61 ++++++++++-------------------------------------
 1 file changed, 13 insertions(+), 48 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3390,28 +3390,17 @@ xfs_bmap_process_allocated_extent(
 
 static int
 xfs_bmap_exact_minlen_extent_alloc(
-	struct xfs_bmalloca	*ap)
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args)
 {
-	struct xfs_mount	*mp = ap->ip->i_mount;
-	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
-	xfs_fileoff_t		orig_offset;
-	xfs_extlen_t		orig_length;
-	int			error;
-
-	ASSERT(ap->length);
-
 	if (ap->minlen != 1) {
-		ap->blkno = NULLFSBLOCK;
-		ap->length = 0;
+		args->fsbno = NULLFSBLOCK;
 		return 0;
 	}
 
-	orig_offset = ap->offset;
-	orig_length = ap->length;
-
-	args.alloc_minlen_only = 1;
-
-	xfs_bmap_compute_alignments(ap, &args);
+	args->alloc_minlen_only = 1;
+	args->minlen = args->maxlen = ap->minlen;
+	args->total = ap->total;
 
 	/*
 	 * Unlike the longest extent available in an AG, we don't track
@@ -3421,33 +3410,9 @@ xfs_bmap_exact_minlen_extent_alloc(
 	 * we need not be concerned about a drop in performance in
 	 * "debug only" code paths.
 	 */
-	ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
-
-	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
-	args.minlen = args.maxlen = ap->minlen;
-	args.total = ap->total;
+	ap->blkno = XFS_AGB_TO_FSB(ap->ip->i_mount, 0, 0);
 
-	args.alignment = 1;
-	args.minalignslop = 0;
-
-	args.minleft = ap->minleft;
-	args.wasdel = ap->wasdel;
-	args.resv = XFS_AG_RESV_NONE;
-	args.datatype = ap->datatype;
-
-	error = xfs_alloc_vextent_first_ag(&args, ap->blkno);
-	if (error)
-		return error;
-
-	if (args.fsbno != NULLFSBLOCK) {
-		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
-			orig_length);
-	} else {
-		ap->blkno = NULLFSBLOCK;
-		ap->length = 0;
-	}
-
-	return 0;
+	return xfs_alloc_vextent_first_ag(args, ap->blkno);
 }
 
 /*
@@ -3706,8 +3671,11 @@ xfs_bmap_btalloc(
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = min(ap->length, mp->m_ag_max_usable);
 
-	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-	    xfs_inode_is_filestream(ap->ip))
+	if (unlikely(XFS_TEST_ERROR(false, mp,
+			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
+		error = xfs_bmap_exact_minlen_extent_alloc(ap, &args);
+	else if ((ap->datatype & XFS_ALLOC_USERDATA) &&
+			xfs_inode_is_filestream(ap->ip))
 		error = xfs_bmap_btalloc_filestreams(ap, &args, stripe_align);
 	else
 		error = xfs_bmap_btalloc_best_length(ap, &args, stripe_align);
@@ -4128,9 +4096,6 @@ xfs_bmapi_allocate(
 	if ((bma->datatype & XFS_ALLOC_USERDATA) &&
 	    XFS_IS_REALTIME_INODE(bma->ip))
 		error = xfs_bmap_rtalloc(bma);
-	else if (unlikely(XFS_TEST_ERROR(false, mp,
-			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
-		error = xfs_bmap_exact_minlen_extent_alloc(bma);
 	else
 		error = xfs_bmap_btalloc(bma);
 	if (error)


