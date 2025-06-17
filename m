Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F3C2FA62E;
	Tue, 17 Jun 2025 16:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179532; cv=none; b=RhYVJY87B0OMf486qu5nsHXjJbYAM4lMZy2Jvv1YCOmWzB0TfR5fdzOEg5nXKPuH2bSBC22l5DmbGPvMUboB8FkRb8qsicBjgqC+3T2JPGORoZMymgvCsx6r5dmhBgW/wD2584xl0GbBciOhK0PMCTfBCaFdRLWNLvzJQNghZJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179532; c=relaxed/simple;
	bh=BJc40qBk2rQrOJWXKxS6n4gRX8RxKiW1ciLYqErwHbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEFhFdF3fezKIUZcDcSB46hSsOfbxGLkO93Vs7GD/zryIgn7KQm2kTczARi7dH0Ss3tFn2OINwpihqPplJNEbzX3y3randgh/ypqRrJOW+Hx0W86Y/MYRGPjroKD886F5wTrPL2q6l6QzahgwGlw1aZpFLvzqU6QmLOen+9Dpjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajfU/v83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajfU/v83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C350C4CEE3;
	Tue, 17 Jun 2025 16:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179532;
	bh=BJc40qBk2rQrOJWXKxS6n4gRX8RxKiW1ciLYqErwHbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajfU/v83dyyHNAYoq9YmtDVH8LkFmt/VqDfkcpdfd4uzyB3KPpIKB2X1sOdU3Qexv
	 QFHGNzPEjsxvRbJAxTXCSEpTug35Yrib+CZmridykR1WLcj6QbveBPMmxNJ9kyvjux
	 F0X6jVCHuSaL51FopHqBBeGlINvH6iEGM6xgCG2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 734/780] block: dont use submit_bio_noacct_nocheck in blk_zone_wplug_bio_work
Date: Tue, 17 Jun 2025 17:27:22 +0200
Message-ID: <20250617152521.394761805@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit cf625013d8741c01407bbb4a60c111b61b9fa69d ]

Bios queued up in the zone write plug have already gone through all all
preparation in the submit_bio path, including the freeze protection.

Submitting them through submit_bio_noacct_nocheck duplicates the work
and can can cause deadlocks when freezing a queue with pending bio
write plugs.

Go straight to ->submit_bio or blk_mq_submit_bio to bypass the
superfluous extra freeze protection and checks.

Fixes: 9b1ce7f0c6f8 ("block: Implement zone append emulation")
Reported-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250611044416.2351850-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-zoned.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 8f15d1aa6eb89..45c91016cef38 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1306,7 +1306,6 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
 	spin_unlock_irqrestore(&zwplug->lock, flags);
 
 	bdev = bio->bi_bdev;
-	submit_bio_noacct_nocheck(bio);
 
 	/*
 	 * blk-mq devices will reuse the extra reference on the request queue
@@ -1314,8 +1313,12 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
 	 * path for BIO-based devices will not do that. So drop this extra
 	 * reference here.
 	 */
-	if (bdev_test_flag(bdev, BD_HAS_SUBMIT_BIO))
+	if (bdev_test_flag(bdev, BD_HAS_SUBMIT_BIO)) {
+		bdev->bd_disk->fops->submit_bio(bio);
 		blk_queue_exit(bdev->bd_disk->queue);
+	} else {
+		blk_mq_submit_bio(bio);
+	}
 
 put_zwplug:
 	/* Drop the reference we took in disk_zone_wplug_schedule_bio_work(). */
-- 
2.39.5



