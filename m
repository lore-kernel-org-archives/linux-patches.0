Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AA4187845;
	Mon, 12 Aug 2024 16:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480397; cv=none; b=Mb6Uj2xtxqJQ4FdBnLYumMWcG/HzPp1PuJBhq6PWOjeu6ySkFn52YZcku381Xj4BvdHNlcAzCWtxcPCVJHhaaiOXnvgl4GRV9NlWtWMmUtKN3Oy7Uoig5G2hLWb+8sSdBKmROFh8n/nXWRcvomY1yRHKTTDzfMz91UqX0tF7R9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480397; c=relaxed/simple;
	bh=7cknwIYouWmv1MkN7AJuHxvzawNT0+rYqy6gi44ZhDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhHOPpn7voyOkduvlpUN2dBqeJfOlVGmT+oPYEmEJbV4beM1OqorbgHp+EU6cK7rOWHf6hvuC/Pobav6uPzrBiaOlPjd9ecDdzk9BTDrLtJzLgKrMEJwBracwhEgjJSNk8+NcosDlAu4KSlOhmCfVeCHpx75OFIWgEjxmhGGbAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYGDkrHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYGDkrHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2726FC32782;
	Mon, 12 Aug 2024 16:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480397;
	bh=7cknwIYouWmv1MkN7AJuHxvzawNT0+rYqy6gi44ZhDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYGDkrHAxjneN5scIzkQ90Q9VbJSRIZ9RUHgjgttoowWYUCLaz/5mwI5GNyf11gJ+
	 7LX9FYxNoZgHvKx0CbOiSWYyCAwTwLiSLWk34mhnrvZ4U3dKjl3pdZzexVQ8O9O8Pm
	 gbnio5ERMr+3ug5RSSLv7BooINoQy8/nuFHA9vbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+78eccfb8b3c9a85fc6c5@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 182/263] ALSA: line6: Fix racy access to midibuf
Date: Mon, 12 Aug 2024 18:03:03 +0200
Message-ID: <20240812160153.514413303@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


