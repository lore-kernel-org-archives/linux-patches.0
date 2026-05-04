Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D739E3DEACB;
	Mon,  4 May 2026 14:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903667; cv=none; b=VzvvSk1tHzAI3Boa3rWfSWaJd7Y4xSDkDMaDSzYKT3pJ3RyWWobCCoWqO4RVQH6hd4LB9cCeT05lNqxRo1iPtitWZIhwoE1jkmkQTdd31bjBtyV3i4rIcRl+4gNiC8xd6HZrxeXJeDcNsKzzi7vVYcUaD0ihVvvIR0c10UJRg8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903667; c=relaxed/simple;
	bh=54RD0Fu6TwZvdIu02Qj8FhZb4luekgCH/f5Plr0V0u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZLOQSgR6phetJ/zeeZ+nAx1nWEckdvlABCAStmcDge0IDZOv44e6dx3U44IbpmgbcTilWUTAWoTLIjzaTQNMda78oYEKW+OK99+3WDmIRN72zQJl7MlVtLi9ETLK3J2m88HqmYFNxH5KAxAWmBaP+sB68Qc83BlEKDleuGGttH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJrgM5hh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJrgM5hh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D05EC2BCB8;
	Mon,  4 May 2026 14:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903667;
	bh=54RD0Fu6TwZvdIu02Qj8FhZb4luekgCH/f5Plr0V0u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJrgM5hh/16n9dM+x1xiw2SVQOK6A3E2xm2U/3Y8KT1VWYInD+BsUFRpO2B69PYEO
	 d1dhOll/b4p+FNM+oAsz5q//A1GwS85VaiVv7sDjD4Eqg7IqkzLNZ0PGf3YuG/Uyfs
	 37LHgPhfZDSp2bqGfGpM6EPuVVKljiEekANXUAlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 002/275] ALSA: usb-audio: Avoid false E-MU sample-rate notifications
Date: Mon,  4 May 2026 15:49:02 +0200
Message-ID: <20260504135143.025217567@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1538,15 +1538,17 @@ void snd_emuusb_set_samplerate(struct sn
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


