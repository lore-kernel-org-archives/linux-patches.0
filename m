Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0531D3D47B0;
	Fri, 24 Apr 2026 13:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037940; cv=none; b=fHpHXvpwALOe2fz1x6INqBBuGZH0xqxWAA7IvFEgrfUwugqK1IxF7QI3p8tZ6m1hnsJ/qD/RKBxR/Wlf3qGUnFJoA7M/ulgpPQikASfvhjb0lA8HGg94m927H9K6Eu/MiP33CdIOmiOdYj074NYqROMuS1weCL6wG3lQ0GDLAeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037940; c=relaxed/simple;
	bh=gl8ium2TS9En5dmXUvAAiNRUeAMv3DN/bF5djcZcZEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEeHyMaeQBmhlhEMiLQwMzh3cmXw+uB0LjglrSg7ZcFi2BSM+P3T/eJB5uLBYzMCqnmDMQ4XSq/8fp1E045CdUfZBMtur0ekziqAfukcxMYYO7aEYcJ2NBGHaI2JvXEeH37/6kZVfiaEiX4Kh+SakMpckXMwIeWWZNm4TCKDuyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arwYmMJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arwYmMJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9D4C2BCB2;
	Fri, 24 Apr 2026 13:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037939;
	bh=gl8ium2TS9En5dmXUvAAiNRUeAMv3DN/bF5djcZcZEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arwYmMJPr6RjNp8iSabnMhEPx3Y8+67+LPmPbHPHeDN2Rz0ceI5Hsg4rh893qw1VD
	 HOBZYIgEx66786C43AmmOC8jWs8ixK/1MBQz+2VpElScvFD91upHcj56aZwTVY974e
	 OrppI+BT3QstylDSxP6jZCrT7Z3CpJwu4fYPhapE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Charles Xu <charles_xu@189.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/166] md/raid1,raid10: dont ignore IO flags
Date: Fri, 24 Apr 2026 15:30:43 +0200
Message-ID: <20260424132559.926975788@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ Based on Harshit's backport for 6.12, fixed minor conflicts for 6.6. ]
Signed-off-by: Charles Xu <charles_xu@189.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c  | 4 ----
 drivers/md/raid10.c | 7 -------
 2 files changed, 11 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4c1f86ca55208..d313e9834d447 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1214,8 +1214,6 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	struct raid1_info *mirror;
 	struct bio *read_bio;
 	struct bitmap *bitmap = mddev->bitmap;
-	const enum req_op op = bio_op(bio);
-	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	int max_sectors;
 	int rdisk;
 	bool r1bio_existed = !!r1_bio;
@@ -1315,7 +1313,6 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_iter.bi_sector = r1_bio->sector +
 		mirror->rdev->data_offset;
 	read_bio->bi_end_io = raid1_end_read_request;
-	read_bio->bi_opf = op | do_sync;
 	if (test_bit(FailFast, &mirror->rdev->flags) &&
 	    test_bit(R1BIO_FailFast, &r1_bio->state))
 	        read_bio->bi_opf |= MD_FAILFAST;
@@ -1537,7 +1534,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 		mbio->bi_iter.bi_sector	= (r1_bio->sector + rdev->data_offset);
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_opf = bio_op(bio) | (bio->bi_opf & (REQ_SYNC | REQ_FUA));
 		if (test_bit(FailFast, &rdev->flags) &&
 		    !test_bit(WriteMostly, &rdev->flags) &&
 		    conf->raid_disks - mddev->degraded > 1)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8546ef98bfa7e..6bcf6852c2000 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1168,8 +1168,6 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 {
 	struct r10conf *conf = mddev->private;
 	struct bio *read_bio;
-	const enum req_op op = bio_op(bio);
-	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	int max_sectors;
 	struct md_rdev *rdev;
 	char b[BDEVNAME_SIZE];
@@ -1250,7 +1248,6 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_iter.bi_sector = r10_bio->devs[slot].addr +
 		choose_data_offset(r10_bio, rdev);
 	read_bio->bi_end_io = raid10_end_read_request;
-	read_bio->bi_opf = op | do_sync;
 	if (test_bit(FailFast, &rdev->flags) &&
 	    test_bit(R10BIO_FailFast, &r10_bio->state))
 	        read_bio->bi_opf |= MD_FAILFAST;
@@ -1267,9 +1264,6 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 				  struct bio *bio, bool replacement,
 				  int n_copy)
 {
-	const enum req_op op = bio_op(bio);
-	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
-	const blk_opf_t do_fua = bio->bi_opf & REQ_FUA;
 	unsigned long flags;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev;
@@ -1295,7 +1289,6 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	mbio->bi_iter.bi_sector	= (r10_bio->devs[n_copy].addr +
 				   choose_data_offset(r10_bio, rdev));
 	mbio->bi_end_io	= raid10_end_write_request;
-	mbio->bi_opf = op | do_sync | do_fua;
 	if (!replacement && test_bit(FailFast,
 				     &conf->mirrors[devnum].rdev->flags)
 			 && enough(conf, devnum))
-- 
2.53.0



