Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD2B33F8A1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300949; cv=none; b=aR/mRWb+2g37Vga5PYOPA9DSHqVsDUiYnmeGT1qSUoz6zgfXZhOC1nWXU+L+ViPtmRaHd0TGykgv1sfTkQMhG6OZQ1PpJ6yGKmyZorY1enbZV+CHklhYdzQxvxzpNFAmIr/3paLcIbIsWkNK60Oitaexs8/yPPsj48gQ6TdyUyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300949; c=relaxed/simple;
	bh=2TP7x5/3d+6wM9kgn7ZaC1A0ywz7tWF9nvq05FSnDdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmmJ+G3kp8DXU54d9rAEhkOVYUj69IdNOYU2owX5cAE2bGJKkmEgb0fO2DLiWw9zcTkVx9c7pIVWE2clGQ6cjBqzNlyDiK2CvJDmzwxVrGX37yR71mexNwsyU8JW6dtfFGzmlnwpsdXjXD+Q5Im5Y+V5dO6u7xyuPudiif7NjBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ExIG03ln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ExIG03ln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB014C19424;
	Sat, 28 Feb 2026 17:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300949;
	bh=2TP7x5/3d+6wM9kgn7ZaC1A0ywz7tWF9nvq05FSnDdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExIG03lnZzouCdNKh4sqWnyOH38CacUa6afOlQfA6x2cTSMSLaaViFMwQzZ73c6Cd
	 tXrJaNM/8Z0F626D3LEipGZLT3/M3SfPiuytMdEB28RNEt46mIqAgyXbzr0WR1Rz1V
	 Sqiym0jb2xBpl0nJjExOBfqZSmF37CsUBN/Of0mY3S64nkVEj+NjG9FPvQrPUnkuuz
	 npk6q36jOwm485F6hjzzfzafajwJz26qCvxyb/LNBw/DMqA2zPxWttyLX32IhDcvI6
	 O3FTqp2ejtJJb91cbkLIIbOFLYzq/YGID0YrY/0UBLUQ5mcVMEUvpng8EWDa21L9Ki
	 Kb9BtNIRCRgIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 072/752] block: decouple secure erase size limit from discard size limit
Date: Sat, 28 Feb 2026 12:36:23 -0500
Message-ID: <20260228174750.1542406-72-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Luke Wang <ziniu.wang_1@nxp.com>

[ Upstream commit ee81212f74a57c5d2b56cf504f40d528dac6faaf ]

Secure erase should use max_secure_erase_sectors instead of being limited
by max_discard_sectors. Separate the handling of REQ_OP_SECURE_ERASE from
REQ_OP_DISCARD to allow each operation to use its own size limit.

Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 21 +++++++++++++++++----
 block/blk.h       |  6 +++++-
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 37864c5d287ef..03b61923cf109 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -158,8 +158,9 @@ static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
 	return bio;
 }
 
-struct bio *bio_split_discard(struct bio *bio, const struct queue_limits *lim,
-		unsigned *nsegs)
+static struct bio *__bio_split_discard(struct bio *bio,
+		const struct queue_limits *lim, unsigned *nsegs,
+		unsigned int max_sectors)
 {
 	unsigned int max_discard_sectors, granularity;
 	sector_t tmp;
@@ -169,8 +170,7 @@ struct bio *bio_split_discard(struct bio *bio, const struct queue_limits *lim,
 
 	granularity = max(lim->discard_granularity >> 9, 1U);
 
-	max_discard_sectors =
-		min(lim->max_discard_sectors, bio_allowed_max_sectors(lim));
+	max_discard_sectors = min(max_sectors, bio_allowed_max_sectors(lim));
 	max_discard_sectors -= max_discard_sectors % granularity;
 	if (unlikely(!max_discard_sectors))
 		return bio;
@@ -194,6 +194,19 @@ struct bio *bio_split_discard(struct bio *bio, const struct queue_limits *lim,
 	return bio_submit_split(bio, split_sectors);
 }
 
+struct bio *bio_split_discard(struct bio *bio, const struct queue_limits *lim,
+		unsigned *nsegs)
+{
+	unsigned int max_sectors;
+
+	if (bio_op(bio) == REQ_OP_SECURE_ERASE)
+		max_sectors = lim->max_secure_erase_sectors;
+	else
+		max_sectors = lim->max_discard_sectors;
+
+	return __bio_split_discard(bio, lim, nsegs, max_sectors);
+}
+
 static inline unsigned int blk_boundary_sectors(const struct queue_limits *lim,
 						bool is_atomic)
 {
diff --git a/block/blk.h b/block/blk.h
index 37b9b6a95c11c..06dfb5b670179 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -208,10 +208,14 @@ static inline unsigned int blk_queue_get_max_sectors(struct request *rq)
 	struct request_queue *q = rq->q;
 	enum req_op op = req_op(rq);
 
-	if (unlikely(op == REQ_OP_DISCARD || op == REQ_OP_SECURE_ERASE))
+	if (unlikely(op == REQ_OP_DISCARD))
 		return min(q->limits.max_discard_sectors,
 			   UINT_MAX >> SECTOR_SHIFT);
 
+	if (unlikely(op == REQ_OP_SECURE_ERASE))
+		return min(q->limits.max_secure_erase_sectors,
+			   UINT_MAX >> SECTOR_SHIFT);
+
 	if (unlikely(op == REQ_OP_WRITE_ZEROES))
 		return q->limits.max_write_zeroes_sectors;
 
-- 
2.51.0

