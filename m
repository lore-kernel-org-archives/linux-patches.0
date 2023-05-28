Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BD4611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9019C433A4;
	Sun, 28 May 2023 19:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301517;
	bh=ylDQpXj6dFf/uJShMYHYyCsgNyo2+JOxX4rVDPXzNQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhKFSKHIxT4yzzfZHM16OPQ+/xPYlowo+jJrlY1DO6OCcxkgh/Q5/L3/WJBr1Tao2
	 LpCtnTHq8VIzSkqLfWEbx6BoEqLQ1ghrW3UUpuSlwej+CqN8JFup2Ai685gLt1sTHo
	 2l7cX+aZG0XXafhE2yeKM+aGcB8SI6fYoPU7MQeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bgolaszewski@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/132] drivers: provide devm_platform_ioremap_resource()
Date: Sun, 28 May 2023 20:09:52 +0100
Message-Id: <20230528190835.195227282@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
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
Stable-dep-of: 8ab5fc55d7f6 ("serial: arc_uart: fix of_iomap leak in `arc_serial_probe`")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform.c         | 18 ++++++++++++++++++
 include/linux/platform_device.h |  3 +++
 2 files changed, 21 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 349c2754eed78..ea83c279b8a36 100644
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
index 1a9f38f27f656..9e5c98fcea8c6 100644
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
2.39.2



