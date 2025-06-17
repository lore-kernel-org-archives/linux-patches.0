Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707012E8DE7;
	Tue, 17 Jun 2025 16:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176943; cv=none; b=gLAS8ohMpxXiDtaco1PlaRCzLRNqP8Xc3uGViyc2IHYW3XpqFppTVVXSwDfi4f6A3b2sQEpoQanWQiPUIe/li6Vs21kAxHPeV30KLfhs/Y2p4VtPwfF72zU19TJeSDpFA7EZ6JBRG8VacUgBvVX8bKn7H7JVLUEjJUWfaKPY8Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176943; c=relaxed/simple;
	bh=qZGmtcy/+bTqCqNx9f/cKXWUZXNVkHnKIOhCphNEgv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/mJkYxCWtYdgNqwvGr9YJXdzIHQ5/WBq0EELlZOqiFbN4SV0ew8LNX+SFu0x0NyUNWMskPKl1C9JKxJTZYFrSohrn6crrVNv9Bsjjl3GGfs4NABzOs+jLz7o7dyczmQZ5sDpifDPlmtdjiAbVgWqIG8dvma/KrVOfZyC4N7hbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zcz79ekB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zcz79ekB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20FAC4CEE3;
	Tue, 17 Jun 2025 16:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176943;
	bh=qZGmtcy/+bTqCqNx9f/cKXWUZXNVkHnKIOhCphNEgv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zcz79ekBCywHn27kgqQohYWjfg7yN+HGPdSiiBe9kXplKnL4IytjcO69rKW0IS8IT
	 FXhHZeATl31/ZArt7AwhwWXBJ5J38Gv7xjzr2tcXF81kTpwAJ5bgLy4KwihXmdxeyM
	 GStQmx/wkky/kOD8+VfbGlQwyx35OtFWyJHsWP+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 282/512] dm-flakey: make corrupting read bios work
Date: Tue, 17 Jun 2025 17:24:08 +0200
Message-ID: <20250617152431.023267272@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 13e79076c89f6e96a6cca8f6df38b40d025907b4 ]

dm-flakey corrupts the read bios in the endio function.  However, the
corrupt_bio_* functions checked bio_has_data() to see if there was data
to corrupt. Since this was the endio function, there was no data left to
complete, so bio_has_data() was always false. Fix this by saving a copy
of the bio's bi_iter in flakey_map(), and using this to initialize the
iter for corrupting the read bios. This patch also skips cloning the bio
for write bios with no data.

Reported-by: Kent Overstreet <kent.overstreet@linux.dev>
Fixes: a3998799fb4df ("dm flakey: add corrupt_bio_byte feature")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-flakey.c | 54 ++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 806a80dd3bd9b..347881f323d5b 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -47,7 +47,8 @@ enum feature_flag_bits {
 };
 
 struct per_bio_data {
-	bool bio_submitted;
+	bool bio_can_corrupt;
+	struct bvec_iter saved_iter;
 };
 
 static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
@@ -339,7 +340,8 @@ static void flakey_map_bio(struct dm_target *ti, struct bio *bio)
 }
 
 static void corrupt_bio_common(struct bio *bio, unsigned int corrupt_bio_byte,
-			       unsigned char corrupt_bio_value)
+			       unsigned char corrupt_bio_value,
+			       struct bvec_iter start)
 {
 	struct bvec_iter iter;
 	struct bio_vec bvec;
@@ -348,7 +350,7 @@ static void corrupt_bio_common(struct bio *bio, unsigned int corrupt_bio_byte,
 	 * Overwrite the Nth byte of the bio's data, on whichever page
 	 * it falls.
 	 */
-	bio_for_each_segment(bvec, bio, iter) {
+	__bio_for_each_segment(bvec, bio, iter, start) {
 		if (bio_iter_len(bio, iter) > corrupt_bio_byte) {
 			unsigned char *segment = bvec_kmap_local(&bvec);
 			segment[corrupt_bio_byte] = corrupt_bio_value;
@@ -357,36 +359,31 @@ static void corrupt_bio_common(struct bio *bio, unsigned int corrupt_bio_byte,
 				"(rw=%c bi_opf=%u bi_sector=%llu size=%u)\n",
 				bio, corrupt_bio_value, corrupt_bio_byte,
 				(bio_data_dir(bio) == WRITE) ? 'w' : 'r', bio->bi_opf,
-				(unsigned long long)bio->bi_iter.bi_sector,
-				bio->bi_iter.bi_size);
+				(unsigned long long)start.bi_sector,
+				start.bi_size);
 			break;
 		}
 		corrupt_bio_byte -= bio_iter_len(bio, iter);
 	}
 }
 
-static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
+static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc,
+			     struct bvec_iter start)
 {
 	unsigned int corrupt_bio_byte = fc->corrupt_bio_byte - 1;
 
-	if (!bio_has_data(bio))
-		return;
-
-	corrupt_bio_common(bio, corrupt_bio_byte, fc->corrupt_bio_value);
+	corrupt_bio_common(bio, corrupt_bio_byte, fc->corrupt_bio_value, start);
 }
 
-static void corrupt_bio_random(struct bio *bio)
+static void corrupt_bio_random(struct bio *bio, struct bvec_iter start)
 {
 	unsigned int corrupt_byte;
 	unsigned char corrupt_value;
 
-	if (!bio_has_data(bio))
-		return;
-
-	corrupt_byte = get_random_u32() % bio->bi_iter.bi_size;
+	corrupt_byte = get_random_u32() % start.bi_size;
 	corrupt_value = get_random_u8();
 
-	corrupt_bio_common(bio, corrupt_byte, corrupt_value);
+	corrupt_bio_common(bio, corrupt_byte, corrupt_value, start);
 }
 
 static void clone_free(struct bio *clone)
@@ -481,7 +478,7 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 	unsigned int elapsed;
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
 
-	pb->bio_submitted = false;
+	pb->bio_can_corrupt = false;
 
 	if (op_is_zone_mgmt(bio_op(bio)))
 		goto map_bio;
@@ -490,10 +487,11 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 	elapsed = (jiffies - fc->start_time) / HZ;
 	if (elapsed % (fc->up_interval + fc->down_interval) >= fc->up_interval) {
 		bool corrupt_fixed, corrupt_random;
-		/*
-		 * Flag this bio as submitted while down.
-		 */
-		pb->bio_submitted = true;
+
+		if (bio_has_data(bio)) {
+			pb->bio_can_corrupt = true;
+			pb->saved_iter = bio->bi_iter;
+		}
 
 		/*
 		 * Error reads if neither corrupt_bio_byte or drop_writes or error_writes are set.
@@ -516,6 +514,8 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 			return DM_MAPIO_SUBMITTED;
 		}
 
+		if (!pb->bio_can_corrupt)
+			goto map_bio;
 		/*
 		 * Corrupt matching writes.
 		 */
@@ -535,9 +535,11 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 			struct bio *clone = clone_bio(ti, fc, bio);
 			if (clone) {
 				if (corrupt_fixed)
-					corrupt_bio_data(clone, fc);
+					corrupt_bio_data(clone, fc,
+							 clone->bi_iter);
 				if (corrupt_random)
-					corrupt_bio_random(clone);
+					corrupt_bio_random(clone,
+							   clone->bi_iter);
 				submit_bio(clone);
 				return DM_MAPIO_SUBMITTED;
 			}
@@ -559,21 +561,21 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 	if (op_is_zone_mgmt(bio_op(bio)))
 		return DM_ENDIO_DONE;
 
-	if (!*error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
+	if (!*error && pb->bio_can_corrupt && (bio_data_dir(bio) == READ)) {
 		if (fc->corrupt_bio_byte) {
 			if ((fc->corrupt_bio_rw == READ) &&
 			    all_corrupt_bio_flags_match(bio, fc)) {
 				/*
 				 * Corrupt successful matching READs while in down state.
 				 */
-				corrupt_bio_data(bio, fc);
+				corrupt_bio_data(bio, fc, pb->saved_iter);
 			}
 		}
 		if (fc->random_read_corrupt) {
 			u64 rnd = get_random_u64();
 			u32 rem = do_div(rnd, PROBABILITY_BASE);
 			if (rem < fc->random_read_corrupt)
-				corrupt_bio_random(bio);
+				corrupt_bio_random(bio, pb->saved_iter);
 		}
 		if (test_bit(ERROR_READS, &fc->flags)) {
 			/*
-- 
2.39.5



