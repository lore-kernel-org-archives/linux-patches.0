Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1F37482;
	Thu, 30 Jan 2025 14:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247490; cv=none; b=bvJ9aWZjyiej8uPXYiM9/TcRgpXO92ksFDlF8eP8KifZpojH4k7jY/A1DxpaKgdJj0DeQUuZYvUzSi7YKe7/Tf7lOrz22PSe/SrF33r6wGnvF3QFkgzdlq11sooJqeJE2c3o5hOxStHTRc4dzCe5/CxyMp10qqGO8+Ju1GnszPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247490; c=relaxed/simple;
	bh=tiGqpYi3u+zfjmTx3kkjkjK5LNEKtq56bLcEVkMWs/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uj2nfLZRDDaxPy3YgGz6moqVYw11B3c2oGff1SD9WxVY1oZvEpim6LL+wEp7bLsOgDzHTOOiBd1Ugj8PHwXz2Bw1lZN0M4svaET2/05MMa3vbMJ8Vlg9tDJtn0xNO/yAx38Dys9hrjeHPRnbQfk9mqn2e4E8QmS8pIbnPH1Q9ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qc/d3oq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qc/d3oq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFBBC4CED2;
	Thu, 30 Jan 2025 14:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247489;
	bh=tiGqpYi3u+zfjmTx3kkjkjK5LNEKtq56bLcEVkMWs/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qc/d3oq19QoHN5sAJEIRmYvWnxLC/lS5Gev0enuTNsZO2WQ+b71cSB8C2ovGSSW96
	 Vs1kYpLpOeMX3fIOsqGZeppLwqA8zllIQZObch4bUE0hYr2MUTM7DjyXEyfmv9P/cD
	 rD/0T08UryqD87NnClu/q8xrSsKgDzbYap8DyGKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 29/49] xfs: clean up FS_XFLAG_REALTIME handling in xfs_ioctl_setattr_xflags
Date: Thu, 30 Jan 2025 15:02:05 +0100
Message-ID: <20250130140135.008438257@linuxfoundation.org>
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

[ Upstream commit c421df0b19430417a04f68919fc3d1943d20ac04 ]

Introduce a local boolean variable if FS_XFLAG_REALTIME to make the
checks for it more obvious, and de-densify a few of the conditionals
using it to make them more readable while at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231025141020.192413-4-hch@lst.de
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_ioctl.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1120,23 +1120,25 @@ xfs_ioctl_setattr_xflags(
 	struct fileattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	bool			rtflag = (fa->fsx_xflags & FS_XFLAG_REALTIME);
 	uint64_t		i_flags2;
 
-	/* Can't change realtime flag if any extents are allocated. */
-	if ((ip->i_df.if_nextents || ip->i_delayed_blks) &&
-	    XFS_IS_REALTIME_INODE(ip) != (fa->fsx_xflags & FS_XFLAG_REALTIME))
-		return -EINVAL;
+	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
+		/* Can't change realtime flag if any extents are allocated. */
+		if (ip->i_df.if_nextents || ip->i_delayed_blks)
+			return -EINVAL;
+	}
 
-	/* If realtime flag is set then must have realtime device */
-	if (fa->fsx_xflags & FS_XFLAG_REALTIME) {
+	if (rtflag) {
+		/* If realtime flag is set then must have realtime device */
 		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
 		    (ip->i_extsize % mp->m_sb.sb_rextsize))
 			return -EINVAL;
-	}
 
-	/* Clear reflink if we are actually able to set the rt flag. */
-	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
-		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+		/* Clear reflink if we are actually able to set the rt flag. */
+		if (xfs_is_reflink_inode(ip))
+			ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+	}
 
 	/* Don't allow us to set DAX mode for a reflinked file for now. */
 	if ((fa->fsx_xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))


