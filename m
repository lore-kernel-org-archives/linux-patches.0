Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D9D1E8854;
	Mon, 21 Oct 2024 10:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506794; cv=none; b=VLBK2mPXGCEIxhX4w5cP7ng8jfhTkHFMMUOs0p0ZMq40pcqN9JR8XsmeBzivCH4N3cA8WWUgR/MDvG8gmSXwbtiM73WAmMH6EOFjcfX3xMU5HZNKuWFU6kA7j/ILF2E490aet4ckE/6zLyfnn3AdJFDejvX7nai8Qu3OhvDJo/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506794; c=relaxed/simple;
	bh=0jFSYChs4/Gbb/0SLHLvpMytbldu8qA4e9P13O9CBrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdhIadtRNzUiUyYyhrKuqaI+e+PJZHd0l+UTqxuPotGP8JBq8I039svdEncHGcR5l4TCUKUK4k0rv7sMaUOAUb6Wec0SMrYbaNTfx/m961VVPSkMbuFjpspMufRk9wPd4GS5rbCkV4nCcfrWwyzix5FBiTDqz32rvOHBDqlkf3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4gMKeTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4gMKeTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BF1C4CEE8;
	Mon, 21 Oct 2024 10:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506793;
	bh=0jFSYChs4/Gbb/0SLHLvpMytbldu8qA4e9P13O9CBrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p4gMKeTY9fwz91dCkDai6nAZrj6aVdw/EDxXrGyYi1PHMt5wHfIU3isM8cR4/uc7T
	 CZxFvyQpBrnyTOPiZkcC7zegaXis0IomOQ+epJaqjxY8I97bTvgn+CWuR5Kqg8LDWv
	 yzTzdNhTHGIeZofmbxNI/EjhIi9B43TqYL+PRYgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Matsievskiy <matsievskiysv@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.11 123/135] pinctrl: ocelot: fix system hang on level based interrupts
Date: Mon, 21 Oct 2024 12:24:39 +0200
Message-ID: <20241021102304.145858051@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1955,21 +1955,21 @@ static void ocelot_irq_handler(struct ir
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


