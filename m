Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173904EC66D;
	Fri,  9 Oct 2026 14:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556918; cv=none; b=ncRM+dAnqDqhEyVrVq8+r0wGpt1cN2Qezmr7IelDr7/JLpglCyozVaYuqGxsNrrU8u+VNTxs98EnrY9PZnH1H74zh1boYqDL//hZMBzFfT/7YGB6hjiI6ACeaiGB9HYQ0PvvBtKXsgRwX3TfSeIsvBMxi02izphzvTYJNwRbyRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556918; c=relaxed/simple;
	bh=18lezbnatIn10cik5G91seWxUIiAMHBlKMQVdtivn1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqgAjf7o04gefOH3u4dMMSbp4MtEBxw6QHUODkLnb7GqK7qYx4lbukzLn4iWZKvibpMIHdCcCNNzY9pDSgdwI6LMPU5zztHrtssOPgmhqS3CY1H/4BTM2NWEx16otA1J7A6X+eIhI8lCQkkN8cdUivD6aj6E+THBtTTKw784EG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LB+LjjiZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LB+LjjiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238151F000FF;
	Fri,  9 Oct 2026 14:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556916;
	bh=2AVlJz8hBuuH15QgPHy/pgxgVOWTT5CNX9FkLkusIF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LB+LjjiZPHJxTUkaSEhvA7ueMd8ONYvqclAon/yCijJDcDaKlUedV0UzhW+XtHFtK
	 eTP4hKwayJPS/PIg0GkNZJV8hbwzX4AqAPv5tVnf7t0/dmn+9tiB/dGNP6MnZxpboR
	 o8EXQ0rJFk49xq9dfH2PHdPJ32cHiS3XXmQ7/aSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Nicoara <lnicoara@thinkoid.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 263/428] ASoC: codecs: lpass-wsa-macro: rewrite the interpolator volume after enabling clocks
Date: Fri,  9 Oct 2026 16:10:00 +0200
Message-ID: <20261009140951.875899291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liviu Nicoara <lnicoara@thinkoid.org>

commit b2047b8cadadccb1c9269ce756c399cd9aef2c82 upstream.

Commit 902f497a1ff5 ("ASoC: codecs: lpass-wsa-macro: remove useless
gain read/write sequence") removed the read and write of the digital
volume register in wsa_macro_enable_interpolator(), on the grounds that
writing back the value just read does nothing. The comment above it,
"apply gain after int clk is enabled", was left in place.

On the Dell XPS 13 9345 (X1E80100, four WSA8845 amplifiers on two WSA
macros) the write does something: a volume change made while the path
is idle does not take effect when playback starts. Lowering the digital
volume from 81 to 63 with nothing playing, then playing a test tone,
gave about the same level as before the change. With the rewrite
restored, lowering it from 81 to 69 while idle played audibly quieter,
and restoring 81 while idle brought the level back. Changes made during
playback take effect with or without the rewrite.

The register already holds the new value when this happens. Without the
rewrite, after an idle change from 69 to 81, playback stayed at the old
level while the register, read from the hardware through /dev/mem, held
the new one (0xfd). Writing that same value back through /dev/mem
brought the level up at once.

This is the behaviour described in commit 46188db080bd ("ASoC: codecs:
lpass-wsa-macro: fix compander volume hack"): "the volume registers
still need to be written after enabling clocks in order for any prior
updates to take effect." The value read comes from the register cache,
so the write pushes the last requested volume to the hardware once its
clock runs.

Restore the rewrite in the interpolator's POST_PMU event only. The mix
path event removed later in the same series is not brought back.

Fixes: 902f497a1ff5 ("ASoC: codecs: lpass-wsa-macro: remove useless gain read/write sequence")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Liviu Nicoara <lnicoara@thinkoid.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260929115755.6096-1-lnicoara@thinkoid.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/lpass-wsa-macro.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/codecs/lpass-wsa-macro.c
+++ b/sound/soc/codecs/lpass-wsa-macro.c
@@ -1840,6 +1840,7 @@ static int wsa_macro_enable_interpolator
 					 int event)
 {
 	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
+	unsigned int gain;
 	u16 gain_reg;
 	u16 reg;
 	struct wsa_macro *wsa = snd_soc_component_get_drvdata(component);
@@ -1881,6 +1882,8 @@ static int wsa_macro_enable_interpolator
 					CDC_WSA_RX_PGA_HALF_DB_MASK,
 					CDC_WSA_RX_PGA_HALF_DB_ENABLE);
 		}
+		gain = snd_soc_component_read(component, gain_reg);
+		snd_soc_component_write(component, gain_reg, gain);
 		wsa_macro_config_ear_spkr_gain(component, wsa,
 						event, gain_reg);
 		break;


