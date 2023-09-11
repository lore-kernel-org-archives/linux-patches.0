Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8241170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACF7C433C8;
	Mon, 11 Sep 2023 14:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442257;
	bh=jkoQ726IpYcv50GTILbGDO3L70AmWus3FTa38P1t4JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrELMHLNbDGrnEPeXXr7gV89IvFWuL9sl1SmClLlDwn3L0Gy/v0hcqe1fBFUCvxrK
	 YgQEDMeboTZtPAFbpBCMoWMMj9W3VWnjVIogM9N6RYg000s+YXe2tyRfdkhrpJ1/o7
	 VlxXIpib5ZV+z0mknzY3+mLp16xhYBGnXJqqmv9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.5 675/739] ALSA: usb-audio: Fix potential memory leaks at error path for UMP open
Date: Mon, 11 Sep 2023 15:47:54 +0200
Message-ID: <20230911134709.956635132@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b1757fa30ef14f254f4719bf6f7d54a4c8207216 upstream.

The allocation and initialization errors at alloc_midi_urbs() that is
called at MIDI 2.0 / UMP device are supposed to be handled at the
caller side by invoking free_midi_urbs().  However, free_midi_urbs()
loops only for ep->num_urbs entries, and since ep->num_entries wasn't
updated yet at the allocation / init error in alloc_midi_urbs(), this
entry won't be released.

The intention of free_midi_urbs() is to release the whole elements, so
change the loop size to NUM_URBS to scan over all elements for fixing
the missed releases.

Also, the call of free_midi_urbs() is missing at
snd_usb_midi_v2_open().  Although it'll be released later at
reopen/close or disconnection, it's better to release immediately at
the error path.

Fixes: ff49d1df79ae ("ALSA: usb-audio: USB MIDI 2.0 UMP support")
Reported-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Closes: https://lore.kernel.org/r/fc275ed315b9157952dcf2744ee7bdb78defdb5f.1693746347.git.christophe.jaillet@wanadoo.fr
Link: https://lore.kernel.org/r/20230905054511.20502-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi2.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/usb/midi2.c
+++ b/sound/usb/midi2.c
@@ -265,7 +265,7 @@ static void free_midi_urbs(struct snd_us
 
 	if (!ep)
 		return;
-	for (i = 0; i < ep->num_urbs; ++i) {
+	for (i = 0; i < NUM_URBS; ++i) {
 		ctx = &ep->urbs[i];
 		if (!ctx->urb)
 			break;
@@ -279,6 +279,7 @@ static void free_midi_urbs(struct snd_us
 }
 
 /* allocate URBs for an EP */
+/* the callers should handle allocation errors via free_midi_urbs() */
 static int alloc_midi_urbs(struct snd_usb_midi2_endpoint *ep)
 {
 	struct snd_usb_midi2_urb *ctx;
@@ -351,8 +352,10 @@ static int snd_usb_midi_v2_open(struct s
 		return -EIO;
 	if (ep->direction == STR_OUT) {
 		err = alloc_midi_urbs(ep);
-		if (err)
+		if (err) {
+			free_midi_urbs(ep);
 			return err;
+		}
 	}
 	return 0;
 }


