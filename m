Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE1B1D555;
	Mon,  4 Aug 2025 00:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267686; cv=none; b=ixB6R2vbF7wuyIbRWskOPaBsOyqcGoLha5AjDNwiEv04l677yIXFLDhrhcrSHk0qiI3DkndP8l4MYYC+0NfJttsNqRfINFkrW5Gh6s9lAL9sLYIb6RJNF/hbDrbDM2Sray4jqivKbfJw4AdprvBhSMdyLgZc7B5rYvAuoFXeQJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267686; c=relaxed/simple;
	bh=sfQRs3wFqdLVTyXWO3C4UsFaWAO3+7WKV2MbISYsL+8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h0XeNjd7DnXTHCBbdIS3tv0pv2QII/doS661edu2FV9Ay3SBaY0NbIjXnM8sd6+9X4rra4qtukE2wttXNBYWpky0BzRF8xButeXDjuZXvCO8MA3Wj7Y7sQZrMZGddPz+B1BBZBJJMVpqSF6LlEwK0W0ty4Hf4XgIrUGQc6Fbt98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQRNfqMU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQRNfqMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BE1C4CEEB;
	Mon,  4 Aug 2025 00:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267686;
	bh=sfQRs3wFqdLVTyXWO3C4UsFaWAO3+7WKV2MbISYsL+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQRNfqMUbSXSLwslzoTCTqTBC+DRLfJAhhQDDMqxlMRp6EXi1i9Ijihort+HDZZxO
	 tJ0/mg8q66AIhF0MhVV2MZ8oVZU0tfS9FNxBNjDWhLVbT+8UmraNlRWxAnjbKLeOHc
	 JyZHYKwrWgIoOatldeiCgkiRM3biBOrcU2aP/jITNv6A+eDjUQkyn4TKR6NuYE7lie
	 AXj6eRpNT4nQJRhu5DPUyZF2LNtniaBxh0dC/hO5Awh0OzKzhmRr0gB/K4CWcYbefd
	 a7l+5GMAuyXVATUMwAMW1SNoPXa92JMvoQO8DI6T7Bq4W+biPwIT6L7VB1CWbY7coC
	 P5wUGfgdQXXQQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hiago De Franco <hiago.franco@toradex.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	andersson@kernel.org,
	shawnguo@kernel.org,
	linux-remoteproc@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.6 12/59] remoteproc: imx_rproc: skip clock enable when M-core is managed by the SCU
Date: Sun,  3 Aug 2025 20:33:26 -0400
Message-Id: <20250804003413.3622950-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003413.3622950-1-sashal@kernel.org>
References: <20250804003413.3622950-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
Content-Transfer-Encoding: 8bit

From: Hiago De Franco <hiago.franco@toradex.com>

[ Upstream commit 496deecb020d14ba89ba7084fbc3024f91687023 ]

For the i.MX8X and i.MX8 family SoCs, when the Cortex-M core is powered
up and started by the Cortex-A core using the bootloader (e.g., via the
U-Boot bootaux command), both M-core and Linux run within the same SCFW
(System Controller Firmware) partition. With that, Linux has permission
to control the M-core.

But once the M-core is started by the bootloader, the SCFW automatically
enables its clock and sets the clock rate. If Linux later attempts to
enable the same clock via clk_prepare_enable(), the SCFW returns a
'LOCKED' error, as the clock is already configured by the SCFW. This
causes the probe function in imx_rproc.c to fail, leading to the M-core
power domain being shut down while the core is still running. This
results in a fault from the SCU (System Controller Unit) and triggers a
system reset.

To address this issue, ignore handling the clk for i.MX8X and i.MX8
M-core, as SCFW already takes care of enabling and configuring the
clock.

Suggested-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Hiago De Franco <hiago.franco@toradex.com>
Acked-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20250629172512.14857-3-hiagofranco@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, I can now provide a definitive answer:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Critical bug fix preventing system reset**: The commit fixes a
   serious issue where the probe function failure causes the M-core
   power domain to be shut down while the core is still running,
   resulting in a fault from the SCU and triggering a system reset. This
   is a severe user-impacting bug that can cause unexpected system
   reboots.

2. **Minimal and contained change**: The fix is very simple - it just
   adds `|| dcfg->method == IMX_RPROC_SCU_API` to an existing condition
   in the `imx_rproc_clk_enable()` function. This is a one-line change
   that only affects the clock handling logic for i.MX8X and i.MX8
   family SoCs when using SCU API method.

3. **Clear root cause**: The commit message clearly explains the issue -
   when the M-core is started by the bootloader, the SCFW automatically
   enables its clock. If Linux later attempts to enable the same clock,
   SCFW returns a 'LOCKED' error, causing probe failure and subsequent
   power domain shutdown while the core is running.

4. **No architectural changes**: This is purely a bug fix that doesn't
   introduce new features or change the driver architecture. It simply
   skips clock operations for a specific configuration where the clock
   is already managed by the SCFW.

5. **Platform-specific fix with no regression risk**: The change only
   affects i.MX8X and i.MX8 platforms using the SCU API method
   (`IMX_RPROC_SCU_API`). Other platforms and methods are unaffected,
   minimizing the risk of regression.

6. **Prevents data corruption/loss**: System resets caused by this bug
   could potentially lead to data loss or corruption, making this fix
   important for system stability.

The specific code change in `imx_rproc_clk_enable()` at line 1033 simply
extends the existing check from:
```c
if (dcfg->method == IMX_RPROC_NONE)
```
to:
```c
if (dcfg->method == IMX_RPROC_NONE || dcfg->method == IMX_RPROC_SCU_API)
```

This ensures that for SCU-managed cores, Linux doesn't attempt to enable
clocks that are already controlled by the SCFW, preventing the probe
failure and subsequent system reset.

 drivers/remoteproc/imx_rproc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index 610a69928dff..251f9840d85b 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -1088,8 +1088,8 @@ static int imx_rproc_clk_enable(struct imx_rproc *priv)
 	struct device *dev = priv->dev;
 	int ret;
 
-	/* Remote core is not under control of Linux */
-	if (dcfg->method == IMX_RPROC_NONE)
+	/* Remote core is not under control of Linux or it is managed by SCU API */
+	if (dcfg->method == IMX_RPROC_NONE || dcfg->method == IMX_RPROC_SCU_API)
 		return 0;
 
 	priv->clk = devm_clk_get(dev, NULL);
-- 
2.39.5

