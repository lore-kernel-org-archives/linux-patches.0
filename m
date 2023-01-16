Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32A13217
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FD7C433EF;
	Mon, 16 Jan 2023 16:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886604;
	bh=NRtvAcC5rpq+NUZELtIk0LosgSPJrePE4WaYdcErAz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pw4Ki1kR7sinxYTuLuk1fds9gw0JCpUjmapkwvuuliLc1tHlya7MPwqiee8ThnOFu
	 1FEa19q4BbCgZhb0EjpzNmnYUO/snu4JlX2FEWtzsN9S67E4I9havilOwfEK65WMKG
	 wz82xMhezXev82IfyGQyth3p27kEuLOBnZ39XUDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Meng <luomeng12@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.4 494/658] dm thin: Fix UAF in run_timer_softirq()
Date: Mon, 16 Jan 2023 16:49:42 +0100
Message-Id: <20230116154932.115362322@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luo Meng <luomeng12@huawei.com>

commit 88430ebcbc0ec637b710b947738839848c20feff upstream.

When dm_resume() and dm_destroy() are concurrent, it will
lead to UAF, as follows:

 BUG: KASAN: use-after-free in __run_timers+0x173/0x710
 Write of size 8 at addr ffff88816d9490f0 by task swapper/0/0
<snip>
 Call Trace:
  <IRQ>
  dump_stack_lvl+0x73/0x9f
  print_report.cold+0x132/0xaa2
  _raw_spin_lock_irqsave+0xcd/0x160
  __run_timers+0x173/0x710
  kasan_report+0xad/0x110
  __run_timers+0x173/0x710
  __asan_store8+0x9c/0x140
  __run_timers+0x173/0x710
  call_timer_fn+0x310/0x310
  pvclock_clocksource_read+0xfa/0x250
  kvm_clock_read+0x2c/0x70
  kvm_clock_get_cycles+0xd/0x20
  ktime_get+0x5c/0x110
  lapic_next_event+0x38/0x50
  clockevents_program_event+0xf1/0x1e0
  run_timer_softirq+0x49/0x90
  __do_softirq+0x16e/0x62c
  __irq_exit_rcu+0x1fa/0x270
  irq_exit_rcu+0x12/0x20
  sysvec_apic_timer_interrupt+0x8e/0xc0

One of the concurrency UAF can be shown as below:

        use                                  free
do_resume                           |
  __find_device_hash_cell           |
    dm_get                          |
      atomic_inc(&md->holders)      |
                                    | dm_destroy
                                    |   __dm_destroy
                                    |     if (!dm_suspended_md(md))
                                    |     atomic_read(&md->holders)
                                    |     msleep(1)
  dm_resume                         |
    __dm_resume                     |
      dm_table_resume_targets       |
        pool_resume                 |
          do_waker  #add delay work |
  dm_put                            |
    atomic_dec(&md->holders)        |
                                    |     dm_table_destroy
                                    |       pool_dtr
                                    |         __pool_dec
                                    |           __pool_destroy
                                    |             destroy_workqueue
                                    |             kfree(pool) # free pool
        time out
__do_softirq
  run_timer_softirq # pool has already been freed

This can be easily reproduced using:
  1. create thin-pool
  2. dmsetup suspend pool
  3. dmsetup resume pool
  4. dmsetup remove_all # Concurrent with 3

The root cause of this UAF bug is that dm_resume() adds timer after
dm_destroy() skips cancelling the timer because of suspend status.
After timeout, it will call run_timer_softirq(), however pool has
already been freed. The concurrency UAF bug will happen.

Therefore, cancelling timer again in __pool_destroy().

Cc: stable@vger.kernel.org
Fixes: 991d9fa02da0d ("dm: add thin provisioning target")
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2931,6 +2931,8 @@ static void __pool_destroy(struct pool *
 	dm_bio_prison_destroy(pool->prison);
 	dm_kcopyd_client_destroy(pool->copier);
 
+	cancel_delayed_work_sync(&pool->waker);
+	cancel_delayed_work_sync(&pool->no_space_timeout);
 	if (pool->wq)
 		destroy_workqueue(pool->wq);
 


