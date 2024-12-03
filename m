Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2846B1FC115;
	Tue,  3 Dec 2024 15:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240117; cv=none; b=SlOIH+rvlagh2bCafcLLl8Ch+I1h/bz0jU/Vmsohkj8418L84EaSRg44I5OIVXOWE9HKiEPwgQUCpy/C9yLGSvgnrnBSwiGQbNvMNlnnJfCK4jOY7/6kkmDTSDAawr21WFF5X8BSrMpEWLgZ5Xlq9ZRms9+lzjC5hoQGy3NkYZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240117; c=relaxed/simple;
	bh=cMPtS9l+EWprX7oLbX2L3pagpRF+AFn7z0SfUEka4Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VicXAo3hoPO9LQ5aJKaE8l8A3CKmEYvf/a0QdJYLHvDamkrrYqq+Vkv3EqGh1TtVCOxTrFyriPWGfQ+NVdHjcxW6MXrD+tU/IXxWK5nv9FKu3+KgB+emUp0toFzgsf/6S5UMiYHQQIni0Ww2uQlu/MSuXlaSDWn7qaN5jcoHjAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOzhinSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOzhinSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FF6C4CECF;
	Tue,  3 Dec 2024 15:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240116;
	bh=cMPtS9l+EWprX7oLbX2L3pagpRF+AFn7z0SfUEka4Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XOzhinSr7KICqhdb158To7AKrA2CoZNqGuuHmZIVNJGesP2DXeYUHQrPfA30lQscv
	 Dr5l5sDKjuoHj7CrOg8zRl16wPz1xqnKJaiuBpd1Ahf5wqNwRIaVW4XvP6zOOC78x6
	 5rQgChG6xMsSZvHM5mArfw8BzqbgbMW2hCsL8jvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jan Stancek <jstancek@redhat.com>,
	Li Wang <liwang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/826] loop: fix type of block size
Date: Tue,  3 Dec 2024 15:35:55 +0100
Message-ID: <20241203144744.558782834@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Wang <liwang@redhat.com>

[ Upstream commit 8e604cac499248c75ad3a26695a743ff879ded5c ]

PAGE_SIZE may be 64K, and the max block size can be PAGE_SIZE, so any
variable for holding block size can't be defined as 'unsigned short'.

Unfortunately commit 473516b36193 ("loop: use the atomic queue limits
update API") passes 'bsize' with type of 'unsigned short' to
loop_reconfigure_limits(), and causes LTP/ioctl_loop06 test failure:

  12 ioctl_loop06.c:76: TINFO: Using LOOP_SET_BLOCK_SIZE with arg > PAGE_SIZE
  13 ioctl_loop06.c:59: TFAIL: Set block size succeed unexpectedly
  ...
  18 ioctl_loop06.c:76: TINFO: Using LOOP_CONFIGURE with block_size > PAGE_SIZE
  19 ioctl_loop06.c:59: TFAIL: Set block size succeed unexpectedly

Fixes the issue by defining 'block size' variable with 'unsigned int', which is
aligned with block layer's definition.

(improve commit log & add fixes tag)

Fixes: 473516b36193 ("loop: use the atomic queue limits update API")
Cc: John Garry <john.g.garry@oracle.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Li Wang <liwang@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241109022744.1126003-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 78a7bb28defe4..86cc3b19faae8 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -173,7 +173,7 @@ static loff_t get_loop_size(struct loop_device *lo, struct file *file)
 static bool lo_bdev_can_use_dio(struct loop_device *lo,
 		struct block_device *backing_bdev)
 {
-	unsigned short sb_bsize = bdev_logical_block_size(backing_bdev);
+	unsigned int sb_bsize = bdev_logical_block_size(backing_bdev);
 
 	if (queue_logical_block_size(lo->lo_queue) < sb_bsize)
 		return false;
@@ -977,7 +977,7 @@ loop_set_status_from_info(struct loop_device *lo,
 	return 0;
 }
 
-static unsigned short loop_default_blocksize(struct loop_device *lo,
+static unsigned int loop_default_blocksize(struct loop_device *lo,
 		struct block_device *backing_bdev)
 {
 	/* In case of direct I/O, match underlying block size */
@@ -986,7 +986,7 @@ static unsigned short loop_default_blocksize(struct loop_device *lo,
 	return SECTOR_SIZE;
 }
 
-static int loop_reconfigure_limits(struct loop_device *lo, unsigned short bsize)
+static int loop_reconfigure_limits(struct loop_device *lo, unsigned int bsize)
 {
 	struct file *file = lo->lo_backing_file;
 	struct inode *inode = file->f_mapping->host;
-- 
2.43.0



