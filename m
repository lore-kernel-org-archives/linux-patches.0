Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4933243376;
	Wed, 25 Feb 2026 01:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983502; cv=none; b=g2zlvuQgAYnodDg4h2PDXxI4//VdqzbRap2Cs1ci+Vc5HSkIzLxTv/fOeXI/TXdurI+oOgMRPFPynI0DvVtChEZ7qr40U5JLqmqpe7gQg5QSp8LS62C5exRVK0jJkKx2czBSsJCoxnuu7XqXKblN8WtCbTPScSMwwvrXjmfzIjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983502; c=relaxed/simple;
	bh=gKjr1AF50NVATfxHilq+KhWH/MDcp16wmOPTMCkWV/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WAliaEwBV6WVm+AqXFnm00sIMHxHA2kIwYnWNJh1YzAm/TABvDJms8izP2wePmA3Q8gXmLUYKFgDPMx7lj68ZI+A1Ma4hSourOlTIxvVW/5xLGWyi1vflwJlQOhEGa8dPfI+PEaI+uAVyulHXa+vc3OsChCJHiCAGwFk0/7VeSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhcdAqFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhcdAqFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931ACC116D0;
	Wed, 25 Feb 2026 01:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983502;
	bh=gKjr1AF50NVATfxHilq+KhWH/MDcp16wmOPTMCkWV/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BhcdAqFFZ7r78i2RcDQhjuKWavS9hh57Hpkbm0a9fMXJ55ybNVEBTPQr1oDMA/GFQ
	 TYpHaYXkFVO9+ppnVSNzGgHV6EPZkCGwk8rgJZnXQCqKQ6KJPiQfK2Ly1ywqHAz5p8
	 rhNcECLCFXOBsJk/Et262esX3vegGF/nI910TdWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 611/781] drbd: always set BLK_FEAT_STABLE_WRITES
Date: Tue, 24 Feb 2026 17:22:00 -0800
Message-ID: <20260225012414.781437998@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>

[ Upstream commit 2ebc8d600fb907fa6b1e7095c0b6d84fc47e91ea ]

DRBD requires stable pages because it may read the same bio data
multiple times for local disk I/O and network transmission, and in
some cases for calculating checksums.

The BLK_FEAT_STABLE_WRITES flag is set when the device is first
created, but blk_set_stacking_limits() clears it whenever a
backing device is attached. In some cases the flag may be
inherited from the backing device, but we want it to be enabled
at all times.

Unconditionally re-enable BLK_FEAT_STABLE_WRITES in
drbd_reconsider_queue_parameters() after the queue parameter
negotiations.

Also, document why we want this flag enabled in the first place.

Fixes: 1a02f3a73f8c ("block: move the stable_writes flag to queue_limits")
Signed-off-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c |  3 ---
 drivers/block/drbd/drbd_nl.c   | 20 +++++++++++++++++++-
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c73376886e7a5..1f6ac9202b66a 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2659,9 +2659,6 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 		 * connect.
 		 */
 		.max_hw_sectors		= DRBD_MAX_BIO_SIZE_SAFE >> 8,
-		.features		= BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA |
-					  BLK_FEAT_ROTATIONAL |
-					  BLK_FEAT_STABLE_WRITES,
 	};
 
 	device = minor_to_device(minor);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 91f3b8afb63ce..b502038be0a92 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1296,6 +1296,8 @@ void drbd_reconsider_queue_parameters(struct drbd_device *device,
 		lim.max_segments = drbd_backing_dev_max_segments(device);
 	} else {
 		lim.max_segments = BLK_MAX_SEGMENTS;
+		lim.features = BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA |
+			       BLK_FEAT_ROTATIONAL | BLK_FEAT_STABLE_WRITES;
 	}
 
 	lim.max_hw_sectors = new >> SECTOR_SHIFT;
@@ -1318,8 +1320,24 @@ void drbd_reconsider_queue_parameters(struct drbd_device *device,
 		lim.max_hw_discard_sectors = 0;
 	}
 
-	if (bdev)
+	if (bdev) {
 		blk_stack_limits(&lim, &b->limits, 0);
+		/*
+		 * blk_set_stacking_limits() cleared the features, and
+		 * blk_stack_limits() may or may not have inherited
+		 * BLK_FEAT_STABLE_WRITES from the backing device.
+		 *
+		 * DRBD always requires stable writes because:
+		 * 1. The same bio data is read for both local disk I/O and
+		 *    network transmission. If the page changes mid-flight,
+		 *    the local and remote copies could diverge.
+		 * 2. When data integrity is enabled, DRBD calculates a
+		 *    checksum before sending the data. If the page changes
+		 *    between checksum calculation and transmission, the
+		 *    receiver will detect a checksum mismatch.
+		 */
+		lim.features |= BLK_FEAT_STABLE_WRITES;
+	}
 
 	/*
 	 * If we can handle "zeroes" efficiently on the protocol, we want to do
-- 
2.51.0



