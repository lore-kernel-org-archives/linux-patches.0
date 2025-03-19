Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D1B18C322;
	Wed, 19 Mar 2025 14:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394840; cv=none; b=W32LIW0d7zi5XnKt4yGq4lM47Kg28OFwJghU8F28vfPmwfzY0aEwIAa2TguMj5OzZYIqbLHcFwSgvc8zTMenchf7GPkKH2j1xURCMQM7oELtf4rwyqanMXbWXStfDLjeIL7GeX9RZ2fkm1PDYn7RSX3a1KRWdTevliv14qbNYsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394840; c=relaxed/simple;
	bh=o9Fv8FOwOe+iaurStz/htY5RcqPD8APuv40oX98JFso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0VNSZrM+ZZ6a5j449Rw7U7d9HIXXzgs+FuoC1nkAtLDAcpSZ3HGTsUuzIbRUZiE2nkRPh90wes+jnPC2g5z2B6jkokI3mML3CALHyMMjs/M43DXi26wI4nPZTUAQRErgkw/PbBqyfJJ6sOjRO2tHqW7I0O25noLSVFbA6hRjJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0X1AsDjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0X1AsDjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7886C4CEE4;
	Wed, 19 Mar 2025 14:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394839;
	bh=o9Fv8FOwOe+iaurStz/htY5RcqPD8APuv40oX98JFso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0X1AsDjM4iCwpOvQQ2UoASWBMggYDYThyYiut3GSj3XK0gvXUqDFV0rtRdA9SQcYc
	 tj3paBEVJvwGmgAkWg9wLlTxeOAYYUtDl1BjkgkVuOip143bUr+cc2boh1BmrQGaV7
	 +WwSc6PPQYFlOjQruk+9kmtUbSg8qWnFDCkiphj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.13 003/241] mm/slab/kvfree_rcu: Switch to WQ_MEM_RECLAIM wq
Date: Wed, 19 Mar 2025 07:27:53 -0700
Message-ID: <20250319143027.780388921@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uladzislau Rezki (Sony) <urezki@gmail.com>

commit dfd3df31c9db752234d7d2e09bef2aeabb643ce4 upstream.

Currently kvfree_rcu() APIs use a system workqueue which is
"system_unbound_wq" to driver RCU machinery to reclaim a memory.

Recently, it has been noted that the following kernel warning can
be observed:

<snip>
workqueue: WQ_MEM_RECLAIM nvme-wq:nvme_scan_work is flushing !WQ_MEM_RECLAIM events_unbound:kfree_rcu_work
  WARNING: CPU: 21 PID: 330 at kernel/workqueue.c:3719 check_flush_dependency+0x112/0x120
  Modules linked in: intel_uncore_frequency(E) intel_uncore_frequency_common(E) skx_edac(E) ...
  CPU: 21 UID: 0 PID: 330 Comm: kworker/u144:6 Tainted: G            E      6.13.2-0_g925d379822da #1
  Hardware name: Wiwynn Twin Lakes MP/Twin Lakes Passive MP, BIOS YMM20 02/01/2023
  Workqueue: nvme-wq nvme_scan_work
  RIP: 0010:check_flush_dependency+0x112/0x120
  Code: 05 9a 40 14 02 01 48 81 c6 c0 00 00 00 48 8b 50 18 48 81 c7 c0 00 00 00 48 89 f9 48 ...
  RSP: 0018:ffffc90000df7bd8 EFLAGS: 00010082
  RAX: 000000000000006a RBX: ffffffff81622390 RCX: 0000000000000027
  RDX: 00000000fffeffff RSI: 000000000057ffa8 RDI: ffff88907f960c88
  RBP: 0000000000000000 R08: ffffffff83068e50 R09: 000000000002fffd
  R10: 0000000000000004 R11: 0000000000000000 R12: ffff8881001a4400
  R13: 0000000000000000 R14: ffff88907f420fb8 R15: 0000000000000000
  FS:  0000000000000000(0000) GS:ffff88907f940000(0000) knlGS:0000000000000000
  CR2: 00007f60c3001000 CR3: 000000107d010005 CR4: 00000000007726f0
  PKRU: 55555554
  Call Trace:
   <TASK>
   ? __warn+0xa4/0x140
   ? check_flush_dependency+0x112/0x120
   ? report_bug+0xe1/0x140
   ? check_flush_dependency+0x112/0x120
   ? handle_bug+0x5e/0x90
   ? exc_invalid_op+0x16/0x40
   ? asm_exc_invalid_op+0x16/0x20
   ? timer_recalc_next_expiry+0x190/0x190
   ? check_flush_dependency+0x112/0x120
   ? check_flush_dependency+0x112/0x120
   __flush_work.llvm.1643880146586177030+0x174/0x2c0
   flush_rcu_work+0x28/0x30
   kvfree_rcu_barrier+0x12f/0x160
   kmem_cache_destroy+0x18/0x120
   bioset_exit+0x10c/0x150
   disk_release.llvm.6740012984264378178+0x61/0xd0
   device_release+0x4f/0x90
   kobject_put+0x95/0x180
   nvme_put_ns+0x23/0xc0
   nvme_remove_invalid_namespaces+0xb3/0xd0
   nvme_scan_work+0x342/0x490
   process_scheduled_works+0x1a2/0x370
   worker_thread+0x2ff/0x390
   ? pwq_release_workfn+0x1e0/0x1e0
   kthread+0xb1/0xe0
   ? __kthread_parkme+0x70/0x70
   ret_from_fork+0x30/0x40
   ? __kthread_parkme+0x70/0x70
   ret_from_fork_asm+0x11/0x20
   </TASK>
  ---[ end trace 0000000000000000 ]---
<snip>

To address this switch to use of independent WQ_MEM_RECLAIM
workqueue, so the rules are not violated from workqueue framework
point of view.

Apart of that, since kvfree_rcu() does reclaim memory it is worth
to go with WQ_MEM_RECLAIM type of wq because it is designed for
this purpose.

Fixes: 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()"),
Reported-by: Keith Busch <kbusch@kernel.org>
Closes: https://lore.kernel.org/all/Z7iqJtCjHKfo8Kho@kbusch-mbp/
Cc: stable@vger.kernel.org
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tree.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3191,6 +3191,8 @@ void call_rcu(struct rcu_head *head, rcu
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
+static struct workqueue_struct *rcu_reclaim_wq;
+
 /* Maximum number of jiffies to wait before draining a batch. */
 #define KFREE_DRAIN_JIFFIES (5 * HZ)
 #define KFREE_N_BATCHES 2
@@ -3519,10 +3521,10 @@ __schedule_delayed_monitor_work(struct k
 	if (delayed_work_pending(&krcp->monitor_work)) {
 		delay_left = krcp->monitor_work.timer.expires - jiffies;
 		if (delay < delay_left)
-			mod_delayed_work(system_unbound_wq, &krcp->monitor_work, delay);
+			mod_delayed_work(rcu_reclaim_wq, &krcp->monitor_work, delay);
 		return;
 	}
-	queue_delayed_work(system_unbound_wq, &krcp->monitor_work, delay);
+	queue_delayed_work(rcu_reclaim_wq, &krcp->monitor_work, delay);
 }
 
 static void
@@ -3620,7 +3622,7 @@ kvfree_rcu_queue_batch(struct kfree_rcu_
 			// "free channels", the batch can handle. Break
 			// the loop since it is done with this CPU thus
 			// queuing an RCU work is _always_ success here.
-			queued = queue_rcu_work(system_unbound_wq, &krwp->rcu_work);
+			queued = queue_rcu_work(rcu_reclaim_wq, &krwp->rcu_work);
 			WARN_ON_ONCE(!queued);
 			break;
 		}
@@ -3708,7 +3710,7 @@ run_page_cache_worker(struct kfree_rcu_c
 	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING &&
 			!atomic_xchg(&krcp->work_in_progress, 1)) {
 		if (atomic_read(&krcp->backoff_page_cache_fill)) {
-			queue_delayed_work(system_unbound_wq,
+			queue_delayed_work(rcu_reclaim_wq,
 				&krcp->page_cache_work,
 					msecs_to_jiffies(rcu_delay_page_cache_fill_msec));
 		} else {
@@ -5654,6 +5656,10 @@ static void __init kfree_rcu_batch_init(
 	int i, j;
 	struct shrinker *kfree_rcu_shrinker;
 
+	rcu_reclaim_wq = alloc_workqueue("kvfree_rcu_reclaim",
+			WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	WARN_ON(!rcu_reclaim_wq);
+
 	/* Clamp it to [0:100] seconds interval. */
 	if (rcu_delay_page_cache_fill_msec < 0 ||
 		rcu_delay_page_cache_fill_msec > 100 * MSEC_PER_SEC) {


