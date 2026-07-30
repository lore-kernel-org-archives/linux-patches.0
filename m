Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5955B37F011;
	Thu, 30 Jul 2026 15:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425696; cv=none; b=AzcWrvgtvy9bs6FRqJWM8Tlh7zoywQG5DZTYVbgmuF4nKWShVK4RMW+oLlFQT+BP+Y1TDokpzcZari3cL/Rccr/9+bbxGSUAIKA5rcingXUB5Xxhm31Id7h56NsZTTal2FZUhIOHm/I292uDhoy/okfgugcE32PGWaqHxD1A/qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425696; c=relaxed/simple;
	bh=Wd7rEFC4B1dLQ3G+cPQS8jhR9ufJo61qHFTdTYBRa6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmonHZfGEAfoEmGovZDnON3AMYlVyKtF7MJ8YSPZW2CfvogJr8YZpAI5btphkC6KJrGrT+XEDu52sTfmuPGJx/tyyH2UYqzMNNhOfGx4DmSmBBGkeoHNcgnoCPjBsYWL6Ih7nUxazP1y2Dwtp7WvlZ//yoSg5hzWpChHg9hq3cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABQG16T+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABQG16T+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB8E1F000E9;
	Thu, 30 Jul 2026 15:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425695;
	bh=PvR6sL1kXUF32cu2A13dKBPYo6Py+504TZ8USzAMfkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ABQG16T+pOS3c9GpnEaAjkWfFSy+nG+d3QS4+CXfj3FqFVS50NFdSQjfINjVNcwxm
	 sr5syOfK3Y0TOAHGMsmdAS3uHKpJEpg75nTx7YXDdfehvkBzbDxpQNfNGKwDsA1Hou
	 qUMPsvf0d2kti9g7LztjqlAIuVTaj/reWs1DchoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Salman S. Tahir" <salman.abusaad@gmail.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/602] ASoC: cs35l56: Fix potential probe() deadlock
Date: Thu, 30 Jul 2026 16:09:11 +0200
Message-ID: <20260730141439.314021498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 93c2a8ea2454b7b14eb378a58cad8a83c0ffc903 ]

On I2C/SPI call cs35l56_init() before calling
snd_soc_register_component() to prevent the potential for a deadlock
on init_completion.

For most buses all the hardware would be ready when probe() returns,
but on SoundWire, probe() must return before the SoundWire bus driver
will enumerate the device. All access to the registers must be deferred
until the driver receives an ATTACHED notification. But anything that
could return -EPROBE_DEFER must be called during probe, and that includes
snd_soc_register_component(). Because of that, on SoundWire the ASoC
component can be created before the registers are accssible, so
cs35l56_component_probe() waits for init_completion to signal that the
registers are accessible.

On I2C/SPI this 2-stage startup isn't required so their probe()
functions simply called cs35l56_common_probe() and then cs35l56_init().
The problem with this was that snd_soc_register_component() was still
called early. If this triggered ASoC to create the card, ASoC would call
cs35l56_component_probe() which waits on init_completion - but this would
be running inside the cs35l56 driver probe() so blocking it from reaching
the code that signals init_completion, causing a deadlock.

Fixes: e496112529006 ("ASoC: cs35l56: Add driver for Cirrus Logic CS35L56")
Reported-by: Salman S. Tahir <salman.abusaad@gmail.com>
Closes: https://lore.kernel.org/linux-sound/95c21574-97d5-4311-9263-9e174d22d22c@opensource.cirrus.com/T/#u
Tested-by: Salman S. Tahir <salman.abusaad@gmail.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260716132045.1469156-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-i2c.c |  4 +---
 sound/soc/codecs/cs35l56-spi.c |  4 +---
 sound/soc/codecs/cs35l56.c     | 15 +++++++++++++++
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/cs35l56-i2c.c b/sound/soc/codecs/cs35l56-i2c.c
index 2bd2ff75cd5047..93ee9e60ba79c9 100644
--- a/sound/soc/codecs/cs35l56-i2c.c
+++ b/sound/soc/codecs/cs35l56-i2c.c
@@ -40,9 +40,7 @@ static int cs35l56_i2c_probe(struct i2c_client *client)
 	if (ret != 0)
 		return ret;
 
-	ret = cs35l56_init(cs35l56);
-	if (ret == 0)
-		ret = cs35l56_irq_request(&cs35l56->base, client->irq);
+	ret = cs35l56_irq_request(&cs35l56->base, client->irq);
 	if (ret < 0)
 		cs35l56_remove(cs35l56);
 
diff --git a/sound/soc/codecs/cs35l56-spi.c b/sound/soc/codecs/cs35l56-spi.c
index 568f554a8638bf..a5bae05d6433e9 100644
--- a/sound/soc/codecs/cs35l56-spi.c
+++ b/sound/soc/codecs/cs35l56-spi.c
@@ -41,9 +41,7 @@ static int cs35l56_spi_probe(struct spi_device *spi)
 	if (ret != 0)
 		return ret;
 
-	ret = cs35l56_init(cs35l56);
-	if (ret == 0)
-		ret = cs35l56_irq_request(&cs35l56->base, spi->irq);
+	ret = cs35l56_irq_request(&cs35l56->base, spi->irq);
 	if (ret < 0)
 		cs35l56_remove(cs35l56);
 
diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index ee5357ac0ceab5..b657a0df1ed166 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1330,6 +1330,16 @@ int cs35l56_common_probe(struct cs35l56_private *cs35l56)
 		goto err;
 	}
 
+	/*
+	 * On SoundWire the cs35l56_init() cannot be run until after the
+	 * device has been enumerated by the SoundWire core.
+	 */
+	if (!cs35l56->sdw_peripheral) {
+		ret = cs35l56_init(cs35l56);
+		if (ret)
+			goto err_remove_wm_adsp;
+	}
+
 	ret = snd_soc_register_component(cs35l56->base.dev,
 					 &soc_component_dev_cs35l56,
 					 cs35l56_dai, ARRAY_SIZE(cs35l56_dai));
@@ -1344,6 +1354,11 @@ int cs35l56_common_probe(struct cs35l56_private *cs35l56)
 	wm_adsp2_remove(&cs35l56->dsp);
 
 err:
+	if (pm_runtime_enabled(cs35l56->base.dev)) {
+		pm_runtime_dont_use_autosuspend(cs35l56->base.dev);
+		pm_runtime_disable(cs35l56->base.dev);
+	}
+
 	gpiod_set_value_cansleep(cs35l56->base.reset_gpio, 0);
 	regulator_bulk_disable(ARRAY_SIZE(cs35l56->supplies), cs35l56->supplies);
 
-- 
2.53.0



