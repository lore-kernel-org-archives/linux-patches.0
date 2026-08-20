Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4735360745;
	Thu, 20 Aug 2026 15:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238737; cv=none; b=dN3zI9gsxyY/fnBmH5V8fhQt1rb8kkIOCrrJ0yC2XQDY6hehZm+6TyHQcOfb7r/eaV4OggE6Zn0MadZaTlKrVXXc0aNE1Kzb6b58T5fsyZjNP1OAWl+hjcXtmgxKVdAdIm4wC+7+6ljFXlgXL3X1idGgq6yojuO0/jKB1LlE1k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238737; c=relaxed/simple;
	bh=UpWQP4MJ1jaVCwQFIbGdQtMwWV4NwAypfuwJ3lLTvic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QDzJJGnHoJ50PUhKBz4W741YkOGEn8mEhIU4veTIhKansEVyspfO2nhocXswCZ3Wb0HVf1JFxcjbyuDErF8+UsBgFlIYrxyRbDoZsKzAGiDUi4m8rJus6x5WqKOXJwZ4itn+bfkwc73nsEWf4NbJRaZEmaqceYB1NlofRX23Y+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeCMM6Q2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeCMM6Q2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A6F1F00A3A;
	Thu, 20 Aug 2026 15:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238736;
	bh=p7RdaxGXq5uWbuqAKwwhWai6F70C0UE4dOBb8JjLfkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IeCMM6Q2vyLn+GG3jL7LpbDAY8FGTTDrrXZ9RkuRiBBZ6Cx1bFJTRar2jUCBq+7Cv
	 LAvCKOqshHEJbaN/XIxZVKtXEdXqzWNppXy5Xzf1hK2iNd79jOu+3alQpx1CfSH0o+
	 XDhj1eET5W1I8Xk3wdGAJmMWKZc9FGPCPI68zGQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dawid=20Wro=CC=81bel?= <me@dawidwrobel.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 023/217] ASoC: codecs: lpass-wsa-macro: Fix enum kcontrol accesses
Date: Thu, 20 Aug 2026 16:53:11 +0200
Message-ID: <20260820145238.319095273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawid Wróbel <me@dawidwrobel.com>

commit 56f24311fd5607588a47e44675195a9efb200f29 upstream.

EAR SPKR PA Gain" and the four "WSA RX* Mux" controls are enumerated,
but their get and put callbacks access the value through
ucontrol->value.integer.value[0] (a long) instead of
ucontrol->value.enumerated.item[0] (an unsigned int).

This same pattern was fixed in the sibling drivers by
commit bcfe5f76cc40 ("ASoC: codecs: rx-macro: fix accessing array
out of bounds for enum type") and
commit 0ea5eff7c606 ("ASoC: codecs: va-macro: fix accessing array
out of bounds for enum type"), but wsa-macro was missed.

On 64-bit kernels with CONFIG_SND_CTL_DEBUG this trips the elem value
sanity check and every read of these controls fails with -EINVAL.

Fixes: 809bcbcecebf ("ASoC: codecs: lpass-wsa-macro: Add support to WSA Macro")
Fixes: 2c4066e5d428 ("ASoC: codecs: lpass-wsa-macro: add dapm widgets and route")
Assisted-by: Claude:claude-fable-5
Cc: stable@vger.kernel.org
Signed-off-by: Dawid Wróbel <me@dawidwrobel.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260730-worktree-lpass-tx-macro-enum-fix-v2-2-6d091c736116@dawidwrobel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/lpass-wsa-macro.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/lpass-wsa-macro.c
+++ b/sound/soc/codecs/lpass-wsa-macro.c
@@ -2167,7 +2167,7 @@ static int wsa_macro_ear_spkr_pa_gain_ge
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wsa_macro *wsa = snd_soc_component_get_drvdata(component);
 
-	ucontrol->value.integer.value[0] = wsa->ear_spkr_gain;
+	ucontrol->value.enumerated.item[0] = wsa->ear_spkr_gain;
 
 	return 0;
 }
@@ -2178,7 +2178,7 @@ static int wsa_macro_ear_spkr_pa_gain_pu
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wsa_macro *wsa = snd_soc_component_get_drvdata(component);
 
-	wsa->ear_spkr_gain =  ucontrol->value.integer.value[0];
+	wsa->ear_spkr_gain =  ucontrol->value.enumerated.item[0];
 
 	return 0;
 }
@@ -2192,7 +2192,7 @@ static int wsa_macro_rx_mux_get(struct s
 				snd_soc_dapm_to_component(widget->dapm);
 	struct wsa_macro *wsa = snd_soc_component_get_drvdata(component);
 
-	ucontrol->value.integer.value[0] =
+	ucontrol->value.enumerated.item[0] =
 			wsa->rx_port_value[widget->shift];
 	return 0;
 }
@@ -2206,7 +2206,7 @@ static int wsa_macro_rx_mux_put(struct s
 				snd_soc_dapm_to_component(widget->dapm);
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	struct snd_soc_dapm_update *update = NULL;
-	u32 rx_port_value = ucontrol->value.integer.value[0];
+	u32 rx_port_value = ucontrol->value.enumerated.item[0];
 	u32 bit_input;
 	u32 aif_rst;
 	unsigned int dai_id;


