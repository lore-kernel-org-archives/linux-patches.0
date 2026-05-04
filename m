Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5AC29E116;
	Mon,  4 May 2026 14:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904388; cv=none; b=I/rRK9KaBXMLnzKDKSNEJIuTHevYw6pOWZCC60su4+uu9nV8TAWsG0oimOBTYnWQLfcwx6so9kBGqCeJGgvR6/t2uAGidXwtXkCPKKRtLwQd75yOcKfiydd0svbPxLb5Ol4K/63v3uFgh5BK9fYlY3pv9KHdyGm/aQMV0rSipbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904388; c=relaxed/simple;
	bh=kUlRd7frq9qk//Uh86cocUHCeUcjO5f5/cvMBWIErfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cD0cQBK6aLt3KIeNK4xt6JmkQMLNefV8mzaTCwqUKJjVQjKtkjMnIuDC5LCi5/x0SFz93RnrImOwzeWS5OR4Zo0lqX9ydKTmMPxQlgamygbak57HHE3VXjucBqwCs3bBiedgC1qr2VHYveMe50NZMHmrRkqUxVXNRAfUJ76j3ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayol7EvV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayol7EvV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD85C2BCB8;
	Mon,  4 May 2026 14:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904388;
	bh=kUlRd7frq9qk//Uh86cocUHCeUcjO5f5/cvMBWIErfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayol7EvVcIPAw157sR+eYfTcaNcRBYPG8aXbq93KsJkjzzQogFAbCJqO0F/F7KYNE
	 4nS1CxNz1FbztIBGInIiIU5Z6YeJH/q/a+vW+AX4IEQlDZP6XmWpooPWJOkrK1W4+r
	 ajBHA2kLxP6NJ3uMjqwDZoNAV6XvjA+7je3WNzvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 002/215] ALSA: usb-audio: Avoid false E-MU sample-rate notifications
Date: Mon,  4 May 2026 15:50:21 +0200
Message-ID: <20260504135130.263775621@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1559,15 +1559,17 @@ void snd_emuusb_set_samplerate(struct sn
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


