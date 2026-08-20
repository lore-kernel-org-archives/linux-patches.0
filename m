Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE4E381AEC;
	Thu, 20 Aug 2026 17:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247856; cv=none; b=luE1CwtDSG0GrhQ1JWZaFO6vF0cTyYyzFuyNXWcqJDMMnJ85tLFjJUdU7b4BY8NMMjJhJ3dM79B/5q1IrW6WCw6oCjYwNF7iA8GuKVoXQpxQiZJkGxi0aiOPpWZ422xH1KuqqNf8U85dpc3Wc7Qzb9W33NEgEJQKQXm++haHiV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247856; c=relaxed/simple;
	bh=VKNVXx5Sfh4zlYCR+4ByBxuxZtzMdhVRvWkxevYCDXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NDUXwEliUJdfzupVAqEZBHUuXSpZwAmRCh5YK7R4azoo6EWBE4WX2pNLTFf0ed14cFUE9YSyMsUvRIvSwyLq+XVExZlhRFtkm7r6p5ubFCCr9zJ3uofNoxuQV4UZ6YGpb1Xlodo58dud1KVwEPcw6XwOJh7ezA3CrHkIAHhphCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFKa8rvV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFKa8rvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BD31F00A3A;
	Thu, 20 Aug 2026 17:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247854;
	bh=VjPjAsbJ52VbUZLkq/NkeQWGf7CXl9lMLdR+KpNhvXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFKa8rvV+CqMotnkU4FGd46+iaNlieD4DWpHxkkL3fWB9/cerWXtO3anOeBMqGitf
	 pRNoex6E1kXjF0Lac0BsW8fTvBatF/BoxqQqGnDt6/CIdodYeR22Sxn5oE/+PpQw+W
	 XN+vdpaaVeb00Npa/XBex1Qpf13ihaTiWzW0TYFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dawid=20Wro=CC=81bel?= <me@dawidwrobel.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 018/303] ASoC: codecs: lpass-wsa-macro: Fix enum kcontrol accesses
Date: Thu, 20 Aug 2026 16:52:34 +0200
Message-ID: <20260820145253.730959768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1856,7 +1856,7 @@ static int wsa_macro_ear_spkr_pa_gain_ge
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wsa_macro *wsa = snd_soc_component_get_drvdata(component);
 
-	ucontrol->value.integer.value[0] = wsa->ear_spkr_gain;
+	ucontrol->value.enumerated.item[0] = wsa->ear_spkr_gain;
 
 	return 0;
 }
@@ -1867,7 +1867,7 @@ static int wsa_macro_ear_spkr_pa_gain_pu
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct wsa_macro *wsa = snd_soc_component_get_drvdata(component);
 
-	wsa->ear_spkr_gain =  ucontrol->value.integer.value[0];
+	wsa->ear_spkr_gain =  ucontrol->value.enumerated.item[0];
 
 	return 0;
 }
@@ -1881,7 +1881,7 @@ static int wsa_macro_rx_mux_get(struct s
 				snd_soc_dapm_to_component(widget->dapm);
 	struct wsa_macro *wsa = snd_soc_component_get_drvdata(component);
 
-	ucontrol->value.integer.value[0] =
+	ucontrol->value.enumerated.item[0] =
 			wsa->rx_port_value[widget->shift];
 	return 0;
 }
@@ -1895,7 +1895,7 @@ static int wsa_macro_rx_mux_put(struct s
 				snd_soc_dapm_to_component(widget->dapm);
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	struct snd_soc_dapm_update *update = NULL;
-	u32 rx_port_value = ucontrol->value.integer.value[0];
+	u32 rx_port_value = ucontrol->value.enumerated.item[0];
 	u32 bit_input;
 	u32 aif_rst;
 	struct wsa_macro *wsa = snd_soc_component_get_drvdata(component);


