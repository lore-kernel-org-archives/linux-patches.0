Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A51019F470;
	Thu, 15 Aug 2024 14:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730468; cv=none; b=htpXwiDI9lvYpZk4ty2vxnk4sBmQnYnCavCcF2Jrn89HAddFBzC6VausLo6fWf4dMxQ88aEeCr6ooNTMYUqTrDAPJLGKCyzRvOJaYCeBvSfC6VuDTqKiSI4IHTA8eWAQO1FkJt4Awo57dLH3fnP15/qLwmaavQvLhvSuaEviVE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730468; c=relaxed/simple;
	bh=nEYaz89FN6WHQfedJ2lmvuv43WDFwWi1M3uS6XmPc8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KN3s161JfDVN8zbxjPMeOS8h+TqoghmLuRKPX172VCqAoIcNoXFPbtUeh1N2SDwUY8RHaguHAN0ujKTQU+/i1o7oIP3fmzeNcgrY8fTyVvPezbKtIbZhoevWgthfCFbd1YYTK8P83ltS7EwyvfsnptEWgn1Tg+tSq9PC6QDOs9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FECW2SO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FECW2SO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA9FC32786;
	Thu, 15 Aug 2024 14:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730468;
	bh=nEYaz89FN6WHQfedJ2lmvuv43WDFwWi1M3uS6XmPc8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FECW2SOxMQGUYf0uje5iFNbQvG6+thWNorchI1pt3hXLSvQbkhEOjvvaS7+8fIwy
	 L21DOsDqM+jt5/YEAniiuSPa3sUQsQ5BUTa1lv62FIAnHZWHhg3FVuawXlIewU7mRd
	 E9R4Wqp9wE8A7WRmiLcWYSfRdYPW88CJZ6EbCZTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+78eccfb8b3c9a85fc6c5@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 417/484] ALSA: line6: Fix racy access to midibuf
Date: Thu, 15 Aug 2024 15:24:35 +0200
Message-ID: <20240815131957.559134839@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

commit 15b7a03205b31bc5623378c190d22b7ff60026f1 upstream.

There can be concurrent accesses to line6 midibuf from both the URB
completion callback and the rawmidi API access.  This could be a cause
of KMSAN warning triggered by syzkaller below (so put as reported-by
here).

This patch protects the midibuf call of the former code path with a
spinlock for avoiding the possible races.

Reported-by: syzbot+78eccfb8b3c9a85fc6c5@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/00000000000000949c061df288c5@google.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240805130129.10872-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/line6/driver.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -286,12 +286,14 @@ static void line6_data_received(struct u
 {
 	struct usb_line6 *line6 = (struct usb_line6 *)urb->context;
 	struct midi_buffer *mb = &line6->line6midi->midibuf_in;
+	unsigned long flags;
 	int done;
 
 	if (urb->status == -ESHUTDOWN)
 		return;
 
 	if (line6->properties->capabilities & LINE6_CAP_CONTROL_MIDI) {
+		spin_lock_irqsave(&line6->line6midi->lock, flags);
 		done =
 			line6_midibuf_write(mb, urb->transfer_buffer, urb->actual_length);
 
@@ -300,12 +302,15 @@ static void line6_data_received(struct u
 			dev_dbg(line6->ifcdev, "%d %d buffer overflow - message skipped\n",
 				done, urb->actual_length);
 		}
+		spin_unlock_irqrestore(&line6->line6midi->lock, flags);
 
 		for (;;) {
+			spin_lock_irqsave(&line6->line6midi->lock, flags);
 			done =
 				line6_midibuf_read(mb, line6->buffer_message,
 						   LINE6_MIDI_MESSAGE_MAXLEN,
 						   LINE6_MIDIBUF_READ_RX);
+			spin_unlock_irqrestore(&line6->line6midi->lock, flags);
 
 			if (done <= 0)
 				break;


