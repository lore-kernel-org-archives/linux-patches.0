Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80459171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0B7C433D2;
	Mon,  8 May 2023 11:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545941;
	bh=DqRIY7AlUMq82zJimec+NmPhiKIzNHVI3ZZ+SZAOrck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rif/lNZpiYMMjGfaNI2CF0f4YupYzrtyZ55WfiUVr1HtSeXPGr91JIVIIeviYBCyF
	 1b5j+T1EvYfB/2OS/y3ZcmeNHIk4tVS74MeUwkWR1jo8dwyOa0KWBJMr59fPCxnTSL
	 Fc78fw4Q4HlNuCYST2xfGl1QN7e992mHtx/tIKHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Logan Gunthorpe <logang@deltatee.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 205/371] md/raid10: factor out code from wait_barrier() to stop_waiting_barrier()
Date: Mon,  8 May 2023 11:46:46 +0200
Message-Id: <20230508094820.223956655@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit ed2e063f92c44c891ccd883e289dde6ca870edcc ]

Currently the nasty condition in wait_barrier() is hard to read. This
patch factors out the condition into a function.

There are no functional changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Song Liu <song@kernel.org>
Stable-dep-of: 72c215ed8731 ("md/raid10: fix task hung in raid10d")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 50 +++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 287bebde2e546..31ecb080851ac 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -952,41 +952,47 @@ static void lower_barrier(struct r10conf *conf)
 	wake_up(&conf->wait_barrier);
 }
 
+static bool stop_waiting_barrier(struct r10conf *conf)
+{
+	struct bio_list *bio_list = current->bio_list;
+
+	/* barrier is dropped */
+	if (!conf->barrier)
+		return true;
+
+	/*
+	 * If there are already pending requests (preventing the barrier from
+	 * rising completely), and the pre-process bio queue isn't empty, then
+	 * don't wait, as we need to empty that queue to get the nr_pending
+	 * count down.
+	 */
+	if (atomic_read(&conf->nr_pending) && bio_list &&
+	    (!bio_list_empty(&bio_list[0]) || !bio_list_empty(&bio_list[1])))
+		return true;
+
+	/* move on if recovery thread is blocked by us */
+	if (conf->mddev->thread->tsk == current &&
+	    test_bit(MD_RECOVERY_RUNNING, &conf->mddev->recovery) &&
+	    conf->nr_queued > 0)
+		return true;
+
+	return false;
+}
+
 static bool wait_barrier(struct r10conf *conf, bool nowait)
 {
 	bool ret = true;
 
 	spin_lock_irq(&conf->resync_lock);
 	if (conf->barrier) {
-		struct bio_list *bio_list = current->bio_list;
 		conf->nr_waiting++;
-		/* Wait for the barrier to drop.
-		 * However if there are already pending
-		 * requests (preventing the barrier from
-		 * rising completely), and the
-		 * pre-process bio queue isn't empty,
-		 * then don't wait, as we need to empty
-		 * that queue to get the nr_pending
-		 * count down.
-		 */
 		/* Return false when nowait flag is set */
 		if (nowait) {
 			ret = false;
 		} else {
 			raid10_log(conf->mddev, "wait barrier");
 			wait_event_lock_irq(conf->wait_barrier,
-					    !conf->barrier ||
-					    (atomic_read(&conf->nr_pending) &&
-					     bio_list &&
-					     (!bio_list_empty(&bio_list[0]) ||
-					      !bio_list_empty(&bio_list[1]))) ||
-					     /* move on if recovery thread is
-					      * blocked by us
-					      */
-					     (conf->mddev->thread->tsk == current &&
-					      test_bit(MD_RECOVERY_RUNNING,
-						       &conf->mddev->recovery) &&
-					      conf->nr_queued > 0),
+					    stop_waiting_barrier(conf),
 					    conf->resync_lock);
 		}
 		conf->nr_waiting--;
-- 
2.39.2



