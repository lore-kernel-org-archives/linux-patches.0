Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2E8423EAD;
	Tue, 25 Aug 2026 13:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664799; cv=none; b=qySGheaGIYDjqC63nGR4PUfR+tVgQ8dMpJRPhcwj3PExpPfPBkfH7Pl1d2lb+rnGYusjvNf7VeFOX3QaLJOk0swqLK1f8ca3V0gScxCatCe0/6FDKkdmN3EM00Tkki9+tfumd5Q0VQndO0JpRx2GX2RKjcNwy5Ii0B3l1bR0Y8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664799; c=relaxed/simple;
	bh=2h92mIAxyQAPess8YjSx1Iv7vseGb7AEEwR97iMR5Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b095AhO9B6IxoAr0eFTuIeb9XkBvpX50+Rk90Nw9C78vHYMTMe9ToODgM8+nMoNDPtl3kjmtsXXi4xb0Nz+4QAo4xABHIQwupIqZPb28YpOK6+vXuDUc9K6XazVq8FyiXesjd8EC9ZKB/KahYMwnXLXxn9rHcv1F9njL9J7Y8Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXCtudA4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXCtudA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7DE1F00A3A;
	Tue, 25 Aug 2026 13:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664798;
	bh=xlvwYGOGuf9jr1Ru+ijI6d7SHoSBAMYAYDmZ3CKtIAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AXCtudA4d+pi5AOi1C4NQ8nRh1Ic5HA/9/0cfQ1KZHg/QWjiS3FVW1f3/lmhbWyVs
	 owy4qIolHbCSEtQur1yBa7ezxpiMr+3D5FTLc9JiJD9pp7jFrDDdbjVFfNNGlG/o+d
	 KXQlcedsmaT3BYh4mX9IOrwAJPoGGaVoUShMO32A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 001/101] xfs: hoist per-bucket unlinked list check to helper
Date: Tue, 25 Aug 2026 15:24:39 +0200
Message-ID: <20260825132542.048299588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


