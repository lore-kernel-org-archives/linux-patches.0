Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD292285048;
	Tue, 17 Jun 2025 16:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178832; cv=none; b=oOrEAZKYiQaS+tStlptJUqdLsFPZjo4uaJ7asHT6mC+BLldIU7pdT3KMDvIoUnly7obUynZd9fM4XOR2FA4wxhMFyi52pBrcdN3eMBmE7lBJuKGjhgK9a2V3K0+mvDe0f3N5ziV8i/xBbAqAZgyutslGu1LgjGkXHeaTSNQZWA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178832; c=relaxed/simple;
	bh=/fjpAQd7+hG54mcASU6h2kRBzRjkqs7y7cVNurzC8f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWqr391JYaIaWWeenTw3ZM4i0ULEwjMkMzGPkL5nfjLMo09DwZ5QyzhFX0xPSu4DThandi5bKUAO0HR8zKZrz/JtAai8B5zaUNpgJIUJcTuRKyoAlzbtuDZc52zpve9UQFPHGlZUiPa6bBF5J7z4uY+rVqlGtK4c+SS5yWyPm2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1rKjFZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1rKjFZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FB6C4CEE3;
	Tue, 17 Jun 2025 16:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178830;
	bh=/fjpAQd7+hG54mcASU6h2kRBzRjkqs7y7cVNurzC8f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1rKjFZlvYMFyxOBoMlBruQ1N2e0XiEQRiTsjpxygbqWHS968tNzMqHIO4rC+GV72
	 cf3chsmdSY20pyZfjRd1rhPfu/RNNWiu+Fuerhi6j+1uprb7RSZZ3vFVphWOUD2uX4
	 C6XTjLFmfje5EeTZgbiNkk5h9JnuPvLKSdFDmceM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.15 566/780] md/raid1,raid10: dont handle IO error for REQ_RAHEAD and REQ_NOWAIT
Date: Tue, 17 Jun 2025 17:24:34 +0200
Message-ID: <20250617152514.531966226@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 9f346f7d4ea73692b82f5102ca8698e4040469ea ]

IO with REQ_RAHEAD or REQ_NOWAIT can fail early, even if the storage medium
is fine, hence record badblocks or remove the disk from array does not
make sense.

This problem if found by lvm2 test lvcreate-large-raid, where dm-zero
will fail read ahead IO directly.

Fixes: e879a0d9cb08 ("md/raid1,raid10: don't ignore IO flags")
Reported-and-tested-by: Mikulas Patocka <mpatocka@redhat.com>
Closes: https://lore.kernel.org/all/34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com/
Link: https://lore.kernel.org/linux-raid/20250527081407.3004055-1-yukuai1@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1-10.c | 10 ++++++++++
 drivers/md/raid1.c    | 19 ++++++++++---------
 drivers/md/raid10.c   | 11 ++++++-----
 3 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index c7efd8aab675c..b8b3a90697012 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -293,3 +293,13 @@ static inline bool raid1_should_read_first(struct mddev *mddev,
 
 	return false;
 }
+
+/*
+ * bio with REQ_RAHEAD or REQ_NOWAIT can fail at anytime, before such IO is
+ * submitted to the underlying disks, hence don't record badblocks or retry
+ * in this case.
+ */
+static inline bool raid1_should_handle_error(struct bio *bio)
+{
+	return !(bio->bi_opf & (REQ_RAHEAD | REQ_NOWAIT));
+}
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index de9bccbe7337b..1fe645e630012 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -373,14 +373,16 @@ static void raid1_end_read_request(struct bio *bio)
 	 */
 	update_head_pos(r1_bio->read_disk, r1_bio);
 
-	if (uptodate)
+	if (uptodate) {
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
-	else if (test_bit(FailFast, &rdev->flags) &&
-		 test_bit(R1BIO_FailFast, &r1_bio->state))
+	} else if (test_bit(FailFast, &rdev->flags) &&
+		 test_bit(R1BIO_FailFast, &r1_bio->state)) {
 		/* This was a fail-fast read so we definitely
 		 * want to retry */
 		;
-	else {
+	} else if (!raid1_should_handle_error(bio)) {
+		uptodate = 1;
+	} else {
 		/* If all other devices have failed, we want to return
 		 * the error upwards rather than fail the last device.
 		 * Here we redefine "uptodate" to mean "Don't want to retry"
@@ -451,16 +453,15 @@ static void raid1_end_write_request(struct bio *bio)
 	struct bio *to_put = NULL;
 	int mirror = find_bio_disk(r1_bio, bio);
 	struct md_rdev *rdev = conf->mirrors[mirror].rdev;
-	bool discard_error;
 	sector_t lo = r1_bio->sector;
 	sector_t hi = r1_bio->sector + r1_bio->sectors;
-
-	discard_error = bio->bi_status && bio_op(bio) == REQ_OP_DISCARD;
+	bool ignore_error = !raid1_should_handle_error(bio) ||
+		(bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
 
 	/*
 	 * 'one mirror IO has finished' event handler:
 	 */
-	if (bio->bi_status && !discard_error) {
+	if (bio->bi_status && !ignore_error) {
 		set_bit(WriteErrorSeen,	&rdev->flags);
 		if (!test_and_set_bit(WantReplacement, &rdev->flags))
 			set_bit(MD_RECOVERY_NEEDED, &
@@ -511,7 +512,7 @@ static void raid1_end_write_request(struct bio *bio)
 
 		/* Maybe we can clear some bad blocks. */
 		if (rdev_has_badblock(rdev, r1_bio->sector, r1_bio->sectors) &&
-		    !discard_error) {
+		    !ignore_error) {
 			r1_bio->bios[mirror] = IO_MADE_GOOD;
 			set_bit(R1BIO_MadeGood, &r1_bio->state);
 		}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ba32bac975b8d..54320a887ecc5 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -399,6 +399,8 @@ static void raid10_end_read_request(struct bio *bio)
 		 * wait for the 'master' bio.
 		 */
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
+	} else if (!raid1_should_handle_error(bio)) {
+		uptodate = 1;
 	} else {
 		/* If all other devices that store this block have
 		 * failed, we want to return the error upwards rather
@@ -456,9 +458,8 @@ static void raid10_end_write_request(struct bio *bio)
 	int slot, repl;
 	struct md_rdev *rdev = NULL;
 	struct bio *to_put = NULL;
-	bool discard_error;
-
-	discard_error = bio->bi_status && bio_op(bio) == REQ_OP_DISCARD;
+	bool ignore_error = !raid1_should_handle_error(bio) ||
+		(bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
 
 	dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
 
@@ -472,7 +473,7 @@ static void raid10_end_write_request(struct bio *bio)
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	if (bio->bi_status && !discard_error) {
+	if (bio->bi_status && !ignore_error) {
 		if (repl)
 			/* Never record new bad blocks to replacement,
 			 * just fail it.
@@ -527,7 +528,7 @@ static void raid10_end_write_request(struct bio *bio)
 		/* Maybe we can clear some bad blocks. */
 		if (rdev_has_badblock(rdev, r10_bio->devs[slot].addr,
 				      r10_bio->sectors) &&
-		    !discard_error) {
+		    !ignore_error) {
 			bio_put(bio);
 			if (repl)
 				r10_bio->devs[slot].repl_bio = IO_MADE_GOOD;
-- 
2.39.5



