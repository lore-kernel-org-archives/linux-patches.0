Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942963EAC74;
	Mon, 17 Aug 2026 14:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976095; cv=none; b=gakydh45IV6i4a44iN/z/nGEDoxdVlJg4cnwUH/knt8m9xVYHCvvZ/avEoLMqG970QKVW31F1x43RBjvmC3/XrlM++LIwtm7jTgVcUr6sXO1QV0rcDQHo1m2zzvIt4nqU/J+pTYmnkelXikvfeml9UMap26SKHkyLLyA16fqztI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976095; c=relaxed/simple;
	bh=LbENJxlrsSfZNYwbs1BTfdo8ugJZVCJqCDoHP2rCoFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPtKA29EPxTjqBbkV56LrFwwG99fg1z+z1aXSDjb+AytJYZGQmBCNFtmrWoCkr3C9qdlQCTF4pr8MttL2kjU/K6sifjAd5w68nAUYtlchUjOK4Al1wGb1o/xLEWXdyGsWsJWOpMHY3TVf74Qb18UkKNre25WvZVKd5Spn2LH0fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OeZG9bwP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OeZG9bwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1351F000E9;
	Mon, 17 Aug 2026 14:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976094;
	bh=t+08y6euFi7M9CbFMc06Q2R6F14DYL8rqeYdfV89W4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OeZG9bwPA7QjsHjiv3pT56ZXrHaW3pSYnwQUETslRYSnP9J9/tqJTgUSSDO0RnuAB
	 ol755LiE43tvhrqYQJIxsLmUg59Pa+uuMdWFxRK4cxKZgaaLDllipon9i4KE30zLxz
	 knY4F31LS307lb/YEFOMSQnYwNze5JxEYR8zZ/TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonali Pradhan <sonalipradhan@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 255/389] ALSA: usb-audio: Fix DMA buffer out-of-bounds write when fill_max is set
Date: Mon, 17 Aug 2026 15:31:34 +0200
Message-ID: <20260817132549.170187453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -871,10 +871,12 @@ static int data_ep_set_params(struct snd
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
 
 	if (snd_usb_get_speed(ep->chip->dev) != USB_SPEED_FULL) {
 		packs_per_ms = 8 >> ep->datainterval;


