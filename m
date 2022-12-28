Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7381863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76D4C433EF;
	Wed, 28 Dec 2022 15:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241674;
	bh=HSqcU3DS8WauVMBJCEpJALpi2UP11Kfm6Gs/Vah/v5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SP+jzZpQXIfcxphrFE2wiqMXIvst7kNquqN4MVk8vm0wo1xcwq1vC/CbQV7EJVS/v
	 vCotxHGJXcWTP+XaWnrEyyAK9or02hKhQkPQoZZEn+mWZZCfwCmjqhV2JiqF675Rr2
	 Bp63CX98xiICJpEP/LHBRRpv0hfHvlQAfuJnhRgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Colledge <joel.colledge@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0305/1073] drbd: use blk_queue_max_discard_sectors helper
Date: Wed, 28 Dec 2022 15:31:33 +0100
Message-Id: <20221228144336.294978299@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>

[ Upstream commit 258bea6388ac93f34561fd91064232d14e174bff ]

We currently only set q->limits.max_discard_sectors, but that is not
enough. Another field, max_hw_discard_sectors, was introduced in
commit 0034af036554 ("block: make /sys/block/<dev>/queue/discard_max_bytes
writeable").

The difference is that max_discard_sectors can be changed from user
space via sysfs, while max_hw_discard_sectors is the "hardware" upper
limit.

So use this helper, which sets both.

This is also a fixup for commit 998e9cbcd615 ("drbd: cleanup
decide_on_discard_support"): if discards are not supported, that does
not necessarily mean we also want to disable write_zeroes.

Fixes: 998e9cbcd615 ("drbd: cleanup decide_on_discard_support")
Reviewed-by: Joel Colledge <joel.colledge@linbit.com>
Signed-off-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Link: https://lore.kernel.org/r/20221109133453.51652-2-christoph.boehmwalder@linbit.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_nl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 013d355a2033..921c303a7b5c 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1210,6 +1210,7 @@ static void decide_on_discard_support(struct drbd_device *device,
 	struct drbd_connection *connection =
 		first_peer_device(device)->connection;
 	struct request_queue *q = device->rq_queue;
+	unsigned int max_discard_sectors;
 
 	if (bdev && !bdev_max_discard_sectors(bdev->backing_bdev))
 		goto not_supported;
@@ -1230,15 +1231,14 @@ static void decide_on_discard_support(struct drbd_device *device,
 	 * topology on all peers.
 	 */
 	blk_queue_discard_granularity(q, 512);
-	q->limits.max_discard_sectors = drbd_max_discard_sectors(connection);
-	q->limits.max_write_zeroes_sectors =
-		drbd_max_discard_sectors(connection);
+	max_discard_sectors = drbd_max_discard_sectors(connection);
+	blk_queue_max_discard_sectors(q, max_discard_sectors);
+	blk_queue_max_write_zeroes_sectors(q, max_discard_sectors);
 	return;
 
 not_supported:
 	blk_queue_discard_granularity(q, 0);
-	q->limits.max_discard_sectors = 0;
-	q->limits.max_write_zeroes_sectors = 0;
+	blk_queue_max_discard_sectors(q, 0);
 }
 
 static void fixup_write_zeroes(struct drbd_device *device, struct request_queue *q)
-- 
2.35.1



