Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765C7183CC9;
	Mon, 12 Aug 2024 16:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478842; cv=none; b=A+SBXG4IMv4MXxBey7nK4RokNZdO++G73HgwmX8mfQpNJlFpSi8KwFtYcdAEz8kFZmQCBysswLEXeTvh9Ix7u5ZF97u989HVxo0Ib869wDWo5lCe9aorQA0U0UKcWyPte3mWRAlPUlMgjKUASRlR8vwXhV3KrINC/jaRFj7+2is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478842; c=relaxed/simple;
	bh=6Taz2mqp1n1AF9xXY99taCwtKLREbYdTQvxZtYFtkF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJW1V45Fwaes4bZQODkD4QWid+5yvmaIel9A2mvERoz/xNsv0xRAHTsoY4kgAbu5e4a9ac7TMZrUcNqokVzifkHAOB5v6/KeBLtdrSjieGfL5dsEZVW4zBn8sOWE8HsLGN9QaI4wdWzhN1YOLollUv3Zq1anNf3ZMVLLZLMyFFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aS9kFJoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aS9kFJoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0D4C32782;
	Mon, 12 Aug 2024 16:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478842;
	bh=6Taz2mqp1n1AF9xXY99taCwtKLREbYdTQvxZtYFtkF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aS9kFJoAjGZ4gj7AGp6tnceME+pBvejeu7EObtS7hEETvjcLNSXOHITdc3GB26+Ql
	 CTVkNG9ywDhKoMoWfVd+P/zHkxOFv/NiM5GUGSySbdIRVdOstgOl+LpZZa5WKCb7P6
	 yVG+4G89vL/3oEI5h7lzgTkJGx20/4fo1+wQdpTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 052/150] profiling: remove profile=sleep support
Date: Mon, 12 Aug 2024 18:02:13 +0200
Message-ID: <20240812160127.174126079@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit b88f55389ad27f05ed84af9e1026aa64dbfabc9a upstream.

The kernel sleep profile is no longer working due to a recursive locking
bug introduced by commit 42a20f86dc19 ("sched: Add wrapper for get_wchan()
to keep task blocked")

Booting with the 'profile=sleep' kernel command line option added or
executing

  # echo -n sleep > /sys/kernel/profiling

after boot causes the system to lock up.

Lockdep reports

  kthreadd/3 is trying to acquire lock:
  ffff93ac82e08d58 (&p->pi_lock){....}-{2:2}, at: get_wchan+0x32/0x70

  but task is already holding lock:
  ffff93ac82e08d58 (&p->pi_lock){....}-{2:2}, at: try_to_wake_up+0x53/0x370

with the call trace being

   lock_acquire+0xc8/0x2f0
   get_wchan+0x32/0x70
   __update_stats_enqueue_sleeper+0x151/0x430
   enqueue_entity+0x4b0/0x520
   enqueue_task_fair+0x92/0x6b0
   ttwu_do_activate+0x73/0x140
   try_to_wake_up+0x213/0x370
   swake_up_locked+0x20/0x50
   complete+0x2f/0x40
   kthread+0xfb/0x180

However, since nobody noticed this regression for more than two years,
let's remove 'profile=sleep' support based on the assumption that nobody
needs this functionality.

Fixes: 42a20f86dc19 ("sched: Add wrapper for get_wchan() to keep task blocked")
Cc: stable@vger.kernel.org # v5.16+
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/kernel-parameters.txt |    4 +---
 include/linux/profile.h                         |    1 -
 kernel/profile.c                                |   11 +----------
 kernel/sched/stats.c                            |   10 ----------
 4 files changed, 2 insertions(+), 24 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4556,11 +4556,9 @@
 
 	profile=	[KNL] Enable kernel profiling via /proc/profile
 			Format: [<profiletype>,]<number>
-			Param: <profiletype>: "schedule", "sleep", or "kvm"
+			Param: <profiletype>: "schedule" or "kvm"
 				[defaults to kernel profiling]
 			Param: "schedule" - profile schedule points.
-			Param: "sleep" - profile D-state sleeping (millisecs).
-				Requires CONFIG_SCHEDSTATS
 			Param: "kvm" - profile VM exits.
 			Param: <number> - step/bucket size as a power of 2 for
 				statistical time based profiling.
--- a/include/linux/profile.h
+++ b/include/linux/profile.h
@@ -11,7 +11,6 @@
 
 #define CPU_PROFILING	1
 #define SCHED_PROFILING	2
-#define SLEEP_PROFILING	3
 #define KVM_PROFILING	4
 
 struct proc_dir_entry;
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -57,20 +57,11 @@ static DEFINE_MUTEX(profile_flip_mutex);
 int profile_setup(char *str)
 {
 	static const char schedstr[] = "schedule";
-	static const char sleepstr[] = "sleep";
 	static const char kvmstr[] = "kvm";
 	const char *select = NULL;
 	int par;
 
-	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
-#ifdef CONFIG_SCHEDSTATS
-		force_schedstat_enabled();
-		prof_on = SLEEP_PROFILING;
-		select = sleepstr;
-#else
-		pr_warn("kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
-#endif /* CONFIG_SCHEDSTATS */
-	} else if (!strncmp(str, schedstr, strlen(schedstr))) {
+	if (!strncmp(str, schedstr, strlen(schedstr))) {
 		prof_on = SCHED_PROFILING;
 		select = schedstr;
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
--- a/kernel/sched/stats.c
+++ b/kernel/sched/stats.c
@@ -92,16 +92,6 @@ void __update_stats_enqueue_sleeper(stru
 
 			trace_sched_stat_blocked(p, delta);
 
-			/*
-			 * Blocking time is in units of nanosecs, so shift by
-			 * 20 to get a milliseconds-range estimation of the
-			 * amount of time that the task spent sleeping:
-			 */
-			if (unlikely(prof_on == SLEEP_PROFILING)) {
-				profile_hits(SLEEP_PROFILING,
-					     (void *)get_wchan(p),
-					     delta >> 20);
-			}
 			account_scheduler_latency(p, delta >> 10, 0);
 		}
 	}


