Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD14168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E09CC433D2;
	Mon,  8 May 2023 10:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543021;
	bh=OHs6TpBgypNBA9W8AcNr7xMM8GZpMB6ixPocoqwR4Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXui8revak7hpEcJlFcyrIWf4EuFrlEVBtLD48bnIeLcJy+OqO3oSB7PvIbli1slW
	 GgaQ6BbxYke7W3tdUiEQMNZdcWQFf8fyxXnKKTrCZ6ncnltEU0N1VtqvdcKCg0a0KX
	 kriDO2ly2ZgUWLn7YWtd04C4NEdvdvoC5vWvEY5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Logan Gunthorpe <logang@deltatee.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.2 623/663] md/raid5: Improve performance for sequential IO
Date: Mon,  8 May 2023 11:47:29 +0200
Message-Id: <20230508094450.004675692@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit fc05e06e6098ca2c28f7a10da0e00aeea20fa59e upstream.

Commit 7e55c60acfbb ("md/raid5: Pivot raid5_make_request()") changed the
order in which requests for underlying disks are created. Since for
large sequential IO adding of requests frequently races with md_raid5
thread submitting bios to underlying disks, this results in a change in
IO pattern because intermediate states of new order of request creation
result in more smaller discontiguous requests. For RAID5 on top of three
rotational disks our performance testing revealed this results in
regression in write throughput:

iozone -a -s 131072000 -y 4 -q 8 -i 0 -i 1 -R

before 7e55c60acfbb:
              KB  reclen   write rewrite    read    reread
       131072000       4  493670  525964   524575   513384
       131072000       8  540467  532880   512028   513703

after 7e55c60acfbb:
              KB  reclen   write rewrite    read    reread
       131072000       4  421785  456184   531278   509248
       131072000       8  459283  456354   528449   543834

To reduce the amount of discontiguous requests we can start generating
requests with the stripe with the lowest chunk offset as that has the
best chance of being adjacent to IO queued previously. This improves the
performance to:
              KB  reclen   write rewrite    read    reread
       131072000       4  497682  506317   518043   514559
       131072000       8  514048  501886   506453   504319

restoring big part of the regression.

Fixes: 7e55c60acfbb ("md/raid5: Pivot raid5_make_request()")
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230417171537.17899-1-jack@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6079,6 +6079,38 @@ out_release:
 	return ret;
 }
 
+/*
+ * If the bio covers multiple data disks, find sector within the bio that has
+ * the lowest chunk offset in the first chunk.
+ */
+static sector_t raid5_bio_lowest_chunk_sector(struct r5conf *conf,
+					      struct bio *bi)
+{
+	int sectors_per_chunk = conf->chunk_sectors;
+	int raid_disks = conf->raid_disks;
+	int dd_idx;
+	struct stripe_head sh;
+	unsigned int chunk_offset;
+	sector_t r_sector = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
+	sector_t sector;
+
+	/* We pass in fake stripe_head to get back parity disk numbers */
+	sector = raid5_compute_sector(conf, r_sector, 0, &dd_idx, &sh);
+	chunk_offset = sector_div(sector, sectors_per_chunk);
+	if (sectors_per_chunk - chunk_offset >= bio_sectors(bi))
+		return r_sector;
+	/*
+	 * Bio crosses to the next data disk. Check whether it's in the same
+	 * chunk.
+	 */
+	dd_idx++;
+	while (dd_idx == sh.pd_idx || dd_idx == sh.qd_idx)
+		dd_idx++;
+	if (dd_idx >= raid_disks)
+		return r_sector;
+	return r_sector + sectors_per_chunk - chunk_offset;
+}
+
 static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
@@ -6150,6 +6182,17 @@ static bool raid5_make_request(struct md
 	}
 	md_account_bio(mddev, &bi);
 
+	/*
+	 * Lets start with the stripe with the lowest chunk offset in the first
+	 * chunk. That has the best chances of creating IOs adjacent to
+	 * previous IOs in case of sequential IO and thus creates the most
+	 * sequential IO pattern. We don't bother with the optimization when
+	 * reshaping as the performance benefit is not worth the complexity.
+	 */
+	if (likely(conf->reshape_progress == MaxSector))
+		logical_sector = raid5_bio_lowest_chunk_sector(conf, bi);
+	s = (logical_sector - ctx.first_sector) >> RAID5_STRIPE_SHIFT(conf);
+
 	add_wait_queue(&conf->wait_for_overlap, &wait);
 	while (1) {
 		res = make_stripe_request(mddev, conf, &ctx, logical_sector,
@@ -6178,7 +6221,7 @@ static bool raid5_make_request(struct md
 			continue;
 		}
 
-		s = find_first_bit(ctx.sectors_to_do, stripe_cnt);
+		s = find_next_bit_wrap(ctx.sectors_to_do, stripe_cnt, s);
 		if (s == stripe_cnt)
 			break;
 


