Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758FC37CD28;
	Thu, 20 Aug 2026 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238987; cv=none; b=i0CJpAxQSM3HsPWwZik1ifGDKZPImGcRCpH6dmVOjovwP9MPmGwJhxDZ8+JbV0q9U861Y6AfgtQ4qE2iO0m0jspXbiDlcXWiKKS5YlvmZOJaauoAGPn6Ih1MkGGCRUcWKG8rID/LP2e7LqRwPgeZwDpddLK8ktaRhIlZpu+UP9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238987; c=relaxed/simple;
	bh=oZEFVU6+pFv7O63u6NE30ODN1qs64N5Zs/ofytcdwOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApRFfaxERlvf/UdKFutp0fdL1Wp4QOI7AFpnwlRUghcyCk0odOze/f0/1AA3/TbgWBP3NRjd3fnkaQ0ADjDxJd+AchESePHQcnOJ+sxN9d5jazoCI2l8gm93mdNGwNruk0lewIAio932GyZIVKeF8QIGEKf1R0Wrr0Kd/i/FunA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzvPCY8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzvPCY8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993051F000E9;
	Thu, 20 Aug 2026 15:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238986;
	bh=kGDNGnN2GvX7ZyqNBjxpWHufdb7Z9smHiFbLwl9+tXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TzvPCY8JQhL9q6hDXvL7MtvoxI5EwKNpczVyIAPKXSK01st0Jb5oeLbQu0eI/slMo
	 Qlu5V9OelXKEoxDY2ruxrLSfBTrCXXJGPP5L7Vx9c7qwxfyBAxwJYnZN9CWju5PE3L
	 5LeKHgvRfRjcEKCdXqfII55KdrWJLnXfqChz57FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 109/217] xfs: fix transaction block reservation in xrep_rtbitmap
Date: Thu, 20 Aug 2026 16:54:37 +0200
Message-ID: <20260820145241.021817074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 61606f8846a9da8ab7d2d36ff4617134c9d6df1b upstream.

LOLLM pointed out an inconsistency in the block reservation code in
xrep_rtbitmap.  The first is that the reservation computation is not
consistent between the code that sets up the repair and the code that
tries to avoid exceeding the transaction reservation once we know how
big the rtbitmap really must be.  As a result, the logic doesn't work.

In fixing that, a second problem emerges: if we do readjust, we ask for
the entire reservation all over again.  We really only need the delta,
so ask only for that.

Fix all these problems by hoisting the computation to a trivial helper
so that it gets used in both places.

Cc: stable@vger.kernel.org # v6.14
Fixes: 8defee8dff2b20 ("xfs: online repair of realtime bitmaps for a realtime group")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/rtbitmap_repair.c |   46 ++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 18 deletions(-)

--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -36,6 +36,24 @@
 
 /* rt bitmap content repairs */
 
+/*
+ * Reserve enough blocks to write out a completely new bitmap file, plus twice
+ * as many blocks as we would need if we can only allocate one block per data
+ * fork mapping.  This should cover the preallocation of the temporary file and
+ * exchanging the extent mappings.
+ *
+ * We cannot use xfs_exchmaps_estimate because we have not yet constructed the
+ * replacement bitmap and therefore do not know how many extents it will use.
+ * By the time we do, we will have a dirty transaction (which we cannot drop
+ * because we cannot drop the rtbitmap ILOCK) and cannot ask for more
+ * reservation.
+ */
+static inline unsigned long long
+xrep_rtbitmap_calc_blocks(struct xfs_mount *mp, unsigned long long blocks)
+{
+	return blocks + (xfs_bmbt_calc_size(mp, blocks) * 2);
+}
+
 /* Set up to repair the realtime bitmap for this group. */
 int
 xrep_setup_rtbitmap(
@@ -56,20 +74,7 @@ xrep_setup_rtbitmap(
 	if (error)
 		return error;
 
-	/*
-	 * Reserve enough blocks to write out a completely new bitmap file,
-	 * plus twice as many blocks as we would need if we can only allocate
-	 * one block per data fork mapping.  This should cover the
-	 * preallocation of the temporary file and exchanging the extent
-	 * mappings.
-	 *
-	 * We cannot use xfs_exchmaps_estimate because we have not yet
-	 * constructed the replacement bitmap and therefore do not know how
-	 * many extents it will use.  By the time we do, we will have a dirty
-	 * transaction (which we cannot drop because we cannot drop the
-	 * rtbitmap ILOCK) and cannot ask for more reservation.
-	 */
-	blocks += xfs_bmbt_calc_size(mp, blocks) * 2;
+	blocks = xrep_rtbitmap_calc_blocks(mp, mp->m_sb.sb_rbmblocks);
 	if (blocks > UINT_MAX)
 		return -EOPNOTSUPP;
 
@@ -512,7 +517,7 @@ xrep_rtbitmap(
 	struct xchk_rtbitmap	*rtb = sc->buf;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_group	*xg = rtg_group(sc->sr.rtg);
-	unsigned long long	blocks = 0;
+	unsigned long long	blocks;
 	unsigned int		busy_gen;
 	int			error;
 
@@ -532,15 +537,20 @@ xrep_rtbitmap(
 	 * figure out if we need to adjust the block reservation in the
 	 * transaction.
 	 */
-	blocks = xfs_bmbt_calc_size(mp, rtb->rbmblocks);
+	blocks = xrep_rtbitmap_calc_blocks(mp, rtb->rbmblocks);
 	if (blocks > UINT_MAX)
 		return -EOPNOTSUPP;
 	if (blocks > rtb->resblks) {
-		error = xfs_trans_reserve_more(sc->tp, blocks, 0);
+		uint64_t	delta = blocks - rtb->resblks;
+
+		if (delta > UINT_MAX)
+			return -EOPNOTSUPP;
+
+		error = xfs_trans_reserve_more(sc->tp, delta, 0);
 		if (error)
 			return error;
 
-		rtb->resblks += blocks;
+		rtb->resblks += delta;
 	}
 
 	/* Fix inode core and forks. */


