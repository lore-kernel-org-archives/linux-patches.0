Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878692FA625;
	Tue, 17 Jun 2025 16:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178485; cv=none; b=U9zCIAVIIgBOrLhG9b9wPAvj6ATB9GZ0quY2j/lRtA6OXPTobxcA5m+fOtxSxCUxuTjXauVR2k3WOYzd/BBzvbpNHtoaqcxJSn/YVPzS99P1BSvzYplNaSUyHF/ZysrYWADFaKjlAX4YW/wnLP+seCDtm87BFpqjYauPVOPdnHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178485; c=relaxed/simple;
	bh=vr6HkXRbyTEkvPNOcsWMXT2CikG+53o81bVhmhF1O4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCy05hz+X+UBoE4a2tBTBkKXtwFuevbNM25AxBpKQyppaOqA58HkKrI1uQjdD5rxPdpt7aQSbFR4vNktQoftNWy+y6nMmFyOnjr8bouFTKizIQ+xanWOe9HL+B0rDpLWDs+KOVlmbed7cUS2jsg5Lo9niNd1Ctl+qr4fPSrZEcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WXt8xz+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WXt8xz+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F4BC4CEE3;
	Tue, 17 Jun 2025 16:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178485;
	bh=vr6HkXRbyTEkvPNOcsWMXT2CikG+53o81bVhmhF1O4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXt8xz+MBBrhJYUhj0JcYv2pJnEL9YDJPZVSjTrlq7+ep7Ha6f2SkA4ymZIpQV2+X
	 bik7k0+Qgdi5/k6FKft1GkNgOpRXp7wLkGuyR5KvwsvjjGRTz5j/lgJukPIvR1Kw/n
	 ydZRryxQB0WeuXDcNeggjDtdn07Qnqk0unHDz1NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Dave Chinner <dchinner@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 466/780] iomap: dont lose folio dropbehind state for overwrites
Date: Tue, 17 Jun 2025 17:22:54 +0200
Message-ID: <20250617152510.467992197@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 34ecde3c56066ba79e5ec3d93c5b14ea83e3603e ]

DONTCACHE I/O must have the completion punted to a workqueue, just like
what is done for unwritten extents, as the completion needs task context
to perform the invalidation of the folio(s). However, if writeback is
started off filemap_fdatawrite_range() off generic_sync() and it's an
overwrite, then the DONTCACHE marking gets lost as iomap_add_to_ioend()
don't look at the folio being added and no further state is passed down
to help it know that this is a dropbehind/DONTCACHE write.

Check if the folio being added is marked as dropbehind, and set
IOMAP_IOEND_DONTCACHE if that is the case. Then XFS can factor this into
the decision making of completion context in xfs_submit_ioend().
Additionally include this ioend flag in the NOMERGE flags, to avoid
mixing it with unrelated IO.

Since this is the 3rd flag that will cause XFS to punt the completion to
a workqueue, add a helper so that each one of them can get appropriately
commented.

This fixes extra page cache being instantiated when the write performed
is an overwrite, rather than newly instantiated blocks.

Fixes: b2cd5ae693a3 ("iomap: make buffered writes work with RWF_DONTCACHE")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/5153f6e8-274d-4546-bf55-30a5018e0d03@kernel.dk
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c |  2 ++
 fs/xfs/xfs_aops.c      | 22 ++++++++++++++++++++--
 include/linux/iomap.h  |  5 ++++-
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 5b08bd417b287..0ac474888a02e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1675,6 +1675,8 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
 		ioend_flags |= IOMAP_IOEND_UNWRITTEN;
 	if (wpc->iomap.flags & IOMAP_F_SHARED)
 		ioend_flags |= IOMAP_IOEND_SHARED;
+	if (folio_test_dropbehind(folio))
+		ioend_flags |= IOMAP_IOEND_DONTCACHE;
 	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
 		ioend_flags |= IOMAP_IOEND_BOUNDARY;
 
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 26a04a7834896..63151feb9c3fd 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -436,6 +436,25 @@ xfs_map_blocks(
 	return 0;
 }
 
+static bool
+xfs_ioend_needs_wq_completion(
+	struct iomap_ioend	*ioend)
+{
+	/* Changing inode size requires a transaction. */
+	if (xfs_ioend_is_append(ioend))
+		return true;
+
+	/* Extent manipulation requires a transaction. */
+	if (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED))
+		return true;
+
+	/* Page cache invalidation cannot be done in irq context. */
+	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE)
+		return true;
+
+	return false;
+}
+
 static int
 xfs_submit_ioend(
 	struct iomap_writepage_ctx *wpc,
@@ -460,8 +479,7 @@ xfs_submit_ioend(
 	memalloc_nofs_restore(nofs_flag);
 
 	/* send ioends that might require a transaction to the completion wq */
-	if (xfs_ioend_is_append(ioend) ||
-	    (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED)))
+	if (xfs_ioend_needs_wq_completion(ioend))
 		ioend->io_bio.bi_end_io = xfs_end_bio;
 
 	if (status)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 68416b135151d..522644d62f30f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -377,13 +377,16 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 #define IOMAP_IOEND_BOUNDARY		(1U << 2)
 /* is direct I/O */
 #define IOMAP_IOEND_DIRECT		(1U << 3)
+/* is DONTCACHE I/O */
+#define IOMAP_IOEND_DONTCACHE		(1U << 4)
 
 /*
  * Flags that if set on either ioend prevent the merge of two ioends.
  * (IOMAP_IOEND_BOUNDARY also prevents merges, but only one-way)
  */
 #define IOMAP_IOEND_NOMERGE_FLAGS \
-	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT)
+	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT | \
+	 IOMAP_IOEND_DONTCACHE)
 
 /*
  * Structure for writeback I/O completions.
-- 
2.39.5



