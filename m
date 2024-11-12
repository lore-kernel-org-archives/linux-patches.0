Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30A01F26E3;
	Tue, 12 Nov 2024 10:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407094; cv=none; b=LgQmWkOX1phIoi/v+GfjX9DKRBhZDKBRZeaHW5sprn2Zl0hLZLbb6j0gisK2f6Qj1YB6Q0lk2ztazWva0hCbA1430W3j3A8fEipHGON6CG1ORqCv3NCirEDfjyoPZdhe2fCG+dhJ8F7a8h3ax2sMckYvz9KUcNJGP0MUsiLEa90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407094; c=relaxed/simple;
	bh=/XMjWF5YdNtloOrImZjr1cwxMxnxfdfWjdA4pvEmY9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sO/ig1mzdmB3E+FjXA4YFbXBBTdj/loN6x21PZ7doexUS/sxhO8jt4KsrCwP9HgGwG3S5IB8ij5+4ec2ddHln/v8FDKuVJpmjsTXlQ9P5n4BY6Gs+YgctnFRdYSxpFoirl5rwpX0wNXt/scdI9WphF1vaVxoFuAvBp6AzEXUiWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfrFfqZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfrFfqZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A97FC4CED4;
	Tue, 12 Nov 2024 10:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407094;
	bh=/XMjWF5YdNtloOrImZjr1cwxMxnxfdfWjdA4pvEmY9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfrFfqZhUb/mGzNGLfXdEHk9FvHtJ/kSVoS0fz8vXiZlG8crI2Dzeb+6+Tgv3WQxf
	 m6rjrl6QxJSE1fVprZjmMYeHLgnbTL/zCRiMEraEMedGRqrWr9z7qc+oDCvOozN253
	 MSyyFv4AUnWaEzeoMdy340VuqOVajwXWTtnbCPtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 48/76] ALSA: usb-audio: Add quirk for HP 320 FHD Webcam
Date: Tue, 12 Nov 2024 11:21:13 +0100
Message-ID: <20241112101841.613108379@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit dabc44c28f118910dea96244d903f0c270225669 upstream.

HP 320 FHD Webcam (03f0:654a) seems to have flaky firmware like other
webcam devices that don't like the frequency inquiries.  Also, Mic
Capture Volume has an invalid resolution, hence fix it to be 16 (as a
blind shot).

Link: https://bugzilla.suse.com/show_bug.cgi?id=1232768
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241105120220.5740-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c  |    1 +
 sound/usb/quirks.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1206,6 +1206,7 @@ static void volume_control_quirks(struct
 		}
 		break;
 	case USB_ID(0x1bcf, 0x2283): /* NexiGo N930AF FHD Webcam */
+	case USB_ID(0x03f0, 0x654a): /* HP 320 FHD Webcam */
 		if (!strcmp(kctl->id.name, "Mic Capture Volume")) {
 			usb_audio_info(chip,
 				"set resolution quirk: cval->res = 16\n");
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1747,6 +1747,8 @@ struct usb_audio_quirk_flags_table {
 
 static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	/* Device matches */
+	DEVICE_FLG(0x03f0, 0x654a, /* HP 320 FHD Webcam */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x041e, 0x3000, /* Creative SB Extigy */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x041e, 0x4080, /* Creative Live Cam VF0610 */


