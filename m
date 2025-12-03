Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A742B350285;
	Wed,  3 Dec 2025 16:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778404; cv=none; b=db+ce7huzfYsUCqc/O/t42PtImNtwYRfetBvSsdzPC4UjGZJCZNsptO81CaJ7ZenIy2iBxOG6d9wrpjLRHj0J8PaYkF6nuJkP61WijnjqIyZXYFUYt6vU8MNPZtNY6zpGfzHftHl4cEk0yKBNxLqliXdkE7W8DVP6f5pSFQDNyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778404; c=relaxed/simple;
	bh=JY9DHwvrsVk6Q+KfHvjmc2ago19h1QChcYIudLfB4/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRBqtarvz5ZPHvsOKO7VS3Ql3/Mo/epL60lsDKZ4YdbeMUSqCw3DD1fexDHG+BqFmFRgE5yEpIhjwUGYND5vrlG/tgXdfzjrkanywVzboUPFgVfxUuE5aWL/asZtDsAxOOh5Vu8VivdpTGZnqpLs4v2pdL4TEPHovz9bxAISSQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoqXRk+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoqXRk+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0519BC4CEF5;
	Wed,  3 Dec 2025 16:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778404;
	bh=JY9DHwvrsVk6Q+KfHvjmc2ago19h1QChcYIudLfB4/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JoqXRk+onSBEEqiIQjjGPNI6nye9Y0VQxlzb0LhW7p0ea5eOp6CfXnInbHnP2v2VN
	 1RVkoEqyAyR969A0DhkRvV6zv/IFHEU4z5r1t4RWMsjYzd9ErRSLHI7yWVLmXe96Ft
	 QQMLYjQibwS9WJqtDgA9cXO5MTLG7Yt6jzuOnWxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gulam Mohamed <gulam.mohamed@oracle.com>
Subject: [PATCH 5.15 335/392] Revert "block: Move checking GENHD_FL_NO_PART to bdev_add_partition()"
Date: Wed,  3 Dec 2025 16:28:05 +0100
Message-ID: <20251203152426.498533675@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gulam Mohamed <gulam.mohamed@oracle.com>

This reverts commit 7777f47f2ea64efd1016262e7b59fab34adfb869.

The commit 1a721de8489f ("block: don't add or resize partition on the disk
with GENHD_FL_NO_PART") and the commit 7777f47f2ea6 ("block: Move checking
GENHD_FL_NO_PART to bdev_add_partition()") used the flag GENHD_FL_NO_PART
to prevent the add or resize of partitions in 5.15 stable kernels.But in
these 5.15 kernels, this is giving an issue with the following error
where the loop driver wants to create a partition when the partscan is
disabled on the loop device:

dd if=/dev/zero of=loopDisk.dsk bs=1M count=1 seek=10240;
losetup -f loopDisk.dsk;parted -s /dev/loop0 -- mklabel gpt mkpart primary
           2048s 4096s
1+0 records in
1+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.0016293 s, 644 MB/s
""
Error: Partition(s) 1 on /dev/loop0 have been written, but we have been
unable to inform the kernel of the change, probably because it/they are
in use.  As a result, the old partition(s) will remain in use.  You should
reboot now before making further changes.
""
If the partition scan is not enabled on the loop device, this flag
GENHD_FL_NO_PART is getting set and when partition creation is tried,
it returns an error EINVAL thereby preventing the creation of partitions.
So, there is no such distinction between disabling of partition scan and
partition creation.

Later in 6.xxx kernels, the commit b9684a71fca7 ("block, loop: support
partitions without scanning") a new flag GD_SUPPRESS_PART_SCAN was
introduced that just disables the partition scan and uses GENHD_FL_NO_PART
only to prevent creating partition scan. So, the partition creationg can
proceed with even if partition scan is disabled.

As the commit b9684a71fca7 ("block, loop: support partitions without
scanning") is not available in 5.15 stable kernel, and since there is no
distinction between disabling of "partition scan" and "partition
creation", we need to revert the commits 1a721de8489f and 7777f47f2ea6
from 5.15 stable kernel to allow partition creation when partscan is
disabled.

Cc: stable@vger.kernel.org
Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/ioctl.c           |    2 ++
 block/partitions/core.c |    5 -----
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -20,6 +20,8 @@ static int blkpg_do_ioctl(struct block_d
 	struct blkpg_partition p;
 	sector_t start, length;
 
+	if (disk->flags & GENHD_FL_NO_PART)
+		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 	if (copy_from_user(&p, upart, sizeof(struct blkpg_partition)))
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -463,11 +463,6 @@ int bdev_add_partition(struct gendisk *d
 		goto out;
 	}
 
-	if (disk->flags & GENHD_FL_NO_PART) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if (partition_overlaps(disk, start, length, -1)) {
 		ret = -EBUSY;
 		goto out;


