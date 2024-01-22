Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8BC6280A;
	Tue, 23 Jan 2024 00:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971135; cv=none; b=Fv4pivdJz1YSnKoUhv2I5K60dZglqZggnG3nb7NX+hMp0w29dvtL9QLDDMkTnriS3EDPSZSVvh2oZUYNn4mGdZHhu8/b+YFQ+UQ1ePO0yWPoCRWhptuW7Kfrul4emne4yfufa+0kM2x1Hl5aAF/gqHebUMfmyroB5BpHJQ7iS8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971135; c=relaxed/simple;
	bh=7/YlYZ7N63GABDQGNZ64ghdsnm8d5z28dxTYt/PtHp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRguw++3LNti/YU56k9MwmRWAByf3z0CFcpzy2DIRLSoxlvdyqPpaquT1/pqKmNAVizjHRgvWJavud4AZLBwCZssi+BCfXOgWDigmB0xj2DcBVkt+ipq3yApJUoIu7wWKNb/f/qan876pPaA8UeRvTP/n3emnXzO24iUpzDnrUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n3QkEzZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n3QkEzZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBFBC433F1;
	Tue, 23 Jan 2024 00:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971134;
	bh=7/YlYZ7N63GABDQGNZ64ghdsnm8d5z28dxTYt/PtHp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3QkEzZIunibsQGs3vzPmT+fKNnfHRgp0N2e04pYWa+INUhOxBIxssVY0aDquyRX9
	 ROrDkGB3VfLVFl6f+fjBWVfzZXYZ4EHidXuzfSIDdjn3RZE2Uf5dPSgO9sH6EuCHeM
	 qocGMfh+sCMnxX3xeyhIHoPi+/H23Pnb/66q3ra0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/286] gfs2: Also reflect single-block allocations in rgd->rd_extfail_pt
Date: Mon, 22 Jan 2024 15:56:41 -0800
Message-ID: <20240122235735.722228258@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit f38e998fbbb5da6a097ecd4b2700ba95eabab0c9 ]

Pass a non-NULL minext to gfs2_rbm_find even for single-block allocations.  In
gfs2_rbm_find, also set rgd->rd_extfail_pt when a single-block allocation
fails in a resource group: there is no reason for treating that case
differently.  In gfs2_reservation_check_and_update, only check how many free
blocks we have if more than one block is requested; we already know there's at
least one free block.

In addition, when allocating N blocks fails in gfs2_rbm_find, we need to set
rd_extfail_pt to N - 1 rather than N:  rd_extfail_pt defines the biggest
allocation that might still succeed.

Finally, reset rd_extfail_pt when updating the resource group statistics in
update_rgrp_lvb, as we already do in gfs2_rgrp_bh_get.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 8877243beafa ("gfs2: Fix kernel NULL pointer dereference in gfs2_rgrp_dump")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/rgrp.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index e05c01d5b9e6..ac0715aafa8e 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1247,6 +1247,8 @@ static int update_rgrp_lvb(struct gfs2_rgrpd *rgd)
 		rgd->rd_flags &= ~GFS2_RDF_CHECK;
 	rgd->rd_free = be32_to_cpu(rgd->rd_rgl->rl_free);
 	rgd->rd_free_clone = rgd->rd_free;
+	/* max out the rgrp allocation failure point */
+	rgd->rd_extfail_pt = rgd->rd_free;
 	rgd->rd_dinodes = be32_to_cpu(rgd->rd_rgl->rl_dinodes);
 	rgd->rd_igeneration = be64_to_cpu(rgd->rd_rgl->rl_igeneration);
 	return 0;
@@ -1648,7 +1650,7 @@ static int gfs2_reservation_check_and_update(struct gfs2_rbm *rbm,
 	 * If we have a minimum extent length, then skip over any extent
 	 * which is less than the min extent length in size.
 	 */
-	if (minext) {
+	if (minext > 1) {
 		extlen = gfs2_free_extlen(rbm, minext);
 		if (extlen <= maxext->len)
 			goto fail;
@@ -1680,7 +1682,7 @@ static int gfs2_reservation_check_and_update(struct gfs2_rbm *rbm,
  * gfs2_rbm_find - Look for blocks of a particular state
  * @rbm: Value/result starting position and final position
  * @state: The state which we want to find
- * @minext: Pointer to the requested extent length (NULL for a single block)
+ * @minext: Pointer to the requested extent length
  *          This is updated to be the actual reservation size.
  * @ip: If set, check for reservations
  * @nowrap: Stop looking at the end of the rgrp, rather than wrapping
@@ -1736,8 +1738,7 @@ static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state, u32 *minext,
 		if (ip == NULL)
 			return 0;
 
-		ret = gfs2_reservation_check_and_update(rbm, ip,
-							minext ? *minext : 0,
+		ret = gfs2_reservation_check_and_update(rbm, ip, *minext,
 							&maxext);
 		if (ret == 0)
 			return 0;
@@ -1769,7 +1770,7 @@ static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state, u32 *minext,
 			break;
 	}
 
-	if (minext == NULL || state != GFS2_BLKST_FREE)
+	if (state != GFS2_BLKST_FREE)
 		return -ENOSPC;
 
 	/* If the extent was too small, and it's smaller than the smallest
@@ -1777,7 +1778,7 @@ static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state, u32 *minext,
 	   useless to search this rgrp again for this amount or more. */
 	if (wrapped && (scan_from_start || rbm->bii > last_bii) &&
 	    *minext < rbm->rgd->rd_extfail_pt)
-		rbm->rgd->rd_extfail_pt = *minext;
+		rbm->rgd->rd_extfail_pt = *minext - 1;
 
 	/* If the maximum extent we found is big enough to fulfill the
 	   minimum requirements, use it anyway. */
@@ -2351,14 +2352,15 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 	struct gfs2_rbm rbm = { .rgd = ip->i_res.rs_rbm.rgd, };
 	unsigned int ndata;
 	u64 block; /* block, within the file system scope */
+	u32 minext = 1;
 	int error;
 
 	gfs2_set_alloc_start(&rbm, ip, dinode);
-	error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, NULL, ip, false);
+	error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, &minext, ip, false);
 
 	if (error == -ENOSPC) {
 		gfs2_set_alloc_start(&rbm, ip, dinode);
-		error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, NULL, NULL, false);
+		error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, &minext, NULL, false);
 	}
 
 	/* Since all blocks are reserved in advance, this shouldn't happen */
-- 
2.43.0



