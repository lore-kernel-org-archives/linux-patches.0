Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A24C1B413C;
	Mon, 23 Dec 2024 16:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970382; cv=none; b=qRKLZB0S7BKHBrhZLmpX53fHE6jxm2/23dBC0P4OaJxi2PM6JTGHeLayHxaJJJC79PvPGGlKzPm8iQFQQVUeMCFGnhqahsXCVDzeK9XLmZjgu/EmWTTYN4NGAuF/4HUywliYjlRDu1nxBspnbSMREW8zs1VqKQMab5nrNyfO6jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970382; c=relaxed/simple;
	bh=SHmEBL+6LgD3VG44UCMWinOrjrwNfKO0DUZJSz3+2N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fR9h0kw9esEcGJm+2UKUJ6BFoZxUJ53sl4pN7TBWD3lfjGMN9+9Sh8u7jwx7/LlEhGgssPnUXGN0xEkw7eLBts97CBbCnDBGi16ZcnX7MNNXIG+Bc/TIvAxI0n+cLpbgdWsxwmIq8s3SHutf3Ui78XRoKoeoyV/G14xGuEMF2tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVSeZ//T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVSeZ//T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072CBC4CED3;
	Mon, 23 Dec 2024 16:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970382;
	bh=SHmEBL+6LgD3VG44UCMWinOrjrwNfKO0DUZJSz3+2N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVSeZ//TcAwJ2n/MgNTbU6ksogz9erRGiJzfjwQJLGkNO1ceZoJaMgGoN4MKVfJbQ
	 QecODSGsomagzdmufRqUiZKh+7ZU7oEqipXEO4bsqnIoq61K01voeocdRREEr0LzO1
	 2H16nGb4MvwE927l9/uRj5yLtBCLk6hmwJ2fzNPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/116] xfs: reset rootdir extent size hint after growfsrt
Date: Mon, 23 Dec 2024 16:58:25 +0100
Message-ID: <20241223155400.939681326@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

commit a24cae8fc1f13f6f6929351309f248fd2e9351ce upstream.

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
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 9268961d887c..ad828fbd5ce4 100644
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



