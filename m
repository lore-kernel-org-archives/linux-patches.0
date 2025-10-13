Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67444307AF4;
	Mon, 13 Oct 2025 14:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367347; cv=none; b=m0yRl/O3j/XALvL7AJrSsmQeckbWtfWsIltPCfisJepyq6qKDqXUwzcN2QgoLQsB3AsoevRaCC7RNNXLUhG+FdBV5hRTo2etg0aFGsZWSKkskhds2g/H64H9y9ik0N0pYmC3R4DfR0RN0n2XnE6pgHNaXp9elv/UHi5n75QhqRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367347; c=relaxed/simple;
	bh=/xnOoXMqhwsGL+Ys22+axOnvvWJnFeyxKqSsV7YsdW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgLjhnNQsGhkwHp7eI1ipkVLg4rlwzH5ZSk7Hwcob7kMuOKobVx0nDFQt+OO6pHEpSlIy/ZhuuOGRyM5p+G+ltOpcU3tmg1vtkCHqKAkGiPmsntnNCzm4bHeeyWeYKdiddqASaWy9ie+A6+cBvRem4JqF0JFSQk7CZM1uPtAmAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5vU6v7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5vU6v7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7D5C4CEE7;
	Mon, 13 Oct 2025 14:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367346;
	bh=/xnOoXMqhwsGL+Ys22+axOnvvWJnFeyxKqSsV7YsdW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5vU6v7cmnVoXaQ8u8ufFZh+zMTW9FujmTZvhAKxgJwMbJfSchdTmd8cYe/4j6uJp
	 WbHwSr17QUXxgZpd8WFYVSojZDc1VsLf7Ob3R2AHVDvDuocGt0fInqJ3u1tWTqNfXE
	 vna2IF9whvw+nyLLKPtuYI23saMSX4CjWTgaBbFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 177/196] mfd: vexpress-sysreg: Check the return value of devm_gpiochip_add_data()
Date: Mon, 13 Oct 2025 16:45:50 +0200
Message-ID: <20251013144321.098643766@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


