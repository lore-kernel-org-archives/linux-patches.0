Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EF5379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301920; cv=none; b=LcAaw1R77N1jgqDNx10gGz3N5bQiD8qeUWQsbLra2wPS1//kf3hYmKZMxUK9ObT2hWaP4j8Iqr/KgrTuhnwtbIbDPT7MrcQRi+PIEwU3iYJJPNEIbaz4vWaQBS+lp5hbSZwZzpOCZ68EszPo+Ohg/un1geQOUt2hP3/Zy63b1kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301920; c=relaxed/simple;
	bh=9JCYQWccimbDgkFWrdP1D0hj56uaHd2jiZYeUn66Z8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OUf0AZn1Zy/GYawdR54SuPo0c/+lYLRdpiP/S6Xr9Wiv9hLTo+oror6LE6L0HeoCGonvlDLghxB6w0VMYFtVIUSI00A4AQJvdugWDIBgkXi2wI17xRwBKFKWoBMXuvSn0x/9M/Mo+cbX1s13FU3FIuEtI3BdNoBkBKou3Pu4ZsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6UjqlHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6UjqlHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91506C19423;
	Sat, 28 Feb 2026 18:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301920;
	bh=9JCYQWccimbDgkFWrdP1D0hj56uaHd2jiZYeUn66Z8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6UjqlHBKSpG18gdtHkvhva9fdLMcezk0IAIZMp+PufVu/jKfYFzJdIk/99FrWkVz
	 /OxfzMiLoBjUfYdn2iOL9Zg6lGgHGpomf3tWVsNAZSaiUjULQQw2or02+o23Iz4ddY
	 WAkjxaBnV3zeS1bm/gy+rNvrbEnjBJyiYmz6RmDX9KKPZkUVVLN+MxcL0Q+tmVx3oD
	 DT+Zb0dNzmAz+td2XtqSid4nP3FXBb7L4jkYFSfjQQI1U7qo8oIUNbrl3u61Izn6nP
	 kg/O4cVlDMgNphqMjk38K4RB/U6qsLYEYgtrUUz+d4jx+LXslFT+/cQ5/38oVf3GQl
	 fiSnXyPQgOhIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 353/385] drbd: always set BLK_FEAT_STABLE_WRITES
Date: Sat, 28 Feb 2026 12:59:35 -0500
Message-ID: <20260228180011.1568201-353-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 5bbd312c3e14d..8c5a7bcfa82b2 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2683,9 +2683,6 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 		 * connect.
 		 */
 		.max_hw_sectors		= DRBD_MAX_BIO_SIZE_SAFE >> 8,
-		.features		= BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA |
-					  BLK_FEAT_ROTATIONAL |
-					  BLK_FEAT_STABLE_WRITES,
 	};
 
 	device = minor_to_device(minor);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 720fc30e2ecc9..8c12bf1b2a0d2 100644
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

