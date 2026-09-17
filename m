Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE283CC7F8;
	Thu, 17 Sep 2026 19:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671740; cv=none; b=d48qsSKkdoLKsg55XVRxlYIzYD/1JZ0NzQY5Bj/EBnunHnaOXHRZkMtxTp5v1ylqkCFP8dX+tHcbFLoJ7KjPSBLHaWqKF5F4tqyDZMbjgSvHfdeiQjd7F7l2D0V6J5oBcxocKjW+Em8dQfr5rDYs21+TVUkcbTYqK7S8DQi1Rjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671740; c=relaxed/simple;
	bh=c6wwXlNoPoGVgTHJangoi38XRSmB07wE2Cz4ao/jwLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4ngit6nsEZAjUTBXOeTLAvC6jyYudCT+WY1dlJAnpN2IM0sVBvyk171QWx/BUjRXvIPm4d+YCObnojRmfrn1Em31qhJrjlvEJvb8M5dkey3wooX0ox7etV1NFE+PKO9vCF7Ue4/EMdirtCJLeRi0AfV36ltKTEjovINH+3BToU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+BAy3RF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+BAy3RF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3308B1F000FF;
	Thu, 17 Sep 2026 19:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671738;
	bh=pHzg22qT6pkTkiiCE2sJ6IIrIAkdU/jqn/6yXaIBQYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y+BAy3RFVHIYRlyNOu9PnU+qHv6nf1+HzRq36CJ6tKP5K6ifcsOwCm10LS4r97WP0
	 1g1B0+PRkcixoGpv5EDVLYu0tFLeTveOMi/um6iiG1jZOTxMGMoODK0Cbg2EPbd/ia
	 2imFj4H+0q3AKIbM3fy+pqC0qEysKB3ZN6bJHpfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1047/1102] btrfs: prepare btrfs_punch_hole_lock_range() for large data folios
Date: Thu, 17 Sep 2026 16:16:30 +0100
Message-ID: <20260917151607.082567058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
Message-ID: <20260917151630.sFcsUYJnubdFvysniojdr9ezKToknOE1pcUp__ALZcc@z>

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 1e5773e0bab761c853eaf7286394905a544ef02d ]

The function btrfs_punch_hole_lock_range() needs to make sure there is
no other folio in the range, thus it goes with filemap_range_has_page(),
which works pretty fine.

But if we have large folios, under the following case
filemap_range_has_page() will always return true, forcing
btrfs_punch_hole_lock_range() to do a very time consuming busy loop:

        start                            end
        |                                |
  |//|//|//|//|  |  |  |  |  |  |  |  |//|//|
   \         /                         \   /
    Folio A                            Folio B

In the above case, folio A and B contain our start/end indexes, and there
are no other folios in the range.  Thus we do not need to retry inside
btrfs_punch_hole_lock_range().

To prepare for large data folios, introduce a helper,
check_range_has_page(), which will:

- Shrink the search range towards page boundaries
  If the rounded down end (exclusive, otherwise it can underflow when @end
  is inside the folio at file offset 0) is no larger than the rounded up
  start, it means the range contains no other pages other than the ones
  covering @start and @end.

  Can return false directly in that case.

- Grab all the folios inside the range

- Skip any large folios that cover the start and end indexes

- If any other folios are found return true

- Otherwise return false

This new helper is going to handle both large folios and regular ones.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 3f950867c307 ("btrfs: fix extent map leak in NOCOW direct I/O write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 56 insertions(+), 11 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2204,11 +2204,29 @@ static int find_first_non_hole(struct bt
 	return ret;
 }
 
-static void btrfs_punch_hole_lock_range(struct inode *inode,
-					const u64 lockstart,
-					const u64 lockend,
-					struct extent_state **cached_state)
+/*
+ * Check if there is no folio in the range.
+ *
+ * We cannot utilize filemap_range_has_page() in a filemap with large folios
+ * as we can hit the following false positive:
+ *
+ *        start                            end
+ *        |                                |
+ *  |//|//|//|//|  |  |  |  |  |  |  |  |//|//|
+ *   \         /                         \   /
+ *    Folio A                            Folio B
+ *
+ * That large folio A and B cover the start and end indexes.
+ * In that case filemap_range_has_page() will always return true, but the above
+ * case is fine for btrfs_punch_hole_lock_range() usage.
+ *
+ * So here we only ensure that no other folios is in the range, excluding the
+ * head/tail large folio.
+ */
+static bool check_range_has_page(struct inode *inode, u64 start, u64 end)
 {
+	struct folio_batch fbatch;
+	bool ret = false;
 	/*
 	 * For subpage case, if the range is not at page boundary, we could
 	 * have pages at the leading/tailing part of the range.
@@ -2219,17 +2237,45 @@ static void btrfs_punch_hole_lock_range(
 	 *
 	 * And do not decrease page_lockend right now, as it can be 0.
 	 */
-	const u64 page_lockstart = round_up(lockstart, PAGE_SIZE);
-	const u64 page_lockend = round_down(lockend + 1, PAGE_SIZE);
+	const u64 page_lockstart = round_up(start, PAGE_SIZE);
+	const u64 page_lockend = round_down(end + 1, PAGE_SIZE);
+	const pgoff_t start_index = page_lockstart >> PAGE_SHIFT;
+	const pgoff_t end_index = (page_lockend - 1) >> PAGE_SHIFT;
+	pgoff_t tmp = start_index;
+	int found_folios;
+
+	/* The same page or adjacent pages. */
+	if (page_lockend <= page_lockstart)
+		return false;
 
+	folio_batch_init(&fbatch);
+	found_folios = filemap_get_folios(inode->i_mapping, &tmp, end_index, &fbatch);
+	for (int i = 0; i < found_folios; i++) {
+		struct folio *folio = fbatch.folios[i];
+
+		/* A large folio begins before the start. Not a target. */
+		if (folio->index < start_index)
+			continue;
+		/* A large folio extends beyond the end. Not a target. */
+		if (folio->index + folio_nr_pages(folio) > end_index)
+			continue;
+		/* A folio doesn't cover the head/tail index. Found a target. */
+		ret = true;
+		break;
+	}
+	folio_batch_release(&fbatch);
+	return ret;
+}
+
+static void btrfs_punch_hole_lock_range(struct inode *inode,
+					const u64 lockstart, const u64 lockend,
+					struct extent_state **cached_state)
+{
 	while (1) {
 		truncate_pagecache_range(inode, lockstart, lockend);
 
 		lock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 			    cached_state);
-		/* The same page or adjacent pages. */
-		if (page_lockend <= page_lockstart)
-			break;
 		/*
 		 * We can't have ordered extents in the range, nor dirty/writeback
 		 * pages, because we have locked the inode's VFS lock in exclusive
@@ -2240,8 +2286,7 @@ static void btrfs_punch_hole_lock_range(
 		 * locking the range check if we have pages in the range, and if
 		 * we do, unlock the range and retry.
 		 */
-		if (!filemap_range_has_page(inode->i_mapping, page_lockstart,
-					    page_lockend - 1))
+		if (!check_range_has_page(inode, lockstart, lockend))
 			break;
 
 		unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend,


