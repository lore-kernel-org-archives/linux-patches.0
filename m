Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2343A7F4C;
	Mon,  4 May 2026 14:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903791; cv=none; b=gwkHQUFEgEMD0bXg4A1sihB7Lc7D/SD46ApWJaW8dkNONnvkbLSNub0SdXQ7tE4gkYuRJfUwPD4Z9A8dY5nA93Qu3kLd0KHfHEqB/r6sZHhXZbIJEuwWfTrWpIOETobLhtIWC/oRAkWJU7yxfIGk7evEPp4t7IwOac/EjAdLMNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903791; c=relaxed/simple;
	bh=Rb5eZR6JL+KE/Nv6pH2oAqRvS2mAf7qywKvY6CPrOMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/pZ9MurxvovI0Of5tFQ6ZZYeJWVXDQcFUuJCr254kz3JAH0n/bh45+9Y/8+vlpyxe2g/YFaRgZJdA0h0HWi2ZJhPR8baIqF7139ELRkJIj9u9mga9aUpA4gQ0CzC/XjSGls9oL54U4gmGYVXDu9KT7MfzHqJWvWC0j6ZjkyOSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlHGVRtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlHGVRtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C12C2BCB8;
	Mon,  4 May 2026 14:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903791;
	bh=Rb5eZR6JL+KE/Nv6pH2oAqRvS2mAf7qywKvY6CPrOMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlHGVRtgAMptOx16Cw9QCYVTxKxRjjGpxCIjq6hdIOl/paBPN1J+J9WQlmDHxc9r4
	 W1UI0+4s8q7HcbpbqL4obhh4zqZlGRBXmo4/EzLH69dahzWBCVIupsXGuFD6IaypSD
	 VrWetM4BVYa2tDgHg+6DKCSw6AjiCgOfXzD4PF9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 064/275] ALSA: ctxfi: Add fallback to default RSR for S/PDIF
Date: Mon,  4 May 2026 15:50:04 +0200
Message-ID: <20260504135145.311930173@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
@@ -788,7 +788,8 @@ static int spdif_passthru_playback_get_r
 	struct src *src;
 	int err;
 	int n_amixer = apcm->substream->runtime->channels, i;
-	unsigned int pitch, rsr = atc->pll_rate;
+	unsigned int pitch;
+	unsigned int rsr = atc->pll_rate ? atc->pll_rate : atc->rsr;
 
 	/* first release old resources */
 	atc_pcm_release_resources(atc, apcm);


