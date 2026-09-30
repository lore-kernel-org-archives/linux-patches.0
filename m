Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B3736E467;
	Wed, 30 Sep 2026 16:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785941; cv=none; b=P0pmXCX7allUXP2C/Zd9QQZ18EeQVDStiB60LREGlClmwbxb/z7gl+2cihL82mEBXvpRVh9IDoKuAd6gC/5fcaYUqf+0+Epb37w7G8zrVN+OV0XIT7wc0r5XS6aV9u6nW9lwGjpUNix3D2/7/nd0rpB0aPPQgcHYHGZfo5M4de8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785941; c=relaxed/simple;
	bh=iTQPi8JRAcLuPONLeVHvneBpiFcPenp5pOt7eCz//4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wy0xrtDFEa/gHrKk2BZOQtnF5m+UCVZ01JBanhiZUFJvLwjUqbsPyOAlr4eX8ToyI4Q6WWw2V2hXkQQat4mLIT7fCzL0zxfseUz9DOOqHMniBg8vAE5I6/rGdreYDaQKhwTRzbhf17cP2jTORJAIuV2m/uhPhBdGr4FhIkMswHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnG439Mi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnG439Mi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F1F1F000FF;
	Wed, 30 Sep 2026 16:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785940;
	bh=aX+F5YoFQSDmY/CFgp0ROXXpO2rcoDcOK395rlzdPx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JnG439Mi2Au5fud3sCf2SQJ+ZWrY2xV/hCX6Jg/FWjlIMY4WMBW0lRgtTF4x9v0PN
	 +z4jCc2xcj5rKdkPTXOoOtCduf+m0PEWyyQp58/tcGx7TTBYUDZ5xjmJmg3EqpGGrM
	 rSiXIOIs/OBTOecmfq2dbifi+nMZZYyS+O0CJAbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 684/982] ASoC: hdmi-codec: Report a change when the channel status moves
Date: Wed, 30 Sep 2026 17:23:40 +0200
Message-ID: <20260930152431.454676076@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit c17ae8c26eac16ad244daef44044d714f68a2ddc ]

The put() callback of "IEC958 Playback Default" stores all 24 channel
status bytes and then returns 0. The core notifies userspace only on a
positive return, so a write that changes what the get() callback hands
back is never announced, and a mixer holding the control open keeps
showing the old value.

Compare the stored bytes and return 1 when they move, the way
snd_hda_spdif_default_put() does.

The same shape is in img-spdif-out and uniperif_player.

No board with this codec was to hand. The change is a comparison of
driver state with no hardware behaviour in it, and mixer-test counts the
missing notification as event_missing.

Fixes: 7a8e1d44211e ("ASoC: hdmi-codec: Add iec958 controls")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Assisted-by: Claude:claude-opus-5
Link: https://patch.msgid.link/20260915092515.2638542-1-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdmi-codec.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/hdmi-codec.c b/sound/soc/codecs/hdmi-codec.c
index cb664d3d02dd0..cbb03da04a947 100644
--- a/sound/soc/codecs/hdmi-codec.c
+++ b/sound/soc/codecs/hdmi-codec.c
@@ -422,10 +422,14 @@ static int hdmi_codec_iec958_default_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_kcontrol_chip(kcontrol);
 	struct hdmi_codec_priv *hcp = snd_soc_component_get_drvdata(component);
 
+	if (!memcmp(hcp->iec_status, ucontrol->value.iec958.status,
+		    sizeof(hcp->iec_status)))
+		return 0;
+
 	memcpy(hcp->iec_status, ucontrol->value.iec958.status,
 	       sizeof(hcp->iec_status));
 
-	return 0;
+	return 1;
 }
 
 static int hdmi_codec_iec958_mask_get(struct snd_kcontrol *kcontrol,
-- 
2.53.0



