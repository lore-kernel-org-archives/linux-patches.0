Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709562FC4E;
	Fri, 24 Nov 2023 18:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drC92lWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DC7C433C8;
	Fri, 24 Nov 2023 18:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850822;
	bh=v2vbjk7o2HfObRc444hpGl3FxNHXt9zHjaRIzsQzKjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=drC92lWLMGkMTWCHLa77o1jHhiUaIANEMOJaUUBaPVT/UxsZRjT1ehxgfjJMoFVzm
	 Gwr02PNtsHT3jN9qp5MEZ1sV+RVpyULkSbSUIX6jt3pQTpNHXie6Cel8sHjnK4He1n
	 YlZPPkctS4Uc7Xvm+l3GgyZtF2fioUxtYrSbi3nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 203/491] io_uring/fdinfo: remove need for sqpoll lock for thread/pid retrieval
Date: Fri, 24 Nov 2023 17:47:19 +0000
Message-ID: <20231124172030.605064494@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit a0d45c3f596be53c1bd8822a1984532d14fdcea9 ]

A previous commit added a trylock for getting the SQPOLL thread info via
fdinfo, but this introduced a regression where we often fail to get it if
the thread is busy. For that case, we end up not printing the current CPU
and PID info.

Rather than rely on this lock, just print the pid we already stored in
the io_sq_data struct, and ensure we update the current CPU every time
we've slept or potentially rescheduled. The latter won't potentially be
100% accurate, but that wasn't the case before either as the task can
get migrated at any time unless it has been pinned at creation time.

We retain keeping the io_sq_data dereference inside the ctx->uring_lock,
as it has always been, as destruction of the thread and data happen below
that. We could make this RCU safe, but there's little point in doing that.

With this, we always print the last valid information we had, rather than
have spurious outputs with missing information.

Fixes: 7644b1a1c9a7 ("io_uring/fdinfo: lock SQ thread while retrieving thread cpu/pid")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/fdinfo.c |  9 ++-------
 io_uring/sqpoll.c | 12 ++++++++++--
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index b603a06f7103d..5fcfe03ed93ec 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -139,13 +139,8 @@ static __cold void __io_uring_show_fdinfo(struct io_ring_ctx *ctx,
 	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
 		struct io_sq_data *sq = ctx->sq_data;
 
-		if (mutex_trylock(&sq->lock)) {
-			if (sq->thread) {
-				sq_pid = task_pid_nr(sq->thread);
-				sq_cpu = task_cpu(sq->thread);
-			}
-			mutex_unlock(&sq->lock);
-		}
+		sq_pid = sq->task_pid;
+		sq_cpu = sq->sq_cpu;
 	}
 
 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index bd6c2c7959a5b..65b5dbe3c850e 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -214,6 +214,7 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
 			did_sig = get_signal(&ksig);
 		cond_resched();
 		mutex_lock(&sqd->lock);
+		sqd->sq_cpu = raw_smp_processor_id();
 	}
 	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 }
@@ -229,10 +230,15 @@ static int io_sq_thread(void *data)
 	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);
 
-	if (sqd->sq_cpu != -1)
+	/* reset to our pid after we've set task_comm, for fdinfo */
+	sqd->task_pid = current->pid;
+
+	if (sqd->sq_cpu != -1) {
 		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
-	else
+	} else {
 		set_cpus_allowed_ptr(current, cpu_online_mask);
+		sqd->sq_cpu = raw_smp_processor_id();
+	}
 
 	mutex_lock(&sqd->lock);
 	while (1) {
@@ -261,6 +267,7 @@ static int io_sq_thread(void *data)
 				mutex_unlock(&sqd->lock);
 				cond_resched();
 				mutex_lock(&sqd->lock);
+				sqd->sq_cpu = raw_smp_processor_id();
 			}
 			continue;
 		}
@@ -294,6 +301,7 @@ static int io_sq_thread(void *data)
 				mutex_unlock(&sqd->lock);
 				schedule();
 				mutex_lock(&sqd->lock);
+				sqd->sq_cpu = raw_smp_processor_id();
 			}
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				atomic_andnot(IORING_SQ_NEED_WAKEUP,
-- 
2.42.0



