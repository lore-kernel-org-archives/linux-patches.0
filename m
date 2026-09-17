Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30930502D47;
	Thu, 17 Sep 2026 18:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668182; cv=none; b=tRVFlY3GuSsV69BvHLbeM1Xqcj6jlmfoMjUjVCZxnHqv7OqQh6PSiGnNW7DIU7d9Kss3MmdMHlged+cKf02AuzGw0aEvmAh0aCbJ9f7IpDw1T7lWivPQhACG5w/koKm/9SqDJElQvjnQ+BoVFhIpD2CUTfK1A3adI/ViETEtGyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668182; c=relaxed/simple;
	bh=7hLMsjzksppKutQBWEykp/NXcIpqusR0hhzeAsQj9VA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuuhSmjK0VPMACGa0Ch2Wj7N1UWqDviTeZBUfx7XDXQLuSHuAz61tXlb/bt/eit+HGA5ETxx/7XHqLXI4ZHEnWzmqQM/UUR5CgVUg1zKPHjUOD2VvlgXZCSf/y3m+iYou3rRVrHP2uvFKlCz7dH1H0M9k5jLveOAC8TO7lqqTEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rhFy+uwk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhFy+uwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4722B1F000FF;
	Thu, 17 Sep 2026 18:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668180;
	bh=siBQotK8eG0uOBTu/8EvEeop1t5frjSiJUB29xZHOwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rhFy+uwkcbzPYXvTn6u5EIzjntiRgeoAxQUjmr3k8XBwu7rW8qZful59l4mFlVyQo
	 VaS7XDndmVnU6+0D347izgQDa0G7k2+Th5+87QyvFGy4s0KUtBLNgipHVftSLZR3wx
	 eZkRDMq8aslv7bLe89kYcpn8tgqy78bgtdDXCCII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0341/1102] md/raid5: account discard IO
Date: Thu, 17 Sep 2026 16:04:44 +0100
Message-ID: <20260917151548.199585351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index bdd620d89c672..dea608e65c413 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5699,7 +5699,10 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 {
 	struct r5conf *conf = mddev->private;
 	sector_t logical_sector, last_sector;
+	sector_t first_stripe, last_stripe;
 	struct stripe_head *sh;
+	struct bvec_iter bi_iter;
+	struct bio *orig_bi = bi;
 	int stripe_sectors;
 
 	/* We need to handle this when io_uring supports discard/trim */
@@ -5710,19 +5713,29 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
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



