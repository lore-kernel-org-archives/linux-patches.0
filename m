Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A5753E16;
	Tue, 23 Jan 2024 00:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970348; cv=none; b=R+NGHt4Sh/i+J77F6LJYSHWG9tkeUNsaNI2UoIVOC6KleJ/3bpvDx1iC1X4dCbkjtb0C5HjvJdOISVf74Vn+g06rp9RXdIM2MXlEZj0BQ7Tt5wXPTBYsD9RGdk4E285E4Yf8BHksa0jHtT7hZrzsVARQLpmo3fUByTmGAt2FMeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970348; c=relaxed/simple;
	bh=Z9M+oCeannoAnAH//HqwoEdLByCcc9yrmNiRMDLx4Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nn10CEQs7CnFpqWcDc86sipOljU7hTjixzcy+vo1iTEwonOLMZvHMBKIUZu97QxuJSRsGGoecnbI9Hzob+5i9xoAR2/y/FzzB6UwXPT822oqcz2ZnZQRH94bimshPnrrtH0G9CFyuRJ9b9mHVgRaIWhqQSA8SPwZ4825WG+ToT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oeiuw5OE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oeiuw5OE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDCDC433F1;
	Tue, 23 Jan 2024 00:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970348;
	bh=Z9M+oCeannoAnAH//HqwoEdLByCcc9yrmNiRMDLx4Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeiuw5OETZFAHP6OvcU68k+crBNc67fvKQ96DnDhZdF78C1yeDHBR163BWI86Zhfg
	 6kJzc6JNYlxQNZPc/LDfgbvM9XmqlBamlp5sGoLo/issGbK6h+zlo9799qx6DRDUHi
	 YTYa2XvIXFSX2sM/+c8Yg/SLB8gFIKN0vpGuhI10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 633/641] loop: fix the the direct I/O support check when used on top of block devices
Date: Mon, 22 Jan 2024 15:58:57 -0800
Message-ID: <20240122235838.079801656@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit baa7d536077dcdfe2b70c476a8873d1745d3de0f ]

__loop_update_dio only checks the alignment requirement for block backed
file systems, but misses them for the case where the loop device is
created directly on top of another block device.  Due to this creating
a loop device with default option plus the direct I/O flag on a > 512 byte
sector size file system will lead to incorrect I/O being submitted to the
lower block device and a lot of error from the lock layer.  This can
be seen with xfstests generic/563.

Fix the code in __loop_update_dio by factoring the alignment check into
a helper, and calling that also for the struct block_device of a block
device inode.

Also remove the TODO comment talking about dynamically switching between
buffered and direct I/O, which is a would be a recipe for horrible
performance and occasional data loss.

Fixes: 2e5ab5f379f9 ("block: loop: prepare for supporing direct IO")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20240117175901.871796-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 52 +++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 9f2d412fc560..552f56a84a7e 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -165,39 +165,37 @@ static loff_t get_loop_size(struct loop_device *lo, struct file *file)
 	return get_size(lo->lo_offset, lo->lo_sizelimit, file);
 }
 
+/*
+ * We support direct I/O only if lo_offset is aligned with the logical I/O size
+ * of backing device, and the logical block size of loop is bigger than that of
+ * the backing device.
+ */
+static bool lo_bdev_can_use_dio(struct loop_device *lo,
+		struct block_device *backing_bdev)
+{
+	unsigned short sb_bsize = bdev_logical_block_size(backing_bdev);
+
+	if (queue_logical_block_size(lo->lo_queue) < sb_bsize)
+		return false;
+	if (lo->lo_offset & (sb_bsize - 1))
+		return false;
+	return true;
+}
+
 static void __loop_update_dio(struct loop_device *lo, bool dio)
 {
 	struct file *file = lo->lo_backing_file;
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
-	unsigned short sb_bsize = 0;
-	unsigned dio_align = 0;
+	struct inode *inode = file->f_mapping->host;
+	struct block_device *backing_bdev = NULL;
 	bool use_dio;
 
-	if (inode->i_sb->s_bdev) {
-		sb_bsize = bdev_logical_block_size(inode->i_sb->s_bdev);
-		dio_align = sb_bsize - 1;
-	}
+	if (S_ISBLK(inode->i_mode))
+		backing_bdev = I_BDEV(inode);
+	else if (inode->i_sb->s_bdev)
+		backing_bdev = inode->i_sb->s_bdev;
 
-	/*
-	 * We support direct I/O only if lo_offset is aligned with the
-	 * logical I/O size of backing device, and the logical block
-	 * size of loop is bigger than the backing device's.
-	 *
-	 * TODO: the above condition may be loosed in the future, and
-	 * direct I/O may be switched runtime at that time because most
-	 * of requests in sane applications should be PAGE_SIZE aligned
-	 */
-	if (dio) {
-		if (queue_logical_block_size(lo->lo_queue) >= sb_bsize &&
-		    !(lo->lo_offset & dio_align) &&
-		    (file->f_mode & FMODE_CAN_ODIRECT))
-			use_dio = true;
-		else
-			use_dio = false;
-	} else {
-		use_dio = false;
-	}
+	use_dio = dio && (file->f_mode & FMODE_CAN_ODIRECT) &&
+		(!backing_bdev || lo_bdev_can_use_dio(lo, backing_bdev));
 
 	if (lo->use_dio == use_dio)
 		return;
-- 
2.43.0



