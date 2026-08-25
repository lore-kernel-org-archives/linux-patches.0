Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BA6449EB2;
	Tue, 25 Aug 2026 13:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665180; cv=none; b=FRiYnU6y1sS3i5oXCDjw67IQ+hWafDFXlsLuzDUybQac+gAeA8QOnPhJVz6Ew03+HzWclmpjPNxoofy7p+FfF7tG1wWCm8MJ2p9zSa0FKmSDn23fmBSv+/nhCNdDExyzbD0GX2gmifTlhfce+GH1XlZmTCfXL0jD5DvncclbTGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665180; c=relaxed/simple;
	bh=a2eKFn1JpGjNrCrKOS/iwfUseolZNygL6InP8+VtJTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0UoI5Mz2Eqgsk0daJGhvYBgCoalnh55Osd6ROjGSdr15nLnXRRk1BB9IVg6KJs4v48CevYgrS8AZE2ugm9nWpphd75W3/17h/wJL0ClZjwtfYXL9xddmUouh9pyVqhiQbzp37AvULKu9pPTScUjg06YX5FY5aj+ZFypdx4LihE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olYZkfO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olYZkfO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163721F000E9;
	Tue, 25 Aug 2026 13:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665178;
	bh=GbZHOlyGNEEcb0eiyOmi1Od4BG7LF7mtXR4NWCgieu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=olYZkfO52lgKMjv6/97In9Lan/kWiDEjUaTe/YBnHggndnH4oWt950TlGqG7wWf+V
	 Fh+KYuNym6PUUIvTpNNXu5pqI36lFPrfULKfSBSdf+LoP4AtUfpUnRNssEcIAXj2/k
	 jdPiYTnQBH10gmxKPkd3d0M+G5kYsHS9CpFjOCO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 06/94] xfs: hoist per-bucket unlinked list check to helper
Date: Tue, 25 Aug 2026 15:25:02 +0200
Message-ID: <20260825132542.139428340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 7cdafd8f10ebdf745ba6046b9fa67490c343a17f ]

In the next patch we're going to make this loop more exciting, so hoist
the code to a helper function to reduce clutter in the resulting code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: 527eaaefddb6 ("xfs: don't livelock in scrub on a circular unlinked list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader.c |   62 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 21 deletions(-)

--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -933,6 +933,42 @@ xchk_agi_xref(
 }
 
 /*
+ * Walk the incore unlinked list for a particular AGI bucket to construct
+ * the unlinked inode bitmap for later reconstruction of the unlinked list.
+ * Returns 1 if we should keep checking, or 0 to stop checking.
+ */
+static int
+xchk_iunlink_bucket(
+	struct xfs_scrub		*sc,
+	unsigned int			bucket,
+	xfs_agino_t			agino)
+{
+	while (agino != NULLAGINO) {
+		struct xfs_inode	*ip;
+
+		if (agino % XFS_AGI_UNLINKED_BUCKETS != bucket) {
+			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+			return 0;
+		}
+
+		ip = xfs_iunlink_lookup(sc->sa.pag, agino);
+		if (!ip) {
+			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+			return 0;
+		}
+
+		if (!xfs_inode_on_unlinked_list(ip)) {
+			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+			return 0;
+		}
+
+		agino = ip->i_next_unlinked;
+	}
+
+	return 1;
+}
+
+/*
  * Check the unlinked buckets for links to bad inodes.  We hold the AGI, so
  * there cannot be any threads updating unlinked list pointers in this AG.
  */
@@ -942,30 +978,14 @@ xchk_iunlink(
 	struct xfs_agi		*agi)
 {
 	unsigned int		i;
-	struct xfs_inode	*ip;
 
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
-		xfs_agino_t	agino = be32_to_cpu(agi->agi_unlinked[i]);
+		int		ret;
 
-		while (agino != NULLAGINO) {
-			if (agino % XFS_AGI_UNLINKED_BUCKETS != i) {
-				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
-				return;
-			}
-
-			ip = xfs_iunlink_lookup(sc->sa.pag, agino);
-			if (!ip) {
-				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
-				return;
-			}
-
-			if (!xfs_inode_on_unlinked_list(ip)) {
-				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
-				return;
-			}
-
-			agino = ip->i_next_unlinked;
-		}
+		ret = xchk_iunlink_bucket(sc, i,
+				be32_to_cpu(agi->agi_unlinked[i]));
+		if (ret < 1)
+			return;
 	}
 }
 


