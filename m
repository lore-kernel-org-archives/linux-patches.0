Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72567224239;
	Tue,  8 Apr 2025 12:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115062; cv=none; b=jrMQh+4+9Deh7ZitIDkw/Ng2GmUGrOpNWcpg13f6SCmrA+82OgFbAdt5inl6GgluywXSRH6q4+o+Ahw+O4w5mIxmZF1fNJ9ypQtrjItehSn2GBlPzKj04JnCaDLZerNDr/2eEL/kYI4SwuxitlmBCOcg4xK9g3OpGCEo5rYdhJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115062; c=relaxed/simple;
	bh=hTCuRrsovgbl/JyCGcrAHzVcBxQASZCpVLX/eTq7SWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7G+Jt6EP3vbFd2WgRurwsJUNpy8Ozu3zmPYrKMBfX9i28CldblR6dNDR2DAd2OHV93IQk92Lxhw04EV68QsfIknNqVTrIz2pdVb83GPwQr5ngeucG5sS1jen/4E6QJhzPY9vVQR0b/jyQY7aaORVXZEG5RczOsF4YQ4VuiKrRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzBf2Kvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzBf2Kvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA897C4CEE5;
	Tue,  8 Apr 2025 12:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115062;
	bh=hTCuRrsovgbl/JyCGcrAHzVcBxQASZCpVLX/eTq7SWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzBf2Kvw1guxJgRYb1G12uvmOPKyfsfed3iGQ8rplvOU1DWnvsj8puj4VP0Gl7+zf
	 6ap/+BxEywNLhh4pbCaCJuvKS1cfZUS+M3Dro3DbZt53w412VwEqdaXKQFaghXOqfn
	 d3pgeyxPjDkLNlPcaUZGpWmXv8DoedkxwXsLQC0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 333/499] ASoC: cs42l43: Add jack delay debounce after suspend
Date: Tue,  8 Apr 2025 12:49:05 +0200
Message-ID: <20250408104859.529448003@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit 164b7dd4546b57c08b373e9e3cf315ff98cb032d ]

Hardware reports jack absent after reset/suspension regardless of jack
state, so introduce an additional delay only in suspension case to allow
proper detection to take place after a short delay.

Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250304140504.139245-1-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43-jack.c | 13 ++++++++++---
 sound/soc/codecs/cs42l43.c      | 15 ++++++++++++++-
 sound/soc/codecs/cs42l43.h      |  3 +++
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/cs42l43-jack.c b/sound/soc/codecs/cs42l43-jack.c
index d9ab003e166bf..ac19a572fe70c 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -167,7 +167,7 @@ int cs42l43_set_jack(struct snd_soc_component *component,
 		autocontrol |= 0x3 << CS42L43_JACKDET_MODE_SHIFT;
 
 	ret = cs42l43_find_index(priv, "cirrus,tip-fall-db-ms", 500,
-				 NULL, cs42l43_accdet_db_ms,
+				 &priv->tip_fall_db_ms, cs42l43_accdet_db_ms,
 				 ARRAY_SIZE(cs42l43_accdet_db_ms));
 	if (ret < 0)
 		goto error;
@@ -175,7 +175,7 @@ int cs42l43_set_jack(struct snd_soc_component *component,
 	tip_deb |= ret << CS42L43_TIPSENSE_FALLING_DB_TIME_SHIFT;
 
 	ret = cs42l43_find_index(priv, "cirrus,tip-rise-db-ms", 500,
-				 NULL, cs42l43_accdet_db_ms,
+				 &priv->tip_rise_db_ms, cs42l43_accdet_db_ms,
 				 ARRAY_SIZE(cs42l43_accdet_db_ms));
 	if (ret < 0)
 		goto error;
@@ -764,6 +764,8 @@ void cs42l43_tip_sense_work(struct work_struct *work)
 error:
 	mutex_unlock(&priv->jack_lock);
 
+	priv->suspend_jack_debounce = false;
+
 	pm_runtime_mark_last_busy(priv->dev);
 	pm_runtime_put_autosuspend(priv->dev);
 }
@@ -771,14 +773,19 @@ void cs42l43_tip_sense_work(struct work_struct *work)
 irqreturn_t cs42l43_tip_sense(int irq, void *data)
 {
 	struct cs42l43_codec *priv = data;
+	unsigned int db_delay = priv->tip_debounce_ms;
 
 	cancel_delayed_work(&priv->bias_sense_timeout);
 	cancel_delayed_work(&priv->tip_sense_work);
 	cancel_delayed_work(&priv->button_press_work);
 	cancel_work(&priv->button_release_work);
 
+	// Ensure delay after suspend is long enough to avoid false detection
+	if (priv->suspend_jack_debounce)
+		db_delay += priv->tip_fall_db_ms + priv->tip_rise_db_ms;
+
 	queue_delayed_work(system_long_wq, &priv->tip_sense_work,
-			   msecs_to_jiffies(priv->tip_debounce_ms));
+			   msecs_to_jiffies(db_delay));
 
 	return IRQ_HANDLED;
 }
diff --git a/sound/soc/codecs/cs42l43.c b/sound/soc/codecs/cs42l43.c
index b1969536862ba..695192d4accfa 100644
--- a/sound/soc/codecs/cs42l43.c
+++ b/sound/soc/codecs/cs42l43.c
@@ -2402,9 +2402,22 @@ static int cs42l43_codec_runtime_resume(struct device *dev)
 	return 0;
 }
 
+static int cs42l43_codec_runtime_force_suspend(struct device *dev)
+{
+	struct cs42l43_codec *priv = dev_get_drvdata(dev);
+
+	dev_dbg(priv->dev, "Runtime suspend\n");
+
+	priv->suspend_jack_debounce = true;
+
+	pm_runtime_force_suspend(dev);
+
+	return 0;
+}
+
 static const struct dev_pm_ops cs42l43_codec_pm_ops = {
 	RUNTIME_PM_OPS(NULL, cs42l43_codec_runtime_resume, NULL)
-	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(cs42l43_codec_runtime_force_suspend, pm_runtime_force_resume)
 };
 
 static const struct platform_device_id cs42l43_codec_id_table[] = {
diff --git a/sound/soc/codecs/cs42l43.h b/sound/soc/codecs/cs42l43.h
index 9c144e129535f..1cd9d8a71c439 100644
--- a/sound/soc/codecs/cs42l43.h
+++ b/sound/soc/codecs/cs42l43.h
@@ -78,6 +78,8 @@ struct cs42l43_codec {
 
 	bool use_ring_sense;
 	unsigned int tip_debounce_ms;
+	unsigned int tip_fall_db_ms;
+	unsigned int tip_rise_db_ms;
 	unsigned int bias_low;
 	unsigned int bias_sense_ua;
 	unsigned int bias_ramp_ms;
@@ -95,6 +97,7 @@ struct cs42l43_codec {
 	bool button_detect_running;
 	bool jack_present;
 	int jack_override;
+	bool suspend_jack_debounce;
 
 	struct work_struct hp_ilimit_work;
 	struct delayed_work hp_ilimit_clear_work;
-- 
2.39.5



