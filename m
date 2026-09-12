Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB77B2E06E4;
	Sat, 12 Sep 2026 18:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237575; cv=none; b=TJ2qCEkAKra6rpV5UX/rM3D475B53A/bkj/vgi37kiv1VZeW8nJkh7eHfvnhWvSUqrJZz6mpZ+KVd/zJt/BgnQSQnYsu1MEssv0WO3UGPa5mqQ/NMb3wTOutCQLRC6hMux21LxHOheX9btgJtqFEd6MU4IdCJ49Cf9hXjZjOlf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237575; c=relaxed/simple;
	bh=YVo8V+PSxlABidjDYXF9kDa56VK7r95rBgvfYHdVVVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4r0jUcevE0ooAqTEAMH1qyioHDH9NUdkbt6poFB0Tvl7RODLN7YmaVvW8+fkVV+YX9YTSHMkAFv6uckzIbnAlBd8ZVOFmSflzfAwm7m8CsR3ZXQrGFS1dKRaINmpd+I227YvAvELWAFPdabvNyDjgeNqRBWJwMsgKu26qo1csg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxeXf/Yz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxeXf/Yz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA90F1F000FF;
	Sat, 12 Sep 2026 18:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237574;
	bh=Dze3351By4boBcEvTk1sRCnk80Xk+BhTwhSSIi8Y3X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxeXf/Yz2ET8pTkH/9U2+nACzRWYkNUmB57Vldkjz0m3djbbUTFk+W6MVss7PV3T9
	 GdMiozXna8u0bnXN2GCp+dcbgRtQbcC5XEzPwDV6v1IajqrrsafF1I5OsxcTMEsIr/
	 5CYhJOFIBUVPb/8ugcbpUzfa1HFVPn2TaGak7EPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 286/935] ASoC: cs35l33: drain threaded IRQ before runtime suspend
Date: Sat, 12 Sep 2026 08:55:16 +0200
Message-ID: <20260912065533.376332047@linuxfoundation.org>
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
@@ -884,6 +885,9 @@ static int __maybe_unused cs35l33_runtim
 		goto err;
 	}
 
+	if (cs35l33->irq_requested)
+		enable_irq(to_i2c_client(dev)->irq);
+
 	return 0;
 
 err:
@@ -903,6 +907,10 @@ static int __maybe_unused cs35l33_runtim
 	/* redo the calibration in next power up */
 	cs35l33->amp_cal = false;
 
+	/* Drain and block the threaded IRQ before cache_only/power-off. */
+	if (cs35l33->irq_requested)
+		disable_irq(to_i2c_client(dev)->irq);
+
 	regcache_cache_only(cs35l33->regmap, true);
 	regcache_mark_dirty(cs35l33->regmap);
 	regulator_bulk_disable(cs35l33->num_core_supplies,
@@ -1160,10 +1168,12 @@ static int cs35l33_i2c_probe(struct i2c_
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


