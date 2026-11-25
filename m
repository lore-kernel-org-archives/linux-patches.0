Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624286;
	b=ufcDJqeuzG5/iLfRO1AgzJIthOwRfaJFEK43K9rc/bcGC0wdRKgdBC3Gu2Pkas+GU/Ai
	 H1HyfI2C4uF12dvGYHe7UJ73iQcUubVsxvAspw+kglkMRXpoTrN3qSVWYTwHRpTMhoISp
	 EZe+ltO7yVkrNm522hLRRpRH+5whf1lmy6uf9zxFZmw+SZlHPoSD4soE7GAlzDWWiNI6y
	 z0ZDzgN0b9gkQVe6Eczp9VHqIhuK2/VmRGqJ/fzO0Jg+e5K31CrF0B9diRUrS2FiyWUNq
	 pqWrRDJMKwMkwDAI4nCBSD7OxhlmDk6Otn+tUt9UaJ0oKI2cTwyP7Lm5zK05VxsPbbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H+xbWsFoXgfChor2U8s54KJXMh/8j3tCTNazQcN+89g=;
	b=ible9lyDJn/usl3308GUv1HG88j18/S+uwRtify8fIqhO2HbioIIzegMKKBeAYaao1dk
	 QOXTysRUeV92kMmAUqflCJUMB4XwOXe6eRNPieGSgoyTFNz0aAeVWEsmYdaRvewsHRAWg
	 WysKump4+sWenj+DmceE1LIU3T7R0SRmVObMcT6Qre216Mt9yngx9Gc0RUt6j8dr/+Mtl
	 d5CEme+edqUEgub2d0CmgTS+6vSr9ylpjaWp0JolDTxBrESHpYkMf1rwHX9DoMXGquQml
	 LikomQ/RGBamig8K49i8C0dCdhASOWYxMj3dpqO557kyiZIqoSbQPknlpIkA0BJXKsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LMdTYmF0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54580606A326;
	Wed, 25 Nov 2026 16:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LMdTYmF0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1F21F000C0;
	Wed, 25 Nov 2026 16:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624286;
	bh=H+xbWsFoXgfChor2U8s54KJXMh/8j3tCTNazQcN+89g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMdTYmF0QcLckk+hjtAwDDXAdaVGNJuqvSF/gcdC3sjtoWDdJE/5yestqmkVGnxii
	 wJW9vSKlDtKOgzKLxafC/yNuJZvZkVlSpsh9IcF/h/AEBJT4i4MkjtdNisTp1hDuxL
	 HtxDOVZyRu/ulZsU3K61Jmn/H2aitjrpc42j1P2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <liguangshuo@mail.sdu.edu.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 145/816] gpio: mpc8xxx: Fix potential use-after-free of IRQ domain
Date: Wed, 25 Nov 2026 15:28:13 +0100
Message-ID: <20261125143852.555163686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 30f36f94ba1b8..b99917d834d6a 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -298,6 +298,14 @@ static const struct of_device_id mpc8xxx_gpio_ids[] = {
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
@@ -378,6 +386,11 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 			gc->read_reg(mpc8xxx_gc->regs + GPIO_DIR);
 	}
 
+	/* GPIO chip cleanup still needs the IRQ domain. */
+	ret = devm_add_action_or_reset(dev, mpc8xxx_irq_domain_remove, mpc8xxx_gc);
+	if (ret)
+		return ret;
+
 	ret = devm_gpiochip_add_data(dev, gc, mpc8xxx_gc);
 	if (ret) {
 		dev_err(dev,
@@ -408,25 +421,20 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(dev, "failed to devm_request_irq(%d), ret = %d\n",
 			mpc8xxx_gc->irqn, ret);
-		goto err;
+		return ret;
 	}
 
 	device_init_wakeup(dev, true);
 
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



