Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C285D32D42B;
	Sat, 30 May 2026 16:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160039; cv=none; b=oo9j8/mwd0TCdN/5S4KLZJvNQzw1Vsa5YwDMkse4eUXPH9cixrC4PCJZzcsskjtdAel9Kq1d3zdV4eUZcDOC28WZldmjex7R/06wkU/M52nRWjnuZGEFJyCvk7vqlEDZ0qk3AbymmZtZa8rGTrt0g3N6B6JUk5L/XdZw/idxIbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160039; c=relaxed/simple;
	bh=iaUoIUhtKx709PbCR9JugEd2b2kHCkqQ5eT0a7LnQZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQDN3BGmbFTlp4J7x+zSrXMOYVhBDfYUJJpFU6P+sDQHW8A/l9j02GRnccCCRwQHuD9vcaeVg1IEhLdmIyuPjeCb7UdXkRKVyy1uCic9/gE7wAIEJH8gAM47OiCVSM82EoCHEcfotHOWobzU8ZI0d5RGcssl3emvFYgWs36vln0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GgfwX8Gr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GgfwX8Gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185A71F00893;
	Sat, 30 May 2026 16:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160038;
	bh=YEk6k3cupXquMEQRu7WzdZ8p7N7gMNiNlaEkj/p/unw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GgfwX8GrX8O0jIsyBufLymVvInyoNZpcnDHA66UiehPGXbWW6nB28qNS5sNN5Zls2
	 WsL6FZfPMj17ov3G5vZ7Xxx8tvVauoRY1+gGe8LqXS7G8n/JXd4TA5ifw2CFVKYcVo
	 nW5lfBtCsSEsWktG8NuZ+OMZ2xVdf49eWUh8NlsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 195/969] ALSA: ctxfi: Add fallback to default RSR for S/PDIF
Date: Sat, 30 May 2026 17:55:19 +0200
Message-ID: <20260530160305.858511714@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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


