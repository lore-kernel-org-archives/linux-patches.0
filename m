Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6C151CF6D;
	Wed, 30 Sep 2026 17:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789794; cv=none; b=V4ucd7fYQbiD0Hd3iDTbPtRMwczVZQK0H4OGy3oaoZv7e6umA8nQul+kzQNA9Ng6O1FJ/G7m3ZGPRSh2LQECLyoH3S99wOieeUU6NcN9vzkb1aYeZiZHbQhm+M7GDUsZSTClULl/D4AjHyKsX9s5ieIqYvQmwLqN4OZp9Jesgz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789794; c=relaxed/simple;
	bh=MnRQ3rFYuk3zG/H5QHFz5N2U12PS/6w9KFDZWYt8dnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3jhL5o9n45PVGzhDd45UhzxnJVmc/REV7cMP1xPTZP0zHe/rr5BF27AU8xiG5YO4y1s3oBNxfqcvVKtY2e5OsgUzQoN/mRFVohwZ+in7G58ZHSxX5YDldI9e7jG4YIqNq6n83rAYLvtKuFO1srXh6TykjvNtS+1K/J3ScVvw3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aeZLIH9D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeZLIH9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EC51F000FF;
	Wed, 30 Sep 2026 17:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789792;
	bh=dICqExFyzkroRQuqHpqVNe/iky+HCno7VwV7ZGPNMv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aeZLIH9DkiSOauC8emzunkRh/lZBs4qdFydrbVL/gnkUomPIzIKjSie/nPda1rpeR
	 1nTJs9Nrz8DcPO7X/g9+nMYyPdhpN/pbB4Yccn6NxpQqMqXD441VkoLsHkPNcVr00B
	 8PmMWCFJJ7T9ZSBstqX7qeJN6GVIDc+vUqkQuaPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 603/877] hwrng: stm32 - Fix runtime PM cleanup on registration failure
Date: Wed, 30 Sep 2026 17:25:14 +0200
Message-ID: <20260930152427.669362112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit 1163a476a568f6c0f852d469c8e4c5a5f805adac ]

stm32_rng_probe() enables autosuspend and runtime PM before registering the
hwrng. If devm_hwrng_register() fails, probe returns with runtime PM left
enabled and autosuspend still selected.

The remove callback also only disables runtime PM and does not undo
pm_runtime_use_autosuspend().

Use devm_pm_runtime_enable() so runtime PM is unwound automatically on
probe failure and driver detach. Since the managed cleanup also disables
runtime PM,drop the remove callback.

Fixes: c6a97c42e399 ("hwrng: stm32 - add support for STM32 HW RNG")
Cc: stable@vger.kernel.org
Signed-off-by: Can Peng <pengcan@kylinos.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ added the missing int ret declaration in stm32_rng_probe(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/stm32-rng.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -366,11 +366,6 @@ static int stm32_rng_init(struct hwrng *
 	return 0;
 }
 
-static void stm32_rng_remove(struct platform_device *ofdev)
-{
-	pm_runtime_disable(&ofdev->dev);
-}
-
 static int __maybe_unused stm32_rng_runtime_suspend(struct device *dev)
 {
 	struct stm32_rng_private *priv = dev_get_drvdata(dev);
@@ -516,6 +511,7 @@ static int stm32_rng_probe(struct platfo
 	struct device_node *np = ofdev->dev.of_node;
 	struct stm32_rng_private *priv;
 	struct resource *res;
+	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -553,7 +549,9 @@ static int stm32_rng_probe(struct platfo
 
 	pm_runtime_set_autosuspend_delay(dev, 100);
 	pm_runtime_use_autosuspend(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 
 	return devm_hwrng_register(dev, &priv->rng);
 }
@@ -565,7 +563,6 @@ static struct platform_driver stm32_rng_
 		.of_match_table = stm32_rng_match,
 	},
 	.probe = stm32_rng_probe,
-	.remove = stm32_rng_remove,
 };
 
 module_platform_driver(stm32_rng_driver);


