Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D576FC5;
	Thu, 12 Feb 2026 01:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858598; cv=none; b=JOMeH5ytlkHEZDSSdErEbu/1Y/Hl49708ZCLs7ltQlTmbu4Glwas8JhDE1vGAJbN+eCBo2o5oeDmRwxNtAo87vw95BGZVXsOmC7wrmKCFlx6+QgToit6adSdNd358Kz2ysgU9uPFpAy8CjlH2DnnFHuuh2/vZDVwLiRTU2xE05Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858598; c=relaxed/simple;
	bh=eDMN7TeT8gO7bJmdnntSroD7vC4jze3nfAXOLb2c+8k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EjZXcqiO59TaFmp2xLE+hFrp/sUNBB8gw6xmbkYjwBMQorD7jcws7SWmPZn61eqrPujbKVDO5lxMKs9UVkADIOzQWFr1RM6I1l8h7IJ/Jx534Liat7FCp432wLpSXrDwr4L12Y235FptZ9zBNPx14Cjc13Nuu0zK4025TbTu1Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ctbAlRNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ctbAlRNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6C3C4CEF7;
	Thu, 12 Feb 2026 01:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858598;
	bh=eDMN7TeT8gO7bJmdnntSroD7vC4jze3nfAXOLb2c+8k=;
	h=From:To:Cc:Subject:Date:From;
	b=ctbAlRNsU6tC4uNeKUn0eCOwujyZAXv98srbpMcgoCISTvxmWYP78aqdOT22vpY8k
	 EkJoKrcNxkkFzjrXMXeyBYUHx/J2PZCiX1l2kyMlVhbIiC8jnVRAu3X9bMaB+GMndx
	 bu2y8TGDZgw7UFtVA19M9SsSjz4vGtB7o7tMD+/R1dixaWeY56622i2jGKdL1YiZ/U
	 PbzNxxd9un1ZlYtKhAmdJplGWU7oK6gZFeRH03B/0kBOYnSaLSFtAHCPdgk3158hSQ
	 Xz3FHbzhuA+5u055ZcF21kY84MiuKoiWJbh2iixWrTykfhLX5ejEuDKCuxABbIhwMe
	 MX4iAtH1oPvwQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>,
	tglx@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-5.10] clocksource/drivers/sh_tmu: Always leave device running after probe
Date: Wed, 11 Feb 2026 20:09:24 -0500
Message-ID: <20260212010955.3480391-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit b1278972b08e480990e2789bdc6a7c918bc349be ]

The TMU device can be used as both a clocksource and a clockevent
provider. The driver tries to be smart and power itself on and off, as
well as enabling and disabling its clock when it's not in operation.
This behavior is slightly altered if the TMU is used as an early
platform device in which case the device is left powered on after probe,
but the clock is still enabled and disabled at runtime.

This has worked for a long time, but recent improvements in PREEMPT_RT
and PROVE_LOCKING have highlighted an issue. As the TMU registers itself
as a clockevent provider, clockevents_register_device(), it needs to use
raw spinlocks internally as this is the context of which the clockevent
framework interacts with the TMU driver. However in the context of
holding a raw spinlock the TMU driver can't really manage its power
state or clock with calls to pm_runtime_*() and clk_*() as these calls
end up in other platform drivers using regular spinlocks to control
power and clocks.

This mix of spinlock contexts trips a lockdep warning.

    =============================
    [ BUG: Invalid wait context ]
    6.18.0-arm64-renesas-09926-gee959e7c5e34 #1 Not tainted
    -----------------------------
    swapper/0/0 is trying to lock:
    ffff000008c9e180 (&dev->power.lock){-...}-{3:3}, at: __pm_runtime_resume+0x38/0x88
    other info that might help us debug this:
    context-{5:5}
    1 lock held by swapper/0/0:
    ccree e6601000.crypto: ARM CryptoCell 630P Driver: HW version 0xAF400001/0xDCC63000, Driver version 5.0
     #0: ffff8000817ec298
    ccree e6601000.crypto: ARM ccree device initialized
     (tick_broadcast_lock){-...}-{2:2}, at: __tick_broadcast_oneshot_control+0xa4/0x3a8
    stack backtrace:
    CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.18.0-arm64-renesas-09926-gee959e7c5e34 #1 PREEMPT
    Hardware name: Renesas Salvator-X 2nd version board based on r8a77965 (DT)
    Call trace:
     show_stack+0x14/0x1c (C)
     dump_stack_lvl+0x6c/0x90
     dump_stack+0x14/0x1c
     __lock_acquire+0x904/0x1584
     lock_acquire+0x220/0x34c
     _raw_spin_lock_irqsave+0x58/0x80
     __pm_runtime_resume+0x38/0x88
     sh_tmu_clock_event_set_oneshot+0x84/0xd4
     clockevents_switch_state+0xfc/0x13c
     tick_broadcast_set_event+0x30/0xa4
     __tick_broadcast_oneshot_control+0x1e0/0x3a8
     tick_broadcast_oneshot_control+0x30/0x40
     cpuidle_enter_state+0x40c/0x680
     cpuidle_enter+0x30/0x40
     do_idle+0x1f4/0x280
     cpu_startup_entry+0x34/0x40
     kernel_init+0x0/0x130
     do_one_initcall+0x0/0x230
     __primary_switched+0x88/0x90

For non-PREEMPT_RT builds this is not really an issue, but for
PREEMPT_RT builds where normal spinlocks can sleep this might be an
issue. Be cautious and always leave the power and clock running after
probe.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251202221341.1856773-1-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me compile my thorough analysis.

---

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message is thorough and well-written. It clearly describes:
- **The problem**: An invalid wait context lockdep warning (`[ BUG:
  Invalid wait context ]`) on PREEMPT_RT kernels
- **The root cause**: The TMU driver tries to manage PM runtime
  (`pm_runtime_get_sync`/`pm_runtime_put`) and clock state
  (`clk_enable`/`clk_disable`) at runtime, but these calls happen within
  a raw spinlock context from the clockevent framework
- **The fix strategy**: Leave the device and clock always running after
  probe
- **Full stack trace**: Reproduced on real hardware (Renesas Salvator-X
  board with r8a77965 SoC)
- **Tested-by**: Geert Uytterhoeven, a very well-known Renesas platform
  maintainer
- **Signed off by**: Daniel Lezcano, the clocksource subsystem
  maintainer

### 2. CODE CHANGE ANALYSIS - THE BUG MECHANISM

The bug is a **lock ordering / invalid wait context** issue. The precise
call chain is:

1. `cpuidle_enter_state` → `__tick_broadcast_oneshot_control` acquires
   `tick_broadcast_lock` (a **raw spinlock**, lock class `{-...}-{2:2}`)
2. Inside the raw spinlock, `clockevents_switch_state` →
   `sh_tmu_clock_event_set_oneshot` → `sh_tmu_clock_event_set_state` →
   `sh_tmu_enable`
3. `sh_tmu_enable` calls `pm_runtime_get_sync(&ch->tmu->pdev->dev)`
   which tries to acquire `dev->power.lock` (a **regular spinlock**,
   lock class `{-...}-{3:3}`)

I verified this call chain through the code:
- `___tick_broadcast_oneshot_control` (line 796 of `tick-broadcast.c`)
  does `raw_spin_lock(&tick_broadcast_lock)` at the top, then at line
  889 calls `clockevents_switch_state(dev, CLOCK_EVT_STATE_ONESHOT)`
- Similarly, `broadcast_shutdown_local` calls
  `clockevents_switch_state(dev, CLOCK_EVT_STATE_SHUTDOWN)` while
  tick_broadcast_lock is held
- `tick_broadcast_set_event` also calls `clockevents_switch_state`
  within the lock

On **PREEMPT_RT**, regular spinlocks are sleeping locks (they can
schedule). Acquiring a sleeping lock while holding a raw spinlock is
**illegal** - it can cause sleeping in atomic context or deadlock. The
lockdep annotation `{-...}-{2:2}` vs `{-...}-{3:3}` in the stack trace
confirms the context mismatch.

### 3. THE FIX

The patch is a **pure deletion** (18 lines removed, 0 added):

1. **`__sh_tmu_enable()`**: Removes `clk_enable()` call (clock stays
   enabled from probe)
2. **`sh_tmu_enable()`**: Removes `pm_runtime_get_sync()` call (PM
   runtime stays active from probe)
3. **`__sh_tmu_disable()`**: Removes `clk_disable()` call (clock never
   disabled)
4. **`sh_tmu_disable()`**: Removes `pm_runtime_put()` call (PM runtime
   never released)
5. **`sh_tmu_setup()`**: Removes `clk_disable()` after rate measurement
   (clock stays enabled)
6. **`sh_tmu_probe()`**: Removes `pm_runtime_idle()` else branch (PM
   runtime stays active)

The trade-off is slightly higher power consumption (the TMU hardware
stays powered/clocked when not actively timing), but this is acceptable
given the alternative is a hard bug.

### 4. SUSPEND/RESUME SAFETY

I verified the suspend/resume paths still work correctly:
- `sh_tmu_clocksource_suspend` calls `__sh_tmu_disable` (still stops the
  channel) + `dev_pm_genpd_suspend` (handles power domain)
- `sh_tmu_clocksource_resume` calls `dev_pm_genpd_resume` +
  `__sh_tmu_enable` (still restores registers)
- Since `clk_enable` count stays at 1 (never disabled), the clock
  framework correctly restores hardware state after genpd resume

### 5. SCOPE AND RISK

- **Files affected**: 1 file (`drivers/clocksource/sh_tmu.c`)
- **Lines changed**: 18 deletions, 0 additions
- **Risk**: Very low - only removes code that dynamically toggles
  power/clock; the conservative approach (always-on) is simpler and
  safer
- **Regression potential**: The only downside is marginally higher power
  consumption on Renesas platforms using TMU, which is negligible
- **Self-contained**: No dependencies on other patches; the companion
  sh_cmt fix (`62524f285c11`) is for a different driver

### 6. APPLICABILITY TO STABLE TREES

I verified the file is **identical** in stable trees 5.15, 6.1, 6.6,
6.12, and the current HEAD (6.19). The patch will apply cleanly to all
active stable trees without any modification.

### 7. USER IMPACT

- **Who is affected**: Users running PREEMPT_RT kernels on Renesas ARM64
  platforms with TMU timers
- **Severity without fix**: Invalid wait context → potential sleeping in
  atomic context → system instability/hang on PREEMPT_RT
- **PREEMPT_RT relevance**: PREEMPT_RT has been merged into mainline and
  is supported in stable trees (verified PREEMPT_RT fixes exist in
  6.12.y stable). This is increasingly used in embedded/industrial
  systems.

### 8. CLASSIFICATION

This is a **locking/synchronization bug fix**:
- Fixes invalid wait context (raw spinlock → regular spinlock
  acquisition)
- Prevents potential sleeping in atomic context on PREEMPT_RT
- Reproducible with lockdep enabled (PROVE_LOCKING)
- Real-world impact on PREEMPT_RT builds (not theoretical)
- Small, surgical, single-driver fix
- Tested on real hardware
- Reviewed and signed off by subsystem maintainer

**YES** signals:
- Fixes a real lockdep BUG warning (potential deadlock/sleep-in-atomic)
- Small, contained fix (18 line deletions in one file)
- Tested-by experienced maintainer
- Applies cleanly to all stable trees
- No dependencies
- Conservative approach (remove complexity, not add it)

**NO** signals: None identified.

**YES**

 drivers/clocksource/sh_tmu.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index beffff81c00f3..3fc6ed9b56300 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -143,16 +143,6 @@ static void sh_tmu_start_stop_ch(struct sh_tmu_channel *ch, int start)
 
 static int __sh_tmu_enable(struct sh_tmu_channel *ch)
 {
-	int ret;
-
-	/* enable clock */
-	ret = clk_enable(ch->tmu->clk);
-	if (ret) {
-		dev_err(&ch->tmu->pdev->dev, "ch%u: cannot enable clock\n",
-			ch->index);
-		return ret;
-	}
-
 	/* make sure channel is disabled */
 	sh_tmu_start_stop_ch(ch, 0);
 
@@ -174,7 +164,6 @@ static int sh_tmu_enable(struct sh_tmu_channel *ch)
 	if (ch->enable_count++ > 0)
 		return 0;
 
-	pm_runtime_get_sync(&ch->tmu->pdev->dev);
 	dev_pm_syscore_device(&ch->tmu->pdev->dev, true);
 
 	return __sh_tmu_enable(ch);
@@ -187,9 +176,6 @@ static void __sh_tmu_disable(struct sh_tmu_channel *ch)
 
 	/* disable interrupts in TMU block */
 	sh_tmu_write(ch, TCR, TCR_TPSC_CLK4);
-
-	/* stop clock */
-	clk_disable(ch->tmu->clk);
 }
 
 static void sh_tmu_disable(struct sh_tmu_channel *ch)
@@ -203,7 +189,6 @@ static void sh_tmu_disable(struct sh_tmu_channel *ch)
 	__sh_tmu_disable(ch);
 
 	dev_pm_syscore_device(&ch->tmu->pdev->dev, false);
-	pm_runtime_put(&ch->tmu->pdev->dev);
 }
 
 static void sh_tmu_set_next(struct sh_tmu_channel *ch, unsigned long delta,
@@ -552,7 +537,6 @@ static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
 		goto err_clk_unprepare;
 
 	tmu->rate = clk_get_rate(tmu->clk) / 4;
-	clk_disable(tmu->clk);
 
 	/* Map the memory resource. */
 	ret = sh_tmu_map_memory(tmu);
@@ -626,8 +610,6 @@ static int sh_tmu_probe(struct platform_device *pdev)
  out:
 	if (tmu->has_clockevent || tmu->has_clocksource)
 		pm_runtime_irq_safe(&pdev->dev);
-	else
-		pm_runtime_idle(&pdev->dev);
 
 	return 0;
 }
-- 
2.51.0

