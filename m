Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EFA2EA720;
	Tue, 17 Jun 2025 16:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178432; cv=none; b=EKOp4UwvobiwRgHfUloEQbiGbsCcGcqCGckppf1s5SIbFXtu3xSfGgOmLGXAWpZs7P6H4se6o8NyO6yQafreVb1P6osmV67sClGrQYiHSXzqfqYuMPzeZp7IrRqGwYvT5/bLKWuTN78IyqavT9oPzyqAfCK395xZnzon5rUOyoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178432; c=relaxed/simple;
	bh=Kq2gVdlf0I7vVKlVpWh8Q9SdvAHSfLKleSG37KAXlVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCV3lEflxf0bw5Tmmv8lonAG/sXF/tSM7JnERRb6PWH40DXx3ZhvbrBAsxkOK2+B/OPzyTUWx0NiwU2IiNFNWgyCrdEuinW2MdM/0qlCvI66OXc6metTp/+34/SRu5HTkUnK6ol9bLIobwAM5W6/ti5txWTXRMImd3QIvUgnBxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFM5vONE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFM5vONE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14965C4CEE3;
	Tue, 17 Jun 2025 16:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178432;
	bh=Kq2gVdlf0I7vVKlVpWh8Q9SdvAHSfLKleSG37KAXlVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFM5vONEuO5ymhf22B4goMH1Rrn9fuZ3+yShqWhOCK97+4wCKdKga/7nlfGn0UYK0
	 APiEZKgz/KljouGmzesbGRK1sb2k6K6wUO0Q2lNzpZ+e/0TI3XprrLk3dWVaaUgN6g
	 EMD5r5+V6mmbnuyVjdr4HZ8Q6ApvWw4/RVIByFhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 459/780] mfd: exynos-lpass: Fix another error handling path in exynos_lpass_probe()
Date: Tue, 17 Jun 2025 17:22:47 +0200
Message-ID: <20250617152510.171495411@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f41cc37f4bc0e8cd424697bf6e26586cadcf4b9b ]

If devm_of_platform_populate() fails, some clean-up needs to be done, as
already done in the remove function.

Add a new devm_add_action_or_reset() to fix the leak in the probe and
remove the need of a remove function.

Fixes: c695abab2429 ("mfd: Add Samsung Exynos Low Power Audio Subsystem driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/69471e839efc0249a504492a8de3497fcdb6a009.1745247209.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/exynos-lpass.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/exynos-lpass.c b/drivers/mfd/exynos-lpass.c
index a2785ceea8bfc..44797001a4322 100644
--- a/drivers/mfd/exynos-lpass.c
+++ b/drivers/mfd/exynos-lpass.c
@@ -104,11 +104,22 @@ static const struct regmap_config exynos_lpass_reg_conf = {
 	.fast_io	= true,
 };
 
+static void exynos_lpass_disable_lpass(void *data)
+{
+	struct platform_device *pdev = data;
+	struct exynos_lpass *lpass = platform_get_drvdata(pdev);
+
+	pm_runtime_disable(&pdev->dev);
+	if (!pm_runtime_status_suspended(&pdev->dev))
+		exynos_lpass_disable(lpass);
+}
+
 static int exynos_lpass_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct exynos_lpass *lpass;
 	void __iomem *base_top;
+	int ret;
 
 	lpass = devm_kzalloc(dev, sizeof(*lpass), GFP_KERNEL);
 	if (!lpass)
@@ -134,16 +145,11 @@ static int exynos_lpass_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	exynos_lpass_enable(lpass);
 
-	return devm_of_platform_populate(dev);
-}
-
-static void exynos_lpass_remove(struct platform_device *pdev)
-{
-	struct exynos_lpass *lpass = platform_get_drvdata(pdev);
+	ret = devm_add_action_or_reset(dev, exynos_lpass_disable_lpass, pdev);
+	if (ret)
+		return ret;
 
-	pm_runtime_disable(&pdev->dev);
-	if (!pm_runtime_status_suspended(&pdev->dev))
-		exynos_lpass_disable(lpass);
+	return devm_of_platform_populate(dev);
 }
 
 static int __maybe_unused exynos_lpass_suspend(struct device *dev)
@@ -183,7 +189,6 @@ static struct platform_driver exynos_lpass_driver = {
 		.of_match_table	= exynos_lpass_of_match,
 	},
 	.probe	= exynos_lpass_probe,
-	.remove	= exynos_lpass_remove,
 };
 module_platform_driver(exynos_lpass_driver);
 
-- 
2.39.5



