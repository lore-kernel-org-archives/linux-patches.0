Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C04F33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823BDC433EF;
	Mon, 16 Jan 2023 16:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884900;
	bh=nRHpCz1qSDLy+lKVEfT3O+Qak/+WHrmKn2uNdYSWR7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NzOwVSW8/ZR5GHALB4JWZfQp0l9jRyHY9gDVjWQQzE9JLJiFA9pk7vqlI6p3Uwxsy
	 2uf6LYGcPUV8otZkcbfG56R3GCkeocgIoEa1U+3Nzq4YTvECA8E0SqvMOwvIMu5kSA
	 EtTgCfVtI7mNzJ1H1xRV8kPZO7m0DVfi9Gb0nVWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Mark Pearson <markpearson@lenovo.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.1 183/183] pinctrl: amd: Add dynamic debugging for active GPIOs
Date: Mon, 16 Jan 2023 16:51:46 +0100
Message-Id: <20230116154811.042081876@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

commit 1d66e379731f79ae5039a869c0fde22a4f6a6a91 upstream.

Some laptops have been reported to wake up from s2idle when plugging
in the AC adapter or by closing the lid.  This is a surprising
behavior that is further clarified by commit cb3e7d624c3ff ("PM:
wakeup: Add extra debugging statement for multiple active IRQs").

With that commit in place the following interaction can be seen
when the lid is closed:

[   28.946038] PM: suspend-to-idle
[   28.946083] ACPI: EC: ACPI EC GPE status set
[   28.946101] ACPI: PM: Rearming ACPI SCI for wakeup
[   28.950152] Timekeeping suspended for 3.320 seconds
[   28.950152] PM: Triggering wakeup from IRQ 9
[   28.950152] ACPI: EC: ACPI EC GPE status set
[   28.950152] ACPI: EC: ACPI EC GPE dispatched
[   28.995057] ACPI: EC: ACPI EC work flushed
[   28.995075] ACPI: PM: Rearming ACPI SCI for wakeup
[   28.995131] PM: Triggering wakeup from IRQ 9
[   28.995271] ACPI: EC: ACPI EC GPE status set
[   28.995291] ACPI: EC: ACPI EC GPE dispatched
[   29.098556] ACPI: EC: ACPI EC work flushed
[   29.207020] ACPI: EC: ACPI EC work flushed
[   29.207037] ACPI: PM: Rearming ACPI SCI for wakeup
[   29.211095] Timekeeping suspended for 0.739 seconds
[   29.211095] PM: Triggering wakeup from IRQ 9
[   29.211079] PM: Triggering wakeup from IRQ 7
[   29.211095] ACPI: PM: ACPI non-EC GPE wakeup
[   29.211095] PM: resume from suspend-to-idle

* IRQ9 on this laptop is used for the ACPI SCI.
* IRQ7 on this laptop is used for the GPIO controller.

What has occurred is when the lid was closed the EC woke up the
SoC from it's deepest sleep state and the kernel's s2idle loop
processed all EC events.  When it was finished processing EC events,
it checked for any other reasons to wake (break the s2idle loop).

The IRQ for the GPIO controller was active so the loop broke, and
then this IRQ was processed.  This is not a kernel bug but it is
certainly a surprising behavior, and to better debug it we should
have a dynamic debugging message that we can enact to catch it.

Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Acked-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Acked-by: Mark Pearson <markpearson@lenovo.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20221013134729.5592-2-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -628,13 +628,15 @@ static bool do_amd_gpio_irq_handler(int
 		/* Each status bit covers four pins */
 		for (i = 0; i < 4; i++) {
 			regval = readl(regs + i);
-			/* caused wake on resume context for shared IRQ */
-			if (irq < 0 && (regval & BIT(WAKE_STS_OFF))) {
+
+			if (regval & PIN_IRQ_PENDING)
 				dev_dbg(&gpio_dev->pdev->dev,
-					"Waking due to GPIO %d: 0x%x",
+					"GPIO %d is active: 0x%x",
 					irqnr + i, regval);
+
+			/* caused wake on resume context for shared IRQ */
+			if (irq < 0 && (regval & BIT(WAKE_STS_OFF)))
 				return true;
-			}
 
 			if (!(regval & PIN_IRQ_PENDING) ||
 			    !(regval & BIT(INTERRUPT_MASK_OFF)))


