Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0963BBF2;
	Mon,  4 Aug 2025 00:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267516; cv=none; b=C1NImbHFVx0cnD7aeV8c0Hl03npaeOdjt7dU/YxXmHAz3WxCt/ikfkZ0n2saMvMvnHgP1ZMe+4oGdrcucHEmDel9BUoGbmZ9/daq/p7CzVAhAzmQoeM4pOA8WjXdeyRuA7sGGmZvB8Q9SFhuJ9hCytkiTpugw/PCyhTqefZYlGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267516; c=relaxed/simple;
	bh=vREE2ZkoWyaTaUVs2JMVo7lnPN/4F9kvPw8m1RUlj1s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fbd4jn63hm7Lto9seluVZoQoMlQ1LJexzuzvVZEeqnHQhwrgnseO7DIudK5eO4YqdZxrgmCqwLZ1BXIs4CNlWu4f28Ff708ZBOrkmSrwLFp039YsOfx7UJx0MG/LBPd8AGEU/2+EEhh/NfjGd0DoHE3JQHNXe8NRwHcgXqP8K3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pc7uC9Ev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pc7uC9Ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376A6C4CEF0;
	Mon,  4 Aug 2025 00:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267516;
	bh=vREE2ZkoWyaTaUVs2JMVo7lnPN/4F9kvPw8m1RUlj1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pc7uC9Ev6c/xW1J9d8JF4iFVa24Mt7xPDjUgnouDSDFIddlR+0yf5sJhN7QiKbAfo
	 3NPefosHqsxp2DzFxYk9Nzlcr9vaFSk/iekj+Kk+8mX6ZPYzOHsj4d9eIjCWjbHW8c
	 jtfL0qfWHl12Z8r5lu0eWuLRi/B+a58XR4YuxzClvMLybukJzllyxkJCPCU4qrX518
	 p8VLPXcgdq+rNfNmNFn2BFh7Ze7aG2WFKvB5tlyRjntjHqOU58vZzHcQg6L9Jw8ZqX
	 2ZzfHBDOuhp6CgURsbOx5DQx3UmBO8fkN7dk+vbo36Jm8Q3vSF2q59jcSfDKqIKE6L
	 qySgf21LWdOCA==
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
Subject: [PATCH AUTOSEL 6.12 13/69] remoteproc: imx_rproc: skip clock enable when M-core is managed by the SCU
Date: Sun,  3 Aug 2025 20:30:23 -0400
Message-Id: <20250804003119.3620476-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003119.3620476-1-sashal@kernel.org>
References: <20250804003119.3620476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
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
index 800015ff7ff9..cc3f5b7fe9dd 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -1029,8 +1029,8 @@ static int imx_rproc_clk_enable(struct imx_rproc *priv)
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

