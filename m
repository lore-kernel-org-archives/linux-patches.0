Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A88E76C75;
	Mon, 29 Jan 2024 17:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548654; cv=none; b=IOoMrs5/+A4RbtplMkSgd2ZLQMkxZqhTBwxXawuk3IXkR5egI3pjy29R9k8xi3lECHzxEmZEtXTEHz9K1B4AcfjmHyEe85PvUo4uypGJAo+xBbU4WfXY5zJD4Mii8FCqs//vrBVvHqjJy4VI1u2tjB3PpatJ5ZK4QwPP0X9uqps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548654; c=relaxed/simple;
	bh=9dCewOxdoGy8iHTy59kMzOTvYT5ih81HXFOBt0o8ulo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFKQopLIR47vTZWDodRVXgzsyeboEKahRMvkA4k6YRM+YNzMOxxkKOkEzOgJKQlEfiZDqZ7eeLFKwEfU/oSh/kW2X5BjYpdTB29TQZ3BbZuwUevJ8aU69y+viOvhLfZqf7Cc/c0ZPQKeHV+0BMM6fxDsCr0XZ8eCCHb2ewykkog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHzabm+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHzabm+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6574C43394;
	Mon, 29 Jan 2024 17:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548653;
	bh=9dCewOxdoGy8iHTy59kMzOTvYT5ih81HXFOBt0o8ulo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHzabm+Og+kGKcUO4q5jtxjiVJ3aeTjsUxLw582gPzzESVdz82PPB01iWaNsrDQ+0
	 hKTPzUax92x19aI+JTt8Z1NDlvJ81ofug0CaoNryRpJKXyX4eIHVTTq58Cnoh+NVfD
	 6sOkPob/gMOM8JWie0HAzOyEILzY/tlpnXbfs5tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Tang <feng.tang@intel.com>,
	Jiri Wiesner <jwiesner@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 6.6 327/331] clocksource: Skip watchdog check for large watchdog intervals
Date: Mon, 29 Jan 2024 09:06:31 -0800
Message-ID: <20240129170024.454856796@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Jiri Wiesner <jwiesner@suse.de>

commit 644649553508b9bacf0fc7a5bdc4f9e0165576a5 upstream.

There have been reports of the watchdog marking clocksources unstable on
machines with 8 NUMA nodes:

  clocksource: timekeeping watchdog on CPU373:
  Marking clocksource 'tsc' as unstable because the skew is too large:
  clocksource:   'hpet' wd_nsec: 14523447520
  clocksource:   'tsc'  cs_nsec: 14524115132

The measured clocksource skew - the absolute difference between cs_nsec
and wd_nsec - was 668 microseconds:

  cs_nsec - wd_nsec = 14524115132 - 14523447520 = 667612

The kernel used 200 microseconds for the uncertainty_margin of both the
clocksource and watchdog, resulting in a threshold of 400 microseconds (the
md variable). Both the cs_nsec and the wd_nsec value indicate that the
readout interval was circa 14.5 seconds.  The observed behaviour is that
watchdog checks failed for large readout intervals on 8 NUMA node
machines. This indicates that the size of the skew was directly proportinal
to the length of the readout interval on those machines. The measured
clocksource skew, 668 microseconds, was evaluated against a threshold (the
md variable) that is suited for readout intervals of roughly
WATCHDOG_INTERVAL, i.e. HZ >> 1, which is 0.5 second.

The intention of 2e27e793e280 ("clocksource: Reduce clocksource-skew
threshold") was to tighten the threshold for evaluating skew and set the
lower bound for the uncertainty_margin of clocksources to twice
WATCHDOG_MAX_SKEW. Later in c37e85c135ce ("clocksource: Loosen clocksource
watchdog constraints"), the WATCHDOG_MAX_SKEW constant was increased to
125 microseconds to fit the limit of NTP, which is able to use a
clocksource that suffers from up to 500 microseconds of skew per second.
Both the TSC and the HPET use default uncertainty_margin. When the
readout interval gets stretched the default uncertainty_margin is no
longer a suitable lower bound for evaluating skew - it imposes a limit
that is far stricter than the skew with which NTP can deal.

The root causes of the skew being directly proportinal to the length of
the readout interval are:

  * the inaccuracy of the shift/mult pairs of clocksources and the watchdog
  * the conversion to nanoseconds is imprecise for large readout intervals

Prevent this by skipping the current watchdog check if the readout
interval exceeds 2 * WATCHDOG_INTERVAL. Considering the maximum readout
interval of 2 * WATCHDOG_INTERVAL, the current default uncertainty margin
(of the TSC and HPET) corresponds to a limit on clocksource skew of 250
ppm (microseconds of skew per second).  To keep the limit imposed by NTP
(500 microseconds of skew per second) for all possible readout intervals,
the margins would have to be scaled so that the threshold value is
proportional to the length of the actual readout interval.

As for why the readout interval may get stretched: Since the watchdog is
executed in softirq context the expiration of the watchdog timer can get
severely delayed on account of a ksoftirqd thread not getting to run in a
timely manner. Surely, a system with such belated softirq execution is not
working well and the scheduling issue should be looked into but the
clocksource watchdog should be able to deal with it accordingly.

Fixes: 2e27e793e280 ("clocksource: Reduce clocksource-skew threshold")
Suggested-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Jiri Wiesner <jwiesner@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240122172350.GA740@incl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/clocksource.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -99,6 +99,7 @@ static u64 suspend_start;
  * Interval: 0.5sec.
  */
 #define WATCHDOG_INTERVAL (HZ >> 1)
+#define WATCHDOG_INTERVAL_MAX_NS ((2 * WATCHDOG_INTERVAL) * (NSEC_PER_SEC / HZ))
 
 /*
  * Threshold: 0.0312s, when doubled: 0.0625s.
@@ -134,6 +135,7 @@ static DECLARE_WORK(watchdog_work, clock
 static DEFINE_SPINLOCK(watchdog_lock);
 static int watchdog_running;
 static atomic_t watchdog_reset_pending;
+static int64_t watchdog_max_interval;
 
 static inline void clocksource_watchdog_lock(unsigned long *flags)
 {
@@ -399,8 +401,8 @@ static inline void clocksource_reset_wat
 static void clocksource_watchdog(struct timer_list *unused)
 {
 	u64 csnow, wdnow, cslast, wdlast, delta;
+	int64_t wd_nsec, cs_nsec, interval;
 	int next_cpu, reset_pending;
-	int64_t wd_nsec, cs_nsec;
 	struct clocksource *cs;
 	enum wd_read_status read_ret;
 	unsigned long extra_wait = 0;
@@ -470,6 +472,27 @@ static void clocksource_watchdog(struct
 		if (atomic_read(&watchdog_reset_pending))
 			continue;
 
+		/*
+		 * The processing of timer softirqs can get delayed (usually
+		 * on account of ksoftirqd not getting to run in a timely
+		 * manner), which causes the watchdog interval to stretch.
+		 * Skew detection may fail for longer watchdog intervals
+		 * on account of fixed margins being used.
+		 * Some clocksources, e.g. acpi_pm, cannot tolerate
+		 * watchdog intervals longer than a few seconds.
+		 */
+		interval = max(cs_nsec, wd_nsec);
+		if (unlikely(interval > WATCHDOG_INTERVAL_MAX_NS)) {
+			if (system_state > SYSTEM_SCHEDULING &&
+			    interval > 2 * watchdog_max_interval) {
+				watchdog_max_interval = interval;
+				pr_warn("Long readout interval, skipping watchdog check: cs_nsec: %lld wd_nsec: %lld\n",
+					cs_nsec, wd_nsec);
+			}
+			watchdog_timer.expires = jiffies;
+			continue;
+		}
+
 		/* Check the deviation from the watchdog clocksource. */
 		md = cs->uncertainty_margin + watchdog->uncertainty_margin;
 		if (abs(cs_nsec - wd_nsec) > md) {


