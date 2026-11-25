Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621390;
	b=IL4HC5X0r0LSG6g9ZF1YYfYPrle6W3eyA2yvO1lxkkiF9EJCTAqMALN7VFe0gKErMKl6
	 6B17y96lYHYsoJ4T469BUlHbeXply0Erj+TbRNTpHBON3Us/EQgtzdNfZchSd5nqfnJsH
	 c9cCy0VbvizxmMwoULyPpu5Z8q+VOjxZI8GkPlHTlI2hpp/M7CYt/HGT9yKtMmwmKNj7c
	 kvzx/ZMPKrd41F13rT4b1+gl7TWqtNMIzf3fmWUEhT80RjldgzOaLjp0Cy2fzas/WSSnD
	 uTAmeHPC/M9LeKq44WoKaBflhITcOlzvh5JJQkx6QptCNQwe1qm0JWkWBofjVoMWxxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lQJxnvWXLXSvclM+fvIv1Hkm3cYDQJO6wIXEiFvOzuU=;
	b=eb4qe5N4GHW2F8Cfuu8eCBfEOW4Rwj/d7dRR57qkXgYkRMFarwtqOOs6kUjjinNcv+1i
	 gcPQjOlRGH6STPOBzXZlsLRTi1WD/lIgs5eMbMHOcscq0v3BGkHzFgBCFvAPANwg4CS3J
	 8eWS74kMdSzhp4WfS8pgITgiULTo/J12FzSaKkkepEO8CrSGMRrSiMdw4y/VoO3VTz4X4
	 ZbRG8d3nYV0AGbPLCSbNWHBLKqcHonC+BrXPoEf0dAEk+2bylrgp2B/FdgAyov/1Pabv7
	 +7SLY7WE9CuPKwfBw7k9lR9KZtKRuxtIfI907cSbyaFY3Y2nRRUhe2Pg+LHJOvJxReg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nVCL6jeO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60914606B38B;
	Wed, 25 Nov 2026 15:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nVCL6jeO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20131F000CF;
	Wed, 25 Nov 2026 15:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621389;
	bh=lQJxnvWXLXSvclM+fvIv1Hkm3cYDQJO6wIXEiFvOzuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVCL6jeOT+VlYnNYeZlHsUPLL7HcVCXd2wt/oebleIME6YKYWYsbPAwusx3killDg
	 DtrncqB5z0JvbmVItNSp+ZloQJmQ/VE4CsuTj2v3W2nKb1QWJOulH6k/555aKxdMuw
	 9jVB/77b3EeY6N7fwSPogWMfhuVL3x7hALNXp8lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <liguangshuo@mail.sdu.edu.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 165/990] gpio: mpc8xxx: Fix potential use-after-free of IRQ domain
Date: Wed, 25 Nov 2026 15:25:32 +0100
Message-ID: <20261125143825.960116834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>

[ Upstream commit 9e4b35c95fede87bad36f68b7ff1eae94ea6b910 ]

GPIO chip cleanup can call the to_irq callback while releasing requested
GPIOs. Removing the IRQ domain first leaves that callback using a freed
domain, both on removal and after an IRQ request failure.

Register domain cleanup before GPIO chip registration so devres removes
the chip before freeing the domain.

This issue was found by our static analysis tool under development.

Fixes: 257e10752c13 ("gpio: mpc8xxx: Use of_mm_gpiochip_remove")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
Link: https://patch.msgid.link/a4fec7fe970d6fc9135b488f57ba7e145b809359.1793377433.git.liguangshuo@mail.sdu.edu.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mpc8xxx.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index bfe828734ee1b..4a5636de08dbd 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -320,6 +320,14 @@ static const struct of_device_id mpc8xxx_gpio_ids[] = {
 	{}
 };
 
+static void mpc8xxx_irq_domain_remove(void *data)
+{
+	struct mpc8xxx_gpio_chip *mpc8xxx_gc = data;
+
+	if (mpc8xxx_gc->irq)
+		irq_domain_remove(mpc8xxx_gc->irq);
+}
+
 static int mpc8xxx_probe(struct platform_device *pdev)
 {
 	const struct mpc8xxx_gpio_devtype *devtype = NULL;
@@ -406,6 +414,11 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 						       mpc8xxx_gc->regs + GPIO_DIR);
 	}
 
+	/* GPIO chip cleanup still needs the IRQ domain. */
+	ret = devm_add_action_or_reset(dev, mpc8xxx_irq_domain_remove, mpc8xxx_gc);
+	if (ret)
+		return ret;
+
 	ret = devm_gpiochip_add_data(dev, gc, mpc8xxx_gc);
 	if (ret) {
 		dev_err(dev,
@@ -438,7 +451,7 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(dev, "failed to devm_request_irq(%d), ret = %d\n",
 			mpc8xxx_gc->irqn, ret);
-		goto err;
+		return ret;
 	}
 
 	ret = devm_device_init_wakeup(dev);
@@ -446,19 +459,14 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, ret, "Failed to init wakeup\n");
 
 	return 0;
-err:
-	irq_domain_remove(mpc8xxx_gc->irq);
-	return ret;
 }
 
 static void mpc8xxx_remove(struct platform_device *pdev)
 {
 	struct mpc8xxx_gpio_chip *mpc8xxx_gc = platform_get_drvdata(pdev);
 
-	if (mpc8xxx_gc->irq) {
+	if (mpc8xxx_gc->irq)
 		irq_set_chained_handler_and_data(mpc8xxx_gc->irqn, NULL, NULL);
-		irq_domain_remove(mpc8xxx_gc->irq);
-	}
 }
 
 static int mpc8xxx_suspend(struct device *dev)
-- 
2.53.0



