Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765CE223C65;
	Thu, 12 Dec 2024 16:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019488; cv=none; b=GPPN3Fxfj/b5COi+OP2rbuB+ObZlOxQA0HbIx5/u48bdC8d1GIOY6mwgR+dndR0XLXaRS8mpeHtKdBkPveE93c12nPT136xijU6tDEgiX7c+J2kpWLYKPu3Qecu+Hjn619qXhGtrAAcQKzaBvoXwXEtvSl1GAvmqCmz8GnjnlOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019488; c=relaxed/simple;
	bh=STQsrYBYxYjRGYPd0BGLpHza6ztcuzF6Ht5EE2wD9MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPfZ9mord1Rj5DJiygdpMxW2sCta/QUcSI/CQZEEn62lQ0BzRywgV00z3twjR6WywQO8pNpBrC76is010BGVNRnoEdsnVJV/p03fflsHZZHlyUcSb0On0rqVIAthcTI0LSOSSJ5PnbKv4xprnmf5q6xQ+zwoLbygrOPqz+gBCEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dh7vNY7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dh7vNY7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA073C4CED3;
	Thu, 12 Dec 2024 16:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019488;
	bh=STQsrYBYxYjRGYPd0BGLpHza6ztcuzF6Ht5EE2wD9MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dh7vNY7ocJQjnQRnlf6qTVOwIY/lCl9wrNYITi6ti7SwWYOLkVreLf3SaQEP2r+lZ
	 hcPAgtCp7E7AuV336rZtRpXne7FH3wgQROmGeG/aFc3QfHkUQE6e4Hb2jJ+k0aYqcG
	 tt3MeN3wOPJgdC8+S01PoKG5CS5Vfc7pztYiaVXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+73582d08864d8268b6fd@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/772] ALSA: usx2y: Use snd_card_free_when_closed() at disconnection
Date: Thu, 12 Dec 2024 15:52:18 +0100
Message-ID: <20241212144357.917022934@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



