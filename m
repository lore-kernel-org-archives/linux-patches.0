Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1010F2D839C;
	Wed, 25 Feb 2026 06:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002700; cv=none; b=TkBmkHP+zogc1yMdQB7hRbEccgRWUrDP0F1JcCO5Y5wy/xGf4iPnyz44QUhhjY7YhNbtx8Ak9xLUcr2hURcUoFLKMe1sb6gu8vdtTNd5a4q3I1RTJPDzFfHT2J7Jd25N+id5TBpNk2JdEKxp9K8gAOiOWUNImnWn0R3D6W/emAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002700; c=relaxed/simple;
	bh=U65CI9fIn+gCBegGT7QtrSxxpNolAJBQMD4I5RCaYsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cGa/fYZjhM6F4kkTQRUtXhjVG94DcoefkW1/kYQ8WtEsCCvuU2JRyduaoT/9MGmXTbr7ithVXUTd8gFOLv96tJAezYSdNL59BEnMCTGhf2I0Uh1ex7LpLpiAhW6WIcJIm4M/R108OcYxAkz+wXlNG2u0OS03iw+XSHTLxOnQK6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBA0Rqss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBA0Rqss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7CCC116D0;
	Wed, 25 Feb 2026 06:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002700;
	bh=U65CI9fIn+gCBegGT7QtrSxxpNolAJBQMD4I5RCaYsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBA0RqssYLHSbK8QTztCZ1RawZ6SVb/IT2jKNztlEmSzycYfNXgd+Rmvxta57h7QU
	 yGgWgSs50tX9vKXn+3NkBtda+Kz/epiEI5c4fw2AsyZ73p+3d1A+x7WLZEZFVYIWfp
	 YCKqxC7RI+nGOAhDxZ9MEcbdV+aaXYtEhx3a1djU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 497/641] drbd: always set BLK_FEAT_STABLE_WRITES
Date: Tue, 24 Feb 2026 17:23:43 -0800
Message-ID: <20260225012400.563785944@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



