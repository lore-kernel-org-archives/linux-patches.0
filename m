Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3413B3BE2;
	Thu, 17 Sep 2026 17:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666590; cv=none; b=nxMZ+Azu8K10pxPG0FXrMQDU74i2zoo6VkuDhbzHVx68eCFQqm+G8j9voXjSUKlRLacLz1iRXOVKhdDI7elWaVr3+UHgAvbxY5Orvd3Xkk/jOS2LHIBdA9+ymLEdPejWzOnzO1ZID7Eg+/sjiNMGV19iE+EnvhtuXKj1bJVC7mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666590; c=relaxed/simple;
	bh=EGW2Ytm3t2Juzl+42XsrW6sEHfgcPKgJb0xBVFiHpNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ky5iXbaYtRQnJY8iR5Tuy88keKH3UvK521SDPEL7kzvwUtX5qWhkF4Xz8ULRyeCA0vwNWoAaFDS89LSRO5hl0GOI3lrp8p78tRwAGhWoHWzsV8F6vVq/yXQcNEHZx0p5S6/50RB7dMABUk/BSUMx60SNfwA3nzAZV0JGmbT4wxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCFwonxP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCFwonxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C041F000FF;
	Thu, 17 Sep 2026 17:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666589;
	bh=PcsS3eNmLtn3Ka9tgWc2u5rCGD8YhNOWyShIBxvXThA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tCFwonxPXAddyNVJEACbudjA0D29KgjE30+F86PUrKPaDMw8JlXTP/dB3IETa0OZd
	 f8V21yDkLm0MHutLTR2fJi8qu0SlAtVXmGO6SdN0O/5IxH1H3wi922dBsPIBuTNAlR
	 eZipj9953S91MDjkOej5AFtWta8jXb9kAxIp/Rvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1088/1250] xfs: use the rtgroup extent count to find rtrefcount gaps
Date: Thu, 17 Sep 2026 16:14:43 +0100
Message-ID: <20260917151621.646193289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

commit c3085f6c7cca7c162248519ce8d763047cdd8acd upstream.

LOLLM noticed an anachronism from the early days of rtrefcount where the
refcount btree would handle 64-bit block numbers -- we pass rtblocks
into the gap finder, but rtrefcount btrees are sharded by rtgroup now.
This isn't really a problem for us since we're only looking for
overlapping rtrmap records to flag, but let's fix this sillyness.

Also fix some stale comments.

Cc: stable@vger.kernel.org # v6.14
Fixes: 30f47950dc2eba ("xfs: check reference counts of gaps between rt refcount records")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/rtrefcount.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -429,7 +429,7 @@ static inline void
 xchk_rtrefcountbt_xref_gaps(
 	struct xfs_scrub	*sc,
 	struct xchk_rtrefcbt_records *rrc,
-	xfs_rtblock_t		bno)
+	xfs_rgblock_t		bno)
 {
 	struct xfs_rmap_irec	low;
 	struct xfs_rmap_irec	high;
@@ -539,7 +539,7 @@ xchk_refcount_xref_rmap(
 		xchk_btree_xref_set_corrupt(sc, sc->sr.rmap_cur, 0);
 }
 
-/* Scrub the refcount btree for some AG. */
+/* Scrub the refcount btree for some rtgroup. */
 int
 xchk_rtrefcountbt(
 	struct xfs_scrub	*sc)
@@ -565,10 +565,10 @@ xchk_rtrefcountbt(
 
 	/*
 	 * Check that all blocks between the last refcount > 1 record and the
-	 * end of the rt volume have at most one reverse mapping.
+	 * end of the rtgroup have at most one reverse mapping.
 	 */
-	xchk_rtrefcountbt_xref_gaps(sc, &rrc, sc->mp->m_sb.sb_rblocks);
-
+	xchk_rtrefcountbt_xref_gaps(sc, &rrc,
+			xfs_rtx_to_rgbno(sc->sr.rtg, sc->mp->m_sb.sb_rgextents));
 	xchk_refcount_xref_rmap(sc, &btree_oinfo, rrc.cow_blocks);
 
 	return 0;


