Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C0C40860A;
	Thu, 30 Jul 2026 15:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426793; cv=none; b=kB1/F3q+nqIq6YLrnzAFzJ/Avs49ou/ElL/vcdqSs8Sa8XmGr+1IuKyYyiu1XfhmZDdVD672k0zrGSb6BeM2T6Tt8BQVuAvwF2w6SiU6LdR4x1c+9pBNn299n9BDYhRdFjb0HsNR0W71DnQFzyN5AwW/izw4hxAFHjVomz0cj98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426793; c=relaxed/simple;
	bh=4BevzLcTKmoG+jig1giuZ9BzNlM1j6ysr95MROsQCOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a137tSUdcZQer/f99vLsoxGdjel9gPVdwSSUlwvimjMGBVWLIUUDyweRihzDzpeIhF+NZd6yWuCNggNnr8ANhxiMHbvm6Ophlp5o4ho3NtBVkFM7uuSAYNSpayErQiRRrZVtXPpXYAHdrFzN2fCb57KCbtZvmAFOExJFtgTp1xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZrQEKKo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZrQEKKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312DE1F000E9;
	Thu, 30 Jul 2026 15:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426792;
	bh=hGYcyK9VAHABA5s6XPaL41Jv8SQV4UVQh950jcrmnIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZrQEKKoctVdhbHv8ioaNH0GvtpCYgFLQthAuoYVSM8qvkbHGNHiO1sQbXNdVTxUy
	 dEEawr5VKjQZl1lzpOAaj6xrPDQCWD+uM12xi0zzsZJQTGyEyMJlOfijW0y1eAYoPX
	 gahg3DSaKJ9+wm6TmqzJh6TCd8TXEwhOnWkgwpvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 544/602] block: add helper add_disk_final()
Date: Thu, 30 Jul 2026 16:15:36 +0200
Message-ID: <20260730141447.460490994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 5fad1490ef510e3b70ad8b0a5a1e28a26638a95f ]

Add helper add_disk_final() for scanning partitions, announcing disk and
handling the last thing for adding disk.

No functional change, and prepare for prevent adding disk from happening
when updating nr_hw_queues.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250505141805.2751237-8-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 181bb9c9eae4 ("block: remove redundant GD_NEED_PART_SCAN in add_disk_final()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/genhd.c |   46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -382,6 +382,32 @@ int disk_scan_partitions(struct gendisk
 	return ret;
 }
 
+static void add_disk_final(struct gendisk *disk)
+{
+	struct device *ddev = disk_to_dev(disk);
+
+	if (!(disk->flags & GENHD_FL_HIDDEN)) {
+		/* Make sure the first partition scan will be proceed */
+		if (get_capacity(disk) && disk_has_partscan(disk))
+			set_bit(GD_NEED_PART_SCAN, &disk->state);
+
+		bdev_add(disk->part0, ddev->devt);
+		if (get_capacity(disk))
+			disk_scan_partitions(disk, BLK_OPEN_READ);
+
+		/*
+		 * Announce the disk and partitions after all partitions are
+		 * created. (for hidden disks uevents remain suppressed forever)
+		 */
+		dev_set_uevent_suppress(ddev, 0);
+		disk_uevent(disk, KOBJ_ADD);
+	}
+
+	blk_apply_bdi_limits(disk->bdi, &disk->queue->limits);
+	disk_add_events(disk);
+	set_bit(GD_ADDED, &disk->state);
+}
+
 /**
  * device_add_disk - add disk information to kernel list
  * @parent: parent device for the disk
@@ -500,21 +526,6 @@ int __must_check device_add_disk(struct
 					&disk->bdi->dev->kobj, "bdi");
 		if (ret)
 			goto out_unregister_bdi;
-
-		/* Make sure the first partition scan will be proceed */
-		if (get_capacity(disk) && disk_has_partscan(disk))
-			set_bit(GD_NEED_PART_SCAN, &disk->state);
-
-		bdev_add(disk->part0, ddev->devt);
-		if (get_capacity(disk))
-			disk_scan_partitions(disk, BLK_OPEN_READ);
-
-		/*
-		 * Announce the disk and partitions after all partitions are
-		 * created. (for hidden disks uevents remain suppressed forever)
-		 */
-		dev_set_uevent_suppress(ddev, 0);
-		disk_uevent(disk, KOBJ_ADD);
 	} else {
 		/*
 		 * Even if the block_device for a hidden gendisk is not
@@ -523,10 +534,7 @@ int __must_check device_add_disk(struct
 		 */
 		disk->part0->bd_dev = MKDEV(disk->major, disk->first_minor);
 	}
-
-	blk_apply_bdi_limits(disk->bdi, &disk->queue->limits);
-	disk_add_events(disk);
-	set_bit(GD_ADDED, &disk->state);
+	add_disk_final(disk);
 	return 0;
 
 out_unregister_bdi:


