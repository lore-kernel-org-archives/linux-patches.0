Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E60949D5BB;
	Thu, 17 Sep 2026 17:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666847; cv=none; b=XWMm1LwzG0+FkRlqFUarTPIDXfUsMO5Z4V1p0TeRj0t+6slv+icgeWz+U+sTGWUE28MVCegqlwBu4aMCc7FMs3pnYlforBImVJ0nyxdz+XYHjWTmFnjDMCDgVianDOAB7HsdOGGw34Y3JyyORyHiI/1lem8yKZSmGnROONpHI+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666847; c=relaxed/simple;
	bh=YKPc32okcBRQVB/w44riARqXoBlsXkD+wGWzKA8PjWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EpXJvGT6rUraQCaMjQ039ra7BiKTB5n05O5ppmSeHbv1AFLHZi3Hu/MRfyWnOEZOM4Y2Y6HA53B00WpI/w6gcHmvXb8h0z120wOLSJp/4qMN4/GePlv0623UAvTrFbVJPhWLecJENzeOhZPHw3foD8BP30PLxhe2CYP4SWX7jII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ubn2zyqd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ubn2zyqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5571F00893;
	Thu, 17 Sep 2026 17:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666845;
	bh=2YxkOSZRazkkKzb3zuT3F1KeLyi+BwQziSzOi+I5vN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ubn2zyqdf3J/gWIG905vmT21D7Ytf8Y+PKoYC9fY/OqYOUcZnKW5ws70Ek44/89pe
	 c+OKQHDHCPjWtZwjnQllisRTzqg1k61HPTuKkQr1RisIDWXmuo0AT52h9pfR3onCAW
	 xDzGI2WGEMx6UYVT6B3BW2U/vI7DqQ5dZ/WjsL9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1107/1250] xfs: fix rtrefcount btree block counting in scrub
Date: Thu, 17 Sep 2026 16:15:02 +0100
Message-ID: <20260917151622.193488391@linuxfoundation.org>
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

commit 3f9fd694fa429e89fe6de51b22b0ed5fb8b2daf4 upstream.

LOLLM started on a long tangent about how xchk_refcount_xref_rmap
shouldn't nope out if sc->sa.rmap_cur isn't set, because nothing ever
sets that field.  It's right about the condition, but misses the bigger
problem, which is that to count the rtrefcount btree blocks, we have to
walk all rmap records in each AG in the data section.  That was papered
over by the incorrect !sc->sa.rmap_cur test.

In other words, we need a perag iteration loop here.  Restructure the
code to do that, and now it'll all work properly.  Fix the confusing
function name prefix.

Cc: stable@vger.kernel.org # v6.14
Fixes: c27929670de144 ("xfs: scrub the realtime refcount btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/rtrefcount.c |   64 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 55 insertions(+), 9 deletions(-)

--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -20,6 +20,7 @@
 #include "xfs_metafile.h"
 #include "xfs_rtrefcount_btree.h"
 #include "xfs_rtalloc.h"
+#include "xfs_ag.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -505,30 +506,75 @@ xchk_rtrefcountbt_rec(
 	return 0;
 }
 
+/* Count the number of blocks used by the rtrefcount btree file in this AG. */
+static int
+xchk_rtrefcount_count_agblocks(
+	struct xfs_scrub	*sc,
+	xfs_agnumber_t		agno,
+	const struct xfs_owner_info *btree_oinfo,
+	xfs_filblks_t		*blocks)
+{
+	xfs_filblks_t		agblocks = 0;
+	int			error;
+
+	error = xchk_ag_init_existing(sc, agno, &sc->sa);
+	if (error)
+		goto out_free;
+
+	/*
+	 * If we don't have an rmap cursor, we can't complete the cross
+	 * referencing, so return EFSCORRUPTED to end the loop and trigger the
+	 * XFAIL flag.
+	 */
+	if (!sc->sa.rmap_cur) {
+		error = -EFSCORRUPTED;
+		goto out_free;
+	}
+
+	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, btree_oinfo,
+			&agblocks);
+	if (error)
+		goto out_free;
+
+	*blocks += agblocks;
+out_free:
+	xchk_ag_free(sc, &sc->sa);
+	return error;
+}
+
 /* Make sure we have as many refc blocks as the rmap says. */
 STATIC void
-xchk_refcount_xref_rmap(
+xchk_rtrefcount_xref_rmap(
 	struct xfs_scrub	*sc,
 	const struct xfs_owner_info *btree_oinfo,
 	xfs_extlen_t		cow_blocks)
 {
 	xfs_filblks_t		refcbt_blocks = 0;
-	xfs_filblks_t		blocks;
-	int			error;
+	xfs_filblks_t		blocks = 1; /* one for the iroot */
+	xfs_agnumber_t		agno;
+	int			error = 0;
 
-	if (!sc->sr.rmap_cur || !sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
+	if (!xfs_has_rmapbt(sc->mp) || xchk_skip_xref(sc->sm))
 		return;
 
 	/* Check that we saw as many refcbt blocks as the rmap knows about. */
 	error = xfs_btree_count_blocks(sc->sr.refc_cur, &refcbt_blocks);
 	if (!xchk_btree_process_error(sc, sc->sr.refc_cur, 0, &error))
 		return;
-	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, btree_oinfo,
-			&blocks);
-	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+
+	for (agno = 0; agno < sc->mp->m_sb.sb_agcount; agno++) {
+		error = xchk_rtrefcount_count_agblocks(sc, agno, btree_oinfo,
+				&blocks);
+		if (error)
+			break;
+	}
+	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
 		return;
 	if (blocks != refcbt_blocks)
-		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
+
+	if (!sc->sr.rmap_cur || xchk_skip_xref(sc->sm))
+		return;
 
 	/* Check that we saw as many cow blocks as the rmap knows about. */
 	error = xchk_count_rmap_ownedby_ag(sc, sc->sr.rmap_cur,
@@ -569,7 +615,7 @@ xchk_rtrefcountbt(
 	 */
 	xchk_rtrefcountbt_xref_gaps(sc, &rrc,
 			xfs_rtx_to_rgbno(sc->sr.rtg, sc->mp->m_sb.sb_rgextents));
-	xchk_refcount_xref_rmap(sc, &btree_oinfo, rrc.cow_blocks);
+	xchk_rtrefcount_xref_rmap(sc, &btree_oinfo, rrc.cow_blocks);
 
 	return 0;
 }


