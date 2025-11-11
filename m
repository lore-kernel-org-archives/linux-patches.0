Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BB9246768;
	Tue, 11 Nov 2025 01:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822999; cv=none; b=PBnZf5C8UEjrInApzESCIlbbVRMI6O+8fPgmwg9VvR/T8MShQb7Lh4S/46CdloOstV29lbV/udY/EMdBjOiVZLT1oWlZIvx7QPt6EoZhnOwOm3G07INQ9rxZoBxxVNOsebamk4UaYaMl5tzyWGs0m+ogR9xccObP6g/GVlZr8VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822999; c=relaxed/simple;
	bh=/5B7/OatzbjARqffTFFOFy8Eg6YaYqGV4QH5R+qwS7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oRVjGCFhKQeN3gYW4P8D1wyIQGQrPfqDZbtmYVjcT9hu177WJmBp20RX9K5q1AIN3YnNZ+6YENjSL8LqN59Mz+E800p0kVcmXZSgp5MnnYBu8kotg5i3S+OkReyK9TeWvFnH+qkkoao+DvqswrgptUT9buO/C/EYPc7iwW6tmQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6nfUX7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6nfUX7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584ACC116B1;
	Tue, 11 Nov 2025 01:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822999;
	bh=/5B7/OatzbjARqffTFFOFy8Eg6YaYqGV4QH5R+qwS7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6nfUX7Fsnmh4UJGdRzEoSLiLfm179I1pM9qM2sysfBIP5QZ4N5Vl+OmJ0Fz3AqF5
	 ri2Hz311hihQ7B5HeoKA8rxHdM8NSNBmELMqoaVh4PI7ou4CoD1NYm4vU7qEXLrFmA
	 8kaPHo6N5tvBMvKGAmdk+Y/or9c7LrIUudmhi1Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Stephen Howell <howels@allthatwemight.be>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/565] clocksource/drivers/timer-rtl-otto: Work around dying timers
Date: Tue, 11 Nov 2025 09:40:08 +0900
Message-ID: <20251111004530.360237128@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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



