Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D2B30FF34;
	Mon, 13 Oct 2025 15:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367978; cv=none; b=taEVHSPxM9lUEsLQMyDz9DiE1vFz9O8bTaTsNtgpAY3B5wWwVWS/Yw8oKaX2zwsoCiIZIUCf/465ENBYGG3BM7g2e30BklyqQB0TeqWYkBmDAPpVvwEkzurXwzF0qc9pd+v9HEiuI9BwGhfFWAeKpOqdnC1zPsvXFq/w+77GtB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367978; c=relaxed/simple;
	bh=Xg/V4XGWSZPZQPB4HNqA28Fzg4Fb1+lAesxqCfnAQRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwKTC1j3vRQu/BdUFGTamBr46yQEiVFNkDepAHAEWOE2X4K3gBohFzzyL3rFPaW8FmJYTJ89WDYvnmi61PB3Iu1c7j43bKzriA81YAEjeb8V6bmdzPEZGGYyOFRxX+bcfVl+WY6u8srl4MKTmOqUrFEJ74eqyPdzNprvGRNDZgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fKDq6tQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fKDq6tQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB068C4CEFE;
	Mon, 13 Oct 2025 15:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367978;
	bh=Xg/V4XGWSZPZQPB4HNqA28Fzg4Fb1+lAesxqCfnAQRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fKDq6tQQ1gbN990dhC89aEGk/8/bcwoTaEpb2ASE57ewuyp2Ec5P2N7V++BQGnAv
	 sDHSEtMvS+CxMyZUzefFMt493+Y3tKFEMXOP6DlJntmit4LXQH2Ta0FFcxlKg2WX9L
	 yVf0jrFDF7hlGFfZXVEb/a/vpofGPQ8ys+IYuUss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 176/196] mfd: vexpress-sysreg: Check the return value of devm_gpiochip_add_data()
Date: Mon, 13 Oct 2025 16:46:07 +0200
Message-ID: <20251013144321.675750641@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -90,6 +90,7 @@ static int vexpress_sysreg_probe(struct
 	struct resource *mem;
 	void __iomem *base;
 	struct gpio_chip *mmc_gpio_chip;
+	int ret;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem)
@@ -110,7 +111,10 @@ static int vexpress_sysreg_probe(struct
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


