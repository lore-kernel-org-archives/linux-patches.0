Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0681FCF41;
	Tue,  3 Dec 2024 15:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240151; cv=none; b=Hb+nFfQTHCrFcvKvwin0z1UDjNsiQVeRw13hMtzzOg9vijNqhLljBZSy/5R3tYkIKc6bco2X8EYxvF/M28Rf9UDD/T3sVUzSgl/DSvtDC8b1qO+uZBBesmqtn1huW4Lc/A39Yd9+lKJAVZ76zW/ea1+c+q5KQEQOBIaOXrg2/sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240151; c=relaxed/simple;
	bh=e+UwYOZIK4HcUXo5zsI1wD/35ca+H0sgJ/OH7B85+zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUafvzK1NROHFX5r8twq7FKqM+Ye2Q02D3LoDLIK50U+xT3UAuc4bJJbGjP4Q+/r7wdv/wiVkNjvDbbZMvuYjisz93cPQthzU0wQvGQt7FKcoE9cXlE1rc/kQZ7isUYc5habutYFnOxSo/cB+QfD5B7CGRJLJd3ZEDGYf+LW8zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABm9Pqnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABm9Pqnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EFBC4CECF;
	Tue,  3 Dec 2024 15:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240151;
	bh=e+UwYOZIK4HcUXo5zsI1wD/35ca+H0sgJ/OH7B85+zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABm9Pqnu5eS5MOGIUvD2yESZ5BuPJDvdzWChThStb+fbQp5z0Dzs+n6yA/1fhupE/
	 xqXy14yMU69qvkblGKyTqVHyW/tE0odPsI3dIOarNDp0Spv/enezgAQmDzp7SKRn7w
	 QSw46X6JutgpXp1m2JBPWBNM12xhY+wmw0jnF6hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/826] block: take chunk_sectors into account in bio_split_write_zeroes
Date: Tue,  3 Dec 2024 15:36:00 +0100
Message-ID: <20241203144744.751359547@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ad763ec313b6a..75d2461b69e40 100644
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



