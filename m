Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83091289E2C;
	Tue,  8 Jul 2025 16:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992874; cv=none; b=W10LHbq1XTRo5M3HDdh17ub8g9TfDVUbs0O00JPOzQr01ecgtoRwqf2nqiSVW91zUaQcoIvLCkss6cM7F0brM4O9xrL2KMoqnPCzcKYb6KIfVnDokMIC1VO4GAVas1LUpbMK8P8AsNKWeYyQisAnoLB0DvpoEVHLEVPHgKQX8pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992874; c=relaxed/simple;
	bh=n6AkOuZLxm94mbxZ+X4MMU33ojZHbcQW8xOxXz42Wvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBFdBndB6QU80gwBUClB1txLgN/zXuax+Nkhmy4z8bYNRxwN0hrqc5Jz19Wbj9TnC4f/EWsCkhs/txEB9Hx5V92dde+f1VBNm9SJn+hKAQIwiUSccKC7VSc60+zYNvdTLLEeZkM5ui9bppmXvJVRXDHFMqVhZOlIh0fF16ZXekY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulO+Nt8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulO+Nt8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B090C4CEED;
	Tue,  8 Jul 2025 16:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992874;
	bh=n6AkOuZLxm94mbxZ+X4MMU33ojZHbcQW8xOxXz42Wvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulO+Nt8Py6bGXIeHxFilASJFpHizfumCwkl45QvXxJ0tOW90VTNOqAhkzyCtf4Axr
	 lORpJjX4niwKGe31tsVA5L/Dz+bpEo11s9CWPgHRy+E0YWiMb2kIU364wpOP/6zgpt
	 PXTzf2WCFya2JA8R4PYtlBI1y5m747k3lE3jeLuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/232] btrfs: prepare btrfs_page_mkwrite() for large folios
Date: Tue,  8 Jul 2025 18:21:47 +0200
Message-ID: <20250708162244.343041687@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 49990d8fa27d75f8ecf4ad013b13de3c4b1ff433 ]

This changes the assumption that the folio is always page sized.
(Although the ASSERT() for folio order is still kept as-is).

Just replace the PAGE_SIZE with folio_size().

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 17a85f520469 ("btrfs: fix wrong start offset for delalloc space release during mmap write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index eaa991e698049..86e7150babd5c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1912,6 +1912,7 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	struct extent_changeset *data_reserved = NULL;
 	unsigned long zero_start;
 	loff_t size;
+	size_t fsize = folio_size(folio);
 	vm_fault_t ret;
 	int ret2;
 	int reserved = 0;
@@ -1922,7 +1923,7 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 
 	ASSERT(folio_order(folio) == 0);
 
-	reserved_space = PAGE_SIZE;
+	reserved_space = fsize;
 
 	sb_start_pagefault(inode->i_sb);
 	page_start = folio_pos(folio);
@@ -1976,7 +1977,7 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	 * We can't set the delalloc bits if there are pending ordered
 	 * extents.  Drop our locks and wait for them to finish.
 	 */
-	ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), page_start, PAGE_SIZE);
+	ordered = btrfs_lookup_ordered_range(BTRFS_I(inode), page_start, fsize);
 	if (ordered) {
 		unlock_extent(io_tree, page_start, page_end, &cached_state);
 		folio_unlock(folio);
@@ -1988,11 +1989,11 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 
 	if (folio->index == ((size - 1) >> PAGE_SHIFT)) {
 		reserved_space = round_up(size - page_start, fs_info->sectorsize);
-		if (reserved_space < PAGE_SIZE) {
+		if (reserved_space < fsize) {
 			end = page_start + reserved_space - 1;
 			btrfs_delalloc_release_space(BTRFS_I(inode),
 					data_reserved, page_start,
-					PAGE_SIZE - reserved_space, true);
+					fsize - reserved_space, true);
 		}
 	}
 
@@ -2019,12 +2020,12 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	if (page_start + folio_size(folio) > size)
 		zero_start = offset_in_folio(folio, size);
 	else
-		zero_start = PAGE_SIZE;
+		zero_start = fsize;
 
-	if (zero_start != PAGE_SIZE)
+	if (zero_start != fsize)
 		folio_zero_range(folio, zero_start, folio_size(folio) - zero_start);
 
-	btrfs_folio_clear_checked(fs_info, folio, page_start, PAGE_SIZE);
+	btrfs_folio_clear_checked(fs_info, folio, page_start, fsize);
 	btrfs_folio_set_dirty(fs_info, folio, page_start, end + 1 - page_start);
 	btrfs_folio_set_uptodate(fs_info, folio, page_start, end + 1 - page_start);
 
@@ -2033,7 +2034,7 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	unlock_extent(io_tree, page_start, page_end, &cached_state);
 	up_read(&BTRFS_I(inode)->i_mmap_lock);
 
-	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), fsize);
 	sb_end_pagefault(inode->i_sb);
 	extent_changeset_free(data_reserved);
 	return VM_FAULT_LOCKED;
@@ -2042,7 +2043,7 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	folio_unlock(folio);
 	up_read(&BTRFS_I(inode)->i_mmap_lock);
 out:
-	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), fsize);
 	btrfs_delalloc_release_space(BTRFS_I(inode), data_reserved, page_start,
 				     reserved_space, (ret != 0));
 out_noreserve:
-- 
2.39.5



