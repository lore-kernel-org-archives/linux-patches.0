Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5905B1D5ABA;
	Sat, 14 Feb 2026 01:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031141; cv=none; b=h4LYhu7oQ69RSpqQx4ZjU7PLygiWmJ6jdVKb5520i8Beq2koHagqrwJjjNERZmeDCvkMdf/S9KetIM7fWzdEwP3Ol/3G4fER45b9v9rgB2rQrj05XVVeYPdBPVdT4TBxfA7pXgmgAfBHx1I6XN7ypVy3kGCbIh1DqvnH2107IUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031141; c=relaxed/simple;
	bh=PaO56kiA8/v9E8MkTgfzvmtNojBYeVDqlrH9GB3WikI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3xqx0lDA2g00KEcrS9csjtSZr70ArnJgG7JHKce1qJNSmKdtx7XWQROdn3mxHGSsqB9VeKM1pwrPZpIM4NjLugpy3SjhJW385RKNTSd/RvyE8SFLjm1bydmFNpHsjFc9JvejJ7G29aVg71b5GJbOQQhQQpklwi7RqtUbHGK4lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MhWuih4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MhWuih4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9186DC116C6;
	Sat, 14 Feb 2026 01:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031141;
	bh=PaO56kiA8/v9E8MkTgfzvmtNojBYeVDqlrH9GB3WikI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhWuih4VyFED3pBhOV4qErPOvR0Yyi9EOe7Poav2Rne1Z8ygrl7hAGGRQGfVptGp6
	 RXhHps9jWM7dJb2Z1yMsLQ7PGTvrm1k5eM/dNGIzzhnmjJcxPrNcMfaLRzMc8hgvRY
	 Uz1FxOf3U2E9jGohk23blUFpTDz3yug5W8CHKCU3TKBkU3OwtCx+NguRiy3sKzM9LE
	 LNj+OOQmasajGl0vILw2cdyg70r6NlkyC3FGDwxS2YgzDx57R0hWAzDIW2ds7Y8vB3
	 5hqBIfbu2L75Cn8cACkuE2zrq0ptp5xKt17GGQ9jJ0vget1Lnmogh2aedKhWdvM8WH
	 SY0R+TcnZLdSw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] spi: cadence-quadspi: Parse DT for flashes with the rest of the DT parsing
Date: Fri, 13 Feb 2026 19:59:19 -0500
Message-ID: <20260214010245.3671907-79-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 9f0736a4e136a6eb61e0cf530ddc18ab6d816ba3 ]

The recent refactoring of where runtime PM is enabled done in commit
f1eb4e792bb1 ("spi: spi-cadence-quadspi: Enable pm runtime earlier to
avoid imbalance") made the fact that when we do a pm_runtime_disable()
in the error paths of probe() we can trigger a runtime disable which in
turn results in duplicate clock disables.  This is particularly likely
to happen when there is missing or broken DT description for the flashes
attached to the controller.

Early on in the probe function we do a pm_runtime_get_noresume() since
the probe function leaves the device in a powered up state but in the
error path we can't assume that PM is enabled so we also manually
disable everything, including clocks. This means that when runtime PM is
active both it and the probe function release the same reference to the
main clock for the IP, triggering warnings from the clock subsystem:

[    8.693719] clk:75:7 already disabled
[    8.693791] WARNING: CPU: 1 PID: 185 at /usr/src/kernel/drivers/clk/clk.c:1188 clk_core_disable+0xa0/0xb
...
[    8.694261]  clk_core_disable+0xa0/0xb4 (P)
[    8.694272]  clk_disable+0x38/0x60
[    8.694283]  cqspi_probe+0x7c8/0xc5c [spi_cadence_quadspi]
[    8.694309]  platform_probe+0x5c/0xa4

Dealing with this issue properly is complicated by the fact that we
don't know if runtime PM is active so can't tell if it will disable the
clocks or not.  We can, however, sidestep the issue for the flash
descriptions by moving their parsing to when we parse the controller
properties which also save us doing a bunch of setup which can never be
used so let's do that.

Reported-by: Francesco Dolcini <francesco@dolcini.it>
Closes: https://lore.kernel.org/r/20251201072844.GA6785@francesco-nb
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20251204-spi-cadence-qspi-runtime-pm-imbalance-v2-1-10af9115d531@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information I need. Let me compile a comprehensive
analysis.

---

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit by Mark Brown (SPI subsystem maintainer) addresses a double
clock disable triggered during `cqspi_probe()` error handling,
specifically when device tree flash descriptions are missing or broken.
The commit references:

- **Root cause commit**: `f1eb4e792bb1` ("spi: spi-cadence-quadspi:
  Enable pm runtime earlier to avoid imbalance") - merged in v6.18
- **Reporter**: Francesco Dolcini (Toradex engineer) with a specific bug
  link
- **Symptom**: Kernel WARNING "clk:75:7 already disabled" plus a full
  stack trace from `clk_core_disable` -> `clk_disable` -> `cqspi_probe`

### 2. CODE CHANGE ANALYSIS

The change is very simple: it moves the `cqspi_setup_flash()` call from
**after** PM runtime is configured to **before** any resource
acquisition:

**Before (current v6.19 code)** - `cqspi_setup_flash()` at line 1990,
after pm_runtime_enable + pm_runtime_get_noresume:

```1983:1994:/home/sasha/linux-autosel/drivers/spi/spi-cadence-quadspi.c
        if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM))) {
                pm_runtime_enable(dev);
                pm_runtime_set_autosuspend_delay(dev,
CQSPI_AUTOSUSPEND_TIMEOUT);
                pm_runtime_use_autosuspend(dev);
                pm_runtime_get_noresume(dev);
        }

        ret = cqspi_setup_flash(cqspi);
        if (ret) {
                dev_err(dev, "failed to setup flash parameters %d\n",
ret);
                goto probe_setup_failed;
        }
```

**After (with patch applied)** - `cqspi_setup_flash()` right after
`cqspi_of_get_pdata()`, before clock/resource acquisition:

```c
        ret = cqspi_of_get_pdata(cqspi);
        if (ret) { ... return -ENODEV; }

        ret = cqspi_setup_flash(cqspi);
        if (ret) {
                dev_err(dev, "failed to setup flash parameters %d\n",
ret);
                return ret;
        }

        /* Obtain QSPI clock. */
        cqspi->clk = devm_clk_get(dev, NULL);
```

**Why this is safe**: Looking at `cqspi_setup_flash()` (lines
1727-1765), it:
- Iterates device tree child nodes with
  `for_each_available_child_of_node_scoped`
- Reads DT properties (`reg`, `cdns,read-delay`, `cdns,tshsl-ns`, etc.)
- Populates `f_pdata` structures and `cqspi->num_chipselect`
- Has **zero** hardware dependencies (no clock access, no IO access, no
  IRQ, no PM runtime)

Its only dependency is `cqspi->num_chipselect` which is set by
`cqspi_of_get_pdata()` (called just before in both old and new code).

### 3. THE BUG MECHANISM

The error path when `cqspi_setup_flash()` fails in the current code:

```2021:2033:/home/sasha/linux-autosel/drivers/spi/spi-cadence-quadspi.c
probe_setup_failed:
        if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM)))
                pm_runtime_disable(dev);
        cqspi_controller_enable(cqspi, 0);
probe_reset_failed:
        if (cqspi->is_jh7110)
                cqspi_jh7110_disable_clk(pdev, cqspi);

        if (pm_runtime_get_sync(&pdev->dev) >= 0)
                clk_disable_unprepare(cqspi->clk);
probe_clk_failed:
        return ret;
```

The problem: `pm_runtime_disable()` can interact with the PM runtime
state in a way that the runtime suspend callback
(`cqspi_runtime_suspend`) gets invoked, which calls
`clk_disable_unprepare(cqspi->clk)`. Then the error path falls through
to `probe_reset_failed` which also calls
`clk_disable_unprepare(cqspi->clk)` via `pm_runtime_get_sync()` +
explicit disable, causing the double disable WARNING.

### 4. FIX APPROACH COMPARISON

This commit represents the subsystem maintainer's preferred approach.
Instead of patching the complex error path interactions (as done in the
earlier attempts: `295fe8406a357`, `1889dd2081975`), it eliminates the
problem entirely by moving the DT parsing before any resource that needs
cleanup. If flash DT is broken, probe fails with a simple `return` - no
PM runtime, no clocks, nothing to clean up.

### 5. CLASSIFICATION AND IMPACT

- **Bug type**: Resource management error (double clock disable) causing
  kernel WARNING
- **Severity**: Medium - kernel WARNING, potential clock framework
  confusion
- **Trigger**: Missing or broken DT flash descriptions for Cadence QSPI
  controller
- **Real-world impact**: Confirmed by Francesco Dolcini (Toradex), a
  major embedded Linux vendor
- **Affected versions**: v6.18+ (where `f1eb4e792bb1` was merged)

### 6. SCOPE AND RISK

- **Lines changed**: ~12 lines moved (6 lines added in new location, 6
  lines removed from old location)
- **Files changed**: 1 (`drivers/spi/spi-cadence-quadspi.c`)
- **Risk**: Very low - pure DT parsing function moved earlier with no
  functional side effects
- **Author**: Mark Brown, the SPI subsystem maintainer

### 7. DEPENDENCIES

- Requires `f1eb4e792bb1` in the tree (v6.18+) since that's the commit
  that introduced the regression
- Compatible with `295fe8406a357` and `1889dd2081975` which are also
  present
- Self-contained; no other patches needed

### 8. STABLE CRITERIA CHECK

- **Obviously correct and tested**: Yes - authored by subsystem
  maintainer, function only does DT parsing
- **Fixes a real bug**: Yes - double clock disable with kernel WARNING
- **Important issue**: Yes - regression from v6.18 on real hardware
- **Small and contained**: Yes - ~12 lines in 1 file
- **No new features**: Correct - pure bug fix
- **Reported-by**: Francesco Dolcini with bug link

**YES**

 drivers/spi/spi-cadence-quadspi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 965b4cea3388a..597a04dbbe2e7 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1844,6 +1844,12 @@ static int cqspi_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	ret = cqspi_setup_flash(cqspi);
+	if (ret) {
+		dev_err(dev, "failed to setup flash parameters %d\n", ret);
+		return ret;
+	}
+
 	/* Obtain QSPI clock. */
 	cqspi->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(cqspi->clk)) {
@@ -1987,12 +1993,6 @@ static int cqspi_probe(struct platform_device *pdev)
 		pm_runtime_get_noresume(dev);
 	}
 
-	ret = cqspi_setup_flash(cqspi);
-	if (ret) {
-		dev_err(dev, "failed to setup flash parameters %d\n", ret);
-		goto probe_setup_failed;
-	}
-
 	host->num_chipselect = cqspi->num_chipselect;
 
 	if (ddata && (ddata->quirks & CQSPI_SUPPORT_DEVICE_RESET))
-- 
2.51.0

