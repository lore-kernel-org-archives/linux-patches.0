Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2358A1F3B96;
	Mon, 23 Jun 2025 21:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714500; cv=none; b=JMfaMaH7TxBXhwVEKlDTBYTvbLMjDf0t/XMp8OJ39P7gJV+36Yma7OBAVhh9BTEAz+Kpxmjpo3hAqpnmYJHO9bUkiJ8m+dfL6rOwjGloKkGysEXDGPkjiF4qOqgyufmvmCKkRU8ctcUZQs3KH9mvVSwUP+3+qbpg5ET/kEnq4+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714500; c=relaxed/simple;
	bh=iRNeCOvvBWUTdlqU7QPmbCNypsxsrt2UYghwkCQ2aNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0AtT57FY5hWQVlZaTfwR5ZQCTWKopwQ2FSoNKIq2YeUleB4X4l7vKEmkIJdHw9MRJbVYdY4Er9MM1GUJI9EcCi4W4ZDjv8hoLzAwIo9/28FonrZ/NmV7qXvPG6esM1BPtPXwhGSOE1l/YF/sXGW3r9R0cXeDADinYMqJwDZqEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHeKjBic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHeKjBic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABE3C4CEEA;
	Mon, 23 Jun 2025 21:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714499;
	bh=iRNeCOvvBWUTdlqU7QPmbCNypsxsrt2UYghwkCQ2aNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHeKjBicwkWYu7ZS2xMuqkxfyHdoIO3ySewy8etawRU/x2k5gMoUJyHIqLycoiMl5
	 9B+FmxU/ALa45Tuf5ZtffDMEXmiEb6uegphO1Sr/NG8WeU4L1bxUAd4gRHBLkCC1gt
	 lAZ36dbhB2qIZbcKz97fOhajYnZpTL8mPpraCPIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun@huaweicloud.com>,
	"Nysal Jan K.A." <nysal@linux.ibm.com>,
	Doug Anderson <dianders@chromium.org>,
	Joel Granados <joel.granados@kernel.org>,
	Song Liu <song@kernel.org>,
	Thomas Gleinxer <tglx@linutronix.de>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 115/414] watchdog: fix watchdog may detect false positive of softlockup
Date: Mon, 23 Jun 2025 15:04:12 +0200
Message-ID: <20250623130644.958450645@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Gengkun <luogengkun@huaweicloud.com>

commit 7123dbbef88cfd9f09e8a7899b0911834600cfa3 upstream.

When updating `watchdog_thresh`, there is a race condition between writing
the new `watchdog_thresh` value and stopping the old watchdog timer.  If
the old timer triggers during this window, it may falsely detect a
softlockup due to the old interval and the new `watchdog_thresh` value
being used.  The problem can be described as follow:

 # We asuume previous watchdog_thresh is 60, so the watchdog timer is
 # coming every 24s.
echo 10 > /proc/sys/kernel/watchdog_thresh (User space)
|
+------>+ update watchdog_thresh (We are in kernel now)
	|
	|	  # using old interval and new `watchdog_thresh`
	+------>+ watchdog hrtimer (irq context: detect softlockup)
		|
		|
	+-------+
	|
	|
	+ softlockup_stop_all

To fix this problem, introduce a shadow variable for `watchdog_thresh`.
The update to the actual `watchdog_thresh` is delayed until after the old
timer is stopped, preventing false positives.

The following testcase may help to understand this problem.

---------------------------------------------
echo RT_RUNTIME_SHARE > /sys/kernel/debug/sched/features
echo -1 > /proc/sys/kernel/sched_rt_runtime_us
echo 0 > /sys/kernel/debug/sched/fair_server/cpu3/runtime
echo 60 > /proc/sys/kernel/watchdog_thresh
taskset -c 3 chrt -r 99 /bin/bash -c "while true;do true; done" &
echo 10 > /proc/sys/kernel/watchdog_thresh &
---------------------------------------------

The test case above first removes the throttling restrictions for
real-time tasks.  It then sets watchdog_thresh to 60 and executes a
real-time task ,a simple while(1) loop, on cpu3.  Consequently, the final
command gets blocked because the presence of this real-time thread
prevents kworker:3 from being selected by the scheduler.  This eventually
triggers a softlockup detection on cpu3 due to watchdog_timer_fn operating
with inconsistent variable - using both the old interval and the updated
watchdog_thresh simultaneously.

[nysal@linux.ibm.com: fix the SOFTLOCKUP_DETECTOR=n case]
  Link: https://lkml.kernel.org/r/20250502111120.282690-1-nysal@linux.ibm.com
Link: https://lkml.kernel.org/r/20250421035021.3507649-1-luogengkun@huaweicloud.com
Signed-off-by: Luo Gengkun <luogengkun@huaweicloud.com>
Signed-off-by: Nysal Jan K.A. <nysal@linux.ibm.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "Nysal Jan K.A." <nysal@linux.ibm.com>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/watchdog.c |   41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -47,6 +47,7 @@ int __read_mostly watchdog_user_enabled
 static int __read_mostly watchdog_hardlockup_user_enabled = WATCHDOG_HARDLOCKUP_DEFAULT;
 static int __read_mostly watchdog_softlockup_user_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
+static int __read_mostly watchdog_thresh_next;
 static int __read_mostly watchdog_hardlockup_available;
 
 struct cpumask watchdog_cpumask __read_mostly;
@@ -863,12 +864,20 @@ int lockup_detector_offline_cpu(unsigned
 	return 0;
 }
 
-static void __lockup_detector_reconfigure(void)
+static void __lockup_detector_reconfigure(bool thresh_changed)
 {
 	cpus_read_lock();
 	watchdog_hardlockup_stop();
 
 	softlockup_stop_all();
+	/*
+	 * To prevent watchdog_timer_fn from using the old interval and
+	 * the new watchdog_thresh at the same time, which could lead to
+	 * false softlockup reports, it is necessary to update the
+	 * watchdog_thresh after the softlockup is completed.
+	 */
+	if (thresh_changed)
+		watchdog_thresh = READ_ONCE(watchdog_thresh_next);
 	set_sample_period();
 	lockup_detector_update_enable();
 	if (watchdog_enabled && watchdog_thresh)
@@ -881,7 +890,7 @@ static void __lockup_detector_reconfigur
 void lockup_detector_reconfigure(void)
 {
 	mutex_lock(&watchdog_mutex);
-	__lockup_detector_reconfigure();
+	__lockup_detector_reconfigure(false);
 	mutex_unlock(&watchdog_mutex);
 }
 
@@ -901,27 +910,29 @@ static __init void lockup_detector_setup
 		return;
 
 	mutex_lock(&watchdog_mutex);
-	__lockup_detector_reconfigure();
+	__lockup_detector_reconfigure(false);
 	softlockup_initialized = true;
 	mutex_unlock(&watchdog_mutex);
 }
 
 #else /* CONFIG_SOFTLOCKUP_DETECTOR */
-static void __lockup_detector_reconfigure(void)
+static void __lockup_detector_reconfigure(bool thresh_changed)
 {
 	cpus_read_lock();
 	watchdog_hardlockup_stop();
+	if (thresh_changed)
+		watchdog_thresh = READ_ONCE(watchdog_thresh_next);
 	lockup_detector_update_enable();
 	watchdog_hardlockup_start();
 	cpus_read_unlock();
 }
 void lockup_detector_reconfigure(void)
 {
-	__lockup_detector_reconfigure();
+	__lockup_detector_reconfigure(false);
 }
 static inline void lockup_detector_setup(void)
 {
-	__lockup_detector_reconfigure();
+	__lockup_detector_reconfigure(false);
 }
 #endif /* !CONFIG_SOFTLOCKUP_DETECTOR */
 
@@ -939,11 +950,11 @@ void lockup_detector_soft_poweroff(void)
 #ifdef CONFIG_SYSCTL
 
 /* Propagate any changes to the watchdog infrastructure */
-static void proc_watchdog_update(void)
+static void proc_watchdog_update(bool thresh_changed)
 {
 	/* Remove impossible cpus to keep sysctl output clean. */
 	cpumask_and(&watchdog_cpumask, &watchdog_cpumask, cpu_possible_mask);
-	__lockup_detector_reconfigure();
+	__lockup_detector_reconfigure(thresh_changed);
 }
 
 /*
@@ -976,7 +987,7 @@ static int proc_watchdog_common(int whic
 		old = READ_ONCE(*param);
 		err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 		if (!err && old != READ_ONCE(*param))
-			proc_watchdog_update();
+			proc_watchdog_update(false);
 	}
 	mutex_unlock(&watchdog_mutex);
 	return err;
@@ -1027,11 +1038,13 @@ static int proc_watchdog_thresh(const st
 
 	mutex_lock(&watchdog_mutex);
 
-	old = READ_ONCE(watchdog_thresh);
+	watchdog_thresh_next = READ_ONCE(watchdog_thresh);
+
+	old = watchdog_thresh_next;
 	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 
-	if (!err && write && old != READ_ONCE(watchdog_thresh))
-		proc_watchdog_update();
+	if (!err && write && old != READ_ONCE(watchdog_thresh_next))
+		proc_watchdog_update(true);
 
 	mutex_unlock(&watchdog_mutex);
 	return err;
@@ -1052,7 +1065,7 @@ static int proc_watchdog_cpumask(const s
 
 	err = proc_do_large_bitmap(table, write, buffer, lenp, ppos);
 	if (!err && write)
-		proc_watchdog_update();
+		proc_watchdog_update(false);
 
 	mutex_unlock(&watchdog_mutex);
 	return err;
@@ -1072,7 +1085,7 @@ static struct ctl_table watchdog_sysctls
 	},
 	{
 		.procname	= "watchdog_thresh",
-		.data		= &watchdog_thresh,
+		.data		= &watchdog_thresh_next,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_watchdog_thresh,


