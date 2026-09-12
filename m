Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2693F076C;
	Sat, 12 Sep 2026 07:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197529; cv=none; b=uyXhF5cT8A+jRthLtcWqrpnnCLm+tPxsLEWPp3e2GH8wpuKNnG1EBFNj6WyFQVUOjVNrXole0ntZ5R4n2VvPo567VvDscKGn2w2hQDIpmSgLN4ORZtaYX8bAW5S+Z65KZ1yT6WKc7VUNXku47VKJRcTNIBcO20eIiYU6biKSFHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197529; c=relaxed/simple;
	bh=/8jkkPN/Jm0cP+dX0krdD7k3WDm9jjso6Bo9j0+4YYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvLfAHfffqX8MJu6rLP7E1d+0FtD1C79WUogzwnHtjMkyVFgWKtaShfcaCF8mTa9vCwPD2dUcnCl/yoILU6WrqXhmMUEgw3otclH4eiEzMT/fGFOOdTBlRPxFV2yVrC6VavknRkFc0MNKjk+OVnBfewOX+5Ul+P9TABl6lza8Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPiabSmm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPiabSmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA7F1F00893;
	Sat, 12 Sep 2026 07:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197528;
	bh=Oi+w2ndvhPHzD7AKfrmOw8lDWkhzprX446Ado0LPBmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPiabSmmlnjqqyxmfc1AccL1pbszBYHYn4JB8ElbgyWoIPWyDeU4Yy2NfBuEXAKTy
	 QafJY1dfPJHGo9ZPc63To+Wy7O15KrBCUr8DH3PHHIrN6Vh5IIegNNK21K1lEvESuM
	 AqL28J7xYx+MCtMtuR4VGtAlshlo01NZGSN7DEHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0194/1815] hwrng: omap - Fix probe error path cleanup
Date: Sat, 12 Sep 2026 08:32:24 +0200
Message-ID: <20260912065653.554328706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit f8c24e6899e263073fbbeb07fadc1af85ec492f5 ]

omap_rng_probe() enables runtime PM before acquiring and enabling the
functional clocks.  Several later error paths returned or unwound without
undoing all state acquired so far.

If pm_runtime_resume_and_get() failed, the driver returned through the
generic ioremap error label and left runtime PM enabled.  If either clock
lookup returned -EPROBE_DEFER, the function returned directly and skipped
the runtime PM cleanup; the register clock defer path could also leave the
already enabled functional clock prepared.

Route these failures through the existing unwind labels so each path only
undoes resources that were acquired successfully.  Keep the resume failure
path limited to pm_runtime_disable(), and use the later labels only after
the runtime PM usage count or clocks have been acquired.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 61dc0a446e5d ("hwrng: omap - Fix assumption that runtime_get_sync will always succeed")
Fixes: 43ec540e6f9b ("hwrng: omap - move clock related code to omap_rng_probe()")
Fixes: b166be004491 ("hwrng: omap - Fix clock resource by adding a register clock")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/omap-rng.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 5e8b50f15db75..a8c0b3dfb133c 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -455,32 +455,40 @@ static int omap_rng_probe(struct platform_device *pdev)
 	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to runtime_get device: %d\n", ret);
-		goto err_ioremap;
+		goto err_pm_disable;
 	}
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
-	if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (PTR_ERR(priv->clk) == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto err_pm_put;
+	}
 	if (!IS_ERR(priv->clk)) {
 		ret = clk_prepare_enable(priv->clk);
 		if (ret) {
 			dev_err(&pdev->dev,
 				"Unable to enable the clk: %d\n", ret);
-			goto err_register;
+			goto err_pm_put;
 		}
+	} else {
+		priv->clk = NULL;
 	}
 
 	priv->clk_reg = devm_clk_get(&pdev->dev, "reg");
-	if (PTR_ERR(priv->clk_reg) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (PTR_ERR(priv->clk_reg) == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto err_clk;
+	}
 	if (!IS_ERR(priv->clk_reg)) {
 		ret = clk_prepare_enable(priv->clk_reg);
 		if (ret) {
 			dev_err(&pdev->dev,
 				"Unable to enable the register clk: %d\n",
 				ret);
-			goto err_register;
+			goto err_clk;
 		}
+	} else {
+		priv->clk_reg = NULL;
 	}
 
 	ret = (dev->of_node) ? of_get_omap_rng_device_details(priv, pdev) :
@@ -498,12 +506,14 @@ static int omap_rng_probe(struct platform_device *pdev)
 	return 0;
 
 err_register:
+	clk_disable_unprepare(priv->clk_reg);
+err_clk:
+	clk_disable_unprepare(priv->clk);
+err_pm_put:
 	priv->base = NULL;
 	pm_runtime_put_sync(&pdev->dev);
+err_pm_disable:
 	pm_runtime_disable(&pdev->dev);
-
-	clk_disable_unprepare(priv->clk_reg);
-	clk_disable_unprepare(priv->clk);
 err_ioremap:
 	dev_err(dev, "initialization failed.\n");
 	return ret;
-- 
2.53.0



