Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EAB26A082;
	Wed, 23 Apr 2025 15:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421525; cv=none; b=o7wHXZUHqR53pZ2/oLgn3fRxYAkEg4s1XQC3z/aTZ6E13DSE3KywFXq9yUYBNlfq3Sr/CnuR1LMc/KUWSnmV8TqpTlV870vF1DkWrvMzFuD57fRKIx8mCUPCnoC2E5YN9219XBW3hGccQw11ljUir5BLWsyuIwjbydvzUhJi/4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421525; c=relaxed/simple;
	bh=bnE/i8oatafrDrno6rHS3yRWkO/dSW51j2YERNWn/pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wxu274Gau7vxp7PXY16id/Mia4SCskjjBHkoahSDmIFwDV20Gya66Np52EQG2PrNefQvHrjIHvhG/ENki6yDgKYGJTk8ffzA5TCMD/g0eYkgg5P1MWF99rCLICO5Y2rFuz9HD634lflEgZw/2r4QjYtFMzxQeG8jeuGgZ07jQ9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ud8ESquO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ud8ESquO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C508C4CEE2;
	Wed, 23 Apr 2025 15:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421523;
	bh=bnE/i8oatafrDrno6rHS3yRWkO/dSW51j2YERNWn/pE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ud8ESquO0S2iycUe9bHpYRXJs37hCg42BU+BL/rpsvwzLX2Zvm6WnQcaIt08RCgz7
	 7Fi15d1bkJqb5h44pNkhr1bjQnyxQsR8eX+PAA06E+qIsxTbNHRx9PKEnI4gaaOUJC
	 PFYc3UHgvbOb3l8IoHLkaK+GZllWJxYAhpohUPSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.1 146/291] gpio: tegra186: fix resource handling in ACPI probe path
Date: Wed, 23 Apr 2025 16:42:15 +0200
Message-ID: <20250423142630.370792907@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -753,6 +753,7 @@ static int tegra186_gpio_probe(struct pl
 	struct gpio_irq_chip *irq;
 	struct tegra_gpio *gpio;
 	struct device_node *np;
+	struct resource *res;
 	char **names;
 	int err;
 
@@ -772,19 +773,19 @@ static int tegra186_gpio_probe(struct pl
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


