Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066661422C4;
	Thu, 11 Apr 2024 10:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829747; cv=none; b=PRA8LFFdAbE2EDMi1J+wtCl9PF9oIMwxaZTN4n6ViGbnebhdtz0iLIJY/DSmZnNAO5mYp8fv4lpKkPi80+uJZUViAeKFE0jxTry0uwqACiapa4+NJZCPhVobLQh09l4zqKwSmxq7wF1gDAE4mTk+9XoGAgEoR0oC2cBabcTFkRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829747; c=relaxed/simple;
	bh=ixYwmUyJ/JPPUNlbOiLedbziPxfk9atXDxAr+Btknsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQ0wsWAcPyrjhhge3V5jgQi8gNb48P+oq2vyeBIXsv9+mDgVe96k0qYbTdeP+9NMtNAPg4L4ujvKJn0y5RFI6vbGLtX2HLw7n4vgm6JyXx3cp95B12+UM78T6BdgBg4/SfZ1yBo6HuLLZy7KDz5jxS4MHSA+LDwSLmra+mHS7KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTm0B3lZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTm0B3lZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA6FC433F1;
	Thu, 11 Apr 2024 10:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829746;
	bh=ixYwmUyJ/JPPUNlbOiLedbziPxfk9atXDxAr+Btknsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTm0B3lZhpL8Lco0v/6ucNxXpMO4yPe/duR3nk6AukbUh/PQOD2DNfuOpXRQCbTRr
	 M6Fq8dG+yJ+HQoGNgkec1qlLNAYE4LkA5WxFs30egz7SnURHsgm+3zANPbyFI4zJFN
	 Wm3/2igXIhJDbOSD4fDrYfrZCIIUcbFj4CJgaG14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martijn Coenen <maco@android.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Genjian Zhang <zhanggenjian@kylinos.cn>
Subject: [PATCH 4.19 092/175] loop: Factor out setting loop device size
Date: Thu, 11 Apr 2024 11:55:15 +0200
Message-ID: <20240411095422.335548629@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martijn Coenen <maco@android.com>

[ Upstream commit 5795b6f5607f7e4db62ddea144727780cb351a9b ]

This code is used repeatedly.

Signed-off-by: Martijn Coenen <maco@android.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -225,20 +225,35 @@ static void __loop_update_dio(struct loo
 	blk_mq_unfreeze_queue(lo->lo_queue);
 }
 
+/**
+ * loop_set_size() - sets device size and notifies userspace
+ * @lo: struct loop_device to set the size for
+ * @size: new size of the loop device
+ *
+ * Callers must validate that the size passed into this function fits into
+ * a sector_t, eg using loop_validate_size()
+ */
+static void loop_set_size(struct loop_device *lo, loff_t size)
+{
+	struct block_device *bdev = lo->lo_device;
+
+	set_capacity(lo->lo_disk, size);
+	bd_set_size(bdev, size << SECTOR_SHIFT);
+	/* let user-space know about the new size */
+	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
+}
+
 static void
 figure_loop_size(struct loop_device *lo, loff_t offset, loff_t sizelimit)
 {
 	loff_t size = get_size(offset, sizelimit, lo->lo_backing_file);
-	struct block_device *bdev = lo->lo_device;
 
 	if (lo->lo_offset != offset)
 		lo->lo_offset = offset;
 	if (lo->lo_sizelimit != sizelimit)
 		lo->lo_sizelimit = sizelimit;
-	set_capacity(lo->lo_disk, size);
-	bd_set_size(bdev, (loff_t)get_capacity(bdev->bd_disk) << 9);
-	/* let user-space know about the new size */
-	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
+
+	loop_set_size(lo, size);
 }
 
 static inline int
@@ -992,11 +1007,8 @@ static int loop_set_fd(struct loop_devic
 		blk_queue_write_cache(lo->lo_queue, true, false);
 
 	loop_update_dio(lo);
-	set_capacity(lo->lo_disk, size);
-	bd_set_size(bdev, size << 9);
 	loop_sysfs_init(lo);
-	/* let user-space know about the new size */
-	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
+	loop_set_size(lo, size);
 
 	set_blocksize(bdev, S_ISBLK(inode->i_mode) ?
 		      block_size(inode->i_bdev) : PAGE_SIZE);


