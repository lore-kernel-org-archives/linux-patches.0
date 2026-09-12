Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF5F3644CA;
	Sat, 12 Sep 2026 08:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200449; cv=none; b=cfGW8XI2AwMJoJ8GfKkHxok/vuQNgUDQ5QffCL235BFLabVN7+JFBH459FaxN6tQ5RhFDJ3w9kbzLdyrONphYs/GE4XdpwcdqzdTw2wPz7in2WCnSwQA8A3CbQoSRD6gwQjNBWiMRF7cNpk5EjsKeqg7sTxreo7nNPANkIi6qHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200449; c=relaxed/simple;
	bh=Zu0BxiCgV5lxxJTO+5OgzvN27z+Cv1rNMnofEq3PM+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSg4AWzdYk4mVzA6RCf6v67mWwBtKMdVHlsBlCsF3pwNgSZfIOWMtyJwYCL9TgS7eXV4XRBd/+9bPGoBcVqDOrOvLoejNkc2TgdutoWAPOyssTnrJ4+nwu9KHmLa/szui+Sm05uj7YoSNPMOFysnWOHBe4e2Nk+svysEiYLYd0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXq/4NYU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXq/4NYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E1D1F000FF;
	Sat, 12 Sep 2026 08:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200448;
	bh=lp1F33x4KZdPpmf6ZO2E5EEBi5wBYVxDDc+hJQiJqLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXq/4NYUrhRxHQQ580gDqXBwit6EPAh09V05FbJdJUSDHH+FDiRxxzzmKsHei+lMe
	 CLPk0ViKlzSE5sOjkClH/jwMbgqFNQwbu0aC5XQlxc8xAJ2LzjlgoxziSvOISZG2ap
	 6uTgDIkHwFwZO0tpJ8FNVdj0HTNlEySDwq4Gr9C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0775/1815] md/raid1: restrict atomic write limits and handle runtime constraints
Date: Sat, 12 Sep 2026 08:42:05 +0200
Message-ID: <20260912065707.103297443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit 86d801e895b853667a886918998e1628fcc3174e ]

Restrict the RAID1 atomic write limits by setting chunk_sectors to
BARRIER_UNIT_SECTOR_SIZE so that atomic writes never straddle a barrier
unit.

A bio that passes block-layer validation may still become unserviceable
within RAID1 due to bad blocks or write-behind constraints. In the former
case, complete the bio with EIO. In the latter case, disable
write-behind rather than failing the bio with EIO.

Fixes: f2a38abf5f1c ("md/raid1: Atomic write support")
Fixes: a4c55c902670 ("md/raid1: simplify raid1_write_request() error handling")
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260710101521.1714-3-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4abbd7f234d96..326c0b7b7188a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1483,6 +1483,7 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	unsigned long flags;
 	int first_clone;
 	bool write_behind = false;
+	bool atomic = bio->bi_opf & REQ_ATOMIC;
 	bool is_discard = op_is_discard(bio->bi_opf);
 	sector_t sector = bio->bi_iter.bi_sector;
 
@@ -1529,6 +1530,8 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 		 */
 		if (!is_discard && rdev && test_bit(WriteMostly, &rdev->flags))
 			write_behind = true;
+		if (atomic && max_sectors > BIO_MAX_VECS * (PAGE_SIZE >> 9))
+			write_behind = false;
 
 		r1_bio->bios[i] = NULL;
 		if (!rdev || test_bit(Faulty, &rdev->flags))
@@ -1554,19 +1557,6 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 			if (is_bad) {
 				int good_sectors;
 
-				/*
-				 * We cannot atomically write this, so just
-				 * error in that case. It could be possible to
-				 * atomically write other mirrors, but the
-				 * complexity of supporting that is not worth
-				 * the benefit.
-				 */
-				if (bio->bi_opf & REQ_ATOMIC) {
-					bio->bi_status = BLK_STS_NOTSUPP;
-					bio_endio(bio);
-					goto err_dec_pending;
-				}
-
 				good_sectors = first_bad - sector;
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
@@ -1587,6 +1577,11 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 		max_sectors = min_t(int, max_sectors,
 				    BIO_MAX_VECS * (PAGE_SIZE >> 9));
 	if (max_sectors < bio_sectors(bio)) {
+		if (atomic) {
+			bio_io_error(bio);
+			goto err_dec_pending;
+		}
+
 		bio = bio_submit_split_bioset(bio, max_sectors,
 					      &conf->bio_split);
 		if (!bio)
@@ -3175,6 +3170,7 @@ static int raid1_set_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.max_hw_wzeroes_unmap_sectors = 0;
+	lim.chunk_sectors = BARRIER_UNIT_SECTOR_SIZE;
 	lim.logical_block_size = mddev->logical_block_size;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	lim.features |= BLK_FEAT_PCI_P2PDMA;
-- 
2.53.0



