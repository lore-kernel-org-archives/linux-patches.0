Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962415FF12;
	Tue, 13 Feb 2024 17:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845244; cv=none; b=cirfMeKGK0ViTwjOJOxijpBjd0+Iy1b76PgTwe+IqZkT52pD6mfY4qxnqdDg5xlpkXEU/D3P+/viQDYYbin/C22B8jMHatXpzHOoW/MUNTHQ0iQpgs4BcX3VITI55paZ+W4RDM7PmJy7lSlIFS3Muh2TdxEw46G7P4aqgMf29MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845244; c=relaxed/simple;
	bh=9OslwH+tBhdWncIckbtd8P6S8Y1E4BgtwJoCPKy26Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYxyXec/FDpO6yTxE62qPruofApXjtxrcqr17Rb2irHvL9orWClC6JGRx/OWFYM8T3H6d62bJd9iI+cgYfFYJqTowBtdvywwC2gMM80Dj6vbg7jnzGPCUBuM3FfRAALHZOsAP6ph2dHihNEImlpcJw9QBtoKsLOhiNMRVdnW9LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vQLGRLa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vQLGRLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99814C433F1;
	Tue, 13 Feb 2024 17:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845244;
	bh=9OslwH+tBhdWncIckbtd8P6S8Y1E4BgtwJoCPKy26Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vQLGRLarz9i83HGBr3ayI9RT7y/NdkjKNeBSiM7Dn4VRiAvE9WyVVPI1Ca76NDWM
	 oP7dQ6fvHI6kq8PqWDeWmthCVnWL8bHAjv7scHfUd2k0mvkUl+gG4iNsQKu35lS518
	 BtMP0IGm3skDANTXNq34ZZzy2BdrkJP7eW1SEnnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/121] xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space
Date: Tue, 13 Feb 2024 18:20:34 +0100
Message-ID: <20240213171853.708656268@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 35dc55b9e80cb9ec4bcb969302000b002b2ed850 upstream.

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
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fcefab687285..ad4aba5002c1 100644
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
-- 
2.43.0



