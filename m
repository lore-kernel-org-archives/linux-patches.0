Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C681E1A05;
	Mon, 23 Jun 2025 21:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715073; cv=none; b=Sxl2BT9ThcJujWhqqw1y2d2n5pAp48hP36Hlk8BVRug015/uXwQqH8/TgeppM3l/+klXf+rCWKh4w1kyYfkUpiv7pIK52rwq6aeqkHOKt1zNJDn2PUQdyaEPK75tYMzklRhR/RrMuY66LSKiMaier08tynhHYlKzr3UKJ6Y6k4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715073; c=relaxed/simple;
	bh=P/amph1TE09FI6+nfj+qibd2yYmxBJNoFHDfEzjI9wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqfRF/OfG/QSaI0IJ7gJbp5+WdWrdDK7zjC1gwXEwFFJJcIRsbIvNaFlgD5KrwCmnv2rJpZNvL14FLSfSmYlU7WQfSikERq5wBD+8mGCTVldXfbLKdRFXRN79qHvLfmyrRgyXxQqAlQ+QVYKLUIagZH5N26LRk4Paf3DRob7EL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkwpLMLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkwpLMLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC4CC4CEEA;
	Mon, 23 Jun 2025 21:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715072;
	bh=P/amph1TE09FI6+nfj+qibd2yYmxBJNoFHDfEzjI9wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkwpLMLy71Uy6sAeCe3UwAubgBhnwog97/S8plpVTzTHCKWOXacwhvRHda07HPCD0
	 PH2SJCjBVsRwvERKVTg4ExEYMSU+GqCyMfZyxkGv6mxUQ5c6e2noYDxYhsLsN8w/QA
	 juTseP46A5PBhNh6bF3HWmSKcNDGZ0bAO65ZmShw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 213/508] xfs: reset rootdir extent size hint after growfsrt
Date: Mon, 23 Jun 2025 15:04:18 +0200
Message-ID: <20250623130650.504681145@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit a24cae8fc1f13f6f6929351309f248fd2e9351ce ]

If growfsrt is run on a filesystem that doesn't have a rt volume, it's
possible to change the rt extent size.  If the root directory was
previously set up with an inherited extent size hint and rtinherit, it's
possible that the hint is no longer a multiple of the rt extent size.
Although the verifiers don't complain about this, xfs_repair will, so if
we detect this situation, log the root directory to clean it up.  This
is still racy, but it's better than nothing.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 149fcfc485d89..fc21b4e81ade8 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -915,6 +915,39 @@ xfs_alloc_rsum_cache(
 		xfs_warn(mp, "could not allocate realtime summary cache");
 }
 
+/*
+ * If we changed the rt extent size (meaning there was no rt volume previously)
+ * and the root directory had EXTSZINHERIT and RTINHERIT set, it's possible
+ * that the extent size hint on the root directory is no longer congruent with
+ * the new rt extent size.  Log the rootdir inode to fix this.
+ */
+static int
+xfs_growfs_rt_fixup_extsize(
+	struct xfs_mount	*mp)
+{
+	struct xfs_inode	*ip = mp->m_rootip;
+	struct xfs_trans	*tp;
+	int			error = 0;
+
+	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	if (!(ip->i_diflags & XFS_DIFLAG_RTINHERIT) ||
+	    !(ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT))
+		goto out_iolock;
+
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange, 0, 0, false,
+			&tp);
+	if (error)
+		goto out_iolock;
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+out_iolock:
+	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	return error;
+}
+
 /*
  * Visible (exported) functions.
  */
@@ -944,6 +977,7 @@ xfs_growfs_rt(
 	xfs_sb_t	*sbp;		/* old superblock */
 	xfs_fsblock_t	sumbno;		/* summary block number */
 	uint8_t		*rsum_cache;	/* old summary cache */
+	xfs_agblock_t	old_rextsize = mp->m_sb.sb_rextsize;
 
 	sbp = &mp->m_sb;
 
@@ -1177,6 +1211,12 @@ xfs_growfs_rt(
 	if (error)
 		goto out_free;
 
+	if (old_rextsize != in->extsize) {
+		error = xfs_growfs_rt_fixup_extsize(mp);
+		if (error)
+			goto out_free;
+	}
+
 	/* Update secondary superblocks now the physical grow has completed */
 	error = xfs_update_secondary_sbs(mp);
 
-- 
2.39.5



