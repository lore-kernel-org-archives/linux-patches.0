Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F7AFBF2
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942A9C433D2;
	Mon, 12 Jun 2023 10:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566602;
	bh=JZqnR6XPgSKf4ENGyFQ8o2mJz+XYxGORgnLNo2+20zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hL+1pOW6FJ3wPzVWXlnk3H73z4QZ42R+GqSrAFwjTanKcnPYsCitWb8zFLNjvFmOB
	 z/jxpOe10zAbhKdsGQyW/hTMXHtvfgleTXaBkuzZ9rRLl1NtC8KNjh5Amjpixhi7BQ
	 WL3/7yhoj/H+PLae2UkNpzzoHlwhAnRdrgtTeLZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 065/132] ALSA: cmipci: Fix kctl->id initialization
Date: Mon, 12 Jun 2023 12:26:39 +0200
Message-ID: <20230612101713.232860437@linuxfoundation.org>
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

commit f2f312ad88c68a7f4a7789b9269ae33af3c7c7e9 upstream.

cmipci driver replaces the kctl->id.device after assigning the kctl
via snd_ctl_add().  This doesn't work any longer with the new Xarray
lookup change.  It has to be set before snd_ctl_add() call instead.

Fixes: c27e1efb61c5 ("ALSA: control: Use xarray for faster lookups")
Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20230606093855.14685-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/cmipci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index 727db6d43391..6d25c12d9ef0 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -2688,20 +2688,20 @@ static int snd_cmipci_mixer_new(struct cmipci *cm, int pcm_spdif_device)
 		}
 		if (cm->can_ac3_hw) {
 			kctl = snd_ctl_new1(&snd_cmipci_spdif_default, cm);
+			kctl->id.device = pcm_spdif_device;
 			err = snd_ctl_add(card, kctl);
 			if (err < 0)
 				return err;
-			kctl->id.device = pcm_spdif_device;
 			kctl = snd_ctl_new1(&snd_cmipci_spdif_mask, cm);
+			kctl->id.device = pcm_spdif_device;
 			err = snd_ctl_add(card, kctl);
 			if (err < 0)
 				return err;
-			kctl->id.device = pcm_spdif_device;
 			kctl = snd_ctl_new1(&snd_cmipci_spdif_stream, cm);
+			kctl->id.device = pcm_spdif_device;
 			err = snd_ctl_add(card, kctl);
 			if (err < 0)
 				return err;
-			kctl->id.device = pcm_spdif_device;
 		}
 		if (cm->chip_version <= 37) {
 			sw = snd_cmipci_old_mixer_switches;
-- 
2.41.0



