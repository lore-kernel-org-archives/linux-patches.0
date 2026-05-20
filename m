Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5649D3F7ABC;
	Wed, 20 May 2026 18:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301632; cv=none; b=pqfEwbZMT7uyWSs/XnO/PmY6umJrCloPKUdqaKqZ1KtwgqqBvn7CEmgkYTuPNNJeD/WCbxy9IBC2zLANnILQ+w40KLnt0j23QW+Px4UfSFd5f0h0hii+NWzMY13uEg0jAY2WI6x8hiW/gJnUcQJeWagW3BBUC7b8kE6vWeJtclw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301632; c=relaxed/simple;
	bh=I8QdBjtAoepKWs9hjaKPH2xkojK1/7Wi6vQqfHvEd2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JY1uOiXScKxnp04BqA2RWcvOhYv3GCt8R3ILSnEIfMVndPJU0AHQSCLIRQtjt4BzsAVsencMwuGM70vwiLSZKot+H962F+v8Rd3eiELjHrJjpO82FAVbg95WUk60fBaNAaox22c+u+JGRDiIU70//fjcdm3Bea8JJMNVgPuXQsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CgccpnNl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CgccpnNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B781F000E9;
	Wed, 20 May 2026 18:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301631;
	bh=gH/pTljXszOptj+XNdpAZe7VYU3SIdDO0A+Ldk9GgeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CgccpnNlgiBRpAJqcfveyYoS6zKqhSugC+De+PkmubWbuGGg9mDrl0kaina7+pkVR
	 RQORysjeWNli2K5EUdrHj26jHgKHpszCV27WCP3MzTkBVGdSKvk5qB0YEo4eKlCo55
	 /T6ZwNlKhs9WhZKQDdVXUpjTsNsn5C64+CwbM2Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 628/666] ALSA: usb-audio: Bound MIDI 2.0 endpoint descriptor scans
Date: Wed, 20 May 2026 18:23:59 +0200
Message-ID: <20260520162124.888420255@linuxfoundation.org>
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

commit 918be519c7876329e1b6e2ea1c59f0b75e792dca upstream.

The USB MIDI 2.0 endpoint parser has the same descriptor walking
pattern as the legacy MIDI parser. It validates bLength against
bNumGrpTrmBlock before reading baAssoGrpTrmBlkID[], but not against the
remaining bytes in the endpoint-extra scan.

A malformed device can therefore make later baAssoGrpTrmBlkID[] reads
consume bytes past the walked descriptor.

Reject zero-length and overlong descriptors while walking endpoint
extras.

Fixes: ff49d1df79ae ("ALSA: usb-audio: USB MIDI 2.0 UMP support")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260507-usb-midi-endpoint-scan-bounds-v1-2-329d7348160e@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi2.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/sound/usb/midi2.c
+++ b/sound/usb/midi2.c
@@ -504,15 +504,17 @@ static void *find_usb_ms_endpoint_descri
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
 		    ms_ep->bDescriptorSubtype == subtype)
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


