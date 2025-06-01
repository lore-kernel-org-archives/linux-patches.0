Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37082277819;
	Sun,  1 Jun 2025 23:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821320; cv=none; b=SJEGcnEUtPCJtONMQqJHqhzxWkwcKKlSO4zH++m48xNesqhFKZUgU6vNp6vSQDbz3WDDtAa7R9rCgUDSzuYtW5m9ZkRhRSxCzKhA/xKjZ7Soae4IX1X8RljdZYlzEAhHglHcRwWM9qkghLpMDO8/r3BUjCAKTO66Yth6Cfym2T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821320; c=relaxed/simple;
	bh=iM6pSY8Ai8HR8vYaQD4zoZGOMR+lQ36214XZMXiXmtM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=chKqWBtPWgc1uO7ImXlJby4M0FxES6p23XrBNSpsjg0v0+oOa28o7qxlNadjeBjsMmBx1z2WTmqHVLhnIHEzPfhBDlYiW9gGQ6V1hCDavKeYZKVFO5Ofxn+O7AxcJhgEGUzccxdskXAZR2VOWcOkZQAPLGlhfXCwrF9DB4P6A8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJ21XwFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJ21XwFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEC8C4CEF1;
	Sun,  1 Jun 2025 23:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821319;
	bh=iM6pSY8Ai8HR8vYaQD4zoZGOMR+lQ36214XZMXiXmtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJ21XwFVDnOdzFVbaLdAPG0AqODA8AGjR+4dblO+hwhtgoNaN3VEfL3lILqZMyWgi
	 J/ftPFBqzbNYt9Lv+cewzwrCfQkRJWatmPVr3MQ2HSd0n/1C8KCsmnB+z0h/lw5eWa
	 BpURQDy9cp0BGAqWtxrPGKSRZGZAl+D2uTC7QP467w3nokOqhlFr0YP1kXcf8wqc6t
	 mroFTrHrWD0do881jLZem0tBZ2wbkYZ+gSZUG2oHykvuFkTdMA7dhvsXA/2jtJ2YuE
	 XzPI69riWN+qbIHNUmZfeHXDGkmQrj5q+J4M6CjQPcQksw+etMrrbhemWiwFlFX3vf
	 nMHXogFmHWyAQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pohsun Su <pohsuns@nvidia.com>,
	Robert Lin <robelin@nvidia.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	tglx@linutronix.de,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 46/58] clocksource/drivers/timer-tegra186: Fix watchdog self-pinging
Date: Sun,  1 Jun 2025 19:39:59 -0400
Message-Id: <20250601234012.3516352-46-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601234012.3516352-1-sashal@kernel.org>
References: <20250601234012.3516352-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.140
Content-Transfer-Encoding: 8bit

From: Pohsun Su <pohsuns@nvidia.com>

[ Upstream commit b42d781e0350c969ef8155b800e33400f5f8b8a6 ]

This change removes watchdog self-pinging behavior.

The timer irq handler is triggered due to the 1st expiration,
the handler disables and enables watchdog but also implicitly
clears the expiration count so the count can only be 0 or 1.

Since this watchdog supports opened, configured, or pinged by
systemd, We remove this behavior or the watchdog may not bark
when systemd crashes since the 5th expiration never comes.

Signed-off-by: Pohsun Su <pohsuns@nvidia.com>
Signed-off-by: Robert Lin <robelin@nvidia.com>
Link: https://lore.kernel.org/r/20250507044311.3751033-3-robelin@nvidia.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

## YES **Extensive Analysis:** This commit should be backported to
stable kernel trees as it fixes a critical watchdog functionality bug
that affects system reliability and crash recovery. ### Code Changes
Analysis: **1. Removal of Self-Pinging IRQ Handler (lines 368-378):**
The commit removes the `tegra186_timer_irq()` function that was
automatically resetting the watchdog on first timeout. This function was
calling `tegra186_wdt_disable()` followed by `tegra186_wdt_enable()`,
which had the side effect of clearing the expiration count. **2. Removal
of Local Interrupt Enable (line 173):** The code removes `value |=
WDTCR_LOCAL_INT_ENABLE;` from `tegra186_wdt_enable()`, which was
enabling the interrupt that triggered the self-pinging behavior. **3.
Removal of IRQ Infrastructure (lines 384, 403, 431-436):** The commit
removes the IRQ request and associated error handling since the IRQ is
no longer needed without the self-pinging behavior. ### Why This Should
Be Backported: **1. Critical Bug Fix:** This addresses a fundamental
flaw where the watchdog would never reach its intended 5th expiration
because the IRQ handler was resetting the count after the 1st
expiration. The comment in the original code states "system reset
happens on the fifth expiration" (line 156/157), but this never occurred
due to the self-pinging. **2. System Reliability Impact:** When systemd
or other watchdog managers crash, the system should reboot via watchdog
timeout. With the old behavior, systems would hang indefinitely instead
of recovering, which is a serious reliability issue in production
environments. **3. Hardware Design Intent:** The Tegra186 watchdog is
designed to count 5 expirations before resetting the system. The self-
pinging behavior was defeating this safety mechanism, making the
watchdog unreliable for its primary purpose. **4. Minimal Risk:** - The
change is small and well-contained - It removes problematic code rather
than adding complex new logic - No new features or architectural changes
- Follows the "do one thing well" principle for watchdogs **5. Clear
User Impact:** Systems using Tegra186/234 SoCs with systemd or other
watchdog daemons would benefit from proper crash recovery functionality.
**6. Stable Tree Suitability:** - Fixes an important bug affecting users
- Small, contained change with minimal regression risk - No new features
introduced - Affects a specific hardware platform (limited blast radius)
The commit properly removes flawed self-recovery logic that was
preventing the watchdog from functioning as designed, making systems
more reliable by ensuring proper reboot behavior when watchdog daemons
fail.

 drivers/clocksource/timer-tegra186.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/clocksource/timer-tegra186.c b/drivers/clocksource/timer-tegra186.c
index ea742889ee067..cbe8d33cbb018 100644
--- a/drivers/clocksource/timer-tegra186.c
+++ b/drivers/clocksource/timer-tegra186.c
@@ -170,9 +170,6 @@ static void tegra186_wdt_enable(struct tegra186_wdt *wdt)
 		value &= ~WDTCR_PERIOD_MASK;
 		value |= WDTCR_PERIOD(1);
 
-		/* enable local interrupt for WDT petting */
-		value |= WDTCR_LOCAL_INT_ENABLE;
-
 		/* enable local FIQ and remote interrupt for debug dump */
 		if (0)
 			value |= WDTCR_REMOTE_INT_ENABLE |
@@ -366,23 +363,10 @@ static int tegra186_timer_usec_init(struct tegra186_timer *tegra)
 	return clocksource_register_hz(&tegra->usec, USEC_PER_SEC);
 }
 
-static irqreturn_t tegra186_timer_irq(int irq, void *data)
-{
-	struct tegra186_timer *tegra = data;
-
-	if (watchdog_active(&tegra->wdt->base)) {
-		tegra186_wdt_disable(tegra->wdt);
-		tegra186_wdt_enable(tegra->wdt);
-	}
-
-	return IRQ_HANDLED;
-}
-
 static int tegra186_timer_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct tegra186_timer *tegra;
-	unsigned int irq;
 	int err;
 
 	tegra = devm_kzalloc(dev, sizeof(*tegra), GFP_KERNEL);
@@ -401,8 +385,6 @@ static int tegra186_timer_probe(struct platform_device *pdev)
 	if (err < 0)
 		return err;
 
-	irq = err;
-
 	/* create a watchdog using a preconfigured timer */
 	tegra->wdt = tegra186_wdt_create(tegra, 0);
 	if (IS_ERR(tegra->wdt)) {
@@ -429,17 +411,8 @@ static int tegra186_timer_probe(struct platform_device *pdev)
 		goto unregister_osc;
 	}
 
-	err = devm_request_irq(dev, irq, tegra186_timer_irq, 0,
-			       "tegra186-timer", tegra);
-	if (err < 0) {
-		dev_err(dev, "failed to request IRQ#%u: %d\n", irq, err);
-		goto unregister_usec;
-	}
-
 	return 0;
 
-unregister_usec:
-	clocksource_unregister(&tegra->usec);
 unregister_osc:
 	clocksource_unregister(&tegra->osc);
 unregister_tsc:
-- 
2.39.5

