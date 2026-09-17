Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CA44EF143;
	Thu, 17 Sep 2026 16:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663929; cv=none; b=ezlHdNtn9F4odY4iGPUBMi+hNUdAvIDUv8SSZt6fAO7lscAo4+s4XS0qMsEyreDe3O6iQXo2qE/jJ55p7n4d4X0h6z654jXcept6X6GR50OiclevGr6mEJFk83derTLxkjAE+6VcP4rOQijDCxwqWrslBKof7vuHHMSm/oWUbEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663929; c=relaxed/simple;
	bh=DRhUuVpQUTFPT8YGItDckfWK3Sqbo3m30FVLaJylgF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQV3FUDe9qoPeAdd2iRr8ikm58XOl1vglrmdUOYwU06hPWOF5OL18Lsn5WwGoWe6BKDJgS4k74axnLAy/nTfe3HtKNGpoh5znU2673qEIA+LNLQ/S4gF2UR2QoAWtN3P+mkrTbmWxxbfvz4YlFsNAqh8Q/cu+4RCgdx5FJR8p3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzmEfnA9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzmEfnA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A251F000FF;
	Thu, 17 Sep 2026 16:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663927;
	bh=u4n/bZYpag6MICsRemFrytPVlaZRWKrXqfVtfI5Upd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UzmEfnA9rTbiVjKKLF2jrnbQmh0utcph//IXVx+V8zsyo2dIVZRgD0Cksq8+WotNb
	 6yVXBT2SkLjnhf8YX+sf6hULZK6dN4lYmQrqfQwG0lwSzXO3/W171dlZTOsiT2A4DZ
	 NUKmqcQXmJhIYxuyfYu70IO2CgpGX3Bun/1NJQs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang@linux.dev>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0200/1250] rcu-tasks: Fix possible boot-time tests failed for the call_rcu_tasks()
Date: Thu, 17 Sep 2026 15:59:55 +0100
Message-ID: <20260917151557.541228868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Zqiang <qiang.zhang@linux.dev>

[ Upstream commit 42c5468f9cdc0c892fec3c0916b3ac5b670775af ]

The following scenarios will cause the call_rcu_tasks() boot-time
tests failed:

                     CPU0								CPU1

rcu_init_tasks_generic()
->rcu_tasks_initiate_self_tests()
  ->call_rcu_tasks_trace(&tests[1].rh, test_rcu_tasks_callback)
    ->call_rcu_tasks_generic()
      ->havekthread = smp_load_acquire(&rtp->kthread_ptr)
       "The havekthread is false"
    ....
								       rcu_tasks_kthread()
								       ->smp_store_release(&rtp->kthread_ptr, current)
								         ->rcu_tasks_one_gp()
								           ->rcuwait_wait_event()
								             ->rcu_tasks_need_gpcb()
								               ->for (cpu = 0; cpu < dequeue_limit; cpu++)
								                 ->rcu_segcblist_n_cbs(&rtpcp->cblist) == 0
								           ->schedule()

     ->raw_spin_trylock_rcu_node()
     ->needwake = (func == wakeme_after_rcu) ||
     (rcu_segcblist_n_cbs(&rtpcp->cblist) == rcu_task_lazy_lim)

       "the rcu_task_lazy_lim default value is 32, and the
        func pointer is test_rcu_tasks_callback, lead to needwake
        is false."

     ->if (havekthread && !needwake && !timer_pending(&rtpcp->lazy_timer))
        "the havekthread is false, will not enter here."
     ....

        "the needwake is false lead to rtp_irq_work can not queue,
         even if the rtp->kthread_ptr already exists at this point."

      ->if (needwake && READ_ONCE(rtp->kthread_ptr))
        ->irq_work_queue(&rtpcp->rtp_irq_work)

For the above scenarios, if the call_rcu_tasks() is not called again
afterward, the rcu_tasks_kthread will not have a chance to be wakeup,
the test_rcu_tasks_callback() will never be called, the boot-time tests
failed can happen, this commit therefore check havekthread variable, if
it's false and the rtpcp->cblist is empty, set needwake variable is true,
if the rtp->kthread_ptr exist, the rtpcp->rtp_irq_work can be queued to
wakeup rcu_tasks_kthread.

Signed-off-by: Zqiang <qiang.zhang@linux.dev>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 2dc044fd126eb..2aa5589f0b8bf 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -377,7 +377,8 @@ static void call_rcu_tasks_generic(struct rcu_head *rhp, rcu_callback_t func,
 	// Queuing callbacks before initialization not yet supported.
 	if (WARN_ON_ONCE(!rcu_segcblist_is_enabled(&rtpcp->cblist)))
 		rcu_segcblist_init(&rtpcp->cblist);
-	needwake = (func == wakeme_after_rcu) ||
+	needwake = (!havekthread && rcu_segcblist_empty(&rtpcp->cblist)) ||
+		   (func == wakeme_after_rcu) ||
 		   (rcu_segcblist_n_cbs(&rtpcp->cblist) == rcu_task_lazy_lim);
 	if (havekthread && !needwake && !timer_pending(&rtpcp->lazy_timer)) {
 		if (rtp->lazy_jiffies)
-- 
2.53.0



