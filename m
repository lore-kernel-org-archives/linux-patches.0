Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5584C3D75D3;
	Wed, 20 May 2026 17:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297250; cv=none; b=tEiPHWqZgZBQ/Zb4vCD9XnsD0ttv/Q/zQTix3QhX5Q77+TgYPpE5QGg0BhEAzgFKMxZZqIbNAtxMWZGeaMjb+NSdmxJ+c1HTrgjHw5xeInxfL37H9PaBlbRHHWxzrjoUiRuY4ImDFU/MkoY6FTBNyeBkJl4tNEulIqjzBKrezsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297250; c=relaxed/simple;
	bh=aJVNSYvmPV9HI8t/xc6PvvXMCtGk+0xm4/sVMjGTMUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QVoqTFfIttUBWXLraFXY/ncm4PrvdPL8uCo2GUL8/AkAXK2pTytIWRRKqCd+ByuvcdmYhdzB1pVneeWZlWj9NHlMYxOQeJ64fC542tvmWu0qsp1SFoe1fEuKJrrf9VqBa+6QnZ9UjuggXd0OjzCT3LRBhU/zOUlGOd/dNnr7lHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=objUIrTs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="objUIrTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0A21F000E9;
	Wed, 20 May 2026 17:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297249;
	bh=ka/QTBMlkmsoN3S+/iQc0MkCvW/xVyeIGtrLbaPKFSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=objUIrTsLTd36ssq5rA8qCcg6h/cBWDmOhPMSrMzVE4GJlaTxt9m4aXaZAp9qOJnR
	 B2Zh745J0G9iz/IzhdovddYTWlcJNjuAFh/hFufHBIekd4RT+zDEJwldjtn3MQlMHe
	 wa0G89gJJsZ/AJJNWov8waQv3rHjkaZiFJIWUVLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 1090/1146] ALSA: usb-audio: Bound MIDI 2.0 endpoint descriptor scans
Date: Wed, 20 May 2026 18:22:20 +0200
Message-ID: <20260520162212.906195365@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -496,15 +496,17 @@ static void *find_usb_ms_endpoint_descri
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


