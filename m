Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D955A38A71E;
	Tue, 10 Mar 2026 11:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142120; cv=none; b=jQ/nhTPFXf3C85CkfvSVwF+bCzRd9aHr+rpH5tlq4EsLjwf1mDPs8tGnNl6lMtLtWCGUMLKmt8948RzbMDz22Bqyaz4vQEmWNqdmt1lQHUFW3HbQB2BXMPBI6j3XLW8+A8+KZe8JAwdUbxMbZ3/SZAScYnl7egftmdNDeLYbhKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142120; c=relaxed/simple;
	bh=sBLC6Y9qzLov302DKhQxi6L2Ig+Z4NQdPHS38Zx0jUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n50OEsxvo1arKYXBwAw7haLmv1YJyVmG4RgQviaI9XO78/4DTr7I/EQKnlON/k88YTYrw89/C9LITokvRQdw0tnYcOvEcrJtS3f1k0Ksk3uIsJMxXbfDJuM2v8zsNXc+a8sDEI+W8mN261c3b14dFkOzYRJ1wgUTFASCltgruP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O8lQMKKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O8lQMKKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAFFC2BCAF;
	Tue, 10 Mar 2026 11:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142120;
	bh=sBLC6Y9qzLov302DKhQxi6L2Ig+Z4NQdPHS38Zx0jUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8lQMKKoZRjAdN0q8wrhq5PYobmAFdbGliD+biPTM8InzgunmdOSsijfR0e8m8Gl3
	 1iYoLsScutnWXn/TR51PXD7+GyyT8jrdxv9Dokp/y3UYZ3ZZF+vsp7Bvu+As7sH6Ge
	 FjUJzIDz0kENGQmGZQ7AaFZzsdAutmugPSVJ3E8QITLingZ6Va0DKt+Ve++ZGx6LIB
	 jHfyFHQZnqXy8d2HP2tedHtOlSRFtW8dOmQ4DLMGtSSRuu8zjeLYp75H3kzZjhmdma
	 PrO3h64SOysyeNfxkJZ2++4vPFTPXVXELQbTgrrrUxC47l5RJaXJQBQ11ZzG6vX1TS
	 SSQrDH0GVIr9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florian Eckert <fe@dev.tdt.de>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 209/314] pinctrl: equilibrium: fix warning trace on load
Date: Tue, 10 Mar 2026 07:17:48 -0400
Message-ID: <a217648530f9667b4979b373f05c0a6cffaa728d.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Florian Eckert <fe@dev.tdt.de>

[ Upstream commit 3e00b1b332e54ba50cca6691f628b9c06574024f ]

The callback functions 'eqbr_irq_mask()' and 'eqbr_irq_ack()' are also
called in the callback function 'eqbr_irq_mask_ack()'. This is done to
avoid source code duplication. The problem, is that in the function
'eqbr_irq_mask()' also calles the gpiolib function 'gpiochip_disable_irq()'

This generates the following warning trace in the log for every gpio on
load.

[    6.088111] ------------[ cut here ]------------
[    6.092440] WARNING: CPU: 3 PID: 1 at drivers/gpio/gpiolib.c:3810 gpiochip_disable_irq+0x39/0x50
[    6.097847] Modules linked in:
[    6.097847] CPU: 3 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W          6.12.59+ #0
[    6.097847] Tainted: [W]=WARN
[    6.097847] RIP: 0010:gpiochip_disable_irq+0x39/0x50
[    6.097847] Code: 39 c6 48 19 c0 21 c6 48 c1 e6 05 48 03 b2 38 03 00 00 48 81 fe 00 f0 ff ff 77 11 48 8b 46 08 f6 c4 02 74 06 f0 80 66 09 fb c3 <0f> 0b 90 0f 1f 40 00 c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40
[    6.097847] RSP: 0000:ffffc9000000b830 EFLAGS: 00010046
[    6.097847] RAX: 0000000000000045 RBX: ffff888001be02a0 RCX: 0000000000000008
[    6.097847] RDX: ffff888001be9000 RSI: ffff888001b2dd00 RDI: ffff888001be02a0
[    6.097847] RBP: ffffc9000000b860 R08: 0000000000000000 R09: 0000000000000000
[    6.097847] R10: 0000000000000001 R11: ffff888001b2a154 R12: ffff888001be0514
[    6.097847] R13: ffff888001be02a0 R14: 0000000000000008 R15: 0000000000000000
[    6.097847] FS:  0000000000000000(0000) GS:ffff888041d80000(0000) knlGS:0000000000000000
[    6.097847] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.097847] CR2: 0000000000000000 CR3: 0000000003030000 CR4: 00000000001026b0
[    6.097847] Call Trace:
[    6.097847]  <TASK>
[    6.097847]  ? eqbr_irq_mask+0x63/0x70
[    6.097847]  ? no_action+0x10/0x10
[    6.097847]  eqbr_irq_mask_ack+0x11/0x60

In an other driver (drivers/pinctrl/starfive/pinctrl-starfive-jh7100.c) the
interrupt is not disabled here.

To fix this, do not call the 'eqbr_irq_mask()' and 'eqbr_irq_ack()'
function. Implement instead this directly without disabling the interrupts.

Fixes: 52066a53bd11 ("pinctrl: equilibrium: Convert to immutable irq_chip")
Signed-off-by: Florian Eckert <fe@dev.tdt.de>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-equilibrium.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-equilibrium.c b/drivers/pinctrl/pinctrl-equilibrium.c
index 49c8232b525a9..ba1c867b7b891 100644
--- a/drivers/pinctrl/pinctrl-equilibrium.c
+++ b/drivers/pinctrl/pinctrl-equilibrium.c
@@ -64,8 +64,15 @@ static void eqbr_irq_ack(struct irq_data *d)
 
 static void eqbr_irq_mask_ack(struct irq_data *d)
 {
-	eqbr_irq_mask(d);
-	eqbr_irq_ack(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct eqbr_gpio_ctrl *gctrl = gpiochip_get_data(gc);
+	unsigned int offset = irqd_to_hwirq(d);
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&gctrl->lock, flags);
+	writel(BIT(offset), gctrl->membase + GPIO_IRNENCLR);
+	writel(BIT(offset), gctrl->membase + GPIO_IRNCR);
+	raw_spin_unlock_irqrestore(&gctrl->lock, flags);
 }
 
 static inline void eqbr_cfg_bit(void __iomem *addr,
-- 
2.51.0

