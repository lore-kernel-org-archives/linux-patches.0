Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B711A0BFD;
	Sun,  7 Sep 2025 20:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277243; cv=none; b=q001C8GIF3e+Xbvw+6Uaib2msQVqZfR+g2LRyxiHyvioAmLOvz0orkarOT1MxOTXVY3JNpHg5nVJnJvqQAPvwV+Qf/Nr4pFilsvrCJKjUSLVJL5npS7JQrzIhr5VXj9GyrrHnRl6EXSRqgcXmjpzSX3EWqM80GD4aYJj4BWxLKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277243; c=relaxed/simple;
	bh=vM4XYjf7SxROcOm+ivn/fZhtKHbOl6+pGBXLIw8nINQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9NhYz9aXGnkPvtN5VlnYFEkvnHdqWeH0tCd+kbPXs3a8/d/EgRPxx4GEF48ijnyyJnPKztIZTqLTlEJjXfBglf0BeAXuEbWomK/l5q1cqNS2/NndDNUh8+7I0jsk9zcmvjDwr2yOB3GEuCDVxYYS4GgGRyqHJbQl0pl2XVIy2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEEHX70v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEEHX70v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E88C4CEF0;
	Sun,  7 Sep 2025 20:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277242;
	bh=vM4XYjf7SxROcOm+ivn/fZhtKHbOl6+pGBXLIw8nINQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEEHX70vsyrl8mGjggne/2Ezatkc4YnSJ45vfgNdvjyiIKXSZNNbXzhhHSC8ST3I0
	 sok37hcgdZ9cEJgD4jvJzFv0PTHVvcdSPxFrNoklnAE1LrIdMFhlVA/g0eLMYyZv2a
	 dq3++XtP4ScZYB2yMK4RajOQf+4iMb7KPwx9rOrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 128/175] md/raid1,raid10: dont ignore IO flags
Date: Sun,  7 Sep 2025 21:58:43 +0200
Message-ID: <20250907195617.880836844@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit e879a0d9cb086c8e52ce6c04e5bfa63825a6213c upstream.

If blk-wbt is enabled by default, it's found that raid write performance
is quite bad because all IO are throttled by wbt of underlying disks,
due to flag REQ_IDLE is ignored. And turns out this behaviour exist since
blk-wbt is introduced.

Other than REQ_IDLE, other flags should not be ignored as well, for
example REQ_META can be set for filesystems, clearing it can cause priority
reverse problems; And REQ_NOWAIT should not be cleared as well, because
io will wait instead of failing directly in underlying disks.

Fix those problems by keep IO flags from master bio.

Fises: f51d46d0e7cb ("md: add support for REQ_NOWAIT")
Fixes: e34cbd307477 ("blk-wbt: add general throttling mechanism")
Fixes: 5404bc7a87b9 ("[PATCH] Allow file systems to differentiate between data and meta reads")
Link: https://lore.kernel.org/linux-raid/20250227121657.832356-1-yukuai1@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
[ Harshit: Resolve conflicts due to missing commit: f2a38abf5f1c
  ("md/raid1: Atomic write support") and  commit: a1d9b4fd42d9
  ("md/raid10: Atomic write support") in 6.12.y, we don't have Atomic
  writes feature in 6.12.y ]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid1.c  |    4 ----
 drivers/md/raid10.c |    7 -------
 2 files changed, 11 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1315,8 +1315,6 @@ static void raid1_read_request(struct md
 	struct r1conf *conf = mddev->private;
 	struct raid1_info *mirror;
 	struct bio *read_bio;
-	const enum req_op op = bio_op(bio);
-	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	int max_sectors;
 	int rdisk;
 	bool r1bio_existed = !!r1_bio;
@@ -1399,7 +1397,6 @@ static void raid1_read_request(struct md
 	read_bio->bi_iter.bi_sector = r1_bio->sector +
 		mirror->rdev->data_offset;
 	read_bio->bi_end_io = raid1_end_read_request;
-	read_bio->bi_opf = op | do_sync;
 	if (test_bit(FailFast, &mirror->rdev->flags) &&
 	    test_bit(R1BIO_FailFast, &r1_bio->state))
 	        read_bio->bi_opf |= MD_FAILFAST;
@@ -1619,7 +1616,6 @@ static void raid1_write_request(struct m
 
 		mbio->bi_iter.bi_sector	= (r1_bio->sector + rdev->data_offset);
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_opf = bio_op(bio) | (bio->bi_opf & (REQ_SYNC | REQ_FUA));
 		if (test_bit(FailFast, &rdev->flags) &&
 		    !test_bit(WriteMostly, &rdev->flags) &&
 		    conf->raid_disks - mddev->degraded > 1)
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1146,8 +1146,6 @@ static void raid10_read_request(struct m
 {
 	struct r10conf *conf = mddev->private;
 	struct bio *read_bio;
-	const enum req_op op = bio_op(bio);
-	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	int max_sectors;
 	struct md_rdev *rdev;
 	char b[BDEVNAME_SIZE];
@@ -1226,7 +1224,6 @@ static void raid10_read_request(struct m
 	read_bio->bi_iter.bi_sector = r10_bio->devs[slot].addr +
 		choose_data_offset(r10_bio, rdev);
 	read_bio->bi_end_io = raid10_end_read_request;
-	read_bio->bi_opf = op | do_sync;
 	if (test_bit(FailFast, &rdev->flags) &&
 	    test_bit(R10BIO_FailFast, &r10_bio->state))
 	        read_bio->bi_opf |= MD_FAILFAST;
@@ -1240,9 +1237,6 @@ static void raid10_write_one_disk(struct
 				  struct bio *bio, bool replacement,
 				  int n_copy)
 {
-	const enum req_op op = bio_op(bio);
-	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
-	const blk_opf_t do_fua = bio->bi_opf & REQ_FUA;
 	unsigned long flags;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev;
@@ -1261,7 +1255,6 @@ static void raid10_write_one_disk(struct
 	mbio->bi_iter.bi_sector	= (r10_bio->devs[n_copy].addr +
 				   choose_data_offset(r10_bio, rdev));
 	mbio->bi_end_io	= raid10_end_write_request;
-	mbio->bi_opf = op | do_sync | do_fua;
 	if (!replacement && test_bit(FailFast,
 				     &conf->mirrors[devnum].rdev->flags)
 			 && enough(conf, devnum))


