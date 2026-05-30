Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B84D3AC0FC;
	Sat, 30 May 2026 17:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163273; cv=none; b=FhJnX4W8rceuAH+xkQMQJeDiwM9+Xr49oVC5aqddOMi5ZlyFRSAFLpCHkgOTNvuJmmdBFLjoBVgnffKr7Rs1+l1yPR1RJCX7mn05joi7+GmEMXIxxQk2GK/LXnjNdIDaEEkFDaoZDnKsZjHcb8iDlQsudI+DIWitcySayC2IiYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163273; c=relaxed/simple;
	bh=2hEg407cFRucaY3/uO/AwM4U7wIWBwPmAG4AY9Dl4i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlFlXQedC+Onn9Rn5EbEXxNct+dxaFG1/NEa1l24W/drij180JqNkiY5NgQ7G9PigX7om0m7HkCdtLP+PC4UqpRCa4+Eqwf5kypo2LyauNp2JvunnHZ8Qf8HfLAwUlFpY3lZVvn9zcGtGijVB6g9qPOjSOR4n3nPjeBMRXqo19g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGtkvmtS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGtkvmtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19691F00893;
	Sat, 30 May 2026 17:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163272;
	bh=yStrkZQjTnqidEzcWQPWfiW6ZN18cJFcw1IvXRsaPf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGtkvmtSdadnQn3CQnxlvID6t+bNPOILVA2UdyTwGAkyqmycU24l/E+xf4nG6XWf3
	 +W+GtoBRSUQPaX24gofnkahVistGxaSDUkcb/PXLylLacKfNNNwGlWzf2zm85mv11O
	 lxtoNLLeelJeJoCb9ARgiPHise7SXkWjMjxXZs+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 209/776] ALSA: ctxfi: Add fallback to default RSR for S/PDIF
Date: Sat, 30 May 2026 17:58:43 +0200
Message-ID: <20260530160245.914903761@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


