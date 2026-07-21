Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AD82DC76A;
	Tue, 21 Jul 2026 16:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649626; cv=none; b=GHLIMxjyB56HXJqXoYtHt2h92ovf5pD+FWZB3aPSISWNWwOkzqxDq9uN8avK0oFtAdgR/dujqKyD5jjQ39lnzzdsA4fX9tVoGOdyhzpyOHLvC2XFnYeysH52Apt81kaYTy6CRRG7ITyulZiIHH595Daq0QpsKPchGSOVBGslVAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649626; c=relaxed/simple;
	bh=mGafDrVEKjcbyXxYdbjqBvE85G+7mjY9GuolC7ZjnmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgefo6em3zNnXMLA3ukiWYLZYwSJr9cw4lCdeUmu6uINHHS4FLp7GxOZpXPSEVVtaYvMkUEIJxME4cOM49NvXtTMoTiQ640DNeUo3GVYr3/Nh2bbcVZE6XW67DqxhukKi8HGzW+Tka8uFlrt2dTIxFqaF1KgIOvaGq8gkbIsRJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+wj7Zhx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+wj7Zhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241141F000E9;
	Tue, 21 Jul 2026 16:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649625;
	bh=E9txtRjRAj6R8GGLoYuzyexwwhJDXqto2jkpIGyYskM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+wj7ZhxVW8ZdqZkXCbUau1+4TaUrahTX3HYYxlt+CpiQ41A4Mcbtj3Vdzvx7hPVX
	 l7OV+2/Q/EpiU/acjk4QffDoMC0fxsYd3VpNtpYk92fDxsrKCpI53HS+YLvT9DyjK3
	 ZCrOpWFwfv+R8p7g0ZnW/IdXyEkbbGQI1rhFc4UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0641/2077] ASoC: cs35l56: Cleanup if component_probe fails
Date: Tue, 21 Jul 2026 17:05:14 +0200
Message-ID: <20260721152607.926526706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit a0df7522dfb098d56b42560247082d6f5a8581dd ]

If cs35l56_component_probe() fails, call cs35l56_component_remove() to
clean up.

All the cleanup in cs35l56_component_remove() is the same cleanup that
would need to be done (at least partially) if cs35l56_component_probe()
fails. So calling cs35l56_component_remove() avoids convoluted cleanup
gotos and duplicated code in cs35l56_component_probe().

The only action in cs35l56_component_remove() that is nominally
dependent on having completed the component_probe() action is the call
to wm_adsp2_component_remove(). Though it is currently safe to call that
even if wm_adsp2_component_probe() was not called. However,
wm_adsp2_component_probe() has been trivially updated to check itself
whether it needs to cleanup.

Fixes: e49611252900 ("ASoC: cs35l56: Add driver for Cirrus Logic CS35L56")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260610093432.557375-4-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 13 ++++++++++++-
 sound/soc/codecs/wm_adsp.c |  7 +++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index 3ab5395f15bb25..3641ac1378c7c2 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1326,7 +1326,7 @@ VISIBLE_IF_KUNIT int cs35l56_set_fw_name(struct snd_soc_component *component)
 }
 EXPORT_SYMBOL_IF_KUNIT(cs35l56_set_fw_name);
 
-static int cs35l56_component_probe(struct snd_soc_component *component)
+static int _cs35l56_component_probe(struct snd_soc_component *component)
 {
 	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 	struct cs35l56_private *cs35l56 = snd_soc_component_get_drvdata(component);
@@ -1426,6 +1426,17 @@ static void cs35l56_component_remove(struct snd_soc_component *component)
 	cs35l56->component = NULL;
 }
 
+static int cs35l56_component_probe(struct snd_soc_component *component)
+{
+	int ret;
+
+	ret = _cs35l56_component_probe(component);
+	if (ret < 0)
+		cs35l56_component_remove(component);
+
+	return ret;
+}
+
 static int cs35l56_set_bias_level(struct snd_soc_component *component,
 				  enum snd_soc_bias_level level)
 {
diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index ca630c9948e49a..baa75e7ff53ba9 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -1170,7 +1170,14 @@ EXPORT_SYMBOL_GPL(wm_adsp2_component_probe);
 
 int wm_adsp2_component_remove(struct wm_adsp *dsp, struct snd_soc_component *component)
 {
+	if (!dsp)
+		return 0;
+
+	if (!dsp->component)
+		return 0;
+
 	cs_dsp_cleanup_debugfs(&dsp->cs_dsp);
+	dsp->component = NULL;
 
 	return 0;
 }
-- 
2.53.0



