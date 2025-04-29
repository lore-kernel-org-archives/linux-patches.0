Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790412522A2;
	Tue, 29 Apr 2025 16:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945773; cv=none; b=Lqr0uLrhCa6OxkOJyw6wIZckj0uwRwXSvpiJ01v/eVnBPv7Ju22WYSRubeIFqFzXQ6uaDFGzwJkJhmpmfcsvFAy9p2DcRseuxFjtN16N4pT1wsH2jMKj2koqGROwpx1WrIPeiFtg5HlzYzBqkLHFe5vo7sqwN7ImCbuk/EDTylI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945773; c=relaxed/simple;
	bh=c/F3T3FO7quPtdkRCg12Telz8UMP0RVaCMUHBVRO9/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E03fvCrMoxGP0IWP8rSEP/u5JKVSJSanlOA2389UVOdoVSS/BAqqZs1uRMLwBNgoMJsi8IsZOZaDnbDARyXXS348E8F5USePtgQiYsFCU/V+YiV3Y+cOzqXOI1d/7eWWG8BPsilpuarKtOu/PlRh/rjdclnWu0AteAZn/UDhCm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8n6NRTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8n6NRTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC72DC4CEE3;
	Tue, 29 Apr 2025 16:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945773;
	bh=c/F3T3FO7quPtdkRCg12Telz8UMP0RVaCMUHBVRO9/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8n6NRTFdLpsvq1mP9movISrvOK6reAK8Ec7xHsSSweeiduUC0TxC81XoBXbYN+kM
	 +pbHAh5TBRdYT+Q0WAxudglxN7L5N9Z1KXbt1+xCHGnZWXUY4VL0knpiEhyO9bT9bs
	 OYGqP7RAshc0v+5DB9q58SOwcvclnqtOuDUNYbqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 044/311] btrfs: avoid page_lockend underflow in btrfs_punch_hole_lock_range()
Date: Tue, 29 Apr 2025 18:38:01 +0200
Message-ID: <20250429161122.829991700@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit bc2dbc4983afedd198490cca043798f57c93e9bf ]

[BUG]
When running btrfs/004 with 4K fs block size and 64K page size,
sometimes fsstress workload can take 100% CPU for a while, but not long
enough to trigger a 120s hang warning.

[CAUSE]
When such 100% CPU usage happens, btrfs_punch_hole_lock_range() is
always in the call trace.

One example when this problem happens, the function
btrfs_punch_hole_lock_range() got the following parameters:

  lock_start = 4096, lockend = 20469

Then we calculate @page_lockstart by rounding up lock_start to page
boundary, which is 64K (page size is 64K).

For @page_lockend, we round down the value towards page boundary, which
result 0.  Then since we need to pass an inclusive end to
filemap_range_has_page(), we subtract 1 from the rounded down value,
resulting in (u64)-1.

In the above case, the range is inside the same page, and we do not even
need to call filemap_range_has_page(), not to mention to call it with
(u64)-1 at the end.

This behavior will cause btrfs_punch_hole_lock_range() to busy loop
waiting for irrelevant range to have its pages dropped.

[FIX]
Calculate @page_lockend by just rounding down @lockend, without
decreasing the value by one.  So @page_lockend will no longer overflow.

Then exit early if @page_lockend is no larger than @page_lockstart.
As it means either the range is inside the same page, or the two pages
are adjacent already.

Finally only decrease @page_lockend when calling filemap_range_has_page().

Fixes: 0528476b6ac7 ("btrfs: fix the filemap_range_has_page() call in btrfs_punch_hole_lock_range()")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0b568c8d24cbc..a92997a583bd2 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2104,15 +2104,20 @@ static void btrfs_punch_hole_lock_range(struct inode *inode,
 	 * will always return true.
 	 * So here we need to do extra page alignment for
 	 * filemap_range_has_page().
+	 *
+	 * And do not decrease page_lockend right now, as it can be 0.
 	 */
 	const u64 page_lockstart = round_up(lockstart, PAGE_SIZE);
-	const u64 page_lockend = round_down(lockend + 1, PAGE_SIZE) - 1;
+	const u64 page_lockend = round_down(lockend + 1, PAGE_SIZE);
 
 	while (1) {
 		truncate_pagecache_range(inode, lockstart, lockend);
 
 		lock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 			    cached_state);
+		/* The same page or adjacent pages. */
+		if (page_lockend <= page_lockstart)
+			break;
 		/*
 		 * We can't have ordered extents in the range, nor dirty/writeback
 		 * pages, because we have locked the inode's VFS lock in exclusive
@@ -2124,7 +2129,7 @@ static void btrfs_punch_hole_lock_range(struct inode *inode,
 		 * we do, unlock the range and retry.
 		 */
 		if (!filemap_range_has_page(inode->i_mapping, page_lockstart,
-					    page_lockend))
+					    page_lockend - 1))
 			break;
 
 		unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-- 
2.39.5



