Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3B51657C7;
	Tue, 23 Jan 2024 00:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970774; cv=none; b=QsbUSJUS0Lwnky9raiPNCkkYdu/T+pQEOyL/9V+jAfPJanuL4b1dJZCLAV9Bjw39EmWxyhzA/L/mZ7HG5A0jHQ7Ys298KNYE3ME0tzJTRSgCVGURwZf/htEDI+032z5ozWbg9uA3nNgOxTUICCPXCWAstaEM7GqZX1MZWT8XYb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970774; c=relaxed/simple;
	bh=q0DrzLrSjByjmjnvJ/qogv7HdnU1IF2sWNM+yp0IvIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sm5bZJMAUCAlJdD9E/CyB04Spz6SLWtEpr0vUorjQJEIbYl7VeWgHvy1bh41q6W/+/BNy/RQvuxMrU6VMjyuqtLwPe8WwpxM/41ldMAjBCa+lmeRTzHSmVhhRQ9ANBW6YEIMc/5/o4YgfkT3xioPKOxGbolYzxA2iHQxFJiuhiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9dAJ+xE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9dAJ+xE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75DFC433C7;
	Tue, 23 Jan 2024 00:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970774;
	bh=q0DrzLrSjByjmjnvJ/qogv7HdnU1IF2sWNM+yp0IvIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9dAJ+xEmx/5DoToa+8Re8zCM+0jkrGh9HRqaJU2NiIFsf0RU/tOC19KRHKGXN8UK
	 tyrQczfoP5TXlNgg6oEFqdyuzyH1OYcuIR1cLMuSejR+BJwT1udq76/e38HAfPppwX
	 lmgiCTVcfNQYx3CbI7V5dnrewWhXof7/97qgBI+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/286] ASoC: rt5650: add mutex to avoid the jack detection failure
Date: Mon, 22 Jan 2024 15:55:20 -0800
Message-ID: <20240122235732.573121185@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit cdba4301adda7c60a2064bf808e48fccd352aaa9 ]

This patch adds the jd_mutex to protect the jack detection control flow.
And only the headset type could check the button status.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://lore.kernel.org/r/20231122100123.2831753-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5645.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index 99d91bfb8812..7dc80183921e 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -421,6 +421,7 @@ struct rt5645_priv {
 	struct regulator_bulk_data supplies[ARRAY_SIZE(rt5645_supply_names)];
 	struct rt5645_eq_param_s *eq_param;
 	struct timer_list btn_check_timer;
+	struct mutex jd_mutex;
 
 	int codec_type;
 	int sysclk;
@@ -3179,6 +3180,8 @@ static int rt5645_jack_detect(struct snd_soc_component *component, int jack_inse
 				rt5645_enable_push_button_irq(component, true);
 			}
 		} else {
+			if (rt5645->en_button_func)
+				rt5645_enable_push_button_irq(component, false);
 			snd_soc_dapm_disable_pin(dapm, "Mic Det Power");
 			snd_soc_dapm_sync(dapm);
 			rt5645->jack_type = SND_JACK_HEADPHONE;
@@ -3259,6 +3262,8 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 	if (!rt5645->component)
 		return;
 
+	mutex_lock(&rt5645->jd_mutex);
+
 	switch (rt5645->pdata.jd_mode) {
 	case 0: /* Not using rt5645 JD */
 		if (rt5645->gpiod_hp_det) {
@@ -3283,7 +3288,7 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 
 	if (!val && (rt5645->jack_type == 0)) { /* jack in */
 		report = rt5645_jack_detect(rt5645->component, 1);
-	} else if (!val && rt5645->jack_type != 0) {
+	} else if (!val && rt5645->jack_type == SND_JACK_HEADSET) {
 		/* for push button and jack out */
 		btn_type = 0;
 		if (snd_soc_component_read(rt5645->component, RT5645_INT_IRQ_ST) & 0x4) {
@@ -3339,6 +3344,8 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 		rt5645_jack_detect(rt5645->component, 0);
 	}
 
+	mutex_unlock(&rt5645->jd_mutex);
+
 	snd_soc_jack_report(rt5645->hp_jack, report, SND_JACK_HEADPHONE);
 	snd_soc_jack_report(rt5645->mic_jack, report, SND_JACK_MICROPHONE);
 	if (rt5645->en_button_func)
@@ -4062,6 +4069,7 @@ static int rt5645_i2c_probe(struct i2c_client *i2c,
 	}
 	timer_setup(&rt5645->btn_check_timer, rt5645_btn_check_callback, 0);
 
+	mutex_init(&rt5645->jd_mutex);
 	INIT_DELAYED_WORK(&rt5645->jack_detect_work, rt5645_jack_detect_work);
 	INIT_DELAYED_WORK(&rt5645->rcclock_work, rt5645_rcclock_work);
 
-- 
2.43.0



