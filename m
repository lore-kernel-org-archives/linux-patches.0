Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48AA372680;
	Wed, 30 Sep 2026 19:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796163; cv=none; b=G0THSA1fhywHcTxXu6c2002Z4+ZsMZXQ3lWMDdkTudGS/3cXn4UrkDVJH/L6y3bPjBVCw5uSycUFTmyr8E2dNhnhB+rkYlRFeaLCcIBthhCr9LUCdPotc+R3TdXCdjg4ejSpUTIOY3N3Cgz9UXLVtNzxbUCpBL1mzEpWiYZyU1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796163; c=relaxed/simple;
	bh=gabyvtbkURNShAdc9NMgB0Wzh8QK4gm+U8x2JO8bbUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3PYNWZXzfvFqHweBnG+BAT/IvwjqJV8+3UKAOyoGp+b1eP0tfIiDA2YuJTQA5rQAVTCvNEydYXosZi8ZG0raobTsL71ziQR8OG28QCpG8ygRmTOQ189xVYaQzeW1AfnhFlbX2OAduEUfBpyRNml5oHbzPYlnz9e4MlLMWYeAKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqzcFWdD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqzcFWdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8351F000FF;
	Wed, 30 Sep 2026 19:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796162;
	bh=JsAEe8JMr5b+WTQivZPnoa8JwMqcf89Zr+GCxnagnsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BqzcFWdD9QFMZioPeQv5v6sVLBE67D3doVlABjwqVeSDGaNPQE5iyhOPRc1zl/QAW
	 uGowTaAbye0CLCegAHcycDJ1L3jXcR8KucLeB8qXxjcJkQUKFdrdP/YR1OTiD76uJ8
	 A6VvArdTkgjTVrJhtCeTrutVuP9gUlSShmN+LUdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0817/1193] ASoC: hdmi-codec: Report a change when the channel status moves
Date: Wed, 30 Sep 2026 17:25:01 +0200
Message-ID: <20260930152452.397307696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 03290d3ae59cc..9ed31547feeda 100644
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



