Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5E141B37C;
	Wed,  4 Feb 2026 14:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217063; cv=none; b=a7nHlpovkOHT6nxwSO2BOdrMVmzETi3fSJr2xVVLnRHkVHeTK3C7sTo3oH5pA/b8wfBpcChNlQAXO1N1Yw/qf0xOzzEYh8tY+DJHo+1psUlcSIzX3ZFoiExZ4ZIbwgQX67g4YeAT1/WafF6UH91UMfio9DURYQN0pmS8v3HCQAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217063; c=relaxed/simple;
	bh=m36Udtdl5AP7rwSQperND3A9IDX5fumOIQDlV9ndHMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLTlWZuasXJuxtgTHPTpBdh9y8OnbjsB5mdXfxHDtWtI5UXueAtv7pd3OaRs4AzBf9Qb6tQMX5Ku9HL31Dbsxgu2m5WT4h7axpmkOQKSwWj/dtZMeVmvxNWQMDxChjXIPr9tCXLmkeiNZAz047vxrftoLf1buocUaK6fUnjof1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nNlB29x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nNlB29x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB03C4CEF7;
	Wed,  4 Feb 2026 14:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217063;
	bh=m36Udtdl5AP7rwSQperND3A9IDX5fumOIQDlV9ndHMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nNlB29xGo9uHRIsWx/CI7/mdHpx7+er9Qq2EGLK3RcgXbHKElRu3PfyMJcVcowN3
	 dltLuB9LNoJaZ1gVKFieiNEqC/fDpYM4JbosEwwZOxG+eRi5SY/mzXWjsotu05Sl+H
	 q179jNOgAPpZwSflVbr+pW18pMD/gMD/6F7ettHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Berk Cem Goksel <berkcgoksel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 112/206] ALSA: usb-audio: Fix use-after-free in snd_usb_mixer_free()
Date: Wed,  4 Feb 2026 15:39:03 +0100
Message-ID: <20260204143902.238925160@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

From: Berk Cem Goksel <berkcgoksel@gmail.com>

commit 930e69757b74c3ae083b0c3c7419bfe7f0edc7b2 upstream.

When snd_usb_create_mixer() fails, snd_usb_mixer_free() frees
mixer->id_elems but the controls already added to the card still
reference the freed memory. Later when snd_card_register() runs,
the OSS mixer layer calls their callbacks and hits a use-after-free read.

Call trace:
  get_ctl_value+0x63f/0x820 sound/usb/mixer.c:411
  get_min_max_with_quirks.isra.0+0x240/0x1f40 sound/usb/mixer.c:1241
  mixer_ctl_feature_info+0x26b/0x490 sound/usb/mixer.c:1381
  snd_mixer_oss_build_test+0x174/0x3a0 sound/core/oss/mixer_oss.c:887
  ...
  snd_card_register+0x4ed/0x6d0 sound/core/init.c:923
  usb_audio_probe+0x5ef/0x2a90 sound/usb/card.c:1025

Fix by calling snd_ctl_remove() for all mixer controls before freeing
id_elems. We save the next pointer first because snd_ctl_remove()
frees the current element.

Fixes: 6639b6c2367f ("[ALSA] usb-audio - add mixer control notifications")
Cc: stable@vger.kernel.org
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Berk Cem Goksel <berkcgoksel@gmail.com>
Link: https://patch.msgid.link/20260120102855.7300-1-berkcgoksel@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2930,10 +2930,23 @@ static int parse_audio_unit(struct mixer
 
 static void snd_usb_mixer_free(struct usb_mixer_interface *mixer)
 {
+	struct usb_mixer_elem_list *list, *next;
+	int id;
+
 	/* kill pending URBs */
 	snd_usb_mixer_disconnect(mixer);
 
-	kfree(mixer->id_elems);
+	/* Unregister controls first, snd_ctl_remove() frees the element */
+	if (mixer->id_elems) {
+		for (id = 0; id < MAX_ID_ELEMS; id++) {
+			for (list = mixer->id_elems[id]; list; list = next) {
+				next = list->next_id_elem;
+				if (list->kctl)
+					snd_ctl_remove(mixer->chip->card, list->kctl);
+			}
+		}
+		kfree(mixer->id_elems);
+	}
 	if (mixer->urb) {
 		kfree(mixer->urb->transfer_buffer);
 		usb_free_urb(mixer->urb);


