Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA64345EA7;
	Sat, 12 Sep 2026 15:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228202; cv=none; b=juai5jxxwPixYTk0o6t93cJ2D9Uu8PbFvxVnB1FaKoI+5HvzKYpbR+DQ8xUT51debpBzSQz83yxmM2Y0bfNjoyG6etvRs+3Y9VR9iICg0jH1yRZgCPqxVnv4tOHfvwJo/VUUK46/+iDc6j/jYG6DYTbR3F9O7Fui97UwTxFVGfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228202; c=relaxed/simple;
	bh=9fd2oD+hFx8vhGlw7bb+vH8dDNN7ToEm7GFAhpTmv/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epAW7VJpIny/lyi2/qesirX+9bfozKMGDkpo1thr56SrCGdqSVcYSEHJuTdZIXiqJQJ4r8CvXKAolP9S9Q4iuBV2KzwtvGL22aLgMgfbsjOWD7YT1Px3Jqt3GQZq61kn3B9N/4bVMaQeYYJ5kqPy/A2yVY6j8N/yMUow+tYC1jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXsHtJPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXsHtJPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE541F000FF;
	Sat, 12 Sep 2026 15:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228200;
	bh=n+6s6Ef4Pte1+/tNNSzwTmxzK4a3RPGzT69jqSqMTCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XXsHtJPswNbLKoHS60+a1FsaVTdv1SSz7Ycf9z5GAyXGME25OMPsnNG/ywiilLdL2
	 vWhV0GIgr/phXx9GKj5jkb2fef9/WIYJewraSM/o6Fyb2Wov3hh1nDWNfAUfwIujM7
	 54KNAQfHEdTT4vHF3ulX1/FM3GqUEdYXnqH/fn8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 0338/1191] ASoC: cs35l34: drain threaded IRQ before runtime suspend
Date: Sat, 12 Sep 2026 08:51:06 +0200
Message-ID: <20260912065555.819080260@linuxfoundation.org>
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
 


