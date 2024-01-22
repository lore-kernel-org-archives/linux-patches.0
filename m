Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D3660BA2;
	Tue, 23 Jan 2024 00:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970662; cv=none; b=UrFTk4dO20SI3dx/6VaQq5pVtdlXRyAHAomtrcBLSOMlKwHCvbV/REcDvfGYU3k+A7WK/LKRz5dUmcPam5jSip7P1vICTw0jRK6CWI9U8s8eKjmUlqhhWOrMAE9RRZY9sLJBPTS8ewxEh/pl4j6NsMNpOT7b2e3bPTkWHHSbE6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970662; c=relaxed/simple;
	bh=bSRAAgiFj7LU7hybZjoJqVjHzN8vFlPvMZruz6caaHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzBLbAFAcws+JihF4u51Ff5emKpiUuo4nFM9vww/9n+HN//K5UOjzm8mLWnonlYvbVYa3OMlL//t8UUGVh5KmBuWT3kbIKCWLBQrk/4kPOS1zZHL4ejy3b0Cj7qeCCe6VkPBh+mtoCLnBUArrwQqnC0da5QbRpToWwPyO5UBUuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDWYBdYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDWYBdYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD34C433C7;
	Tue, 23 Jan 2024 00:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970662;
	bh=bSRAAgiFj7LU7hybZjoJqVjHzN8vFlPvMZruz6caaHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDWYBdYu6WOwNekoS70OXqEkjVsZ69Zw2/Tg3GB33f3FOnSXga4iSpcbH6tLuigv2
	 +YvxPobLHz+J/BCmrUhEU/WbCo119y9tIduvOLdtj4FTQxHtVBqtKHfe2Z3VXg/ESg
	 BnTUJ4zyyXgVbLCqrCPN2+Rp6trGEM1GQd4vtdnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/417] md: synchronize flush io with array reconfiguration
Date: Mon, 22 Jan 2024 15:54:10 -0800
Message-ID: <20240122235754.548853796@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0c2801d77090..6120f26a7969 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -528,6 +528,9 @@ static void md_end_flush(struct bio *bio)
 	rdev_dec_pending(rdev, mddev);
 
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
+		/* The pair is percpu_ref_get() from md_flush_request() */
+		percpu_ref_put(&mddev->active_io);
+
 		/* The pre-request flush has finished */
 		queue_work(md_wq, &mddev->flush_work);
 	}
@@ -547,12 +550,8 @@ static void submit_flushes(struct work_struct *ws)
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
@@ -563,7 +562,6 @@ static void submit_flushes(struct work_struct *ws)
 			atomic_inc(&mddev->flush_pending);
 			submit_bio(bi);
 			rcu_read_lock();
-			rdev_dec_pending(rdev, mddev);
 		}
 	rcu_read_unlock();
 	if (atomic_dec_and_test(&mddev->flush_pending))
@@ -616,6 +614,18 @@ bool md_flush_request(struct mddev *mddev, struct bio *bio)
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



