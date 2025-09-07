Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F5B1A0BFD;
	Sun,  7 Sep 2025 20:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277246; cv=none; b=XTa1j5QkcoLEiCDYOPMlT74l5DiduI7cL2rdd3nFlK3fW57W+DOzagjzPNYdZkS5usPL3sXisAZDxkJwazWGxNHR9ewRpvbWCYSCOQrCz5CxRmVYZQ89WDbv64FyVI35mNpwl59zfUjSDv2Sjpc1TTJa3VVQIOWrelFrDiHMWH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277246; c=relaxed/simple;
	bh=tkmXakmziEoP90mjasiBIgW7zbsNkVCyjHNYgHP+8qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X91fo2y2HTKOBOxAHQ7lNdemlQsElqIu8hhQLhkSn/Pr0UMK0eLsispPyoVDD3MvU35W3GJL2o50wx1oyLY9EDOlxWRKL7lpDFldAhIU3RqVArVQBkFMGJcSnd0fu4QiBrZSn54gLfmopk729cGoxAxbDs/6XG8lbcFHT1Xf02s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NEhkzqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NEhkzqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4F6C4CEF0;
	Sun,  7 Sep 2025 20:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277246;
	bh=tkmXakmziEoP90mjasiBIgW7zbsNkVCyjHNYgHP+8qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NEhkzqI/8Fjwu600jCeN5gd3rRF2v14kw42w8cQNfemu2TM7V6ON7Dml7bJIL5YJ
	 UeZz9H0KYgmnRoOibU4s+gjyhg7ZukguyzOBWDtiTlOt+C3BmIsyfD+1WnQ8SmnRYF
	 eDfkhZ6nUAJwtM2EdMZCHZmyIokNa1KssE41j72M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 129/175] md/raid1,raid10: dont handle IO error for REQ_RAHEAD and REQ_NOWAIT
Date: Sun,  7 Sep 2025 21:58:44 +0200
Message-ID: <20250907195617.904478366@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

commit 9f346f7d4ea73692b82f5102ca8698e4040469ea upstream.

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
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid1-10.c |   10 ++++++++++
 drivers/md/raid1.c    |   19 ++++++++++---------
 drivers/md/raid10.c   |   11 ++++++-----
 3 files changed, 26 insertions(+), 14 deletions(-)

--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -293,3 +293,13 @@ static inline bool raid1_should_read_fir
 
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
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -371,14 +371,16 @@ static void raid1_end_read_request(struc
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
@@ -449,16 +451,15 @@ static void raid1_end_write_request(stru
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
@@ -509,7 +510,7 @@ static void raid1_end_write_request(stru
 
 		/* Maybe we can clear some bad blocks. */
 		if (rdev_has_badblock(rdev, r1_bio->sector, r1_bio->sectors) &&
-		    !discard_error) {
+		    !ignore_error) {
 			r1_bio->bios[mirror] = IO_MADE_GOOD;
 			set_bit(R1BIO_MadeGood, &r1_bio->state);
 		}
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -398,6 +398,8 @@ static void raid10_end_read_request(stru
 		 * wait for the 'master' bio.
 		 */
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
+	} else if (!raid1_should_handle_error(bio)) {
+		uptodate = 1;
 	} else {
 		/* If all other devices that store this block have
 		 * failed, we want to return the error upwards rather
@@ -455,9 +457,8 @@ static void raid10_end_write_request(str
 	int slot, repl;
 	struct md_rdev *rdev = NULL;
 	struct bio *to_put = NULL;
-	bool discard_error;
-
-	discard_error = bio->bi_status && bio_op(bio) == REQ_OP_DISCARD;
+	bool ignore_error = !raid1_should_handle_error(bio) ||
+		(bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
 
 	dev = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
 
@@ -471,7 +472,7 @@ static void raid10_end_write_request(str
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	if (bio->bi_status && !discard_error) {
+	if (bio->bi_status && !ignore_error) {
 		if (repl)
 			/* Never record new bad blocks to replacement,
 			 * just fail it.
@@ -526,7 +527,7 @@ static void raid10_end_write_request(str
 		/* Maybe we can clear some bad blocks. */
 		if (rdev_has_badblock(rdev, r10_bio->devs[slot].addr,
 				      r10_bio->sectors) &&
-		    !discard_error) {
+		    !ignore_error) {
 			bio_put(bio);
 			if (repl)
 				r10_bio->devs[slot].repl_bio = IO_MADE_GOOD;


