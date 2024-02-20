Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02DF133987;
	Tue, 20 Feb 2024 21:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463125; cv=none; b=L+VBH89Z/WMEzKHzIRWdL7jfq1FNI+ka4T4bO8lqWYLpXPgbJgp5gNoifs7v8AEpWrQgEtj9y8D4b2rhGCIwt85XssshN9jkdEysK/ItNnKWVX0EuYifGwouPyP1NxgRcoaOU5tMaB1/5d0LKYEZYVj5SogH3MpXTcbMXIRSCG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463125; c=relaxed/simple;
	bh=M/gUen5qXTw2q21WiqQeYwky6xkmra2fSEXWlaKV7Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/2L9tKPW4yWhd2XvJJVfHlSyUxEWbT32Ab2CNgiBSam8lH12twnByq7veh3b6JmqdBRCbejmJELAugTgzcPO6ijQaEBbuvpHoIJqhx9EaMwoMULC85LGD7opgr4ZWDvlA3nJSRbap6H6LiWOor4cODZjcgLZbkevA7gkh0SUoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqzYMAVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqzYMAVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B99C433C7;
	Tue, 20 Feb 2024 21:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463125;
	bh=M/gUen5qXTw2q21WiqQeYwky6xkmra2fSEXWlaKV7Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqzYMAVolZehdr1GMklTUriaxQNdwe67N+T1xumbmBufmqwgDrn6RRHvM8/CwCuMu
	 Sf1xb5CY242I5nq0zzaHXHd4KsRj0QKlhEFFkKWC4rg7Xsb6YBHuxZMKZzlXn8RlJt
	 +6E7Tp0AhWKcvPTKOUh6qBEv7vMUJPJ0g7V/npho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 6.1 144/197] zonefs: Improve error handling
Date: Tue, 20 Feb 2024 21:51:43 +0100
Message-ID: <20240220204845.377487565@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit 14db5f64a971fce3d8ea35de4dfc7f443a3efb92 upstream.

Write error handling is racy and can sometime lead to the error recovery
path wrongly changing the inode size of a sequential zone file to an
incorrect value  which results in garbage data being readable at the end
of a file. There are 2 problems:

1) zonefs_file_dio_write() updates a zone file write pointer offset
   after issuing a direct IO with iomap_dio_rw(). This update is done
   only if the IO succeed for synchronous direct writes. However, for
   asynchronous direct writes, the update is done without waiting for
   the IO completion so that the next asynchronous IO can be
   immediately issued. However, if an asynchronous IO completes with a
   failure right before the i_truncate_mutex lock protecting the update,
   the update may change the value of the inode write pointer offset
   that was corrected by the error path (zonefs_io_error() function).

2) zonefs_io_error() is called when a read or write error occurs. This
   function executes a report zone operation using the callback function
   zonefs_io_error_cb(), which does all the error recovery handling
   based on the current zone condition, write pointer position and
   according to the mount options being used. However, depending on the
   zoned device being used, a report zone callback may be executed in a
   context that is different from the context of __zonefs_io_error(). As
   a result, zonefs_io_error_cb() may be executed without the inode
   truncate mutex lock held, which can lead to invalid error processing.

Fix both problems as follows:
- Problem 1: Perform the inode write pointer offset update before a
  direct write is issued with iomap_dio_rw(). This is safe to do as
  partial direct writes are not supported (IOMAP_DIO_PARTIAL is not
  set) and any failed IO will trigger the execution of zonefs_io_error()
  which will correct the inode write pointer offset to reflect the
  current state of the one on the device.
- Problem 2: Change zonefs_io_error_cb() into zonefs_handle_io_error()
  and call this function directly from __zonefs_io_error() after
  obtaining the zone information using blkdev_report_zones() with a
  simple callback function that copies to a local stack variable the
  struct blk_zone obtained from the device. This ensures that error
  handling is performed holding the inode truncate mutex.
  This change also simplifies error handling for conventional zone files
  by bypassing the execution of report zones entirely. This is safe to
  do because the condition of conventional zones cannot be read-only or
  offline and conventional zone files are always fully mapped with a
  constant file size.

Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/zonefs/file.c  |   42 +++++++++++++++++++++------------
 fs/zonefs/super.c |   68 ++++++++++++++++++++++++++++++------------------------
 2 files changed, 66 insertions(+), 44 deletions(-)

--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -349,7 +349,12 @@ static int zonefs_file_write_dio_end_io(
 	struct zonefs_inode_info *zi = ZONEFS_I(inode);
 
 	if (error) {
-		zonefs_io_error(inode, true);
+		/*
+		 * For Sync IOs, error recovery is called from
+		 * zonefs_file_dio_write().
+		 */
+		if (!is_sync_kiocb(iocb))
+			zonefs_io_error(inode, true);
 		return error;
 	}
 
@@ -577,6 +582,14 @@ static ssize_t zonefs_file_dio_write(str
 			ret = -EINVAL;
 			goto inode_unlock;
 		}
+		/*
+		 * Advance the zone write pointer offset. This assumes that the
+		 * IO will succeed, which is OK to do because we do not allow
+		 * partial writes (IOMAP_DIO_PARTIAL is not set) and if the IO
+		 * fails, the error path will correct the write pointer offset.
+		 */
+		z->z_wpoffset += count;
+		zonefs_inode_account_active(inode);
 		mutex_unlock(&zi->i_truncate_mutex);
 		append = sync;
 	}
@@ -596,20 +609,19 @@ static ssize_t zonefs_file_dio_write(str
 			ret = -EBUSY;
 	}
 
-	if (zonefs_zone_is_seq(z) &&
-	    (ret > 0 || ret == -EIOCBQUEUED)) {
-		if (ret > 0)
-			count = ret;
-
-		/*
-		 * Update the zone write pointer offset assuming the write
-		 * operation succeeded. If it did not, the error recovery path
-		 * will correct it. Also do active seq file accounting.
-		 */
-		mutex_lock(&zi->i_truncate_mutex);
-		z->z_wpoffset += count;
-		zonefs_inode_account_active(inode);
-		mutex_unlock(&zi->i_truncate_mutex);
+	/*
+	 * For a failed IO or partial completion, trigger error recovery
+	 * to update the zone write pointer offset to a correct value.
+	 * For asynchronous IOs, zonefs_file_write_dio_end_io() may already
+	 * have executed error recovery if the IO already completed when we
+	 * reach here. However, we cannot know that and execute error recovery
+	 * again (that will not change anything).
+	 */
+	if (zonefs_zone_is_seq(z)) {
+		if (ret > 0 && ret != count)
+			ret = -EIO;
+		if (ret < 0 && ret != -EIOCBQUEUED)
+			zonefs_io_error(inode, true);
 	}
 
 inode_unlock:
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -245,16 +245,18 @@ static void zonefs_inode_update_mode(str
 	z->z_flags &= ~ZONEFS_ZONE_INIT_MODE;
 }
 
-struct zonefs_ioerr_data {
-	struct inode	*inode;
-	bool		write;
-};
-
 static int zonefs_io_error_cb(struct blk_zone *zone, unsigned int idx,
 			      void *data)
 {
-	struct zonefs_ioerr_data *err = data;
-	struct inode *inode = err->inode;
+	struct blk_zone *z = data;
+
+	*z = *zone;
+	return 0;
+}
+
+static void zonefs_handle_io_error(struct inode *inode, struct blk_zone *zone,
+				   bool write)
+{
 	struct zonefs_zone *z = zonefs_inode_zone(inode);
 	struct super_block *sb = inode->i_sb;
 	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
@@ -269,8 +271,8 @@ static int zonefs_io_error_cb(struct blk
 	data_size = zonefs_check_zone_condition(sb, z, zone);
 	isize = i_size_read(inode);
 	if (!(z->z_flags & (ZONEFS_ZONE_READONLY | ZONEFS_ZONE_OFFLINE)) &&
-	    !err->write && isize == data_size)
-		return 0;
+	    !write && isize == data_size)
+		return;
 
 	/*
 	 * At this point, we detected either a bad zone or an inconsistency
@@ -291,7 +293,7 @@ static int zonefs_io_error_cb(struct blk
 	 * In all cases, warn about inode size inconsistency and handle the
 	 * IO error according to the zone condition and to the mount options.
 	 */
-	if (zonefs_zone_is_seq(z) && isize != data_size)
+	if (isize != data_size)
 		zonefs_warn(sb,
 			    "inode %lu: invalid size %lld (should be %lld)\n",
 			    inode->i_ino, isize, data_size);
@@ -351,8 +353,6 @@ static int zonefs_io_error_cb(struct blk
 	zonefs_i_size_write(inode, data_size);
 	z->z_wpoffset = data_size;
 	zonefs_inode_account_active(inode);
-
-	return 0;
 }
 
 /*
@@ -366,23 +366,25 @@ void __zonefs_io_error(struct inode *ino
 {
 	struct zonefs_zone *z = zonefs_inode_zone(inode);
 	struct super_block *sb = inode->i_sb;
-	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
 	unsigned int noio_flag;
-	unsigned int nr_zones = 1;
-	struct zonefs_ioerr_data err = {
-		.inode = inode,
-		.write = write,
-	};
+	struct blk_zone zone;
 	int ret;
 
 	/*
-	 * The only files that have more than one zone are conventional zone
-	 * files with aggregated conventional zones, for which the inode zone
-	 * size is always larger than the device zone size.
-	 */
-	if (z->z_size > bdev_zone_sectors(sb->s_bdev))
-		nr_zones = z->z_size >>
-			(sbi->s_zone_sectors_shift + SECTOR_SHIFT);
+	 * Conventional zone have no write pointer and cannot become read-only
+	 * or offline. So simply fake a report for a single or aggregated zone
+	 * and let zonefs_handle_io_error() correct the zone inode information
+	 * according to the mount options.
+	 */
+	if (!zonefs_zone_is_seq(z)) {
+		zone.start = z->z_sector;
+		zone.len = z->z_size >> SECTOR_SHIFT;
+		zone.wp = zone.start + zone.len;
+		zone.type = BLK_ZONE_TYPE_CONVENTIONAL;
+		zone.cond = BLK_ZONE_COND_NOT_WP;
+		zone.capacity = zone.len;
+		goto handle_io_error;
+	}
 
 	/*
 	 * Memory allocations in blkdev_report_zones() can trigger a memory
@@ -393,12 +395,20 @@ void __zonefs_io_error(struct inode *ino
 	 * the GFP_NOIO context avoids both problems.
 	 */
 	noio_flag = memalloc_noio_save();
-	ret = blkdev_report_zones(sb->s_bdev, z->z_sector, nr_zones,
-				  zonefs_io_error_cb, &err);
-	if (ret != nr_zones)
+	ret = blkdev_report_zones(sb->s_bdev, z->z_sector, 1,
+				  zonefs_io_error_cb, &zone);
+	memalloc_noio_restore(noio_flag);
+
+	if (ret != 1) {
 		zonefs_err(sb, "Get inode %lu zone information failed %d\n",
 			   inode->i_ino, ret);
-	memalloc_noio_restore(noio_flag);
+		zonefs_warn(sb, "remounting filesystem read-only\n");
+		sb->s_flags |= SB_RDONLY;
+		return;
+	}
+
+handle_io_error:
+	zonefs_handle_io_error(inode, &zone, write);
 }
 
 static struct kmem_cache *zonefs_inode_cachep;


