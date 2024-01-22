Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D47814A4CF;
	Tue, 23 Jan 2024 00:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969232; cv=none; b=Yr2Vdb9Jkiln1YOAX00H5r8XPBVBLhjcM3SpOi55HWB3ZLiDFUFCR5Dfk85RsCJmpyhult3LOY6dncdW2HhiFu/QkOEitEZdVXuIpoDT9xFvijZHBkQAZmL/r9Y971XvtKs7374ucbYRFmtFMlvjMG+VVxb7u5rn4OU5P3UhogI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969232; c=relaxed/simple;
	bh=Aicg9KelX1bTsnSKcTHE8oxO8acJ6M3mvqCzinyRxXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvV1hUIm8FS39v8DhPqR9tT/+sR/dy9EPWMwEUmkwEDiW4iQ3AXaV5V6wDf/biadfJbwBDYXyBzQtgTNtPfamlYEh9OF2wZO+nri+tCvdGEeXfxs5O9PuucXn95FpU6OSp9CDlinucgjTKteMN+V5QO7Y/sT5EGD0sVUFUWz1VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpWHcly/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpWHcly/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CF9C433C7;
	Tue, 23 Jan 2024 00:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969232;
	bh=Aicg9KelX1bTsnSKcTHE8oxO8acJ6M3mvqCzinyRxXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpWHcly/5S0A2mdSUafQrC3be2zgR3lxVuZW5/SBzmxk/uStaZ6TkT1ozmY8ATBAj
	 i/SBdzGc8N7X9O94oBR7sZl/Ap3cyZ0A0D4HH3IQreZWfdFX6Rrj+aki3SBVwcPZLZ
	 /g1wN742VTlX9CO4TFTWulJYgcBdU9cz2YrottsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 115/641] md: synchronize flush io with array reconfiguration
Date: Mon, 22 Jan 2024 15:50:19 -0800
Message-ID: <20240122235821.642948954@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit fa2bbff7b0b4e211fec5e5686ef96350690597b5 ]

Currently rcu is used to protect iterating rdev from submit_flushes():

submit_flushes			remove_and_add_spares
				synchronize_rcu
				pers->hot_remove_disk()
 rcu_read_lock()
 rdev_for_each_rcu
  if (rdev->raid_disk >= 0)
				rdev->radi_disk = -1;
   atomic_inc(&rdev->nr_pending)
   rcu_read_unlock()
   bi = bio_alloc_bioset()
   bi->bi_end_io = md_end_flush
   bi->private = rdev
   submit_bio
   // issue io for removed rdev

Fix this problem by grabbing 'acive_io' before iterating rdev, make sure
that remove_and_add_spares() won't concurrent with submit_flushes().

Fixes: a2826aa92e2e ("md: support barrier requests on all personalities.")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20231129020234.1586910-1-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9bdd57324c37..f246bb0932b0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -543,6 +543,9 @@ static void md_end_flush(struct bio *bio)
 	rdev_dec_pending(rdev, mddev);
 
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
+		/* The pair is percpu_ref_get() from md_flush_request() */
+		percpu_ref_put(&mddev->active_io);
+
 		/* The pre-request flush has finished */
 		queue_work(md_wq, &mddev->flush_work);
 	}
@@ -562,12 +565,8 @@ static void submit_flushes(struct work_struct *ws)
 	rdev_for_each_rcu(rdev, mddev)
 		if (rdev->raid_disk >= 0 &&
 		    !test_bit(Faulty, &rdev->flags)) {
-			/* Take two references, one is dropped
-			 * when request finishes, one after
-			 * we reclaim rcu_read_lock
-			 */
 			struct bio *bi;
-			atomic_inc(&rdev->nr_pending);
+
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
 			bi = bio_alloc_bioset(rdev->bdev, 0,
@@ -578,7 +577,6 @@ static void submit_flushes(struct work_struct *ws)
 			atomic_inc(&mddev->flush_pending);
 			submit_bio(bi);
 			rcu_read_lock();
-			rdev_dec_pending(rdev, mddev);
 		}
 	rcu_read_unlock();
 	if (atomic_dec_and_test(&mddev->flush_pending))
@@ -631,6 +629,18 @@ bool md_flush_request(struct mddev *mddev, struct bio *bio)
 	/* new request after previous flush is completed */
 	if (ktime_after(req_start, mddev->prev_flush_start)) {
 		WARN_ON(mddev->flush_bio);
+		/*
+		 * Grab a reference to make sure mddev_suspend() will wait for
+		 * this flush to be done.
+		 *
+		 * md_flush_reqeust() is called under md_handle_request() and
+		 * 'active_io' is already grabbed, hence percpu_ref_is_zero()
+		 * won't pass, percpu_ref_tryget_live() can't be used because
+		 * percpu_ref_kill() can be called by mddev_suspend()
+		 * concurrently.
+		 */
+		WARN_ON(percpu_ref_is_zero(&mddev->active_io));
+		percpu_ref_get(&mddev->active_io);
 		mddev->flush_bio = bio;
 		bio = NULL;
 	}
-- 
2.43.0



