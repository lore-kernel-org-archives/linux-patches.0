Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050712;
	b=qQSrgoArzDFCkdMb9TijCaHkY7qffN9z2hJjtzvCwtnWi9WZFGdekxPT5uTUTjA40DH5
	 m9Be6kNH1VpaiihguElhFWi8WCDq8FR74QVBNnTldy02xwVYuHNaYYl8FQ5eB7dNyKve1
	 OAUlDaJnFhOpC+vsRXViJ2kI1LDKGaMUWNL0qSmmTGpVt4P5j9217B+KIB5MdVNE4sOJF
	 iPV0BBIK8OwBbvVeIOKcwLayk+ORS/lmpM8q3ZGNeUu4xAfBR6yqa2uvmOLpH2gCOcMs+
	 /Z9bKR0b8yTb4nTrRGLcZAAxTU96W+an/nAXI0hqPgwdBuHwefpqBEaHZl1/HZ0melw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KLgw2ky6zTc5lhxQs/zGY6GJLvro/UOBnDwEMufcKTg=;
	b=swj1Qj06c8mZaDDZlAWc+HpIIGXeaukqTfslfYJz4SGUpya/AlGnj1NBjwFfkjslh5zV
	 WJn7oAvjGXIXBGttI029kG/xZsaNfNQg6PrZRbw8DjCpNYgxxo7Uov+cowuW1/3zwfOqz
	 N0sDKhSjpklYX1OHjlOiFaOvTVZtx37OSu1WUHVt1W9GKGC9w+wF1GmCy60eN163i4sDZ
	 tQL32XeyrinfFchEpKv33a+y8V1ARM+aIoMVsLngzy/crGKDn+8KwV1tcvEv9ubt10aWp
	 2kEJhOLxA22Dfpldln4EO6Oe4CcG240rtW6fF3GyHvzNTpx3dA7+WBj+lXji9EksoWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gv/Fuewr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08146606A320;
	Thu, 19 Nov 2026 01:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gv/Fuewr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CA31F000C4;
	Thu, 19 Nov 2026 01:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050711;
	bh=KLgw2ky6zTc5lhxQs/zGY6GJLvro/UOBnDwEMufcKTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gv/FuewrangiVW56QX3Sf+jc9CLOR9fmBjG/8ekm1duW5k+Kf7KjH1oLSr7ESCzba
	 xLkx3l5hANai+ySocHKSu8nE0+WvZPZeRhn4dVSXIoGXzec8KgM6W5cDQgSE6c1BMh
	 p9g3cE3KkwQSkFYhsoMQ9TyuXHhesZGdYngEKW/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2798/2857] block: fix use-after-free of the disk in sync_bdevs()
Date: Wed, 18 Nov 2026 16:03:52 +0100
Message-ID: <20261118150342.336788826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit cebb1c2331c2af1b7f1c822ac672a7f77b54bd90 ]

sync_bdevs() holds a reference to the bdev inode while it takes
bd_disk->open_mutex. For a partition the inode doesn't keep the gendisk
alive, the device reference does: part_release() drops the disk as soon
as the last reference to the partition device is gone. A sync(2) racing
with the last close of a partition of an already deleted disk locks a
freed open_mutex.

Take a device reference before touching the disk, like
blkdev_get_no_open() does, and skip the bdev if it's on its way out.

Fixes: a8698707a183 ("block: move bd_mutex to struct gendisk")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261028164415.1262013-5-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/bdev.c b/block/bdev.c
index 0c1b8d3e80a37..5331a733a3258 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1076,6 +1076,15 @@ void sync_bdevs(bool wait)
 		old_inode = inode;
 		bdev = I_BDEV(inode);
 
+		/*
+		 * The inode does not keep the gendisk of a partition alive, the
+		 * device does.
+		 */
+		if (!kobject_get_unless_zero(&bdev->bd_device.kobj)) {
+			spin_lock(&blockdev_superblock->s_inode_list_lock);
+			continue;
+		}
+
 		mutex_lock(&bdev->bd_disk->open_mutex);
 		if (!atomic_read(&bdev->bd_openers)) {
 			; /* skip */
@@ -1091,6 +1100,7 @@ void sync_bdevs(bool wait)
 			filemap_fdatawrite(inode->i_mapping);
 		}
 		mutex_unlock(&bdev->bd_disk->open_mutex);
+		put_device(&bdev->bd_device);
 
 		spin_lock(&blockdev_superblock->s_inode_list_lock);
 	}
-- 
2.53.0



