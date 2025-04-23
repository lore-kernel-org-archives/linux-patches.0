Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B220528C5C5;
	Wed, 23 Apr 2025 15:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421863; cv=none; b=CyTo9z62begOH0XTKCBR/pqXg3/Nvs4y6PFVO3b23ejaxAhgDV126DtM5+OkFx1O9Md4qVEDbNEvGntyFew125oKUO4kSiWsxY6Eo0VnrE3mlX+znuHXmT8HConEVb2RJOPiFN+Tvok/x6UCSc+GRfB2XEYmqebaMGLQh1G3rUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421863; c=relaxed/simple;
	bh=MY5nxagZc47Phmra7j5+LaU9slFZZAay/VaXIOQfViY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1G3hkYjXQTWzjpfuQIdz6V50L2JF8C3t//xCYM9PelNaZ0JzObW6puKfJ7+qU25dIeQ4NhBlpZnjKJawi1uveEjns/rX7/SZS1gCd/oHOH7gv8rpeXxZsxFh40deYfmxvhh2Z3GWqRcEqAU6i5Up6SWqEyNJJfbjCRE3E7czFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxBn7BGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxBn7BGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA916C4AF09;
	Wed, 23 Apr 2025 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421863;
	bh=MY5nxagZc47Phmra7j5+LaU9slFZZAay/VaXIOQfViY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxBn7BGBCeUsHEuOi+6v2Fb6SwmyfDwpcqkAuybxA7nG8p7BSDyiMuGUQj0LAqGC3
	 52+k0y8I97X/vKv5d4C49On9swqznI08z602HQkIcMf46FRdI8eIKpAoovmUTwteW6
	 bgTFxRF4EUSxijWBEffjNc2CYGVLidhsCnb+aeqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 215/393] gpio: tegra186: fix resource handling in ACPI probe path
Date: Wed, 23 Apr 2025 16:41:51 +0200
Message-ID: <20250423142652.262509588@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

commit 8323f3a69de6f6e96bf22f32dd8e2920766050c2 upstream.

When the Tegra186 GPIO controller is probed through ACPI matching,
the driver emits two error messages during probing:
  "tegra186-gpio NVDA0508:00: invalid resource (null)"
  "tegra186-gpio NVDA0508:00: invalid resource (null)"

Fix this by getting resource first and then do the ioremap.

Fixes: 2606e7c9f5fc ("gpio: tegra186: Add ACPI support")
Cc: stable@vger.kernel.org
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250327032349.78809-1-kanie@linux.alibaba.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-tegra186.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/drivers/gpio/gpio-tegra186.c
+++ b/drivers/gpio/gpio-tegra186.c
@@ -822,6 +822,7 @@ static int tegra186_gpio_probe(struct pl
 	struct gpio_irq_chip *irq;
 	struct tegra_gpio *gpio;
 	struct device_node *np;
+	struct resource *res;
 	char **names;
 	int err;
 
@@ -841,19 +842,19 @@ static int tegra186_gpio_probe(struct pl
 	gpio->num_banks++;
 
 	/* get register apertures */
-	gpio->secure = devm_platform_ioremap_resource_byname(pdev, "security");
-	if (IS_ERR(gpio->secure)) {
-		gpio->secure = devm_platform_ioremap_resource(pdev, 0);
-		if (IS_ERR(gpio->secure))
-			return PTR_ERR(gpio->secure);
-	}
-
-	gpio->base = devm_platform_ioremap_resource_byname(pdev, "gpio");
-	if (IS_ERR(gpio->base)) {
-		gpio->base = devm_platform_ioremap_resource(pdev, 1);
-		if (IS_ERR(gpio->base))
-			return PTR_ERR(gpio->base);
-	}
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "security");
+	if (!res)
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	gpio->secure = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(gpio->secure))
+		return PTR_ERR(gpio->secure);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gpio");
+	if (!res)
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	gpio->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(gpio->base))
+		return PTR_ERR(gpio->base);
 
 	err = platform_irq_count(pdev);
 	if (err < 0)


