Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3E53A0B2E;
	Sat, 17 Oct 2026 16:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255957; cv=none; b=AJY8ShxAkRMLsFDWnMnhaCAofb44TUlQsO4Nw/cokz19KEp7e7b8pJEL0dvTOhQUP3JcZe5sO/JHQ2oWwvJKXcKaS7ix7USSrht2n7V4GOh+MdcA2Ul9v4xSD0u8pV34T1V8JG6Phufa5R1voyyA9X+Y5yN/5iA8rCTkme8kAB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255957; c=relaxed/simple;
	bh=ZQ+1stlht654sIawTF2VYae812D961kMzfBNfb67mo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H6NQflL8BoxhrcNB3lDE27a0TB0i0vmI13my0sbxg+p1qGVN4T3OdwUcXz9LQipFJNcEydtZZC5VVh0PJF+jO4A8h0+tnrbhgNSc41b7tu8h7qsPOhlVGQUFtW/oNCL43xi+A7RpwCt13RiESbgXNNWZAMzhNbPdIOAyJa+sJsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWrjqjtz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWrjqjtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BDF1F000C4;
	Sat, 17 Oct 2026 16:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255956;
	bh=TLrNkhL55JQKJGsUTtTiAVUKRZl/yu7KdiRMmC1RWQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sWrjqjtzujIO7IHCo3MMNp4Hza2e7BFi2+rUxRCIeMGa0bddOm0EJncipiwAlmA01
	 3ta1AEGY9LyrmYbpJqQrjWDnm91XjMUwwOXVfLq88XUOCaz4h3uRJXZCP6QhV889qB
	 uU5TvM5Dq5PHKb8IOmFJUc+/G0iJYq46CSAnJw40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Linus Walleij <linusw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0078/1674] hwrng: stm32 - Fix runtime PM cleanup on registration failure
Date: Sat, 17 Oct 2026 17:39:10 +0200
Message-ID: <20261017160433.137074704@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ adapted to the older driver’s relocated int-returning remove callback and existing err variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/stm32-rng.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index efb6a9f9a11b5..fcfb0c4cea236 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -159,18 +159,13 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 
 	pm_runtime_set_autosuspend_delay(dev, 100);
 	pm_runtime_use_autosuspend(dev);
-	pm_runtime_enable(dev);
+	err = devm_pm_runtime_enable(dev);
+	if (err)
+		return err;
 
 	return devm_hwrng_register(dev, &priv->rng);
 }
 
-static int stm32_rng_remove(struct platform_device *ofdev)
-{
-	pm_runtime_disable(&ofdev->dev);
-
-	return 0;
-}
-
 #ifdef CONFIG_PM
 static int stm32_rng_runtime_suspend(struct device *dev)
 {
@@ -212,7 +207,6 @@ static struct platform_driver stm32_rng_driver = {
 		.of_match_table = stm32_rng_match,
 	},
 	.probe = stm32_rng_probe,
-	.remove = stm32_rng_remove,
 };
 
 module_platform_driver(stm32_rng_driver);
-- 
2.53.0



