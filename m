Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896D153A7;
	Fri,  6 Dec 2024 15:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497399; cv=none; b=L9YbRbyKDMbAKf6KiQ+p3tmy7b/E3p7ftL/3lOq90bqq/1pYhZhKnZBw7A8+WQLv+kXDU5syxXzFGTWgL8UAgrEatfK4YYSipBo8eIKcOiQAt/tOHjSoavcWfO22ozeTIdC3IMWWOFX8dKDylRKl7JsXgVKGyFLOFGE6sQBXoO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497399; c=relaxed/simple;
	bh=48oyk/IfRcL1qAjuSn7FmyQmO5Q+N0ksXPSoVePQFJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUbW1vgjYV08C0Y0XOuNB1Yz/0BRQQdAneXBi06SqT1ucTbqeXFIce0xwMNhcIgo3ctb+FFkNjElLu1hp5botCZ+L3JH8HVUWq2QMCJXHYef+PmZlpRab1R7LM6cDg1JKSVnTQrznWbHpRhbUvZGrNgj576mqoXF1bxHQnvp8ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzUjX2pX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzUjX2pX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0C4C4CED1;
	Fri,  6 Dec 2024 15:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497399;
	bh=48oyk/IfRcL1qAjuSn7FmyQmO5Q+N0ksXPSoVePQFJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzUjX2pXDwL9NLCJKT4MpLxQxXjAAzd4IKVK+T/fF5eVt3JvI9UNBSuXjZV/uC6kX
	 nWH7vQzLg1mZSbmx6hhiH90UhzQ7dkNhhKQhFIMemZ32vxRcRS6TvptLNI+i01l6k1
	 wx+Ocl2srZLkUOnglUcZeKUjfXkCNId8A8L4Ecgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+73582d08864d8268b6fd@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 249/676] ALSA: usx2y: Use snd_card_free_when_closed() at disconnection
Date: Fri,  6 Dec 2024 15:31:08 +0100
Message-ID: <20241206143703.058459414@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit dafb28f02be407e07a6f679e922a626592b481b0 ]

The USB disconnect callback is supposed to be short and not too-long
waiting.  OTOH, the current code uses snd_card_free() at
disconnection, but this waits for the close of all used fds, hence it
can take long.  It eventually blocks the upper layer USB ioctls, which
may trigger a soft lockup.

An easy workaround is to replace snd_card_free() with
snd_card_free_when_closed().  This variant returns immediately while
the release of resources is done asynchronously by the card device
release at the last close.

Fixes: 230cd5e24853 ("[ALSA] prevent oops & dead keyboard on usb unplugging while the device is be ing used")
Reported-by: syzbot+73582d08864d8268b6fd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=73582d08864d8268b6fd
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241113111042.15058-2-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usbusx2y.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index 52f4e6652407d..4c4ce0319d624 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -423,7 +423,7 @@ static void snd_usx2y_disconnect(struct usb_interface *intf)
 	}
 	if (usx2y->us428ctls_sharedmem)
 		wake_up(&usx2y->us428ctls_wait_queue_head);
-	snd_card_free(card);
+	snd_card_free_when_closed(card);
 }
 
 static int snd_usx2y_probe(struct usb_interface *intf,
-- 
2.43.0



