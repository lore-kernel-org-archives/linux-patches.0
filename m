Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AF92D787;
	Fri, 24 Nov 2023 18:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sf1adV/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3667C433C8;
	Fri, 24 Nov 2023 18:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851254;
	bh=fP4AmtSQSVpgiXc7Fmzl34G1Jzz3kEZVVaaYyw/qbgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sf1adV/r9PwkWJaR3br522QbRb3C4QtnP2SAmyQ7hJ9mVc7AtVSWhpDkC26PrBBaA
	 LmDdkG9gb7vdh9PhXnH6rYCPdTyb5CkjWTe1L+Ua5+x6udvjxLQqrFGvaeDZqJ6Dpv
	 1Gbs2TuWhIjd8swk+Oy/0CSOvxtzectfOnjapI4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	kernel-team@android.com,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	John Stultz <jstultz@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 374/491] torture: Add lock_torture writer_fifo module parameter
Date: Fri, 24 Nov 2023 17:50:10 +0000
Message-ID: <20231124172035.822803455@linuxfoundation.org>
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

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

[ Upstream commit 5d248bb39fe1388943acb6510f8f48fa5570e0ec ]

This commit adds a module parameter that causes the locktorture writer
to run at real-time priority.

To use it:
insmod /lib/modules/torture.ko random_shuffle=1
insmod /lib/modules/locktorture.ko torture_type=mutex_lock rt_boost=1 rt_boost_factor=50 nested_locks=3 writer_fifo=1
													^^^^^^^^^^^^^

A predecessor to this patch has been helpful to uncover issues with the
proxy-execution series.

[ paulmck: Remove locktorture-specific code from kernel/torture.c. ]

Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: kernel-team@android.com
Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
[jstultz: Include header change to build, reword commit message]
Signed-off-by: John Stultz <jstultz@google.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Stable-dep-of: cca42bd8eb1b ("rcutorture: Fix stuttering races and other issues")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  4 ++++
 kernel/locking/locktorture.c                    | 12 +++++++-----
 kernel/torture.c                                |  3 ++-
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b951b4c2808f1..5711129686d10 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2938,6 +2938,10 @@
 	locktorture.torture_type= [KNL]
 			Specify the locking implementation to test.
 
+	locktorture.writer_fifo= [KNL]
+			Run the write-side locktorture kthreads at
+			sched_set_fifo() real-time priority.
+
 	locktorture.verbose= [KNL]
 			Enable additional printk() statements.
 
diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index 949d3deae5062..270c7f80ce84c 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -45,6 +45,7 @@ torture_param(int, stutter, 5, "Number of jiffies to run/halt test, 0=disable");
 torture_param(int, rt_boost, 2,
 		   "Do periodic rt-boost. 0=Disable, 1=Only for rt_mutex, 2=For all lock types.");
 torture_param(int, rt_boost_factor, 50, "A factor determining how often rt-boost happens.");
+torture_param(int, writer_fifo, 0, "Run writers at sched_set_fifo() priority");
 torture_param(int, verbose, 1, "Enable verbose debugging printk()s");
 torture_param(int, nested_locks, 0, "Number of nested locks (max = 8)");
 /* Going much higher trips "BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low!" errors */
@@ -809,7 +810,8 @@ static int lock_torture_writer(void *arg)
 	bool skip_main_lock;
 
 	VERBOSE_TOROUT_STRING("lock_torture_writer task started");
-	set_user_nice(current, MAX_NICE);
+	if (!rt_task(current))
+		set_user_nice(current, MAX_NICE);
 
 	do {
 		if ((torture_random(&rand) & 0xfffff) == 0)
@@ -1015,8 +1017,7 @@ static void lock_torture_cleanup(void)
 
 	if (writer_tasks) {
 		for (i = 0; i < cxt.nrealwriters_stress; i++)
-			torture_stop_kthread(lock_torture_writer,
-					     writer_tasks[i]);
+			torture_stop_kthread(lock_torture_writer, writer_tasks[i]);
 		kfree(writer_tasks);
 		writer_tasks = NULL;
 	}
@@ -1244,8 +1245,9 @@ static int __init lock_torture_init(void)
 			goto create_reader;
 
 		/* Create writer. */
-		firsterr = torture_create_kthread(lock_torture_writer, &cxt.lwsa[i],
-						  writer_tasks[i]);
+		firsterr = torture_create_kthread_cb(lock_torture_writer, &cxt.lwsa[i],
+						     writer_tasks[i],
+						     writer_fifo ? sched_set_fifo : NULL);
 		if (torture_init_error(firsterr))
 			goto unwind;
 
diff --git a/kernel/torture.c b/kernel/torture.c
index 1da48f3816f61..e06b03e987c9f 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -37,6 +37,7 @@
 #include <linux/ktime.h>
 #include <asm/byteorder.h>
 #include <linux/torture.h>
+#include <linux/sched/rt.h>
 #include "rcu/rcu.h"
 
 MODULE_LICENSE("GPL");
@@ -728,7 +729,7 @@ bool stutter_wait(const char *title)
 	cond_resched_tasks_rcu_qs();
 	spt = READ_ONCE(stutter_pause_test);
 	for (; spt; spt = READ_ONCE(stutter_pause_test)) {
-		if (!ret) {
+		if (!ret && !rt_task(current)) {
 			sched_set_normal(current, MAX_NICE);
 			ret = true;
 		}
-- 
2.42.0



