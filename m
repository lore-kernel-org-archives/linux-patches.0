Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232843ACEFE;
	Thu, 15 Jan 2026 17:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496660; cv=none; b=XAbFMn0x1z5oLrVINRZRu6kW6NTAYK+T9VjwU3cwbYGguYg0t8MErXXNc6kXY2nnponm606RncjIOD9AyvaDk5hS92lcD1KWG7iHZJWYGsnX1juJPQSsqseBOY/OOjqDS3n5XqWbzFAnqFgNPWofIoGEARsTVG9hJFoFlEysZxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496660; c=relaxed/simple;
	bh=aUOC/sZX061TmKfycLbFd6H73bA4N1wRQG83gec4ZxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGPtVU7/O2G4Ad9SdO9X7v+N+OqMRlnaLi7+5IYchYrr2uC+Zq+4tAAwMS+cvvnLGKx4BCm+XeZpq8T/AGCwUs/RXFcRDxXl/VkUbXst+MtXFygRF08h0tXJmVv/Whcyqs1V8mi3BEwNlfsDGje4Zes/wdenhRHAMTf1+U3lHZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKFqJNIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKFqJNIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64039C116D0;
	Thu, 15 Jan 2026 17:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496659;
	bh=aUOC/sZX061TmKfycLbFd6H73bA4N1wRQG83gec4ZxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKFqJNIcfacQYpdmOWCE1ebgqCAXab+27NAgZ+MuWn9tCO/HAsTm6mpeuYIaZxsXP
	 hFhnO8JtOUOZ5iEifD7SVyoVgGpron771fbyf509gepwrEiBrPt6tLNlMl2fwmCiMi
	 DLzEKSxXnAml2uFDZZ/qNINpqDn1ZNV5YKLih03g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/119] btrfs: fix error handling of submit_uncompressed_range()
Date: Thu, 15 Jan 2026 17:48:25 +0100
Message-ID: <20260115164155.198626604@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit a7858d5c36cae52eaf3048490b05c0b19086073b ]

[BUG]
If we failed to compress the range, or cannot reserve a large enough
data extent (e.g. too fragmented free space), we will fall back to
submit_uncompressed_range().

But inside submit_uncompressed_range(), run_delalloc_cow() can also fail
due to -ENOSPC or any other error.

In that case there are 3 bugs in the error handling:

1) Double freeing for the same ordered extent
   This can lead to crash due to ordered extent double accounting

2) Start/end writeback without updating the subpage writeback bitmap

3) Unlock the folio without clear the subpage lock bitmap

Both bugs 2) and 3) will crash the kernel if the btrfs block size is
smaller than folio size, as the next time the folio gets writeback/lock
updates, subpage will find the bitmap already have the range set,
triggering an ASSERT().

[CAUSE]
Bug 1) happens in the following call chain:

  submit_uncompressed_range()
  |- run_delalloc_cow()
  |  |- cow_file_range()
  |     |- btrfs_reserve_extent()
  |        Failed with -ENOSPC or whatever error
  |
  |- btrfs_clean_up_ordered_extents()
  |  |- btrfs_mark_ordered_io_finished()
  |     Which cleans all the ordered extents in the async_extent range.
  |
  |- btrfs_mark_ordered_io_finished()
     Which cleans the folio range.

The finished ordered extents may not be immediately removed from the
ordered io tree, as they are removed inside a work queue.

So the second btrfs_mark_ordered_io_finished() may find the finished but
not-yet-removed ordered extents, and double free them.

Furthermore, the second btrfs_mark_ordered_io_finished() is not subpage
compatible, as it uses fixed folio_pos() with PAGE_SIZE, which can cover
other ordered extents.

Bugs 2) and 3) are more straightforward, btrfs just calls folio_unlock(),
folio_start_writeback() and folio_end_writeback(), other than the helpers
which handle subpage cases.

[FIX]
For bug 1) since the first btrfs_cleanup_ordered_extents() call is
handling the whole range, we should not do the second
btrfs_mark_ordered_io_finished() call.

And for the first btrfs_cleanup_ordered_extents(), we no longer need to
pass the @locked_page parameter, as we are already in the async extent
context, thus will never rely on the error handling inside
btrfs_run_delalloc_range().

So just let the btrfs_clean_up_ordered_extents() handle every folio
equally.

For bug 2) we should not even call
folio_start_writeback()/folio_end_writeback() anymore.
As the error handling protocol, cow_file_range() should clear
dirty flag and start/finish the writeback for the whole range passed in.

For bug 3) just change the folio_unlock() to btrfs_folio_end_lock()
helper.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: e9e3b22ddfa7 ("btrfs: fix beyond-EOF write handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1159,19 +1159,10 @@ static void submit_uncompressed_range(st
 			       &wbc, false);
 	wbc_detach_inode(&wbc);
 	if (ret < 0) {
-		btrfs_cleanup_ordered_extents(inode, locked_folio,
-					      start, end - start + 1);
-		if (locked_folio) {
-			const u64 page_start = folio_pos(locked_folio);
-
-			folio_start_writeback(locked_folio);
-			folio_end_writeback(locked_folio);
-			btrfs_mark_ordered_io_finished(inode, locked_folio,
-						       page_start, PAGE_SIZE,
-						       !ret);
-			mapping_set_error(locked_folio->mapping, ret);
-			folio_unlock(locked_folio);
-		}
+		btrfs_cleanup_ordered_extents(inode, NULL, start, end - start + 1);
+		if (locked_folio)
+			btrfs_folio_end_lock(inode->root->fs_info, locked_folio,
+					     start, async_extent->ram_size);
 	}
 }
 


