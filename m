Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5980303BF1;
	Sun,  1 Jun 2025 23:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821025; cv=none; b=G4lO3cSQ+WYYw9ind7/dw1Eur4gk7T8y3eQHOrAFTzW8NXvB2LNI5Q5IVp6RvGSWOnHyfZYB4iu7rtAUNHUyY0Zb8bNsatOyYZ5JVKS8RBuyG9lTo6welH7dNe1LGyrwQUBUE5xCpJ6pecTnFM7VqKul8B055U/d45T+wmDK9RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821025; c=relaxed/simple;
	bh=hr95H+EQED96vd1xQnOVdC9R2WoCM4lZqmScNMPGxYU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=diWvTxvqvD6RtKMubnk1mZmc19jRWZ0vbdrS5USwoyB2xRuAD/WwHwyHnbv2QpkxXbkiZYuanxnZj/3Wjh8MNLhKNRIjDo5m8wIGddqsZCYfGOLpZRyVYgFdbB0hyRN20kS5GpcxAfBDMOgUDkIZX5boGePJHphflfhljjZ8Ums=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cWCnneuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cWCnneuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDA5C4CEE7;
	Sun,  1 Jun 2025 23:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821025;
	bh=hr95H+EQED96vd1xQnOVdC9R2WoCM4lZqmScNMPGxYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cWCnneuUVTQnlGhVjPrBqHxai0ZlwuLLUbM7fYn2Ufr3+KYcsAJU9/aAmq49m/g3W
	 sytgJGcK04zsFB71uPhblgi0gUKA0qy3O3MgkD82+3Yx6289qUwJA+z2QO4vEpIZXw
	 7vy9l/eJDP14B7jvR/oLPHHrLaLV97M7WZw2LmTiW6Qcna0HALo+Sie31MPG8MKUeD
	 FQ7P5KJxLdcO6P6CFIVUfF+AEAQQUSLnVwRBXlHVa9++eEENXj/dBJez0srw3g5GLJ
	 tPQBzUHrG8vhem6/dMZWsFh3uKp6IJMey/yIDh4X2yN0h3caStluGsufNT+477Kn4Z
	 CY+88kyYV3FLA==
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
Subject: [PATCH AUTOSEL 6.12 74/93] clocksource/drivers/timer-tegra186: Fix watchdog self-pinging
Date: Sun,  1 Jun 2025 19:33:41 -0400
Message-Id: <20250601233402.3512823-74-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601233402.3512823-1-sashal@kernel.org>
References: <20250601233402.3512823-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
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
index 304537dadf2c1..ebe3ffa79591a 100644
--- a/drivers/clocksource/timer-tegra186.c
+++ b/drivers/clocksource/timer-tegra186.c
@@ -169,9 +169,6 @@ static void tegra186_wdt_enable(struct tegra186_wdt *wdt)
 		value &= ~WDTCR_PERIOD_MASK;
 		value |= WDTCR_PERIOD(1);
 
-		/* enable local interrupt for WDT petting */
-		value |= WDTCR_LOCAL_INT_ENABLE;
-
 		/* enable local FIQ and remote interrupt for debug dump */
 		if (0)
 			value |= WDTCR_REMOTE_INT_ENABLE |
@@ -365,23 +362,10 @@ static int tegra186_timer_usec_init(struct tegra186_timer *tegra)
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
@@ -400,8 +384,6 @@ static int tegra186_timer_probe(struct platform_device *pdev)
 	if (err < 0)
 		return err;
 
-	irq = err;
-
 	/* create a watchdog using a preconfigured timer */
 	tegra->wdt = tegra186_wdt_create(tegra, 0);
 	if (IS_ERR(tegra->wdt)) {
@@ -428,17 +410,8 @@ static int tegra186_timer_probe(struct platform_device *pdev)
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

