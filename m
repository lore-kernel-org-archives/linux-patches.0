Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CEC346FC3;
	Fri,  4 Sep 2026 06:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501654; cv=none; b=M9NAlWRB0vbCpZRpchLFKinvZvow/ZGVeKXXB38+y24lKEaiMMW+oOVd5aUi0XW+ZMuXAIY2xMy6jgAGLEboJfUqdv2dP/DVjC1f3ug2jaDW88knyFxIpjERov4abqtKQOan7jQreY9kfH9mK768G7/BifEJrFxgo5ywY+wE4u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501654; c=relaxed/simple;
	bh=hzh0A4qBJpjFe9Dt5h1Z3rCcBZIbQLSMfxedcwPXXT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+b6ecKdqVqKbahNkik7N0/IgvRwScuNuxxlQ9lhqwkM9TJelgBbn1RtsfsIRQ6vmcuoNPzC/YutT3mNBTXb3LIvMwO/ANETZar5MSUmvIZ1pD8DWzdFnYcy0yDuRaQpmWl6vTu8eXY4/qxVk8Y0ILkcJMrOaXnepCPEoD3kU2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+RS8qO2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+RS8qO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507691F00A3D;
	Fri,  4 Sep 2026 06:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501652;
	bh=WZp6/N+CSipRSv8KkUotYGWta4nIxOWy1lbYB2laVBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+RS8qO2B9dOEiM2j7ONjzfJbN1TYFNtMhM5NaTERI+mQY+WKHYx0Wt46d3XHJ9wi
	 YiUMb71RiQZJqcIx22IFex4kPcDTi/QAYGIwjv+GsUZ9xK9EnBgIOIRWAtLZiS5hrM
	 nAGxv1lOKtF3EtOv8VNgxiA89Wj6NEA+4ibszma8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 483/552] hwrng: stm32 - Fix runtime PM cleanup on registration failure
Date: Fri,  4 Sep 2026 07:00:40 +0200
Message-ID: <20260904045801.622762930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Can Peng <pengcan@kylinos.cn>

commit 1163a476a568f6c0f852d469c8e4c5a5f805adac upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/stm32-rng.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -368,11 +368,6 @@ static int stm32_rng_init(struct hwrng *
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
@@ -590,7 +585,9 @@ static int stm32_rng_probe(struct platfo
 
 	pm_runtime_set_autosuspend_delay(dev, 100);
 	pm_runtime_use_autosuspend(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 
 	return devm_hwrng_register(dev, &priv->rng);
 }
@@ -602,7 +599,6 @@ static struct platform_driver stm32_rng_
 		.of_match_table = stm32_rng_match,
 	},
 	.probe = stm32_rng_probe,
-	.remove = stm32_rng_remove,
 };
 
 module_platform_driver(stm32_rng_driver);


