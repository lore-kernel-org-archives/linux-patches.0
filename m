Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB20C463B7B;
	Mon, 31 Aug 2026 13:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183956; cv=none; b=ZQzgd9lG8SEUf739dgOw8YPun9bkU/5+G2ih/UzFhKOlbeUI/2wMXFsYGCHVTGvlvcJ0TgBc+/4P6PE7DQoVfP7HH81iEIE9vH2KWwvG1hfZLMsEtnZkvTk2Tr+Zi02RECAV9KhLyzhZlaDYJdUxIZsw2lMpKi4qRXJdz/qHFEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183956; c=relaxed/simple;
	bh=+sgNPuX+cVBpnmZJO8TTtdvLGhD7iEDVMdnJaXblJcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HNF4a5hAMp9cNZnyme2zS223yFUFF+k8MRepc1Hqw8YWB/ZGuaAFdnXso557UHxY1KcCN/2T2oE+C0YjBKvWErAu1WTAkPgKBzBo86+sleX8FvfVO3+lFIhxGbxP8hm8cw8GUYlEdgIGmBD3vGwrBWQIYk50Nk2Nzfv9g0wjk1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b8GTqxb+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b8GTqxb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767331F00ACF;
	Mon, 31 Aug 2026 13:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183954;
	bh=79SnfAKr0WCbVfxiI6EYmarFRhbBXTB4QyqCZJq5fa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8GTqxb+/FDvS2T1JvLmRW8aO57/fvT6/cWwQyc+p93ETjtElHGIHms6NKPCX2BC8
	 NcL7SVqjtP+xu36g0ihf3wMouvE5bonYXWaOqsw+yhqQfHpxWvTtYKhxt8N2V9b12P
	 oAopk0HamywzrO0gMo95NQf96jDR36IT1Zdt11n/AuUTpEBQHlk7tdxFydpxlJeLK+
	 78OFmbgOaJtRIxkupp68rW5ilcsFImwyOIG3Q+yrHeYP97d/cneWKqm9DaftCcTgAd
	 zWWSX0MTbTsiuz98khLrDOdzcoB4GbSOgyl43ctmCVwN3BPl+drXn9cnat9gCNG2FH
	 2q2G+BNTYW/Gw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Frank.Li@nxp.com,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.12] mailbox: imx: Use devm_pm_runtime_enable()
Date: Mon, 31 Aug 2026 09:27:10 -0400
Message-ID: <20260831133314.4125787-402-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The background history check finished successfully. It confirmed:

- The imx mailbox PM/mbox ordering issue dates to **676f23eab75adb**
  (Apr 2020, “Support runtime PM”).
- The same class of fix is already in **6.18.44** via **a8bd68e4329f9**
  (mtk-cmdq devm PM/mbox reorder), merged with mailbox-v6.11.

That supports the earlier **YES** verdict: the imx patch fixes the same
teardown ordering bug for i.MX MU devices in this tree.

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

