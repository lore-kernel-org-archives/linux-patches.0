Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2ED494804;
	Mon, 31 Aug 2026 14:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185168; cv=none; b=WL7ZkkSX5ye6UON/LHrQyS4KT5Ei9/zi4wkOZhASl/v1FC/ECpIGjy3oeBkg5SUl2NhW0WAVy9ibYuRBNVmsPZvZsMloNrJg7Ty5KbwGL+j7gTFuA2PIgpnM8o6ahjccQCjT2RLJg+9l64SG7mWOdZ53lKiLuhglNZ8E116NziY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185168; c=relaxed/simple;
	bh=Zoeza8n6QCXH2vxpwBeNY5He52xljLiYVZEmEJQfSBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbXrwOXsd9gpGpOgI8vCbTAWgkPjXisTd+7p1byWcmmknMxTzTepSwPjhsIkIB8KejHH+tpWqz3CVd99Au4SdeuonihENTLo957DwvntJlYKFS7N4gdycRUwS7zGKyclWxT8An+CYFSPFA5C4WSVEB2fEE3RVxxMaJ2M46ViRXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/idyFkU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/idyFkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42E61F000E9;
	Mon, 31 Aug 2026 14:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185167;
	bh=m7hBJ2VhISshGbYNtTSVV5Terds/O8p5XnteERP5ri0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N/idyFkUdEbD+BfG/tSrVvl1E+9yXtthZstj8QNiS6EK+YGdTOc7RLJpG1QT7Eqcp
	 c1VT5aEmJasdOcyUOOuQmlQnYcWkDu2jECIhvBWW4BqGeU86OwWXxxnddRtRU9gjeT
	 cPBojivcT5+GWkRV7+vkTEWuKfno12RwVl41wifA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Porter <mrwillporter@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 65/69] ALSA: usb-audio: Complete cleanup after system-resume errors
Date: Mon, 31 Aug 2026 15:35:38 +0200
Message-ID: <20260831133401.986820509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

From: Will Porter <mrwillporter@gmail.com>

commit 1739a976312e110c93a8dee66a1cdf893a1b187e upstream.

A failed system resume can leave the card unusable until reboot.
usb_audio_resume() jumps to err_out when snd_usb_pcm_resume() or
snd_usb_mixer_resume() fails. The error path skips the out: block, which
restores D0 and decrements chip->num_suspended_intf.

The card stays in SNDRV_CTL_POWER_D3hot, so later control access blocks in
snd_power_ref_and_wait(). USB core logs an interface resume callback error.
It does not retry that callback, so a later callback cannot complete the
skipped cleanup.

usb_audio_suspend() increments num_suspended_intf before returning success.
A system-resume callback must consume the system-suspend count even if a
component resume fails. Otherwise, the stranded count skews later suspend
and resume cycles.

Do not apply this cleanup to runtime-resume errors. Runtime PM can retry
-EAGAIN or -EBUSY without another suspend callback. The count must continue
to describe that suspended interface. Other runtime-resume errors latch
runtime_error in the PM core and do not cause an immediate callback retry.

Both parts of the system-resume error path are longstanding. Commit
88a8516a2128a ("ALSA: usbaudio: implement USB autosuspend") introduced
err_out past the D0 restore. Commit 862b2509d157c ("ALSA: usb-audio: Fix
inconsistent card PM state after resume") later moved
num_suspended_intf-- into the out: block. The error path now skips both
operations.

No third-party code is needed to reach the error path.
snd_usb_mixer_resume() ends in snd_usb_mixer_activate(), which returns the
result of usb_submit_urb() for devices that have a mixer status URB. Its
mixer->private_resume hook can also fail through scarlett2_init_notify().
snd_usb_pcm_resume() issues a SET_CUR request to a UAC3 power domain. It
can return -EPIPE or -EIO when the device stalls the request.

Route a component error through out: only when system_suspend is nonzero.
Continue to return runtime-resume errors through err_out. Later component
resume stages remain skipped. The original error still reaches USB core.
A later transfer can fail if the device did not recover.

I reproduced the system-resume failure on an Audient iD14 MkI with an
out-of-tree diagnostic mixer resume hook. An injected -EIO on the unpatched
core left control readers in uninterruptible sleep in
snd_power_ref_and_wait() until a reboot. With this patch, the same failure
restored control access. A second system suspend and resume also succeeded
after I disabled fault injection.

Assisted-by: Claude:claude-opus-5
Assisted-by: Antigravity:gemini-3.1-pro-high
Assisted-by: Codex:gpt-5.6-sol
Fixes: 88a8516a2128a ("ALSA: usbaudio: implement USB autosuspend")
Fixes: 862b2509d157c ("ALSA: usb-audio: Fix inconsistent card PM state after resume")
Cc: <stable@vger.kernel.org>
Signed-off-by: Will Porter <mrwillporter@gmail.com>
Link: https://patch.msgid.link/20260824225757.26749-1-mrwillporter@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/card.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -1121,8 +1121,11 @@ static int usb_audio_resume(struct usb_i
 
 	list_for_each_entry(as, &chip->pcm_list, list) {
 		err = snd_usb_pcm_resume(as);
-		if (err < 0)
-			goto err_out;
+		if (err < 0) {
+			if (!chip->system_suspend)
+				goto err_out;
+			goto out;
+		}
 	}
 
 	/*
@@ -1131,8 +1134,11 @@ static int usb_audio_resume(struct usb_i
 	 */
 	list_for_each_entry(mixer, &chip->mixer_list, list) {
 		err = snd_usb_mixer_resume(mixer);
-		if (err < 0)
-			goto err_out;
+		if (err < 0) {
+			if (!chip->system_suspend)
+				goto err_out;
+			goto out;
+		}
 	}
 
 	list_for_each(p, &chip->midi_list) {


