Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D7820F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD54C433CA;
	Fri, 21 Jul 2023 19:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967287;
	bh=5TfMpsNO7wFX4j5DzdZIqwozieroYAMDbWSNwTlM0y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjInSkm0+DToAQKYBcrhOf0UemH0q4JekAfXzZKBnO6KaMqcrZhDzgsRHz9/vSr+Q
	 JOTIezyOP3LyNoXpF/9pPoYhegVZc66Rkp+QSPM10fQt7JRo4OCMfncLtKlxpztVJL
	 sAX9jal1pARPQH73XR4bGr0QJ9yA1s2UqpyurJwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.1 081/223] pinctrl: amd: Fix mistake in handling clearing pins at startup
Date: Fri, 21 Jul 2023 18:05:34 +0200
Message-ID: <20230721160524.315441731@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit a855724dc08b8cb0c13ab1e065a4922f1e5a7552 upstream.

commit 4e5a04be88fe ("pinctrl: amd: disable and mask interrupts on probe")
had a mistake in loop iteration 63 that it would clear offset 0xFC instead
of 0x100.  Offset 0xFC is actually `WAKE_INT_MASTER_REG`.  This was
clearing bits 13 and 15 from the register which significantly changed the
expected handling for some platforms for GPIO0.

Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217315
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230421120625.3366-3-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -897,9 +897,9 @@ static void amd_gpio_irq_init(struct amd
 
 		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 
-		pin_reg = readl(gpio_dev->base + i * 4);
+		pin_reg = readl(gpio_dev->base + pin * 4);
 		pin_reg &= ~mask;
-		writel(pin_reg, gpio_dev->base + i * 4);
+		writel(pin_reg, gpio_dev->base + pin * 4);
 
 		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 	}


