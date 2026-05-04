Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451B43DE44F;
	Mon,  4 May 2026 14:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904599; cv=none; b=pa5lcBczAxWUydKo4BmLNX3uxlsnXixZnmI9MTvrcANZHVncjRaJ4niJjD/X9QtVMkvm9O5CJf+KLa13rwD6qBEiCiAg65SA+93xSoqtUEDzHgcdz8oODusOqpuJ3zO/DNiHwq/UPe7XMctpZ3lY4Wy3hHFYzAhoqKCDz81L3Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904599; c=relaxed/simple;
	bh=3CU9IR/wqmn+r4g0I/Yi9QqfGZSvimBhJm9oXjezxaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igaoeLPBZaaKpYX414A8gEkACHR33wfgOLB5cGIEww0s4IagPIV185Z8bsNMV3AggQz/XKwlkIJz8W4IwDd/gghzhxXj79UqGmmUqcwjl62xq58k5DSke4prNwwZbAwiEHSKRiKS3NlJ0M4JCKLLpZmonnEv0ovjbW9MxZeqMds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I89JhsGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I89JhsGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4ADC2BCB8;
	Mon,  4 May 2026 14:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904599;
	bh=3CU9IR/wqmn+r4g0I/Yi9QqfGZSvimBhJm9oXjezxaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I89JhsGR3LfFSj2QIsU3U1myoRNi+E6SXbjiXLF09le+23CO21PusG5q4sy+5mZ/+
	 Md2p5e2aeW4DtyDFi9GD3vWBUNWEgEsdZO2U45Y11VMXnpN56L+k2WZfWNC3qplJIi
	 Wnpkh6g8TwwFZtIwF4olCg46Jqv/GhCoG6TvkuiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 069/215] block: fix zone write plugs refcount handling in disk_zone_wplug_schedule_bio_work()
Date: Mon,  4 May 2026 15:51:28 +0200
Message-ID: <20260504135132.690509430@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit 0a8b8af896e0ef83e188e1fe20f98f2bbb1c2459 upstream.

The function disk_zone_wplug_schedule_bio_work() always takes a
reference on the zone write plug of the BIO work being scheduled. This
ensures that the zone write plug cannot be freed while the BIO work is
being scheduled but has not run yet. However, this unconditional
reference taking is fragile since the reference taken is released by the
BIO work blk_zone_wplug_bio_work() function, which implies that there
always must be a 1:1 relation between the work being scheduled and the
work running.

Make sure to drop the reference taken when scheduling the BIO work if
the work is already scheduled, that is, when queue_work() returns false.

Fixes: 9e78c38ab30b ("block: Hold a reference on zone write plugs to schedule submission")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -811,13 +811,17 @@ static void disk_zone_wplug_schedule_bio
 					      struct blk_zone_wplug *zwplug)
 {
 	/*
-	 * Take a reference on the zone write plug and schedule the submission
-	 * of the next plugged BIO. blk_zone_wplug_bio_work() will release the
-	 * reference we take here.
+	 * Schedule the submission of the next plugged BIO. Taking a reference
+	 * to the zone write plug is required as the bio_work belongs to the
+	 * plug, and thus we must ensure that the write plug does not go away
+	 * while the work is being scheduled but has not run yet.
+	 * blk_zone_wplug_bio_work() will release the reference we take here,
+	 * and we also drop this reference if the work is already scheduled.
 	 */
 	WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));
 	refcount_inc(&zwplug->ref);
-	queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
+	if (!queue_work(disk->zone_wplugs_wq, &zwplug->bio_work))
+		disk_put_zone_wplug(zwplug);
 }
 
 static inline void disk_zone_wplug_add_bio(struct gendisk *disk,


