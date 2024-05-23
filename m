Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881EC13BAE2;
	Thu, 23 May 2024 13:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470374; cv=none; b=K9/ZWfeCT2yTjxsEYmyd6rAV5B5Qcx9fWTSmPqJ2CudvY0jP4cEsvo29hRT3eci3GCnh8N3fKFk70X4AupUn7Oqcprxck1kTGaHgO0kxAg+90xYPnhEslsGswesd5tUiSXoYq2sABdqWoIUFvCUvBwzb59/Vf9I1OuKIg2FmhBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470374; c=relaxed/simple;
	bh=xiQGoUdFglFYGX28XC9yuQkEyeEdckBwGlk5F4ozfXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6R5CaIbKADHkPbFKfx730rlk0Vw0oPLVjclpiBcAHQfIWustlUvbsTcUIf65DdxB5pLi+UFpDoLOkGhRVlTLAK2v+TtkIdAXu9L/hrA2ridfq7OlIFZsjLsSrp1iGw4pHAX1S75uHclODc8Dva/icctP3QxErBXWELryIlz/Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7+yCKc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7+yCKc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10251C2BD10;
	Thu, 23 May 2024 13:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470374;
	bh=xiQGoUdFglFYGX28XC9yuQkEyeEdckBwGlk5F4ozfXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7+yCKc9GJw447SZPfPyCtRwYzN4vK+O03pyN6NwVxdwBR2RNqUn0UBRRV5pS/F/W
	 5Jeiw8lFMCW4VcMoMexasSCNVWakNnYJQVNro3q/EiptJU27Foy5t7U2Zh5u71+nxr
	 N0r0WrswIaZDemAw5t29SYK+JJC7UOfHonzsZZLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 15/45] xfs: xfs_bmap_punch_delalloc_range() should take a byte range
Date: Thu, 23 May 2024 15:13:06 +0200
Message-ID: <20240523130333.068307510@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 7348b322332d8602a4133f0b861334ea021b134a ]

All the callers of xfs_bmap_punch_delalloc_range() jump through
hoops to convert a byte range to filesystem blocks before calling
xfs_bmap_punch_delalloc_range(). Instead, pass the byte range to
xfs_bmap_punch_delalloc_range() and have it do the conversion to
filesystem blocks internally.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_aops.c      |   16 ++++++----------
 fs/xfs/xfs_bmap_util.c |   10 ++++++----
 fs/xfs/xfs_bmap_util.h |    2 +-
 fs/xfs/xfs_iomap.c     |    8 ++------
 4 files changed, 15 insertions(+), 21 deletions(-)

--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -114,9 +114,8 @@ xfs_end_ioend(
 	if (unlikely(error)) {
 		if (ioend->io_flags & IOMAP_F_SHARED) {
 			xfs_reflink_cancel_cow_range(ip, offset, size, true);
-			xfs_bmap_punch_delalloc_range(ip,
-						      XFS_B_TO_FSBT(mp, offset),
-						      XFS_B_TO_FSB(mp, size));
+			xfs_bmap_punch_delalloc_range(ip, offset,
+					offset + size);
 		}
 		goto done;
 	}
@@ -455,12 +454,8 @@ xfs_discard_folio(
 	struct folio		*folio,
 	loff_t			pos)
 {
-	struct inode		*inode = folio->mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_inode	*ip = XFS_I(folio->mapping->host);
 	struct xfs_mount	*mp = ip->i_mount;
-	size_t			offset = offset_in_folio(folio, pos);
-	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, pos);
-	xfs_fileoff_t		pageoff_fsb = XFS_B_TO_FSBT(mp, offset);
 	int			error;
 
 	if (xfs_is_shutdown(mp))
@@ -470,8 +465,9 @@ xfs_discard_folio(
 		"page discard on page "PTR_FMT", inode 0x%llx, pos %llu.",
 			folio, ip->i_ino, pos);
 
-	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
-			i_blocks_per_folio(inode, folio) - pageoff_fsb);
+	error = xfs_bmap_punch_delalloc_range(ip, pos,
+			round_up(pos, folio_size(folio)));
+
 	if (error && !xfs_is_shutdown(mp))
 		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
 }
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -590,11 +590,13 @@ out_unlock_iolock:
 int
 xfs_bmap_punch_delalloc_range(
 	struct xfs_inode	*ip,
-	xfs_fileoff_t		start_fsb,
-	xfs_fileoff_t		length)
+	xfs_off_t		start_byte,
+	xfs_off_t		end_byte)
 {
+	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = &ip->i_df;
-	xfs_fileoff_t		end_fsb = start_fsb + length;
+	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, start_byte);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end_byte);
 	struct xfs_bmbt_irec	got, del;
 	struct xfs_iext_cursor	icur;
 	int			error = 0;
@@ -607,7 +609,7 @@ xfs_bmap_punch_delalloc_range(
 
 	while (got.br_startoff + got.br_blockcount > start_fsb) {
 		del = got;
-		xfs_trim_extent(&del, start_fsb, length);
+		xfs_trim_extent(&del, start_fsb, end_fsb - start_fsb);
 
 		/*
 		 * A delete can push the cursor forward. Step back to the
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -31,7 +31,7 @@ xfs_bmap_rtalloc(struct xfs_bmalloca *ap
 #endif /* CONFIG_XFS_RT */
 
 int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
-		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
+		xfs_off_t start_byte, xfs_off_t end_byte);
 
 struct kgetbmap {
 	__s64		bmv_offset;	/* file offset of segment in blocks */
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1126,12 +1126,8 @@ xfs_buffered_write_delalloc_punch(
 	loff_t			offset,
 	loff_t			length)
 {
-	struct xfs_mount	*mp = XFS_M(inode->i_sb);
-	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, offset);
-	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + length);
-
-	return xfs_bmap_punch_delalloc_range(XFS_I(inode), start_fsb,
-				end_fsb - start_fsb);
+	return xfs_bmap_punch_delalloc_range(XFS_I(inode), offset,
+			offset + length);
 }
 
 static int


