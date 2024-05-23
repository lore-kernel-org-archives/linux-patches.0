Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5551F14AD36;
	Thu, 23 May 2024 13:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470257; cv=none; b=YmvTVoSN8OLT62SEYnPHWhO5Z7+l8/5M4j9GV1xh0MPMO0rjlPCYLGCTOZpfkqFM+hlGgeb+fm8oK0yvM2FIfupGki3dJhDC6gJtltp6oGzHEj2FjUrenze3caq22aZNEn/Oj4RNKES3Pregz5Lyz+Mhus0u1ksvqX5LcMMHUI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470257; c=relaxed/simple;
	bh=xE2WAf7ghI2rSeEjHiR+uhnZFCk7gb6IiENd0xZDotw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSnDFZTdKlQp67qvvj6kolHQVuQNmW5H5zrpQBY855/U1DzpXeyD/QP0kfuS7RXZL+17JAuVsXXCOjWeJmYOFHWuCs7ZPX/ra9+s5jcuGWMXX8u93hYVv4XMrKaiU/3eLaPIxzkypinuhoaATl6uNunbwkljm3iQ/vMNbrl0TG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ex9AwQZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ex9AwQZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01B3C2BD10;
	Thu, 23 May 2024 13:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470257;
	bh=xE2WAf7ghI2rSeEjHiR+uhnZFCk7gb6IiENd0xZDotw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ex9AwQZxwVqxzUYIC77Ae/ldOs2VMvH1xDnHFJIeMso2dBd9OiuTVelrYcqX8o/qE
	 ymdISogd6Ij2GokNZgn+Mh7UB/BsiGC+dEKrmFKjZwMxMPMeCmY90vmHazoOJTmrZV
	 QYwqhbewlcMnrX7IQOHOk6xWuj2sRPj48SZf0MgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.9 24/25] block: add a disk_has_partscan helper
Date: Thu, 23 May 2024 15:13:09 +0200
Message-ID: <20240523130331.292645865@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
 	struct file *file;
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
@@ -573,10 +573,7 @@ static int blk_add_partitions(struct gen
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


