Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C20B332EAE;
	Sat, 12 Sep 2026 13:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221568; cv=none; b=SV07gGKBZ6NPk6bsjcrMUMCW42Qxi4rC8PK/zCjQ1oA5pWAoikKWFoilB+914gE0/m0EfQq6iY+hSr33+AF3NrQwkDbCWpuCpCzSzZxR1nJM/QS/sFKxW/kvB3IIvBIVFyYHI8K2vwWIkCGiniLFJC5MwcMEw9am2b/d58GwGP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221568; c=relaxed/simple;
	bh=5TRhUbtMSw6njuYd4mCk+oU9rz7czXtweWPgCV8K6ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQy16bCqyp4f5W4BZTBfQJTzx1dn0vjbsToo+m3PGQqxmsQ1G8nNMSPZyPYvpqzZ5hSOACNgKF6syOGKRcXZe3cTCxCdUgL0CPY71IaPgJ1nrh7uqIJSjFmbFRid3yDr9OP+upGolmivOHMwT8SCM3gEs+OhH1jg7m/NucM5MUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqaeAHPz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqaeAHPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483211F000FF;
	Sat, 12 Sep 2026 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221564;
	bh=CxFqBuw0TT1ZQwa0DEgCzaGUg5LcznXpBiMcUHfOQ9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqaeAHPzak5gng7+GHwjVuSYum97yQOXYz9GCV3sta0LJIzSEpCqz2l2r/+9gkoSI
	 EyiY7DtuLk01Ykg7GxZgWmjmrr5xEASwrx+j9nLyHkLtty2+pKKCFtM+2+BTfDDkg+
	 LE/cqIo23VSmB2NYdlhEcnuhRTsANbuqlflfFYnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0409/1424] ASoC: cs35l34: drain threaded IRQ before runtime suspend
Date: Sat, 12 Sep 2026 08:47:21 +0200
Message-ID: <20260912065616.442567409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -45,6 +45,7 @@ struct  cs35l34_private {
 	int num_core_supplies;
 	int mclk_int;
 	bool tdm_mode;
+	bool irq_requested;
 	struct gpio_desc *reset_gpio;	/* Active-low reset GPIO */
 };
 
@@ -1053,10 +1054,12 @@ static int cs35l34_i2c_probe(struct i2c_
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
@@ -1161,6 +1164,9 @@ static int __maybe_unused cs35l34_runtim
 		dev_err(dev, "Failed to restore register cache\n");
 		goto err;
 	}
+
+	if (cs35l34->irq_requested)
+		enable_irq(to_i2c_client(dev)->irq);
 	return 0;
 err:
 	regcache_cache_only(cs35l34->regmap, true);
@@ -1174,6 +1180,10 @@ static int __maybe_unused cs35l34_runtim
 {
 	struct cs35l34_private *cs35l34 = dev_get_drvdata(dev);
 
+	/* Drain and block the threaded IRQ before cache_only/power-off. */
+	if (cs35l34->irq_requested)
+		disable_irq(to_i2c_client(dev)->irq);
+
 	regcache_cache_only(cs35l34->regmap, true);
 	regcache_mark_dirty(cs35l34->regmap);
 


