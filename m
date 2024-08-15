Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CDA1DFFB;
	Thu, 15 Aug 2024 14:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732594; cv=none; b=RDFAkLcT/jFGmg3H4uW6QyuOVJeLkZc/zF3dnhlN4mf0pJTu3bVXXlmbU46CTVt3VTMdTGxOt3P4PV7iXl99toMuZ/3Z0mrn6Xkeb5wqzHKCWJRjV+OBcB+5OmNrMHAoKopNm1X7jmzgx/md2KdRL6DJDoxy7uRdGHJHHxO3UF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732594; c=relaxed/simple;
	bh=H2oRZsdBywvFyAZFbcERchbZ12IJq1Srg89hgvHbFwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cST4oXnlmanQg2iKeWzmd7ZdyaAKqccJHe9OwAkjpiD+S8mYFcgmfiCuyIG3JMu8jhJ33JdvFFc9cpWe08g+3++tm7xsJaMJ5N2Gsqv+lOhxlhMn5OXBK0I/YnRfkfzZOSlzPYVEldTYrPikt968R7htyEe0y7dsJz6IkIH4XZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZJj3TbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZJj3TbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A68C32786;
	Thu, 15 Aug 2024 14:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732594;
	bh=H2oRZsdBywvFyAZFbcERchbZ12IJq1Srg89hgvHbFwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZJj3TbK7NrVzyzCapBNzS4E4oDOioIF+WkQjOWAu0A8mFO+wk6NP5c18NqJIVPmT
	 uj1B6SHvH6cvokPikDQYRDY18WoLcKfuJxDLGO+h1WxClZNKbhTS1MuYaGBggywi4+
	 yX4tYzRoqRjjnCthSwKMhsNDZ9bfaYN/hqkWJFcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 228/352] irqchip/imx-irqsteer: Add runtime PM support
Date: Thu, 15 Aug 2024 15:24:54 +0200
Message-ID: <20240815131928.243539632@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c9998b46414cc..b1ecdb08c618c 100644
--- a/drivers/irqchip/irq-imx-irqsteer.c
+++ b/drivers/irqchip/irq-imx-irqsteer.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/pm_runtime.h>
 #include <linux/spinlock.h>
 
 #define CTRL_STRIDE_OFF(_t, _r)	(_t * 4 * _r)
@@ -178,7 +179,7 @@ static int imx_irqsteer_probe(struct platform_device *pdev)
 	data->irq_count = DIV_ROUND_UP(irqs_num, 64);
 	data->reg_num = irqs_num / 32;
 
-	if (IS_ENABLED(CONFIG_PM_SLEEP)) {
+	if (IS_ENABLED(CONFIG_PM)) {
 		data->saved_reg = devm_kzalloc(&pdev->dev,
 					sizeof(u32) * data->reg_num,
 					GFP_KERNEL);
@@ -202,6 +203,7 @@ static int imx_irqsteer_probe(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto out;
 	}
+	irq_domain_set_pm_device(data->domain, &pdev->dev);
 
 	if (!data->irq_count || data->irq_count > CHAN_MAX_OUTPUT_INT) {
 		ret = -EINVAL;
@@ -222,6 +224,9 @@ static int imx_irqsteer_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	return 0;
 out:
 	clk_disable_unprepare(data->ipg_clk);
@@ -244,7 +249,7 @@ static int imx_irqsteer_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_PM
 static void imx_irqsteer_save_regs(struct irqsteer_data *data)
 {
 	int i;
@@ -291,7 +296,10 @@ static int imx_irqsteer_resume(struct device *dev)
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



