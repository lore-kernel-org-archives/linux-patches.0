Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCFDD512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168AAC433EF;
	Mon, 12 Jun 2023 10:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566935;
	bh=tYhmpjOVNoC/7aLqc3NJnYUbWt4jUAzkIBgDYzqMbqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKEcSs6NDywwzJKJNRG4Cvvk5LLns/5vp8FfYWMjK/vkmchY4zQE/C1mSUmTkr4Pn
	 40bOh7NuUm93HTEh5LQ4D61rI+Es2QZ9YvqcsoUAe64r3NBUYno7Aqh0x/mmbgDI9t
	 g5fJzZ+PHPpOlRcE1KGrzS9phlHtwUPSLRsz2x24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Zidek <zidek@master.cz>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	stable@kernel.org
Subject: [PATCH 6.3 080/160] ALSA: ice1712,ice1724: fix the kcontrol->id initialization
Date: Mon, 12 Jun 2023 12:26:52 +0200
Message-ID: <20230612101718.679285666@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaroslav Kysela <perex@perex.cz>

commit b9a4efd61b6b9f62f83752959e75a5dae20624fa upstream.

The new xarray lookup code requires to know complete kcontrol->id before
snd_ctl_add() call. Reorder the code to make the initialization properly.

Cc: stable@kernel.org # v5.19+
Reported-by: Martin Zidek <zidek@master.cz>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20230606073122.597491-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ice1712/aureon.c  |    7 ++++---
 sound/pci/ice1712/ice1712.c |   14 +++++++++-----
 sound/pci/ice1712/ice1724.c |   16 ++++++++++------
 3 files changed, 23 insertions(+), 14 deletions(-)

--- a/sound/pci/ice1712/aureon.c
+++ b/sound/pci/ice1712/aureon.c
@@ -1899,11 +1899,12 @@ static int aureon_add_controls(struct sn
 		else {
 			for (i = 0; i < ARRAY_SIZE(cs8415_controls); i++) {
 				struct snd_kcontrol *kctl;
-				err = snd_ctl_add(ice->card, (kctl = snd_ctl_new1(&cs8415_controls[i], ice)));
-				if (err < 0)
-					return err;
+				kctl = snd_ctl_new1(&cs8415_controls[i], ice);
 				if (i > 1)
 					kctl->id.device = ice->pcm->device;
+				err = snd_ctl_add(ice->card, kctl);
+				if (err < 0)
+					return err;
 			}
 		}
 	}
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2371,22 +2371,26 @@ int snd_ice1712_spdif_build_controls(str
 
 	if (snd_BUG_ON(!ice->pcm_pro))
 		return -EIO;
-	err = snd_ctl_add(ice->card, kctl = snd_ctl_new1(&snd_ice1712_spdif_default, ice));
+	kctl = snd_ctl_new1(&snd_ice1712_spdif_default, ice);
+	kctl->id.device = ice->pcm_pro->device;
+	err = snd_ctl_add(ice->card, kctl);
 	if (err < 0)
 		return err;
+	kctl = snd_ctl_new1(&snd_ice1712_spdif_maskc, ice);
 	kctl->id.device = ice->pcm_pro->device;
-	err = snd_ctl_add(ice->card, kctl = snd_ctl_new1(&snd_ice1712_spdif_maskc, ice));
+	err = snd_ctl_add(ice->card, kctl);
 	if (err < 0)
 		return err;
+	kctl = snd_ctl_new1(&snd_ice1712_spdif_maskp, ice);
 	kctl->id.device = ice->pcm_pro->device;
-	err = snd_ctl_add(ice->card, kctl = snd_ctl_new1(&snd_ice1712_spdif_maskp, ice));
+	err = snd_ctl_add(ice->card, kctl);
 	if (err < 0)
 		return err;
+	kctl = snd_ctl_new1(&snd_ice1712_spdif_stream, ice);
 	kctl->id.device = ice->pcm_pro->device;
-	err = snd_ctl_add(ice->card, kctl = snd_ctl_new1(&snd_ice1712_spdif_stream, ice));
+	err = snd_ctl_add(ice->card, kctl);
 	if (err < 0)
 		return err;
-	kctl->id.device = ice->pcm_pro->device;
 	ice->spdif.stream_ctl = kctl;
 	return 0;
 }
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -2392,23 +2392,27 @@ static int snd_vt1724_spdif_build_contro
 	if (err < 0)
 		return err;
 
-	err = snd_ctl_add(ice->card, kctl = snd_ctl_new1(&snd_vt1724_spdif_default, ice));
+	kctl = snd_ctl_new1(&snd_vt1724_spdif_default, ice);
+	kctl->id.device = ice->pcm->device;
+	err = snd_ctl_add(ice->card, kctl);
 	if (err < 0)
 		return err;
+	kctl = snd_ctl_new1(&snd_vt1724_spdif_maskc, ice);
 	kctl->id.device = ice->pcm->device;
-	err = snd_ctl_add(ice->card, kctl = snd_ctl_new1(&snd_vt1724_spdif_maskc, ice));
+	err = snd_ctl_add(ice->card, kctl);
 	if (err < 0)
 		return err;
+	kctl = snd_ctl_new1(&snd_vt1724_spdif_maskp, ice);
 	kctl->id.device = ice->pcm->device;
-	err = snd_ctl_add(ice->card, kctl = snd_ctl_new1(&snd_vt1724_spdif_maskp, ice));
+	err = snd_ctl_add(ice->card, kctl);
 	if (err < 0)
 		return err;
-	kctl->id.device = ice->pcm->device;
 #if 0 /* use default only */
-	err = snd_ctl_add(ice->card, kctl = snd_ctl_new1(&snd_vt1724_spdif_stream, ice));
+	kctl = snd_ctl_new1(&snd_vt1724_spdif_stream, ice);
+	kctl->id.device = ice->pcm->device;
+	err = snd_ctl_add(ice->card, kctl);
 	if (err < 0)
 		return err;
-	kctl->id.device = ice->pcm->device;
 	ice->spdif.stream_ctl = kctl;
 #endif
 	return 0;


