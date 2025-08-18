Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BCE335BA7;
	Mon, 18 Aug 2025 13:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524958; cv=none; b=g1cEN2ClMczedSDJhbR2o+QipHtj97nDcXBGDUpCCUogka6XZHIJmg+sQs2C219nHYcsy++5QufYKbcZmMkZZA0FjsJXN4CXziz+fHtX/mRpuQ0eIC/oQAQJwMyjDQ1DyE08U/3I43ROhgG+NBYsbqd5V8QeQ0pKZZv42+KiydA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524958; c=relaxed/simple;
	bh=9G5FUPXq+F6yPfOlH+0EdaqIRjpHDoea3KM9vrk7S+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMo3m4cRxn+Ll6N3yRAuVZ++p2B0iRZ3IccMO2DPo+8IAECIvz618eCqzMAm2oMKjUc5KQc+dlUgoPNIB58qP0qURb6M02fr1AubJBsVdARXmY6K2j/sf1TSIeuNi1NQkzUeV0QtyiQbPEzdATi3+PSpHvC3jSbs1McG3WdstgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/tFx/W7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/tFx/W7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E112BC4CEF1;
	Mon, 18 Aug 2025 13:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524958;
	bh=9G5FUPXq+F6yPfOlH+0EdaqIRjpHDoea3KM9vrk7S+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b/tFx/W7e03ceFxaOVaa+FlJDeZlNZZ6ISqeKnTixj9OkJkH1jYhL95jni2WpEGD0
	 0u5+6mPbmjdutD/CFWnoMX4zOfoaKIUVpWVZ0AJyVEIY+TCeem5T9HbqVG7pns/bC9
	 EKCLYFpcoAv28mYUaDDjPYwSYssgh/UM727ceQ0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 098/570] btrfs: fix -ENOSPC mmap write failure on NOCOW files/extents
Date: Mon, 18 Aug 2025 14:41:25 +0200
Message-ID: <20250818124509.590997337@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 6599716de2d68ab7b3c0429221deca306dbda878 ]

If we attempt a mmap write into a NOCOW file or a prealloc extent when
there is no more available data space (or unallocated space to allocate a
new data block group) and we can do a NOCOW write (there are no reflinks
for the target extent or snapshots), we always fail due to -ENOSPC, unlike
for the regular buffered write and direct IO paths where we check that we
can do a NOCOW write in case we can't reserve data space.

Simple reproducer:

  $ cat test.sh
  #!/bin/bash

  DEV=/dev/sdi
  MNT=/mnt/sdi

  umount $DEV &> /dev/null
  mkfs.btrfs -f -b $((512 * 1024 * 1024)) $DEV
  mount $DEV $MNT

  touch $MNT/foobar
  # Make it a NOCOW file.
  chattr +C $MNT/foobar

  # Add initial data to file.
  xfs_io -c "pwrite -S 0xab 0 1M" $MNT/foobar

  # Fill all the remaining data space and unallocated space with data.
  dd if=/dev/zero of=$MNT/filler bs=4K &> /dev/null

  # Overwrite the file with a mmap write. Should succeed.
  xfs_io -c "mmap -w 0 1M"        \
         -c "mwrite -S 0xcd 0 1M" \
         -c "munmap"              \
         $MNT/foobar

  # Unmount, mount again and verify the new data was persisted.
  umount $MNT
  mount $DEV $MNT

  od -A d -t x1 $MNT/foobar

  umount $MNT

Running this:

  $ ./test.sh
  (...)
  wrote 1048576/1048576 bytes at offset 0
  1 MiB, 256 ops; 0.0008 sec (1.188 GiB/sec and 311435.5231 ops/sec)
  ./test.sh: line 24: 234865 Bus error               xfs_io -c "mmap -w 0 1M" -c "mwrite -S 0xcd 0 1M" -c "munmap" $MNT/foobar
  0000000 ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab
  *
  1048576

Fix this by not failing in case we can't allocate data space and we can
NOCOW into the target extent - reserving only metadata space in this case.

After this change the test passes:

  $ ./test.sh
  (...)
  wrote 1048576/1048576 bytes at offset 0
  1 MiB, 256 ops; 0.0007 sec (1.262 GiB/sec and 330749.3540 ops/sec)
  0000000 cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd
  *
  1048576

A test case for fstests will be added soon.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 59 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 51 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 8ce6f45f45e0..0a468bbfe015 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1842,6 +1842,7 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	loff_t size;
 	size_t fsize = folio_size(folio);
 	int ret;
+	bool only_release_metadata = false;
 	u64 reserved_space;
 	u64 page_start;
 	u64 page_end;
@@ -1862,10 +1863,34 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	 * end up waiting indefinitely to get a lock on the page currently
 	 * being processed by btrfs_page_mkwrite() function.
 	 */
-	ret = btrfs_delalloc_reserve_space(BTRFS_I(inode), &data_reserved,
-					   page_start, reserved_space);
-	if (ret < 0)
+	ret = btrfs_check_data_free_space(BTRFS_I(inode), &data_reserved,
+					  page_start, reserved_space, false);
+	if (ret < 0) {
+		size_t write_bytes = reserved_space;
+
+		if (btrfs_check_nocow_lock(BTRFS_I(inode), page_start,
+					   &write_bytes, false) <= 0)
+			goto out_noreserve;
+
+		only_release_metadata = true;
+
+		/*
+		 * Can't write the whole range, there may be shared extents or
+		 * holes in the range, bail out with @only_release_metadata set
+		 * to true so that we unlock the nocow lock before returning the
+		 * error.
+		 */
+		if (write_bytes < reserved_space)
+			goto out_noreserve;
+	}
+	ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode), reserved_space,
+					      reserved_space, false);
+	if (ret < 0) {
+		if (!only_release_metadata)
+			btrfs_free_reserved_data_space(BTRFS_I(inode), data_reserved,
+						       page_start, reserved_space);
 		goto out_noreserve;
+	}
 
 	ret = file_update_time(vmf->vma->vm_file);
 	if (ret < 0)
@@ -1906,10 +1931,16 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	if (folio_contains(folio, (size - 1) >> PAGE_SHIFT)) {
 		reserved_space = round_up(size - page_start, fs_info->sectorsize);
 		if (reserved_space < fsize) {
+			const u64 to_free = fsize - reserved_space;
+
 			end = page_start + reserved_space - 1;
-			btrfs_delalloc_release_space(BTRFS_I(inode),
-					data_reserved, end + 1,
-					fsize - reserved_space, true);
+			if (only_release_metadata)
+				btrfs_delalloc_release_metadata(BTRFS_I(inode),
+								to_free, true);
+			else
+				btrfs_delalloc_release_space(BTRFS_I(inode),
+							     data_reserved, end + 1,
+							     to_free, true);
 		}
 	}
 
@@ -1946,10 +1977,16 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 
 	btrfs_set_inode_last_sub_trans(BTRFS_I(inode));
 
+	if (only_release_metadata)
+		btrfs_set_extent_bit(io_tree, page_start, end, EXTENT_NORESERVE,
+				     &cached_state);
+
 	btrfs_unlock_extent(io_tree, page_start, page_end, &cached_state);
 	up_read(&BTRFS_I(inode)->i_mmap_lock);
 
 	btrfs_delalloc_release_extents(BTRFS_I(inode), fsize);
+	if (only_release_metadata)
+		btrfs_check_nocow_unlock(BTRFS_I(inode));
 	sb_end_pagefault(inode->i_sb);
 	extent_changeset_free(data_reserved);
 	return VM_FAULT_LOCKED;
@@ -1959,10 +1996,16 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	up_read(&BTRFS_I(inode)->i_mmap_lock);
 out:
 	btrfs_delalloc_release_extents(BTRFS_I(inode), fsize);
-	btrfs_delalloc_release_space(BTRFS_I(inode), data_reserved, page_start,
-				     reserved_space, true);
+	if (only_release_metadata)
+		btrfs_delalloc_release_metadata(BTRFS_I(inode), reserved_space, true);
+	else
+		btrfs_delalloc_release_space(BTRFS_I(inode), data_reserved,
+					     page_start, reserved_space, true);
 	extent_changeset_free(data_reserved);
 out_noreserve:
+	if (only_release_metadata)
+		btrfs_check_nocow_unlock(BTRFS_I(inode));
+
 	sb_end_pagefault(inode->i_sb);
 
 	if (ret < 0)
-- 
2.39.5



