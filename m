Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C386D1C5F0C;
	Wed, 19 Feb 2025 09:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955925; cv=none; b=rYw7vBYpT7BeM9fJzP0SnwBW7v770irFPvzi7JZ/t6VGQpI2Is4qRCkHPHZ42k8NfrIqpjKUQo1oifeNYZ/uPV31f4IH9PYK8aaN9jP0Sv7UT9kkjh/HSwEdpYXwBn+nJxpgtqxbqUYPT34APY0yLEVwSv2XBk+KXYtxFsxHgZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955925; c=relaxed/simple;
	bh=WYV4mEHEhHBlcWG6GeihYOtnhFndqxuReuybcn/qI0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AO7U1DoYOKEsRhAQktCegEnS/IYwRTv68r+i6kUmotYvF/hDONCMgHKfn3POy5PfnNjdbwsqR2LTtE2cVfzMYRzSXbFEk7nZntTeGnj+ufenhdclbZKgUBIK90EcsmyEKRWv6cC0nW2ji7nQA65JBIFL8zVSe2S3hrjX+5Lm2Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2X5AcHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2X5AcHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467E8C4CED1;
	Wed, 19 Feb 2025 09:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955925;
	bh=WYV4mEHEhHBlcWG6GeihYOtnhFndqxuReuybcn/qI0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2X5AcHDe9hXhrtGXfu54bhW7dy6W3doIVUjPZjVkP/4X7wxOs1RML+2h87V/u0dw
	 3dznmGUK+Ju7OnoePX9O2zLOHQmY2bH9J8Zl9HC23LwfE51TGBHL01Q2p+5gsabZuG
	 7r/gCvR9vjEoUFt+lS49BzwfN6OOeOPoN6C1xmQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 6.6 138/152] md/raid5: recheck if reshape has finished with device_lock held
Date: Wed, 19 Feb 2025 09:29:11 +0100
Message-ID: <20250219082555.504840734@linuxfoundation.org>
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

From: Benjamin Marzinski <bmarzins@redhat.com>

commit 25b3a8237a03ec0b67b965b52d74862e77ef7115 upstream.

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
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |   64 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 23 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5972,6 +5972,39 @@ static bool reshape_disabled(struct mdde
 	return is_md_suspended(mddev) || !md_is_rdwr(mddev);
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
@@ -5986,28 +6019,14 @@ static enum stripe_result make_stripe_re
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
@@ -6189,8 +6208,7 @@ static bool raid5_make_request(struct md
 	/* Bail out if conflicts with reshape and REQ_NOWAIT is set */
 	if ((bi->bi_opf & REQ_NOWAIT) &&
 	    (conf->reshape_progress != MaxSector) &&
-	    !ahead_of_reshape(mddev, logical_sector, conf->reshape_progress) &&
-	    ahead_of_reshape(mddev, logical_sector, conf->reshape_safe)) {
+	    get_reshape_loc(mddev, conf, logical_sector) == LOC_INSIDE_RESHAPE) {
 		bio_wouldblock_error(bi);
 		if (rw == WRITE)
 			md_write_end(mddev);


