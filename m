Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77B65AEC6A;
	Mon, 31 Aug 2026 13:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184404; cv=none; b=b4/f0qDEoZ/thBik33qYV8MBZ5/HcZB0g4BqK5PYgUb7cBVPoFw5RyDKlz/Mqh3esJroVFXq8pPD8aGkF5n5W0ZPWjq3o1ibx4G8upI9Oeb57kbp01Vje32ob5dgwiEwHfDAsymPWQnbufhxYrdjZLzH2zrXPOkugWMMKg3/s9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184404; c=relaxed/simple;
	bh=zzvFmMle4yHE+kSzINEKAe+f87I5FCSd5xta18IhuDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4ewmeA3VPmDjZCUc912Dh5h4JOO8vjIsJlqukEiz3LGykNLSB5eyzCALCL9PhldffF6g4BlwrkqGg5G7IZ6zoHRu6xSioXFR1lzLHe+mC4A22dwVoT6PHdwLkQlyGTrc4bTo/NX1qgiXc3j7v943d7/3QBjDSQt9DT6Fj4uCBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZ7jQQsK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZ7jQQsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2881F000E9;
	Mon, 31 Aug 2026 13:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184402;
	bh=4krcS+TaY040VEIb8ROQzRODElGYzpL2gNpNsZGFSkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZ7jQQsK7WQl7vY4043zJ9C2lxo2EZcFi4FqpbkuV/bgkCiek4PzDjcNdf3sXoouY
	 RLDR51i6bW5t/RPz7q/ckASckzk7HOqWOx6opAYgaVN4xexAabWexftgZurpiXvuIH
	 IbbbTc23PXIx9C3ooykTcg0m3jiyt4U43BIkN67g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Porter <mrwillporter@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 94/99] ALSA: usb-audio: Complete cleanup after system-resume errors
Date: Mon, 31 Aug 2026 15:35:03 +0200
Message-ID: <20260831133404.412642050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1128,8 +1128,11 @@ static int usb_audio_resume(struct usb_i
 
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
@@ -1138,8 +1141,11 @@ static int usb_audio_resume(struct usb_i
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


