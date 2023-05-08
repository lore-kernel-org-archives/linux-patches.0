Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4BA168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5582C433D2;
	Mon,  8 May 2023 11:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545198;
	bh=osggGEj4JKsmz6/Dvz6kPG2mchpBugrtqzbtUMynS+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiFB0mJLasstvRw5LyIFEN/iHMKAWNtPF58ZyZRo+ZiK7Sa6HGNOql7QTPC9gqGeZ
	 h+zFg5q/kkJ8wRMogOtPcjHyK9ZqRm+BXBXnkWARolLQnmd9kpvcD37eq0/mFOhCkr
	 DSPKdX0nzoOU8xchnlSCuNQUrCYZGyZvcwavbu5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 657/694] pinctrl-bcm2835.c: fix race condition when setting gpio dir
Date: Mon,  8 May 2023 11:48:12 +0200
Message-Id: <20230508094457.297080441@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit b7badd752de05312fdb1aeb388480f706d0c087f ]

In the past setting the pin direction called pinctrl_gpio_direction()
which uses a mutex to serialize this. That was changed to set the
direction directly in the pin controller driver, but that lost the
serialization mechanism. Since the direction of multiple pins are in
the same register you can have a race condition, something that was
in fact observed with the cec-gpio driver.

Add a new spinlock to serialize writing to the FSEL registers.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 1a4541b68e25 ("pinctrl-bcm2835: don't call pinctrl_gpio_direction()")
Link: https://lore.kernel.org/r/4302b66b-ca20-0f19-d2aa-ee8661118863@xs4all.nl
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index 8e2551a08c372..7435173e10f43 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -90,6 +90,8 @@ struct bcm2835_pinctrl {
 	struct pinctrl_gpio_range gpio_range;
 
 	raw_spinlock_t irq_lock[BCM2835_NUM_BANKS];
+	/* Protect FSEL registers */
+	spinlock_t fsel_lock;
 };
 
 /* pins are just named GPIO0..GPIO53 */
@@ -284,14 +286,19 @@ static inline void bcm2835_pinctrl_fsel_set(
 		struct bcm2835_pinctrl *pc, unsigned pin,
 		enum bcm2835_fsel fsel)
 {
-	u32 val = bcm2835_gpio_rd(pc, FSEL_REG(pin));
-	enum bcm2835_fsel cur = (val >> FSEL_SHIFT(pin)) & BCM2835_FSEL_MASK;
+	u32 val;
+	enum bcm2835_fsel cur;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pc->fsel_lock, flags);
+	val = bcm2835_gpio_rd(pc, FSEL_REG(pin));
+	cur = (val >> FSEL_SHIFT(pin)) & BCM2835_FSEL_MASK;
 
 	dev_dbg(pc->dev, "read %08x (%u => %s)\n", val, pin,
-			bcm2835_functions[cur]);
+		bcm2835_functions[cur]);
 
 	if (cur == fsel)
-		return;
+		goto unlock;
 
 	if (cur != BCM2835_FSEL_GPIO_IN && fsel != BCM2835_FSEL_GPIO_IN) {
 		/* always transition through GPIO_IN */
@@ -309,6 +316,9 @@ static inline void bcm2835_pinctrl_fsel_set(
 	dev_dbg(pc->dev, "write %08x (%u <= %s)\n", val, pin,
 			bcm2835_functions[fsel]);
 	bcm2835_gpio_wr(pc, FSEL_REG(pin), val);
+
+unlock:
+	spin_unlock_irqrestore(&pc->fsel_lock, flags);
 }
 
 static int bcm2835_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
@@ -1248,6 +1258,7 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 	pc->gpio_chip = *pdata->gpio_chip;
 	pc->gpio_chip.parent = dev;
 
+	spin_lock_init(&pc->fsel_lock);
 	for (i = 0; i < BCM2835_NUM_BANKS; i++) {
 		unsigned long events;
 		unsigned offset;
-- 
2.39.2



