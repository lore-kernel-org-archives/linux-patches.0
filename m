Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275FE386C22;
	Sat, 12 Sep 2026 19:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242000; cv=none; b=MeeVCYqrNnP7b0Gk1czEEu6E/0BJVd7PEnp/GBNBIpR5pytinzEuAwJjmDTpisifQjDAAF8U7dShs4pko/EFo4KTgibsHMi6nEhRFDaZdeBkEEjA5raExpW3O9Ps27hcJaPGx05aXzLXuf1jynHdQQx8ObeNQARsU9IjKhC+G1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242000; c=relaxed/simple;
	bh=+eqOwevTN5gmFhKgimv7aeg3D61T+jbHT30zhwitIko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJFya3lkwOWpO9gQewHBfy1SYDkY5sigrlWJ6YFEnL9l5qJEWIPSTluTbr+x3BVCW/W0IbP7ROUT5n2F9Uw2qYNiS1eMQSjcbg1SgcVKL/TsYry/Qwxs6s6hSO80OK3FSrXUxNLIqQxzszvLoe7ywR6AlogkhQkr8IqXAhZ4nZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ih/OxUDm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ih/OxUDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED731F000FF;
	Sat, 12 Sep 2026 19:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241997;
	bh=S1dFDszh8t0x6zyOZ+TzgMnmhxmD8zmpAchPJJ/Oxxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ih/OxUDmkBPUx3JoS/f0RiJ8+XXbOlgad54vA1indSmTemQwkUfuE0OISsfoIXcwQ
	 impH77DvS4f588lbKTyjIjaVyaiNElypJOEGZL1S3p1/Rt32cMeJMuIuRVyLExgypD
	 zQkkb+iuj8lDMLE34HuIBBomqecgZ+niPKFRSOfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 252/798] ASoC: cs35l34: drain threaded IRQ before runtime suspend
Date: Sat, 12 Sep 2026 08:58:00 +0200
Message-ID: <20260912065522.934463403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 4105a4c0678b2808fc8046b60321b4f1cc7dae75 upstream.

cs35l34_runtime_suspend() currently switches the codec into
regcache_cache_only(true), asserts reset low, and powers the device off
without first quiescing the threaded IRQ registered by
devm_request_threaded_irq(). That leaves a window where
cs35l34_irq_thread() can still run after suspend has removed live
hardware access.

A running system can reach this during runtime PM while the driver still
has critical fault IRQs unmasked. If the threaded handler runs in that
window, it reads volatile INT_STATUS_1..4 after cache_only has been
enabled, ignores the regmap_read() failures, and can still execute the
PROT_RELEASE_CTL release sequence or the BST fault power-down writes.

Use disable_irq() before entering cache_only/reset-low/power-off so any
in-flight threaded handler is drained and no new IRQ thread can run
while the device is suspended. Re-enable the IRQ only after
runtime_resume() has restored live register access with regcache_sync().
Since probe only logs request_threaded_irq() failures and keeps going,
track whether the IRQ was actually installed before disabling or
re-enabling it.

Fixes: c1124c09e103 ("ASoC: cs35l34: Initial commit of the cs35l34 CODEC driver.")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260611161553.3378721-3-runyu.xiao@seu.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cs35l34.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/cs35l34.c
+++ b/sound/soc/codecs/cs35l34.c
@@ -44,6 +44,7 @@ struct  cs35l34_private {
 	int num_core_supplies;
 	int mclk_int;
 	bool tdm_mode;
+	bool irq_requested;
 	struct gpio_desc *reset_gpio;	/* Active-low reset GPIO */
 };
 
@@ -1050,10 +1051,12 @@ static int cs35l34_i2c_probe(struct i2c_
 	}
 
 	ret = devm_request_threaded_irq(&i2c_client->dev, i2c_client->irq, NULL,
-			cs35l34_irq_thread, IRQF_ONESHOT | IRQF_TRIGGER_LOW,
-			"cs35l34", cs35l34);
+				cs35l34_irq_thread, IRQF_ONESHOT | IRQF_TRIGGER_LOW,
+				"cs35l34", cs35l34);
 	if (ret != 0)
 		dev_err(&i2c_client->dev, "Failed to request IRQ: %d\n", ret);
+	else
+		cs35l34->irq_requested = true;
 
 	cs35l34->reset_gpio = devm_gpiod_get_optional(&i2c_client->dev,
 				"reset", GPIOD_OUT_LOW);
@@ -1157,6 +1160,9 @@ static int __maybe_unused cs35l34_runtim
 		dev_err(dev, "Failed to restore register cache\n");
 		goto err;
 	}
+
+	if (cs35l34->irq_requested)
+		enable_irq(to_i2c_client(dev)->irq);
 	return 0;
 err:
 	regcache_cache_only(cs35l34->regmap, true);
@@ -1170,6 +1176,10 @@ static int __maybe_unused cs35l34_runtim
 {
 	struct cs35l34_private *cs35l34 = dev_get_drvdata(dev);
 
+	/* Drain and block the threaded IRQ before cache_only/power-off. */
+	if (cs35l34->irq_requested)
+		disable_irq(to_i2c_client(dev)->irq);
+
 	regcache_cache_only(cs35l34->regmap, true);
 	regcache_mark_dirty(cs35l34->regmap);
 


