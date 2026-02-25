Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C261D1EB5E1;
	Wed, 25 Feb 2026 01:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983200; cv=none; b=eHsccJbHzd8GSRsKGdl3zE3Lt3T015+hW+FICwIKTwgwkWJ6876gkFokVaVDxjr7N4ZR0jShHQmLvSdWJR4DBW+wfqoJoIIZAZdtwyNCd+w19OKJ0PUOWo9fRIxW0NRKixrkDXJijn4QbtzyEQ27YEh5ueUlNonvRdRfg0pLnsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983200; c=relaxed/simple;
	bh=HEHFbLhQXSb+3HOIMRdFH7zPjQynO3ykQO9d9CNsB+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XX03nbmnfd7hjuulNq57+zkbwN5nxW6fHXgtW7tl3oHPdXDjFll0q6d3WKZLk3kJxSbcjR3tpa+GKa217nbAOOxPJyBsyQKWp0xiuPrZ7LsbEVGmtQ7VUcgSt+S6a2zKeaBqdfUZBZo2YwhY3w8XJUnMVyEvQAjkIc+aM/ofh0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0+ah6hA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0+ah6hA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D030C116D0;
	Wed, 25 Feb 2026 01:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983200;
	bh=HEHFbLhQXSb+3HOIMRdFH7zPjQynO3ykQO9d9CNsB+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0+ah6hAeYHJR3q2Z1h5UWix/iaHF45NIgDwpBW/9Px7RsYB8S4tv1ijphPngGOdO
	 sjX3rncmmuLiXqe+IGTz88il2VLuEzoX+Y6J2Na9qRjB05x67c0xgvOh733F7ah2Pz
	 o47JtzOBqwhQky/daeOZ8MTzhhDBOEZ73n2fRBGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 306/781] ASoC: SDCA: Still process most of the jack detect if control is missing
Date: Tue, 24 Feb 2026 17:16:55 -0800
Message-ID: <20260225012407.213302765@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit d7730c44b7dddbc5063505ce9e0c21d8bf298368 ]

DAPM creates its controls very late in the card creation, so
there is no call into the driver after the controls are created. This
means the jack IRQs can't be guaranteed to be registered after the ALSA
controls are available. If a jack IRQ is received before the controls
are available, currently the driver does not update the Selected Mode as
it is required by the specification to do.

If the ALSA controls are not available update the Selected Mode directly
rather than going through the ALSA control. The ALSA control should pick
up the state once it is created.

Fixes: b9ab3b618241 ("ASoC: SDCA: Add some initial IRQ handlers")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260204125944.1134011-4-ckeepax@opensource.cirrus.com
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_jack.c | 52 ++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/sound/soc/sdca/sdca_jack.c b/sound/soc/sdca/sdca_jack.c
index 5b9cf69cbcd6b..bfa621b744e1a 100644
--- a/sound/soc/sdca/sdca_jack.c
+++ b/sound/soc/sdca/sdca_jack.c
@@ -41,10 +41,11 @@ int sdca_jack_process(struct sdca_interrupt *interrupt)
 	struct jack_state *state = interrupt->priv;
 	struct snd_kcontrol *kctl = state->kctl;
 	struct snd_ctl_elem_value *ucontrol __free(kfree) = NULL;
-	struct soc_enum *soc_enum;
 	unsigned int reg, val;
 	int ret;
 
+	guard(rwsem_write)(rwsem);
+
 	if (!kctl) {
 		const char *name __free(kfree) = kasprintf(GFP_KERNEL, "%s %s",
 							   interrupt->entity->label,
@@ -54,16 +55,12 @@ int sdca_jack_process(struct sdca_interrupt *interrupt)
 			return -ENOMEM;
 
 		kctl = snd_soc_component_get_kcontrol(component, name);
-		if (!kctl) {
+		if (!kctl)
 			dev_dbg(dev, "control not found: %s\n", name);
-			return -ENOENT;
-		}
-
-		state->kctl = kctl;
+		else
+			state->kctl = kctl;
 	}
 
-	soc_enum = (struct soc_enum *)kctl->private_value;
-
 	reg = SDW_SDCA_CTL(interrupt->function->desc->adr, interrupt->entity->id,
 			   interrupt->control->sel, 0);
 
@@ -73,13 +70,12 @@ int sdca_jack_process(struct sdca_interrupt *interrupt)
 		return ret;
 	}
 
+	reg = SDW_SDCA_CTL(interrupt->function->desc->adr, interrupt->entity->id,
+			   SDCA_CTL_GE_SELECTED_MODE, 0);
+
 	switch (val) {
 	case SDCA_DETECTED_MODE_DETECTION_IN_PROGRESS:
 	case SDCA_DETECTED_MODE_JACK_UNKNOWN:
-		reg = SDW_SDCA_CTL(interrupt->function->desc->adr,
-				   interrupt->entity->id,
-				   SDCA_CTL_GE_SELECTED_MODE, 0);
-
 		/*
 		 * Selected mode is not normally marked as volatile register
 		 * (RW), but here force a read from the hardware. If the
@@ -100,21 +96,29 @@ int sdca_jack_process(struct sdca_interrupt *interrupt)
 
 	dev_dbg(dev, "%s: %#x\n", interrupt->name, val);
 
-	ucontrol = kzalloc(sizeof(*ucontrol), GFP_KERNEL);
-	if (!ucontrol)
-		return -ENOMEM;
+	if (kctl) {
+		struct soc_enum *soc_enum = (struct soc_enum *)kctl->private_value;
+
+		ucontrol = kzalloc(sizeof(*ucontrol), GFP_KERNEL);
+		if (!ucontrol)
+			return -ENOMEM;
 
-	ucontrol->value.enumerated.item[0] = snd_soc_enum_val_to_item(soc_enum, val);
+		ucontrol->value.enumerated.item[0] = snd_soc_enum_val_to_item(soc_enum, val);
 
-	down_write(rwsem);
-	ret = kctl->put(kctl, ucontrol);
-	up_write(rwsem);
-	if (ret < 0) {
-		dev_err(dev, "failed to update selected mode: %d\n", ret);
-		return ret;
-	}
+		ret = kctl->put(kctl, ucontrol);
+		if (ret < 0) {
+			dev_err(dev, "failed to update selected mode: %d\n", ret);
+			return ret;
+		}
 
-	snd_ctl_notify(card->snd_card, SNDRV_CTL_EVENT_MASK_VALUE, &kctl->id);
+		snd_ctl_notify(card->snd_card, SNDRV_CTL_EVENT_MASK_VALUE, &kctl->id);
+	} else {
+		ret = regmap_write(interrupt->function_regmap, reg, val);
+		if (ret) {
+			dev_err(dev, "failed to write selected mode: %d\n", ret);
+			return ret;
+		}
+	}
 
 	return sdca_jack_report(interrupt);
 }
-- 
2.51.0



