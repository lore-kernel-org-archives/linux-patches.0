Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944072D660E;
	Wed, 28 Jan 2026 15:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614625; cv=none; b=qO4WqwF0aUtdLfBY+ILZPgr5Oa/wxnEMNfC7BqhOHyU6SXX3qkZsDTLiuT9ckp6m5Dg8BW1KM1jtJ4eFfUZsffx7WF7QxVQaVVI8H/jxoolJ3CQzO2KddvOJ4lH/50G2SvHeE/cI4Dq6WVrcSR01hSRVR/I1IuI7mAoKVL1aqlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614625; c=relaxed/simple;
	bh=Ap8vaY7A55SI7UaPv9D+SzYt6ydpd5lKwt087+SuXUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTefnPDdRu/zqDHtRs6IYTusKvauL6F+BAoIgkiMwA/FwMnwjsZ7E5n0GnSlsElYU/4jWupk10gwGwWZgs1A1OCn3C5dPQWth5IlP+drxlOhH/ut7P+RhVVLNNyL7u2HNbeSjS1NwzGJKn9Ogzn/iRMyzAJdxxJ9n+EqqI0TrMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ck5qrY34; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ck5qrY34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151A2C4CEF1;
	Wed, 28 Jan 2026 15:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614625;
	bh=Ap8vaY7A55SI7UaPv9D+SzYt6ydpd5lKwt087+SuXUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ck5qrY34dR4tYiLHh+9U3YiIyph5KuOsNz1n2VH7rBo5vxLjndlcbd76fBXRw+wvH
	 PBdNI7Za+6oS7k72urgzXowbu5a0m5KdfD5lExUH5WJ8b2ZBkNeJx9T+OaI9lMrDK5
	 NuErq99zh6pitKAEruO3zGqvHYzxixF+7qte1378=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Berk Cem Goksel <berkcgoksel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 193/254] ALSA: usb-audio: Fix use-after-free in snd_usb_mixer_free()
Date: Wed, 28 Jan 2026 16:22:49 +0100
Message-ID: <20260128145351.743250598@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2938,10 +2938,23 @@ static int parse_audio_unit(struct mixer
 
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


