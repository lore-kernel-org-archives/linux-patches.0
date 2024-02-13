Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7284E5F54E;
	Tue, 13 Feb 2024 17:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845331; cv=none; b=YQA1yKVOdqQniD6BO1XttQH9tckp9hzUKaa5nzYV+fSg4YqewsN0TqfhAQgBBflzmtP1oeLtkUqESoAYIwF+9aV1jmIGyVNv20hkPkDNS84X730uIhZ6iZSdgb2R37yZs0AJfFHKyAH+7kE4fcW3ubEOCw6vFhJU4RV+7OhsxYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845331; c=relaxed/simple;
	bh=ycPife+3o7m6Zi5JDAnnURHe4BGxj7VbdfYfP1i3m48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxqjdex0vHSSQCCDA8JWq21qwRTSHXSw5+9PGbYZrQX4Sj468YX0JcT+tjxkrzm3lkY+s/RZqLTdc1SzCCJ7tyhs/1JCDSgErGOxe/dCVyKJSo37SLdS9+klwMSFEwJzWthpZsaSOqoirYAhM7MavRs9U7In0pTv/rC1vEgH4ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLv4uMN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLv4uMN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE3CC43390;
	Tue, 13 Feb 2024 17:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845331;
	bh=ycPife+3o7m6Zi5JDAnnURHe4BGxj7VbdfYfP1i3m48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLv4uMN6n6dxOHoztjIGMmKVsQ7C4SYuR9RTBAAyQCgdhi6E7kILa5Bferh/WteOE
	 L8rMM7eFedBwMDuirqvQju5oWVbnrKZiC2kEdhxPW651rIeM46MxKvHZ7XpJD3D/d2
	 ZuPcNBsIKev98LnYVy4KpoxViNYEl28/ZpBVW7aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/121] xfs: hoist freeing of rt data fork extent mappings
Date: Tue, 13 Feb 2024 18:20:28 +0100
Message-ID: <20240213171853.531827262@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 6c664484337b37fa0cf6e958f4019623e30d40f7 upstream.

Currently, xfs_bmap_del_extent_real contains a bunch of code to convert
the physical extent of a data fork mapping for a realtime file into rt
extents and pass that to the rt extent freeing function.  Since the
details of this aren't needed when CONFIG_XFS_REALTIME=n, move it to
xfs_rtbitmap.c to reduce code size when realtime isn't enabled.

This will (one day) enable realtime EFIs to reuse the same
unit-converting call with less code duplication.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c     | 19 +++----------------
 fs/xfs/libxfs/xfs_rtbitmap.c | 33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h         |  5 +++++
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 30c931b38853..26bfa34b4bbf 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5057,33 +5057,20 @@ xfs_bmap_del_extent_real(
 
 	flags = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
-		xfs_filblks_t	len;
-		xfs_extlen_t	mod;
-
-		len = div_u64_rem(del->br_blockcount, mp->m_sb.sb_rextsize,
-				  &mod);
-		ASSERT(mod == 0);
-
 		if (!(bflags & XFS_BMAPI_REMAP)) {
-			xfs_fsblock_t	bno;
-
-			bno = div_u64_rem(del->br_startblock,
-					mp->m_sb.sb_rextsize, &mod);
-			ASSERT(mod == 0);
-
-			error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
+			error = xfs_rtfree_blocks(tp, del->br_startblock,
+					del->br_blockcount);
 			if (error)
 				goto done;
 		}
 
 		do_fx = 0;
-		nblks = len * mp->m_sb.sb_rextsize;
 		qfield = XFS_TRANS_DQ_RTBCOUNT;
 	} else {
 		do_fx = 1;
-		nblks = del->br_blockcount;
 		qfield = XFS_TRANS_DQ_BCOUNT;
 	}
+	nblks = del->br_blockcount;
 
 	del_endblock = del->br_startblock + del->br_blockcount;
 	if (cur) {
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index fa180ab66b73..655108a4cd05 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1005,6 +1005,39 @@ xfs_rtfree_extent(
 	return 0;
 }
 
+/*
+ * Free some blocks in the realtime subvolume.  rtbno and rtlen are in units of
+ * rt blocks, not rt extents; must be aligned to the rt extent size; and rtlen
+ * cannot exceed XFS_MAX_BMBT_EXTLEN.
+ */
+int
+xfs_rtfree_blocks(
+	struct xfs_trans	*tp,
+	xfs_fsblock_t		rtbno,
+	xfs_filblks_t		rtlen)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_rtblock_t		bno;
+	xfs_filblks_t		len;
+	xfs_extlen_t		mod;
+
+	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
+
+	len = div_u64_rem(rtlen, mp->m_sb.sb_rextsize, &mod);
+	if (mod) {
+		ASSERT(mod == 0);
+		return -EIO;
+	}
+
+	bno = div_u64_rem(rtbno, mp->m_sb.sb_rextsize, &mod);
+	if (mod) {
+		ASSERT(mod == 0);
+		return -EIO;
+	}
+
+	return xfs_rtfree_extent(tp, bno, len);
+}
+
 /* Find all the free records within a given range. */
 int
 xfs_rtalloc_query_range(
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 62c7ad79cbb6..3b2f1b499a11 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -58,6 +58,10 @@ xfs_rtfree_extent(
 	xfs_rtblock_t		bno,	/* starting block number to free */
 	xfs_extlen_t		len);	/* length of extent freed */
 
+/* Same as above, but in units of rt blocks. */
+int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
+		xfs_filblks_t rtlen);
+
 /*
  * Initialize realtime fields in the mount structure.
  */
@@ -139,6 +143,7 @@ int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
+# define xfs_rtfree_blocks(t,rb,rl)			(ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
 # define xfs_growfs_rt(mp,in)                           (ENOSYS)
 # define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)
-- 
2.43.0



