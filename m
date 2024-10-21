Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BED1E7C18;
	Mon, 21 Oct 2024 10:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507162; cv=none; b=rB0qcxyZ8RF42+8tqIUpYH7qaVrKF/1uW0m3XpJdchtvGUpNBdoRnTClyKYmNvl2haWquY1ONubQp3YjpAi6OzqgUgG9ACJBUjDVHCxQ9OJTKwrCPNKSpCQII6LNLQqLblF0WUSkajgaJTkHd+t8nFXq19HCPYLCfwLH/hsdFcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507162; c=relaxed/simple;
	bh=M2iJ4XIKREdzxoR0Jw1ALmZ/LC/9iviV2Ws/kLUg5Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hV/ANyZk3tYu3PrREDINUAJ6WVLe1NBRxZWUe2eLtuoTFcPBtXxI4mP57lkzpp3wgdiT+kAzfts61EnX4SNKVIAiqjzw8RWrG+BPmYi4mBpAc9giwAg6bFAqrrruNbGkHT2fuLSfgCpW5bvmr1OgejqFVqpuvwmhFYc+i3uo9K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJmnUWq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJmnUWq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A369C4CEC3;
	Mon, 21 Oct 2024 10:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507162;
	bh=M2iJ4XIKREdzxoR0Jw1ALmZ/LC/9iviV2Ws/kLUg5Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJmnUWq2DD7NFuyuQ/Gq+Ny1ZM3mEcuJUAFm9bVNjwHA7WWxmJmcPEWArc7BKwSwd
	 0/eM5RUi/zLQVoKFl4onHxLWUXJ2oicxezNSP9iRFk2JXvfl020zDGRSUSDDurh0M/
	 GKHnkjppMvHWb/GWkDN2cbKA6gXzsUcOZF5Bc4Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Matsievskiy <matsievskiysv@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.6 110/124] pinctrl: ocelot: fix system hang on level based interrupts
Date: Mon, 21 Oct 2024 12:25:14 +0200
Message-ID: <20241021102300.973290117@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Matsievskiy <matsievskiysv@gmail.com>

commit 93b8ddc54507a227087c60a0013ed833b6ae7d3c upstream.

The current implementation only calls chained_irq_enter() and
chained_irq_exit() if it detects pending interrupts.

```
for (i = 0; i < info->stride; i++) {
	uregmap_read(info->map, id_reg + 4 * i, &reg);
	if (!reg)
		continue;

	chained_irq_enter(parent_chip, desc);
```

However, in case of GPIO pin configured in level mode and the parent
controller configured in edge mode, GPIO interrupt might be lowered by the
hardware. In the result, if the interrupt is short enough, the parent
interrupt is still pending while the GPIO interrupt is cleared;
chained_irq_enter() never gets called and the system hangs trying to
service the parent interrupt.

Moving chained_irq_enter() and chained_irq_exit() outside the for loop
ensures that they are called even when GPIO interrupt is lowered by the
hardware.

The similar code with chained_irq_enter() / chained_irq_exit() functions
wrapping interrupt checking loop may be found in many other drivers:
```
grep -r -A 10 chained_irq_enter drivers/pinctrl
```

Cc: stable@vger.kernel.org
Signed-off-by: Sergey Matsievskiy <matsievskiysv@gmail.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/20241012105743.12450-2-matsievskiysv@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-ocelot.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -1962,21 +1962,21 @@ static void ocelot_irq_handler(struct ir
 	unsigned int reg = 0, irq, i;
 	unsigned long irqs;
 
+	chained_irq_enter(parent_chip, desc);
+
 	for (i = 0; i < info->stride; i++) {
 		regmap_read(info->map, id_reg + 4 * i, &reg);
 		if (!reg)
 			continue;
 
-		chained_irq_enter(parent_chip, desc);
-
 		irqs = reg;
 
 		for_each_set_bit(irq, &irqs,
 				 min(32U, info->desc->npins - 32 * i))
 			generic_handle_domain_irq(chip->irq.domain, irq + 32 * i);
-
-		chained_irq_exit(parent_chip, desc);
 	}
+
+	chained_irq_exit(parent_chip, desc);
 }
 
 static int ocelot_gpiochip_register(struct platform_device *pdev,


