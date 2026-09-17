Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AA25187F4;
	Thu, 17 Sep 2026 17:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664655; cv=none; b=tZHPbNfzvlNDj1mLN5+uNliiN+wy6i4ECnrx5AKl+PbBrBJqQtGGWvMqQjZup5ng36/V7VSz3WiiMrvMUA6dOGm7d0tr4rzEr7IEPvlcxJl7ds2B1wfs+8SjSMPWsSvujTuhRM3OrhL7+m0z4UUPKqG5lzm7T09YDpf8X9gaO84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664655; c=relaxed/simple;
	bh=WaSEW6IvKPGHmoG07uvumllzovSRVQdsFn6W2ui3T8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVNxIKOw6aSn3tC+heHBtEDMSUpxv0uRNcolmF2Zalg9LcMqslS7zNinZ0dQ5eQ8U40c9ik4AsofgEdgFu4XmhRfup2Xn8QfrnGPdog5G7CJ55BYxkSY4vY5JW3slqpq41xnwn/MJQmp4NJkjy4NvJ9YRrY1OshohyQKDWJFLBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVIgTftO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVIgTftO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0671F000FF;
	Thu, 17 Sep 2026 17:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664654;
	bh=W8zEj13UqK4CZZ0WIAUcSfW0F04W+bRfDl8NMzF9sps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wVIgTftOlnqeLOxp5jgbf7J6kz3BAJvOU+kNsjJCBpnVcHps5OQ0jk4Um9KWrYDuZ
	 kCERQYgunLPr+4M6hG8TUPLD5/D5sZm1MwK+wBGXzIQO0cJnamiJAMJJkUyit50ZOB
	 gbblYTSH+X1Vk2rWgj2UMgAJ4IH01H7fuaQ2Voq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0445/1250] mailbox: imx: Use devm_pm_runtime_enable()
Date: Thu, 17 Sep 2026 16:04:00 +0100
Message-ID: <20260917151604.062369147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a80cb2c9df6ee..a45c3e6d76575 100644
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



