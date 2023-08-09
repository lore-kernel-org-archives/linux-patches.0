Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA7715AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8713C433C7;
	Wed,  9 Aug 2023 10:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578080;
	bh=DlxghmVUkJR6OMqrDqh0R4b8BolZSyiTuUNxst6EnHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0V2a2F0+lm/UD0CTmIibET+IT8KCJX6Bn7+nabofvKh4MS8NuzGa80pkfGZ0rxeu
	 KzOPahI/FxXi5vlY6vSxBnrXYyvQjLB9jnz1VxVWBjUPnUhH0Tu7oVdw2P7pSkCZ6m
	 BYuO7+ed5J+kKb7ebIG6I6OO4InChXBh3IifSQ9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Pu Lehui <pulehui@huawei.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 069/165] bpf, cpumap: Make sure kthread is running before map update returns
Date: Wed,  9 Aug 2023 12:40:00 +0200
Message-ID: <20230809103645.066020813@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 640a604585aa30f93e39b17d4d6ba69fcb1e66c9 ]

The following warning was reported when running stress-mode enabled
xdp_redirect_cpu with some RT threads:

  ------------[ cut here ]------------
  WARNING: CPU: 4 PID: 65 at kernel/bpf/cpumap.c:135
  CPU: 4 PID: 65 Comm: kworker/4:1 Not tainted 6.5.0-rc2+ #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
  Workqueue: events cpu_map_kthread_stop
  RIP: 0010:put_cpu_map_entry+0xda/0x220
  ......
  Call Trace:
   <TASK>
   ? show_regs+0x65/0x70
   ? __warn+0xa5/0x240
   ......
   ? put_cpu_map_entry+0xda/0x220
   cpu_map_kthread_stop+0x41/0x60
   process_one_work+0x6b0/0xb80
   worker_thread+0x96/0x720
   kthread+0x1a5/0x1f0
   ret_from_fork+0x3a/0x70
   ret_from_fork_asm+0x1b/0x30
   </TASK>

The root cause is the same as commit 436901649731 ("bpf: cpumap: Fix memory
leak in cpu_map_update_elem"). The kthread is stopped prematurely by
kthread_stop() in cpu_map_kthread_stop(), and kthread() doesn't call
cpu_map_kthread_run() at all but XDP program has already queued some
frames or skbs into ptr_ring. So when __cpu_map_ring_cleanup() checks
the ptr_ring, it will find it was not emptied and report a warning.

An alternative fix is to use __cpu_map_ring_cleanup() to drop these
pending frames or skbs when kthread_stop() returns -EINTR, but it may
confuse the user, because these frames or skbs have been handled
correctly by XDP program. So instead of dropping these frames or skbs,
just make sure the per-cpu kthread is running before
__cpu_map_entry_alloc() returns.

After apply the fix, the error handle for kthread_stop() will be
unnecessary because it will always return 0, so just remove it.

Fixes: 6710e1126934 ("bpf: introduce new bpf cpu map type BPF_MAP_TYPE_CPUMAP")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://lore.kernel.org/r/20230729095107.1722450-2-houtao@huaweicloud.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cpumap.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 6ae02be7a48e3..7eeb200251640 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/workqueue.h>
 #include <linux/kthread.h>
+#include <linux/completion.h>
 #include <trace/events/xdp.h>
 #include <linux/btf_ids.h>
 
@@ -73,6 +74,7 @@ struct bpf_cpu_map_entry {
 	struct rcu_head rcu;
 
 	struct work_struct kthread_stop_wq;
+	struct completion kthread_running;
 };
 
 struct bpf_cpu_map {
@@ -153,7 +155,6 @@ static void put_cpu_map_entry(struct bpf_cpu_map_entry *rcpu)
 static void cpu_map_kthread_stop(struct work_struct *work)
 {
 	struct bpf_cpu_map_entry *rcpu;
-	int err;
 
 	rcpu = container_of(work, struct bpf_cpu_map_entry, kthread_stop_wq);
 
@@ -163,14 +164,7 @@ static void cpu_map_kthread_stop(struct work_struct *work)
 	rcu_barrier();
 
 	/* kthread_stop will wake_up_process and wait for it to complete */
-	err = kthread_stop(rcpu->kthread);
-	if (err) {
-		/* kthread_stop may be called before cpu_map_kthread_run
-		 * is executed, so we need to release the memory related
-		 * to rcpu.
-		 */
-		put_cpu_map_entry(rcpu);
-	}
+	kthread_stop(rcpu->kthread);
 }
 
 static void cpu_map_bpf_prog_run_skb(struct bpf_cpu_map_entry *rcpu,
@@ -298,11 +292,11 @@ static int cpu_map_bpf_prog_run(struct bpf_cpu_map_entry *rcpu, void **frames,
 	return nframes;
 }
 
-
 static int cpu_map_kthread_run(void *data)
 {
 	struct bpf_cpu_map_entry *rcpu = data;
 
+	complete(&rcpu->kthread_running);
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	/* When kthread gives stop order, then rcpu have been disconnected
@@ -467,6 +461,7 @@ __cpu_map_entry_alloc(struct bpf_map *map, struct bpf_cpumap_val *value,
 		goto free_ptr_ring;
 
 	/* Setup kthread */
+	init_completion(&rcpu->kthread_running);
 	rcpu->kthread = kthread_create_on_node(cpu_map_kthread_run, rcpu, numa,
 					       "cpumap/%d/map:%d", cpu,
 					       map->id);
@@ -480,6 +475,12 @@ __cpu_map_entry_alloc(struct bpf_map *map, struct bpf_cpumap_val *value,
 	kthread_bind(rcpu->kthread, cpu);
 	wake_up_process(rcpu->kthread);
 
+	/* Make sure kthread has been running, so kthread_stop() will not
+	 * stop the kthread prematurely and all pending frames or skbs
+	 * will be handled by the kthread before kthread_stop() returns.
+	 */
+	wait_for_completion(&rcpu->kthread_running);
+
 	return rcpu;
 
 free_prog:
-- 
2.40.1



