Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC4514B950;
	Thu, 23 May 2024 13:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470550; cv=none; b=qizfZvemPTk5m+2FAOqpwjwXdpDrApFg/kGz4ugBqnCmSW/UHHn3gnnyESA/YbkZPWPdXS7BHWZbOhwRDfr8/MdJOPZLCmoTORpnYCdotfz9lySaVQkNd5WJVPZy+fuRxhBLg8GF8VKvuJaP/lOmESpuuvG5iuKTeQ26CpttUME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470550; c=relaxed/simple;
	bh=/eX/OjUCZzFP9fLRXekoLokrxJyQUrAbYz9L08Oas9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=albfz5+I7ISvKH7FE9A2kPu1uEIANuco4CD+e8XSq9VM7J6bGcRIpfaZO25NSxIc+0mSVx6XtOiWjrYkdI+/OOswvF0i8tEoXL9yvuLRSkLQRJkTNaxYWEUTJ22QFxoycB38P7XhvLYPUgle7dR005xOY5GZhvEVjdL3aRkJFbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mR40ZFQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mR40ZFQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE20CC3277B;
	Thu, 23 May 2024 13:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470550;
	bh=/eX/OjUCZzFP9fLRXekoLokrxJyQUrAbYz9L08Oas9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mR40ZFQbBjH1zY5yOJROACJR3KoZ2zGsUZHqYTGDKR+ErZnXL2XctkJZLQfdgnkDX
	 BNjlIcyS4xFIIOr65rD1PPpsugS55oSpX9xITvIH8L0TOJfL36/Ir6+9tveYrGbbmS
	 t4IPoGa2QbvmQCAGVsovcHmVQVTMSz1SIxKOuzAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.8 22/23] block: add a disk_has_partscan helper
Date: Thu, 23 May 2024 15:13:49 +0200
Message-ID: <20240523130330.588688366@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
References: <20240523130329.745905823@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 140ce28dd3bee8e53acc27f123ae474d69ef66f0 upstream.

Add a helper to check if partition scanning is enabled instead of
open coding the check in a few places.  This now always checks for
the hidden flag even if all but one of the callers are never reachable
for hidden gendisks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20240502130033.1958492-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/genhd.c           |    7 ++-----
 block/partitions/core.c |    5 +----
 include/linux/blkdev.h  |   13 +++++++++++++
 3 files changed, 16 insertions(+), 9 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -345,9 +345,7 @@ int disk_scan_partitions(struct gendisk
 	struct bdev_handle *handle;
 	int ret = 0;
 
-	if (disk->flags & (GENHD_FL_NO_PART | GENHD_FL_HIDDEN))
-		return -EINVAL;
-	if (test_bit(GD_SUPPRESS_PART_SCAN, &disk->state))
+	if (!disk_has_partscan(disk))
 		return -EINVAL;
 	if (disk->open_partitions)
 		return -EBUSY;
@@ -503,8 +501,7 @@ int __must_check device_add_disk(struct
 			goto out_unregister_bdi;
 
 		/* Make sure the first partition scan will be proceed */
-		if (get_capacity(disk) && !(disk->flags & GENHD_FL_NO_PART) &&
-		    !test_bit(GD_SUPPRESS_PART_SCAN, &disk->state))
+		if (get_capacity(disk) && disk_has_partscan(disk))
 			set_bit(GD_NEED_PART_SCAN, &disk->state);
 
 		bdev_add(disk->part0, ddev->devt);
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -584,10 +584,7 @@ static int blk_add_partitions(struct gen
 	struct parsed_partitions *state;
 	int ret = -EAGAIN, p;
 
-	if (disk->flags & GENHD_FL_NO_PART)
-		return 0;
-
-	if (test_bit(GD_SUPPRESS_PART_SCAN, &disk->state))
+	if (!disk_has_partscan(disk))
 		return 0;
 
 	state = check_partition(disk);
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -233,6 +233,19 @@ static inline unsigned int disk_openers(
 	return atomic_read(&disk->part0->bd_openers);
 }
 
+/**
+ * disk_has_partscan - return %true if partition scanning is enabled on a disk
+ * @disk: disk to check
+ *
+ * Returns %true if partitions scanning is enabled for @disk, or %false if
+ * partition scanning is disabled either permanently or temporarily.
+ */
+static inline bool disk_has_partscan(struct gendisk *disk)
+{
+	return !(disk->flags & (GENHD_FL_NO_PART | GENHD_FL_HIDDEN)) &&
+		!test_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
+}
+
 /*
  * The gendisk is refcounted by the part0 block_device, and the bd_device
  * therein is also used for device model presentation in sysfs.


