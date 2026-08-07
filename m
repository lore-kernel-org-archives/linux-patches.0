Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A272D12ED;
	Fri,  7 Aug 2026 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116241; cv=none; b=Zf9bw8DWmAdVUCkUbGvs5OacDUV10C6zxem6uFBIKeDi/vIFKzpckQc8Xov6O0aF/IcaqxfTs75sLl9ebLM0f4cFtvaXq4WJReA8pBj7Pe+NpMBWdVSaP9fniIubhom+N37EiCSlqNH8by+lNRwnR+YLFHm/9FOcEgiW7zEBwIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116241; c=relaxed/simple;
	bh=QUWR9z6W3QVi/VJwf7zidxdb/s9+6wlbqYmH1sDYhxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3P/NucyBpeDm5+5F17GZdfFpEmkewBG4VQaXxzgXlJVy+nhe8uKCVBkPZFZypeUqaFOkZMtUv2zPE70/+QJpj7ECFtsMBUmAPTk19awflMRhoMvYwOZbnasDLMK3YLvzxH8fFHR1E4i9/D3FZc2BClTbMSTU04FMWNH8RuoC6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYuXndAz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYuXndAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3401F00A3F;
	Fri,  7 Aug 2026 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116240;
	bh=QtTqeTKcAjiA+81rYdf+v8hYqK4c/dSBRPee7hLiMBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bYuXndAzz0S0M/2awWAfhdKKLL9RRt2zTgk7HoKH4JSRY2h2ROD+Ij8Hf2IJ7+gIE
	 FDN8lYhp5S0E5RNNTw84Cs4pOZzLfJHhm/5eRXC+Bj5wR/lv5oE0p4tc4B8ne/JksY
	 Tr33sHG0k1pam+9xdR64DwGnqPGQeXNLmzDeH9/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonali Pradhan <sonalipradhan@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 118/261] ALSA: usb-audio: Fix DMA buffer out-of-bounds write when fill_max is set
Date: Fri,  7 Aug 2026 16:37:55 +0200
Message-ID: <20260807143417.917891728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1185,10 +1185,12 @@ static int data_ep_set_params(struct snd
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


