Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD3D1CDFAC;
	Sun,  7 Sep 2025 20:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275649; cv=none; b=LSZKHS3DIqTM7r5cCJHR8ozUGcnvOm4kSq90qj0oNvrAol9Jqb+u2cza+hj7QgWwpe2P0Y7E/I8eWVwKZ2dQp25M60gkWsIVK8BYs0xITRh32m3SortiOemOUXQgbYM9qDVkK0uylUrKajnc+Bafg67//ju4XlMWNEbdNNwRjfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275649; c=relaxed/simple;
	bh=3miHTiIiuXmGstWpgLtFKAyo8iYVqA2F5zllCGJP1Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4LBDIbvgP+i3uwAJfb6Bn7qZrC5cpkBP/NoG/rFBmbDqdimpUTnmSmrjgFt07UGtEJozej209HxDPoG6LGPu6lwRBXoTyeuXQ1xsHZcriH0zesDGe28MamJUw6v/kMzCgP/uZ2IQQOBEX91cbMvQTDatThItLvlPhYIKAfVXQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NR+v3wzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NR+v3wzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF53C4CEF0;
	Sun,  7 Sep 2025 20:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275648;
	bh=3miHTiIiuXmGstWpgLtFKAyo8iYVqA2F5zllCGJP1Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NR+v3wzc6uJWgv1eOUPIR9wpgDecm8d3XELn+2yHO4zkMgYyifugdej+QPVIzUvgU
	 n54oqA8uDKQt17FNDje3afiWYSZOo+z21xTOU2koniXRspr4NtLQsgpQsX80tL6JLh
	 wLUqp5WDL0zVR0bbkGp9q/l/9RQs5qi4hjKq16iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoli An <anguoli@uniontech.com>,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 20/52] ALSA: usb-audio: Add mute TLV for playback volumes on some devices
Date: Sun,  7 Sep 2025 21:57:40 +0200
Message-ID: <20250907195602.584362356@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cryolitia PukNgae <cryolitia@uniontech.com>

commit 9c6182843b0d02ca04cc1d946954a65a2286c7db upstream.

Applying the quirk of that, the lowest Playback mixer volume setting
mutes the audio output, on more devices.

Link: https://gitlab.freedesktop.org/pipewire/pipewire/-/merge_requests/2514
Cc: <stable@vger.kernel.org>
Tested-by: Guoli An <anguoli@uniontech.com>
Signed-off-by: Cryolitia PukNgae <cryolitia@uniontech.com>
Link: https://patch.msgid.link/20250822-mixer-quirk-v1-1-b19252239c1c@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3352,9 +3352,11 @@ void snd_usb_mixer_fu_apply_quirk(struct
 			snd_dragonfly_quirk_db_scale(mixer, cval, kctl);
 		break;
 	/* lowest playback value is muted on some devices */
+	case USB_ID(0x0572, 0x1b09): /* Conexant Systems (Rockwell), Inc. */
 	case USB_ID(0x0d8c, 0x000c): /* C-Media */
 	case USB_ID(0x0d8c, 0x0014): /* C-Media */
 	case USB_ID(0x19f7, 0x0003): /* RODE NT-USB */
+	case USB_ID(0x2d99, 0x0026): /* HECATE G2 GAMING HEADSET */
 		if (strstr(kctl->id.name, "Playback"))
 			cval->min_mute = 1;
 		break;


