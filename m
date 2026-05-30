Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52077223DC6;
	Sat, 30 May 2026 17:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163190; cv=none; b=aNHz+d7E/NI0oszwnBLmBVyYhqbpyNumhgUeSDnQu8EQNXtgIDqKFChcL2JgraAujsGARUlfhMNo5DcOVK+5LhwEGSQtlY9OWAGa1LMYR69B64fUF644kiUBvMAmWGhvKvVrvEZRxQwGxzbPpe1xShG18+7FXUPAmqn6aDgQGLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163190; c=relaxed/simple;
	bh=2v9+f6Je98sA5ZpbrDSS+6dCb24Rni7qclTwfQgMV5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=StG90wUp294n6Dj4qSOrUtPiinFDMavDgZb9EZ5aHj7BMp6cUlfEWNVzJl+Fw1ciK67AT7JIRGUfFtP5sBoL8gT+GgaLm3ixNBgH3pCt7waSP4UK2vMqNI8V3RVhMIN8R3ca42wyS2+GBEgrSrgWxWMTtpoU1nFz9BeqxukKY38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4FgByXv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4FgByXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A121F00893;
	Sat, 30 May 2026 17:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163188;
	bh=CRsVLYFzgNDOfGkngvI6q5fVA6tz9V2VCMuYf1IONsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4FgByXvXkU+3eybZZFTDVzmf3jsulqhCYOIRTJNW2ZfmdcVGCpG2FVCUCw9sRxzU
	 RV9l43BLPCG2f0KnNn//LwjgGyldEkXDzQjQRqfAD57fYL2psb39kQ3d4S1u3IqEwF
	 A8Rq3TOxk+mYoNBP6mGmeOs078/rfJ4xFK51Y1H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 183/776] ALSA: usb-audio: Fix Audio Advantage Micro II SPDIF switch
Date: Sat, 30 May 2026 17:58:17 +0200
Message-ID: <20260530160245.228791701@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit a9224f26b754b5034719248891ff3c2ea0d11144 upstream.

snd_microii_spdif_switch_put() returns 0 when the requested
vendor register value differs from the cached one.

This comparison was inverted by the resume-support conversion,
so real SPDIF switch toggles are ignored while no-op writes still
issue SET_CUR and report success.

Return early only when the requested value matches the cached one.

Fixes: 288673beae6c ("ALSA: usb-audio: Add resume support for MicroII SPDIF ctls")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260421-microii-spdif-switch-fix-v1-1-5c50dc28b88f@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2066,7 +2066,7 @@ static int snd_microii_spdif_switch_put(
 	int err;
 
 	reg = ucontrol->value.integer.value[0] ? 0x28 : 0x2a;
-	if (reg != list->kctl->private_value)
+	if (reg == list->kctl->private_value)
 		return 0;
 
 	kcontrol->private_value = reg;


