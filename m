Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE31B502D65;
	Thu, 17 Sep 2026 18:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668179; cv=none; b=IKJuUgOKgwMU3AJ6yh3+IX+fI3SFeuSq5O59uG31Ybsw14XoogxRVjGhkyA7Uq3nG045GCqUzzLyxzUca1K0MdVKkv2O8RNzkyuYEjWMutTdT535XO0qzoluFv+ZygisAALsT9O6VftHdkeqfS7sKb+oW5FhhVp98IgXO5DmuQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668179; c=relaxed/simple;
	bh=T+ufQ8inOkhvoBCrrJve/PNMKLNNnAmImdj61QsuHp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vv7rsVqqAvixTMCFfICRdYQDBvZbHSgb6YpGcdc9mMnFibCA++DBhk15RJlXbr/64f658SPB3piBiMsqfBmlwzfg1Rl0812exFni6JEf/Xu3odNmNpT6UJ2O/jM4wmr3b9+uyLsVZRnVKdpr+OkJZOdhzddEFWhdfhyG4YoaXS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fvu5Js8Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fvu5Js8Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E701F000FF;
	Thu, 17 Sep 2026 18:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668177;
	bh=JywcB+7zUyVkKfyIWh7zrvIRqCD1cfH/bXBUkvWG980=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fvu5Js8QT341WtyZwN4UfWVOVIIx2jEwvzISnhL3keuAC4Nj7oDXKzyEvx6xhTzED
	 e9kDSKs+u1JWZU4NE8PEQ89ba+bED32w3VEokr+wOGUqvVhtCF949QOZQ+wKkqT0Sj
	 21kw6vkv7R9rCjJCe+YfsG4QiLxE/3AT2N/z4kSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0340/1102] mailbox: imx: Use devm_pm_runtime_enable()
Date: Thu, 17 Sep 2026 16:04:43 +0100
Message-ID: <20260917151548.172418698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 1f602619e408b6e9655ee76656a2a5ab6e89c5e4 ]

sashiko complained about early usage of the device while probe isn't
completed. This can be mitigated by delaying the pm_runtime_enable()
into the removal path instead doing it early. This ensures that in an
error case the device is removed (and imx_mu_shutdown()) before
pm_runtime_disable() so we don't have to do this manually.

For the order to work, lets move devm_mbox_controller_register() until
after the pm-runtime part. So the reverse order will be mbox-controller
removal followed by disabling pm runtime.

Use devm_pm_runtime_enable(), remove manual pm_runtime_disable()
invocations and move the pm_runtime handling in probe before
devm_mbox_controller_register().

Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/imx-mailbox.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index 056c71ec97d1d..3319b40835f3c 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -936,38 +936,36 @@ static int imx_mu_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, priv);
 
-	ret = devm_mbox_controller_register(dev, &priv->mbox);
-	if (ret)
+	ret = devm_pm_runtime_enable(dev);
+	if (ret < 0)
 		goto disable_clk;
 
-	of_platform_populate(dev->of_node, NULL, NULL, dev);
-
-	pm_runtime_enable(dev);
-
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
-		goto disable_runtime_pm;
+		goto disable_clk;
 
 	ret = pm_runtime_put_sync(dev);
 	if (ret < 0)
-		goto disable_runtime_pm;
+		goto disable_clk;
 
 	clk_disable_unprepare(priv->clk);
 
+	ret = devm_mbox_controller_register(dev, &priv->mbox);
+	if (ret)
+		goto err_out;
+
+	of_platform_populate(dev->of_node, NULL, NULL, dev);
+
 	return 0;
 
-disable_runtime_pm:
-	pm_runtime_disable(dev);
 disable_clk:
 	clk_disable_unprepare(priv->clk);
+err_out:
 	return ret;
 }
 
 static void imx_mu_remove(struct platform_device *pdev)
 {
-	struct imx_mu_priv *priv = platform_get_drvdata(pdev);
-
-	pm_runtime_disable(priv->dev);
 }
 
 static const struct imx_mu_dcfg imx_mu_cfg_imx6sx = {
-- 
2.53.0



