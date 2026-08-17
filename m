Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D158B42901B;
	Mon, 17 Aug 2026 15:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980027; cv=none; b=FSgUr5Zhpv6sZrmhlh6Vx76RTXuptYXTfaH9T7AAQnjKd+w/4AvWl5ofbUlr5TRpdWo9sDfM71xYucyc66N5d36k1J75dvic4Lryog0XrSpVrudkpE3xIMZzg+IOtIEutZ9Bp4iSpLAZf0HLNb0rPJMafwUJk/FbaBr/tukeS8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980027; c=relaxed/simple;
	bh=HMjss1oyOsNoWM2CqEEjOwVfCDPc+SA1lOphrrD/Zzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMeBJzkLVHJ4PIfHdYRZIzSxfj7/v21cGTO+tetEneejEwGmcLnJ9oP0Yd8F4XXaBBBLcjyMYT/cAEl92yIgSWAkbBRlnRvosVxJndV6SQhJg9wocHL3yZQDZ6YEoQGdrk9yop834uDh3PfoAmCyELaiEokCM4TRoZViYH8ObU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEuc7ZWV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEuc7ZWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3A51F000E9;
	Mon, 17 Aug 2026 15:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980025;
	bh=yVIEBfC3Dmz7EswcLCjHP4kroVW8BdZoTTWzisHsmsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FEuc7ZWVXTI4blTn5EAXrmaenrZaygjWY1h+px06tAX3Mb5xMwhdAyCexgS6ACa2Q
	 BW0HOfe4BaOqgFeIupFrzf99pOYNYa5re7adDLjs3EZLp2duh030xcXAKt5zKMxFm8
	 jZySThI0O4IbtW++P5qHaJLO5dcGoKcodsv3J1+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonali Pradhan <sonalipradhan@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 403/609] ALSA: usb-audio: Fix DMA buffer out-of-bounds write when fill_max is set
Date: Mon, 17 Aug 2026 15:31:39 +0200
Message-ID: <20260817132557.676265154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sonali Pradhan <sonalipradhan@google.com>

commit d0199ae1666ff9ae2d1d568d64c3430d4c47f0e5 upstream.

When a USB audio endpoint requests full packet transfers via the fill_max
descriptor flag, data_ep_set_params() promotes ep->curpacksize to
ep->maxpacksize. However, maxsize is left at the original sample-rate
derived value.

Since u->buffer_size is allocated as maxsize * packets, the resulting
DMA buffer is far too small for the requested transfer length. When the
USB host controller streams up to curpacksize bytes per packet, it writes
past the end of the buffer via DMA, corrupting kernel heap memory.

Update maxsize to curpacksize when fill_max is set so that the allocated
DMA buffer size matches the actual transfer request size.

[ changed to reassign maxsize only when ep->fill_max is set -- tiwai ]

Fixes: 8fdff6a319e7 ("ALSA: snd-usb: implement new endpoint streaming model")
Cc: stable@vger.kernel.org
Assisted-by: Jetski:Gemini-3.6-Flash
Signed-off-by: Sonali Pradhan <sonalipradhan@google.com>
Link: https://patch.msgid.link/20260728201716.2347726-1-sonalipradhan@google.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1167,10 +1167,12 @@ static int data_ep_set_params(struct snd
 				<< (16 - ep->datainterval);
 	}
 
-	if (ep->fill_max)
+	if (ep->fill_max) {
 		ep->curpacksize = ep->maxpacksize;
-	else
+		maxsize = ep->curpacksize;
+	} else {
 		ep->curpacksize = maxsize;
+	}
 
 	if (snd_usb_get_speed(chip->dev) != USB_SPEED_FULL) {
 		packs_per_ms = 8 >> ep->datainterval;


