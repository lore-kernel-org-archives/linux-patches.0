Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE8129CA;
	Mon, 12 Aug 2024 16:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479634; cv=none; b=gSgkzeN0PWl/S6PTVBs5+irxOq6GOIBDr5AmgHZl6XRuOA7XBNMvNzWC41Emu3Myo4y5KZRAUQQyFvLNgmIBct+IEMQYyf4BOPXAOvIfMOefSxAVIpFbeh7MR5f/pCx00UZ5gs3A6st56bPWM3/IeF6hMzz4d8JkBbrnADRvZ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479634; c=relaxed/simple;
	bh=JSWeqskncFQHT2BU2rInslFJB/J4mtEiRXyM9tjhqBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liK24wjghboYLHzpK89iZD/RmfvMiJNnF2BfhiBl1Gvh7IgSkI6jW4LTcG7C72PWojqs503e6f8LxGeKuHf4OccM2nkpeAfwElTf5g2L3p1t2zdiBs0PYhzuUNgVqfMeycTOeRrMWkOHbeZmLuF6bMvqImDt0sHipLKHTeHRn6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=po1VsRMm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="po1VsRMm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE14C4AF0C;
	Mon, 12 Aug 2024 16:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479634;
	bh=JSWeqskncFQHT2BU2rInslFJB/J4mtEiRXyM9tjhqBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=po1VsRMmfz2ClfAHR6tzgMEpgNGVNXzaFYUcBXf5O0U1erVoC6Q6PCAC/6iYZfqfP
	 nVwhqZZNQwVGAlXybjh9ueRrwLXc7ctbmaj/EtYilz909toQ0Sd5EWj5n1NrXIIfy7
	 ld7yZ2JbUTM0DsHoe8Su5obUfIcYRhZ7CnYt+ug8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Tang <feng.tang@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jin Wang <jin1.wang@intel.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/189] clocksource: Scale the watchdog read retries automatically
Date: Mon, 12 Aug 2024 18:03:05 +0200
Message-ID: <20240812160137.111246430@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Tang <feng.tang@intel.com>

[ Upstream commit 2ed08e4bc53298db3f87b528cd804cb0cce066a9 ]

On a 8-socket server the TSC is wrongly marked as 'unstable' and disabled
during boot time on about one out of 120 boot attempts:

    clocksource: timekeeping watchdog on CPU227: wd-tsc-wd excessive read-back delay of 153560ns vs. limit of 125000ns,
    wd-wd read-back delay only 11440ns, attempt 3, marking tsc unstable
    tsc: Marking TSC unstable due to clocksource watchdog
    TSC found unstable after boot, most likely due to broken BIOS. Use 'tsc=unstable'.
    sched_clock: Marking unstable (119294969739, 159204297)<-(125446229205, -5992055152)
    clocksource: Checking clocksource tsc synchronization from CPU 319 to CPUs 0,99,136,180,210,542,601,896.
    clocksource: Switched to clocksource hpet

The reason is that for platform with a large number of CPUs, there are
sporadic big or huge read latencies while reading the watchog/clocksource
during boot or when system is under stress work load, and the frequency and
maximum value of the latency goes up with the number of online CPUs.

The cCurrent code already has logic to detect and filter such high latency
case by reading the watchdog twice and checking the two deltas. Due to the
randomness of the latency, there is a low probabilty that the first delta
(latency) is big, but the second delta is small and looks valid. The
watchdog code retries the readouts by default twice, which is not
necessarily sufficient for systems with a large number of CPUs.

There is a command line parameter 'max_cswd_read_retries' which allows to
increase the number of retries, but that's not user friendly as it needs to
be tweaked per system. As the number of required retries is proportional to
the number of online CPUs, this parameter can be calculated at runtime.

Scale and enlarge the number of retries according to the number of online
CPUs and remove the command line parameter completely.

[ tglx: Massaged change log and comments ]

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Jin Wang <jin1.wang@intel.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/r/20240221060859.1027450-1-feng.tang@intel.com
Stable-dep-of: f2655ac2c06a ("clocksource: Fix brown-bag boolean thinko in cs_watchdog_read()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt   |  6 ------
 include/linux/clocksource.h                       | 14 +++++++++++++-
 kernel/time/clocksource-wdtest.c                  | 13 +++++++------
 kernel/time/clocksource.c                         | 10 ++++------
 tools/testing/selftests/rcutorture/bin/torture.sh |  2 +-
 5 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 83b1795335e53..a7fe113897361 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -664,12 +664,6 @@
 			loops can be debugged more effectively on production
 			systems.
 
-	clocksource.max_cswd_read_retries= [KNL]
-			Number of clocksource_watchdog() retries due to
-			external delays before the clock will be marked
-			unstable.  Defaults to two retries, that is,
-			three attempts to read the clock under test.
-
 	clocksource.verify_n_cpus= [KNL]
 			Limit the number of CPUs checked for clocksources
 			marked with CLOCK_SOURCE_VERIFY_PERCPU that
diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index 1d42d4b173271..0ad8b550bb4b4 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -291,7 +291,19 @@ static inline void timer_probe(void) {}
 #define TIMER_ACPI_DECLARE(name, table_id, fn)		\
 	ACPI_DECLARE_PROBE_ENTRY(timer, name, table_id, 0, NULL, 0, fn)
 
-extern ulong max_cswd_read_retries;
+static inline unsigned int clocksource_get_max_watchdog_retry(void)
+{
+	/*
+	 * When system is in the boot phase or under heavy workload, there
+	 * can be random big latencies during the clocksource/watchdog
+	 * read, so allow retries to filter the noise latency. As the
+	 * latency's frequency and maximum value goes up with the number of
+	 * CPUs, scale the number of retries with the number of online
+	 * CPUs.
+	 */
+	return (ilog2(num_online_cpus()) / 2) + 1;
+}
+
 void clocksource_verify_percpu(struct clocksource *cs);
 
 #endif /* _LINUX_CLOCKSOURCE_H */
diff --git a/kernel/time/clocksource-wdtest.c b/kernel/time/clocksource-wdtest.c
index df922f49d171b..d06185e054ea2 100644
--- a/kernel/time/clocksource-wdtest.c
+++ b/kernel/time/clocksource-wdtest.c
@@ -104,8 +104,8 @@ static void wdtest_ktime_clocksource_reset(void)
 static int wdtest_func(void *arg)
 {
 	unsigned long j1, j2;
+	int i, max_retries;
 	char *s;
-	int i;
 
 	schedule_timeout_uninterruptible(holdoff * HZ);
 
@@ -139,18 +139,19 @@ static int wdtest_func(void *arg)
 	WARN_ON_ONCE(time_before(j2, j1 + NSEC_PER_USEC));
 
 	/* Verify tsc-like stability with various numbers of errors injected. */
-	for (i = 0; i <= max_cswd_read_retries + 1; i++) {
-		if (i <= 1 && i < max_cswd_read_retries)
+	max_retries = clocksource_get_max_watchdog_retry();
+	for (i = 0; i <= max_retries + 1; i++) {
+		if (i <= 1 && i < max_retries)
 			s = "";
-		else if (i <= max_cswd_read_retries)
+		else if (i <= max_retries)
 			s = ", expect message";
 		else
 			s = ", expect clock skew";
-		pr_info("--- Watchdog with %dx error injection, %lu retries%s.\n", i, max_cswd_read_retries, s);
+		pr_info("--- Watchdog with %dx error injection, %d retries%s.\n", i, max_retries, s);
 		WRITE_ONCE(wdtest_ktime_read_ndelays, i);
 		schedule_timeout_uninterruptible(2 * HZ);
 		WARN_ON_ONCE(READ_ONCE(wdtest_ktime_read_ndelays));
-		WARN_ON_ONCE((i <= max_cswd_read_retries) !=
+		WARN_ON_ONCE((i <= max_retries) !=
 			     !(clocksource_wdtest_ktime.flags & CLOCK_SOURCE_UNSTABLE));
 		wdtest_ktime_clocksource_reset();
 	}
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 3052b1f1168e2..c95080f005dd4 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -210,9 +210,6 @@ void clocksource_mark_unstable(struct clocksource *cs)
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
-ulong max_cswd_read_retries = 2;
-module_param(max_cswd_read_retries, ulong, 0644);
-EXPORT_SYMBOL_GPL(max_cswd_read_retries);
 static int verify_n_cpus = 8;
 module_param(verify_n_cpus, int, 0644);
 
@@ -224,11 +221,12 @@ enum wd_read_status {
 
 static enum wd_read_status cs_watchdog_read(struct clocksource *cs, u64 *csnow, u64 *wdnow)
 {
-	unsigned int nretries;
+	unsigned int nretries, max_retries;
 	u64 wd_end, wd_end2, wd_delta;
 	int64_t wd_delay, wd_seq_delay;
 
-	for (nretries = 0; nretries <= max_cswd_read_retries; nretries++) {
+	max_retries = clocksource_get_max_watchdog_retry();
+	for (nretries = 0; nretries <= max_retries; nretries++) {
 		local_irq_disable();
 		*wdnow = watchdog->read(watchdog);
 		*csnow = cs->read(cs);
@@ -240,7 +238,7 @@ static enum wd_read_status cs_watchdog_read(struct clocksource *cs, u64 *csnow,
 		wd_delay = clocksource_cyc2ns(wd_delta, watchdog->mult,
 					      watchdog->shift);
 		if (wd_delay <= WATCHDOG_MAX_SKEW) {
-			if (nretries > 1 || nretries >= max_cswd_read_retries) {
+			if (nretries > 1 || nretries >= max_retries) {
 				pr_warn("timekeeping watchdog on CPU%d: %s retried %d times before success\n",
 					smp_processor_id(), watchdog->name, nretries);
 			}
diff --git a/tools/testing/selftests/rcutorture/bin/torture.sh b/tools/testing/selftests/rcutorture/bin/torture.sh
index 12b50a4a881ac..89a82f6f140ef 100755
--- a/tools/testing/selftests/rcutorture/bin/torture.sh
+++ b/tools/testing/selftests/rcutorture/bin/torture.sh
@@ -567,7 +567,7 @@ then
 	torture_bootargs="rcupdate.rcu_cpu_stall_suppress_at_boot=1 torture.disable_onoff_at_boot rcupdate.rcu_task_stall_timeout=30000 tsc=watchdog"
 	torture_set "clocksourcewd-1" tools/testing/selftests/rcutorture/bin/kvm.sh --allcpus --duration 45s --configs TREE03 --kconfig "CONFIG_TEST_CLOCKSOURCE_WATCHDOG=y" --trust-make
 
-	torture_bootargs="rcupdate.rcu_cpu_stall_suppress_at_boot=1 torture.disable_onoff_at_boot rcupdate.rcu_task_stall_timeout=30000 clocksource.max_cswd_read_retries=1 tsc=watchdog"
+	torture_bootargs="rcupdate.rcu_cpu_stall_suppress_at_boot=1 torture.disable_onoff_at_boot rcupdate.rcu_task_stall_timeout=30000 tsc=watchdog"
 	torture_set "clocksourcewd-2" tools/testing/selftests/rcutorture/bin/kvm.sh --allcpus --duration 45s --configs TREE03 --kconfig "CONFIG_TEST_CLOCKSOURCE_WATCHDOG=y" --trust-make
 
 	# In case our work is already done...
-- 
2.43.0



