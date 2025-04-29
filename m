Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1325E40C03;
	Tue, 29 Apr 2025 18:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950303; cv=none; b=UO4FWNbGNJcqIllicl7RXN0F0exgLYckQO3Bvy06yDGryvQdZ7Ml1Mku3SUCtTcmyBob7dMWycQ7lH8aidTjz0BND3Yr5EGj6hJHEneKcS1blIg+lgEeQAxhE6D7Gto0OJG5gbnunNfg6PFsetxVlekFY9gOPLgfXosQzt8a9Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950303; c=relaxed/simple;
	bh=+8vKhwmAanMqhy6vBzbWPU7xl9FZrOC3IM8cRUPGAec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8RELzjshzR49lUxTEWqcKAQqazSHHuo3s3lbzsLWiLcJG+2IolEDfBw9hnk4nDuA7UKEarOOb0wxjTHdWd6T7lPwq54yb7Hji58caN6/+ZI2YIS/f1FDqMDFr3+craG5LR/Yt7lWHgu+5snapHVcjwIWD68CQT2HGUCHLAOsjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=id1DTPL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="id1DTPL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE74C4CEE3;
	Tue, 29 Apr 2025 18:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950302;
	bh=+8vKhwmAanMqhy6vBzbWPU7xl9FZrOC3IM8cRUPGAec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=id1DTPL8gQbUXa5hfK970uMAohj2peZO1/RevlnVOFeACZBQflHy88HRo6+kxfRBm
	 tDBaT3D3IZ4WLO945oCjyAg8d8WRROs1KuFTsay+W3SoCVc0/grSsAoZshrF79NfKj
	 64HZsK2K3iyhkiGSEtk1356Hf6XJZPFoBSK/VTcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/204] btrfs: avoid page_lockend underflow in btrfs_punch_hole_lock_range()
Date: Tue, 29 Apr 2025 18:42:20 +0200
Message-ID: <20250429161101.537626314@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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
index 68092b64e29ea..e794606e7c780 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2225,15 +2225,20 @@ static void btrfs_punch_hole_lock_range(struct inode *inode,
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
@@ -2245,7 +2250,7 @@ static void btrfs_punch_hole_lock_range(struct inode *inode,
 		 * we do, unlock the range and retry.
 		 */
 		if (!filemap_range_has_page(inode->i_mapping, page_lockstart,
-					    page_lockend))
+					    page_lockend - 1))
 			break;
 
 		unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-- 
2.39.5



