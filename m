Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12D98F5D
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71663C433C7;
	Thu, 31 Aug 2023 11:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693480276;
	bh=RiB5c7MpuFSEFlc5oXriBMV+fvuoY6M/dY+UTamHxKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jiw0iIOA13qW17SYzf/0/xWg0aJgnjDjHMHx6I2u/ldxik+gdZDsVdpczsTkHJjwV
	 HPzUYezRKZov4S8z6xi4aemQCV4aDWoSejIF7+oenBnrWl/Lc59vatRiMPMsWBz1Ow
	 AugQyzdo/52qHKuSLhdEvKcuWIMNZW2wXGwlChHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 5.15 9/9] rcu-tasks: Add trc_inspect_reader() checks for exiting critical section
Date: Thu, 31 Aug 2023 13:10:17 +0200
Message-ID: <20230831110830.446394288@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230831110830.039135096@linuxfoundation.org>
References: <20230831110830.039135096@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@kernel.org>

commit 18f08e758f34e6dfe0668bee51bd2af7adacf381 upstream.

Currently, trc_inspect_reader() treats a task exiting its RCU Tasks
Trace read-side critical section the same as being within that critical
section.  However, this can fail because that task might have already
checked its .need_qs field, which means that it might never decrement
the all-important trc_n_readers_need_end counter.  Of course, for that
to happen, the task would need to never again execute an RCU Tasks Trace
read-side critical section, but this really could happen if the system's
last trampoline was removed.  Note that exit from such a critical section
cannot be treated as a quiescent state due to the possibility of nested
critical sections.  This means that if trc_inspect_reader() sees a
negative nesting value, it must set up to try again later.

This commit therefore ignores tasks that are exiting their RCU Tasks
Trace read-side critical sections so that they will be rechecked later.

[ paulmck: Apply feedback from Neeraj Upadhyay and Boqun Feng. ]

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tasks.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -951,7 +951,7 @@ reset_ipi:
 static bool trc_inspect_reader(struct task_struct *t, void *arg)
 {
 	int cpu = task_cpu(t);
-	bool in_qs = false;
+	int nesting;
 	bool ofl = cpu_is_offline(cpu);
 
 	if (task_curr(t)) {
@@ -971,18 +971,18 @@ static bool trc_inspect_reader(struct ta
 		n_heavy_reader_updates++;
 		if (ofl)
 			n_heavy_reader_ofl_updates++;
-		in_qs = true;
+		nesting = 0;
 	} else {
 		// The task is not running, so C-language access is safe.
-		in_qs = likely(!t->trc_reader_nesting);
+		nesting = t->trc_reader_nesting;
 	}
 
-	// Mark as checked so that the grace-period kthread will
-	// remove it from the holdout list.
-	t->trc_reader_checked = true;
-
-	if (in_qs)
-		return true;  // Already in quiescent state, done!!!
+	// If not exiting a read-side critical section, mark as checked
+	// so that the grace-period kthread will remove it from the
+	// holdout list.
+	t->trc_reader_checked = nesting >= 0;
+	if (nesting <= 0)
+		return !nesting;  // If in QS, done, otherwise try again later.
 
 	// The task is in a read-side critical section, so set up its
 	// state so that it will awaken the grace-period kthread upon exit


