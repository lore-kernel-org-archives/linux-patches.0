Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E4F264FA0;
	Tue,  8 Apr 2025 11:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110732; cv=none; b=IXDQmp/onReaQjUSOQ+EcRfe/1dMTA+jrG2u1Y041iRGwzkF2kK8C7nVWGq/ShC6grdRCHDBqaJG9oWnpA1lsqsbHApgyOdmuHzTT4R5rxy9WauUE7NC3vH9N7naTtlrADaK3iWQ0Rnzx4WEv/k/6iXPGhE47OIrL3hweM2JCRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110732; c=relaxed/simple;
	bh=E1z6aU+SWV1IuyPc/Z1seVMJCTN6dYgw7dqR6sWB1rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldhPGNzg9ShbN1n1xCnUN631mqtzt3Mrt+A9y9KziYrTq7TqBCCmOu4BXX6saMY2vURviIVjLXeg0xWVGx7yB7e5jZ1euQIJBFlF4o/KRmHB1Ypz1AhqQkcv4CkkrU2nZ07Bs3zPxylMXvkRgJ5MGyEggVIY/xIFxQXjkTTpblo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFXQRjf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFXQRjf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59DCC4CEE5;
	Tue,  8 Apr 2025 11:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110732;
	bh=E1z6aU+SWV1IuyPc/Z1seVMJCTN6dYgw7dqR6sWB1rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KFXQRjf4c2SLIMN2G3haB9nDfWRdB0+TdG7yAciXSKqOdGIaQ/3DjmXbc9VCH3P2w
	 eSgFLYv3U5kvvw+lgsHnT3fSlpwBMjYEOntQl7HyqMuZmigbZfcdlkG88vXG3CAiCX
	 oPYHeDOX5hNBjwbHGNoB+jNZQHerUDZJajnModCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 133/731] md/raid1,raid10: dont ignore IO flags
Date: Tue,  8 Apr 2025 12:40:30 +0200
Message-ID: <20250408104917.373372643@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit e879a0d9cb086c8e52ce6c04e5bfa63825a6213c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c  | 5 -----
 drivers/md/raid10.c | 8 --------
 2 files changed, 13 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cb108b3e28c4d..44dcfebff4f03 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1316,8 +1316,6 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	struct r1conf *conf = mddev->private;
 	struct raid1_info *mirror;
 	struct bio *read_bio;
-	const enum req_op op = bio_op(bio);
-	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	int max_sectors;
 	int rdisk, error;
 	bool r1bio_existed = !!r1_bio;
@@ -1405,7 +1403,6 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_iter.bi_sector = r1_bio->sector +
 		mirror->rdev->data_offset;
 	read_bio->bi_end_io = raid1_end_read_request;
-	read_bio->bi_opf = op | do_sync;
 	if (test_bit(FailFast, &mirror->rdev->flags) &&
 	    test_bit(R1BIO_FailFast, &r1_bio->state))
 	        read_bio->bi_opf |= MD_FAILFAST;
@@ -1654,8 +1651,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 		mbio->bi_iter.bi_sector	= (r1_bio->sector + rdev->data_offset);
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_opf = bio_op(bio) |
-			(bio->bi_opf & (REQ_SYNC | REQ_FUA | REQ_ATOMIC));
 		if (test_bit(FailFast, &rdev->flags) &&
 		    !test_bit(WriteMostly, &rdev->flags) &&
 		    conf->raid_disks - mddev->degraded > 1)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 15b9ae5bf84d8..c897b19dc2d53 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1146,8 +1146,6 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 {
 	struct r10conf *conf = mddev->private;
 	struct bio *read_bio;
-	const enum req_op op = bio_op(bio);
-	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
 	int max_sectors;
 	struct md_rdev *rdev;
 	char b[BDEVNAME_SIZE];
@@ -1228,7 +1226,6 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	read_bio->bi_iter.bi_sector = r10_bio->devs[slot].addr +
 		choose_data_offset(r10_bio, rdev);
 	read_bio->bi_end_io = raid10_end_read_request;
-	read_bio->bi_opf = op | do_sync;
 	if (test_bit(FailFast, &rdev->flags) &&
 	    test_bit(R10BIO_FailFast, &r10_bio->state))
 	        read_bio->bi_opf |= MD_FAILFAST;
@@ -1247,10 +1244,6 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 				  struct bio *bio, bool replacement,
 				  int n_copy)
 {
-	const enum req_op op = bio_op(bio);
-	const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
-	const blk_opf_t do_fua = bio->bi_opf & REQ_FUA;
-	const blk_opf_t do_atomic = bio->bi_opf & REQ_ATOMIC;
 	unsigned long flags;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev;
@@ -1269,7 +1262,6 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 	mbio->bi_iter.bi_sector	= (r10_bio->devs[n_copy].addr +
 				   choose_data_offset(r10_bio, rdev));
 	mbio->bi_end_io	= raid10_end_write_request;
-	mbio->bi_opf = op | do_sync | do_fua | do_atomic;
 	if (!replacement && test_bit(FailFast,
 				     &conf->mirrors[devnum].rdev->flags)
 			 && enough(conf, devnum))
-- 
2.39.5



