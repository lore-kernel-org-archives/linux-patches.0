Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184FB3A1E92;
	Sat, 17 Oct 2026 17:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259791; cv=none; b=UoElSBnZchRpLKXrGKbLwyjtFCuXISUATJ4CVXCE2G7W5AktneDvy4901j1x963+dJVAz98kbNcji0Q4AZdf/GQNpEe/EomjJSywePEJ5iFjEQKIg23K7W+9RAYRzocx5Y5uB1ktgi5O3C1SBF1+zxMvq2udqgymm3zsu/LwTLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259791; c=relaxed/simple;
	bh=jriZ5Ciu3hYlfNorsTaRL7SI6eTxLWzcN/+tk5KlHjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOJQ66Uocv26dCVCTJJXWEpsvJGzs9y1BtcFNVk/KY9GuYIXT011sR6ZBIGZHADZtDy9isVByzjXxRyiDMC1MkayBA2pDPkI4NIts6AuM3Ri39zwavGvJ1epJESEo4vTbyxgWH5ep850ZAr7IlRTlfvUsIxcPaXZ4LmWW4zFAmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DfgAo8Dw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DfgAo8Dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFBF1F000C4;
	Sat, 17 Oct 2026 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259790;
	bh=EKaLV9jRXgFmNEWC9OFaufRq+JSryBhbjDOWO1/Nh+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DfgAo8DwNgJJalbsjt3uSyXTPg8HSH5VqV1g9sXom7KUdP+lLDE3QEd3lC5u3KOB8
	 uI5Q0CzEgTizLtWTafPqPQj7HZMiJyI5DKDU0m7rxFUHHhysB4tjuyfIQgFCJFvTWz
	 ME8KKXWUD4+JAVFo69h5nVnFra3Ynu9aSjk6Apm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Lance Yang <lance.yang@linux.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Qian Cai <cai@lca.pw>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1332/1674] mm/kmemleak: avoid soft lockup when scanning task stacks
Date: Sat, 17 Oct 2026 18:00:04 +0200
Message-ID: <20261017160505.336851220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 5d10d4e19e6daa487f0cd0ea6cba472325de92f9 ]

Patch series "mm/kmemleak: avoid soft lockup when scanning task", v3.

kmemleak_scan() scans every task stack under one rcu_read_lock() with no
reschedule point, which can trip the soft lockup watchdog on hosts with
very many threads.

That prints the following message, depending on the workload+host
configuration:

      watchdog: BUG: soft lockup - CPU#35 stuck for 22s! [kmemleak:537]
       scan_block
       kmemleak_scan
       kmemleak_scan_thread
       kthread

Patch 1 walks the tasks with find_ge_pid() so the scan reschedules between
tasks

Patches 2-3 let the scan loops stop early once a scan is interrupted.

This patch (of 3):

kmemleak_scan() walks every thread and scans its kernel stack under a
single rcu_read_lock() with no reschedule point.  On a host with very many
threads -- amplified by KASAN/lockdep in debug builds -- this loop can hog
a CPU long enough to trip the soft lockup watchdog:

  watchdog: BUG: soft lockup - CPU#35 stuck for 22s! [kmemleak:537]
   scan_block
   kmemleak_scan
   kmemleak_scan_thread
   kthread

A cond_resched() cannot be added directly: the loop runs inside an RCU
read-side critical section.

Walk the tasks one PID at a time with find_ge_pid(), taking the RCU read
lock only to look up and pin each task.  The stack is then scanned with no
lock held, so cond_resched() runs between tasks and the scan stops early
on scan_should_stop().  This follows the next_tgid()/task_seq_get_next()
iteration pattern and keeps each RCU critical section short.

Link: https://lore.kernel.org/20260615-kmemleak-stack-resched-v3-0-acecd7d7fd92@debian.org
Link: https://lore.kernel.org/20260615-kmemleak-stack-resched-v3-1-acecd7d7fd92@debian.org
Fixes: c4b28963fd79 ("mm/kmemleak: rely on rcu for task stack scanning")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Qian Cai <cai@lca.pw>
Cc: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kmemleak.c | 51 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 13 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index e2e41de55c02b..fceb28690f2fc 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1516,6 +1516,42 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
 	put_object(object);
 }
 
+/*
+ * Scan all task kernel stacks, rescheduling between tasks. Each task is looked
+ * up and pinned within its own RCU read-side section, so no lock is held across
+ * the scan and the walk cannot trip the soft lockup watchdog.
+ */
+static void kmemleak_scan_task_stacks(void)
+{
+	struct pid *pid;
+	int nr = 1;
+
+	do {
+		struct task_struct *p = NULL;
+
+		rcu_read_lock();
+		pid = find_ge_pid(nr, &init_pid_ns);
+		if (pid) {
+			nr = pid_nr(pid) + 1;
+			p = pid_task(pid, PIDTYPE_PID);
+			if (p)
+				get_task_struct(p);
+		}
+		rcu_read_unlock();
+
+		if (p) {
+			void *stack = try_get_task_stack(p);
+
+			if (stack) {
+				scan_block(stack, stack + THREAD_SIZE, NULL);
+				put_task_stack(p);
+			}
+			put_task_struct(p);
+		}
+		cond_resched();
+	} while (pid && !scan_should_stop());
+}
+
 /*
  * Scan data sections and all the referenced memory blocks allocated via the
  * kernel's standard allocators. This function must be called with the
@@ -1607,19 +1643,8 @@ static void kmemleak_scan(void)
 	/*
 	 * Scanning the task stacks (may introduce false negatives).
 	 */
-	if (kmemleak_stack_scan) {
-		struct task_struct *p, *g;
-
-		rcu_read_lock();
-		for_each_process_thread(g, p) {
-			void *stack = try_get_task_stack(p);
-			if (stack) {
-				scan_block(stack, stack + THREAD_SIZE, NULL);
-				put_task_stack(p);
-			}
-		}
-		rcu_read_unlock();
-	}
+	if (kmemleak_stack_scan)
+		kmemleak_scan_task_stacks();
 
 	/*
 	 * Scan the objects already referenced from the sections scanned
-- 
2.53.0



