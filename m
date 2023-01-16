Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43026FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28888C433F1;
	Mon, 16 Jan 2023 16:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887694;
	bh=D7iA2627opMSbu8Xw4XUqK+8Ip68gn0a/lZ3XoAN9C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVA4Hl8Lq1bGmKWezXQpggh6tEckxOcW8Iu/5SSTMlnRYlNzohc1hWuqfNxu6+sI9
	 CmGmPl8x3jDALW8EpAlZYoU3DzeW9du75J6RzAqdDjsUpEa6X76NJhFEDqKf1vBtye
	 go+6iN1u33HIZLaIEb0y3jZgIuesC/MdE4gm9aWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bgolaszewski@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 247/521] drivers: provide devm_platform_ioremap_resource()
Date: Mon, 16 Jan 2023 16:48:29 +0100
Message-Id: <20230116154858.181417756@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit 7945f929f1a77a1c8887a97ca07f87626858ff42 ]

There are currently 1200+ instances of using platform_get_resource()
and devm_ioremap_resource() together in the kernel tree.

This patch wraps these two calls in a single helper. Thanks to that
we don't have to declare a local variable for struct resource * and can
omit the redundant argument for resource type. We also have one
function call less.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 2d47b79d2bd3 ("i2c: mux: reg: check return value after calling platform_get_resource()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform.c         | 18 ++++++++++++++++++
 include/linux/platform_device.h |  3 +++
 2 files changed, 21 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 349c2754eed7..ea83c279b8a3 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -80,6 +80,24 @@ struct resource *platform_get_resource(struct platform_device *dev,
 }
 EXPORT_SYMBOL_GPL(platform_get_resource);
 
+/**
+ * devm_platform_ioremap_resource - call devm_ioremap_resource() for a platform
+ *				    device
+ *
+ * @pdev: platform device to use both for memory resource lookup as well as
+ *        resource managemend
+ * @index: resource index
+ */
+void __iomem *devm_platform_ioremap_resource(struct platform_device *pdev,
+					     unsigned int index)
+{
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, index);
+	return devm_ioremap_resource(&pdev->dev, res);
+}
+EXPORT_SYMBOL_GPL(devm_platform_ioremap_resource);
+
 /**
  * platform_get_irq - get an IRQ for a device
  * @dev: platform device
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 1a9f38f27f65..9e5c98fcea8c 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -51,6 +51,9 @@ extern struct device platform_bus;
 extern void arch_setup_pdev_archdata(struct platform_device *);
 extern struct resource *platform_get_resource(struct platform_device *,
 					      unsigned int, unsigned int);
+extern void __iomem *
+devm_platform_ioremap_resource(struct platform_device *pdev,
+			       unsigned int index);
 extern int platform_get_irq(struct platform_device *, unsigned int);
 extern int platform_irq_count(struct platform_device *);
 extern struct resource *platform_get_resource_byname(struct platform_device *,
-- 
2.35.1



