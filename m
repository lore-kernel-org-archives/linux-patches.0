Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66239426D2E;
	Wed, 23 Sep 2026 14:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174605; cv=none; b=Jjg60d9p8gGHxqVMh8jcifDZnaAdEnVDozHkOGjSrBkt1Z4ygM2a7s2WCgnGwcDJ2IcYI8G203pC9uIYTRxSmzU3iokgnwJb5mAPs6phtyFd0IJKobwuHhPwuKhn4XaJnHGyLS73guQ6DSEOFJjRbsNZ3T7CWMbEIpt6eu8d/R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174605; c=relaxed/simple;
	bh=KSsK/pW/iRjwWy/Pn+03SOl5rxP5PfWuP6tN1N4LGXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2ywdV58awakPUVH4EKhS1yCQzoEk4cq9ugghFjBC03e5vPXUp6ya8IUvvoAFXp7c4lDPMGsBJOVcOXsEE3UhGcers77bDGLYVffhmy6DcTA0cUEXRzJkHibDZ9C9wWLc1JN8SX3xB4ivVtw7aSES6DhI30YicQRWjOYsiLmoWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHEv2LVO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHEv2LVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B543E1F00893;
	Wed, 23 Sep 2026 14:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174604;
	bh=c/R2gtmNPnRSWnHNs12YplJ4S253HJevJdP9TcUvqzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tHEv2LVOumZ+kgCBjD4Mnkp1tO4YRRrfhFqtHvE1om6Q1laQl3RhNc3PHNWvYpvy/
	 4QO54t552sSWSypHBv2RTrpnVIH6dF0uF71ovT31x6mC2XiA7HA6nT9B/Wv44T3+sl
	 h1n99Rw91CkqMA4pcRfItHT0hB8Hq7eALZRG88uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 167/398] ASoC: hdmi-codec: Report a change when the channel status moves
Date: Wed, 23 Sep 2026 16:04:01 +0200
Message-ID: <20260923140647.764618513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e1933f733af10..df32032e631fc 100644
--- a/sound/soc/codecs/hdmi-codec.c
+++ b/sound/soc/codecs/hdmi-codec.c
@@ -425,10 +425,14 @@ static int hdmi_codec_iec958_default_put(struct snd_kcontrol *kcontrol,
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



