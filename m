Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495D62FA643;
	Tue, 17 Jun 2025 16:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179248; cv=none; b=mdaJs3Eb2obpAZhWS3c8VNr0zLPwnNQyursy2dodhpc+4GEtKvDguE1/MHDx/b8D0K3lvHSmTauEPz/FuFAmvO6ySvOu5t6QxaabBnrDTceL3+TyFoUUt+xwfX3wXRm+76rAU3pTvg0KgSTEkx9FhBdYut+PRCxAY69d0G525xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179248; c=relaxed/simple;
	bh=hkIYnbnui01PL3nJZX7FkqXIqiUlDk1Ak0KGjM+PuKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrQidaLVDnYHqsbjXp3SR+0gEmaaURYhSBu14Sddm0PJqEz9wTL/fklXFg7yIhwZmRc6h75hiInWyJ1wrLSb5sTQO5vquqapv439jm9q1rjkXNs4JfwdhUHtfRYmXqOV1b7CCplSXz6K+VQPCnhN1Lk4yV7GlCg/YyWtz6+XnaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsv7f/8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsv7f/8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7DDC4CEE3;
	Tue, 17 Jun 2025 16:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179248;
	bh=hkIYnbnui01PL3nJZX7FkqXIqiUlDk1Ak0KGjM+PuKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsv7f/8FDyrLwzzeKibjrX4q51SmFhh24jbV+xmXCz3Bshym7x4IQ53eqoQnnwgIc
	 9cCTa03zE6WuwmTrThelT0jPKY/+g4Qb2xNhka0cyPKwlXFFx4tAPYpfc7UqFwM7Yn
	 al7WoE7IKVEIk7TxB8LidBKE9C1FZezS/BtO7sJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 693/780] pinctrl: sunxi: dt: Consider pin base when calculating bank number from pin
Date: Tue, 17 Jun 2025 17:26:41 +0200
Message-ID: <20250617152519.716982031@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 5558f27a58459a4038ebb23bcb5bd40c1e345c57 ]

In prepare_function_table() when the pinctrl function table IRQ entries
are generated, the pin bank is calculated from the absolute pin number;
however the IRQ bank mux array is indexed from the first pin bank of the
controller. For R_PIO controllers, this means the absolute pin bank is
way off from the relative pin bank used for array indexing.

Correct this by taking into account the pin base of the controller.

Fixes: f5e2cd34b12f ("pinctrl: sunxi: allow reading mux values from DT")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/20250607135203.2085226-1-wens@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c b/drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c
index 1833078f68776..4e34b0cd3b73a 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi-dt.c
@@ -143,7 +143,7 @@ static struct sunxi_desc_pin *init_pins_table(struct device *dev,
  */
 static int prepare_function_table(struct device *dev, struct device_node *pnode,
 				  struct sunxi_desc_pin *pins, int npins,
-				  const u8 *irq_bank_muxes)
+				  unsigned pin_base, const u8 *irq_bank_muxes)
 {
 	struct device_node *node;
 	struct property *prop;
@@ -166,7 +166,7 @@ static int prepare_function_table(struct device *dev, struct device_node *pnode,
 	 */
 	for (i = 0; i < npins; i++) {
 		struct sunxi_desc_pin *pin = &pins[i];
-		int bank = pin->pin.number / PINS_PER_BANK;
+		int bank = (pin->pin.number - pin_base) / PINS_PER_BANK;
 
 		if (irq_bank_muxes[bank]) {
 			pin->variant++;
@@ -211,7 +211,7 @@ static int prepare_function_table(struct device *dev, struct device_node *pnode,
 	last_bank = 0;
 	for (i = 0; i < npins; i++) {
 		struct sunxi_desc_pin *pin = &pins[i];
-		int bank = pin->pin.number / PINS_PER_BANK;
+		int bank = (pin->pin.number - pin_base) / PINS_PER_BANK;
 		int lastfunc = pin->variant + 1;
 		int irq_mux = irq_bank_muxes[bank];
 
@@ -353,7 +353,7 @@ int sunxi_pinctrl_dt_table_init(struct platform_device *pdev,
 		return PTR_ERR(pins);
 
 	ret = prepare_function_table(&pdev->dev, pnode, pins, desc->npins,
-				     irq_bank_muxes);
+				     desc->pin_base, irq_bank_muxes);
 	if (ret)
 		return ret;
 
-- 
2.39.5



