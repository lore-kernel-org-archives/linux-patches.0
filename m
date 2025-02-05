Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E879F1519BF;
	Wed,  5 Feb 2025 15:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768001; cv=none; b=GUioXNkOElQgZoZl1LZfE9yTMPbNTyoC94qDvXcIL99YjchunN4xWShgxNQRD6w+A7K2raHenzsVmrT6TBaH8DRNM1iyo6ks+SCihqihV7AIJ19QSK96xPSKLSoDhNkYT/ll2ix4dqHWEJlruwZ8MLyL5jWj1mMgyb2UmhXCY0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768001; c=relaxed/simple;
	bh=bAaNfa2KGDHkN8tc4SpowXDvGr5Xv/6A9v+k2PX3d64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bez8JNaiTRqRnTzAlo7vqo6w1lArvZ+GimgHWUqK+bE9FYywG56yh5HX490Cbi/ub5pW9ACm5Y9PibBy1X4DFzVlLk3DoCszWRHpbSegKGBJDs6c+MwjRPNpvY/bZP1WoAGja5WwWYeQrUvaFapUdLrJjUnvSDFT3aEsuqstC9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cc3KpqjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cc3KpqjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B65C4CED1;
	Wed,  5 Feb 2025 15:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768000;
	bh=bAaNfa2KGDHkN8tc4SpowXDvGr5Xv/6A9v+k2PX3d64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cc3KpqjMNFeWcXBm9UOdfzvWMNfgJkSKC2Odn+hj3zZX+1r6sm+aem8kpWvWxLkdo
	 7eK7IuUisNvUAhUBfxSDrYzB9SeoxaKpYhq4i8yR6tEiTLQ3wN4B5zsvCGooWpSjfe
	 I/z9fiHm605etH4UYuMoMssbFlhk+DPnuvPxJ7pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH 6.12 540/590] md/raid5: implement pers->bitmap_sector()
Date: Wed,  5 Feb 2025 14:44:55 +0100
Message-ID: <20250205134515.932763878@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 9c89f604476cf15c31fbbdb043cff7fbf1dbe0cb upstream.

Bitmap is used for the whole array for raid1/raid10, hence IO for the
array can be used directly for bitmap. However, bitmap is used for
underlying disks for raid5, hence IO for the array can't be used
directly for bitmap.

Implement pers->bitmap_sector() for raid5 to convert IO ranges from the
array to the underlying disks.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250109015145.158868-5-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Yu Kuai <yukuai1@huaweicloud.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5919,6 +5919,54 @@ static enum reshape_loc get_reshape_loc(
 	return LOC_BEHIND_RESHAPE;
 }
 
+static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
+				unsigned long *sectors)
+{
+	struct r5conf *conf = mddev->private;
+	sector_t start = *offset;
+	sector_t end = start + *sectors;
+	sector_t prev_start = start;
+	sector_t prev_end = end;
+	int sectors_per_chunk;
+	enum reshape_loc loc;
+	int dd_idx;
+
+	sectors_per_chunk = conf->chunk_sectors *
+		(conf->raid_disks - conf->max_degraded);
+	start = round_down(start, sectors_per_chunk);
+	end = round_up(end, sectors_per_chunk);
+
+	start = raid5_compute_sector(conf, start, 0, &dd_idx, NULL);
+	end = raid5_compute_sector(conf, end, 0, &dd_idx, NULL);
+
+	/*
+	 * For LOC_INSIDE_RESHAPE, this IO will wait for reshape to make
+	 * progress, hence it's the same as LOC_BEHIND_RESHAPE.
+	 */
+	loc = get_reshape_loc(mddev, conf, prev_start);
+	if (likely(loc != LOC_AHEAD_OF_RESHAPE)) {
+		*offset = start;
+		*sectors = end - start;
+		return;
+	}
+
+	sectors_per_chunk = conf->prev_chunk_sectors *
+		(conf->previous_raid_disks - conf->max_degraded);
+	prev_start = round_down(prev_start, sectors_per_chunk);
+	prev_end = round_down(prev_end, sectors_per_chunk);
+
+	prev_start = raid5_compute_sector(conf, prev_start, 1, &dd_idx, NULL);
+	prev_end = raid5_compute_sector(conf, prev_end, 1, &dd_idx, NULL);
+
+	/*
+	 * for LOC_AHEAD_OF_RESHAPE, reshape can make progress before this IO
+	 * is handled in make_stripe_request(), we can't know this here hence
+	 * we set bits for both.
+	 */
+	*offset = min(start, prev_start);
+	*sectors = max(end, prev_end) - *offset;
+}
+
 static enum stripe_result make_stripe_request(struct mddev *mddev,
 		struct r5conf *conf, struct stripe_request_ctx *ctx,
 		sector_t logical_sector, struct bio *bi)
@@ -8967,6 +9015,7 @@ static struct md_personality raid6_perso
 	.takeover	= raid6_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
+	.bitmap_sector	= raid5_bitmap_sector,
 };
 static struct md_personality raid5_personality =
 {
@@ -8992,6 +9041,7 @@ static struct md_personality raid5_perso
 	.takeover	= raid5_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
+	.bitmap_sector	= raid5_bitmap_sector,
 };
 
 static struct md_personality raid4_personality =
@@ -9018,6 +9068,7 @@ static struct md_personality raid4_perso
 	.takeover	= raid4_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
 	.prepare_suspend = raid5_prepare_suspend,
+	.bitmap_sector	= raid5_bitmap_sector,
 };
 
 static int __init raid5_init(void)


