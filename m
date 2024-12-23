Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D542EAE6;
	Mon, 23 Dec 2024 16:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969686; cv=none; b=sqdrFJqu9X88Qw8zhU55tfEtD18r+2kayP3mNDNklp9RynYGidTMHU/XqcVQ5agsW074pUY6oIJiLMroTuJek502JEHVnKfCtY41hDD3YlfjUWUa/b8fUM2ku9U3k+NS8eM/wyyAQVPZuiMzRQorBoU+SazK1q2LmOXnHcKOALY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969686; c=relaxed/simple;
	bh=dqamgX0iWai1mMYUbIJT/qOcYTyFcONctN43hFdRr80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKXeR/I2I23AzGyAgg+KX7p0KiJr/yKdD1KCVCBvmd+SJGLnGLHkKbE+bb5KZ+jikNWzTsPDQBGz17DcvVJ2zDy3otIBSWxT3qKuqMADuHf32EM601uZX6CmEZTXS39viGEbayk2yyOTfxbUVBjEckd+t1WkyPa2wi7JqUtOc9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FR/wnEKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FR/wnEKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD336C4CED4;
	Mon, 23 Dec 2024 16:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969686;
	bh=dqamgX0iWai1mMYUbIJT/qOcYTyFcONctN43hFdRr80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FR/wnEKZtiS7Yc+JDaZRpkALVscO9DKQspQsG20FQrDQilwP2zN3LKnNhUNTTO4G3
	 3+mCHyaL9lrDnmOQir/2CJXs59QvcUgWEWamLDUOUv/c42oAYRF5RFM/pjDieCsN0U
	 p9s/pACG39TDYLwo89sCNbyKLXy+oCkotKcV68Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/160] xfs: fix sb_spino_align checks for large fsblock sizes
Date: Mon, 23 Dec 2024 16:57:17 +0100
Message-ID: <20241223155409.670040589@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 7f8a44f37229fc76bfcafa341a4b8862368ef44a upstream.

For a sparse inodes filesystem, mkfs.xfs computes the values of
sb_spino_align and sb_inoalignmt with the following code:

	int     cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;

	if (cfg->sb_feat.crcs_enabled)
		cluster_size *= cfg->inodesize / XFS_DINODE_MIN_SIZE;

	sbp->sb_spino_align = cluster_size >> cfg->blocklog;
	sbp->sb_inoalignmt = XFS_INODES_PER_CHUNK *
			cfg->inodesize >> cfg->blocklog;

On a V5 filesystem with 64k fsblocks and 512 byte inodes, this results
in cluster_size = 8192 * (512 / 256) = 16384.  As a result,
sb_spino_align and sb_inoalignmt are both set to zero.  Unfortunately,
this trips the new sb_spino_align check that was just added to
xfs_validate_sb_common, and the mkfs fails:

# mkfs.xfs -f -b size=64k, /dev/sda
meta-data=/dev/sda               isize=512    agcount=4, agsize=81136 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=0   metadir=0
data     =                       bsize=65536  blocks=324544, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=65536  ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=65536  blocks=5006, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=65536  blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 extents
Discarding blocks...Sparse inode alignment (0) is invalid.
Metadata corruption detected at 0x560ac5a80bbe, xfs_sb block 0x0/0x200
libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x1
mkfs.xfs: Releasing dirty buffer to free list!
found dirty buffer (bulk) on free list!
Sparse inode alignment (0) is invalid.
Metadata corruption detected at 0x560ac5a80bbe, xfs_sb block 0x0/0x200
libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x1
mkfs.xfs: writing AG headers failed, err=22

Prior to commit 59e43f5479cce1 this all worked fine, even if "sparse"
inodes are somewhat meaningless when everything fits in a single
fsblock.  Adjust the checks to handle existing filesystems.

Cc: <stable@vger.kernel.org> # v6.13-rc1
Fixes: 59e43f5479cce1 ("xfs: sb_spino_align is not verified")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 9e0ae312bc80..e27b63281d01 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -392,12 +392,13 @@ xfs_validate_sb_common(
 				return -EINVAL;
 			}
 
-			if (!sbp->sb_spino_align ||
-			    sbp->sb_spino_align > sbp->sb_inoalignmt ||
-			    (sbp->sb_inoalignmt % sbp->sb_spino_align) != 0) {
+			if (sbp->sb_spino_align &&
+			    (sbp->sb_spino_align > sbp->sb_inoalignmt ||
+			     (sbp->sb_inoalignmt % sbp->sb_spino_align) != 0)) {
 				xfs_warn(mp,
-				"Sparse inode alignment (%u) is invalid.",
-					sbp->sb_spino_align);
+"Sparse inode alignment (%u) is invalid, must be integer factor of (%u).",
+					sbp->sb_spino_align,
+					sbp->sb_inoalignmt);
 				return -EINVAL;
 			}
 		} else if (sbp->sb_spino_align) {
-- 
2.39.5



