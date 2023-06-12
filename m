Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6726D518
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710CAC4339C;
	Mon, 12 Jun 2023 10:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566597;
	bh=B7A7U+QIML6q9L9p26ZV99TiZEb0yefHpnnkpVH9zac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXNcKpX83pqHp2H6XM5yku/1sBmxB9Uc6qyOad13UyePrmKU668FAQpZ+io8qguWt
	 wXjvcjp6XTdiJJFu+AsALJN48hu2l50ZohFb59rgeT3zp6P7v5jTH3a9zc0yo8OuYF
	 v/Y452QAT43Gs5FdQoIkMsNwerPfN/KW2QU5MCA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 063/132] ALSA: ymfpci: Fix kctl->id initialization
Date: Mon, 12 Jun 2023 12:26:37 +0200
Message-ID: <20230612101713.136048258@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

commit c9b83ae4a1609b1914ba7fc70826a3f3a8b234db upstream.

ymfpci driver replaces the kctl->id.device after assigning the kctl
via snd_ctl_add().  This doesn't work any longer with the new Xarray
lookup change.  It has to be set before snd_ctl_add() call instead.

Fixes: c27e1efb61c5 ("ALSA: control: Use xarray for faster lookups")
Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20230606093855.14685-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ymfpci/ymfpci_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -1827,20 +1827,20 @@ int snd_ymfpci_mixer(struct snd_ymfpci *
 	if (snd_BUG_ON(!chip->pcm_spdif))
 		return -ENXIO;
 	kctl = snd_ctl_new1(&snd_ymfpci_spdif_default, chip);
+	kctl->id.device = chip->pcm_spdif->device;
 	err = snd_ctl_add(chip->card, kctl);
 	if (err < 0)
 		return err;
-	kctl->id.device = chip->pcm_spdif->device;
 	kctl = snd_ctl_new1(&snd_ymfpci_spdif_mask, chip);
+	kctl->id.device = chip->pcm_spdif->device;
 	err = snd_ctl_add(chip->card, kctl);
 	if (err < 0)
 		return err;
-	kctl->id.device = chip->pcm_spdif->device;
 	kctl = snd_ctl_new1(&snd_ymfpci_spdif_stream, chip);
+	kctl->id.device = chip->pcm_spdif->device;
 	err = snd_ctl_add(chip->card, kctl);
 	if (err < 0)
 		return err;
-	kctl->id.device = chip->pcm_spdif->device;
 	chip->spdif_pcm_ctl = kctl;
 
 	/* direct recording source */


