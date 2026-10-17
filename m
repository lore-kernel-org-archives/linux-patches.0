Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6132A356A12;
	Sat, 17 Oct 2026 17:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257407; cv=none; b=LESoKHU7jtGrOoCzFo9C1FpdgK7TiOio95I1bZE+AeyIjtylns+xpHKBaSc4anUqMacwmVbsn6VvB/MZ6yHoLu8LsqjlddbsxbSkpLb4imn54UXk9dJ7A3oGTxVcc49rPZtW0sZCetxJ5wQXQi/Vor9KK4wsy/Ty+BFqZq2910U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257407; c=relaxed/simple;
	bh=v06eJIMVlmxmpn/QfjJNA5v2CF8rtwjZ8TqCYbp99ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByOXyKxQNW3s3Dx8aom33xmKmi0KuJCwerPdUAyNIX8Bbj/YZSy4YPkCAABMetc/IdoOBVwDtlfSm29EUrZVh/eGvxO8EjW+Pn26hmM3LTv4gJSY7NZ0oq8KNkCnseh7GUxWqtsUirWezEV95hQs0KSPLDAdtdHPCujdsPn/s0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvMDuD3n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvMDuD3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F021F000C4;
	Sat, 17 Oct 2026 17:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257406;
	bh=urqNQ0caW++vZZc8lNcFK58tzvMXLseIQN0RzcB9Eq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WvMDuD3nGiKzwjX8vfXVgbH+RAI7qcbIGXa4jy9HJxrtD8ELF4BeeDKPruM8G8OYD
	 lCJdkRqELa3MuJ4rvaeGkGojLg2OTmLjmhvE6ruZyidAvTSpIYyM90yJG2cbPdi/Q9
	 tzkSVTkmohchZDA906NqrrB5uB8gsgoHVdxaxBPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Claude Opus 5.5" <noreply@anthropic.com>
Subject: [PATCH 6.6 0549/1674] ASoC: samsung: i2s: enable op_clk in probe to balance runtime PM
Date: Sat, 17 Oct 2026 17:47:01 +0200
Message-ID: <20261017160445.188794252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 7529254014764ae0b8c33d5c61a58f36c65b1a1c ]

The probe function puts the device into the runtime PM active state with
only the "iis" bus clock enabled, but it also sets priv->op_clk to the
parent of the RCLK_SRC mux without enabling it. The runtime PM suspend
callback disables both clocks, so the first runtime suspend after probe
disables op_clk once more than it was enabled.

On Exynos5250 Arndale both clocks resolve to the same EXYNOS_I2S_BUS gate,
so this triggers the following warning during boot:

 WARNING: drivers/clk/clk.c:1270 at clk_core_disable+0xe4/0x23c, CPU#0: kworker/u8:3/45
 i2s_bus already disabled
 ...
 Workqueue: pm pm_runtime_work
 Call trace:
  ...
  clk_core_disable from clk_disable+0x28/0x34
  clk_disable from i2s_runtime_suspend+0x58/0x68 [snd_soc_i2s]
  i2s_runtime_suspend [snd_soc_i2s] from genpd_runtime_suspend+0xc4/0x298
  genpd_runtime_suspend from __rpm_callback+0x48/0x18c
  __rpm_callback from rpm_callback+0x4c/0x50
  rpm_callback from rpm_suspend+0xf4/0x718
  rpm_suspend from pm_runtime_work+0x9c/0xa0
  ...

Fix this by enabling op_clk in probe right after getting it, so the clock
state matches the runtime PM active state, and by disabling it in remove.

Fixes: 48279c53fd1d ("ASoC: samsung: i2s: Prevent external abort on exynos5433 I2S1 access")
Assisted-by: Claude Opus 5.5 <noreply@anthropic.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://patch.msgid.link/20261002092116.585466-1-m.szyprowski@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/i2s.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index 925782e676730..6dae7f06234ae 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -1547,9 +1547,16 @@ static int samsung_i2s_probe(struct platform_device *pdev)
 		goto err_disable_pm;
 
 	priv->op_clk = clk_get_parent(priv->clk_table[CLK_I2S_RCLK_SRC]);
+	ret = clk_prepare_enable(priv->op_clk);
+	if (ret < 0) {
+		priv->op_clk = NULL;
+		goto err_unregister_clk;
+	}
 
 	return 0;
 
+err_unregister_clk:
+	i2s_unregister_clock_provider(priv);
 err_disable_pm:
 	pm_runtime_disable(&pdev->dev);
 err_del_sec:
@@ -1572,6 +1579,7 @@ static void samsung_i2s_remove(struct platform_device *pdev)
 
 	i2s_unregister_clock_provider(priv);
 	i2s_delete_secondary_device(priv);
+	clk_disable_unprepare(priv->op_clk);
 	clk_disable_unprepare(priv->clk);
 
 	pm_runtime_put_noidle(&pdev->dev);
-- 
2.53.0



