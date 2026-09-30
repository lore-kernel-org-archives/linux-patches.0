Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A336514764;
	Wed, 30 Sep 2026 16:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784733; cv=none; b=pEIP683MihZhR5NgXHB2RqjBOkb1u/arXs90BwKMkmmX90OgJQy3a1gEI5agBCCqoVucIeSAU8oARmCOyHP8XZVYJNlbwIusd5j2xQNU3v1eQdhG7SqHYwhgcwwPDjSi6Y0pC+sykndBSmdFclih8yS5+Cc+IcQsqeFNo1V6ros=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784733; c=relaxed/simple;
	bh=BBOEaxJXZqFlL5jbQJtL9k/DiKKTwvuIVJKH4E35SBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4cOd9YYbz0IdUvswD7lYm4kRRCVb5t0qEBr7sQ8vDp67xPyjaM0pWnD9MwfBcfPhlOmbVhNmmScBAXsgGWC9uYDn7Q0eWSORLm7g4G3uVKDRDs2Px4HMc/LCUwyWHo0UBR8WlVhVSFjdP8MmTkW/qM96JIjz+xVPMrXcDOa02g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7N7tLya; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7N7tLya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CD71F00899;
	Wed, 30 Sep 2026 16:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784728;
	bh=B2H1FeauJ50b6EcDzW1Ze/iA4WtymDSaTUVz1bolmVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7N7tLyaI+ZhtaO9ICBtF4D9BL40LOyALc3Mc1V0dsUNDrMYRPaHQ3PjySCvTmjxH
	 qvXcyiQFWu5QnY6NOET6hIvzDP6yN3Q8KaT30benBVb5AN/W8WRSSMKmO2/hQ2jTKe
	 YiPrFuVRoF/ZGF7nphwvvKOSe93JjlCvInhXuwA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 213/982] md/raid5: account discard IO
Date: Wed, 30 Sep 2026 17:15:49 +0200
Message-ID: <20260930152421.383169137@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fygo.io>

[ Upstream commit 74ddbf98e2db646ec58f7e7731c936b7a4a470fe ]

Raid5 handles discard bios internally through make_discard_request() and
never passes them through md_account_bio(). As a result, discard IO is
missing the md-device iostat accounting that normal raid5 IO and discard
IO in other raid levels get from md_account_bio().

Before accounting the bio, trim the request to the full data stripes that
raid5 will actually discard. The first full stripe is the ceiling of the
bio start divided by data-stripe sectors, and the last full stripe is the
floor of the bio end divided by data-stripe sectors. Account that exact
MD logical full-stripe range, then restore the original iterator so bio
completion and iostat still cover the original request.

Link: https://patch.msgid.link/20260605072639.2434847-2-yukuai@kernel.org
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6675ca50259e0..664aa8c0781e9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5796,7 +5796,10 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 {
 	struct r5conf *conf = mddev->private;
 	sector_t logical_sector, last_sector;
+	sector_t first_stripe, last_stripe;
 	struct stripe_head *sh;
+	struct bvec_iter bi_iter;
+	struct bio *orig_bi = bi;
 	int stripe_sectors;
 
 	/* We need to handle this when io_uring supports discard/trim */
@@ -5807,19 +5810,29 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 		/* Skip discard while reshape is happening */
 		return;
 
-	logical_sector = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
-	last_sector = bio_end_sector(bi);
-
-	bi->bi_next = NULL;
-
 	stripe_sectors = conf->chunk_sectors *
 		(conf->raid_disks - conf->max_degraded);
-	logical_sector = DIV_ROUND_UP_SECTOR_T(logical_sector,
-					       stripe_sectors);
-	sector_div(last_sector, stripe_sectors);
+	first_stripe = DIV_ROUND_UP_SECTOR_T(bi->bi_iter.bi_sector,
+					     stripe_sectors);
+	last_stripe = bio_end_sector(bi);
+	sector_div(last_stripe, stripe_sectors);
+
+	if (first_stripe >= last_stripe) {
+		bio_endio(bi);
+		return;
+	}
+
+	bi_iter = bi->bi_iter;
+	bi->bi_iter.bi_sector = first_stripe * stripe_sectors;
+	bi->bi_iter.bi_size = ((last_stripe - first_stripe) *
+			       stripe_sectors) << 9;
+	md_account_bio(mddev, &bi);
+	orig_bi->bi_iter = bi_iter;
+	bi->bi_iter = bi_iter;
+	bi->bi_next = NULL;
 
-	logical_sector *= conf->chunk_sectors;
-	last_sector *= conf->chunk_sectors;
+	logical_sector = first_stripe * conf->chunk_sectors;
+	last_sector = last_stripe * conf->chunk_sectors;
 
 	for (; logical_sector < last_sector;
 	     logical_sector += RAID5_STRIPE_SECTORS(conf)) {
-- 
2.53.0



