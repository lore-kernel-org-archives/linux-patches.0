Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA02B243376;
	Wed, 25 Feb 2026 01:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983503; cv=none; b=rO7OulV8cioxUDwy2roSA7cVdQ8V+tl0uHA06L2L/66mpV1UWLxBMpTSghwfFtOzXMXlHUpMTNGIv3pqkMVHsg0TN/4qvEVt33GpZeEfsbN3chM6Jvp65YEJ97kYNYszBX9abyY9vKPPC08owVe7iMYpvbB15KjSzkbi+oV5NGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983503; c=relaxed/simple;
	bh=6Z924ZUI+t5jJSkrkTJAHH0CAXNkvmgJCjlqSk2XYnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNwpwlraByYut7DOquNgawCR8Oit8vJVKWURVyfYoTvdj+logB6uOV05b46n4Fk2yu7X03I3jUW+sgveVZ596xfcj/4I3J9Qkw5Irl9uCpxczhwEDsWryTpOy18Zm89pzKure5qvAHWgEUeKbnUaKXZh16j7BBKYiyyYYoM0faI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIjDnze1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIjDnze1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71C5C116D0;
	Wed, 25 Feb 2026 01:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983503;
	bh=6Z924ZUI+t5jJSkrkTJAHH0CAXNkvmgJCjlqSk2XYnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIjDnze1ckeBe8sXWPvucyHiKNdAl+FBz6ZtRG2Yqr00LduwRT7NuXwQ9pvcEAk5T
	 156dpZOn9gW5jTN4A1fIQiWInRwzQ8v0snkM85rp+0HsrdLuHTpsGroBof0fmsYl0O
	 UTHBQEOCM2tIQ9znO2hDCZ1fqLBi/sJClj+z2SKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 612/781] block: allow IOC_PR_READ_* ioctls with BLK_OPEN_READ
Date: Tue, 24 Feb 2026 17:22:01 -0800
Message-ID: <20260225012414.809016664@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Hajnoczi <stefanha@redhat.com>

[ Upstream commit 5b88af7113feba2f0ae3402bb57cb5c94eea7dc3 ]

The recently added IOC_PR_READ_* ioctls require the same BLK_OPEN_WRITE
permission as the older persistent reservation ioctls. This has the
drawback that udev triggers when the file descriptor is closed,
resulting in unnecessary activity like scanning partitions even though
these read-only ioctls do not modify the device.

Change IOC_PR_READ_KEYS and IOC_PR_READ_RESERVATION to require
BLK_OPEN_READ. This prevents unnecessary activity every time `blkpr
--read-keys` or `blkpr --read-reservation` is invoked by shell scripts,
for example.

It is safe to reduce the permission requirement from BLK_OPEN_WRITE to
BLK_OPEN_READ since these two ioctls do not modify the persistent
reservation state. Userspace cannot use the information fetched by these
ioctls to make changes to the device unless it later opens the device
with BLK_OPEN_WRITE.

Fixes: 3e2cb9ee76c2 ("block: add IOC_PR_READ_RESERVATION ioctl")
Fixes: 22a1ffea5f80 ("block: add IOC_PR_READ_KEYS ioctl")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Suggested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/ioctl.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 344478348a54e..337e4c3b65b2c 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -318,7 +318,13 @@ int blkdev_compat_ptr_ioctl(struct block_device *bdev, blk_mode_t mode,
 EXPORT_SYMBOL(blkdev_compat_ptr_ioctl);
 #endif
 
-static bool blkdev_pr_allowed(struct block_device *bdev, blk_mode_t mode)
+enum pr_direction {
+	PR_IN,  /* read from device */
+	PR_OUT, /* write to device */
+};
+
+static bool blkdev_pr_allowed(struct block_device *bdev, blk_mode_t mode,
+		enum pr_direction dir)
 {
 	/* no sense to make reservations for partitions */
 	if (bdev_is_partition(bdev))
@@ -326,11 +332,17 @@ static bool blkdev_pr_allowed(struct block_device *bdev, blk_mode_t mode)
 
 	if (capable(CAP_SYS_ADMIN))
 		return true;
+
 	/*
-	 * Only allow unprivileged reservations if the file descriptor is open
-	 * for writing.
+	 * Only allow unprivileged reservation _out_ commands if the file
+	 * descriptor is open for writing. Allow reservation _in_ commands if
+	 * the file descriptor is open for reading since they do not modify the
+	 * device.
 	 */
-	return mode & BLK_OPEN_WRITE;
+	if (dir == PR_IN)
+		return mode & BLK_OPEN_READ;
+	else
+		return mode & BLK_OPEN_WRITE;
 }
 
 static int blkdev_pr_register(struct block_device *bdev, blk_mode_t mode,
@@ -339,7 +351,7 @@ static int blkdev_pr_register(struct block_device *bdev, blk_mode_t mode,
 	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
 	struct pr_registration reg;
 
-	if (!blkdev_pr_allowed(bdev, mode))
+	if (!blkdev_pr_allowed(bdev, mode, PR_OUT))
 		return -EPERM;
 	if (!ops || !ops->pr_register)
 		return -EOPNOTSUPP;
@@ -357,7 +369,7 @@ static int blkdev_pr_reserve(struct block_device *bdev, blk_mode_t mode,
 	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
 	struct pr_reservation rsv;
 
-	if (!blkdev_pr_allowed(bdev, mode))
+	if (!blkdev_pr_allowed(bdev, mode, PR_OUT))
 		return -EPERM;
 	if (!ops || !ops->pr_reserve)
 		return -EOPNOTSUPP;
@@ -375,7 +387,7 @@ static int blkdev_pr_release(struct block_device *bdev, blk_mode_t mode,
 	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
 	struct pr_reservation rsv;
 
-	if (!blkdev_pr_allowed(bdev, mode))
+	if (!blkdev_pr_allowed(bdev, mode, PR_OUT))
 		return -EPERM;
 	if (!ops || !ops->pr_release)
 		return -EOPNOTSUPP;
@@ -393,7 +405,7 @@ static int blkdev_pr_preempt(struct block_device *bdev, blk_mode_t mode,
 	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
 	struct pr_preempt p;
 
-	if (!blkdev_pr_allowed(bdev, mode))
+	if (!blkdev_pr_allowed(bdev, mode, PR_OUT))
 		return -EPERM;
 	if (!ops || !ops->pr_preempt)
 		return -EOPNOTSUPP;
@@ -411,7 +423,7 @@ static int blkdev_pr_clear(struct block_device *bdev, blk_mode_t mode,
 	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
 	struct pr_clear c;
 
-	if (!blkdev_pr_allowed(bdev, mode))
+	if (!blkdev_pr_allowed(bdev, mode, PR_OUT))
 		return -EPERM;
 	if (!ops || !ops->pr_clear)
 		return -EOPNOTSUPP;
@@ -434,7 +446,7 @@ static int blkdev_pr_read_keys(struct block_device *bdev, blk_mode_t mode,
 	size_t keys_copy_len;
 	int ret;
 
-	if (!blkdev_pr_allowed(bdev, mode))
+	if (!blkdev_pr_allowed(bdev, mode, PR_IN))
 		return -EPERM;
 	if (!ops || !ops->pr_read_keys)
 		return -EOPNOTSUPP;
@@ -486,7 +498,7 @@ static int blkdev_pr_read_reservation(struct block_device *bdev,
 	struct pr_read_reservation out = {};
 	int ret;
 
-	if (!blkdev_pr_allowed(bdev, mode))
+	if (!blkdev_pr_allowed(bdev, mode, PR_IN))
 		return -EPERM;
 	if (!ops || !ops->pr_read_reservation)
 		return -EOPNOTSUPP;
-- 
2.51.0



