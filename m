Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2419251357E;
	Thu, 17 Sep 2026 15:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660586; cv=none; b=necSt3wdZVY6+Yf1IuXV4UcdqoYZYpv6rodCqY+3+bOjVwfZ11GamHuCf09bUKJiT1LQ7uKBS1RwcGO4j6tlGRO7HtbUtMTkzM5vrxXTIvDGejqZsdmc0Jt4xlDuUOLiBaagz/pMpijMwHayAfKA2vZl3QF0J3i+XKCI3wNyw0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660586; c=relaxed/simple;
	bh=rMGUMPRnCw7+74sqdYzVB6KEUJY8OxamjDWrYuiYSbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBx4HhRSpzP7NIVX4Doj5Ud1wxI6B7bbr7HWqpQW9eZrliPqlM6wRgPv4IWCdlzs9ZubSU/S43+NM6iNiT3+KW0BZDPgi6Lt32xNMO3BFgV1vrzBhtPIEN0kc6oShNrL9Xz9jPCRkR/QffRHsL/nrL8I2Fyx5MpnQCYmL1CzOkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRhe+nag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRhe+nag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D94B1F00893;
	Thu, 17 Sep 2026 15:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660585;
	bh=/COypUyKV1FgbsbxMU7sKp4w7BfaWmGf5T0vMzUtaqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRhe+nagZlbxIe0zW+Kq46uTIexHaCqPl46X3fKjA3mGeIg6u5z7SiYu0wve+oSSH
	 YAzB+4UC/vqvMuxaMncT6XslAIjn3RfMFZ4LhzlykkNo8H+Qbvk1+TjxdM0vSnR7zL
	 zPGSSfh4XXXPrMXTVwQZO+jyWeFBdeoKvXdAU+gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 641/733] xfs: use the rtgroup extent count to find rtrefcount gaps
Date: Thu, 17 Sep 2026 16:15:49 +0100
Message-ID: <20260917151408.564941668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -428,7 +428,7 @@ static inline void
 xchk_rtrefcountbt_xref_gaps(
 	struct xfs_scrub	*sc,
 	struct xchk_rtrefcbt_records *rrc,
-	xfs_rtblock_t		bno)
+	xfs_rgblock_t		bno)
 {
 	struct xfs_rmap_irec	low;
 	struct xfs_rmap_irec	high;
@@ -538,7 +538,7 @@ xchk_refcount_xref_rmap(
 		xchk_btree_xref_set_corrupt(sc, sc->sr.rmap_cur, 0);
 }
 
-/* Scrub the refcount btree for some AG. */
+/* Scrub the refcount btree for some rtgroup. */
 int
 xchk_rtrefcountbt(
 	struct xfs_scrub	*sc)
@@ -564,10 +564,10 @@ xchk_rtrefcountbt(
 
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


