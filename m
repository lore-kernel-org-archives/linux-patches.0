Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968FD229B05;
	Tue, 29 Apr 2025 16:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945888; cv=none; b=oHgoM/oUTkVkAnqdD2KtELmFFZfEWsrRBvKhDPeO3X8hRA34ADQCEn6MZ1J4uFaVrBnorT9FudkAX908jz04+BX/jakdNi2MrZXWI5T846sWsoLgjekZciLW6bktyp6AJdLJOPOoX72RPm4MwLSaCUoAFM20e46SuYG//0Brctg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945888; c=relaxed/simple;
	bh=axZ1oA/0gftr9wn420ArV4J0MNbXlGW57L4hONpStK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGE5LH0arIgKKta5JbmGExhJLZYNdvkFCSTd1rbRSZ9mq6Ulwb9mHE+EvMgyC28v/+JLldmsVseFygBTHkXztK8amphBWihE0i3w/Iej69zekWj4+Zbj5LoP38OoxWaleTBJUeuXkjU7p/i4oDMrY8CYD3l6BaV+fdsH+JnhLho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CzV6odR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CzV6odR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E8FC4CEE9;
	Tue, 29 Apr 2025 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945888;
	bh=axZ1oA/0gftr9wn420ArV4J0MNbXlGW57L4hONpStK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CzV6odR2hmp6d6/fh8E7xR9b796xU48nYC3R1MxsgjkHd0/W6WO8SPZ53dv1+sMkx
	 WZcHdsGMJ4qA+XnDUid+6wOccl3s8JcmKBPZGt0NHjyLXfnRYOvE2YD2gFMSUpxVsV
	 HGSCiC1PUt+kRrT8zx0d8O3zgfvy2UiotoptKcM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 081/311] bdev: use bdev_io_min() for statx block size
Date: Tue, 29 Apr 2025 18:38:38 +0200
Message-ID: <20250429161124.375960285@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit 425fbcd62d2e1330e64d8d3bf89e554830ba997f ]

You can use lsblk to query for a block device block device block size:

lsblk -o MIN-IO /dev/nvme0n1
MIN-IO
 4096

The min-io is the minimum IO the block device prefers for optimal
performance. In turn we map this to the block device block size.
The current block size exposed even for block devices with an
LBA format of 16k is 4k. Likewise devices which support 4k LBA format
but have a larger Indirection Unit of 16k have an exposed block size
of 4k.

This incurs read-modify-writes on direct IO against devices with a
min-io larger than the page size. To fix this, use the block device
min io, which is the minimal optimal IO the device prefers.

With this we now get:

lsblk -o MIN-IO /dev/nvme0n1
MIN-IO
 16384

And so userspace gets the appropriate information it needs for optimal
performance. This is verified with blkalgn against mkfs against a
device with LBA format of 4k but an NPWG of 16k (min io size)

mkfs.xfs -f -b size=16k  /dev/nvme3n1
blkalgn -d nvme3n1 --ops Write

     Block size          : count     distribution
         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 0        |                                        |
         8 -> 15         : 0        |                                        |
        16 -> 31         : 0        |                                        |
        32 -> 63         : 0        |                                        |
        64 -> 127        : 0        |                                        |
       128 -> 255        : 0        |                                        |
       256 -> 511        : 0        |                                        |
       512 -> 1023       : 0        |                                        |
      1024 -> 2047       : 0        |                                        |
      2048 -> 4095       : 0        |                                        |
      4096 -> 8191       : 0        |                                        |
      8192 -> 16383      : 0        |                                        |
     16384 -> 32767      : 66       |****************************************|
     32768 -> 65535      : 0        |                                        |
     65536 -> 131071     : 0        |                                        |
    131072 -> 262143     : 2        |*                                       |
Block size: 14 - 66
Block size: 17 - 2

     Algn size           : count     distribution
         0 -> 1          : 0        |                                        |
         2 -> 3          : 0        |                                        |
         4 -> 7          : 0        |                                        |
         8 -> 15         : 0        |                                        |
        16 -> 31         : 0        |                                        |
        32 -> 63         : 0        |                                        |
        64 -> 127        : 0        |                                        |
       128 -> 255        : 0        |                                        |
       256 -> 511        : 0        |                                        |
       512 -> 1023       : 0        |                                        |
      1024 -> 2047       : 0        |                                        |
      2048 -> 4095       : 0        |                                        |
      4096 -> 8191       : 0        |                                        |
      8192 -> 16383      : 0        |                                        |
     16384 -> 32767      : 66       |****************************************|
     32768 -> 65535      : 0        |                                        |
     65536 -> 131071     : 0        |                                        |
    131072 -> 262143     : 2        |*                                       |
Algn size: 14 - 66
Algn size: 17 - 2

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20250221223823.1680616-9-mcgrof@kernel.org
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 5f33b5226c9d ("block: don't autoload drivers on stat")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index 9d73a8fbf7f99..8453f6a795d9a 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1274,9 +1274,6 @@ void bdev_statx(struct path *path, struct kstat *stat,
 	struct inode *backing_inode;
 	struct block_device *bdev;
 
-	if (!(request_mask & (STATX_DIOALIGN | STATX_WRITE_ATOMIC)))
-		return;
-
 	backing_inode = d_backing_inode(path->dentry);
 
 	/*
@@ -1303,6 +1300,8 @@ void bdev_statx(struct path *path, struct kstat *stat,
 			queue_atomic_write_unit_max_bytes(bd_queue));
 	}
 
+	stat->blksize = bdev_io_min(bdev);
+
 	blkdev_put_no_open(bdev);
 }
 
-- 
2.39.5



