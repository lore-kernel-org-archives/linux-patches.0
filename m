Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD675FDB4;
	Tue, 23 Jan 2024 01:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974642; cv=none; b=mISXch/udi1zFPxFb9CGiXuA5aRvJWZdg3WSY8xfgOvwqaHK7BmJofRHGaiClQitkPhOmZ/gotay06zDA4cdxHu6ZhWnhG+tjy74dEWovO2lDaYTkJB8r6VdUpmGGEhJdRFJcSBFq/B8cMbwjugCthdwuf2423cGIFjPDLIeSyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974642; c=relaxed/simple;
	bh=kV8NaC1iUrXG1DQiGUY43zHHpgWdCoYpXK3hpj+gJ3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBfINwYB1pn+krlIuLyk0nQnece6M6O5qFjLUsvUJZxZJP+WZTNX5NuCOOcl1bbLM9l8SwkIDMshbRo90YBR8qMWXuB6OtN0eCtIpDW4Qmt+sbpfBmMjjSigBfxGlG9OjKsTyK1ynq+GcZslTL1WChd7xCiEKjZ3PyBRK6e6J2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QcsS0gnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcsS0gnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AA9C433C7;
	Tue, 23 Jan 2024 01:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974642;
	bh=kV8NaC1iUrXG1DQiGUY43zHHpgWdCoYpXK3hpj+gJ3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QcsS0gnuVGxZ2HrMAvJtvh7NOvI5BzC31kf4/8yxopd8ke6axzNMJ0KJYrzDL2BtT
	 LbijZddJAcexyYn0bJt92bu99WxHA0jILJQrik+6x1Z3jWT0+72VtbUjIuZDJjFo6o
	 rqiL44j8nPqZ/ENJCNHqlOSsSYptxrqcNxGYi4eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/583] md: synchronize flush io with array reconfiguration
Date: Mon, 22 Jan 2024 15:52:33 -0800
Message-ID: <20240122235815.295828336@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b2ef6af8376a..8c40c1c3959c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -494,6 +494,9 @@ static void md_end_flush(struct bio *bio)
 	rdev_dec_pending(rdev, mddev);
 
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
+		/* The pair is percpu_ref_get() from md_flush_request() */
+		percpu_ref_put(&mddev->active_io);
+
 		/* The pre-request flush has finished */
 		queue_work(md_wq, &mddev->flush_work);
 	}
@@ -513,12 +516,8 @@ static void submit_flushes(struct work_struct *ws)
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
@@ -529,7 +528,6 @@ static void submit_flushes(struct work_struct *ws)
 			atomic_inc(&mddev->flush_pending);
 			submit_bio(bi);
 			rcu_read_lock();
-			rdev_dec_pending(rdev, mddev);
 		}
 	rcu_read_unlock();
 	if (atomic_dec_and_test(&mddev->flush_pending))
@@ -582,6 +580,18 @@ bool md_flush_request(struct mddev *mddev, struct bio *bio)
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



