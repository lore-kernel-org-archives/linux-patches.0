Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4281E12A173;
	Tue, 23 Jan 2024 00:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968757; cv=none; b=eXtoJHGCZ5DMfGt8BjvAza4yfmmeCL6u/LUA7JbwnvdKz13c176a0QQ5VHmV7Xkkr1XXDWcef2QdKn1e6Cj4lRfQzHSotPcGIGYS5IDS7i+H1FCogwG9bBZLP3PYvw8O2QHJ/JdnH78JC+Sj0j/pIO+89XFKqgZ4QQ4T95iGaME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968757; c=relaxed/simple;
	bh=/NLOKNCpRZLG7PjXpLjPfAM4j8cwu0u6g+YSK4vhG7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+CSp+SrPZIkITZbMqoXaJYhZeRkjtuEvws0aal/c7zxeXONqE8+wEdNZ8klQdZpG+Ua2JnkB2/n4ATVi4r3Jdb8n26+3/nqJ8J1zh1yts/e64J3kkMw3WtEeOiOV1cnUi+8Wiy7fS2/XFFnGfhGMAvsc637cjkuSRK/M1/QwqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+V+pekm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+V+pekm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9381C433F1;
	Tue, 23 Jan 2024 00:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968757;
	bh=/NLOKNCpRZLG7PjXpLjPfAM4j8cwu0u6g+YSK4vhG7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+V+pekmxyEUB1spdsF053sjz8Yr7px9BNh/sq5peckHMWNWcj2c93s6X6pypwupm
	 iOdit2ZcQ7XX0Ln/Tjg+6PKSrV2KSkgqyOBxEy11hX/dOhiDFAf+UHL3zW9t+RZS3M
	 7lGnZVy9MoYVn+QG2h6pQIklyOK861S8Wr3oeJ8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/194] ASoC: rt5650: add mutex to avoid the jack detection failure
Date: Mon, 22 Jan 2024 15:55:39 -0800
Message-ID: <20240122235719.594417409@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9fda0e5548dc..c9512e97c12e 100644
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
 		if (snd_soc_component_read32(rt5645->component, RT5645_INT_IRQ_ST) & 0x4) {
@@ -3339,6 +3344,8 @@ static void rt5645_jack_detect_work(struct work_struct *work)
 		rt5645_jack_detect(rt5645->component, 0);
 	}
 
+	mutex_unlock(&rt5645->jd_mutex);
+
 	snd_soc_jack_report(rt5645->hp_jack, report, SND_JACK_HEADPHONE);
 	snd_soc_jack_report(rt5645->mic_jack, report, SND_JACK_MICROPHONE);
 	if (rt5645->en_button_func)
@@ -4041,6 +4048,7 @@ static int rt5645_i2c_probe(struct i2c_client *i2c,
 	}
 	timer_setup(&rt5645->btn_check_timer, rt5645_btn_check_callback, 0);
 
+	mutex_init(&rt5645->jd_mutex);
 	INIT_DELAYED_WORK(&rt5645->jack_detect_work, rt5645_jack_detect_work);
 	INIT_DELAYED_WORK(&rt5645->rcclock_work, rt5645_rcclock_work);
 
-- 
2.43.0



