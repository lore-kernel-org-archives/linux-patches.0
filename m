Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9FB282F1A;
	Fri, 15 May 2026 15:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860632; cv=none; b=WwQ5p2jMczyveyIjn4qx5A43YRlD2gFbnI+KrT/PA5psNRGiBFpUBB8l4NC0hPLmmrQxXxp6sMHLmVA2JKO9P10X8PZH807xyX938NmKPRhXUDEbmcarhFk+fDBzDQ1aK9jgemJZ+HQI1xOsSFpYcj+HCY2+HrsTX4mNK7bECRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860632; c=relaxed/simple;
	bh=wTQy9TjGH1F2TpW0MG8Z0K/cw/01UERjyi1Ujp4jvCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nWN4A/Qgo44BTY6CVTPEKP8+cZTM7HaQZbWJK5uRIfcVBSKdHtH4sTP7UsxzhrUWNHiQPjPylPGvYYMTGet3fMBcADD/4AUsk+UQC4kx1iD+K58QgK9h2S15zZHeFRgiHRmwHF3SE45zXgqM9GFxJppDk7JWPhRbTnYb/O+iICE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROnbo5lb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROnbo5lb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E66C2BCB0;
	Fri, 15 May 2026 15:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860631;
	bh=wTQy9TjGH1F2TpW0MG8Z0K/cw/01UERjyi1Ujp4jvCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROnbo5lb98Kwa7EbCkIaOYDLQ7ltEloToAPFxvaPTojyIhSqFf89moPAtMxUhNKOs
	 T3UPT+Bafdihv2UPbKzPIj0RTIi+y77sePN9eX1EcCsVm9lF87FHtHRC0Q55OgQ7d8
	 nJfeFTJI9bjOQsc5tdCoX7YXLH3f1mpWtvvJYLmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 002/474] ALSA: usb-audio: Avoid false E-MU sample-rate notifications
Date: Fri, 15 May 2026 17:41:51 +0200
Message-ID: <20260515154715.109214683@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit fca9c850042a7ab4828ce3a9caa8bc40ea09856a upstream.

snd_emuusb_set_samplerate() unconditionally notifies the E-MU
SampleRate Extension Unit control after issuing SET_CUR.

If snd_usb_mixer_set_ctl_value() fails, the control value has not
changed, yet snd_usb_mixer_notify_id() still invalidates the cache and
emits a value-change event to userspace.

Notify the control only after a successful write.

Fixes: 7d2b451e65d2 ("ALSA: usb-audio - Added functionality for E-mu 0404USB/0202USB/TrackerPre")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260421-alsa-emuusb-samplerate-notify-v1-1-8b63bbc1d7f1@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1561,15 +1561,17 @@ void snd_emuusb_set_samplerate(struct sn
 {
 	struct usb_mixer_interface *mixer;
 	struct usb_mixer_elem_info *cval;
+	int err;
 	int unitid = 12; /* SampleRate ExtensionUnit ID */
 
 	list_for_each_entry(mixer, &chip->mixer_list, list) {
 		if (mixer->id_elems[unitid]) {
 			cval = mixer_elem_list_to_info(mixer->id_elems[unitid]);
-			snd_usb_mixer_set_ctl_value(cval, UAC_SET_CUR,
-						    cval->control << 8,
-						    samplerate_id);
-			snd_usb_mixer_notify_id(mixer, unitid);
+			err = snd_usb_mixer_set_ctl_value(cval, UAC_SET_CUR,
+							  cval->control << 8,
+							  samplerate_id);
+			if (!err)
+				snd_usb_mixer_notify_id(mixer, unitid);
 			break;
 		}
 	}


