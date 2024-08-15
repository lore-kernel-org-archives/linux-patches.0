Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0CF7DA7D;
	Thu, 15 Aug 2024 13:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730374; cv=none; b=d91bt5V+2SjG38SRm9VwFZotjNahhCZIq/IMONW7xochbFo0nSd7915X2a/RwT3dAljljieC2gHe5pTz8fFeaow5MPZ24hjy5xQsXmlNGazti5wKbfsteFlv4Y1npPfkucZcfGld2NNH03gjFhGewS3hfhk6phQJ8gkjlCM39dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730374; c=relaxed/simple;
	bh=aKTF0lsXjR6YPWsWtI2OQyEx6U2Q3g6y4iHqvRHVccg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1qkem2DN/sFBE2AYy18A0ArP0JKutdWZ9UBmp00XhxXe5A50h2EJ7sZJ+h8IMIOYXohO45ksrGrsyTVgYGaewt0QDknI1piok4rtxxX6VExZJ99ssr3SipHvV80WYOWx1hysxar6rU5PvxuKlSyjdWZeQcdqG6VF5tNoGhjjBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpWev5Zi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpWev5Zi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E35BC32786;
	Thu, 15 Aug 2024 13:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730374;
	bh=aKTF0lsXjR6YPWsWtI2OQyEx6U2Q3g6y4iHqvRHVccg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QpWev5ZinGoY36z32U3iv704FJd/yKccUn6y9DOf6uxloX3XfQzr906yy1oaAD4I3
	 d3vh3RNdbxByDHoiUf11lL6NANqW88OaMXLZHoKduji0g5vr7WWZe6azGrymR2ys6Z
	 oL0OXPX3N+CJqZFAPBQIxB5XPW6Pq55VgJUgkb4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 388/484] profiling: remove profile=sleep support
Date: Thu, 15 Aug 2024 15:24:06 +0200
Message-ID: <20240815131956.432530801@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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
 kernel/profile.c                                |   16 +---------------
 kernel/sched/fair.c                             |   10 ----------
 4 files changed, 2 insertions(+), 29 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4355,11 +4355,9 @@
 
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
@@ -57,24 +57,10 @@ static DEFINE_MUTEX(profile_flip_mutex);
 int profile_setup(char *str)
 {
 	static const char schedstr[] = "schedule";
-	static const char sleepstr[] = "sleep";
 	static const char kvmstr[] = "kvm";
 	int par;
 
-	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
-#ifdef CONFIG_SCHEDSTATS
-		force_schedstat_enabled();
-		prof_on = SLEEP_PROFILING;
-		if (str[strlen(sleepstr)] == ',')
-			str += strlen(sleepstr) + 1;
-		if (get_option(&str, &par))
-			prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
-		pr_info("kernel sleep profiling enabled (shift: %u)\n",
-			prof_shift);
-#else
-		pr_warn("kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
-#endif /* CONFIG_SCHEDSTATS */
-	} else if (!strncmp(str, schedstr, strlen(schedstr))) {
+	if (!strncmp(str, schedstr, strlen(schedstr))) {
 		prof_on = SCHED_PROFILING;
 		if (str[strlen(schedstr)] == ',')
 			str += strlen(schedstr) + 1;
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -988,16 +988,6 @@ update_stats_enqueue_sleeper(struct cfs_
 
 			trace_sched_stat_blocked(tsk, delta);
 
-			/*
-			 * Blocking time is in units of nanosecs, so shift by
-			 * 20 to get a milliseconds-range estimation of the
-			 * amount of time that the task spent sleeping:
-			 */
-			if (unlikely(prof_on == SLEEP_PROFILING)) {
-				profile_hits(SLEEP_PROFILING,
-						(void *)get_wchan(tsk),
-						delta >> 20);
-			}
 			account_scheduler_latency(tsk, delta >> 10, 0);
 		}
 	}


