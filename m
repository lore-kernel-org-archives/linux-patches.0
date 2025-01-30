Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002FD1E522;
	Thu, 30 Jan 2025 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247379; cv=none; b=cIaByLF8ViORfkJyln7JyDZkn12GV2Gva1vAKs1jkoaEGF7O76R+ByGQrPyrCckoMAufmTQ8cdOwU2+w0nIKNZHP0Pg8kF92DIx4vQ2FThe7HJ1NLrJJEkjVpJfQJd5RQha5fxXldRihleMi+1PC+Gogg9pNykrtnWb6j1XgtWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247379; c=relaxed/simple;
	bh=H7WZCGQ8O29NIKtByRsKSSLOwefeeMJoO5WE/OHvwfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vp2ay813OSfyRZptNjBBEYn5dkmDc9TbJTsfX0hF9Asztd5xqNVRkclx/2KNYrtWNO/YbgWNBRl+kpxuPFKP7nlRfrnKguIhAes4mzU5A9fUhzrHR8/eTyavI4IWVdaDPDSfS1NNpEseWH28fBc8DwMfsNYS4LlfFqMzcq7f0Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKUJLD6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKUJLD6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F001C4CED2;
	Thu, 30 Jan 2025 14:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247378;
	bh=H7WZCGQ8O29NIKtByRsKSSLOwefeeMJoO5WE/OHvwfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKUJLD6zoNVqdhsE2r6O8H8WQK7FTzY6QRmQCQw+0DDtcgpilLl4s5WdaFfjvjsxa
	 gSVZxhtJF1dkxMJNNyPOEaKmNBVrWrdq2Wl0wgsSg3CP7qMgKRdnMzXCDyKT7BPgME
	 lrgKZazwfZHIlrN5LVyL8o1eX/hsOFvpIP+FedXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 19/49] xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space
Date: Thu, 30 Jan 2025 15:01:55 +0100
Message-ID: <20250130140134.611180323@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 35dc55b9e80cb9ec4bcb969302000b002b2ed850 ]

If xfs_bmapi_write finds a delalloc extent at the requested range, it
tries to convert the entire delalloc extent to a real allocation.

But if the allocator cannot find a single free extent large enough to
cover the start block of the requested range, xfs_bmapi_write will
return 0 but leave *nimaps set to 0.

In that case we simply need to keep looping with the same startoffset_fsb
so that one of the following allocations will eventually reach the
requested range.

Note that this could affect any caller of xfs_bmapi_write that covers
an existing delayed allocation.  As far as I can tell we do not have
any other such caller, though - the regular writeback path uses
xfs_bmapi_convert_delalloc to convert delayed allocations to real ones,
and direct I/O invalidates the page cache first.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_bmap_util.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -780,12 +780,10 @@ xfs_alloc_file_space(
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_off_t		count;
-	xfs_filblks_t		allocated_fsb;
 	xfs_filblks_t		allocatesize_fsb;
 	xfs_extlen_t		extsz, temp;
 	xfs_fileoff_t		startoffset_fsb;
 	xfs_fileoff_t		endoffset_fsb;
-	int			nimaps;
 	int			rt;
 	xfs_trans_t		*tp;
 	xfs_bmbt_irec_t		imaps[1], *imapp;
@@ -808,7 +806,6 @@ xfs_alloc_file_space(
 
 	count = len;
 	imapp = &imaps[0];
-	nimaps = 1;
 	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
 	endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
 	allocatesize_fsb = endoffset_fsb - startoffset_fsb;
@@ -819,6 +816,7 @@ xfs_alloc_file_space(
 	while (allocatesize_fsb && !error) {
 		xfs_fileoff_t	s, e;
 		unsigned int	dblocks, rblocks, resblks;
+		int		nimaps = 1;
 
 		/*
 		 * Determine space reservations for data/realtime.
@@ -884,15 +882,19 @@ xfs_alloc_file_space(
 		if (error)
 			break;
 
-		allocated_fsb = imapp->br_blockcount;
-
-		if (nimaps == 0) {
-			error = -ENOSPC;
-			break;
+		/*
+		 * If the allocator cannot find a single free extent large
+		 * enough to cover the start block of the requested range,
+		 * xfs_bmapi_write will return 0 but leave *nimaps set to 0.
+		 *
+		 * In that case we simply need to keep looping with the same
+		 * startoffset_fsb so that one of the following allocations
+		 * will eventually reach the requested range.
+		 */
+		if (nimaps) {
+			startoffset_fsb += imapp->br_blockcount;
+			allocatesize_fsb -= imapp->br_blockcount;
 		}
-
-		startoffset_fsb += allocated_fsb;
-		allocatesize_fsb -= allocated_fsb;
 	}
 
 	return error;


