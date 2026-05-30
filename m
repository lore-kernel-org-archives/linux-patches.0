Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081793C2B80;
	Sat, 30 May 2026 18:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165719; cv=none; b=o6LA11sHCXlskVCJdmlBpZtiLHEP+afcISaTC5tPfEhie0l1JkpEzh3m0qWL8tYHckmOcdu6B1VLcNvnpMFjRYZhSEG0pBUAoDowrPgk1WhIv8Pq92s7BaC6trktKlq02p5uSPNA9TS9TbqvEL8JZXDvti5v7ap3fF0nJ5+S98M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165719; c=relaxed/simple;
	bh=0McLzhgPgHk+SO4iq39AbaDJO/FT0v0urV/BDIa83yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1CXbvfZRN4Kyo2RR9Yt1k5W7iUC3IFtjMb1aoigaFMS0uT1p2Vymu9RkpSBR5+9L+k6Isk+l2PSz5NoEsLO14b/jYAi+zILAXo8br/alQ61MzFHimZz4+X3ZaJuz9XfvbSC0fR+rgkKmL0oowuxigKtSRJ/G9D6kARHSgIbJIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSjQWAdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSjQWAdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493A01F00899;
	Sat, 30 May 2026 18:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165717;
	bh=J2cNLQwtgzHqk7xUC1p2wxSnXjoM115vOPFHI7Rmi64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSjQWAdwKyoYeOSCH94rfpf7LllaUs/K0M3Wru5iM3DHPWpoNLg2HAOe25eDOEGR2
	 wmqtgw0JnXXQ7nUlK/yd/66fnzSdhcyB+Iu3Swm0fNBGbLclv/fwzhwlmfgwAlLXOs
	 MzYIEqjmV55Rpw9wY0gZgFpAwyxesyWSPt4yRUok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 161/589] ALSA: ctxfi: Add fallback to default RSR for S/PDIF
Date: Sat, 30 May 2026 18:00:42 +0200
Message-ID: <20260530160229.016045934@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -791,7 +791,8 @@ static int spdif_passthru_playback_get_r
 	struct src *src;
 	int err;
 	int n_amixer = apcm->substream->runtime->channels, i;
-	unsigned int pitch, rsr = atc->pll_rate;
+	unsigned int pitch;
+	unsigned int rsr = atc->pll_rate ? atc->pll_rate : atc->rsr;
 
 	/* first release old resources */
 	atc_pcm_release_resources(atc, apcm);


