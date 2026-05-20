Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FF44F5E0;
	Wed, 20 May 2026 17:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299861; cv=none; b=Klxz68OEnNvWhuoiadQmDWCfoSE21TiPHOpW+7pn3s6f0ZW5oVDEZn+Cy4Tv8ux9Tz+ULCzQ9IEvE/ZkOuTgKCDs+9SPVV7PWjV3y06OXrI0TQMTgni2gNPe9NVtmB2xVf8uicvZlGMfXW8Zis2ZyhyOU/hivlJfvlvsz4WR5k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299861; c=relaxed/simple;
	bh=jqfYLL6gyxQ2vef68b1GiqNfG8mEMkbYetPjnZsf9e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QGJVYql102pDORNYqjwZRIcXoAW5Ewwn3HPUdjg1ZUHth6a0l1ZV1y+v3LSriKV2F802jCscI4BHGPif30qkuk4sAGtmCEX82X0PZUaLkKAmGpl/xvCtOuokQ5PQVNsLUdVtvd5HiQGZgq72p3TMfgHDPUVPs6suPvoGkLmtyAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LAWQnjhU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LAWQnjhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDD61F000E9;
	Wed, 20 May 2026 17:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299860;
	bh=So7mDO487m/uUmA+CE4BfiTccW+TQzuP3PsdEe3hyEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LAWQnjhUsDUn61l7pagOm4SVmp1s+GbcW2oEPjRMs6E9oXt6m05U/VirdwqQJsIP4
	 eBReocLIubSHf4Cp95LTk9MXRyK2UAR+B7Uy5T09MeJ/HItc6uVp02XbtvqcAhU4Kv
	 qMugDi+a6zJgZq/1G6P8mucf6FHXuS4yB8cibi/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 913/957] ALSA: usb-audio: Bound MIDI 2.0 endpoint descriptor scans
Date: Wed, 20 May 2026 18:23:16 +0200
Message-ID: <20260520162154.375447780@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


