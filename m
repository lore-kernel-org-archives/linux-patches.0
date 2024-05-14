Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B81139596;
	Tue, 14 May 2024 11:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687024; cv=none; b=q1RfYzku2cUMLZqOsL3hyi8EQecfq32orRFjYPd87+XPy0za3qmKu3dVCVwT4Iro8YD28T/SyNe0Ktzr962SkNaN3GGbHOTLNtZjfRI76A9pjqoSrcQObiu0oML48JCmwRJy9hEVQWQKIrHIIBpl7xDIejV0My8hhCbu3KgR4Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687024; c=relaxed/simple;
	bh=ZdD2h/Gf5EniYxrQCd7Z9R3BfJe4gDGwUHnxrPZpHvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZmCmTj1Jd2WCjEzzPpjg1cVgHEGxVjlIzDj+izb/LuRzDOWMNHfDkNuFEacKIpD8z0INLl0nZymLTL0hr06xTXMQygAoUFkQK3TXBIFUroskUC0M1UOaJzLf/oQV/uJxhI9FhzBPOreV77mg5p5lbOC0VUwzj0aR3k08YSUxOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5uvyGG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5uvyGG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B575C2BD10;
	Tue, 14 May 2024 11:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687024;
	bh=ZdD2h/Gf5EniYxrQCd7Z9R3BfJe4gDGwUHnxrPZpHvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5uvyGG01mAeX8+18DUSLGVj8S9Tz9NlDnOjhSdmKyO4LUNodBkg/SA/XzN7Bj4nt
	 BCLA6ntoQJsZvjHFeA5ngLyUz1uv0aEJ6PlVJMSJw9DNA+Lxe0hYZQ5bfzxulcGZzS
	 vpgUsRwWwbgDLGwITmInN3Et6sWqydwEglfYRxTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7fb05ccf7b3d2f9617b3@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 39/84] ALSA: line6: Zero-initialize message buffers
Date: Tue, 14 May 2024 12:19:50 +0200
Message-ID: <20240514100953.162208009@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit c4e51e424e2c772ce1836912a8b0b87cd61bc9d5 ]

For shutting up spurious KMSAN uninit-value warnings, just replace
kmalloc() calls with kzalloc() for the buffers used for
communications.  There should be no real issue with the original code,
but it's still better to cover.

Reported-by: syzbot+7fb05ccf7b3d2f9617b3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/00000000000084b18706150bcca5@google.com
Message-ID: <20240402063628.26609-1-tiwai@suse.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/line6/driver.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/line6/driver.c b/sound/usb/line6/driver.c
index 22104cb84b1ca..efa8fb59d3ad2 100644
--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -201,7 +201,7 @@ int line6_send_raw_message_async(struct usb_line6 *line6, const char *buffer,
 	struct urb *urb;
 
 	/* create message: */
-	msg = kmalloc(sizeof(struct message), GFP_ATOMIC);
+	msg = kzalloc(sizeof(struct message), GFP_ATOMIC);
 	if (msg == NULL)
 		return -ENOMEM;
 
@@ -679,7 +679,7 @@ static int line6_init_cap_control(struct usb_line6 *line6)
 	int ret;
 
 	/* initialize USB buffers: */
-	line6->buffer_listen = kmalloc(LINE6_BUFSIZE_LISTEN, GFP_KERNEL);
+	line6->buffer_listen = kzalloc(LINE6_BUFSIZE_LISTEN, GFP_KERNEL);
 	if (!line6->buffer_listen)
 		return -ENOMEM;
 
@@ -688,7 +688,7 @@ static int line6_init_cap_control(struct usb_line6 *line6)
 		return -ENOMEM;
 
 	if (line6->properties->capabilities & LINE6_CAP_CONTROL_MIDI) {
-		line6->buffer_message = kmalloc(LINE6_MIDI_MESSAGE_MAXLEN, GFP_KERNEL);
+		line6->buffer_message = kzalloc(LINE6_MIDI_MESSAGE_MAXLEN, GFP_KERNEL);
 		if (!line6->buffer_message)
 			return -ENOMEM;
 
-- 
2.43.0



