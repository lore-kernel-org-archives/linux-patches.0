Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034131714A1;
	Thu, 15 Aug 2024 13:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730156; cv=none; b=N4uZke/RUb1bESlSDD2i7rg6fqqtts6lzZWIhSwwrBPeJGmABJYXtgr5Praao8ftlsRmp47/8JPbvmWrhUSbHzvfY+xYY4OcljhlDK/uPvV7Shga8pN4T+bcNZjlSXq1VmNz8R27Rmk5gv7ApHTmMyKhqFfrRMtX5KVg+sIvLHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730156; c=relaxed/simple;
	bh=8S23FgFlFm62MI+SvbOiT6/3EEmjn+d+lGgm+LPtOiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HM+ZNdeXI2U6ukIvD+sr43tAkYCzYQPVMRINm71Vb5y3Bt6gSmnIPXkA6qZjaKWvoyFrsicL29M/jXuSV8VCKFGLWx03u69u297QpwFgoHHCb7er3Lpk6dZITlGrCuFwwLqWG14QaM20vZdm0f33LStRLA0DFhiURPf53l+uIUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKXk6uSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKXk6uSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D7AC32786;
	Thu, 15 Aug 2024 13:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730155;
	bh=8S23FgFlFm62MI+SvbOiT6/3EEmjn+d+lGgm+LPtOiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKXk6uSaBlPXiHrUGQtCfOB1WgyeLjeDrYk+TG5n5PP1argoans/F6AuIa35htcUS
	 4NgyJ6u7AJ7YBVx0bd5hL/5sWrWxcQU8+QpZiBEgZi1QEEqW3clTdkw752aMwPDOv0
	 bIC8q1esj6AM3N01+aNCUAxUHPrhmRVvl5jxYl4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 320/484] irqchip/imx-irqsteer: Add runtime PM support
Date: Thu, 15 Aug 2024 15:22:58 +0200
Message-ID: <20240815131953.765407300@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 4730d2233311d86cad9dc510318d1b40e4b53cf2 ]

There are now SoCs that integrate the irqsteer controller within
a separate power domain. In order to allow this domain to be
powered down when not needed, add runtime PM support to the driver.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220406163701.1277930-2-l.stach@pengutronix.de
Stable-dep-of: 33b1c47d1fc0 ("irqchip/imx-irqsteer: Handle runtime power management correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-imx-irqsteer.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-imx-irqsteer.c b/drivers/irqchip/irq-imx-irqsteer.c
index e286e7c5ccbfb..96230a04ec238 100644
--- a/drivers/irqchip/irq-imx-irqsteer.c
+++ b/drivers/irqchip/irq-imx-irqsteer.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/pm_runtime.h>
 #include <linux/spinlock.h>
 
 #define CTRL_STRIDE_OFF(_t, _r)	(_t * 4 * _r)
@@ -175,7 +176,7 @@ static int imx_irqsteer_probe(struct platform_device *pdev)
 	data->irq_count = DIV_ROUND_UP(irqs_num, 64);
 	data->reg_num = irqs_num / 32;
 
-	if (IS_ENABLED(CONFIG_PM_SLEEP)) {
+	if (IS_ENABLED(CONFIG_PM)) {
 		data->saved_reg = devm_kzalloc(&pdev->dev,
 					sizeof(u32) * data->reg_num,
 					GFP_KERNEL);
@@ -199,6 +200,7 @@ static int imx_irqsteer_probe(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto out;
 	}
+	irq_domain_set_pm_device(data->domain, &pdev->dev);
 
 	if (!data->irq_count || data->irq_count > CHAN_MAX_OUTPUT_INT) {
 		ret = -EINVAL;
@@ -219,6 +221,9 @@ static int imx_irqsteer_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	return 0;
 out:
 	clk_disable_unprepare(data->ipg_clk);
@@ -241,7 +246,7 @@ static int imx_irqsteer_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 static void imx_irqsteer_save_regs(struct irqsteer_data *data)
 {
 	int i;
@@ -288,7 +293,10 @@ static int imx_irqsteer_resume(struct device *dev)
 #endif
 
 static const struct dev_pm_ops imx_irqsteer_pm_ops = {
-	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(imx_irqsteer_suspend, imx_irqsteer_resume)
+	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				      pm_runtime_force_resume)
+	SET_RUNTIME_PM_OPS(imx_irqsteer_suspend,
+			   imx_irqsteer_resume, NULL)
 };
 
 static const struct of_device_id imx_irqsteer_dt_ids[] = {
-- 
2.43.0



