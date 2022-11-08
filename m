Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6828E15CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB5CC433D6;
	Tue,  8 Nov 2022 13:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915745;
	bh=1bFuWh6Ne9uio9ieBTXTvVAx+ncIDvxbdqJuCV3t6do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qn5OLWVlbYsQ+l0unO10R+75Pt+MvHYdMue+OjUUEkJ3ssEZRz1f+82Jrf8YHwlKY
	 feVq+Ate79Tsh3wU5gmO9dKdQZRfLkkL5wyW3Rl+5yUOJ2jjvMjMPbmddkZI+NREu2
	 sUv5tncSX9kgsGw4htWx4k929AgzTAOUrTizMEPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Khazhy Kumykov <khazhy@chromium.org>
Subject: [PATCH 5.10 078/118] block, bfq: protect bfqd->queued by bfqd->lock
Date: Tue,  8 Nov 2022 14:39:16 +0100
Message-Id: <20221108133344.115822736@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

commit 181490d5321806e537dc5386db5ea640b826bf78 upstream.

If bfq_schedule_dispatch() is called from bfq_idle_slice_timer_body(),
then 'bfqd->queued' is read without holding 'bfqd->lock'. This is
wrong since it can be wrote concurrently.

Fix the problem by holding 'bfqd->lock' in such case.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20220513023507.2625717-2-yukuai3@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Khazhy Kumykov <khazhy@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bfq-iosched.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -421,6 +421,8 @@ static struct bfq_io_cq *bfq_bic_lookup(
  */
 void bfq_schedule_dispatch(struct bfq_data *bfqd)
 {
+	lockdep_assert_held(&bfqd->lock);
+
 	if (bfqd->queued != 0) {
 		bfq_log(bfqd, "schedule dispatch");
 		blk_mq_run_hw_queues(bfqd->queue, true);
@@ -6269,8 +6271,8 @@ bfq_idle_slice_timer_body(struct bfq_dat
 	bfq_bfqq_expire(bfqd, bfqq, true, reason);
 
 schedule_dispatch:
-	spin_unlock_irqrestore(&bfqd->lock, flags);
 	bfq_schedule_dispatch(bfqd);
+	spin_unlock_irqrestore(&bfqd->lock, flags);
 }
 
 /*


