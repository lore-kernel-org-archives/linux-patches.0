Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9D23161BF;
	Mon, 13 Oct 2025 15:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369264; cv=none; b=cg+nsn6+I86jaOfeX4d0OUONKFCGtQSsfF0XyQNxg5XJVyu+eDgvYhE/6xCMDGKDyhlsISM671kmT85vb+ElZXRFAAAXfcXqLqOjxUKbmeM+f0ivdH3hNQEqF+3wHtz4iPQ7EnfCzQj39dfRDNshQdd5G0KY5DFWA4qXk2PpfQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369264; c=relaxed/simple;
	bh=GzIrFzEhUvZhTY+bAeXBqvbsbtEN6pyPkW6nKukX5IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTRmOzqMkjw4DpaNc9WbXtYfJLzHfGjcBRqa8VTGqaJJiBRd9FxohybK5PohmZA0L5ZxnrCXcWq+wKm19t3boGwY4iL582loz7yD3/gX6nuhdbMWw5oRzibN56GvDutoGlRRpD/uAdZc8Os2lySN+s6iq3JNTGcQxRHhSdiPR+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TPmFVz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TPmFVz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8498BC116B1;
	Mon, 13 Oct 2025 15:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369263;
	bh=GzIrFzEhUvZhTY+bAeXBqvbsbtEN6pyPkW6nKukX5IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TPmFVz2AQKorsyvi6pMyug4m/UAsoXAvOGo8RaaA+E678CqBBT/wHK2YM3629Oe1
	 Ix9EDzd/XRTCyOiaroUDjb5vbTYlHYxOV7pCWUkMXBhnmSE9MjoFdHv3kuS1elfkQr
	 z68wpM8/7UUM9M/9jO8S81+cmoNHeYr8fgCcKm5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 185/563] mfd: max77705: max77705_charger: move active discharge setting to mfd parent
Date: Mon, 13 Oct 2025 16:40:46 +0200
Message-ID: <20251013144417.984222869@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit c24928ac69be2390cdf456d126b464af079c57ef ]

Active discharge setting is a part of MFD top level i2c device, hence
cannot be controlled by charger. Writing to MAX77705_PMIC_REG_MAINCTRL1
register from charger driver is a mistake.

Move active discharge setting to MFD parent driver.

Fixes: a6a494c8e3ce ("power: supply: max77705: Add charger driver for Maxim 77705")
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Acked-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/max77705.c                  | 3 +++
 drivers/power/supply/max77705_charger.c | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/max77705.c b/drivers/mfd/max77705.c
index 6b263bacb8c28..ff07d0e0d5f8e 100644
--- a/drivers/mfd/max77705.c
+++ b/drivers/mfd/max77705.c
@@ -108,6 +108,9 @@ static int max77705_i2c_probe(struct i2c_client *i2c)
 	if (pmic_rev != MAX77705_PASS3)
 		return dev_err_probe(dev, -ENODEV, "Rev.0x%x is not tested\n", pmic_rev);
 
+	/* Active Discharge Enable */
+	regmap_update_bits(max77705->regmap, MAX77705_PMIC_REG_MAINCTRL1, 1, 1);
+
 	ret = devm_regmap_add_irq_chip(dev, max77705->regmap,
 					i2c->irq,
 					IRQF_ONESHOT | IRQF_SHARED, 0,
diff --git a/drivers/power/supply/max77705_charger.c b/drivers/power/supply/max77705_charger.c
index 329b430d0e506..3b75c82b9b9ea 100644
--- a/drivers/power/supply/max77705_charger.c
+++ b/drivers/power/supply/max77705_charger.c
@@ -487,9 +487,6 @@ static void max77705_charger_initialize(struct max77705_charger_data *chg)
 	regmap_update_bits(regmap, MAX77705_CHG_REG_CNFG_00,
 				MAX77705_WDTEN_MASK, 0);
 
-	/* Active Discharge Enable */
-	regmap_update_bits(regmap, MAX77705_PMIC_REG_MAINCTRL1, 1, 1);
-
 	/* VBYPSET=5.0V */
 	regmap_update_bits(regmap, MAX77705_CHG_REG_CNFG_11, MAX77705_VBYPSET_MASK, 0);
 
-- 
2.51.0



