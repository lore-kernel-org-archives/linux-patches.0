Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C344315A;
	Sun,  7 Sep 2025 20:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277700; cv=none; b=R8TdmU3hwEFCE5c2qC+nYZSqPREd9+PykzfimV8K14z5dWypVFVGLDVTKR40bF9RVH2Yisa5DBfZnL8bhbFulfKNJxjHZz9CTLcjQ34yhN+XVWXhwAv4/tRkoeQILI3ZPhzVzQcknnEXgWf6Z9wdmkO4lXwmo9o0BQkM2uRecuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277700; c=relaxed/simple;
	bh=7RKQ1+mRuJVFNpoJOYv6YH10HSSOENx2jdE0Cf/iM/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVqZ8/P64xNZGzvn6RTrnX/gxCE7feCDIQcJurZizPZDd57mJlq71Rum6j4wYLYQdJy+S+kPF8gmlBQW9gT5ByuYdvVoUISMbcw7QuGzaKjGRT4vqMJozbFHXDx3YIEXmAa7SIACXIAOz1b1E40UhElH1o1xfGfH3pMng3RbdA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9VMqf/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9VMqf/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F470C4CEF0;
	Sun,  7 Sep 2025 20:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277700;
	bh=7RKQ1+mRuJVFNpoJOYv6YH10HSSOENx2jdE0Cf/iM/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y9VMqf/sCtqe8unp7ceQDVZqoyFD/2r4qDsR9tKChdhjvu+Wdbgf6EK3SwUwxO5oY
	 2+CmUm0uKj5OUNOLuX3c1B59x05aER8aElC2lDY5oqSqdcgwMw8c93A6qmnKc+tA4e
	 3vug+ZeE2D/ZvWvGei056t2zoOnw/1E9J2g5qFEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoli An <anguoli@uniontech.com>,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.16 096/183] ALSA: usb-audio: Add mute TLV for playback volumes on some devices
Date: Sun,  7 Sep 2025 21:58:43 +0200
Message-ID: <20250907195618.067191924@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4339,9 +4339,11 @@ void snd_usb_mixer_fu_apply_quirk(struct
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


