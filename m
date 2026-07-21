Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BFC46EF7A;
	Tue, 21 Jul 2026 18:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659612; cv=none; b=kVFNPPWuozxCWtYnXxOVNWUbw3KyL4wC8WTR931aNqvxPI0fbEaEMTdEz2RDepM96VvO+GULIzUm8oXk/xAooL266+dEJU76tS3PQXE1dp2HpDodrP7fJy6UBQciR0fTdKh8P6Ev/dayodFzdVOZxBfak/IWFrJ06zrrOGqng7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659612; c=relaxed/simple;
	bh=1Hv3TcmnkwhmEzPlzSYzM5Tl/UeB9MT5rOceDmrqIK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEMxK9UVbVPoq57zGzO7aYSYk6rKiBXnUskEVbUTzBhukKLAP2t7IU0ifJrsh/+OyAZpQJx9nAmE3d41kX7X+4JvkQNg97PwOU5x5KtJpiE9dhxdsReQxcGJRrU5hF97uk7WCfsA8x3k8ETtsW2u3m0Avqy5Y6EM8J/7RW4x1FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bb57sLzq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bb57sLzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E83D1F000E9;
	Tue, 21 Jul 2026 18:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659611;
	bh=bNQ4iA/+zQcdQZQhmY75KvlVwWwkoORZWf1m/M7UR/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bb57sLzq7TqWs92ynaL/+Ywa6cfcicoqFKzhPeSgjbkPg1L3w/T47wagobXmI+44Q
	 NH2HQzTxQ9QEM5jnyYooNtrHnGaLM6rU7oBNJNdBcJt28brmH3NRk20SRF0VuO4+ox
	 UoUqiPwJaE8bZqQR/DWVudU0Itg33Q6YtOMds/CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1587/1611] btrfs: replace for_each_set_bit() with for_each_set_bitmap()
Date: Tue, 21 Jul 2026 17:28:23 +0200
Message-ID: <20260721152551.168763719@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit e6698b34fab33867ef3faeeea6feb165f31aae24 ]

Inside extent_io.c, there are several simple call sites doing things
like:

	for_each_set_bit(bit, bitmap, bitmap_size) {
		/* handle one fs block */
	}

The workload includes:

- set_bit()
  Inside extent_writepage_io().

  This can be replaced with a bitmap_set().

- btrfs_folio_set_lock()
- btrfs_mark_ordered_io_finished()
  Inside writepage_delalloc().

  Instead of calling it multiple times, we can pass a range into the
  function with one call.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 66ff4d366e7e ("btrfs: fix false IO failure after falling back to buffered write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1427,8 +1427,9 @@ static noinline_for_stack int writepage_
 	u64 delalloc_start = page_start;
 	u64 delalloc_end = page_end;
 	u64 delalloc_to_write = 0;
+	unsigned int start_bit;
+	unsigned int end_bit;
 	int ret = 0;
-	int bit;
 
 	/* Save the dirty bitmap as our submission bitmap will be a subset of it. */
 	if (btrfs_is_subpage(fs_info, folio)) {
@@ -1438,10 +1439,12 @@ static noinline_for_stack int writepage_
 		bio_ctrl->submit_bitmap = 1;
 	}
 
-	for_each_set_bit(bit, &bio_ctrl->submit_bitmap, blocks_per_folio) {
-		u64 start = page_start + (bit << fs_info->sectorsize_bits);
+	for_each_set_bitrange(start_bit, end_bit, &bio_ctrl->submit_bitmap,
+			      blocks_per_folio) {
+		u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
+		u32 len = (end_bit - start_bit) << fs_info->sectorsize_bits;
 
-		btrfs_folio_set_lock(fs_info, folio, start, fs_info->sectorsize);
+		btrfs_folio_set_lock(fs_info, folio, start, len);
 	}
 
 	/* Lock all (subpage) delalloc ranges inside the folio first. */
@@ -1558,10 +1561,13 @@ static noinline_for_stack int writepage_
 				fs_info->sectorsize_bits,
 				blocks_per_folio);
 
-		for_each_set_bit(bit, &bio_ctrl->submit_bitmap, bitmap_size)
-			btrfs_mark_ordered_io_finished(inode, folio,
-				page_start + (bit << fs_info->sectorsize_bits),
-				fs_info->sectorsize, false);
+		for_each_set_bitrange(start_bit, end_bit, &bio_ctrl->submit_bitmap,
+				      bitmap_size) {
+			u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
+			u32 len = (end_bit - start_bit) << fs_info->sectorsize_bits;
+
+			btrfs_mark_ordered_io_finished(inode, folio, start, len, false);
+		}
 		return ret;
 	}
 out:
@@ -1727,8 +1733,8 @@ static noinline_for_stack int extent_wri
 		return ret;
 	}
 
-	for (cur = start; cur < end; cur += fs_info->sectorsize)
-		set_bit((cur - folio_start) >> fs_info->sectorsize_bits, &range_bitmap);
+	bitmap_set(&range_bitmap, (start - folio_pos(folio)) >> fs_info->sectorsize_bits,
+		   len >> fs_info->sectorsize_bits);
 	bitmap_and(&bio_ctrl->submit_bitmap, &bio_ctrl->submit_bitmap, &range_bitmap,
 		   blocks_per_folio);
 


