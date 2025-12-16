Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A070C3659E4;
	Tue, 16 Dec 2025 12:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887005; cv=none; b=K9pfbusz0d7RH/yGgFDD5ub2apHUqDnXnwuJiaklufhSYD0uqU+e/vJQIX9fEjO9jF2oLVUzqunNWKDoQacWmFqqPVrdd1l2W38luiQsw3wGGtrWAUFXHZmWhz7fVG/fYIC3Dn+gW1/C4QchLB+05/+GOwrH0DNRidFfZMZRZ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887005; c=relaxed/simple;
	bh=JZwsWQAfaLuITUm5o1bQ79l5Ls1LQex2EVLAvZwUBI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5HVb5eyk7xSVjvrxvhup45pLz81RZJ+GPIJF6qQiZ8BRWf5oGjx402jEV+GbNVr4NMuAhpPM+s0WMz5prUconC2kCV0Ank5tITqtTy5X3j+2jvROHhOOJagcYTG7JOjrAS4nCdyXl2kDWemC9DNpPhMyuhsyzmLybGMbHfjzGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSkxN6xL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSkxN6xL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29426C4CEF1;
	Tue, 16 Dec 2025 12:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887005;
	bh=JZwsWQAfaLuITUm5o1bQ79l5Ls1LQex2EVLAvZwUBI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSkxN6xLkH0m8/rOKzixTG6E+zV1oOKblOZjMz8FMiQR/eOIeXZtXHwf2tuEr3pFV
	 aq3bbxJqFUhkujDxrek6Vdg7b2UNcCiJyjZpuYHUwCgQOm3aUwDkR3yn0gZsl5h2QJ
	 LTXOjZ4vp7DkeOakffSyEhPP8RBFn/jT+bayDuhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai@kernel.org>,
	chengkaitao <chengkaitao@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/614] block/mq-deadline: Introduce dd_start_request()
Date: Tue, 16 Dec 2025 12:07:12 +0100
Message-ID: <20251216111403.669413590@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 93a358af59c6e8ab00b57cfdb1c437516a4948ca ]

Prepare for adding a second caller of this function. No functionality
has been changed.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Yu Kuai <yukuai@kernel.org>
Cc: chengkaitao <chengkaitao@kylinos.cn>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d60055cf5270 ("block/mq-deadline: Switch back to a single dispatch list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/mq-deadline.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 3e741d33142d3..647a45f6d9352 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -306,6 +306,19 @@ static bool started_after(struct deadline_data *dd, struct request *rq,
 	return time_after(start_time, latest_start);
 }
 
+static struct request *dd_start_request(struct deadline_data *dd,
+					enum dd_data_dir data_dir,
+					struct request *rq)
+{
+	u8 ioprio_class = dd_rq_ioclass(rq);
+	enum dd_prio prio = ioprio_class_to_prio[ioprio_class];
+
+	dd->per_prio[prio].latest_pos[data_dir] = blk_rq_pos(rq);
+	dd->per_prio[prio].stats.dispatched++;
+	rq->rq_flags |= RQF_STARTED;
+	return rq;
+}
+
 /*
  * deadline_dispatch_requests selects the best request according to
  * read/write expire, fifo_batch, etc and with a start time <= @latest_start.
@@ -316,8 +329,6 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
 {
 	struct request *rq, *next_rq;
 	enum dd_data_dir data_dir;
-	enum dd_prio prio;
-	u8 ioprio_class;
 
 	lockdep_assert_held(&dd->lock);
 
@@ -411,12 +422,7 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd,
 	dd->batching++;
 	deadline_move_request(dd, per_prio, rq);
 done:
-	ioprio_class = dd_rq_ioclass(rq);
-	prio = ioprio_class_to_prio[ioprio_class];
-	dd->per_prio[prio].latest_pos[data_dir] = blk_rq_pos(rq);
-	dd->per_prio[prio].stats.dispatched++;
-	rq->rq_flags |= RQF_STARTED;
-	return rq;
+	return dd_start_request(dd, data_dir, rq);
 }
 
 /*
-- 
2.51.0



