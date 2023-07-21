Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F0C1FB42
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4CEC433CA;
	Fri, 21 Jul 2023 16:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956047;
	bh=ZuR7ks4lBmY8dy1kOwpq48U15G2f5gp7Ivorv0FyQdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKXHDhvV3QSwa32Ls6zGKNwYrzy/B9tUp3b4cQPgvO/2zADtKC6tPEyDUEBiH0Kua
	 ZeoqBUhA7HKEgghGqZRNUInACpbvSlTViSkxF1OvAFiP9tLp2l9mpKXqwtU6Lemz0Y
	 c0tYikrfqbeK/EvjBKyb2MyClQBvLI79BiHkbZmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.4 115/292] pinctrl: amd: Detect internal GPIO0 debounce handling
Date: Fri, 21 Jul 2023 18:03:44 +0200
Message-ID: <20230721160533.768472569@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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

commit 968ab9261627fa305307e3935ca1a32fcddd36cb upstream.

commit 4e5a04be88fe ("pinctrl: amd: disable and mask interrupts on probe")
had a mistake in loop iteration 63 that it would clear offset 0xFC instead
of 0x100.  Offset 0xFC is actually `WAKE_INT_MASTER_REG`.  This was
clearing bits 13 and 15 from the register which significantly changed the
expected handling for some platforms for GPIO0.

commit b26cd9325be4 ("pinctrl: amd: Disable and mask interrupts on resume")
actually fixed this bug, but lead to regressions on Lenovo Z13 and some
other systems.  This is because there was no handling in the driver for bit
15 debounce behavior.

Quoting a public BKDG:
```
EnWinBlueBtn. Read-write. Reset: 0. 0=GPIO0 detect debounced power button;
Power button override is 4 seconds. 1=GPIO0 detect debounced power button
in S3/S5/S0i3, and detect "pressed less than 2 seconds" and "pressed 2~10
seconds" in S0; Power button override is 10 seconds
```

Cross referencing the same master register in Windows it's obvious that
Windows doesn't use debounce values in this configuration.  So align the
Linux driver to do this as well.  This fixes wake on lid when
WAKE_INT_MASTER_REG is properly programmed.

Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217315
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230421120625.3366-2-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |    7 +++++++
 drivers/pinctrl/pinctrl-amd.h |    1 +
 2 files changed, 8 insertions(+)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -125,6 +125,12 @@ static int amd_gpio_set_debounce(struct
 	struct amd_gpio *gpio_dev = gpiochip_get_data(gc);
 
 	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+
+	/* Use special handling for Pin0 debounce */
+	pin_reg = readl(gpio_dev->base + WAKE_INT_MASTER_REG);
+	if (pin_reg & INTERNAL_GPIO0_DEBOUNCE)
+		debounce = 0;
+
 	pin_reg = readl(gpio_dev->base + offset * 4);
 
 	if (debounce) {
@@ -219,6 +225,7 @@ static void amd_gpio_dbg_show(struct seq
 	char *debounce_enable;
 	char *wake_cntrlz;
 
+	seq_printf(s, "WAKE_INT_MASTER_REG: 0x%08x\n", readl(gpio_dev->base + WAKE_INT_MASTER_REG));
 	for (bank = 0; bank < gpio_dev->hwbank_num; bank++) {
 		unsigned int time = 0;
 		unsigned int unit = 0;
--- a/drivers/pinctrl/pinctrl-amd.h
+++ b/drivers/pinctrl/pinctrl-amd.h
@@ -17,6 +17,7 @@
 #define AMD_GPIO_PINS_BANK3     32
 
 #define WAKE_INT_MASTER_REG 0xfc
+#define INTERNAL_GPIO0_DEBOUNCE (1 << 15)
 #define EOI_MASK (1 << 29)
 
 #define WAKE_INT_STATUS_REG0 0x2f8


