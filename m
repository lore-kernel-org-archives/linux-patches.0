Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58F7221FCC;
	Mon, 23 Jun 2025 21:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714718; cv=none; b=fpEjNzQF0Ked/iN9a6PGOUTpPlJwvflcVqN0HfPd1K4bdZckifHVWeVXqc73QZWeeGP/cjfsM/pVsDcyl9scBoPXULOW9OMjH7OMdogo5l1ZZkhOBUUwBYME+ESKHWPPFAb2tItnXCmZBoSD8e8ciNZHULArkRWoCKfvc1n7nGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714718; c=relaxed/simple;
	bh=WAor2sqyToqZHdt4YfMvox0L6krzIhfo32Lf08w0ngg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h66hjAIMig0gIBqLwsr96Dx/5/Qujx0gEqhYxggA1j38KyVVH760UDHEAjDorZOVO16vWq0m9pUvRvllJ/12dDa5mjAgzXdNmLJACPL1UYhRQgMSs6y8MLnK9zO9KDivC+QWr9hylv4n0UbeROkGUGrgcpUGXjqgmjuRmisE5IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnDjZFtK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnDjZFtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35767C4CEEA;
	Mon, 23 Jun 2025 21:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714718;
	bh=WAor2sqyToqZHdt4YfMvox0L6krzIhfo32Lf08w0ngg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VnDjZFtKjgzUFT/pklaMym0e9d1ITwWDv/yzMSBET8jr7R6/YPHdHyNKwKiJ2lMAP
	 Vu0FtxkMkCDiaeNsi2ojSa0Z7WQCZfDvWMzXvKlwLM9Lj9QJRCCEhJIF9hXrEPRwph
	 88M+7fOrrnF1A+oMr0DCI3R+dz9+6wtZzSba2oCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/508] xfs: fix interval filtering in multi-step fsmap queries
Date: Mon, 23 Jun 2025 15:03:56 +0200
Message-ID: <20250623130649.970894479@linuxfoundation.org>
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

[ Upstream commit 63ef7a35912dd743cabd65d5bb95891625c0dd46 ]

I noticed a bug in ranged GETFSMAP queries:

# xfs_io -c 'fsmap -vvvv' /opt
 EXT: DEV  BLOCK-RANGE           OWNER              FILE-OFFSET      AG AG-OFFSET           TOTAL
   0: 8:80 [0..7]:               static fs metadata                  0  (0..7)                  8
<snip>
   9: 8:80 [192..223]:           137                0..31            0  (192..223)             32
# xfs_io -c 'fsmap -vvvv -d 208 208' /opt
#

That's not right -- we asked what block maps block 208, and we should've
received a mapping for inode 137 offset 16.  Instead, we get nothing.

The root cause of this problem is a mis-interaction between the fsmap
code and how btree ranged queries work.  xfs_btree_query_range returns
any btree record that overlaps with the query interval, even if the
record starts before or ends after the interval.  Similarly, GETFSMAP is
supposed to return a recordset containing all records that overlap the
range queried.

However, it's possible that the recordset is larger than the buffer that
the caller provided to convey mappings to userspace.  In /that/ case,
userspace is supposed to copy the last record returned to fmh_keys[0]
and call GETFSMAP again.  In this case, we do not want to return
mappings that we have already supplied to the caller.  The call to
xfs_btree_query_range is the same, but now we ignore any records that
start before fmh_keys[0].

Unfortunately, we didn't implement the filtering predicate correctly.
The predicate should only be called when we're calling back for more
records.  Accomplish this by setting info->low.rm_blockcount to a
nonzero value and ensuring that it is cleared as necessary.  As a
result, we no longer want to adjust dkeys[0] in the main setup function
because that's confusing.

This patch doesn't touch the logdev/rtbitmap backends because they have
bigger problems that will be addressed by subsequent patches.

Found via xfs/556 with parent pointers enabled.

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_fsmap.c | 67 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 48 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index a5b9754c62d1c..2011f1bf7ce0f 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -162,7 +162,14 @@ struct xfs_getfsmap_info {
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	u64			missing_owner;	/* owner of holes */
 	u32			dev;		/* device id */
-	struct xfs_rmap_irec	low;		/* low rmap key */
+	/*
+	 * Low rmap key for the query.  If low.rm_blockcount is nonzero, this
+	 * is the second (or later) call to retrieve the recordset in pieces.
+	 * xfs_getfsmap_rec_before_start will compare all records retrieved
+	 * by the rmapbt query to filter out any records that start before
+	 * the last record.
+	 */
+	struct xfs_rmap_irec	low;
 	struct xfs_rmap_irec	high;		/* high rmap key */
 	bool			last;		/* last extent? */
 };
@@ -237,6 +244,17 @@ xfs_getfsmap_format(
 	xfs_fsmap_from_internal(rec, xfm);
 }
 
+static inline bool
+xfs_getfsmap_rec_before_start(
+	struct xfs_getfsmap_info	*info,
+	const struct xfs_rmap_irec	*rec,
+	xfs_daddr_t			rec_daddr)
+{
+	if (info->low.rm_blockcount)
+		return xfs_rmap_compare(rec, &info->low) < 0;
+	return false;
+}
+
 /*
  * Format a reverse mapping for getfsmap, having translated rm_startblock
  * into the appropriate daddr units.
@@ -260,7 +278,7 @@ xfs_getfsmap_helper(
 	 * Filter out records that start before our startpoint, if the
 	 * caller requested that.
 	 */
-	if (xfs_rmap_compare(rec, &info->low) < 0) {
+	if (xfs_getfsmap_rec_before_start(info, rec, rec_daddr)) {
 		rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
 		if (info->next_daddr < rec_daddr)
 			info->next_daddr = rec_daddr;
@@ -606,9 +624,27 @@ __xfs_getfsmap_datadev(
 	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
 	if (error)
 		return error;
-	info->low.rm_blockcount = 0;
+	info->low.rm_blockcount = XFS_BB_TO_FSBT(mp, keys[0].fmr_length);
 	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
 
+	/* Adjust the low key if we are continuing from where we left off. */
+	if (info->low.rm_blockcount == 0) {
+		/* empty */
+	} else if (XFS_RMAP_NON_INODE_OWNER(info->low.rm_owner) ||
+		   (info->low.rm_flags & (XFS_RMAP_ATTR_FORK |
+					  XFS_RMAP_BMBT_BLOCK |
+					  XFS_RMAP_UNWRITTEN))) {
+		info->low.rm_startblock += info->low.rm_blockcount;
+		info->low.rm_owner = 0;
+		info->low.rm_offset = 0;
+
+		start_fsb += info->low.rm_blockcount;
+		if (XFS_FSB_TO_DADDR(mp, start_fsb) >= eofs)
+			return 0;
+	} else {
+		info->low.rm_offset += info->low.rm_blockcount;
+	}
+
 	info->high.rm_startblock = -1U;
 	info->high.rm_owner = ULLONG_MAX;
 	info->high.rm_offset = ULLONG_MAX;
@@ -659,12 +695,8 @@ __xfs_getfsmap_datadev(
 		 * Set the AG low key to the start of the AG prior to
 		 * moving on to the next AG.
 		 */
-		if (pag->pag_agno == start_ag) {
-			info->low.rm_startblock = 0;
-			info->low.rm_owner = 0;
-			info->low.rm_offset = 0;
-			info->low.rm_flags = 0;
-		}
+		if (pag->pag_agno == start_ag)
+			memset(&info->low, 0, sizeof(info->low));
 
 		/*
 		 * If this is the last AG, report any gap at the end of it
@@ -901,21 +933,17 @@ xfs_getfsmap(
 	 * blocks could be mapped to several other files/offsets.
 	 * According to rmapbt record ordering, the minimal next
 	 * possible record for the block range is the next starting
-	 * offset in the same inode. Therefore, bump the file offset to
-	 * continue the search appropriately.  For all other low key
-	 * mapping types (attr blocks, metadata), bump the physical
-	 * offset as there can be no other mapping for the same physical
-	 * block range.
+	 * offset in the same inode. Therefore, each fsmap backend bumps
+	 * the file offset to continue the search appropriately.  For
+	 * all other low key mapping types (attr blocks, metadata), each
+	 * fsmap backend bumps the physical offset as there can be no
+	 * other mapping for the same physical block range.
 	 */
 	dkeys[0] = head->fmh_keys[0];
 	if (dkeys[0].fmr_flags & (FMR_OF_SPECIAL_OWNER | FMR_OF_EXTENT_MAP)) {
-		dkeys[0].fmr_physical += dkeys[0].fmr_length;
-		dkeys[0].fmr_owner = 0;
 		if (dkeys[0].fmr_offset)
 			return -EINVAL;
-	} else
-		dkeys[0].fmr_offset += dkeys[0].fmr_length;
-	dkeys[0].fmr_length = 0;
+	}
 	memset(&dkeys[1], 0xFF, sizeof(struct xfs_fsmap));
 
 	if (!xfs_getfsmap_check_keys(dkeys, &head->fmh_keys[1]))
@@ -960,6 +988,7 @@ xfs_getfsmap(
 		info.dev = handlers[i].dev;
 		info.last = false;
 		info.pag = NULL;
+		info.low.rm_blockcount = 0;
 		error = handlers[i].fn(tp, dkeys, &info);
 		if (error)
 			break;
-- 
2.39.5



