Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FCA3BC4DB;
	Thu, 15 Jan 2026 17:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496666; cv=none; b=bAbl0aVBxiyZFQYvqrojq0iri2DMO//Dbn6aO9DzIvoe5yR8D7zUpUZacXKRQ3HUocD13RuuOBk2zwPcmMDW2fdCCls5CzUILqRIZFgg0pGJtlLXCpN5t7RLvBL66yCRHZGnOb51+8YU5UtBH8OYk2bG4C4Yb4v1wqUS2+TEREk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496666; c=relaxed/simple;
	bh=BVqE+fxDxPrmES1TkHpWIKlQvd0+5NkiTwAMG3XjuXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRfVgGvVwdft9Bw/BuHa/u1RH06/ZZAtRMbwnBR17s0QR/cmVM3q0Ru1UQyWalXx+BFLqjnfgFXRn6y9yOA+jOM0vEnGdrGBDKfcRR2ponbMIrPPL3nYVDI1hwYYX5/fR7keSws9o8nBGZRHUyoE/EMNeMil2Z2Uc+kafRgbKJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHpElFVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHpElFVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2C7C116D0;
	Thu, 15 Jan 2026 17:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496665;
	bh=BVqE+fxDxPrmES1TkHpWIKlQvd0+5NkiTwAMG3XjuXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHpElFVbeIvFk/CpZ/cnQrey5pRpKuoASrekAb3L4E1Hd3lojr+xVctCliOc+YCPi
	 6JfMo99A9EhAuJ9PS66HuYvg+h6IPzQo4QiEHz06vQRqQu8+yy1FkzVMjFm5zAj8PT
	 lDAglk1fkf0uffh5CVHn9AjH3HjBjQRKLD2uvKS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/119] btrfs: add extra error messages for delalloc range related errors
Date: Thu, 15 Jan 2026 17:48:27 +0100
Message-ID: <20260115164155.270675216@linuxfoundation.org>
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

[ Upstream commit 975a6a8855f45729a0fbfe2a8f2df2d3faef2a97 ]

All the error handling bugs I hit so far are all -ENOSPC from either:

- cow_file_range()
- run_delalloc_nocow()
- submit_uncompressed_range()

Previously when those functions failed, there was no error message at
all, making the debugging much harder.

So here we introduce extra error messages for:

- cow_file_range()
- run_delalloc_nocow()
- submit_uncompressed_range()
- writepage_delalloc() when btrfs_run_delalloc_range() failed
- extent_writepage() when extent_writepage_io() failed

One example of the new debug error messages is the following one:

  run fstests generic/750 at 2024-12-08 12:41:41
  BTRFS: device fsid 461b25f5-e240-4543-8deb-e7c2bd01a6d3 devid 1 transid 8 /dev/mapper/test-scratch1 (253:4) scanned by mount (2436600)
  BTRFS info (device dm-4): first mount of filesystem 461b25f5-e240-4543-8deb-e7c2bd01a6d3
  BTRFS info (device dm-4): using crc32c (crc32c-arm64) checksum algorithm
  BTRFS info (device dm-4): forcing free space tree for sector size 4096 with page size 65536
  BTRFS info (device dm-4): using free-space-tree
  BTRFS warning (device dm-4): read-write for sector size 4096 with page size 65536 is experimental
  BTRFS info (device dm-4): checking UUID tree
  BTRFS error (device dm-4): cow_file_range failed, root=363 inode=412 start=503808 len=98304: -28
  BTRFS error (device dm-4): run_delalloc_nocow failed, root=363 inode=412 start=503808 len=98304: -28
  BTRFS error (device dm-4): failed to run delalloc range, root=363 ino=412 folio=458752 submit_bitmap=11-15 start=503808 len=98304: -28

Which shows an error from cow_file_range() which is called inside a
nocow write attempt, along with the extra bitmap from
writepage_delalloc().

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: e9e3b22ddfa7 ("btrfs: fix beyond-EOF write handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   15 +++++++++++++++
 fs/btrfs/inode.c     |   12 ++++++++++++
 2 files changed, 27 insertions(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1322,6 +1322,15 @@ static noinline_for_stack int writepage_
 						       wbc);
 			if (ret >= 0)
 				last_finished_delalloc_end = found_start + found_len;
+			if (unlikely(ret < 0))
+				btrfs_err_rl(fs_info,
+"failed to run delalloc range, root=%lld ino=%llu folio=%llu submit_bitmap=%*pbl start=%llu len=%u: %d",
+					     btrfs_root_id(inode->root),
+					     btrfs_ino(inode),
+					     folio_pos(folio),
+					     fs_info->sectors_per_page,
+					     &bio_ctrl->submit_bitmap,
+					     found_start, found_len, ret);
 		} else {
 			/*
 			 * We've hit an error during previous delalloc range,
@@ -1621,6 +1630,12 @@ static int extent_writepage(struct folio
 				  PAGE_SIZE, bio_ctrl, i_size);
 	if (ret == 1)
 		return 0;
+	if (ret < 0)
+		btrfs_err_rl(fs_info,
+"failed to submit blocks, root=%lld inode=%llu folio=%llu submit_bitmap=%*pbl: %d",
+			     btrfs_root_id(inode->root), btrfs_ino(inode),
+			     folio_pos(folio), fs_info->sectors_per_page,
+			     &bio_ctrl->submit_bitmap, ret);
 
 	bio_ctrl->wbc->nr_to_write--;
 
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1163,6 +1163,10 @@ static void submit_uncompressed_range(st
 		if (locked_folio)
 			btrfs_folio_end_lock(inode->root->fs_info, locked_folio,
 					     start, async_extent->ram_size);
+		btrfs_err_rl(inode->root->fs_info,
+			"%s failed, root=%llu inode=%llu start=%llu len=%llu: %d",
+			     __func__, btrfs_root_id(inode->root),
+			     btrfs_ino(inode), start, async_extent->ram_size, ret);
 	}
 }
 
@@ -1623,6 +1627,10 @@ out_unlock:
 					     &cached, clear_bits, page_ops);
 		btrfs_qgroup_free_data(inode, NULL, start, end - start + 1, NULL);
 	}
+	btrfs_err_rl(fs_info,
+		     "%s failed, root=%llu inode=%llu start=%llu len=%llu: %d",
+		     __func__, btrfs_root_id(inode->root),
+		     btrfs_ino(inode), orig_start, end + 1 - orig_start, ret);
 	return ret;
 }
 
@@ -2373,6 +2381,10 @@ error:
 		btrfs_qgroup_free_data(inode, NULL, cur_offset, end - cur_offset + 1, NULL);
 	}
 	btrfs_free_path(path);
+	btrfs_err_rl(fs_info,
+		     "%s failed, root=%llu inode=%llu start=%llu len=%llu: %d",
+		     __func__, btrfs_root_id(inode->root),
+		     btrfs_ino(inode), start, end + 1 - start, ret);
 	return ret;
 }
 


