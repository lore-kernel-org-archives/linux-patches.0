Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9987C1DE2A1;
	Tue,  3 Dec 2024 14:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237816; cv=none; b=iuRJ35mipU33pTGhAoIOD8Mp38kJDtfUUj+aYQJLTBBrwIRbxlAVgeN1EsDP7j9KAz7geWYhqPPxnDTAyQFlief1U41TxYF1QKxQoER1d7n6Dj56qM0tbTQuJHKSExhV4DYCL0WH4wB4afN/2kfcc+F0FYkymHDIT1Olfww0YNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237816; c=relaxed/simple;
	bh=ulmd01BArfBoGL9/BxU3kq306op1wfNnqX2Jg/6h+rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=on0UuTyJnzEoD2LbyV5U3YkhDfC0EXzBgQSD99lF1/J2f2xMEXZRJJCuthJ20jCZyVvEIO83wIOF/N8jjBbpx/ZX5hAAQXt5xNb58qrIc4+SHHkvjHEkEU6xa+9l+dEqdfEr+GdlRuS5lvZ1TM77dDf17M/te0rijcB7Z8T+Aa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zN8WyJaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zN8WyJaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADE0C4CECF;
	Tue,  3 Dec 2024 14:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237816;
	bh=ulmd01BArfBoGL9/BxU3kq306op1wfNnqX2Jg/6h+rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zN8WyJafoecC3IlzFPXpofAEQM2LN8Byb1ZuFDmzRsX/QMUpALT+FgwCZJrOixfpx
	 rFEJNbR6VM1cMadE9wAsYbWgBstmE/lydcENaz++9NPlLBFBbzCRi3RSwPGp183KbP
	 n5fsNstIqltg6fmBIxveS/cKxB32GB47bqg/EA44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 079/817] block: take chunk_sectors into account in bio_split_write_zeroes
Date: Tue,  3 Dec 2024 15:34:11 +0100
Message-ID: <20241203143958.780819848@linuxfoundation.org>
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

[ Upstream commit 60dc5ea6bcfd078b71419640d49afa649acf9450 ]

For zoned devices, write zeroes must be split at the zone boundary
which is represented as chunk_sectors.  For other uses like the
internally RAIDed NVMe devices it is probably at least useful.

Enhance get_max_io_size to know about write zeroes and use it in
bio_split_write_zeroes.  Also add a comment about the seemingly
nonsensical zero max_write_zeroes limit.

Fixes: 885fa13f6559 ("block: implement splitting of REQ_OP_WRITE_ZEROES bios")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20241104062647.91160-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 56769c4bcd799..f2b5f63e118bd 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -166,17 +166,6 @@ struct bio *bio_split_discard(struct bio *bio, const struct queue_limits *lim,
 	return bio_submit_split(bio, split_sectors);
 }
 
-struct bio *bio_split_write_zeroes(struct bio *bio,
-		const struct queue_limits *lim, unsigned *nsegs)
-{
-	*nsegs = 0;
-	if (!lim->max_write_zeroes_sectors)
-		return bio;
-	if (bio_sectors(bio) <= lim->max_write_zeroes_sectors)
-		return bio;
-	return bio_submit_split(bio, lim->max_write_zeroes_sectors);
-}
-
 static inline unsigned int blk_boundary_sectors(const struct queue_limits *lim,
 						bool is_atomic)
 {
@@ -211,7 +200,9 @@ static inline unsigned get_max_io_size(struct bio *bio,
 	 * We ignore lim->max_sectors for atomic writes because it may less
 	 * than the actual bio size, which we cannot tolerate.
 	 */
-	if (is_atomic)
+	if (bio_op(bio) == REQ_OP_WRITE_ZEROES)
+		max_sectors = lim->max_write_zeroes_sectors;
+	else if (is_atomic)
 		max_sectors = lim->atomic_write_max_sectors;
 	else
 		max_sectors = lim->max_sectors;
@@ -398,6 +389,26 @@ struct bio *bio_split_zone_append(struct bio *bio,
 	return bio_submit_split(bio, split_sectors);
 }
 
+struct bio *bio_split_write_zeroes(struct bio *bio,
+		const struct queue_limits *lim, unsigned *nsegs)
+{
+	unsigned int max_sectors = get_max_io_size(bio, lim);
+
+	*nsegs = 0;
+
+	/*
+	 * An unset limit should normally not happen, as bio submission is keyed
+	 * off having a non-zero limit.  But SCSI can clear the limit in the
+	 * I/O completion handler, and we can race and see this.  Splitting to a
+	 * zero limit obviously doesn't make sense, so band-aid it here.
+	 */
+	if (!max_sectors)
+		return bio;
+	if (bio_sectors(bio) <= max_sectors)
+		return bio;
+	return bio_submit_split(bio, max_sectors);
+}
+
 /**
  * bio_split_to_limits - split a bio to fit the queue limits
  * @bio:     bio to be split
-- 
2.43.0



