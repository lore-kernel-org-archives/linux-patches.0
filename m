Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DFB14831A;
	Tue, 23 Jan 2024 01:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972071; cv=none; b=SO+rTnV1AnFvuHg35iSQm33J69BszPxVw1r6Nz2rZndQNYkfK6rijBE6cXLgUw1P38vj7bicg2E5jKMBO/TGUcyXvc6r0tmJY4k1IiAQuZABng7Q3FQos776qx4UnXL1xAQ0ieqjDL4P/FMu8n+DWyzNXM48x8JDVZASBsSkfSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972071; c=relaxed/simple;
	bh=IObwU+qYjcE/zi0uyhkTgNkfq53cReeNbtiNJ5aq0/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAFV3ECwmHJPqQaPzwT2jXu59bnnxFmpaBwNJ2u+JjvE6PuFRJktuprU/HAmPY1J6upm2zh3pZGKLGnJCPgP4M6oepMoqok+S4y9g16pZMq6WVMBnD8Nyl9ytk0VvsJzoxZQ6IXwfp6FOUW0ATm8jnLzYtpWnh1h6/ktnA1MYlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cex5Oo7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cex5Oo7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1ABC43390;
	Tue, 23 Jan 2024 01:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972071;
	bh=IObwU+qYjcE/zi0uyhkTgNkfq53cReeNbtiNJ5aq0/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cex5Oo7ZRC224st1EO0UDWAOIJecpG94/Qgx8z/lF3PR+EFFtHC5A04owl3G1AhK2
	 PZd0w90c0YxsQXVqonB/Xx6roQ++iT9JdNmiLUVgjdbCc9U6W/NchpPJdtnT94UsKb
	 z/miXkQmw0if+LHR360BQ4maRWjWCE2BBYYhILFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/374] ASoC: rt5650: add mutex to avoid the jack detection failure
Date: Mon, 22 Jan 2024 15:54:31 -0800
Message-ID: <20240122235745.157886775@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 385f2cca939a..e7009f704b99 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -448,6 +448,7 @@ struct rt5645_priv {
 	struct regulator_bulk_data supplies[ARRAY_SIZE(rt5645_supply_names)];
 	struct rt5645_eq_param_s *eq_param;
 	struct timer_list btn_check_timer;
+	struct mutex jd_mutex;
 
 	int codec_type;
 	int sysclk;
@@ -3189,6 +3190,8 @@ static int rt5645_jack_detect(struct snd_soc_component *component, int jack_inse
 				rt5645_enable_push_button_irq(component, true);
 			}
 		} else {
+			if (rt5645->en_button_func)
+				rt5645_enable_push_button_irq(component, false);
 			snd_soc_dapm_disable_pin(dapm, "Mic Det Power");
 			snd_soc_dapm_sync(dapm);
 			rt5645->jack_type = SND_JACK_HEADPHONE;
@@ -3269,6 +3272,8 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 	if (!rt5645->component)
 		return;
 
+	mutex_lock(&rt5645->jd_mutex);
+
 	switch (rt5645->pdata.jd_mode) {
 	case 0: /* Not using rt5645 JD */
 		if (rt5645->gpiod_hp_det) {
@@ -3295,7 +3300,7 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 
 	if (!val && (rt5645->jack_type == 0)) { /* jack in */
 		report = rt5645_jack_detect(rt5645->component, 1);
-	} else if (!val && rt5645->jack_type != 0) {
+	} else if (!val && rt5645->jack_type == SND_JACK_HEADSET) {
 		/* for push button and jack out */
 		btn_type = 0;
 		if (snd_soc_component_read(rt5645->component, RT5645_INT_IRQ_ST) & 0x4) {
@@ -3351,6 +3356,8 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 		rt5645_jack_detect(rt5645->component, 0);
 	}
 
+	mutex_unlock(&rt5645->jd_mutex);
+
 	snd_soc_jack_report(rt5645->hp_jack, report, SND_JACK_HEADPHONE);
 	snd_soc_jack_report(rt5645->mic_jack, report, SND_JACK_MICROPHONE);
 	if (rt5645->en_button_func)
@@ -4121,6 +4128,7 @@ static int rt5645_i2c_probe(struct i2c_client *i2c,
 	}
 	timer_setup(&rt5645->btn_check_timer, rt5645_btn_check_callback, 0);
 
+	mutex_init(&rt5645->jd_mutex);
 	INIT_DELAYED_WORK(&rt5645->jack_detect_work, rt5645_jack_detect_work);
 	INIT_DELAYED_WORK(&rt5645->rcclock_work, rt5645_rcclock_work);
 
-- 
2.43.0



