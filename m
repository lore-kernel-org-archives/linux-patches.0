Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D2F1B424F;
	Sun,  7 Sep 2025 20:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276047; cv=none; b=Urk8mfEi1a6NM5q5NMPij6gKivmySs1sFkmDm2PXkCFGuHblo2gUHsdShoSooaQnpiUW+3J0Pec7sRBODncF+/vJ7l0vDwGlerrSIJoPrGgmSZx1ZDAt2wEXxsCNdt+flZHbLNjXAMHxqc+LhcJG+5SlmQpJflURaTYs3hjq2tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276047; c=relaxed/simple;
	bh=8I323Zem2ZaqzuK/rkNIHcJA/lCkM/pc7qCrdO2PKM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tmbo9ZgsjcGDs+ZxHUYFqj8ifsRz4qJbqVCVdk0f5fzgQt0itSezBksd0n3lk2u5/XrXgQMKsVPW+EdL9GGnneHDZ/2GveIUWdurn1rgJ2aIO3z8roz/5zNtyNSTAtlMXXeFdG4U9lcHXGUezE8sXYIIG6qt9QNA+BBGQSyBnVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VaD8gwt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VaD8gwt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5427C4CEF0;
	Sun,  7 Sep 2025 20:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276047;
	bh=8I323Zem2ZaqzuK/rkNIHcJA/lCkM/pc7qCrdO2PKM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VaD8gwt508V10rPRkMhsLaEHlKQR8e0vTp5QLonpLTPFQEyk9KGbWOsg1UnxNWVHx
	 NXEr2WS7gIy47FN1vlC6i+4XYQjhujFJjvYcK/uIaTRWeLAS+UbQlMUuzRBwsiqCxz
	 tR3NEKIKW+ohJxZcKje2Aon/vcMeAin0w01duMug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoli An <anguoli@uniontech.com>,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 29/64] ALSA: usb-audio: Add mute TLV for playback volumes on some devices
Date: Sun,  7 Sep 2025 21:58:11 +0200
Message-ID: <20250907195604.196017958@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3609,9 +3609,11 @@ void snd_usb_mixer_fu_apply_quirk(struct
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


