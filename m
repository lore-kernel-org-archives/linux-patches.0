Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310644E2F36;
	Fri,  9 Oct 2026 14:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555734; cv=none; b=EuYFYj7oUr0t+ngRXyiMdT+G3Pe7nHWiHJPy76tkIV4F6jnqDOP94ysgZehy1DrRdgC11hgpFCE/KTvObHVzE9IB09ufQLxsddHANJTifi4aG8jCK54QheeS4AR9S1ynxUrI73SBh8LbQjpHdhABiMO62IVe/idXHYmn0moAF9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555734; c=relaxed/simple;
	bh=xEWiyG0kG7Mp65l/yF0kbpFGZj2BVJHpT42g4QnmWic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fde000RWl7OtUxTmm4c4/gu4l4vleR/MplX04lDuTEaCaX36PeCGkaCQcmIIM+wiP+LVZrPLFyMcOF72kc3sa+w0T2HQ9v/Xd0izk/v1JF942oSAGld5EVEpz5X+Hh74r5wwMMQX/PK/4U3xFvhkgzGLKZHemCOcaxr67+T0EDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDd6H4sy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDd6H4sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714871F000FF;
	Fri,  9 Oct 2026 14:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555733;
	bh=sCjvN8ecWtjJWRtp1SuvArs0T9f8iO58iQpZX2ao7dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZDd6H4syLzxE4HNvvlpES8TXalYqDxU6p6c92kt3s7TpdguwyX6KOs1pEvqAOArOB
	 BWzQxb1FrTx1A6zhLQGtSsY/iRIEOXbnMfPqHU2GmAnhX2Px9TrMrkLq4hunMXCl4J
	 B5M3KpMACOa13K0EeZRZHvoTmGeMexbBz9vTEbNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/403] virtio_blk: set the zone write granularity
Date: Fri,  9 Oct 2026 16:07:48 +0200
Message-ID: <20261009140954.584933977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 684b413b5483f57c890c171b9400076a0143b918 ]

virtblk_read_zoned_limits() reads the write granularity that the device
reports in virtio_blk_zoned_characteristics and assigns it to the
physical block size and to io_min, but never to the limit that is named
after it. queue_limits.zone_write_granularity is left at zero, so
blk_validate_zoned_limits() raises it to the logical block size:

	if (lim->zone_write_granularity < lim->logical_block_size)
		lim->zone_write_granularity = lim->logical_block_size;

A device that reports a granularity coarser than its logical block size,
which is what the field exists to express, therefore has it silently
reduced. A 512e host managed disk passed through to a guest reports a
logical block size of 512 and a write granularity of 4096, and the guest
ends up with a zone write granularity of 512.

bio_split_alignment() returns lim->zone_write_granularity if it is non-zero
and bio_split_io_at() may split a bio with as per bio_split_alignment().
This can real to the write getting rejected by the host drive, as the write
is not aligned to the physical block size.

zonefs also takes its block size from bdev_zone_write_granularity(), so it
would incorrectly use 512 on a disk that requires 4096.

sd_zbc_read_zones() sets the limit from the physical block size for the
same reason. NVMe ZNS and null_blk leave it unset, but the fallback
gives the right answer for them, as their write granularity is the
logical block size. virtio carries a separate value that may exceed it.

Set the zone write granularity from the value that the device reports.

Fixes: 95bfec41bd3d ("virtio-blk: add support for zoned block devices")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Link: https://patch.msgid.link/20260918140641.2031075-2-cassel@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index f061420dfb10c..e577b02cf4003 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -740,6 +740,7 @@ static int virtblk_read_zoned_limits(struct virtio_blk *vblk,
 		dev_warn(&vdev->dev, "zero write granularity reported\n");
 		return -ENODEV;
 	}
+	lim->zone_write_granularity = wg;
 	lim->physical_block_size = wg;
 	lim->io_min = wg;
 
-- 
2.53.0



