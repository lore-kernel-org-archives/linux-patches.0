Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8499322753;
	Mon, 27 Oct 2025 18:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591158; cv=none; b=VwQdPhv3L1B1fEj9mCk1dNANPrHc6YNW/4xXAFiEwu8+wS1vdOyqHBgXUPBMDncv92Oj89h0tcEs/BNaOYrYWd67nVzgtXrAxiv8Qn19MGZPRZQRaYwtjhXNBP8I2qWOBIGQSsehm1UGfGKL8eFNXvg1ku+3yr5JusX+s5PIp2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591158; c=relaxed/simple;
	bh=txJOu9zBCONZdVbrJh9BJsy0NvVieZVhrN9rx61j5+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4XtqiK1+arP8w4qRDpPYxT4o9mwYrGpuNit5IRmmH3YlEk/k+07lKNKGRejhMfgd0x1MJMusd3koxN8QpasZdq9iFa8PFpUvyY+20hUXmJecPR+dKnvU9H4zk+asw4uCIdfTj25bYjUfJM/6H+6fL/xeXyHeSnbTGiRd8KsAqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zM2Zs0Vw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zM2Zs0Vw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330CDC4CEFD;
	Mon, 27 Oct 2025 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591158;
	bh=txJOu9zBCONZdVbrJh9BJsy0NvVieZVhrN9rx61j5+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zM2Zs0VwJxUCy8+divL/EzGDjemHuxbNGIMFcO2EmNiLReP4sbVmONHAyN/CgnoOG
	 1cBL3ld2MY+YTgPnJvIJ6o40y+In1M+jzOQoU/uLQAH7I4V+A7GFqIN3zez96VOUVe
	 afOT09wYA/1R24hBiCAUHnZVQdItMbByRNUkb0os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 090/332] mfd: vexpress-sysreg: Check the return value of devm_gpiochip_add_data()
Date: Mon, 27 Oct 2025 19:32:23 +0100
Message-ID: <20251027183526.998825407@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 1efbee6852f1ff698a9981bd731308dd027189fb upstream.

Commit 974cc7b93441 ("mfd: vexpress: Define the device as MFD cells")
removed the return value check from the call to gpiochip_add_data() (or
rather gpiochip_add() back then and later converted to devres) with no
explanation. This function however can still fail, so check the return
value and bail-out if it does.

Cc: stable@vger.kernel.org
Fixes: 974cc7b93441 ("mfd: vexpress: Define the device as MFD cells")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20250811-gpio-mmio-mfd-conv-v1-1-68c5c958cf80@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/vexpress-sysreg.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -98,6 +98,7 @@ static int vexpress_sysreg_probe(struct
 	struct resource *mem;
 	void __iomem *base;
 	struct gpio_chip *mmc_gpio_chip;
+	int ret;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem)
@@ -118,7 +119,10 @@ static int vexpress_sysreg_probe(struct
 	bgpio_init(mmc_gpio_chip, &pdev->dev, 0x4, base + SYS_MCI,
 			NULL, NULL, NULL, NULL, 0);
 	mmc_gpio_chip->ngpio = 2;
-	devm_gpiochip_add_data(&pdev->dev, mmc_gpio_chip, NULL);
+
+	ret = devm_gpiochip_add_data(&pdev->dev, mmc_gpio_chip, NULL);
+	if (ret)
+		return ret;
 
 	return devm_mfd_add_devices(&pdev->dev, PLATFORM_DEVID_AUTO,
 			vexpress_sysreg_cells,


