Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BEA1DD0FE;
	Mon,  6 Jan 2025 15:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178370; cv=none; b=Ej+rzOA5kuJG6CNTOjh4ry9EQH45d5thgU5SRgjk52Jo8BnYxVytntlP9rGOYnZwmM9G/pZJTcXjeAO89QF+yfziKPyFuaqitQ5guQxmtwlbcMnENy3fdlTFLBYRD9Baaw6GSBuOIGzM3awHuAA1fbw64ypg0N9zruemW8l+oxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178370; c=relaxed/simple;
	bh=QTN0+I+IzBnqc4D39qJ7pl5k3BZ+9EMpsnjxb6A0j3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmQ9mHvY6aeJ2f8O4Ox76Ibk4hzVakRNgH4c2pb/VO15VyRydesUd4S2Ez98v/liinfCdkUzTJHJdCif2hDphzQ1wRAIojfLrllTcsQswGDM44j7o8GVblCgDRCtdrOqyj4phGsEe51p6eKfNrG1ME/YuAqZtV5wNgZfAotf1Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0VT2Kmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0VT2Kmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED43C4CED2;
	Mon,  6 Jan 2025 15:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178370;
	bh=QTN0+I+IzBnqc4D39qJ7pl5k3BZ+9EMpsnjxb6A0j3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0VT2KmhopI2b3kQF8/oSw9mjh4ydTaiKNr1fKTQ9NI1efqRW2dh7LgKFwHR2OK2g
	 X4K73MeDlhIIJ8WayAMI69OzX/vTOlxd2Ody5mZ1XLOt6IXFodF5bUWjfWEcYunTyt
	 O8S0tpO0kKskZr2bo0GZz3yFncgC8sqZr43xDCXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/138] zram: use set_capacity_and_notify
Date: Mon,  6 Jan 2025 16:17:00 +0100
Message-ID: <20250106151136.866168719@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6e017a3931d7722260e3656a6fc9b02de5fb3c5d ]

Use set_capacity_and_notify to set the size of both the disk and block
device.  This also gets the uevent notifications for the resize for free.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 16db4fae5145..8f38e5a1a63f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1706,7 +1706,7 @@ static void zram_reset_device(struct zram *zram)
 	disksize = zram->disksize;
 	zram->disksize = 0;
 
-	set_capacity(zram->disk, 0);
+	set_capacity_and_notify(zram->disk, 0);
 	part_stat_set_all(&zram->disk->part0, 0);
 
 	up_write(&zram->init_lock);
@@ -1752,9 +1752,7 @@ static ssize_t disksize_store(struct device *dev,
 
 	zram->comp = comp;
 	zram->disksize = disksize;
-	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
-
-	revalidate_disk_size(zram->disk, true);
+	set_capacity_and_notify(zram->disk, zram->disksize >> SECTOR_SHIFT);
 	up_write(&zram->init_lock);
 
 	return len;
@@ -1801,7 +1799,6 @@ static ssize_t reset_store(struct device *dev,
 	/* Make sure all the pending I/O are finished */
 	fsync_bdev(bdev);
 	zram_reset_device(zram);
-	revalidate_disk_size(zram->disk, true);
 	bdput(bdev);
 
 	mutex_lock(&bdev->bd_mutex);
-- 
2.39.5



