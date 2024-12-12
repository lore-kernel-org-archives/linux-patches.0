Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8B7209693;
	Thu, 12 Dec 2024 15:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016541; cv=none; b=a2JjFCA9aEaOYdV8GpXpf1AHu1sGJfiSB5DOoKwI3W4C/1FitU9lSf7NHpyOBSs5dyA4IdhlVWB+gWnYSg8CZ2jIRFREuW9LUhBl7hPOp/Rfa0gnC1DWCnlsKm6ZTsnPKps2O1kKJllVzBoVbCe09WHt4/feWgTrCjE5bIyu81s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016541; c=relaxed/simple;
	bh=xjTA1wxwZnrpVsGUyL/egYn7JZazkPO6B0Dkpxzduik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLpYu1LPDMycyqGq5tdi4ZhM40+kYgjRRlxdjW4+32S///Hi2f/vThhJBGhXzidkOhDnhn4Llz6Ol5RTBEKZdHPLGLZauijreCXkY8zT3rzE8qYxvqcYoR0WQpwjJNlJUh7vHYxGTPuq81M/NEU4gvwkIAjhurm7mKYboiX4v50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMdvbcR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMdvbcR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DFDC4CECE;
	Thu, 12 Dec 2024 15:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016541;
	bh=xjTA1wxwZnrpVsGUyL/egYn7JZazkPO6B0Dkpxzduik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMdvbcR/J1OWzla7tSxEoErhG2mljMiKYFByU6G8DpvVDlrOLke3ENfeeHxDT9QJX
	 5JRpqU7NIatHrXRvhUSLhqpybGVmynJc/asYa+gtzsrJEuwa51RC80sE/o+MZAkZva
	 iomMzPGv5D3taIvDfPwnnu/rTw6MeOdsyaA6YjmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Huang <ahuang12@lenovo.com>,
	Jiwei Sun <sunjw10@lenovo.com>,
	Raghavendra K T <raghavendra.kt@amd.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 197/466] sched/numa: fix memory leak due to the overwritten vma->numab_state
Date: Thu, 12 Dec 2024 15:56:06 +0100
Message-ID: <20241212144314.577551609@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Huang <ahuang12@lenovo.com>

commit 5f1b64e9a9b7ee9cfd32c6b2fab796e29bfed075 upstream.

[Problem Description]
When running the hackbench program of LTP, the following memory leak is
reported by kmemleak.

  # /opt/ltp/testcases/bin/hackbench 20 thread 1000
  Running with 20*40 (== 800) tasks.

  # dmesg | grep kmemleak
  ...
  kmemleak: 480 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
  kmemleak: 665 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

  # cat /sys/kernel/debug/kmemleak
  unreferenced object 0xffff888cd8ca2c40 (size 64):
    comm "hackbench", pid 17142, jiffies 4299780315
    hex dump (first 32 bytes):
      ac 74 49 00 01 00 00 00 4c 84 49 00 01 00 00 00  .tI.....L.I.....
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace (crc bff18fd4):
      [<ffffffff81419a89>] __kmalloc_cache_noprof+0x2f9/0x3f0
      [<ffffffff8113f715>] task_numa_work+0x725/0xa00
      [<ffffffff8110f878>] task_work_run+0x58/0x90
      [<ffffffff81ddd9f8>] syscall_exit_to_user_mode+0x1c8/0x1e0
      [<ffffffff81dd78d5>] do_syscall_64+0x85/0x150
      [<ffffffff81e0012b>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
  ...

This issue can be consistently reproduced on three different servers:
  * a 448-core server
  * a 256-core server
  * a 192-core server

[Root Cause]
Since multiple threads are created by the hackbench program (along with
the command argument 'thread'), a shared vma might be accessed by two or
more cores simultaneously. When two or more cores observe that
vma->numab_state is NULL at the same time, vma->numab_state will be
overwritten.

Although current code ensures that only one thread scans the VMAs in a
single 'numa_scan_period', there might be a chance for another thread
to enter in the next 'numa_scan_period' while we have not gotten till
numab_state allocation [1].

Note that the command `/opt/ltp/testcases/bin/hackbench 50 process 1000`
cannot the reproduce the issue. It is verified with 200+ test runs.

[Solution]
Use the cmpxchg atomic operation to ensure that only one thread executes
the vma->numab_state assignment.

[1] https://lore.kernel.org/lkml/1794be3c-358c-4cdc-a43d-a1f841d91ef7@amd.com/

Link: https://lkml.kernel.org/r/20241113102146.2384-1-ahuang12@lenovo.com
Fixes: ef6a22b70f6d ("sched/numa: apply the scan delay to every new vma")
Signed-off-by: Adrian Huang <ahuang12@lenovo.com>
Reported-by: Jiwei Sun <sunjw10@lenovo.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Ben Segall <bsegall@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3399,10 +3399,16 @@ retry_pids:
 
 		/* Initialise new per-VMA NUMAB state. */
 		if (!vma->numab_state) {
-			vma->numab_state = kzalloc(sizeof(struct vma_numab_state),
-				GFP_KERNEL);
-			if (!vma->numab_state)
+			struct vma_numab_state *ptr;
+
+			ptr = kzalloc(sizeof(*ptr), GFP_KERNEL);
+			if (!ptr)
+				continue;
+
+			if (cmpxchg(&vma->numab_state, NULL, ptr)) {
+				kfree(ptr);
 				continue;
+			}
 
 			vma->numab_state->start_scan_seq = mm->numa_scan_seq;
 


