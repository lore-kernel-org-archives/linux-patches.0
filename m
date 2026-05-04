Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CDA2E2F0E;
	Mon,  4 May 2026 13:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903097; cv=none; b=J99WMmyXeI2LPIh4UeVrBeBebsmQ+FWkCT0PwF+x4DwmXa04ulbeZr30P8KoGnOl/bMMbliWxtbV9NhIHCad+jXIsf8n/Ks/0RIGGDk7i2jh6i7XWtKYvcWMk4Aa9noSL2jamxpziBIXPL3lj22F9f/rJVrBAvt2j/M9l8pzJgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903097; c=relaxed/simple;
	bh=oebDUseL1dy7UR2+TNMfNRqJ7iL9tWKBDCSrGWMweD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEQ416E7nwJa76jgde2gWl+h4xtQ/0cYJ/a65q3maNnJ3tpnXzgjRagmVQd5vgMgSMRoJi4LIJinhwIexPhjbQHBiuvYN/IYDR1DTl4gKP2Y4+/DjrqZgDaIA5VYwXH2gnTmoG/LgF7ZEaIet4IY2k5El7Rri4z9uaL9J/hJgtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ApwEHYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ApwEHYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F1AC2BCB8;
	Mon,  4 May 2026 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903097;
	bh=oebDUseL1dy7UR2+TNMfNRqJ7iL9tWKBDCSrGWMweD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ApwEHYHwM0XRyydBKRTgrsT5L5AlXyFM/4edTClei+HZagi7TmeOnuI6Zt9jn3Gl
	 FCVrOJSU6IQkCTXYPijGu0ksLcUKnUDmv1ZiLCtvtZ1nsAZUB5S6GQ7biboqq4b2g4
	 grHKqdCC4FWh14cQ2ZNnDsGZ5YeyTKZrVIuyBZqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 070/307] ALSA: ctxfi: Add fallback to default RSR for S/PDIF
Date: Mon,  4 May 2026 15:49:15 +0200
Message-ID: <20260504135145.447754852@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harin Lee <me@harin.net>

commit 7d61662197ecdc458e33e475b6ada7f6da61d364 upstream.

spdif_passthru_playback_get_resources() uses atc->pll_rate as the RSR
for the MSR calculation loop. However, pll_rate is only updated in
atc_pll_init() and not in hw_pll_init(), so it remains 0 after the
card init.

When spdif_passthru_playback_setup() skips atc_pll_init() for
32000 Hz, (rsr * desc.msr) always becomes 0, causing the loop to spin
indefinitely.

Add fallback to use atc->rsr when atc->pll_rate is 0. This reflects
the hardware state, since hw_card_init() already configures the PLL
to the default RSR.

Fixes: 8cc72361481f ("ALSA: SB X-Fi driver merge")
Cc: stable@vger.kernel.org
Signed-off-by: Harin Lee <me@harin.net>
Link: https://patch.msgid.link/20260406074913.217374-1-me@harin.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ctxfi/ctatc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -794,7 +794,8 @@ static int spdif_passthru_playback_get_r
 	struct src *src;
 	int err;
 	int n_amixer = apcm->substream->runtime->channels, i;
-	unsigned int pitch, rsr = atc->pll_rate;
+	unsigned int pitch;
+	unsigned int rsr = atc->pll_rate ? atc->pll_rate : atc->rsr;
 
 	/* first release old resources */
 	atc_pcm_release_resources(atc, apcm);


