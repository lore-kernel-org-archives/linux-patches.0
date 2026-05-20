Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8AA3FBEDA;
	Wed, 20 May 2026 18:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301634; cv=none; b=mX0oqlVDPHKJAJnyoKBITTYfrl5mCbUejSweo7r42sZcCe29zx3x672LWTW2rwJDmGpe9ebYu3ytGc8oz1aFijTgqQ8TBdT2CCEtH9UXm98Jkq++HqDxPnyOqW/JNnyjGIIuPriy2aJMD0RirYWrkEN2tnRNgJYm0lAiRpYiMYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301634; c=relaxed/simple;
	bh=7ckjnKJUDEN8D+o9S3cp77Mf4KD3W3uiKK3Ud9LKrl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IimK74wBKDwwu2tgxWwQR0CScqpZnwncnYdR1RoJYKHBtf66BePoUL0BP1xpoHr8MER/X1M+0eUe3S2CzHIPBUQpUulKVn/U8Q0EcjhfO8mH0LrXMQ5S2P+VmsrX9Zw1bM+BpK4mmW4U5FfSl0zG6sj/D6jlaqRhLTkNPT58Fv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppf3IKjP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppf3IKjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7F71F000E9;
	Wed, 20 May 2026 18:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301633;
	bh=P2AM/FIgAYfL1mJqfxbPlNPhRATMsT9A0UbRn7VctJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppf3IKjPsESN+pNMIb6W5DJgwPoXUlTDdRasiwSb6n3Kx+khz3/+ZgiQ+bUxcFmc2
	 JdPfPQ0eT/Ap2otW9U9FUVpF6zuDTE4mGJU6qM5G71kLJX6SMG+6rTKBa2bY7PzuIL
	 EY6l8CVnlgsHyqLzOr7a+nuol6CNzfX+qPtlkdfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 629/666] ALSA: usb-audio: Bound MIDI endpoint descriptor scans
Date: Wed, 20 May 2026 18:24:00 +0200
Message-ID: <20260520162124.909195758@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit d6854daa67be623860f4e1873fd3d3c275aba4ed upstream.

snd_usbmidi_get_ms_info() validates the internal MIDIStreaming endpoint
descriptor size before using baAssocJackID[], but the descriptor walker can
still return a class-specific endpoint descriptor whose bLength exceeds the
remaining bytes in the endpoint-extra scan.

That leaves later flexible-array reads bounded by bLength, but not by the
remaining bytes in the endpoint-extra scan.

Stop walking when bLength is zero or
extends past the remaining endpoint-extra scan.

Fixes: 5c6cd7021a05 ("ALSA: usb-audio: Fix case when USB MIDI interface has more than one extra endpoint descriptor")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260507-usb-midi-endpoint-scan-bounds-v1-1-329d7348160e@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1959,15 +1959,17 @@ static struct usb_ms_endpoint_descriptor
 	while (extralen > 3) {
 		struct usb_ms_endpoint_descriptor *ms_ep =
 				(struct usb_ms_endpoint_descriptor *)extra;
+		int length = ms_ep->bLength;
 
-		if (ms_ep->bLength > 3 &&
+		if (!length || length > extralen)
+			break;
+
+		if (length > 3 &&
 		    ms_ep->bDescriptorType == USB_DT_CS_ENDPOINT &&
 		    ms_ep->bDescriptorSubtype == UAC_MS_GENERAL)
 			return ms_ep;
-		if (!extra[0])
-			break;
-		extralen -= extra[0];
-		extra += extra[0];
+		extralen -= length;
+		extra += length;
 	}
 	return NULL;
 }


