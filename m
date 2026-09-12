Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37FA35C1BD;
	Sat, 12 Sep 2026 18:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237581; cv=none; b=Yc+HgoAoauZTYtqHXmxzmxdHfsWrn/gxFGRmv4bMoVV1zszqmZq2fz6enTEFkoV3SAWJa7oNfzz+DERv9LlUBFXPFPTI4XXE1bpjO8ZEEvwHDiScPBeQrMwQR4Rji2w8b396+pqocGUJZP8uNV48Mxbbw7lPlIpovZrXv2RowYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237581; c=relaxed/simple;
	bh=jGMSFGmbXR3+B+t/d+Z6PIwdbdL4mPY0cWUev2yvZaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bd3RPGS7hGW7HBl74kOqg4xYNNrQBGRAPPMAIOYxMVk9DjWLc8pMvT0Jzto+gSpraU6inUK1wpUpn2jJb8BE0lfHfAu3+5K3p4dM0obbRPUUO8ghnxNJnfb/O+FVALeJaAg4yyaU7VMdVzjjZFnlpFfXSF07/Zt0I7UhY3lqkqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayUgqFgX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayUgqFgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C901F000FF;
	Sat, 12 Sep 2026 18:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237579;
	bh=0im8rz+IpuyLMvo2p1l6xWNNkOZLTi85rRXMBdTUiXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ayUgqFgXfHhTNCXQ9Ie4o0pAIdVucO9bDl6Vnhu6x7TaD9s2qyAY7jZ5zxKl1Z8qJ
	 HGvqEEx8FvxrIgJZXpKe14Fkv1Wa/hKhsZFP/awmUEanFStrCVzj3n5Gs4nl4sjpHS
	 3fk3ILIj/tnFvUzWqdlpeDraGw1woq+lEV5l5p3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 287/935] ASoC: cs35l34: drain threaded IRQ before runtime suspend
Date: Sat, 12 Sep 2026 08:55:17 +0200
Message-ID: <20260912065533.398100111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -1055,10 +1056,12 @@ static int cs35l34_i2c_probe(struct i2c_
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
@@ -1165,6 +1168,9 @@ static int __maybe_unused cs35l34_runtim
 		dev_err(dev, "Failed to restore register cache\n");
 		goto err;
 	}
+
+	if (cs35l34->irq_requested)
+		enable_irq(to_i2c_client(dev)->irq);
 	return 0;
 err:
 	regcache_cache_only(cs35l34->regmap, true);
@@ -1178,6 +1184,10 @@ static int __maybe_unused cs35l34_runtim
 {
 	struct cs35l34_private *cs35l34 = dev_get_drvdata(dev);
 
+	/* Drain and block the threaded IRQ before cache_only/power-off. */
+	if (cs35l34->irq_requested)
+		disable_irq(to_i2c_client(dev)->irq);
+
 	regcache_cache_only(cs35l34->regmap, true);
 	regcache_mark_dirty(cs35l34->regmap);
 


