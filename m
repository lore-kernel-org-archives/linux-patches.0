Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775010;
	b=by+svn5/2QFXnz11YTZN0/B7NTXgTCVa9Afsu+PDDbL8vkpo2bvsmaAftUVtD0y1Kacq
	 3kPH8f/lPuxR/K6lMc4N2c+QQN5hav9oJ99roSjpy9x95iQZ8NNxws2tBpZpgYYghW2Y5
	 yeZag1DdOMud5t3K1n3WYHyBPGJr/ROSAKboo4PSw/JBJBX1V94/hZ+8QnT+q7JKy/aLX
	 fE/9Z4a5ttDT27HtZvBB55uieNiKDs9xv1qqeqYXLmCPyukaJY+yTUmYYUpe4BGvBbGC2
	 BPFk5o8oqzTuOG7DLXMo7yDQ2+Nelk+WITIIvtwvcRcAeVgm1oYRDihdPWN8x6WKcng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WuU+zrH9jGDA8Gnuitj7VFrdNDAbuHSJxGI5/c5iJ8M=;
	b=3FddjHVAN2uH5fPwlXkwYMKFM6TRIYLmLsK/5SiGpidp7ZP5P6brSRj09KQq1h2bzi4A
	 nJd+h5d83EkNhhp9KDLr2hlCPogpRm3CjFqvMbCx+Gai0zZMtX7SCxIrBqOSB/n0vfGM6
	 rU1KApQ9pmwXRJ/cmpFVMG9qjl6vwvoEu7Irxkp5N7mxQWhT9IZZ4MjFiht2zqIBAdt+a
	 b9IuF8urgtxYnJEa1RMgT3beTMZvIFvL8tl5jVm5xRVMWcCY+GtiW/JxMKvQSedXzdGIw
	 wGRqrq4r7AoknOyYE6KtJL1+9h5DTBCO+S0aYnEmMN6+6uxfoon0kT3XzZc/0j7Jttw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qOpZAuJT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78423606A31A;
	Fri, 23 Oct 2026 17:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qOpZAuJT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59D81F01825;
	Fri, 23 Oct 2026 17:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775010;
	bh=WuU+zrH9jGDA8Gnuitj7VFrdNDAbuHSJxGI5/c5iJ8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qOpZAuJTvhCjn/ZsyuPBQsHzHn9iB/JzdFII5ieGmMz+CLPnVeYawpNXADvhRvI6M
	 zoWJvIGanb1DeErNPfGkaQCLXXJgbzYnoDEkEDLBDgmU8VfgkcIphCn8YcelkLdbJn
	 Sl5IcaKChQA5SdtNQ/Qy+8NJo/5AYXbCq2xTutUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiangyu Bu <xbu@meta.com>,
	Tejun Heo <tj@kernel.org>,
	Dan Schatzberg <schatzberg.dan@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 231/242] sched_ext: Fix stall when a task enqueued with SCX_ENQ_LAST lands back on its CPUs local DSQ
Date: Fri, 23 Oct 2026 18:41:13 +0200
Message-ID: <20261023163719.309120412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 7a9df76679633cf26e0fea882a684012c6ec245a ]

With SCX_OPS_ENQ_LAST, the last runnable task on a CPU is passed to
ops.enqueue() instead of being kept running. Exiting tasks without
SCX_OPS_ENQ_EXITING, migration disabled tasks without
SCX_OPS_ENQ_MIGRATION_DISABLED and tasks on an offline rq skip ops.enqueue()
and go straight to the local DSQ. This happens in put_prev_task_scx() after
the pick has settled on idle, so nothing reschedules the CPU, which idles
with the task queued until an unrelated wakeup lands on it or the watchdog
fires.

scx_mitosis, which sets SCX_OPS_ENQ_LAST without SCX_OPS_ENQ_EXITING, hit
this during mass cgroup teardown: exiting tasks stuck in exit_mmap() for
over 40 seconds.

A task put on the local DSQ runs, as anywhere else. If the SCX_ENQ_LAST
enqueue left the task on this CPU's local DSQ, set need_resched on the task
being switched in, as proxy_resched_idle() does. resched_curr() would flag
the task being put instead, and __schedule() clears that right after the
pick.

Fixes: f0e1a0643a59 ("sched_ext: Implement BPF extensible scheduler class")
Cc: stable@vger.kernel.org # v6.12+
Reported-by: Xiangyu Bu <xbu@meta.com>
Link: https://github.com/sched-ext/scx/pull/3870
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>
[ sashal: Adjusted context to use do_enqueue_task() without the upstream CPU-capability condition. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c      |   13 +++++++++++--
 kernel/sched/ext/internal.h |    5 +++--
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -3169,8 +3169,7 @@ static void put_prev_task_scx(struct rq
 		/*
 		 * If @p is runnable but we're about to enter a lower
 		 * sched_class, %SCX_OPS_ENQ_LAST must be set. Tell
-		 * ops.enqueue() that @p is the only one available for this cpu,
-		 * which should trigger an explicit follow-up scheduling event.
+		 * ops.enqueue() that @p is the only one available for this cpu.
 		 *
 		 * Under core scheduling, a pick dispatches only when nothing is
 		 * locally runnable and can legitimately go idle with @p still
@@ -3180,6 +3179,16 @@ static void put_prev_task_scx(struct rq
 			WARN_ON_ONCE(!sched_core_enabled(rq) &&
 				     !(sch->ops.flags & SCX_OPS_ENQ_LAST));
 			do_enqueue_task(rq, p, SCX_ENQ_LAST, -1);
+
+			/*
+			 * A task put on the local DSQ runs, as anywhere else.
+			 * Here the insert can't reschedule on its own: the pick
+			 * has settled on @next and @p is still curr, so
+			 * resched_curr() would flag @p and __schedule() clears
+			 * that right after the pick. Flag @next instead.
+			 */
+			if (p->scx.dsq == &rq->scx.local_dsq)
+				set_tsk_need_resched(next);
 		} else {
 			do_enqueue_task(rq, p, 0, -1);
 		}
--- a/kernel/sched/ext/internal.h
+++ b/kernel/sched/ext/internal.h
@@ -1291,8 +1291,9 @@ enum scx_enq_flags {
 	 * %SCX_OPS_ENQ_LAST is specified, they're ops.enqueue()'d with the
 	 * %SCX_ENQ_LAST flag set.
 	 *
-	 * The BPF scheduler is responsible for triggering a follow-up
-	 * scheduling event. Otherwise, Execution may stall.
+	 * If the task is queued on the local DSQ of the CPU it was running on,
+	 * it continues to run. Otherwise, the CPU goes idle. A scheduler that
+	 * wants a full dispatch cycle on the CPU should kick it.
 	 */
 	SCX_ENQ_LAST		= 1LLU << 41,
 


