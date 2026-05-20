Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CA110F2;
	Wed, 20 May 2026 18:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302972; cv=none; b=h5JjWAb0fo8dTetY3JUSnbJfjPMmALLMlhU7ocs1L46MIvKedsFjmTdWuDmQJ7Km0JUr7SyqANnfbGcCOpWWeEBD14YatCJbdf82vCM8Fp3uHJTtWCjBB3B4LG0WP/TlL8FYTm12IrKKROHqwrAC8EtMi23R6ai0bis3RewTshI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302972; c=relaxed/simple;
	bh=vZl4obEi1LlIf3ggqgKcVfOn4upmlMHwg57QZZ8ZTk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LJavuavJudKu1y6szPJenJulzsMaudWLEHIvqyvpqlYf/lwyTxyisB6IPSlIEQMtG0QdCw8JTFbC/isZxuL1vjYjA9OEUv9ye130pbrCbfqxmuqmkf5vM6WkgtI+T744Nwxn9l/9IvJKlURMCaDqINeDahWdkPNVMZnoBp2h0T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMD8mhf1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMD8mhf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1117D1F000E9;
	Wed, 20 May 2026 18:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302969;
	bh=1Azj2Kb2nHvh7PJ1JEmGuMIf1LDeivzIs5poH1CCoY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMD8mhf1mqS7brrJn2DzNPdnJPyPz/K9VBjR6h3Zlc9BG6AHD8fygTF1sJhCHM6sI
	 PS5GVQ+Mvc7a0m8iw5/NJEqnXf7m4RnUJgYy+O2ZH+YzpZx7pFUMOD/zYvnQ7lV8iz
	 e2eos0OMS/bRqOyyGi3U3thBBWnYYFuTLnx9NXp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 468/508] ALSA: usb-audio: Bound MIDI 2.0 endpoint descriptor scans
Date: Wed, 20 May 2026 18:24:51 +0200
Message-ID: <20260520162108.738310302@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


