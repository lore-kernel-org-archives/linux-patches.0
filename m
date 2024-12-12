Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A433021578E;
	Thu, 12 Dec 2024 15:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017389; cv=none; b=G4Xf2xlZxRJBmRpgIK6gum9KoqIDFGPzNregSQe/s92zPZnvraykGKyv8w9Wmq1gt8pbPEb9Vewm4YbunZLBSLg/1gK0nAAVAbOw+pZ/VsYHMZq9LB1TqhGJL/RwMT9a+UWihTDfKFE+RAAzwRPgM2NCW+gYLYTrgajP4XJn2D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017389; c=relaxed/simple;
	bh=tshHOAJC3CUVRDnU11F55AG0RBFqNcras+6nQj3/cJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHC16HDsGU/Mu57yHAJbvDRPTcFE0XpsndQtRVh5lzCtQ9/RwNZPQGK21hFnza/bhHp4U/hcnYnLnVH9zSfOuoh0FhSqvW7VH1YdrXzgZSI3UgfkxVY+wlkBZcldMXlUkCo/ScXkelz0iyvAwN7/KA9PfEq4xm+C5X02O/5JIIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEstcfP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEstcfP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A841C4CECE;
	Thu, 12 Dec 2024 15:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017389;
	bh=tshHOAJC3CUVRDnU11F55AG0RBFqNcras+6nQj3/cJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEstcfP/ploYBffbXyo6vhTQQaKA0tM0PCUfaA11ijnCdzG+HzmDPhLhmutFSUEDZ
	 Tx3UJQQ5zAiFv/jWX4cYGE0NgFvD10gPFY18wCCRA72LhyMrOzrHGcky0gf0cfDZY0
	 D0nAhN413Q3wFMzRYG3kXQNvvapeQ4Gpe5kZH2s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 466/466] clocksource: Make negative motion detection more robust
Date: Thu, 12 Dec 2024 16:00:35 +0100
Message-ID: <20241212144325.277833274@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

commit 76031d9536a076bf023bedbdb1b4317fc801dd67 upstream.

Guenter reported boot stalls on a emulated ARM 32-bit platform, which has a
24-bit wide clocksource.

It turns out that the calculated maximal idle time, which limits idle
sleeps to prevent clocksource wrap arounds, is close to the point where the
negative motion detection triggers.

  max_idle_ns:                    597268854 ns
  negative motion tripping point: 671088640 ns

If the idle wakeup is delayed beyond that point, the clocksource
advances far enough to trigger the negative motion detection. This
prevents the clock to advance and in the worst case the system stalls
completely if the consecutive sleeps based on the stale clock are
delayed as well.

Cure this by calculating a more robust cut-off value for negative motion,
which covers 87.5% of the actual clocksource counter width. Compare the
delta against this value to catch negative motion. This is specifically for
clock sources with a small counter width as their wrap around time is close
to the half counter width. For clock sources with wide counters this is not
a problem because the maximum idle time is far from the half counter width
due to the math overflow protection constraints.

For the case at hand this results in a tripping point of 1174405120ns.

Note, that this cannot prevent issues when the delay exceeds the 87.5%
margin, but that's not different from the previous unchecked version which
allowed arbitrary time jumps.

Systems with small counter width are prone to invalid results, but this
problem is unlikely to be seen on real hardware. If such a system
completely stalls for more than half a second, then there are other more
urgent problems than the counter wrapping around.

Fixes: c163e40af9b2 ("timekeeping: Always check for negative motion")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/all/8734j5ul4x.ffs@tglx
Closes: https://lore.kernel.org/all/387b120b-d68a-45e8-b6ab-768cd95d11c2@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/clocksource.h        |    2 ++
 kernel/time/clocksource.c          |   11 ++++++++++-
 kernel/time/timekeeping.c          |    6 ++++--
 kernel/time/timekeeping_internal.h |    8 ++++----
 4 files changed, 20 insertions(+), 7 deletions(-)

--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -49,6 +49,7 @@ struct module;
  * @archdata:		Optional arch-specific data
  * @max_cycles:		Maximum safe cycle value which won't overflow on
  *			multiplication
+ * @max_raw_delta:	Maximum safe delta value for negative motion detection
  * @name:		Pointer to clocksource name
  * @list:		List head for registration (internal)
  * @freq_khz:		Clocksource frequency in khz.
@@ -109,6 +110,7 @@ struct clocksource {
 	struct arch_clocksource_data archdata;
 #endif
 	u64			max_cycles;
+	u64			max_raw_delta;
 	const char		*name;
 	struct list_head	list;
 	u32			freq_khz;
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -22,7 +22,7 @@
 
 static noinline u64 cycles_to_nsec_safe(struct clocksource *cs, u64 start, u64 end)
 {
-	u64 delta = clocksource_delta(end, start, cs->mask);
+	u64 delta = clocksource_delta(end, start, cs->mask, cs->max_raw_delta);
 
 	if (likely(delta < cs->max_cycles))
 		return clocksource_cyc2ns(delta, cs->mult, cs->shift);
@@ -985,6 +985,15 @@ static inline void clocksource_update_ma
 	cs->max_idle_ns = clocks_calc_max_nsecs(cs->mult, cs->shift,
 						cs->maxadj, cs->mask,
 						&cs->max_cycles);
+
+	/*
+	 * Threshold for detecting negative motion in clocksource_delta().
+	 *
+	 * Allow for 0.875 of the counter width so that overly long idle
+	 * sleeps, which go slightly over mask/2, do not trigger the
+	 * negative motion detection.
+	 */
+	cs->max_raw_delta = (cs->mask >> 1) + (cs->mask >> 2) + (cs->mask >> 3);
 }
 
 static struct clocksource *clocksource_find_best(bool oneshot, bool skipcur)
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -793,7 +793,8 @@ static void timekeeping_forward_now(stru
 	u64 cycle_now, delta;
 
 	cycle_now = tk_clock_read(&tk->tkr_mono);
-	delta = clocksource_delta(cycle_now, tk->tkr_mono.cycle_last, tk->tkr_mono.mask);
+	delta = clocksource_delta(cycle_now, tk->tkr_mono.cycle_last, tk->tkr_mono.mask,
+				  tk->tkr_mono.clock->max_raw_delta);
 	tk->tkr_mono.cycle_last = cycle_now;
 	tk->tkr_raw.cycle_last  = cycle_now;
 
@@ -2292,7 +2293,8 @@ static bool timekeeping_advance(enum tim
 		goto out;
 
 	offset = clocksource_delta(tk_clock_read(&tk->tkr_mono),
-				   tk->tkr_mono.cycle_last, tk->tkr_mono.mask);
+				   tk->tkr_mono.cycle_last, tk->tkr_mono.mask,
+				   tk->tkr_mono.clock->max_raw_delta);
 
 	/* Check if there's really nothing to do */
 	if (offset < real_tk->cycle_interval && mode == TK_ADV_TICK)
--- a/kernel/time/timekeeping_internal.h
+++ b/kernel/time/timekeeping_internal.h
@@ -15,15 +15,15 @@ extern void tk_debug_account_sleep_time(
 #define tk_debug_account_sleep_time(x)
 #endif
 
-static inline u64 clocksource_delta(u64 now, u64 last, u64 mask)
+static inline u64 clocksource_delta(u64 now, u64 last, u64 mask, u64 max_delta)
 {
 	u64 ret = (now - last) & mask;
 
 	/*
-	 * Prevent time going backwards by checking the MSB of mask in
-	 * the result. If set, return 0.
+	 * Prevent time going backwards by checking the result against
+	 * @max_delta. If greater, return 0.
 	 */
-	return ret & ~(mask >> 1) ? 0 : ret;
+	return ret > max_delta ? 0 : ret;
 }
 
 /* Semi public for serialization of non timekeeper VDSO updates. */


