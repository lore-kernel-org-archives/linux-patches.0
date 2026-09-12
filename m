Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A951345EA7;
	Sat, 12 Sep 2026 15:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228197; cv=none; b=POvl5940PppVyVYbYNOJlG420SwiXjYQoO1aluuKXqeGRj02p/1dZnuT7+ChrcV5VE2W1/3K01HY8SzT/zwfUtkfiGnSUtsl/KEgOOEzp71coYDtVZIF6uU/Lqy5L0fRP2rEZm4qAo60bEePpPeZnnYXCyk01aBJyBpTFVFmYo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228197; c=relaxed/simple;
	bh=vRTuAmneWMz1JF24JKaFFU1+oTUd9n/57gRsqASABY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPY85B7DYsdsAUrBmVtufNI3SCcLHyEvnQROzNlE/0a92nfqCdPRDjdhhpWaaXwhx5zUReKTCaV6G7IPRtOsfUKg9DoeztHYRL2aPHWVkJ+5fb2K9Yl1/MY7xoFSEnPQ3aNWtNEZ9EMJrZQcp5lF1GN5QrEqsyhdsVAKb2+KYTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0M681Cj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0M681Cj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2241F000FF;
	Sat, 12 Sep 2026 15:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228195;
	bh=dt1WX0JzR0j4hWfTod7TyVO0z/BOuALbtOSyXqWI3mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0M681Cja7nynBnaMvYefAuZ9ehKtZ5eTJJnbsQL1AbTJacMCMoiE0Zik8xZBSW0U
	 rmp/k+DsKPYQXImX6v0uAb370DLidulaAbBbLpkuA81B+9E+x5i2F20hS73Uh5n9NZ
	 Lq7So5pEI/2TYTBnUOq39dGk5c5j55tye5KdHrDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 0337/1191] ASoC: cs35l33: drain threaded IRQ before runtime suspend
Date: Sat, 12 Sep 2026 08:51:05 +0200
Message-ID: <20260912065555.796029301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit e074c12c428c633e079154301207a6079a208583 upstream.

cs35l33_runtime_suspend() currently switches the codec into
regcache_cache_only(true) and powers it down without first quiescing the
threaded IRQ registered by devm_request_threaded_irq(). That leaves a
window where cs35l33_irq_thread() can still run after suspend has closed
off live register access.

A running system can reach this during runtime PM while the driver still
has critical fault IRQs unmasked. If the threaded handler runs in that
window, it reads volatile INT_STATUS_1/2 after cache_only has been
enabled, ignores the regmap_read() failures, and can still drive the
AMP_SHORT_RLS, CAL_ERR_RLS, OTE_RLS, and OTW_RLS release paths.

Use disable_irq() before entering cache_only/power-off so any in-flight
threaded handler is drained and no new IRQ thread can run during the
suspended state. Re-enable the IRQ only after runtime_resume() has
restored live register access with regcache_sync(). Since probe only
warns if devm_request_threaded_irq() fails, track whether the IRQ was
actually installed before disabling or re-enabling it.

Fixes: 3333cb7187b9 ("ASoC: cs35l33: Initial commit of the cs35l33 CODEC driver.")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260611161553.3378721-2-runyu.xiao@seu.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cs35l33.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/cs35l33.c
+++ b/sound/soc/codecs/cs35l33.c
@@ -42,6 +42,7 @@ struct cs35l33_private {
 	struct regmap *regmap;
 	struct gpio_desc *reset_gpio;
 	bool amp_cal;
+	bool irq_requested;
 	int mclk_int;
 	struct regulator_bulk_data core_supplies[2];
 	int num_core_supplies;
@@ -883,6 +884,9 @@ static int __maybe_unused cs35l33_runtim
 		goto err;
 	}
 
+	if (cs35l33->irq_requested)
+		enable_irq(to_i2c_client(dev)->irq);
+
 	return 0;
 
 err:
@@ -902,6 +906,10 @@ static int __maybe_unused cs35l33_runtim
 	/* redo the calibration in next power up */
 	cs35l33->amp_cal = false;
 
+	/* Drain and block the threaded IRQ before cache_only/power-off. */
+	if (cs35l33->irq_requested)
+		disable_irq(to_i2c_client(dev)->irq);
+
 	regcache_cache_only(cs35l33->regmap, true);
 	regcache_mark_dirty(cs35l33->regmap);
 	regulator_bulk_disable(cs35l33->num_core_supplies,
@@ -1158,10 +1166,12 @@ static int cs35l33_i2c_probe(struct i2c_
 	}
 
 	ret = devm_request_threaded_irq(&i2c_client->dev, i2c_client->irq, NULL,
-			cs35l33_irq_thread, IRQF_ONESHOT | IRQF_TRIGGER_LOW,
-			"cs35l33", cs35l33);
+				cs35l33_irq_thread, IRQF_ONESHOT | IRQF_TRIGGER_LOW,
+				"cs35l33", cs35l33);
 	if (ret != 0)
 		dev_warn(&i2c_client->dev, "Failed to request IRQ: %d\n", ret);
+	else
+		cs35l33->irq_requested = true;
 
 	/* We could issue !RST or skip it based on AMP topology */
 	cs35l33->reset_gpio = devm_gpiod_get_optional(&i2c_client->dev,


