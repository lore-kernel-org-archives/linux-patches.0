Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705041;
	b=Dutxmn2JqmTxptT7y2bUX8wp2LFa1WNSlYk6GyG9mQYhFEm9B2r/uIkflNltR8ru1JoK
	 GDYPT16ctkQyeLkHxQHRfY4V49zomuaHxv4miaZ/nMRXNT3jT9STANS2c9964icagQNf5
	 owWn9i3/Vp1cM2SKvIthVoNQCqBFTMXhADOh6jEQAdqFh5aSbHgJFClEGtwbj8dVpj/y7
	 g8ElwfJ+wuGwGqZg3EdUvy1Rv7D3MpHsif/cn8WMvbCYnK3IJK0kSZtz3SleTsTk98BVM
	 NCOLJTYj4OuJztJ5clwpVZq5stmnYuyloQR03T211jdArd8/vo+VWPk6uJv/GrnYzuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tKvO6rvEIAw7UiBXw6LaXgV4YVsh+uES5PUEg3n6QPY=;
	b=HoxpYOQXHTZoK3aLX9L8v92HYZxJ2KNDBRE52E68hrPyB5LzdkTLGSRKuLtLDKmRhxy0
	 dOIfsEz4D6GpI10B81FW3Y5HYKJfr2nmnmZtybMCHespvHnW8kQla0cLPOJFe0D9BsqBs
	 XFF1AasX80BMCeieuZuABwkVjm2jSLEYY3bff8nwTkak3F3Ste4bTTzni4xREe9FUahvH
	 hv0yF6o8Yo+bMrex3/2Aww4Drgz19deGALt4pCRuTnEYnoYP2r3n6rF0dlXW7NirWii8L
	 cXhBDg474Suzv5YypXc1c9Tjoi3Cq6QYz3QKq11a2bz6pRqhaotKQqUCYhqClS0sKgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VzHUJWAi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CFF606A321;
	Thu, 26 Nov 2026 14:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VzHUJWAi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86091F000C4;
	Thu, 26 Nov 2026 14:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705041;
	bh=tKvO6rvEIAw7UiBXw6LaXgV4YVsh+uES5PUEg3n6QPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VzHUJWAiuwDTartA8NYhSCzUeiavXEXuBASgIuoaHy0qHA0q3nNiF9nYs//cUA/hU
	 U0xsz3aihkMOG0pE51ueC90iX0NavKio41dAcjvUd3q5c4/CLOTaswNnqm8pM0QUNC
	 vEF00d3vnyL8rTVniFNWXzSEZ8Z6mbJNzkzdjQhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <liguangshuo@mail.sdu.edu.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/319] gpio: mpc8xxx: Fix potential use-after-free of IRQ domain
Date: Thu, 26 Nov 2026 15:37:10 +0100
Message-ID: <20261126144008.137825260@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b4701fd0ea63b..674bbbd6850de 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -302,6 +302,14 @@ static const struct of_device_id mpc8xxx_gpio_ids[] = {
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
 	    is_acpi_node(fwnode))
 		gc->write_reg(mpc8xxx_gc->regs + GPIO_IBE, 0xffffffff);
 
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
 
 #ifdef CONFIG_PM
-- 
2.53.0



