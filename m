Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0950D1624CF;
	Mon, 24 Feb 2025 14:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407841; cv=none; b=KaL8bxp9Q//EZ5vx4n40WTQqI4K+mTPPs2Obj1LWdaekQzd4yK72MQ6kFukiioc4CMiFOXPDJNxjoXTBWkFDxGhOmvAUCs4wpHiRQ8lMzC10g/DXby8HYNv6iVdkujyChE2EtV3xlXSs3eIwovwuK7WS4TqlZQ+JpflXeh/Ej2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407841; c=relaxed/simple;
	bh=OHE47wFYdLGpfIFpkJlrDhn6QTJ79HLgCIggACdVp50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLIE0HIBAD5GcCfKq6i8x2w9XideqPLl0s/pN3HFJ32m38roLSvRqSI//N1FCG4QSs6HFKZtkN9FgfgPs8aH1/d8/YcYxaCP8SFdiTNwHMxK38GSVePWQcETAcR7cc2js9YjfzA6eZLbHD6HVyGPJuNCm8Zk6tfIFtyUvmuoMuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuf9PHHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuf9PHHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AB6C4CEE6;
	Mon, 24 Feb 2025 14:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407840;
	bh=OHE47wFYdLGpfIFpkJlrDhn6QTJ79HLgCIggACdVp50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zuf9PHHotxzzY2XmvunBH+/ZTsdhApqBBn5A+CXim60b0VhWGD/GVgtFvzDEZZVMn
	 RQCXAFDvDJ4ap0De5GuvaQUfWkS7n6J0+pMNcFTV4l3A0+ZPEbbnilHOptIpBtj4d5
	 TofPMNVEcRucWoHSz0vmEMTfEOHqX+rEnDKzxRBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 024/140] xfs: streamline xfs_filestream_pick_ag
Date: Mon, 24 Feb 2025 15:33:43 +0100
Message-ID: <20250224142603.954159768@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 81a1e1c32ef474c20ccb9f730afe1ac25b1c62a4 upstream.

Directly return the error from xfs_bmap_longest_free_extent instead
of breaking from the loop and handling it there, and use a done
label to directly jump to the exist when we found a suitable perag
structure to reduce the indentation level and pag/max_pag check
complexity in the tail of the function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_filestream.c |   96 +++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 50 deletions(-)

--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -67,22 +67,28 @@ xfs_filestream_pick_ag(
 	xfs_extlen_t		minfree, maxfree = 0;
 	xfs_agnumber_t		agno;
 	bool			first_pass = true;
-	int			err;
 
 	/* 2% of an AG's blocks must be free for it to be chosen. */
 	minfree = mp->m_sb.sb_agblocks / 50;
 
 restart:
 	for_each_perag_wrap(mp, start_agno, agno, pag) {
+		int		err;
+
 		trace_xfs_filestream_scan(pag, pino);
+
 		*longest = 0;
 		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
 		if (err) {
-			if (err != -EAGAIN)
-				break;
-			/* Couldn't lock the AGF, skip this AG. */
-			err = 0;
-			continue;
+			if (err == -EAGAIN) {
+				/* Couldn't lock the AGF, skip this AG. */
+				err = 0;
+				continue;
+			}
+			xfs_perag_rele(pag);
+			if (max_pag)
+				xfs_perag_rele(max_pag);
+			return err;
 		}
 
 		/* Keep track of the AG with the most free blocks. */
@@ -107,7 +113,9 @@ restart:
 			     !(flags & XFS_PICK_USERDATA) ||
 			     (flags & XFS_PICK_LOWSPACE))) {
 				/* Break out, retaining the reference on the AG. */
-				break;
+				if (max_pag)
+					xfs_perag_rele(max_pag);
+				goto done;
 			}
 		}
 
@@ -115,56 +123,44 @@ restart:
 		atomic_dec(&pag->pagf_fstrms);
 	}
 
-	if (err) {
-		xfs_perag_rele(pag);
-		if (max_pag)
-			xfs_perag_rele(max_pag);
-		return err;
+	/*
+	 * Allow a second pass to give xfs_bmap_longest_free_extent() another
+	 * attempt at locking AGFs that it might have skipped over before we
+	 * fail.
+	 */
+	if (first_pass) {
+		first_pass = false;
+		goto restart;
 	}
 
-	if (!pag) {
-		/*
-		 * Allow a second pass to give xfs_bmap_longest_free_extent()
-		 * another attempt at locking AGFs that it might have skipped
-		 * over before we fail.
-		 */
-		if (first_pass) {
-			first_pass = false;
-			goto restart;
-		}
-
-		/*
-		 * We must be low on data space, so run a final lowspace
-		 * optimised selection pass if we haven't already.
-		 */
-		if (!(flags & XFS_PICK_LOWSPACE)) {
-			flags |= XFS_PICK_LOWSPACE;
-			goto restart;
-		}
-
-		/*
-		 * No unassociated AGs are available, so select the AG with the
-		 * most free space, regardless of whether it's already in use by
-		 * another filestream. It none suit, just use whatever AG we can
-		 * grab.
-		 */
-		if (!max_pag) {
-			for_each_perag_wrap(args->mp, 0, start_agno, pag) {
-				max_pag = pag;
-				break;
-			}
+	/*
+	 * We must be low on data space, so run a final lowspace optimised
+	 * selection pass if we haven't already.
+	 */
+	if (!(flags & XFS_PICK_LOWSPACE)) {
+		flags |= XFS_PICK_LOWSPACE;
+		goto restart;
+	}
 
-			/* Bail if there are no AGs at all to select from. */
-			if (!max_pag)
-				return -ENOSPC;
+	/*
+	 * No unassociated AGs are available, so select the AG with the most
+	 * free space, regardless of whether it's already in use by another
+	 * filestream. It none suit, just use whatever AG we can grab.
+	 */
+	if (!max_pag) {
+		for_each_perag_wrap(args->mp, 0, start_agno, pag) {
+			max_pag = pag;
+			break;
 		}
 
-		pag = max_pag;
-		atomic_inc(&pag->pagf_fstrms);
-	} else if (max_pag) {
-		xfs_perag_rele(max_pag);
+		/* Bail if there are no AGs at all to select from. */
+		if (!max_pag)
+			return -ENOSPC;
 	}
 
+	pag = max_pag;
+	atomic_inc(&pag->pagf_fstrms);
+done:
 	trace_xfs_filestream_pick(pag, pino);
 	args->pag = pag;
 	return 0;


