Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7456723D7E8;
	Tue, 21 Oct 2025 20:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077032; cv=none; b=MhNkp3VFrx2InPHE/ti3JntFJjZuKSZr1ddU1KG0jW/V1wL+u63NbmCEriaJRn6B5FIffMuY5GKXLKl/MNsYFEMpPP8MFI/WdcyTJnADdkqH+aWm3hZ0LesbVnLP4XBdMwPMcCVgBAWd00vNDsYAyhc/H7VeMQF5Erly0CIxjNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077032; c=relaxed/simple;
	bh=YS8NlBT3aU0zi4H8ycTjqtWWawmOnw/GbEqlHYO9PJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YC9w2CftihZM4lwsi3hRRUrsEIB9KrpabVu2tfwZZi1edK/284pVZubsgOXU6dwr7g+ZXwGKhOlEggxSu8RRnhS0Qr/K0TOBo+N41LEWi670voSsT1L78ejjKQ0Y/PpEjL+dBqNYTB7pgyn80axcCwaVX5PzvDUbrfpW1oVS6lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzrmSj9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzrmSj9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FA7C4CEF5;
	Tue, 21 Oct 2025 20:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077030;
	bh=YS8NlBT3aU0zi4H8ycTjqtWWawmOnw/GbEqlHYO9PJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzrmSj9OasZrxnNj1BVulxg+UFg2sliYEUIO1MucPjPsoYWcqPHbj+eNBUF77EbmH
	 xu9cLkVKuS68Ajq3l2ZuOWBgskrlUtwBCg8NTm2EbfMiI4q4Hbto0UmHAO6DlBAUr0
	 oPuXJnLWomt8I1L9cuyh4Yzq/NSGVHrredt3uehk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/136] md: fix mssing blktrace bio split events
Date: Tue, 21 Oct 2025 21:51:42 +0200
Message-ID: <20251021195038.709345986@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 22f166218f7313e8fe2d19213b5f4b3265f8c39e ]

If bio is split by internal handling like chunksize or badblocks, the
corresponding trace_block_split() is missing, resulting in blktrace
inability to catch BIO split events and making it harder to analyze the
BIO sequence.

Cc: stable@vger.kernel.org
Fixes: 4b1faf931650 ("block: Kill bio_pair_split()")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md-linear.c |    1 +
 drivers/md/raid0.c     |    4 ++++
 drivers/md/raid1.c     |    4 ++++
 drivers/md/raid10.c    |    8 ++++++++
 drivers/md/raid5.c     |    2 ++
 5 files changed, 19 insertions(+)

--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -267,6 +267,7 @@ static bool linear_make_request(struct m
 		}
 
 		bio_chain(split, bio);
+		trace_block_split(split, bio->bi_iter.bi_sector);
 		submit_bio_noacct(bio);
 		bio = split;
 	}
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -470,7 +470,9 @@ static void raid0_handle_discard(struct
 			bio_endio(bio);
 			return;
 		}
+
 		bio_chain(split, bio);
+		trace_block_split(split, bio->bi_iter.bi_sector);
 		submit_bio_noacct(bio);
 		bio = split;
 		end = zone->zone_end;
@@ -618,7 +620,9 @@ static bool raid0_make_request(struct md
 			bio_endio(bio);
 			return true;
 		}
+
 		bio_chain(split, bio);
+		trace_block_split(split, bio->bi_iter.bi_sector);
 		raid0_map_submit_bio(mddev, bio);
 		bio = split;
 	}
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1383,7 +1383,9 @@ static void raid1_read_request(struct md
 			error = PTR_ERR(split);
 			goto err_handle;
 		}
+
 		bio_chain(split, bio);
+		trace_block_split(split, bio->bi_iter.bi_sector);
 		submit_bio_noacct(bio);
 		bio = split;
 		r1_bio->master_bio = bio;
@@ -1574,7 +1576,9 @@ static void raid1_write_request(struct m
 			error = PTR_ERR(split);
 			goto err_handle;
 		}
+
 		bio_chain(split, bio);
+		trace_block_split(split, bio->bi_iter.bi_sector);
 		submit_bio_noacct(bio);
 		bio = split;
 		r1_bio->master_bio = bio;
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1208,7 +1208,9 @@ static void raid10_read_request(struct m
 			error = PTR_ERR(split);
 			goto err_handle;
 		}
+
 		bio_chain(split, bio);
+		trace_block_split(split, bio->bi_iter.bi_sector);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
 		wait_barrier(conf, false);
@@ -1484,7 +1486,9 @@ static void raid10_write_request(struct
 			error = PTR_ERR(split);
 			goto err_handle;
 		}
+
 		bio_chain(split, bio);
+		trace_block_split(split, bio->bi_iter.bi_sector);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
 		wait_barrier(conf, false);
@@ -1669,7 +1673,9 @@ static int raid10_handle_discard(struct
 			bio_endio(bio);
 			return 0;
 		}
+
 		bio_chain(split, bio);
+		trace_block_split(split, bio->bi_iter.bi_sector);
 		allow_barrier(conf);
 		/* Resend the fist split part */
 		submit_bio_noacct(split);
@@ -1684,7 +1690,9 @@ static int raid10_handle_discard(struct
 			bio_endio(bio);
 			return 0;
 		}
+
 		bio_chain(split, bio);
+		trace_block_split(split, bio->bi_iter.bi_sector);
 		allow_barrier(conf);
 		/* Resend the second split part */
 		submit_bio_noacct(bio);
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5484,8 +5484,10 @@ static struct bio *chunk_aligned_read(st
 
 	if (sectors < bio_sectors(raid_bio)) {
 		struct r5conf *conf = mddev->private;
+
 		split = bio_split(raid_bio, sectors, GFP_NOIO, &conf->bio_split);
 		bio_chain(split, raid_bio);
+		trace_block_split(split, raid_bio->bi_iter.bi_sector);
 		submit_bio_noacct(raid_bio);
 		raid_bio = split;
 	}


