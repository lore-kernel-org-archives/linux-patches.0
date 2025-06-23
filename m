Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9705221734;
	Mon, 23 Jun 2025 21:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714495; cv=none; b=jK6lOOl3gLyk+z4+yt/N3JkI/21RGEv8uwE3+a4nH2WzwtKtrkTKt5LFPjSBlL47ue7nDFdmeYiIgVf9CJqg0ekpsnrigTiIYB2+zCq2n8GrMV5xsejsQtVW2tibZQFDH4iS3Mee/mA2xrGX90YyPyG+3LmRUEOw7UwTtTCBKhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714495; c=relaxed/simple;
	bh=cWWGOVhRXWnwO+L8d4/hHs0FxaiCx3vc00+CcD/Th08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPdMxecyNHsJ/nB5qbkmrvqBtvSKmom3DS2m6U2wVDSZQxkexUN2SF50gJzCsIGxz+b42LrXg9/zE9yfUzt5Mv0uACNy+9MBTXNPmCqZfmpQo871VCwOf9WkDHu1S+8PoWnhaeD/8gfoA2J8HpiPAcbJr/jZDswqSBTmf/406BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1BjH2k8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1BjH2k8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F642C4CEED;
	Mon, 23 Jun 2025 21:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714494;
	bh=cWWGOVhRXWnwO+L8d4/hHs0FxaiCx3vc00+CcD/Th08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1BjH2k81GpdWMYrnY28aSN1hL09kRg6THD/YTzShhrfbuKW/+OYF/6GiukJMjkaa
	 rlNrnSpxvshbbS8TrlAvUeuVRAs1pvZRu3Nh4DPdHLY3aYj0ojfwrZ2ORMyUAOlZAT
	 r7BatnZxI3f2uUnPwjg6EDumJ9Y5ENFF37hYK1vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 198/508] xfs: fix an agbno overflow in __xfs_getfsmap_datadev
Date: Mon, 23 Jun 2025 15:04:03 +0200
Message-ID: <20250623130650.141909099@linuxfoundation.org>
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

[ Upstream commit cfa2df68b7ceb49ac9eb2d295ab0c5974dbf17e7 ]

Dave Chinner reported that xfs/273 fails if the AG size happens to be an
exact power of two.  I traced this to an agbno integer overflow when the
current GETFSMAP call is a continuation of a previous GETFSMAP call, and
the last record returned was non-shareable space at the end of an AG.

__xfs_getfsmap_datadev sets up a data device query by converting the
incoming fmr_physical into an xfs_fsblock_t and cracking it into an agno
and agbno pair.  In the (failing) case of where fmr_blockcount of the
low key is nonzero and the record was for a non-shareable extent, it
will add fmr_blockcount to start_fsb and info->low.rm_startblock.

If the low key was actually the last record for that AG, then this
addition causes info->low.rm_startblock to point beyond EOAG.  When the
rmapbt range query starts, it'll return an empty set, and fsmap moves on
to the next AG.

Or so I thought.  Remember how we added to start_fsb?

If agsize < 1<<agblklog, start_fsb points to the same AG as the original
fmr_physical from the low key.  We run the rmapbt query, which returns
nothing, so getfsmap zeroes info->low and moves on to the next AG.

If agsize == 1<<agblklog, start_fsb now points to the next AG.  We run
the rmapbt query on the next AG with the excessively large
rm_startblock.  If this next AG is actually the last AG, we'll set
info->high to EOFS (which is now has a lower rm_startblock than
info->low), and the ranged btree query code will return -EINVAL.  If
it's not the last AG, we ignore all records for the intermediate AGs.

Oops.

Fix this by decoding start_fsb into agno and agbno only after making
adjustments to start_fsb.  This means that info->low.rm_startblock will
always be set to a valid agbno, and we always start the rmapbt iteration
in the correct AG.

While we're at it, fix the predicate for determining if an fsmap record
represents non-shareable space to include file data on pre-reflink
filesystems.

Reported-by: Dave Chinner <david@fromorbit.com>
Fixes: 63ef7a35912dd ("xfs: fix interval filtering in multi-step fsmap queries")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_fsmap.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index d10f2c719220d..956a5670e56ce 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -565,6 +565,19 @@ xfs_getfsmap_rtdev_rtbitmap(
 }
 #endif /* CONFIG_XFS_RT */
 
+static inline bool
+rmap_not_shareable(struct xfs_mount *mp, const struct xfs_rmap_irec *r)
+{
+	if (!xfs_has_reflink(mp))
+		return true;
+	if (XFS_RMAP_NON_INODE_OWNER(r->rm_owner))
+		return true;
+	if (r->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			   XFS_RMAP_UNWRITTEN))
+		return true;
+	return false;
+}
+
 /* Execute a getfsmap query against the regular data device. */
 STATIC int
 __xfs_getfsmap_datadev(
@@ -598,7 +611,6 @@ __xfs_getfsmap_datadev(
 	 * low to the fsmap low key and max out the high key to the end
 	 * of the AG.
 	 */
-	info->low.rm_startblock = XFS_FSB_TO_AGBNO(mp, start_fsb);
 	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
 	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
 	if (error)
@@ -608,12 +620,9 @@ __xfs_getfsmap_datadev(
 
 	/* Adjust the low key if we are continuing from where we left off. */
 	if (info->low.rm_blockcount == 0) {
-		/* empty */
-	} else if (XFS_RMAP_NON_INODE_OWNER(info->low.rm_owner) ||
-		   (info->low.rm_flags & (XFS_RMAP_ATTR_FORK |
-					  XFS_RMAP_BMBT_BLOCK |
-					  XFS_RMAP_UNWRITTEN))) {
-		info->low.rm_startblock += info->low.rm_blockcount;
+		/* No previous record from which to continue */
+	} else if (rmap_not_shareable(mp, &info->low)) {
+		/* Last record seen was an unshareable extent */
 		info->low.rm_owner = 0;
 		info->low.rm_offset = 0;
 
@@ -621,8 +630,10 @@ __xfs_getfsmap_datadev(
 		if (XFS_FSB_TO_DADDR(mp, start_fsb) >= eofs)
 			return 0;
 	} else {
+		/* Last record seen was a shareable file data extent */
 		info->low.rm_offset += info->low.rm_blockcount;
 	}
+	info->low.rm_startblock = XFS_FSB_TO_AGBNO(mp, start_fsb);
 
 	info->high.rm_startblock = -1U;
 	info->high.rm_owner = ULLONG_MAX;
-- 
2.39.5



