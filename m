Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE81E1D545;
	Thu, 23 May 2024 13:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470824; cv=none; b=b8UereCmX3TWe9tihz8tgvisylS/ryitFSUHqRNZF3jAttnqPf9LlLTlgJcACXLHVQIUPblYU2atXFmago9j2fJjqxUXyiMRjsFDKHD/TAsWavCX8v1Vdb2UTP1VTkSlwRCS5YT7XHmrd1F63/3cUJrtTkqw2fNZRJNKce2JLnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470824; c=relaxed/simple;
	bh=AQX1DjdSXdqU8QsPqAnU/Eh7v0O4zlIFRoCF4LqWWIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbeRYvVNbXktajSPTmwDPpveGvBjJhZ0Tm5CudJjf7rlRygVyRfGrgJ2OJB+1S0/E0w3WH3cu3OSiQPj9CqbQvYkFv8gVlAhOqbc4qcSmxMwA8OqmgUae3wo1hdZr91PWqUQDorr4JzZlIsrJC+rFlYi3eLywc1Qrjurs99aaKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJBh2Tda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJBh2Tda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66643C3277B;
	Thu, 23 May 2024 13:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470823;
	bh=AQX1DjdSXdqU8QsPqAnU/Eh7v0O4zlIFRoCF4LqWWIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJBh2TdakzloeBhHKI7CgWFsob2Q6E9/5a7F1vxxO9K23fhkqdlkhG58PNUXHOdsZ
	 1dQ94YwXkjtMW2ztZW5XIsfpI2fMp7nqTovwlhgO4Eyhgh8sEBaF6p/qD7jlyPgg6p
	 iabyZHRbegYj0B/3x041Hz76vvUZLyqhYlEEDI0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 101/102] block: add a disk_has_partscan helper
Date: Thu, 23 May 2024 15:14:06 +0200
Message-ID: <20240523130346.284224820@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 	struct block_device *bdev;
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
@@ -592,10 +592,7 @@ static int blk_add_partitions(struct gen
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
@@ -229,6 +229,19 @@ static inline unsigned int disk_openers(
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


