Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7874C330B00;
	Fri, 17 Oct 2025 15:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716302; cv=none; b=o1taiMVjQNVjFtZyyx5JXp5S8ZyTMvQWhu6VXdZUQBr/cyGf/ig4mLeI90pEcOYJHuWq+GajQOBQVijivVoufpzVUvp6fwDxNJUCk7aOxh47kawk/KsLHibpEe8e5rXrPLLBXd6S+m8ivEZcFCcHpT/VIKDj4OnidtQy4dECgwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716302; c=relaxed/simple;
	bh=i9Ayl5CAVvpTPwUZLDwwDvNLOeTXYkrjOEW+OOQ5Wqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNkfdivMAMwZp8iED329EOUzctyysjKq+xD4jacKyECzBQCDDg5sPFSG+QIX3fBxr5FFTeh3oAXq8kT1dl8VNvxmN6KSn8ovnhzO33PZsSJERMS36Ibi6XEtOfUTMEMOQV8gEeqrM2bhKVP23WrTuyAeBKkDImvHWQ+IyQ8kHPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmU1E2xt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmU1E2xt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0A5C4CEE7;
	Fri, 17 Oct 2025 15:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716302;
	bh=i9Ayl5CAVvpTPwUZLDwwDvNLOeTXYkrjOEW+OOQ5Wqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmU1E2xt+KyqnwrUUpGY9R2dEFgrBuz7Dsl3FHQNoxngmI0znngNj4V/s6glliO02
	 Jfyu2TFVC7mLvAhMTaZIAHAGYjYJ9vO81MTSLqUGSaGgByfRpDEDgOuHjL+aQZUine
	 taC7WZKabZjlBE5666SQjsGO6hWfSw0gpLin5tio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 111/276] mfd: vexpress-sysreg: Check the return value of devm_gpiochip_add_data()
Date: Fri, 17 Oct 2025 16:53:24 +0200
Message-ID: <20251017145146.530857380@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


