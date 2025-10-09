Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FD219E967;
	Thu,  9 Oct 2025 15:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025476; cv=none; b=f992wvNh6KDqXsY2xTz3AMYxYRZHcbJe6COxK83FAadQiXLnV/25OgPXXoAwkTC1vUpO5IBUQWXo4AkuFrHvYBP8CCL15SGdrf6b+bp22VOLpsJ7AZ0NUcaVG5CUp8Nz6imBid3RmXpocYyBjMpiAlqul9tPdtNE+JMBknPwTtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025476; c=relaxed/simple;
	bh=O0EX2Pumapvmik9XwpyC1sDrus6j3n7Q3+G7u4UaG8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dtRlv0bvCt91uInl5YV7AWM7fWkevfXc1CI3z1hmEIIVKD1CpPwiwKfPD7ku4cOaugFbZoWy1uxmSXiOjOGZ4VUedLeYTjr//Mdg9Ecs5Au1YJLL4cZPnYurkgLVZQdiWOuE75yf9HfkckgS3S7be2kFX/zwiWM6Tfg8Oo9h6iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=acT4FOka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="acT4FOka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04494C4CEF8;
	Thu,  9 Oct 2025 15:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025476;
	bh=O0EX2Pumapvmik9XwpyC1sDrus6j3n7Q3+G7u4UaG8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acT4FOka67ozuQuu8rVEjFtQXeXqhppaqTZE7t1OxoQAmGMGw80s1M7AfkIIA5k0C
	 aOrkyxlMD05o2ttn7pGHQjn9sBFAybsExhJ1erfhyjEu7qDH6h11ZoTK/dR5l3YDuc
	 1oeUdX0R7q9m6wxYc2xIl8J9o+cm1touqSkKJJG19zlkgU32++PU3/mpnmwbwzxShj
	 Z4neeXEsyBmmnmde0zKPiBeMnMrdwX1YpzqHHD75fEevAvQKoaRaM8aLAwcId1Echf
	 qWa91OXGPLUth3OxY+blJlV0MSNMkGr2r+aVkEL+SPe+uHQzlR2ObPB39blP4EMgMa
	 K8xOApAPT1vMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Markus Stockhausen <markus.stockhausen@gmx.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Stephen Howell <howels@allthatwemight.be>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	Sasha Levin <sashal@kernel.org>,
	tglx@linutronix.de,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] clocksource/drivers/timer-rtl-otto: Work around dying timers
Date: Thu,  9 Oct 2025 11:54:28 -0400
Message-ID: <20251009155752.773732-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Transfer-Encoding: 8bit

From: Markus Stockhausen <markus.stockhausen@gmx.de>

[ Upstream commit e7a25106335041aeca4fdf50a84804c90142c886 ]

The OpenWrt distribution has switched from kernel longterm 6.6 to
6.12. Reports show that devices with the Realtek Otto switch platform
die during operation and are rebooted by the watchdog. Sorting out
other possible reasons the Otto timer is to blame. The platform
currently consists of 4 targets with different hardware revisions.
It is not 100% clear which devices and revisions are affected.

Analysis shows:

A more aggressive sched/deadline handling leads to more timer starts
with small intervals. This increases the bug chances. See
https://marc.info/?l=linux-kernel&m=175276556023276&w=2

Focusing on the real issue a hardware limitation on some devices was
found. There is a minimal chance that a timer ends without firing an
interrupt if it is reprogrammed within the 5us before its expiration
time. Work around this issue by introducing a bounce() function. It
restarts the timer directly before the normal restart functions as
follows:

- Stop timer
- Restart timer with a slow frequency.
- Target time will be >5us
- The subsequent normal restart is outside the critical window

Downstream has already tested and confirmed a patch. See
https://github.com/openwrt/openwrt/pull/19468
https://forum.openwrt.org/t/support-for-rtl838x-based-managed-switches/57875/3788

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Tested-by: Stephen Howell <howels@allthatwemight.be>
Tested-by: Bjørn Mork <bjorn@mork.no>
Link: https://lore.kernel.org/r/20250804080328.2609287-2-markus.stockhausen@gmx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real user-visible bug: The commit addresses a hardware timing
  erratum on some Realtek Otto SoCs where reprogramming a running timer
  within ~5 µs of its expiration can cause the next interrupt to be
  lost, leading to hangs and watchdog resets. This is confirmed by field
  reports (OpenWrt) and multiple Tested-by tags in the commit message.
  It is an important reliability fix, not a feature.

- Small, contained change in one driver: The patch is limited to
  `drivers/clocksource/timer-rtl-otto.c`. It introduces a minimal helper
  and three call sites; no API or architectural changes.

- Core idea and code changes:
  - Adds `RTTM_MAX_DIVISOR` to select the slowest prescaler for a brief
    “bounce” restart to safely move the timer away from the <5 µs danger
    window (define added near the other timer constants).
  - Introduces `rttm_bounce_timer()` which disables and immediately re-
    enables the timer with the slowest divisor, preserving the current
    period so the immediate follow-up reprogramming happens well outside
    the critical window:
    - New helper is placed after the IRQ handler and before the
      stop/start helpers.
  - Wires the bounce into all clockevent reprogram paths by calling it
    just before the existing stop/program/start sequence:
    - `rttm_next_event()` adds the bounce before `rttm_stop_timer()`
      (see current function start at drivers/clocksource/timer-rtl-
      otto.c:127).
    - `rttm_state_oneshot()` adds the bounce before `rttm_stop_timer()`
      (drivers/clocksource/timer-rtl-otto.c:139).
    - `rttm_state_periodic()` adds the bounce before `rttm_stop_timer()`
      (drivers/clocksource/timer-rtl-otto.c:151).
  - The clocksource path remains untouched (e.g.,
    `rttm_enable_clocksource()` at drivers/clocksource/timer-rtl-
    otto.c:204), which is appropriate since the bug is triggered by
    frequent reprogramming of the clockevent timers, not the continuous
    clocksource.

- Rationale for safety and effectiveness:
  - The bounce sequence is purely local to the Otto timer MMIO block and
    uses existing primitives (`rttm_disable_timer()`,
    `rttm_enable_timer()`), preserving established semantics while
    creating a safe temporal margin before the normal reprogramming.
  - Using `RTTM_MAX_DIVISOR` ensures the effective tick frequency drops
    to ~kHz, making the “time to end marker” well beyond 5 µs even with
    the minimal period (`>= RTTM_MIN_DELTA`, 8 ticks), eliminating the
    observed race window.
  - The stop/ack/program/start logic remains identical aside from the
    pre-amble bounce; ack of pending IRQs is still done in
    `rttm_stop_timer()`, as before, so the change does not introduce new
    interrupt handling semantics.

- Scope and regression risk:
  - Limited to Realtek Otto timer driver; no impact on other platforms
    or subsystems.
  - No ABI/DT/Kconfig changes; no scheduling or generic timekeeping
    changes.
  - Minimal runtime overhead (a couple of MMIO writes per reprogram) is
    acceptable versus preventing system hangs.

- Stable backport suitability:
  - The driver is present in stable trees starting with v6.11 (verified:
    file exists in v6.11 and v6.12; drivers/clocksource/timer-rtl-
    otto.c). The bug has real-world impact with OpenWrt on 6.12; hence
    backporting to 6.11.y, 6.12.y, and newer stable series that include
    this driver is appropriate.
  - The patch is self-contained and does not depend on recent framework
    changes.

Conclusion: This is a targeted, low-risk workaround for a serious
hardware erratum affecting deployed systems. It cleanly fits stable
criteria and should be backported to all stable series that contain
`drivers/clocksource/timer-rtl-otto.c`.

 drivers/clocksource/timer-rtl-otto.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/clocksource/timer-rtl-otto.c b/drivers/clocksource/timer-rtl-otto.c
index 8a3068b36e752..8be45a11fb8b6 100644
--- a/drivers/clocksource/timer-rtl-otto.c
+++ b/drivers/clocksource/timer-rtl-otto.c
@@ -38,6 +38,7 @@
 #define RTTM_BIT_COUNT		28
 #define RTTM_MIN_DELTA		8
 #define RTTM_MAX_DELTA		CLOCKSOURCE_MASK(28)
+#define RTTM_MAX_DIVISOR	GENMASK(15, 0)
 
 /*
  * Timers are derived from the LXB clock frequency. Usually this is a fixed
@@ -112,6 +113,22 @@ static irqreturn_t rttm_timer_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void rttm_bounce_timer(void __iomem *base, u32 mode)
+{
+	/*
+	 * When a running timer has less than ~5us left, a stop/start sequence
+	 * might fail. While the details are unknown the most evident effect is
+	 * that the subsequent interrupt will not be fired.
+	 *
+	 * As a workaround issue an intermediate restart with a very slow
+	 * frequency of ~3kHz keeping the target counter (>=8). So the follow
+	 * up restart will always be issued outside the critical window.
+	 */
+
+	rttm_disable_timer(base);
+	rttm_enable_timer(base, mode, RTTM_MAX_DIVISOR);
+}
+
 static void rttm_stop_timer(void __iomem *base)
 {
 	rttm_disable_timer(base);
@@ -129,6 +146,7 @@ static int rttm_next_event(unsigned long delta, struct clock_event_device *clkev
 	struct timer_of *to = to_timer_of(clkevt);
 
 	RTTM_DEBUG(to->of_base.base);
+	rttm_bounce_timer(to->of_base.base, RTTM_CTRL_COUNTER);
 	rttm_stop_timer(to->of_base.base);
 	rttm_set_period(to->of_base.base, delta);
 	rttm_start_timer(to, RTTM_CTRL_COUNTER);
@@ -141,6 +159,7 @@ static int rttm_state_oneshot(struct clock_event_device *clkevt)
 	struct timer_of *to = to_timer_of(clkevt);
 
 	RTTM_DEBUG(to->of_base.base);
+	rttm_bounce_timer(to->of_base.base, RTTM_CTRL_COUNTER);
 	rttm_stop_timer(to->of_base.base);
 	rttm_set_period(to->of_base.base, RTTM_TICKS_PER_SEC / HZ);
 	rttm_start_timer(to, RTTM_CTRL_COUNTER);
@@ -153,6 +172,7 @@ static int rttm_state_periodic(struct clock_event_device *clkevt)
 	struct timer_of *to = to_timer_of(clkevt);
 
 	RTTM_DEBUG(to->of_base.base);
+	rttm_bounce_timer(to->of_base.base, RTTM_CTRL_TIMER);
 	rttm_stop_timer(to->of_base.base);
 	rttm_set_period(to->of_base.base, RTTM_TICKS_PER_SEC / HZ);
 	rttm_start_timer(to, RTTM_CTRL_TIMER);
-- 
2.51.0

