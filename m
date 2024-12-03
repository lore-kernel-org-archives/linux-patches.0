Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266591EF0BA;
	Tue,  3 Dec 2024 14:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237813; cv=none; b=s/Xub4XLo49CU1SxF/Gt1VPiY9/X7u63CljjMvXO9V+eCgv1YlypYWRHyTIIWlimAM339cYnlwYFcmty7pjc2I2ddeTv1jIiqIKTSKCyYbkfXmEKfLcz+35TFPknyyyToHOsn0i0BxnsbgsoNQbyMEld3nqFddyX9TVX7TYeXlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237813; c=relaxed/simple;
	bh=8J7i/ztQx4RFjDdebJh/g7Ma6yMVCbFqQGt8EJfYQik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRBqkt4S5mk2vFIVsScEUvKstwJCnlgiM2pRt8Fk0wdirxWaILB0IdlFgERrtLVYlR/OTWqItK+48E6J0tLawSKN/1fsgmqE3sMPQ2kwejIXt8sOH9RQSLGSTuXiSD7WMcboeflWAm6vSYHzCOYJHB6LY9AuL2MN26P905uwKvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sc2El0L/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sc2El0L/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467A3C4CED6;
	Tue,  3 Dec 2024 14:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237813;
	bh=8J7i/ztQx4RFjDdebJh/g7Ma6yMVCbFqQGt8EJfYQik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sc2El0L/PPdsnr/6NYvlBAOcdqeTwCFiA5LePnVx6mZwv7aT4NzTrPMhDKHN62lpf
	 BA10vQJpFv8HH27aEpr9Ig2Vy9rEt5Va6Ohvl4y4L8eIiuiVqzHecJLuyIhuMu1YCo
	 7Cvq8LJTUTX3Vd1EIRjuwT0GS7wk0z+s9+u6vu9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 078/817] block: properly handle REQ_OP_ZONE_APPEND in __bio_split_to_limits
Date: Tue,  3 Dec 2024 15:34:10 +0100
Message-ID: <20241203143958.736516755@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1e8a7f6af926e266cc1d7ac49b56bd064057d625 ]

Currently REQ_OP_ZONE_APPEND is handled by the bio_split_rw case in
__bio_split_to_limits.  This is harmful because REQ_OP_ZONE_APPEND
bios do not adhere to the soft max_limits value but instead use their
own capped version of max_hw_sectors, leading to incorrect splits that
later blow up in bio_split.

We still need the bio_split_rw logic to count nr_segs for blk-mq code,
so add a new wrapper that passes in the right limit, and turns any bio
that would need a split into an error as an additional debugging aid.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Link: https://lore.kernel.org/r/20240826173820.1690925-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 60dc5ea6bcfd ("block: take chunk_sectors into account in bio_split_write_zeroes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 20 ++++++++++++++++++++
 block/blk.h       |  4 ++++
 2 files changed, 24 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index c7222c4685e06..56769c4bcd799 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -378,6 +378,26 @@ struct bio *bio_split_rw(struct bio *bio, const struct queue_limits *lim,
 			get_max_io_size(bio, lim) << SECTOR_SHIFT));
 }
 
+/*
+ * REQ_OP_ZONE_APPEND bios must never be split by the block layer.
+ *
+ * But we want the nr_segs calculation provided by bio_split_rw_at, and having
+ * a good sanity check that the submitter built the bio correctly is nice to
+ * have as well.
+ */
+struct bio *bio_split_zone_append(struct bio *bio,
+		const struct queue_limits *lim, unsigned *nr_segs)
+{
+	unsigned int max_sectors = queue_limits_max_zone_append_sectors(lim);
+	int split_sectors;
+
+	split_sectors = bio_split_rw_at(bio, lim, nr_segs,
+			max_sectors << SECTOR_SHIFT);
+	if (WARN_ON_ONCE(split_sectors > 0))
+		split_sectors = -EINVAL;
+	return bio_submit_split(bio, split_sectors);
+}
+
 /**
  * bio_split_to_limits - split a bio to fit the queue limits
  * @bio:     bio to be split
diff --git a/block/blk.h b/block/blk.h
index 0d8cd64c12606..61c2afa67daab 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -337,6 +337,8 @@ struct bio *bio_split_write_zeroes(struct bio *bio,
 		const struct queue_limits *lim, unsigned *nsegs);
 struct bio *bio_split_rw(struct bio *bio, const struct queue_limits *lim,
 		unsigned *nr_segs);
+struct bio *bio_split_zone_append(struct bio *bio,
+		const struct queue_limits *lim, unsigned *nr_segs);
 
 /*
  * All drivers must accept single-segments bios that are smaller than PAGE_SIZE.
@@ -375,6 +377,8 @@ static inline struct bio *__bio_split_to_limits(struct bio *bio,
 			return bio_split_rw(bio, lim, nr_segs);
 		*nr_segs = 1;
 		return bio;
+	case REQ_OP_ZONE_APPEND:
+		return bio_split_zone_append(bio, lim, nr_segs);
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
 		return bio_split_discard(bio, lim, nr_segs);
-- 
2.43.0



