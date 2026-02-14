Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84271D54FA;
	Sat, 14 Feb 2026 01:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031143; cv=none; b=d7aWtmFWN+STyaYS4/VdO9myO29s0Yo2DqlfroqxLHLwK8uXbhwPTvQRj671xE2cZ6sHznWNPdLGuqw6k3pfUe5CL843NCElgpLdBA+c2/1udCYZeRd54HkxeMLWAHHX+owVP6GbFZ/A1LTWxC1o4ZL++BabO0HjL2baLkJG5KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031143; c=relaxed/simple;
	bh=kq4TfTbU0rUqXKJMS9hy8Q/6kbdgI7b7WWulMBha2Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S16/JJj7snr6jsgy+ZT+ZArmuOX3REFwrpuqcDs0Zr/0JehvFAEbUO0WoixTFyS/cUm4NTLJsgF1V+3KX+Z97ys9DZ1zePU5BC21fzL1n6YRfZ6DKw6AyYdbIbe8EGZ7qxeX7omNTjyRBtxwNoVcyN0Cadgij2RPyVsSZZPGlxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pBGY+BxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pBGY+BxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB06C19423;
	Sat, 14 Feb 2026 01:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031143;
	bh=kq4TfTbU0rUqXKJMS9hy8Q/6kbdgI7b7WWulMBha2Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBGY+BxS1r9VXUaIfOtUrts3gwEIKeON+qEJsLOen7YDcCYoXU30YE9YsaiADq/rA
	 ROb5HTX9eJY+rTK6TXu8ns2psKtbf64JZzZTQ7V4A4ajtqzWbQDDUybbYjuvEnRzKQ
	 QyiwU3JmE7ZGJHOQ9psl9Ds5hxI9oQo9LAk5Ei1vn17pGGZCsY3MVX9ePatX//0rzJ
	 o7fzMRb5uqNa5PsvVSM2ee1OaMmZVYQg1shl1A9fAty0sEFB//iiI+CrgGAi1x8inV
	 480KyHmcnTyj5Xw+CEfwHukUuTWRvVapATXBmPTedFOlHSIIs6AIugCQi5oaJqSPsA
	 Eq2+HJp+BomMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Santhosh Kumar K <s-k6@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] spi: cadence-qspi: Fix probe error path and remove
Date: Fri, 13 Feb 2026 19:59:21 -0500
Message-ID: <20260214010245.3671907-81-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>

[ Upstream commit f18c8cfa4f1af2cf7d68d86989a7d6109acfa1bb ]

The probe has been modified by many different users, it is hard to track
history, but for sure its current state is partially broken. One easy
rule to follow is to drop/free/release the resources in the opposite
order they have been queried.

Fix the labels, the order for freeing the resources, and add the
missing DMA channel step. Replicate these changes in the remove path as
well.

Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
Tested-by: Santhosh Kumar K <s-k6@ti.com>
Link: https://patch.msgid.link/20260122-schneider-6-19-rc1-qspi-v4-8-f9c21419a3e6@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of spi: cadence-qspi: Fix probe error path and remove

### 1. COMMIT MESSAGE ANALYSIS

The commit message explicitly says "Fix probe error path and remove" —
this is a bug fix. The author clearly states:
- "its current state is partially broken"
- Resources were not being freed in the correct order
- DMA channel release was missing from error paths
- The remove path also had ordering issues

The commit has strong trust indicators:
- **Two "Tested-by:" tags** (Wolfram Sang and Santhosh Kumar K) — both
  are well-known kernel contributors
- Accepted by Mark Brown (SPI subsystem maintainer)
- Part of a versioned series (v4), indicating careful review iterations

### 2. CODE CHANGE ANALYSIS

Let me trace through the specific fixes:

#### A. Probe Error Path Fixes

**Missing DMA channel release:** The old code had `probe_setup_failed`
label that jumped directly to disabling the controller and runtime PM,
but **never released `cqspi->rx_chan`**. The new code adds a dedicated
`release_dma_chan` label:
```c
release_dma_chan:
    if (cqspi->rx_chan)
        dma_release_channel(cqspi->rx_chan);
```
This fixes a **resource leak** — if `spi_register_controller()` fails
after DMA channels are requested, they would never be freed.

**Incorrect error label targets:** Several error paths were jumping to
`probe_reset_failed` which would attempt to disable clocks/reset that
hadn't been enabled yet, or skip cleanup that was needed. The new labels
(`disable_rpm`, `disable_clk`, `disable_clks`, `disable_controller`,
`release_dma_chan`) provide proper granularity matching the actual
resources acquired at each point.

**Reordering of runtime PM disable:** The old code disabled runtime PM
in `probe_setup_failed` (early in cleanup), but the new code moves
`pm_runtime_disable()` to `disable_rpm` (the last cleanup step before
return). This is correct because PM was enabled relatively late in the
probe sequence and should be disabled early in the reverse-order
cleanup.

#### B. Remove Path Fixes

**DMA channel release added before controller disable:** The old remove
path had:
1. Disable controller
2. Release DMA channel

The new order:
1. Release DMA channel
2. Disable controller

This is the correct reverse order — DMA was requested after controller
init, so it should be released before controller disable.

**Clock disable ordering fixed:** The old code disabled clocks before
JH7110-specific clock cleanup. The new code reverses this to match probe
order.

### 3. BUG CLASSIFICATION

This fixes multiple real bugs:
1. **Resource leak**: Missing `dma_release_channel()` in probe error
   path — DMA channels leaked on probe failure
2. **Incorrect cleanup ordering**: Resources freed in wrong order could
   cause use-after-free or access to already-disabled hardware
3. **Wrong goto targets**: Error paths jumping to labels that free
   resources not yet acquired (wasteful but potentially harmful) or that
   skip freeing resources that were acquired (leak)

### 4. SCOPE AND RISK ASSESSMENT

- **Files changed**: 1 file (`drivers/spi/spi-cadence-quadspi.c`)
- **Nature of changes**: Primarily label renaming and reordering of
  cleanup steps — no logic changes to the normal (non-error) path
- **Risk**: LOW. The normal successful probe/remove paths are minimally
  affected. The changes only affect error handling and teardown
  ordering.
- **Subsystem**: SPI driver (Cadence QSPI) — widely used on ARM/embedded
  platforms (TI, Intel, StarFive, Renesas, etc.)

### 5. USER IMPACT

The Cadence QSPI controller is used on many SoCs. Users affected
include:
- Anyone whose probe fails for any reason (missing firmware, DT
  misconfiguration, resource conflicts) — they'd leak DMA channels
- Anyone unloading/reloading the module — remove path had ordering bugs
- Embedded systems that are sensitive to resource leaks

### 6. STABLE SUITABILITY

- **Obviously correct**: Yes — reverse-order cleanup is a well-
  established pattern, and the missing DMA release is clearly a bug
- **Fixes a real bug**: Yes — resource leaks and incorrect cleanup
  ordering
- **Small and contained**: Yes — single file, ~80 lines changed, mostly
  label renaming
- **No new features**: Correct — purely error handling fixes
- **Tested**: Yes — two Tested-by tags from reputable contributors
- **Clean application**: The patch modifies only one file with
  straightforward changes. May need minor adjustment depending on the
  stable version but should be relatively clean.

### 7. DEPENDENCY CHECK

This appears to be self-contained. The cleanup labels and DMA channel
handling are local to this file. The `cqspi_jh7110_disable_clk()`
function and `cqspi_request_mmap_dma()` need to exist in the stable
tree, which they should for any kernel version that has this driver with
JH7110 support and DMA support.

### Conclusion

This commit fixes genuine resource leaks (DMA channels) and incorrect
cleanup ordering in both the probe error path and remove function of a
widely-used SPI controller driver. It's small, well-tested, obviously
correct (follows reverse-order cleanup pattern), and has zero risk to
the normal operation path. It meets all stable kernel criteria.

**YES**

 drivers/spi/spi-cadence-quadspi.c | 44 ++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 597a04dbbe2e7..b1c95b1c343fc 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1891,7 +1891,7 @@ static int cqspi_probe(struct platform_device *pdev)
 	ret = clk_prepare_enable(cqspi->clk);
 	if (ret) {
 		dev_err(dev, "Cannot enable QSPI clock.\n");
-		goto probe_clk_failed;
+		goto disable_rpm;
 	}
 
 	/* Obtain QSPI reset control */
@@ -1899,14 +1899,14 @@ static int cqspi_probe(struct platform_device *pdev)
 	if (IS_ERR(rstc)) {
 		ret = PTR_ERR(rstc);
 		dev_err(dev, "Cannot get QSPI reset.\n");
-		goto probe_reset_failed;
+		goto disable_clk;
 	}
 
 	rstc_ocp = devm_reset_control_get_optional_exclusive(dev, "qspi-ocp");
 	if (IS_ERR(rstc_ocp)) {
 		ret = PTR_ERR(rstc_ocp);
 		dev_err(dev, "Cannot get QSPI OCP reset.\n");
-		goto probe_reset_failed;
+		goto disable_clk;
 	}
 
 	if (of_device_is_compatible(pdev->dev.of_node, "starfive,jh7110-qspi")) {
@@ -1914,7 +1914,7 @@ static int cqspi_probe(struct platform_device *pdev)
 		if (IS_ERR(rstc_ref)) {
 			ret = PTR_ERR(rstc_ref);
 			dev_err(dev, "Cannot get QSPI REF reset.\n");
-			goto probe_reset_failed;
+			goto disable_clk;
 		}
 		reset_control_assert(rstc_ref);
 		reset_control_deassert(rstc_ref);
@@ -1956,7 +1956,7 @@ static int cqspi_probe(struct platform_device *pdev)
 		if (ddata->jh7110_clk_init) {
 			ret = cqspi_jh7110_clk_init(pdev, cqspi);
 			if (ret)
-				goto probe_reset_failed;
+				goto disable_clk;
 		}
 		if (ddata->quirks & CQSPI_DISABLE_STIG_MODE)
 			cqspi->disable_stig_mode = true;
@@ -1964,7 +1964,7 @@ static int cqspi_probe(struct platform_device *pdev)
 		if (ddata->quirks & CQSPI_DMA_SET_MASK) {
 			ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
 			if (ret)
-				goto probe_reset_failed;
+				goto disable_clks;
 		}
 	}
 
@@ -1975,7 +1975,7 @@ static int cqspi_probe(struct platform_device *pdev)
 			       pdev->name, cqspi);
 	if (ret) {
 		dev_err(dev, "Cannot request IRQ.\n");
-		goto probe_reset_failed;
+		goto disable_clks;
 	}
 
 	cqspi_wait_idle(cqspi);
@@ -2002,14 +2002,14 @@ static int cqspi_probe(struct platform_device *pdev)
 		ret = cqspi_request_mmap_dma(cqspi);
 		if (ret == -EPROBE_DEFER) {
 			dev_err_probe(&pdev->dev, ret, "Failed to request mmap DMA\n");
-			goto probe_setup_failed;
+			goto disable_controller;
 		}
 	}
 
 	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register SPI ctlr %d\n", ret);
-		goto probe_setup_failed;
+		goto release_dma_chan;
 	}
 
 	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM))) {
@@ -2018,17 +2018,22 @@ static int cqspi_probe(struct platform_device *pdev)
 	}
 
 	return 0;
-probe_setup_failed:
-	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM)))
-		pm_runtime_disable(dev);
+
+release_dma_chan:
+	if (cqspi->rx_chan)
+		dma_release_channel(cqspi->rx_chan);
+disable_controller:
 	cqspi_controller_enable(cqspi, 0);
-probe_reset_failed:
+disable_clks:
 	if (cqspi->is_jh7110)
 		cqspi_jh7110_disable_clk(pdev, cqspi);
-
+disable_clk:
 	if (pm_runtime_get_sync(&pdev->dev) >= 0)
 		clk_disable_unprepare(cqspi->clk);
-probe_clk_failed:
+disable_rpm:
+	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM)))
+		pm_runtime_disable(dev);
+
 	return ret;
 }
 
@@ -2046,18 +2051,19 @@ static void cqspi_remove(struct platform_device *pdev)
 		cqspi_wait_idle(cqspi);
 
 	spi_unregister_controller(cqspi->host);
-	cqspi_controller_enable(cqspi, 0);
 
 	if (cqspi->rx_chan)
 		dma_release_channel(cqspi->rx_chan);
 
-	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM)))
-		if (pm_runtime_get_sync(&pdev->dev) >= 0)
-			clk_disable(cqspi->clk);
+	cqspi_controller_enable(cqspi, 0);
 
 	if (cqspi->is_jh7110)
 		cqspi_jh7110_disable_clk(pdev, cqspi);
 
+	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM)))
+		if (pm_runtime_get_sync(&pdev->dev) >= 0)
+			clk_disable(cqspi->clk);
+
 	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM))) {
 		pm_runtime_put_sync(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
-- 
2.51.0

