Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625A320316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtsRBLmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BBFC433C8;
	Mon,  6 Nov 2023 13:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276589;
	bh=v89wM95YP14nzNH4XWDNDh8EtSOBM9joSOosKj4OUSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtsRBLmNWztdb6a9ORLwPdegd6eHedFMcxDvNAlBAz3vmW5TDZ/AjmvxsVL4ScaO7
	 Faou8p9/udrdkzhY2/rROd+x/nxMEuvMa4w9rWJD6Zi8+yoHeVBzcotHdyExfUL0n2
	 uH5UxJO9SoZo3+rzZxe9IyYOrnicel2iRIZHaHOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 31/88] ASoC: soc-dapm: Add helper for comparing widget name
Date: Mon,  6 Nov 2023 14:03:25 +0100
Message-ID: <20231106130306.929278086@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 76aca10ccb7c23a7b7a0d56e0bfde2c8cdddfe24 ]

Some drivers use one event callback for multiple widgets but still need
to perform a bit different actions based on actual widget.  This is done
by comparing widget name, however drivers tend to miss possible name
prefix.  Add a helper to solve common mistakes.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20231003155710.821315-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-dapm.h  |  1 +
 sound/soc/soc-component.c |  1 +
 sound/soc/soc-dapm.c      | 12 ++++++++++++
 3 files changed, 14 insertions(+)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index 87f8e1793af15..295d63437e4d8 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -423,6 +423,7 @@ void snd_soc_dapm_connect_dai_link_widgets(struct snd_soc_card *card);
 
 int snd_soc_dapm_update_dai(struct snd_pcm_substream *substream,
 			    struct snd_pcm_hw_params *params, struct snd_soc_dai *dai);
+int snd_soc_dapm_widget_name_cmp(struct snd_soc_dapm_widget *widget, const char *s);
 
 /* dapm path setup */
 int snd_soc_dapm_new_widgets(struct snd_soc_card *card);
diff --git a/sound/soc/soc-component.c b/sound/soc/soc-component.c
index 4356cc320fea0..10b5fe5a3af85 100644
--- a/sound/soc/soc-component.c
+++ b/sound/soc/soc-component.c
@@ -242,6 +242,7 @@ int snd_soc_component_notify_control(struct snd_soc_component *component,
 	char name[SNDRV_CTL_ELEM_ID_NAME_MAXLEN];
 	struct snd_kcontrol *kctl;
 
+	/* When updating, change also snd_soc_dapm_widget_name_cmp() */
 	if (component->name_prefix)
 		snprintf(name, ARRAY_SIZE(name), "%s %s", component->name_prefix, ctl);
 	else
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 3091e8160bad7..5fd32185fe63d 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2726,6 +2726,18 @@ int snd_soc_dapm_update_dai(struct snd_pcm_substream *substream,
 }
 EXPORT_SYMBOL_GPL(snd_soc_dapm_update_dai);
 
+int snd_soc_dapm_widget_name_cmp(struct snd_soc_dapm_widget *widget, const char *s)
+{
+	struct snd_soc_component *component = snd_soc_dapm_to_component(widget->dapm);
+	const char *wname = widget->name;
+
+	if (component->name_prefix)
+		wname += strlen(component->name_prefix) + 1; /* plus space */
+
+	return strcmp(wname, s);
+}
+EXPORT_SYMBOL_GPL(snd_soc_dapm_widget_name_cmp);
+
 /*
  * dapm_update_widget_flags() - Re-compute widget sink and source flags
  * @w: The widget for which to update the flags
-- 
2.42.0



