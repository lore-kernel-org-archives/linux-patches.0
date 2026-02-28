Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E380338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301744; cv=none; b=JlZ4HAhZZAAFb9b7vTJ0cmU6FgK7jhi57gTbuBgnf3NGTHzu6GnfoNSZhaR/rZJ+Q8XSAlUMvyu3LDBwSlUmEp3tgIsb2Dtw8B9sbuj9nZ5pMsya6r2EHayvAh8ozk9iISNkCv+EPRr6nsJ+ZAc9mVO81qnN6ERNZrBgN5QioRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301744; c=relaxed/simple;
	bh=h+mM97cfDccCuR44AYk159HKuSwZk9NQMnjgOzQj13g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCSAc/SmzHsmkos74Ovj9yBg03LTuQAqqBh+BI+GI+zWkYRglIyXKcrEQG9gkrK2PwJ2DGf11Ecmgqswvt1FoqiCx0RZxyw7eW+OFiMr/n40o8DUTc/issYpJfLKeP1Nk6ubtx4ySL8QZS/0OGVMQ0jh19wvpX/PKdY7Re/DO60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rjjs9vkP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rjjs9vkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848C5C19423;
	Sat, 28 Feb 2026 18:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301744;
	bh=h+mM97cfDccCuR44AYk159HKuSwZk9NQMnjgOzQj13g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rjjs9vkPt/Io2/1CkHn5QIUq5DolvFKSZV7EidoIA5/uWlOFRkfHC1A9N8/XxRhZx
	 h5t+matfcnK5jOScHQu4x/CPhmNFOKv7yJn8RIpCzR9mhFBxuFngCe8tJBxL7MSgbk
	 E8G4ESAsGISvVJ8vzPpYt7F2ufzFOg1FQlRvQkO4ec980XNGypFgGoqYda3WZ8P11F
	 DCLeP+kntr7N56XLGIM8n7kPGiIML70pLHTlcbRDam4CciVTlrVXoEGEHN07uXH800
	 ls1otz29w/PApytr7vcJjmNKJHf/pwEYC60vT0ai/qgLN6tHfw6EF3QO0IindiS6gL
	 +dcdUU3Ht+2gg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/385] ASoC: nau8821: Fixup nau8821_enable_jack_detect()
Date: Sat, 28 Feb 2026 12:56:08 -0500
Message-ID: <20260228180011.1568201-146-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 70237853edf0a69773a7370eb74ea2a44dfe3050 ]

The nau8821_enable_jack_detect() function was supposed to allow enabling
or disabling jack events reporting.  However, once enabled, any
subsequent invocation would fail and the following splat is shown:

[ 3136.996771] Hardware name: Valve Jupiter/Jupiter, BIOS F7A0131 01/30/2024
[ 3136.996773] Workqueue: events_unbound deferred_probe_work_func
[ 3136.996780] Call Trace:
[ 3136.996782]  <TASK>
[ 3136.996787]  dump_stack_lvl+0x6e/0xa0
[ 3136.996796]  __setup_irq.cold+0x9c/0xce
[ 3136.996803]  ? __pfx_irq_default_primary_handler+0x10/0x10
[ 3136.996812]  ? __pfx_nau8821_interrupt+0x10/0x10 [snd_soc_nau8821]
[ 3136.996825]  request_threaded_irq+0xd9/0x160
[ 3136.996853]  devm_request_threaded_irq+0x71/0xd0
[ 3136.996859]  ? __pfx_nau8821_interrupt+0x10/0x10 [snd_soc_nau8821]
[ 3136.996882]  nau8821_enable_jack_detect+0xa5/0xc0 [snd_soc_nau8821]
[ 3136.996901]  acp5x_8821_init+0x8d/0xa0 [snd_soc_acp5x_mach]
[ 3136.996917]  snd_soc_link_init+0x25/0x50 [snd_soc_core]
[ 3136.996958]  snd_soc_bind_card+0x615/0xd00 [snd_soc_core]
[ 3136.997026]  snd_soc_register_card+0x1b2/0x1c0 [snd_soc_core]
[ 3136.997064]  devm_snd_soc_register_card+0x47/0x90 [snd_soc_core]
[ 3136.997108]  acp5x_probe+0x72/0xb0 [snd_soc_acp5x_mach]
[...]
[ 3136.997508] nau8821 i2c-NVTN2020:00: Cannot request irq 58 (-16)

Introduce jdet_active flag to driver data structure and use it to
provide one-time initialization of the jack detection work queue and
related interrupt line.

Note this is also a prerequisite for additional fixes around module
unloading and suspend handling.

Fixes: aab1ad11d69f ("ASoC: nau8821: new driver")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20251231-nau8821-cleanup-v1-1-6b0b76cbbb64@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8821.c | 5 +++++
 sound/soc/codecs/nau8821.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index 9d006c4b6f284..2d040722ab881 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1662,8 +1662,13 @@ int nau8821_enable_jack_detect(struct snd_soc_component *component,
 	int ret;
 
 	nau8821->jack = jack;
+
+	if (nau8821->jdet_active)
+		return 0;
+
 	/* Initiate jack detection work queue */
 	INIT_DELAYED_WORK(&nau8821->jdet_work, nau8821_jdet_work);
+	nau8821->jdet_active = true;
 
 	ret = devm_request_threaded_irq(nau8821->dev, nau8821->irq, NULL,
 		nau8821_interrupt, IRQF_TRIGGER_LOW | IRQF_ONESHOT,
diff --git a/sound/soc/codecs/nau8821.h b/sound/soc/codecs/nau8821.h
index 88602923780d8..f9d7cd8cbd211 100644
--- a/sound/soc/codecs/nau8821.h
+++ b/sound/soc/codecs/nau8821.h
@@ -562,6 +562,7 @@ struct nau8821 {
 	struct snd_soc_dapm_context *dapm;
 	struct snd_soc_jack *jack;
 	struct delayed_work jdet_work;
+	bool jdet_active;
 	int irq;
 	int clk_id;
 	int micbias_voltage;
-- 
2.51.0

