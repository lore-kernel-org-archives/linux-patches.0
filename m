Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4829E36A033;
	Wed, 30 Sep 2026 17:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791055; cv=none; b=JinxjJbkxYQytfo2cMtAXNbkM0ecazs8q+UIuoQ4Al1VhyicrntYqKGjnjPmESCVIpiuHLogU7jIAhl2Ce2fOe45SyChy5fRqkj/Vo1s2xwVD/gKijNizcFpoPb2nnfLswa3o7te5JnX/Cm0ln/4yuJeF6Ej+GErC1iVspKnFvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791055; c=relaxed/simple;
	bh=V0NmsMgAr2567AKFZoXBtnInN4qtvtXXueL+QhG4w2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMaQxpK4qH0rs7FOKr+T8m1vwF9u23tTu45GRImhQIFhKV/GIzOJd3bdEYn6qGrLUJG+17CiTd8RTM6sjz5UZnQpLsq/ii87Q/iZE5bTWLesL6hV6iWa2NaPIVYL0gGkJjlfMFPWiW2i3xYgl2uSyBdvMScx4Oot4MBTCZovCAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMfkZSQJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMfkZSQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF631F000FF;
	Wed, 30 Sep 2026 17:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791054;
	bh=5shgV9pmpjxWey92qtwJJZJhy6wWDQiS60eLWKi+LxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMfkZSQJcRPN3s8hhDWEyLz5xnYGfQ3PlOgcdToExye7XjMEuYoylqrVvgddiqQZj
	 GncKRQBMWrHtgQ7tgnIQaMxZryLq0iGN5677nSBi4my70x05j88BFkzV8jnUjmwXpR
	 /Llxe95Jb3HIex3EP4EsOn6GQZPzBUA2+1l6vZ4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/752] md/raid5: account discard IO
Date: Wed, 30 Sep 2026 17:20:37 +0200
Message-ID: <20260930152401.813456383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a957eb3ce7bc6..7ecc339f34a27 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5679,26 +5679,39 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 {
 	struct r5conf *conf = mddev->private;
 	sector_t logical_sector, last_sector;
+	sector_t first_stripe, last_stripe;
 	struct stripe_head *sh;
+	struct bvec_iter bi_iter;
+	struct bio *orig_bi = bi;
 	int stripe_sectors;
 
 	if (mddev->reshape_position != MaxSector)
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



