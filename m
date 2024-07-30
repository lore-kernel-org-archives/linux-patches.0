Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2740C1BE85E;
	Tue, 30 Jul 2024 16:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355219; cv=none; b=BmZtBh03u5yP3zlHuSkiFJSAxhp0tFEywfDP3p4xCrce7+4gYN3RxBbV6srV30z6QwVwrBA12/HoC4/HCJUPkfiRyGbPdYlxm5BGEz/TeC+yxeC/gb81gmhWBRNaVJiWUfJiLP9KYRZFgtfPPSy05TMpqIkJcLd2I2chJUp25Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355219; c=relaxed/simple;
	bh=8l/j04e2zT1t6onVuWds8Jtbh2geGRHJ7u8O7yUu47o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jW4PNy7eABt+cublq3jNpRlu/0oVgEpSFujzAvXlWem/eWtvF2U16rRhrBqKPWSxeqiZ6Y64cAh7R7Rhbkw8A3qdTVSQPQJhILTj8vptFVpWpq8yoJvQtayvIs9n6hb4GYqMm50NWCnWVho/a6f/mX5JOc80QfFJyPliRqN53Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUylv2gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUylv2gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C71CC32782;
	Tue, 30 Jul 2024 16:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355219;
	bh=8l/j04e2zT1t6onVuWds8Jtbh2geGRHJ7u8O7yUu47o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUylv2gcSv2Nk/A9P+EzH2Euwaet7/81Ab4bdE68n6EQYPzKB5DxkO7PFPFn7e438
	 mdfhJe1lJRftLQ2PrbuFDBXpE/S3whHNiJNbZ0gpTwO5Z8gi4K3+XIE8kYdoQNnsoe
	 kRIZKh4lFcdNX7UaxIKpuwMYqILyK4HfNZKe8bfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 030/809] md/raid5: recheck if reshape has finished with device_lock held
Date: Tue, 30 Jul 2024 17:38:26 +0200
Message-ID: <20240730151725.845727290@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 25b3a8237a03ec0b67b965b52d74862e77ef7115 ]

When handling an IO request, MD checks if a reshape is currently
happening, and if so, where the IO sector is in relation to the reshape
progress. MD uses conf->reshape_progress for both of these tasks.  When
the reshape finishes, conf->reshape_progress is set to MaxSector.  If
this occurs after MD checks if the reshape is currently happening but
before it calls ahead_of_reshape(), then ahead_of_reshape() will end up
comparing the IO sector against MaxSector. During a backwards reshape,
this will make MD think the IO sector is in the area not yet reshaped,
causing it to use the previous configuration, and map the IO to the
sector where that data was before the reshape.

This bug can be triggered by running the lvm2
lvconvert-raid-reshape-linear_to_raid6-single-type.sh test in a loop,
although it's very hard to reproduce.

Fix this by factoring the code that checks where the IO sector is in
relation to the reshape out to a helper called get_reshape_loc(),
which reads reshape_progress and reshape_safe while holding the
device_lock, and then rechecks if the reshape has finished before
calling ahead_of_reshape with the saved values.

Also use the helper during the REQ_NOWAIT check to see if the location
is inside of the reshape region.

Fixes: fef9c61fdfabf ("md/raid5: change reshape-progress measurement to cope with reshaping backwards.")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240702151802.1632010-1-bmarzins@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 64 +++++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 23 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2bd1ce9b39226..36d6764a1b25c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5899,6 +5899,39 @@ static int add_all_stripe_bios(struct r5conf *conf,
 	return ret;
 }
 
+enum reshape_loc {
+	LOC_NO_RESHAPE,
+	LOC_AHEAD_OF_RESHAPE,
+	LOC_INSIDE_RESHAPE,
+	LOC_BEHIND_RESHAPE,
+};
+
+static enum reshape_loc get_reshape_loc(struct mddev *mddev,
+		struct r5conf *conf, sector_t logical_sector)
+{
+	sector_t reshape_progress, reshape_safe;
+	/*
+	 * Spinlock is needed as reshape_progress may be
+	 * 64bit on a 32bit platform, and so it might be
+	 * possible to see a half-updated value
+	 * Of course reshape_progress could change after
+	 * the lock is dropped, so once we get a reference
+	 * to the stripe that we think it is, we will have
+	 * to check again.
+	 */
+	spin_lock_irq(&conf->device_lock);
+	reshape_progress = conf->reshape_progress;
+	reshape_safe = conf->reshape_safe;
+	spin_unlock_irq(&conf->device_lock);
+	if (reshape_progress == MaxSector)
+		return LOC_NO_RESHAPE;
+	if (ahead_of_reshape(mddev, logical_sector, reshape_progress))
+		return LOC_AHEAD_OF_RESHAPE;
+	if (ahead_of_reshape(mddev, logical_sector, reshape_safe))
+		return LOC_INSIDE_RESHAPE;
+	return LOC_BEHIND_RESHAPE;
+}
+
 static enum stripe_result make_stripe_request(struct mddev *mddev,
 		struct r5conf *conf, struct stripe_request_ctx *ctx,
 		sector_t logical_sector, struct bio *bi)
@@ -5913,28 +5946,14 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 	seq = read_seqcount_begin(&conf->gen_lock);
 
 	if (unlikely(conf->reshape_progress != MaxSector)) {
-		/*
-		 * Spinlock is needed as reshape_progress may be
-		 * 64bit on a 32bit platform, and so it might be
-		 * possible to see a half-updated value
-		 * Of course reshape_progress could change after
-		 * the lock is dropped, so once we get a reference
-		 * to the stripe that we think it is, we will have
-		 * to check again.
-		 */
-		spin_lock_irq(&conf->device_lock);
-		if (ahead_of_reshape(mddev, logical_sector,
-				     conf->reshape_progress)) {
-			previous = 1;
-		} else {
-			if (ahead_of_reshape(mddev, logical_sector,
-					     conf->reshape_safe)) {
-				spin_unlock_irq(&conf->device_lock);
-				ret = STRIPE_SCHEDULE_AND_RETRY;
-				goto out;
-			}
+		enum reshape_loc loc = get_reshape_loc(mddev, conf,
+						       logical_sector);
+		if (loc == LOC_INSIDE_RESHAPE) {
+			ret = STRIPE_SCHEDULE_AND_RETRY;
+			goto out;
 		}
-		spin_unlock_irq(&conf->device_lock);
+		if (loc == LOC_AHEAD_OF_RESHAPE)
+			previous = 1;
 	}
 
 	new_sector = raid5_compute_sector(conf, logical_sector, previous,
@@ -6113,8 +6132,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	/* Bail out if conflicts with reshape and REQ_NOWAIT is set */
 	if ((bi->bi_opf & REQ_NOWAIT) &&
 	    (conf->reshape_progress != MaxSector) &&
-	    !ahead_of_reshape(mddev, logical_sector, conf->reshape_progress) &&
-	    ahead_of_reshape(mddev, logical_sector, conf->reshape_safe)) {
+	    get_reshape_loc(mddev, conf, logical_sector) == LOC_INSIDE_RESHAPE) {
 		bio_wouldblock_error(bi);
 		if (rw == WRITE)
 			md_write_end(mddev);
-- 
2.43.0



