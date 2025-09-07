Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C9B17BB21;
	Sun,  7 Sep 2025 20:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276752; cv=none; b=GzCaGFQxjMWjzHMJFEjEnEWHOhYvNeTxZV32eP0xC6tMp8xJYTncH8CfhwcYnz6hPNtH51w3c+tuKBRM3IPpIb7Vs5PIxFMyHT0RZxLfI6UDftZg89riqaXUlY95Li22q/FjcnSJTYaJOVKEQnHYaoIB5gWZ44qBP96RrWaitNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276752; c=relaxed/simple;
	bh=drMpN1R8JJSKJLcFFYNghgYBK/Plv1gag8zMOBldsn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8a8ORj8IRTelhr969yEMd+3Zzq/GTdrEfq5L9pvHyYmrhrOwQLX4/5zktIAPgIgBZG0RrXQA6O4INXqgwYkqOHj5I1v/bw2mnKhv0n7SjBm+st/f5S4BZJ99+3WgYSA9R75R9ulWZrNoRPVGZy43w2CI46z9krTREaksTDahy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpMO8rIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpMO8rIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F54C4CEF0;
	Sun,  7 Sep 2025 20:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276750;
	bh=drMpN1R8JJSKJLcFFYNghgYBK/Plv1gag8zMOBldsn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpMO8rIefcVPP2v3DvneSBcVa+orCdclEsymfTFk4ztkC9AYIaVvr9MbY4bi04OVy
	 q7HLqiMaotrBaRr7HSMDbnOBgioGYluYM9QtvCIW36p/Y2w3IdekasRUpFUYu5MitS
	 6T43B7WfY3t3SycsreXp4/3TglRexFQBjycgW1f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoli An <anguoli@uniontech.com>,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 051/121] ALSA: usb-audio: Add mute TLV for playback volumes on some devices
Date: Sun,  7 Sep 2025 21:58:07 +0200
Message-ID: <20250907195611.136933589@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3631,9 +3631,11 @@ void snd_usb_mixer_fu_apply_quirk(struct
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


