Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D6B25228D;
	Thu, 20 Aug 2026 15:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239097; cv=none; b=hu+rsh6p15YCLZCWZN0oMpSk7rXruDvmCxDkvmgcJ9UqZGhFSaBBo5qYrqVjweD5wYtjP/Tzcb8UqRhI+ujTPJ8m//MWGkZ1gGJ6WdjNys7BkmJY6mvM85j7dDKvBXq0fvNq7B7SLhgoVtFAP4+tb9353p/TzeELnnLd41xacls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239097; c=relaxed/simple;
	bh=8bRq7zXkc+IJPzuOb0KfE6qrojcKdiyvIKfTpstc+7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JRwM9bBzeZ+pYv8JCqCUe46Bsa3tdsZuxBEKkdjiw3PMLcX+d06qYzIA7id2/+nAw5o1tWhZu2YP8gIJ7ndqf/RdciHRY5pgK2+qYLQgrjOGK5fhLrVhfUC0nxrxMjGp8ejWblahotaUEvnRaHmfxx2ciavVbhOaxVRyBR2Ai+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpj8vt53; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpj8vt53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151991F000E9;
	Thu, 20 Aug 2026 15:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239095;
	bh=OK1UCEvM3IOG7AoWa5CrwBkOX3XmyCKfr/+0qJVt/xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpj8vt53ZMZQ76jOaeEn/nGR4WSfcFIaY71OO2HeXU42vDakmX3h/gVikNCeWcAoW
	 7Z5Dt8/H9CtLbb3rzOHOBoISDk9Rdh87B+iaIEULYfLZ3Fs+fgXR6bS/P1O8TXCX2v
	 0vd7fmOmpzQ+Mr0CzsYZE276vtHj5Vg5qSJqsR6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 121/217] xfs: fix another iunlink infinite loop bug in online fsck
Date: Thu, 20 Aug 2026 16:54:49 +0200
Message-ID: <20260820145241.373811005@linuxfoundation.org>
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

commit 6d67c6b99f1fc07c64b97fcbc974c6f1ada7f622 upstream.

xrep_iunlink_resolve_bucket is supposed to reconstruct as much of the
incore prev and next unlinked list pointers based on what it finds on
disk and in memory before we move on to relinking the truly lost inodes
back into the unlinked list.  However, it's still vulnerable to infinite
loops that come in via the next_unlinked pointers.

Fix this problem by remembering which inodes we've already seen and
checking new agino pointers against that.  If a bit is already set,
either this is a loop or the inode has nonzero link count.  We'll deal
with the second case in a subsequent patch.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |   37 ++++++++++++++++++++++++++++---------
 fs/xfs/scrub/trace.h           |    1 +
 2 files changed, 29 insertions(+), 9 deletions(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1341,15 +1341,32 @@ xrep_iunlink_resolve_bucket(
 	struct xrep_agi		*ragi,
 	unsigned int		bucket)
 {
+	struct xagino_bitmap	seen;
 	struct xfs_scrub	*sc = ragi->sc;
 	struct xfs_inode	*ip;
 	xfs_agino_t		prev_agino = NULLAGINO;
 	xfs_agino_t		next_agino = ragi->iunlink_heads[bucket];
 	int			error = 0;
 
+	xagino_bitmap_init(&seen);
+
 	while (next_agino != NULLAGINO) {
+		unsigned int len = 1;
+
 		if (xchk_should_terminate(ragi->sc, &error))
-			return error;
+			goto out_bitmap;
+
+		/* Inode already seen?  We're stuck in a loop */
+		if (xagino_bitmap_test(&seen, next_agino, &len)) {
+			trace_xrep_iunlink_resolve_infinite_loop(sc->sa.pag,
+					bucket, prev_agino, next_agino);
+			next_agino = NULLAGINO;
+			break;
+		}
+
+		error = xagino_bitmap_set(&seen, next_agino, 1);
+		if (error)
+			goto out_bitmap;
 
 		/* Find the next inode in the chain. */
 		ip = xfs_iunlink_lookup(sc->sa.pag, next_agino);
@@ -1375,17 +1392,17 @@ xrep_iunlink_resolve_bucket(
 			error = xrep_iunlink_store_next(ragi, next_agino,
 					NULLAGINO);
 			if (error)
-				return error;
+				goto out_bitmap;
 
 			error = xrep_iunlink_store_prev(ragi, next_agino,
 					LINKED_AGINO);
 			if (error)
-				return error;
+				goto out_bitmap;
 
 			error = xagino_bitmap_clear(&ragi->iunlink_bmp,
 					next_agino, 1);
 			if (error)
-				return error;
+				goto out_bitmap;
 
 			next_agino = ip->i_next_unlinked;
 			continue;
@@ -1426,20 +1443,20 @@ xrep_iunlink_resolve_bucket(
 		 */
 		error = xagino_bitmap_clear(&ragi->iunlink_bmp, next_agino, 1);
 		if (error)
-			return error;
+			goto out_bitmap;
 
 		/* Remember the previous inode's next pointer. */
 		if (prev_agino != NULLAGINO) {
 			error = xrep_iunlink_store_next(ragi, prev_agino,
 					next_agino);
 			if (error)
-				return error;
+				goto out_bitmap;
 		}
 
 		/* Remember this inode's previous pointer. */
 		error = xrep_iunlink_store_prev(ragi, next_agino, prev_agino);
 		if (error)
-			return error;
+			goto out_bitmap;
 
 		/* Advance the list and remember this inode. */
 		prev_agino = next_agino;
@@ -1450,10 +1467,12 @@ xrep_iunlink_resolve_bucket(
 	if (prev_agino != NULLAGINO) {
 		error = xrep_iunlink_store_next(ragi, prev_agino, next_agino);
 		if (error)
-			return error;
+			goto out_bitmap;
 	}
 
-	return 0;
+out_bitmap:
+	xagino_bitmap_destroy(&seen);
+	return error;
 }
 
 /* Reinsert this unlinked inode into the head of the staged bucket list. */
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -3579,6 +3579,7 @@ DEFINE_EVENT(xrep_iunlink_resolve_class,
 	TP_PROTO(const struct xfs_perag *pag, unsigned int bucket, \
 		 xfs_agino_t prev_agino, xfs_agino_t next_agino), \
 	TP_ARGS(pag, bucket, prev_agino, next_agino))
+DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_infinite_loop);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_uncached);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_wronglist);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_nolist);


