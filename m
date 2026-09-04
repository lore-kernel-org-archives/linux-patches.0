Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4238A4CCDC7;
	Fri,  4 Sep 2026 05:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500243; cv=none; b=HPg6sr4N4b92xNPXb8vxy70g1lKwBNh0XgeYaeaN75GoMcwqBoP/F3j5pYn2fcwxNXxM9o3Ft8goXOcmdFZzusifPnrG4rrhNh9T+yrl13vTLHbaUzoMuIXkaePwxfeypxPF4Zz7bE6/Ey/MZiWCVTd/svqZg8633s6VyPzguQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500243; c=relaxed/simple;
	bh=U1wDoblRRf/RkZ7mUv6DuQLKyzGw03puwm7vQ/rta/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LaCr7bUezHb9PfdNCcVshL7vqPe0MGuFtd4mYTLJglFLtxY7lOovMIkE7s82QRAAFwu6dAPngnf6UTZOv5drPJCbYg7tcA3iswqG6HncmDbV79QJjh9h7hnBxuuqGTlO8cc3eM+YYrKIqCjhYLvTwW7NFKs1il7iYXOiNcIphGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJCf6bTS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJCf6bTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7011F00A3D;
	Fri,  4 Sep 2026 05:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500242;
	bh=4+d+lwrF8ZvD7WDk5gDDM+Da9JF2E3sT90jO1B6MwrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJCf6bTSD9WBnSiHebqRNVnpUihY3Em+6SJ3wq7I3bZfjt6SbsqGhuvumps6DLrjU
	 DJIcNzIA9Icwftp9aIrKdz8kpHoXebro8EhI+ePCRiiiMXSsjvzyWIaMQnN05zdY8e
	 HbOA2xxG6tbBe5jYpy7wyhSDaBcop9ZucgbBOmzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Xu Rao <raoxu@uniontech.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 701/713] zloop: truncate finished zones to zone capacity
Date: Fri,  4 Sep 2026 07:01:09 +0200
Message-ID: <20260904045819.559343326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit 72e67c118642634c25465db0c8bcfa54c4ce086c upstream.

The size of a sequential zone backing file records the amount of data
written and is used to restore the zone state. A backing file whose size
is equal to the zone capacity is restored as a full zone, while a file
larger than the zone capacity is rejected as invalid.

However, zloop_finish_zone() currently truncates the backing file to the
zone size. For devices with a reduced zone capacity, finishing a zone
therefore creates a backing file larger than the zone capacity. After the
device is removed and later re-added, that zone file is rejected instead
of being restored as a full zone.

Truncate finished sequential zones to the zone capacity, matching the
persistent representation accepted by zloop_update_seq_zone() for a full
zone.

Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/B39E5FD81D1A07F4+20260804023403.939767-1-raoxu@uniontech.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/blockdev/zoned_loop.rst |    9 ++++-----
 drivers/block/zloop.c                             |    3 ++-
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/blockdev/zoned_loop.rst
+++ b/Documentation/admin-guide/blockdev/zoned_loop.rst
@@ -30,11 +30,10 @@ indicates the position of the write poin
 
 When resetting a sequential zone, its backing file size is truncated to zero.
 Conversely, for a zone finish operation, the backing file is truncated to the
-zone size. With this, the maximum capacity of a zloop zoned block device created
-can be larger configured to be larger than the storage space available on the
-backing file system. Of course, for such configuration, writing more data than
-the storage space available on the backing file system will result in write
-errors.
+zone capacity. With this, a zloop zoned block device can be configured with a
+larger capacity than the storage space available on the backing file system. Of
+course, for such configuration, writing more data than the storage space
+available on the backing file system will result in write errors.
 
 The zoned loop block device driver implements a complete zone transition state
 machine. That is, zones can be empty, implicitly opened, explicitly opened,
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -478,7 +478,8 @@ static int zloop_finish_zone(struct zloo
 	    zone->cond == BLK_ZONE_COND_FULL)
 		goto unlock;
 
-	if (vfs_truncate(&zone->file->f_path, zlo->zone_size << SECTOR_SHIFT)) {
+	if (vfs_truncate(&zone->file->f_path,
+			 zlo->zone_capacity << SECTOR_SHIFT)) {
 		set_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
 		ret = -EIO;
 		goto unlock;


