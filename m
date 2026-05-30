Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E9A3C8C5A;
	Sat, 30 May 2026 18:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165763; cv=none; b=I+M1xyWuyAsPyd+Tu9HSuJqkfBuCojXs3MtmTOAayo6qaaQ+dx5XOUwoQOhdh6PzonFQKqpqFmKj/tbwbI3Mszi6OEuWRS5DREyapGSpMeQ+tfSQFu9aNpNwLZlEC++h2FIRCzr/75roRf+gGA4u8MAZM9AZBapnyjplkUgylkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165763; c=relaxed/simple;
	bh=3qrNzEXV43wV+1ecWkDD5ND1n7NgtQ/rlpY00Di1bVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GT+qs4uQrQvjHIQXld2XqzfOEWXY4/fwWgCTYLyYnpGqG2Hh/EXIVhchvn5QK1Zqohw5xcS5W8L7Nv6MTNKA5hbaf3ME1pgRPJ5Dyv4QPXnGEyUPlvoPYDG8eQ7IQH9uH3gNTVxZpurlAerELCdPPWFVIVJVp8zFCpMveqHCwK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1aq5aTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1aq5aTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F119E1F00893;
	Sat, 30 May 2026 18:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165762;
	bh=YYgb734n0BC/tpe4Bg6XfE0pmDDpxxc8LtAX3B/ZJhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v1aq5aTZJUbcxuFVAwevanFO0MM8NnrvUiLJ9Lv/TberHsLd5SqUzgScVyHJicv1R
	 tUiay/FbuCX+J8kdRve7gdL/AfzYyepe+YQ55PL5i23SDp9+yrjhPi6BM30cjEu34m
	 aDOHYzBqFgkbqEsCkNSJ4aQpX2ovtsIc2Uqxt1ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 138/589] ALSA: usb-audio: Avoid false E-MU sample-rate notifications
Date: Sat, 30 May 2026 18:00:19 +0200
Message-ID: <20260530160228.408687605@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1420,15 +1420,17 @@ void snd_emuusb_set_samplerate(struct sn
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


