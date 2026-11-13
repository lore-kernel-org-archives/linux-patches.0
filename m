Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585885;
	b=o4cJdJdO7NYB1diP9tcHOHJHTG4FS2B/NjnVS8R8RhomC9NMfiTcOTwcRrQe42B9dAVh
	 5SsCWEJJtnc6UAmewXkbkFjTHScPo5Uow9ajKPhJk9eyXReURZ+kt3oc7XwXFCPmiHo0G
	 jE0IsxCSmS+A68tSG+O4tkkSINllPbkPLadQURXcnCpUoGjGXjLRzHfrnIbk3CrVwCcdE
	 ZYul7qewbW1MSqnQZrQL4P1fTCbqg0TR6vjg0ukVDmLwpUe34o2ihkLcvK271tHMzL0TU
	 krHyorj5JE9TdiBbS6MfD/5o/Bc+p/6x9N8MzcZtdTlaYG9Kp5EZu5RUz0QBKrbOpjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZfyPYLsvubmzwJdsiwX7++rYyhqYuccZHXgFHmnNgcA=;
	b=FZyxwZtM59mV80BeyqvI4ieBddiIm9Q/VI/nKz8Yivr8CKUEfWgLyOF5MvEwrZ0dafwI
	 SgSms2hEGVPfQB5xxmjrtIooJCr4ddp1gyEZX3mHISBf6gr/C6Vf2PHClgIoSnxUg0TOR
	 gzBk2PEcdVWHROS9wa10aqRsu3x26Is+/R0N/1wzC4KObD/bFdpsuE8LcxdOyzCUaFGSR
	 0GmocjFvkA7nGLsilrbsMdlKKxse4W8F1PxZF0b52bEpMu6SriV6mugvcREJaEVRVy3oU
	 QDMSfOAPGyMiI2i+NtM/zSGB5yGuQS+/yZPksQYNmN8UCFx6y0TYLBLZm1WGHHLRqVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FaiOEU8f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087FB606EAA7;
	Fri, 13 Nov 2026 16:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FaiOEU8f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92BA1F000C4;
	Fri, 13 Nov 2026 16:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585884;
	bh=ZfyPYLsvubmzwJdsiwX7++rYyhqYuccZHXgFHmnNgcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FaiOEU8f+22sDG6CkaUnTrAZbap6PFUp9GWKtlxlrsIuUK507TxVKkeC5V19i7NOB
	 VjbaVkHWh6y7YaPUKorjSkkBwMfS8fZSPuxnj2qFTXRVpB1YFx/vP2uML5TbiD4guO
	 kHlf8cki5SP5T1GwkhoEEy/0HaILhk0KaEJhtUHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 451/507] ALSA: usb-audio: Protect Roland control activation
Date: Fri, 13 Nov 2026 10:52:35 -0500
Message-ID: <20261113153812.014650257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 19b42c1fff7f220a6346c614d79ce1bda6d95b40 ]

The USB MIDI driver changes the Roland MIDI Input Mode control's access
flags directly from the rawmidi open and close paths.  These changes are
not protected by the ALSA control core and the corresponding notifications
can race with control access.

Use snd_ctl_activate_id() so that the control core updates the access flags
and sends the notification under its lock.  Release the USB MIDI mutex
before calling it because the control write path holds controls_rwsem while
roland_load_put() takes the USB MIDI mutex.

Keep the state transition and alternate-setting change under the USB MIDI
mutex; rawmidi's open mutex serializes the enclosing open and close paths.

Fixes: 96f61d9ade82 ("sound: usb-audio: allow switching altsetting on Roland USB MIDI devices")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260929141726.2166899-1-runyu.xiao@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/midi.c | 53 ++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 353217b3629b7..1099e5b814113 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1150,41 +1150,42 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
 			  int open)
 {
 	struct snd_usb_midi *umidi = substream->rmidi->private_data;
-	struct snd_kcontrol *ctl;
+	struct snd_ctl_elem_id ctl_id;
+	bool activate_ctl = false;
+	bool active;
 
 	guard(rwsem_read)(&umidi->disc_rwsem);
 	if (umidi->disconnected)
 		return open ? -ENODEV : 0;
 
-	guard(mutex)(&umidi->mutex);
-	if (open) {
-		if (!umidi->opened[0] && !umidi->opened[1]) {
-			if (umidi->roland_load_ctl) {
-				ctl = umidi->roland_load_ctl;
-				ctl->vd[0].access |=
-					SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-				snd_ctl_notify(umidi->card,
-				       SNDRV_CTL_EVENT_MASK_INFO, &ctl->id);
-				update_roland_altsetting(umidi);
+	scoped_guard(mutex, &umidi->mutex) {
+		if (open) {
+			if (!umidi->opened[0] && !umidi->opened[1]) {
+				if (umidi->roland_load_ctl) {
+					ctl_id = umidi->roland_load_ctl->id;
+					activate_ctl = true;
+					active = false;
+					update_roland_altsetting(umidi);
+				}
 			}
-		}
-		umidi->opened[dir]++;
-		if (umidi->opened[1])
-			snd_usbmidi_input_start(&umidi->list);
-	} else {
-		umidi->opened[dir]--;
-		if (!umidi->opened[1] && !umidi->keep_input_running)
-			snd_usbmidi_input_stop(&umidi->list);
-		if (!umidi->opened[0] && !umidi->opened[1]) {
-			if (umidi->roland_load_ctl) {
-				ctl = umidi->roland_load_ctl;
-				ctl->vd[0].access &=
-					~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-				snd_ctl_notify(umidi->card,
-				       SNDRV_CTL_EVENT_MASK_INFO, &ctl->id);
+			umidi->opened[dir]++;
+			if (umidi->opened[1])
+				snd_usbmidi_input_start(&umidi->list);
+		} else {
+			umidi->opened[dir]--;
+			if (!umidi->opened[1] && !umidi->keep_input_running)
+				snd_usbmidi_input_stop(&umidi->list);
+			if (!umidi->opened[0] && !umidi->opened[1]) {
+				if (umidi->roland_load_ctl) {
+					ctl_id = umidi->roland_load_ctl->id;
+					activate_ctl = true;
+					active = true;
+				}
 			}
 		}
 	}
+	if (activate_ctl)
+		snd_ctl_activate_id(umidi->card, &ctl_id, active);
 	return 0;
 }
 
-- 
2.53.0



