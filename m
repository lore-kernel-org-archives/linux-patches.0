Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7FE3C3C;
	Fri, 27 Sep 2024 12:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440370; cv=none; b=TWkWJjiVNuiW6GQ/Z8etzboTXvkjv7obSm20jHVwM21dHLfDy3l1uNuyMnR9hf4jvhvppIKhuMC9RWlw76gI3qib07ob31bMoQOuEAhnlG+OVHUomXBGptKxXl53xg3H3FeyS1rf3jsgagomublrNBVg1wbje4ecGrjJ8By+YZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440370; c=relaxed/simple;
	bh=hu2Y2h/znGYO3zGKu2HObo8YJGwEV0PBQq0DvHn38HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqVzXK4Npf0qu+DgpS8Dbbao2VA0TBZAjurm9J/t7BeSu09caOTZB040vBdOcGaKevEEIORCotkW1ILX9ktWcfRuR9sZyHyeQLVlKKutTXgl3ZjPCEiVfKCNVPfkrBgNTm5FpHn25Y+xWA4+kqn7DDhAAQlzaGvLXfAaorzSEPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NR9uDASI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NR9uDASI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADFDC4CEC4;
	Fri, 27 Sep 2024 12:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440369;
	bh=hu2Y2h/znGYO3zGKu2HObo8YJGwEV0PBQq0DvHn38HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NR9uDASIW52w8/Iz6PC94+l6DFVUmwYH6PoAlfmWXbNX1RNbZQNWuyiEOFAH0pdvE
	 DyWtksZuRrm8IAAnBPD6MdPUVg6fcg8zn5QFMbBL5+FD1qbXrOsE2KHEZSgcEW2raq
	 YNK2twFhJTnUQVoI1maQGIVkXBbtt8n/mLr5kV+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 57/73] xfs: set bnobt/cntbt numrecs correctly when formatting new AGs
Date: Fri, 27 Sep 2024 14:24:08 +0200
Message-ID: <20240927121722.231183900@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 8e698ee72c4ecbbf18264568eb310875839fd601 ]

Through generic/300, I discovered that mkfs.xfs creates corrupt
filesystems when given these parameters:

Filesystems formatted with --unsupported are not supported!!
meta-data=/dev/sda               isize=512    agcount=8, agsize=16352 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
data     =                       bsize=4096   blocks=130816, imaxpct=25
         =                       sunit=32     swidth=128 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=8192, version=2
         =                       sectsz=512   sunit=32 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 blks
Discarding blocks...Done.
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - 16:30:50: zeroing log - 16320 of 16320 blocks done
        - scan filesystem freespace and inode maps...
agf_freeblks 25, counted 0 in ag 4
sb_fdblocks 8823, counted 8798

The root cause of this problem is the numrecs handling in
xfs_freesp_init_recs, which is used to initialize a new AG.  Prior to
calling the function, we set up the new bnobt block with numrecs == 1
and rely on _freesp_init_recs to format that new record.  If the last
record created has a blockcount of zero, then it sets numrecs = 0.

That last bit isn't correct if the AG contains the log, the start of the
log is not immediately after the initial blocks due to stripe alignment,
and the end of the log is perfectly aligned with the end of the AG.  For
this case, we actually formatted a single bnobt record to handle the
free space before the start of the (stripe aligned) log, and incremented
arec to try to format a second record.  That second record turned out to
be unnecessary, so what we really want is to leave numrecs at 1.

The numrecs handling itself is overly complicated because a different
function sets numrecs == 1.  Change the bnobt creation code to start
with numrecs set to zero and only increment it after successfully
formatting a free space extent into the btree block.

Fixes: f327a00745ff ("xfs: account for log space when formatting new AGs")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_ag.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -415,10 +415,12 @@ xfs_freesp_init_recs(
 		ASSERT(start >= mp->m_ag_prealloc_blocks);
 		if (start != mp->m_ag_prealloc_blocks) {
 			/*
-			 * Modify first record to pad stripe align of log
+			 * Modify first record to pad stripe align of log and
+			 * bump the record count.
 			 */
 			arec->ar_blockcount = cpu_to_be32(start -
 						mp->m_ag_prealloc_blocks);
+			be16_add_cpu(&block->bb_numrecs, 1);
 			nrec = arec + 1;
 
 			/*
@@ -429,7 +431,6 @@ xfs_freesp_init_recs(
 					be32_to_cpu(arec->ar_startblock) +
 					be32_to_cpu(arec->ar_blockcount));
 			arec = nrec;
-			be16_add_cpu(&block->bb_numrecs, 1);
 		}
 		/*
 		 * Change record start to after the internal log
@@ -438,15 +439,13 @@ xfs_freesp_init_recs(
 	}
 
 	/*
-	 * Calculate the record block count and check for the case where
-	 * the log might have consumed all available space in the AG. If
-	 * so, reset the record count to 0 to avoid exposure of an invalid
-	 * record start block.
+	 * Calculate the block count of this record; if it is nonzero,
+	 * increment the record count.
 	 */
 	arec->ar_blockcount = cpu_to_be32(id->agsize -
 					  be32_to_cpu(arec->ar_startblock));
-	if (!arec->ar_blockcount)
-		block->bb_numrecs = 0;
+	if (arec->ar_blockcount)
+		be16_add_cpu(&block->bb_numrecs, 1);
 }
 
 /*
@@ -458,7 +457,7 @@ xfs_bnoroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 1, id->agno);
+	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 0, id->agno);
 	xfs_freesp_init_recs(mp, bp, id);
 }
 
@@ -468,7 +467,7 @@ xfs_cntroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_CNT, 0, 1, id->agno);
+	xfs_btree_init_block(mp, bp, XFS_BTNUM_CNT, 0, 0, id->agno);
 	xfs_freesp_init_recs(mp, bp, id);
 }
 


