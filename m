Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4888721C9E5;
	Thu,  9 Oct 2025 16:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025676; cv=none; b=qr9Anq8QfUHYMf3uGIWnSUjQOBavgdfvdk2E+e9dfB9gLBV4K2z5l/l0FijUaN5vHoCgbV7+A3XOVDoj/3T9V0qQUZnXCmPy074IwGbNIQZ007HPVyNw9SlzJVEw5qXIBn7uvuAtN1Nnr5fDzhVwPsrB2xAmdXdNQZEuzAMtDwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025676; c=relaxed/simple;
	bh=fnycNGwfec3l+SsjOOItCXsCXGjvx0s17N4BpESMjrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=drvfZ7urWj1tPFCHZ6F8WwEHGVQaVLp7Zs8UFPuHRAFT939LIyOWeEW7w/drUVwfF3xXJU3jZH3LXhu2jP5/b1FQYKG/dx5Sw+zcBVTVJRkNaCv+T3Yyk/4pI10Do7RxKMQ1s0pitEBloHoxO/XTNSBlEfA7wEnDkzAp+VslHMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fhgqtzrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fhgqtzrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F2AC4CEF7;
	Thu,  9 Oct 2025 16:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025676;
	bh=fnycNGwfec3l+SsjOOItCXsCXGjvx0s17N4BpESMjrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fhgqtzrc4Gz10XKF8u866Wj9z+ZRpvHgOyL6MiSZG19WN/daY49uodHRDVzNhdHEb
	 YBPdyFAFDdjjrrgxm+iUjdPkiRlc2hXaGCZtk4tIYw9M8Qh+lIvtepIxOG2e74xXmn
	 +27tC4X9w3dHaXjALjUQimXZEOW0MqcMX4o9aFKoZb8aLzZfjpMRVqrPux+s/5Zlr4
	 Hd2Xh+1uga3UzdWpx0vpEW3hufZODWbwu+wTAlO1dDtSluDSIsoPimbfDrKwG7gz74
	 XDl0nFwn+sX4Eu2f29woJP3RT183cKcpIJEkzMIhtkPhCM2nVVnzSjDI4XtiVgxmnP
	 VUBQfz/djNSBw==
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
Subject: [PATCH AUTOSEL 6.17-6.12] clocksource/drivers/timer-rtl-otto: Do not interfere with interrupts
Date: Thu,  9 Oct 2025 11:56:15 -0400
Message-ID: <20251009155752.773732-109-sashal@kernel.org>
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

[ Upstream commit c445bffbf28f721e05d0ce06895045fc62aaff7c ]

During normal operation the timers are reprogrammed including an
interrupt acknowledgement. This has no effect as the whole timer
is setup from scratch afterwards. Especially in an interrupt this
has already been done by rttm_timer_interrupt().

Change the behaviour as follows:

- Use rttm_disable_timer() during reprogramming
- Keep rttm_stop_timer() for all other use cases.

Downstream has already tested and confirmed a patch. See
https://github.com/openwrt/openwrt/pull/19468
https://forum.openwrt.org/t/support-for-rtl838x-based-managed-switches/57875/3788

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Tested-by: Stephen Howell <howels@allthatwemight.be>
Tested-by: Bjørn Mork <bjorn@mork.no>
Link: https://lore.kernel.org/r/20250804080328.2609287-4-markus.stockhausen@gmx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - The driver was acknowledging the interrupt (“W1C” PENDING bit) as
    part of routine timer reprogramming, not just in the interrupt
    handler. That read-modify-write ack can race with new pending
    interrupts and clear them, leading to occasional lost timer
    interrupts. The change confines IRQ acknowledgement to the interrupt
    handler and explicit stop/shutdown paths, preventing interference
    with in-flight or newly arriving interrupts.

- Exact code changes
  - In the reprogramming paths, `rttm_stop_timer()` (which disables the
    timer and acks the IRQ) is replaced with `rttm_disable_timer()`
    (disable only), so the PENDING bit is no longer touched during
    normal reprogramming:
    - `drivers/clocksource/timer-rtl-otto.c:141-146` changes
      reprogramming for oneshot next-event (now disable → set period →
      start, without ack).
    - `drivers/clocksource/timer-rtl-otto.c:153-159` changes
      `rttm_state_oneshot()` similarly.
    - `drivers/clocksource/timer-rtl-otto.c:166-172` changes
      `rttm_state_periodic()` similarly.
  - IRQ acknowledgement remains where it belongs:
    - Interrupt handler acks before invoking the event handler:
      `drivers/clocksource/timer-rtl-otto.c:97-106` and specifically the
      ack helper at `drivers/clocksource/timer-rtl-otto.c:77-80`.
    - Stop/shutdown/init paths still ack via `rttm_stop_timer()`:
      - Shutdown: `drivers/clocksource/timer-rtl-otto.c:175-182`
      - Setup: `drivers/clocksource/timer-rtl-otto.c:185-190`
      - `rttm_stop_timer()` itself still does disable + ack:
        `drivers/clocksource/timer-rtl-otto.c:125-129`.

- Why the original behavior is problematic
  - The ack function is implemented as a read-modify-write to a W1C bit:
    `ioread32(base + RTTM_INT) | RTTM_INT_PENDING` followed by a write
    (`drivers/clocksource/timer-rtl-otto.c:77-80`). If a new interrupt
    becomes pending between the read and the write, the write will still
    set the PENDING bit in the value and clear it on write, effectively
    dropping that freshly latched interrupt. Calling this sequence
    outside the ISR (e.g., during reprogramming) can therefore interfere
    with normal interrupt delivery.

- Why this change is safe
  - In-ISR reprogramming: The handler already acknowledges the interrupt
    at entry (`drivers/clocksource/timer-rtl-otto.c:102`). Removing a
    second ack during reprogramming eliminates a window where a new
    pending interrupt could be inadvertently cleared.
  - Non-ISR reprogramming: If a pending bit exists, not acking ensures
    it will be properly handled by the ISR when it fires, rather than
    being silently cleared by a stray reprogramming ack.
  - Ack is still performed at shutdown/setup where it is appropriate to
    clear stale state (`drivers/clocksource/timer-rtl-otto.c:175-190`),
    so there is no accumulation of stale flags.

- Context and related fixes
  - This change is part of a small, focused series addressing timer
    reliability on Realtek Otto platforms:
    - “Work around dying timers” added `rttm_bounce_timer()` to avoid
      reprogramming in a critical ~5us window before expiry (hardware
      peculiarity) and is used directly before reprogramming in all the
      altered paths (`drivers/clocksource/timer-rtl-otto.c:109-123` and
      calls at 141, 154, 167).
    - “Drop set_counter” cleaned up a no-op write to the current
      counter.
  - The series was tested downstream (OpenWrt) and carries multiple
    Tested-by tags; the commit under review also notes downstream
    confirmation.

- Backport considerations
  - Scope: Single driver file; changes are three substitutions of
    `rttm_stop_timer()` with `rttm_disable_timer()` in reprogramming
    paths. No functional/ABI changes outside this driver.
  - Dependencies: None strict. If a stable branch does not yet have
    `rttm_bounce_timer()`, the underlying correctness argument for using
    `rttm_disable_timer()` instead of `rttm_stop_timer()` during
    reprogramming still holds. For branches already including the bounce
    patch (as in newer stables), this applies cleanly.
  - Risk: Low. Potential for an extra immediate interrupt if a PENDING
    bit remained set is mitigated because the ISR acks and the
    clockevents layer tolerates such re-entries; conversely, the change
    removes a race that could drop interrupts, which is more severe.

- Stable policy fit
  - Fixes a real bug affecting users (lost or interfered interrupts on
    rtl-otto platforms).
  - Small, contained, and without architectural changes.
  - Confined to `drivers/clocksource/timer-rtl-otto.c`.
  - Already tested downstream and reviewed/merged upstream (commit
    c445bffbf28f7).
  - While there is no explicit “Cc: stable” in the commit message, the
    change meets stable backport criteria and aligns with the prior
    reliability fix series for this driver.

Conclusion: Backporting this patch reduces the risk of lost timer
interrupts by avoiding unnecessary and racy IRQ acknowledgements during
reprogramming, with minimal regression risk and limited scope.

 drivers/clocksource/timer-rtl-otto.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/timer-rtl-otto.c b/drivers/clocksource/timer-rtl-otto.c
index 8be45a11fb8b6..24c4aa6a30131 100644
--- a/drivers/clocksource/timer-rtl-otto.c
+++ b/drivers/clocksource/timer-rtl-otto.c
@@ -147,7 +147,7 @@ static int rttm_next_event(unsigned long delta, struct clock_event_device *clkev
 
 	RTTM_DEBUG(to->of_base.base);
 	rttm_bounce_timer(to->of_base.base, RTTM_CTRL_COUNTER);
-	rttm_stop_timer(to->of_base.base);
+	rttm_disable_timer(to->of_base.base);
 	rttm_set_period(to->of_base.base, delta);
 	rttm_start_timer(to, RTTM_CTRL_COUNTER);
 
@@ -160,7 +160,7 @@ static int rttm_state_oneshot(struct clock_event_device *clkevt)
 
 	RTTM_DEBUG(to->of_base.base);
 	rttm_bounce_timer(to->of_base.base, RTTM_CTRL_COUNTER);
-	rttm_stop_timer(to->of_base.base);
+	rttm_disable_timer(to->of_base.base);
 	rttm_set_period(to->of_base.base, RTTM_TICKS_PER_SEC / HZ);
 	rttm_start_timer(to, RTTM_CTRL_COUNTER);
 
@@ -173,7 +173,7 @@ static int rttm_state_periodic(struct clock_event_device *clkevt)
 
 	RTTM_DEBUG(to->of_base.base);
 	rttm_bounce_timer(to->of_base.base, RTTM_CTRL_TIMER);
-	rttm_stop_timer(to->of_base.base);
+	rttm_disable_timer(to->of_base.base);
 	rttm_set_period(to->of_base.base, RTTM_TICKS_PER_SEC / HZ);
 	rttm_start_timer(to, RTTM_CTRL_TIMER);
 
-- 
2.51.0

