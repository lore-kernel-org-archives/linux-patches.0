Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A147168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A505C43443;
	Mon,  8 May 2023 10:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542258;
	bh=l9olUmp6uJA8kixhd76fAVTX3Pv2HjX78Qg/R/e0kPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiUm4zPuF/4zChBfAxBX9fP8dPVINIddLGI6SdDdB64EQtwhhCMwTRqd4fbs+izIz
	 9LAZ99dyZeHit4dVe38UGUgfwhw9lrWhHuL+ViIDk8RpXp0dCZSLEVYnTXr2f2G/sv
	 p+j8xFTfOICM64hDaHv6rl+793DE1gEy2P2MbcKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 376/663] md/raid10: dont call bio_start_io_acct twice for bio which experienced read error
Date: Mon,  8 May 2023 11:43:22 +0200
Message-Id: <20230508094440.319351140@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 7cddb055bfda5f7b0be931e8ea750fc28bc18a27 ]

handle_read_error() will resumit r10_bio by raid10_read_request(), which
will call bio_start_io_acct() again, while bio_end_io_acct() will only
be called once.

Fix the problem by don't account io again from handle_read_error().

Fixes: 528bc2cf2fcc ("md/raid10: enable io accounting")
Suggested-by: Song Liu <song@kernel.org>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230314012258.2395894-1-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 20522af894e0d..0193cc7a6c8e1 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1248,7 +1248,8 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	}
 	slot = r10_bio->read_slot;
 
-	if (blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
+	if (!r10_bio->start_time &&
+	    blk_queue_io_stat(bio->bi_bdev->bd_disk->queue))
 		r10_bio->start_time = bio_start_io_acct(bio);
 	read_bio = bio_alloc_clone(rdev->bdev, bio, gfp, &mddev->bio_set);
 
@@ -1578,6 +1579,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	r10_bio->sector = bio->bi_iter.bi_sector;
 	r10_bio->state = 0;
 	r10_bio->read_slot = -1;
+	r10_bio->start_time = 0;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
 			conf->geo.raid_disks);
 
-- 
2.39.2



