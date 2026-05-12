Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4986E3EDE5B;
	Tue, 12 May 2026 18:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609023; cv=none; b=ijuB8KvBxg2CCYP/1o0iiRaiZZAmS81PQavDfywBBq2PSfBQUyK0Y0ZvsUNG+J3Jq9mHFQDqj2UTruqQyQqO6fQRODJacM9ek7kdjf6b5SY1E8T6klbAf4/RfZvqRaDYMYjapz2GYD0rr13+TQZYysNR/Xy4U7JjhGsHSmnPbTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609023; c=relaxed/simple;
	bh=6bmaOyXcdF4S82blkIf6SZseKYPn8Hqd4L1TnzzWirs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s1EyPZCdEmfmtZD7oA5cwV2pxXm033jgSwvbXch8LmwcS7o1bJ/djSJ4UCFtrIUnSQZzIxEZPtAMpZkJ5kD3PJ3cb7VsZHCwPPFxY3vrseYPGp8Dlqdo8iCDU0Ks6FvpBZkORgCl5GLmshYrwhCC4yEpDMlxod9NXLkyiAL9oig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKCZiq1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKCZiq1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5860C2BCB0;
	Tue, 12 May 2026 18:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609023;
	bh=6bmaOyXcdF4S82blkIf6SZseKYPn8Hqd4L1TnzzWirs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKCZiq1wVhOq+nrEA4/CUiY3LefGodyGkURp4hpn5PEYLRH0WKkTIgPFobGzUqt6S
	 cmsFUlViffEOxosUT9OkwvnIOG9wymXNoVtAjcQWNxAopG60xTy2+eFIKx6p6Sl8V5
	 lZACY/IWZAAB+FQsiK+MYguu+4+EfrJO8YKFi88I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 036/307] ALSA: usb-audio: midi2: Restart output URBs on resume
Date: Tue, 12 May 2026 19:37:11 +0200
Message-ID: <20260512173940.887687412@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit f3c57c9c2a49a21d784b7c04a2c883bffc070659 upstream.

USB MIDI 2.0 suspend saves the endpoint running state, clears it and
kills all endpoint URBs. Resume restores the running state, but only
restarts input endpoints.

For a running output endpoint, this leaves the endpoint marked running
with an empty URB queue. Output transfer progress depends on either the
rawmidi trigger path starting the queue or an output completion refilling
it. After suspend there is no completion left, and output data that
remains queued in the raw UMP or legacy rawmidi buffer can stay stalled
until userspace happens to trigger the stream again.

Restore the saved state with atomic accessors, keep input endpoints
restarted as before, and restart output endpoints that were running before
suspend. Clear the saved suspend state after restoring it.

Fixes: ff49d1df79ae ("ALSA: usb-audio: USB MIDI 2.0 UMP support")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260504-usb-midi2-output-resume-v1-1-c089cc8ad3c6@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi2.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/sound/usb/midi2.c
+++ b/sound/usb/midi2.c
@@ -227,7 +227,7 @@ static void kill_midi_urbs(struct snd_us
 	if (!ep)
 		return;
 	if (suspending)
-		ep->suspended = ep->running;
+		atomic_set(&ep->suspended, atomic_read(&ep->running));
 	atomic_set(&ep->running, 0);
 	for (i = 0; i < ep->num_urbs; i++) {
 		if (!ep->urbs[i].urb)
@@ -1190,10 +1190,11 @@ void snd_usb_midi_v2_suspend_all(struct
 
 static void resume_midi2_endpoint(struct snd_usb_midi2_endpoint *ep)
 {
-	ep->running = ep->suspended;
-	if (ep->direction == STR_IN)
+	atomic_set(&ep->running, atomic_read(&ep->suspended));
+	atomic_set(&ep->suspended, 0);
+
+	if (ep->direction == STR_IN || atomic_read(&ep->running))
 		submit_io_urbs(ep);
-	/* FIXME: does it all? */
 }
 
 void snd_usb_midi_v2_resume_all(struct snd_usb_audio *chip)


