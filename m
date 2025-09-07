Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328AC1DF246;
	Sun,  7 Sep 2025 20:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277401; cv=none; b=hi/4tB55v0km+Ya6RaZBLMCGiFfQyAQ5Buna7klVP1tuTQijKUTilLB1NeJkzAiA5W7hiuu9BH4dWs2LXjC2wOT38NR5BLF6EfG+yYyJ0Y3vjdHK0+WpVWsoHau6SDyNXI5o6Xjz++O96ciqgYLVPqiBLjYibMBS5MBQMioi64o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277401; c=relaxed/simple;
	bh=SBkeksSaFEyR/F4XIhnnAITuwtMvrAcacRq5P9g16lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdt0dIZo8OKlqJJd7bH4+Wy4Yll1kp7nXhLt9cYyIL5ZuzjtaGVb7ZkJ6p3Ek12F9uvJSHD40U47G+6FcGhg32TUsch7s/SPlES8fcNw94H6jbQ2+gVxG7XHPS1u4biKINmymV+F4/XRAMv31KrtOznu0NMcW9ffunY4iUZeI8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAkxbi2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAkxbi2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6124C4CEF0;
	Sun,  7 Sep 2025 20:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277401;
	bh=SBkeksSaFEyR/F4XIhnnAITuwtMvrAcacRq5P9g16lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAkxbi2dp+K8DqKGU1M5N5CBclwCgtA44dFEwfNNoActOatL6//OsMbhbFXk8WmpL
	 1vAyOgy5z1gIx3Ur8YigItomyAHRdS0ifZXOWJ0uERo/igoH8J6wRY0OPQleB/EzjJ
	 nc+AShzZE6+h3TGyFtWY4Cy5iddsc90XxU2PyNj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Yue <glass.su@suse.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 136/175] md/md-bitmap: fix wrong bitmap_limit for clustermd when write sb
Date: Sun,  7 Sep 2025 21:58:51 +0200
Message-ID: <20250907195618.067930425@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Su Yue <glass.su@suse.com>

commit 6130825f34d41718c98a9b1504a79a23e379701e upstream.

In clustermd, separate write-intent-bitmaps are used for each cluster
node:

0                    4k                     8k                    12k
-------------------------------------------------------------------
| idle                | md super            | bm super [0] + bits |
| bm bits[0, contd]   | bm super[1] + bits  | bm bits[1, contd]   |
| bm super[2] + bits  | bm bits [2, contd]  | bm super[3] + bits  |
| bm bits [3, contd]  |                     |                     |

So in node 1, pg_index in __write_sb_page() could equal to
bitmap->storage.file_pages. Then bitmap_limit will be calculated to
0. md_super_write() will be called with 0 size.
That means the first 4k sb area of node 1 will never be updated
through filemap_write_page().
This bug causes hang of mdadm/clustermd_tests/01r1_Grow_resize.

Here use (pg_index % bitmap->storage.file_pages) to make calculation
of bitmap_limit correct.

Fixes: ab99a87542f1 ("md/md-bitmap: fix writing non bitmap pages")
Signed-off-by: Su Yue <glass.su@suse.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Link: https://lore.kernel.org/linux-raid/20250303033918.32136-1-glass.su@suse.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md-bitmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -426,8 +426,8 @@ static int __write_sb_page(struct md_rde
 	struct block_device *bdev;
 	struct mddev *mddev = bitmap->mddev;
 	struct bitmap_storage *store = &bitmap->storage;
-	unsigned int bitmap_limit = (bitmap->storage.file_pages - pg_index) <<
-		PAGE_SHIFT;
+	unsigned long num_pages = bitmap->storage.file_pages;
+	unsigned int bitmap_limit = (num_pages - pg_index % num_pages) << PAGE_SHIFT;
 	loff_t sboff, offset = mddev->bitmap_info.offset;
 	sector_t ps = pg_index * PAGE_SIZE / SECTOR_SIZE;
 	unsigned int size = PAGE_SIZE;
@@ -436,7 +436,7 @@ static int __write_sb_page(struct md_rde
 
 	bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
 	/* we compare length (page numbers), not page offset. */
-	if ((pg_index - store->sb_index) == store->file_pages - 1) {
+	if ((pg_index - store->sb_index) == num_pages - 1) {
 		unsigned int last_page_size = store->bytes & (PAGE_SIZE - 1);
 
 		if (last_page_size == 0)


