Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E59E81AA8;
	Wed, 28 Jan 2026 16:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616032; cv=none; b=sjp1DplyepKE4NyP+6OIdmb/+EhtImq2DnxjekDCgpLxZ+1PykRSorgixpAFgw0dCpRM2V+V27HqYiKMdGB0tp9ZR05MzbPlZZqctjC7YfERNsr4Q5yrsXsfNLecyZ/yuq01Ou3L/QMwi3ekQXFx7tQxagdtpRAJTn0O7mzgBsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616032; c=relaxed/simple;
	bh=n5T5sj9akrOY3vUqhs5kWrQVF9cNlGotAUwcaFlmWbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKVyl0Yl7rV3WXX9Lb8MhobcgxIh/6inZzCFnvWpqjbRmEHqd/JzZo0ahuYdlqQeMSzLKUwInNjy17emeyUgjdzqj2zKJnr9K2ZQi2b3b9wSs40pyLMRuHUT7Q/wHpkMvV2PSeBiBDRaAbp0Hwjx3Qf3oLagEX6wn8mY1/vR27I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxmPIb5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxmPIb5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FF5C4CEF1;
	Wed, 28 Jan 2026 16:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616032;
	bh=n5T5sj9akrOY3vUqhs5kWrQVF9cNlGotAUwcaFlmWbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxmPIb5mHqKMJZaEkO/DLMFDIXFNg0cxmRpZ4D1oHwNiSBl9IsKbUxrnJifZpBtDn
	 xGj+2lGGJ0HOg3KuP4DoAkU89p9KhUFcj/Hbk5lYFASzJo3l934jaDT+DeLEhrkCgY
	 b8GRFYgn1AHuhqyl25T1/EynpoAJyGD8NZrEOJdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Berk Cem Goksel <berkcgoksel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 169/227] ALSA: usb-audio: Fix use-after-free in snd_usb_mixer_free()
Date: Wed, 28 Jan 2026 16:23:34 +0100
Message-ID: <20260128145350.532794387@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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
@@ -2945,10 +2945,23 @@ static int parse_audio_unit(struct mixer
 
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


