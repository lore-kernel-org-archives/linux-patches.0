Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA6418C01D;
	Mon, 24 Feb 2025 14:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407796; cv=none; b=FOywuhnT80hFwelO+G8mTyb0l69psEbD1T78nbzHu0tcRvBZEdaMI1fBojcy7/iwQR3NRQSmn5/IWPk9gGGHkwmrY2/GekbEZssrJLJp/Hkia3yUiT9LU9TE1sj30eOT9KcW/UYeZIKtlJxEmQvX1mK4UIc8+uSmJ2YUpTEZuO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407796; c=relaxed/simple;
	bh=a+/Hz9Pa8vi5xXlpkV4jlax9017fnP/ZQS0M4KB6KbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1sJ3cgDQzYYSUH6s5RGcH8uvb/iiKP9iB9S/cn1mXZnOsOz9W8Ai7oLCy1C+2BPhBVUyJQT66mHC4E8vMSuKii+pUextn0C1Ub4wdsYiuix07qU6U9rTgugdIGPEzjsBAsnfoJNnIBcvugWbxnM0PzQN2ghZXcqCtIWUXZWHdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkH9oj2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkH9oj2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAFAC4CEE9;
	Mon, 24 Feb 2025 14:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407795;
	bh=a+/Hz9Pa8vi5xXlpkV4jlax9017fnP/ZQS0M4KB6KbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wkH9oj2xRfefuw9QaYVwB4PV8WveCaFEItTYE+YIKfty/C4dVCefqoxpW5tVtBwIr
	 3rlb3m0v70Vy4t4s0rpLaKYZFJzeyHqj5nSvguRdMnYsAsBCt/EaPP9Ub0oAnkFHnt
	 vf2I2tgHMTskj7NqYnJSj6Pdqxalx4Mb1prjWDJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 012/140] xfs: fold xfs_bmap_alloc_userdata into xfs_bmapi_allocate
Date: Mon, 24 Feb 2025 15:33:31 +0100
Message-ID: <20250224142603.493237057@linuxfoundation.org>
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

commit 865469cd41bce2b04bef9539cbf70676878bc8df upstream.

[backport: dependency of 6aac770]

Userdata and metadata allocations end up in the same allocation helpers.
Remove the separate xfs_bmap_alloc_userdata function to make this more
clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   73 ++++++++++++++++++-----------------------------
 1 file changed, 28 insertions(+), 45 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4078,43 +4078,6 @@ out:
 }
 
 static int
-xfs_bmap_alloc_userdata(
-	struct xfs_bmalloca	*bma)
-{
-	struct xfs_mount	*mp = bma->ip->i_mount;
-	int			whichfork = xfs_bmapi_whichfork(bma->flags);
-	int			error;
-
-	/*
-	 * Set the data type being allocated. For the data fork, the first data
-	 * in the file is treated differently to all other allocations. For the
-	 * attribute fork, we only need to ensure the allocated range is not on
-	 * the busy list.
-	 */
-	bma->datatype = XFS_ALLOC_NOBUSY;
-	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
-		bma->datatype |= XFS_ALLOC_USERDATA;
-		if (bma->offset == 0)
-			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
-
-		if (mp->m_dalign && bma->length >= mp->m_dalign) {
-			error = xfs_bmap_isaeof(bma, whichfork);
-			if (error)
-				return error;
-		}
-
-		if (XFS_IS_REALTIME_INODE(bma->ip))
-			return xfs_bmap_rtalloc(bma);
-	}
-
-	if (unlikely(XFS_TEST_ERROR(false, mp,
-			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
-		return xfs_bmap_exact_minlen_extent_alloc(bma);
-
-	return xfs_bmap_btalloc(bma);
-}
-
-static int
 xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
 {
@@ -4147,15 +4110,35 @@ xfs_bmapi_allocate(
 	else
 		bma->minlen = 1;
 
-	if (bma->flags & XFS_BMAPI_METADATA) {
-		if (unlikely(XFS_TEST_ERROR(false, mp,
-				XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
-			error = xfs_bmap_exact_minlen_extent_alloc(bma);
-		else
-			error = xfs_bmap_btalloc(bma);
-	} else {
-		error = xfs_bmap_alloc_userdata(bma);
+	if (!(bma->flags & XFS_BMAPI_METADATA)) {
+		/*
+		 * For the data and COW fork, the first data in the file is
+		 * treated differently to all other allocations. For the
+		 * attribute fork, we only need to ensure the allocated range
+		 * is not on the busy list.
+		 */
+		bma->datatype = XFS_ALLOC_NOBUSY;
+		if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
+			bma->datatype |= XFS_ALLOC_USERDATA;
+			if (bma->offset == 0)
+				bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
+
+			if (mp->m_dalign && bma->length >= mp->m_dalign) {
+				error = xfs_bmap_isaeof(bma, whichfork);
+				if (error)
+					return error;
+			}
+		}
 	}
+
+	if ((bma->datatype & XFS_ALLOC_USERDATA) &&
+	    XFS_IS_REALTIME_INODE(bma->ip))
+		error = xfs_bmap_rtalloc(bma);
+	else if (unlikely(XFS_TEST_ERROR(false, mp,
+			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
+		error = xfs_bmap_exact_minlen_extent_alloc(bma);
+	else
+		error = xfs_bmap_btalloc(bma);
 	if (error)
 		return error;
 	if (bma->blkno == NULLFSBLOCK)


