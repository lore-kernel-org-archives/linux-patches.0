Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6A018FC86;
	Wed, 19 Feb 2025 09:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955873; cv=none; b=g7J5oUrhgJsEoVufGG+l/8QATde5/pCCurLAg5d0AfCtLzSsLbyrUvTOwSv/YaBiXPtCcDFAGqVkgFxY4oN1JNfBytv543pBGsfvEM9fz5ItBrinhYhf0EMb692CZ9CTzLu5tUxRMNBTbxEXKw4RsRSe1KFbeBEw469pm3mCcyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955873; c=relaxed/simple;
	bh=I0BDWQE7t7y/EDqgodCOVOH0v3M4MTgh3cKz0eGmI90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BaA9NCjpnqtOAbm1RPHOVQdzv4Wa7VFeK8R7SFFYsG4C8yqc8nBWiYHSqFBCHdzRh9jH483vZ9Dtjb28BbydASh69jrhQpaSMrHncV6wQdhr78isBE1Cwi9CTydoyp/Ng1iCs5ce6DpioD2kcsimHILfPskkr8Uw4QCC1P9otJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtsXDJon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtsXDJon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964C4C4CED1;
	Wed, 19 Feb 2025 09:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955873;
	bh=I0BDWQE7t7y/EDqgodCOVOH0v3M4MTgh3cKz0eGmI90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtsXDJonvw0GZzq89roJkwsp7CBh1k96oMxD1B7y8r9ppAcGT5Q44+LPANT8N55Tp
	 EiC81HbH36pZ//f+pDZ8l5aMTDoicIIbDWIDbXZs2Xz1kY/QjDAa9hmYnAfPn+TwY5
	 ioQtZgld5JEq8YzvEJdv4AyD5iz8gEw7BCtWwuTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.6 142/152] md/raid5: implement pers->bitmap_sector()
Date: Wed, 19 Feb 2025 09:29:15 +0100
Message-ID: <20250219082555.664212457@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ Resolve minor conflicts ]
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5996,6 +5996,54 @@ static enum reshape_loc get_reshape_loc(
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
@@ -9099,6 +9147,7 @@ static struct md_personality raid6_perso
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid6_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
+	.bitmap_sector  = raid5_bitmap_sector,
 };
 static struct md_personality raid5_personality =
 {
@@ -9124,6 +9173,7 @@ static struct md_personality raid5_perso
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid5_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
+	.bitmap_sector  = raid5_bitmap_sector,
 };
 
 static struct md_personality raid4_personality =
@@ -9150,6 +9200,7 @@ static struct md_personality raid4_perso
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid4_takeover,
 	.change_consistency_policy = raid5_change_consistency_policy,
+	.bitmap_sector  = raid5_bitmap_sector,
 };
 
 static int __init raid5_init(void)


