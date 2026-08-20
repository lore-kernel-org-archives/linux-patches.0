Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B33737C925;
	Thu, 20 Aug 2026 15:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238394; cv=none; b=j3+mKJjhyCF9qTwslUPi9U2g5iC5EKrTNF3lNYuoc1WiuBMvZd0v/CzwVIzaeP1IyUmOWRVkhTMUuX4ApRWwiMl50VcNvG2jFz+SmlEnK8nEImxA6ucImcY4vHQL7T3O/DE/luWH0+aKomb5wJla6+u54aX9Gwww3juHSE1/qxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238394; c=relaxed/simple;
	bh=57nL+Jlp3LQdxqYJnnqJ89nYVf5VbKKh4dLGz2XqGpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkDPakDJxfpPem3GKF7TajP/DLRzhqh0bQqGf6TsDbIT77VDzJtGAfPGcMzKKm24Y5FtMVQ0kM6yB7F12TYKlf3T+m94WG6wJd8eqLLMMN4ldfXuqfBCz+FoEmQC1bx4csJR/LcsiQuiDH/3fctNQwsqToI4cOFUyBkdJr+tASg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UvAiU85y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UvAiU85y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CAA1F000E9;
	Thu, 20 Aug 2026 15:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238393;
	bh=oKJlnzjHFRESIgOFE9yV2VWoYEaQs3kdBCc0EcSdyEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UvAiU85yRtC+hj50X1eO5JQoWclP7FJLOy8gGMr+uWLQOnD4v0692lROC1fa3cgwz
	 32H5JFCx8qP6Q3eSftV5JwTQBHtmlC4JftlvpYkzf7waDh95KcmnfsUTTfE7kMN+5S
	 ZyqzS/Fd1lNu0u1nf0wvV5ljBu3Jjg4CE03a8eKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 131/228] xfs: fix transaction block reservation in xrep_rtbitmap
Date: Thu, 20 Aug 2026 16:54:33 +0200
Message-ID: <20260820145248.593797626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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


