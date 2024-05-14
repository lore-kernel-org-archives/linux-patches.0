Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5216947A57;
	Tue, 14 May 2024 11:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687311; cv=none; b=NYRwOJkokQQZf43J+FBiaGE3nqYnxhgqR10YAikBqeVWiabKSt3bCPrG1KElF+moSfq/1wTmUoYdlTumRm1o3tqIQCoHsptN6VekAXDTio3ne/vCOcNguAsd1aa+VfF60F2FsF4aDnKrzpH4R1XvcTanvv/fjxckErb/LcXxCtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687311; c=relaxed/simple;
	bh=XyaNF08O0NiusxhzrQOYum0GtzXQvLqah2wGGU9HR5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3ijjDaB9YxmzmyaXAsbH/mOarSPK1/YLHn07JBXV4rXiWtC+w8geBS0qFJArLxBqJcwmar6+R0HdEGfEqv0j4jFegbiVoVnQK0LjTg9saTAzXxvYLEddewyChbZJXWjJMemv8KJXo0ygVJ3gYDJ/KhacSZiKQqY97X8/SKioek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGC9J/SH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGC9J/SH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB95C2BD10;
	Tue, 14 May 2024 11:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687311;
	bh=XyaNF08O0NiusxhzrQOYum0GtzXQvLqah2wGGU9HR5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGC9J/SHO3VHAUxi4UZmMN9iZMIqKcXXwR/5qr2/Idl5COi8EBw7XXGR5W/6gVxxl
	 4/KaIe0zNoHvM/00FcOHuNtZ/q7RWFf6dBEo9gsElY16y56dtgto4i/chUvNxl6f0P
	 M7/1zhEQPRD9AcOviD0vSEeWyqa8mKun+Wucs3FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7fb05ccf7b3d2f9617b3@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/111] ALSA: line6: Zero-initialize message buffers
Date: Tue, 14 May 2024 12:19:49 +0200
Message-ID: <20240514100959.073061401@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b67617b68e509..f4437015d43a7 100644
--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -202,7 +202,7 @@ int line6_send_raw_message_async(struct usb_line6 *line6, const char *buffer,
 	struct urb *urb;
 
 	/* create message: */
-	msg = kmalloc(sizeof(struct message), GFP_ATOMIC);
+	msg = kzalloc(sizeof(struct message), GFP_ATOMIC);
 	if (msg == NULL)
 		return -ENOMEM;
 
@@ -688,7 +688,7 @@ static int line6_init_cap_control(struct usb_line6 *line6)
 	int ret;
 
 	/* initialize USB buffers: */
-	line6->buffer_listen = kmalloc(LINE6_BUFSIZE_LISTEN, GFP_KERNEL);
+	line6->buffer_listen = kzalloc(LINE6_BUFSIZE_LISTEN, GFP_KERNEL);
 	if (!line6->buffer_listen)
 		return -ENOMEM;
 
@@ -697,7 +697,7 @@ static int line6_init_cap_control(struct usb_line6 *line6)
 		return -ENOMEM;
 
 	if (line6->properties->capabilities & LINE6_CAP_CONTROL_MIDI) {
-		line6->buffer_message = kmalloc(LINE6_MIDI_MESSAGE_MAXLEN, GFP_KERNEL);
+		line6->buffer_message = kzalloc(LINE6_MIDI_MESSAGE_MAXLEN, GFP_KERNEL);
 		if (!line6->buffer_message)
 			return -ENOMEM;
 
-- 
2.43.0



