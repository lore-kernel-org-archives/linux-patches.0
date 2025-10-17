Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3CF32E121;
	Fri, 17 Oct 2025 15:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715594; cv=none; b=eNitwwTnFEUMO7vCsSxL5YPAFaLm+OhgCj2Wa85n1zFtq9KASygGY1GAXYuRo50c2/PVBao0kOz8YdqBUnKxOjwV7+B8hLdqrUmnan1vSLayfV/p0c5Imyut4XpWgOBHMEIFlpyCR0HI+GIRigl4hZB8fp53LB9LduqzyFXAz3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715594; c=relaxed/simple;
	bh=Z+XVH7nwV9t6LbK6NNN7NP77TSWytvjHlI/U+0v2EkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpQ8Hka/e1fnDpk9gpXvBHkNU0ylumkMd64Izej1ulOzfo63QxzK2gLE5a1ptikcFceEbrg2ezrLUHqte5B/5A5oaWWBAfPCJP3/z3a0ohCok85jt+/ROIlnAtPMMvsplAodifC70z02rFm5hIqpH8cYB2R7yMiTKLg8tuzJ9Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCbszPDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCbszPDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB4CC4CEE7;
	Fri, 17 Oct 2025 15:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715593;
	bh=Z+XVH7nwV9t6LbK6NNN7NP77TSWytvjHlI/U+0v2EkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCbszPDvGmyaewWHud60fA7/eYNNtc4z+WMnHy43bFn01uD945cbIUcpED2lmYxla
	 lUtD9zH3Pmkd4i5oF23lQLrYqPpYfEB3TRLa4KNHx0nLACdKtN2LE7QkdYHnS0JvF1
	 an8iCBmBW9rcg2R6DE83ys3/rce3uRJjXhubgp3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.17 237/371] md: fix mssing blktrace bio split events
Date: Fri, 17 Oct 2025 16:53:32 +0200
Message-ID: <20251017145210.656287839@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 22f166218f7313e8fe2d19213b5f4b3265f8c39e upstream.

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
@@ -473,7 +473,9 @@ static void raid0_handle_discard(struct
 			bio_endio(bio);
 			return;
 		}
+
 		bio_chain(split, bio);
+		trace_block_split(split, bio->bi_iter.bi_sector);
 		submit_bio_noacct(bio);
 		bio = split;
 		end = zone->zone_end;
@@ -621,7 +623,9 @@ static bool raid0_make_request(struct md
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
@@ -1591,7 +1593,9 @@ static void raid1_write_request(struct m
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
@@ -1209,7 +1209,9 @@ static void raid10_read_request(struct m
 			error = PTR_ERR(split);
 			goto err_handle;
 		}
+
 		bio_chain(split, bio);
+		trace_block_split(split, bio->bi_iter.bi_sector);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
 		wait_barrier(conf, false);
@@ -1495,7 +1497,9 @@ static void raid10_write_request(struct
 			error = PTR_ERR(split);
 			goto err_handle;
 		}
+
 		bio_chain(split, bio);
+		trace_block_split(split, bio->bi_iter.bi_sector);
 		allow_barrier(conf);
 		submit_bio_noacct(bio);
 		wait_barrier(conf, false);
@@ -1679,7 +1683,9 @@ static int raid10_handle_discard(struct
 			bio_endio(bio);
 			return 0;
 		}
+
 		bio_chain(split, bio);
+		trace_block_split(split, bio->bi_iter.bi_sector);
 		allow_barrier(conf);
 		/* Resend the fist split part */
 		submit_bio_noacct(split);
@@ -1694,7 +1700,9 @@ static int raid10_handle_discard(struct
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
@@ -5475,8 +5475,10 @@ static struct bio *chunk_aligned_read(st
 
 	if (sectors < bio_sectors(raid_bio)) {
 		struct r5conf *conf = mddev->private;
+
 		split = bio_split(raid_bio, sectors, GFP_NOIO, &conf->bio_split);
 		bio_chain(split, raid_bio);
+		trace_block_split(split, raid_bio->bi_iter.bi_sector);
 		submit_bio_noacct(raid_bio);
 		raid_bio = split;
 	}


