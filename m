Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62CE275844;
	Tue, 21 Oct 2025 20:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077024; cv=none; b=gcErnRmux3gqth1mVF0j5xcQh0hN5wxt8sRkdtTETNHUfxGV6tcp8q/GNug/ZTs+j9dQqddz/L31bwYXUbxwuApkq0nWlrSICOTvTsv8WThfS2laIhq3eab4MP/vYIk9Mp4h+VAITs6POh5R3H8H+2d/YInRYgl8BtW6RcVV2Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077024; c=relaxed/simple;
	bh=z1p7c6EG+AmPSSsApoRX/TRQkY2Awe/130fNyW042LM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGnofSh+NdvY2tomsQnOk9WE7G8ZL9lAsgHRlfD+eEjtDpPXSSGvz4ZzhtNdx29ofpK367AKSUVf6O2CZRqJ+QIpO1qqtEUAeSzNkLyXDWGoetHCe1+3mXrSIyoIbCHtelqyhgEOi9RBdi/EkYyIyLA+RSeT8NXJBtnRan/TUIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pngy4v6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pngy4v6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE0DC113D0;
	Tue, 21 Oct 2025 20:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077024;
	bh=z1p7c6EG+AmPSSsApoRX/TRQkY2Awe/130fNyW042LM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pngy4v6L94hT5iY7ValD90GPhqL6bm+H2Pm6V+KZIMTjeOO8p7prNiaOfQHOu8urW
	 ju2xSYNG6sxyBo9KYhjJsfzqJc+45aIGEitKMj82bLbB00RZrvHDSo5Pvg0vWzre3o
	 qT6+jn/G6nD0q14Z+MRDJ6KklSbwj82o17lKwJ34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/136] md/raid1: Handle bio_split() errors
Date: Tue, 21 Oct 2025 21:51:40 +0200
Message-ID: <20251021195038.660734822@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit b1a7ad8b5c4fa28325ee7b369a2d545d3e16ccde ]

Add proper bio_split() error handling. For any error, call
raid_end_bio_io() and return.

For the case of an in the write path, we need to undo the increment in
the rdev pending count and NULLify the r1_bio->bios[] pointers.

For read path failure, we need to undo rdev pending count increment from
the earlier read_balance() call.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241111112150.3756529-6-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 22f166218f73 ("md: fix mssing blktrace bio split events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid1.c |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1317,7 +1317,7 @@ static void raid1_read_request(struct md
 	struct raid1_info *mirror;
 	struct bio *read_bio;
 	int max_sectors;
-	int rdisk;
+	int rdisk, error;
 	bool r1bio_existed = !!r1_bio;
 
 	/*
@@ -1378,6 +1378,11 @@ static void raid1_read_request(struct md
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      gfp, &conf->bio_split);
+
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		submit_bio_noacct(bio);
 		bio = split;
@@ -1404,6 +1409,13 @@ static void raid1_read_request(struct md
 	read_bio->bi_private = r1_bio;
 	mddev_trace_remap(mddev, read_bio, r1_bio->sector);
 	submit_bio_noacct(read_bio);
+	return;
+
+err_handle:
+	atomic_dec(&mirror->rdev->nr_pending);
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R1BIO_Uptodate, &r1_bio->state);
+	raid_end_bio_io(r1_bio);
 }
 
 static void raid1_write_request(struct mddev *mddev, struct bio *bio,
@@ -1411,7 +1423,7 @@ static void raid1_write_request(struct m
 {
 	struct r1conf *conf = mddev->private;
 	struct r1bio *r1_bio;
-	int i, disks;
+	int i, disks, k, error;
 	unsigned long flags;
 	struct md_rdev *blocked_rdev;
 	int first_clone;
@@ -1557,6 +1569,11 @@ static void raid1_write_request(struct m
 	if (max_sectors < bio_sectors(bio)) {
 		struct bio *split = bio_split(bio, max_sectors,
 					      GFP_NOIO, &conf->bio_split);
+
+		if (IS_ERR(split)) {
+			error = PTR_ERR(split);
+			goto err_handle;
+		}
 		bio_chain(split, bio);
 		submit_bio_noacct(bio);
 		bio = split;
@@ -1640,6 +1657,18 @@ static void raid1_write_request(struct m
 
 	/* In case raid1d snuck in to freeze_array */
 	wake_up_barrier(conf);
+	return;
+err_handle:
+	for (k = 0; k < i; k++) {
+		if (r1_bio->bios[k]) {
+			rdev_dec_pending(conf->mirrors[k].rdev, mddev);
+			r1_bio->bios[k] = NULL;
+		}
+	}
+
+	bio->bi_status = errno_to_blk_status(error);
+	set_bit(R1BIO_Uptodate, &r1_bio->state);
+	raid_end_bio_io(r1_bio);
 }
 
 static bool raid1_make_request(struct mddev *mddev, struct bio *bio)


