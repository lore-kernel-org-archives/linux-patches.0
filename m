Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE264F3939;
	Tue, 13 Oct 2026 12:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895020; cv=none; b=iFFx7vapMlAA/9+JjHjJEJjoG7etsVy2ECn0HUDtFI5bCa9aDfQJAvjjXxoOvEoIK/piVzJEbBu9WzsJ5H4n8iMB6lMpzv2ZIgfwG3LoygvMpNKXxdz44iniBkRT7pqukozvFWLKOl1woxAQVc1Brp2g8DIum/aehfgEoqehOfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895020; c=relaxed/simple;
	bh=LlTrK0QeSi0udyachBCd6YmW9c+xp5AA08tBx1g9jc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAJ2OB7w8C6dqI8xwlTHyN/VwKt4SDgzRjRBlA0g00uXn8s58MdfHSx4+ydmTxOAiIGeKOg2q/oGV7UfzkIhUXX5Xu+I1D1FQ9l9uqFLXOJjsiGBcOofeGn6Yb+lZioWg9HRHL+tbUWtCkP5IXKZBoUa9ixvMAAniuVvhaeoYsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o54/WCqT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o54/WCqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A64F1F000FF;
	Tue, 13 Oct 2026 12:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895018;
	bh=WRi2lbAb4L85oBQ6BiJWUgdwCrGuM/l+9v2OXduEmN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o54/WCqT5TzrTuK55V3KwJSFBCz7CBJoGNhyYuwpbuPn4Lexl3n/Uo6JvT2Y+LFI+
	 gqF4HKhIeeanXoglF+YvjCmx9BnGLgnwUA0995M1OM6Q+cQup3x0ozhdOp3uKMGlsA
	 DdIZQ5jGScr2D/RZSmIf7DprG3mAdCGq92Sa/Emk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/497] virtio_blk: set the zone write granularity
Date: Tue, 13 Oct 2026 13:34:17 +0200
Message-ID: <20261013112910.025633791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index 4bedcb49a73a7..789890f3c5ff4 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -741,6 +741,7 @@ static int virtblk_read_zoned_limits(struct virtio_blk *vblk,
 		dev_warn(&vdev->dev, "zero write granularity reported\n");
 		return -ENODEV;
 	}
+	lim->zone_write_granularity = wg;
 	lim->physical_block_size = wg;
 	lim->io_min = wg;
 
-- 
2.53.0



