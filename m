Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E36412C46D;
	Tue, 30 Apr 2024 10:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474025; cv=none; b=FyWIAeHdJpXJGi42imfBPy8YVu+fqiAG7+L1b1xSk06EQka3b9pf6dffwiTnrfOB5c7OtRvioy1q5lJT1HG34FW9/zwJ3i8PBrp2kv0tcBQjHrGDuHU1a5Wm9uHw9gWH/pXuQF25fS9SN75XMtNS/emJxwkKv/v2hEzmzZLhgUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474025; c=relaxed/simple;
	bh=x3/stRiWdxfNNuxoYQ4188LhRUWAEqzAfDaaB9z7Wvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGkDMykBJ9eo+j9evre1VHCKd+CGKhVlxscTmK7SygBIO1SAPgpk0+5tXIpkOn3TQc1DFllzFkRav0uUfLECejFehv0Vb40pjkLhW3nr4xmH1H+uMpYcXYYCdgVavHQwjoNr9yvaeLHR2nm/8zquPOQqu/hFidTbmfCxeUV77YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXNLAwAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXNLAwAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F9DC2BBFC;
	Tue, 30 Apr 2024 10:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474025;
	bh=x3/stRiWdxfNNuxoYQ4188LhRUWAEqzAfDaaB9z7Wvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXNLAwAFUeBhw5bNcCfBF1M99++m8cP7MnDyoHm/zv+Dagkf1G8tmIOLIBB6AmCKG
	 mR7m2wGfJQ1USJq5EAl35wK4tvR98g67nCVJWlTDyer9sUl1pHcErQlEqxxCQEDXa6
	 78KmwAqH7czsSDaBMLcQiBDAdSi06zX+KBXxDDnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 038/228] gpio: tangier: Use correct type for the IRQ chip data
Date: Tue, 30 Apr 2024 12:36:56 +0200
Message-ID: <20240430103104.914600439@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 7d045025a24b6336d444d359bd4312f351d017f9 ]

IRQ chip data contains a pointer to the GPIO chip. Luckily we have
the pointers the same, but strictly speaking it's not guaranteed.
Even though, still better to fix this.

Fixes: ccf6fd6dcc86 ("gpio: merrifield: Introduce GPIO driver to support Merrifield")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tangier.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-tangier.c b/drivers/gpio/gpio-tangier.c
index b75e0b12087ac..4b29abafecf6a 100644
--- a/drivers/gpio/gpio-tangier.c
+++ b/drivers/gpio/gpio-tangier.c
@@ -195,7 +195,8 @@ static int tng_gpio_set_config(struct gpio_chip *chip, unsigned int offset,
 
 static void tng_irq_ack(struct irq_data *d)
 {
-	struct tng_gpio *priv = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct tng_gpio *priv = gpiochip_get_data(gc);
 	irq_hw_number_t gpio = irqd_to_hwirq(d);
 	void __iomem *gisr;
 	u8 shift;
@@ -227,7 +228,8 @@ static void tng_irq_unmask_mask(struct tng_gpio *priv, u32 gpio, bool unmask)
 
 static void tng_irq_mask(struct irq_data *d)
 {
-	struct tng_gpio *priv = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct tng_gpio *priv = gpiochip_get_data(gc);
 	irq_hw_number_t gpio = irqd_to_hwirq(d);
 
 	tng_irq_unmask_mask(priv, gpio, false);
@@ -236,7 +238,8 @@ static void tng_irq_mask(struct irq_data *d)
 
 static void tng_irq_unmask(struct irq_data *d)
 {
-	struct tng_gpio *priv = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct tng_gpio *priv = gpiochip_get_data(gc);
 	irq_hw_number_t gpio = irqd_to_hwirq(d);
 
 	gpiochip_enable_irq(&priv->chip, gpio);
-- 
2.43.0



