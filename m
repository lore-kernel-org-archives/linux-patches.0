Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D5E3D6664;
	Fri,  4 Sep 2026 05:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498413; cv=none; b=b8fgM988s4Ln9VhhFMDd1potGG0Z7ludOv9h7hGghXCnjzTzquUIf0Vu5FBPQq9GQavKQBt92MyXFG7lHcSJkosiUU4MWpdBT+0n9H+LBLSda+ZnQD47GobFtAMfE8Df3kViRCHNPbcA/Xx2LhZMkFOVjBQNJqB/LzHYsRQh2WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498413; c=relaxed/simple;
	bh=DVHGTCRHrnyTPM/zihSZCrC/J/VovhFWc7EJ7uDaO2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lG8b/IefcBV1zd2GhY3uQXFc+yhhQSD8ybz5Aar4hOQmumV+v69URW5k6o0Sum9N5gvV2/txKGyAjbBrk7op7WlwigMyaOrDmyMlvAAbGfHhbMIV1b8FyUyK60033EkF16XAzZgHWGNlYI5LlO9ofNIhqF1afUlduzcGzTSOhvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzTV+Rtf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzTV+Rtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BA11F00A3E;
	Fri,  4 Sep 2026 05:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498411;
	bh=wZGkQA+HYDFAd0LrT/07S/JRZAy4hn6yLhhmJr55wHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DzTV+RtfdXerWGYtt7a6k4Za+G+LliwcQdgDB4T/wSoQVA+HQ0NW8Uh7H1RoXtFQb
	 I60Ygj21pPkSJdVDpzFa0DFxQRX/n2KIGcbJAU71vnObBVSG5k1pBFrG2GZxC5Lf50
	 jv0XzEYx3MNemUjlbL2WI7tMj+XL3Qdo6QBz2pbc=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 053/713] mm/kmemleak: avoid soft lockup when scanning task stacks
Date: Fri,  4 Sep 2026 06:50:21 +0200
Message-ID: <20260904045805.019857524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 5d10d4e19e6daa487f0cd0ea6cba472325de92f9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c |   51 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 13 deletions(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1697,6 +1697,42 @@ unlock_put:
 }
 
 /*
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
+/*
  * Print one leak inline. The hex dump is gated on OBJECT_ALLOCATED so it
  * does not touch user memory that was freed concurrently; the rest of the
  * report (backtrace, comm, pid) is always emitted since the kmemleak_object
@@ -1885,19 +1921,8 @@ static void kmemleak_scan(void)
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


