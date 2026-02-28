Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB807301F16;
	Sat, 28 Feb 2026 17:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301418; cv=none; b=F0/aJNwDd+0wb/e8usvvStzi+nN52F1QY8rHvXg4bM54NcBVrk3nccmxmMtczSepQ6eVq5EuE13VeUr82CnSggFLfrWZO5wPTXFg/2x2QJhG2va9iov8OyTySKiAtyJ3x/FaKEFA0E3p6mBbr5xF5P08k2MZcI3K0yiGcgluguo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301418; c=relaxed/simple;
	bh=GgcFNP1QtzleZLiLxh/PC3kbpgrW2huzx1/XQE76kMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ql0sGFkCOYoIlMrMrxwQ8Cbk8s23zrzWS3NUUDWaw6gb1orLrgh+upQS5MxR0E/Et/fxejjtqvddAyMNVlaX2pEVREWItaxJVHpPTAxSaVKxm6Iw/GUMs9AwnpAYFAZVmsO9yYzpjci7LVRm5uMRT84yBiq3UYJyMEIf5vNWxIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QsIvltEx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QsIvltEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33106C2BC87;
	Sat, 28 Feb 2026 17:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301418;
	bh=GgcFNP1QtzleZLiLxh/PC3kbpgrW2huzx1/XQE76kMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsIvltExbRHNnTFruQjkeGvgDrRh6nB5kAhNtj5tnmL4yg2Elr1NfVqDcnp/hGdbY
	 qvmghVdB26qB+LBKtl/jptEFtyspP4QWvGFoGpkWGqMMuE2H6iMCJNZV6gUDxnIl8q
	 su5kutEmYVS1UiSCM7g3YatmQ76tzQ8OIUpu+S9sMmAgoMDHobzWb3toPCivuShE9h
	 5hmHdwd4w6RfyNE/ArBX9kM+7YyoRn4z5/ZbSWgaKy/EmCiqM6VAYr4tq+ReBinh5g
	 s0U8WxkEGBMcRUP5RCGMLD1OxeIIAxrZiJBw7Ubu1ZVTuKbmQpSmgzPwLnzZon4pw8
	 L3McsTKkhYTGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	stable@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 608/752] xfs: fix the xattr scrub to detect freemap/entries array collisions
Date: Sat, 28 Feb 2026 12:45:19 -0500
Message-ID: <20260228174750.1542406-608-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 6fed8270448c246e706921c177e9633013dd3fcf ]

In the previous patches, we observed that it's possible for there to be
freemap entries with zero size but a nonzero base.  This isn't an
inconsistency per se, but older kernels can get confused by this and
corrupt the block, leading to corruption.

If we see this, flag the xattr structure for optimization so that it
gets rebuilt.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 13791d3b833428 ("xfs: scrub extended attribute leaf space")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/attr.c | 54 ++++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 708334f9b2bd1..ef299be01de5e 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -287,32 +287,6 @@ xchk_xattr_set_map(
 	return ret;
 }
 
-/*
- * Check the leaf freemap from the usage bitmap.  Returns false if the
- * attr freemap has problems or points to used space.
- */
-STATIC bool
-xchk_xattr_check_freemap(
-	struct xfs_scrub		*sc,
-	struct xfs_attr3_icleaf_hdr	*leafhdr)
-{
-	struct xchk_xattr_buf		*ab = sc->buf;
-	unsigned int			mapsize = sc->mp->m_attr_geo->blksize;
-	int				i;
-
-	/* Construct bitmap of freemap contents. */
-	bitmap_zero(ab->freemap, mapsize);
-	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
-		if (!xchk_xattr_set_map(sc, ab->freemap,
-				leafhdr->freemap[i].base,
-				leafhdr->freemap[i].size))
-			return false;
-	}
-
-	/* Look for bits that are set in freemap and are marked in use. */
-	return !bitmap_intersects(ab->freemap, ab->usedmap, mapsize);
-}
-
 /*
  * Check this leaf entry's relations to everything else.
  * Returns the number of bytes used for the name/value data.
@@ -403,6 +377,7 @@ xchk_xattr_block(
 
 	*last_checked = blk->blkno;
 	bitmap_zero(ab->usedmap, mp->m_attr_geo->blksize);
+	bitmap_zero(ab->freemap, mp->m_attr_geo->blksize);
 
 	/* Check all the padding. */
 	if (xfs_has_crc(ds->sc->mp)) {
@@ -449,6 +424,9 @@ xchk_xattr_block(
 	if ((char *)&entries[leafhdr.count] > (char *)leaf + leafhdr.firstused)
 		xchk_da_set_corrupt(ds, level);
 
+	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
 	buf_end = (char *)bp->b_addr + mp->m_attr_geo->blksize;
 	for (i = 0, ent = entries; i < leafhdr.count; ent++, i++) {
 		/* Mark the leaf entry itself. */
@@ -467,7 +445,29 @@ xchk_xattr_block(
 			goto out;
 	}
 
-	if (!xchk_xattr_check_freemap(ds->sc, &leafhdr))
+	/* Construct bitmap of freemap contents. */
+	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
+		if (!xchk_xattr_set_map(ds->sc, ab->freemap,
+				leafhdr.freemap[i].base,
+				leafhdr.freemap[i].size))
+			xchk_da_set_corrupt(ds, level);
+
+		/*
+		 * freemap entries with zero length and nonzero base can cause
+		 * problems with older kernels, so we mark these for preening
+		 * even though there's no inconsistency.
+		 */
+		if (leafhdr.freemap[i].size == 0 &&
+		    leafhdr.freemap[i].base > 0)
+			xchk_da_set_preen(ds, level);
+
+		if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+			goto out;
+	}
+
+	/* Look for bits that are set in freemap and are marked in use. */
+	if (bitmap_intersects(ab->freemap, ab->usedmap,
+			mp->m_attr_geo->blksize))
 		xchk_da_set_corrupt(ds, level);
 
 	if (leafhdr.usedbytes != usedbytes)
-- 
2.51.0

