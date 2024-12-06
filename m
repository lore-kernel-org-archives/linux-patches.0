Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BAC53A7;
	Fri,  6 Dec 2024 15:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497403; cv=none; b=p8yAznDoV4BX1mmHIZzOitdI4WHLZUsVio/F6NVjC2b8juBqsjN6GHuak1XdrRqm/3dK0UFnGyuj6w+NEIJOMRHCC/H9zv4NHpiPd9UG5XmUarMzp4P6au1nFnqv235ryMxR4+oWirfOVUMWE2amWWU8JQS5IWOSh0UK1phmbH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497403; c=relaxed/simple;
	bh=Zoyedq/CyoBoPT0BgCKnFIjKOY+ruwzNOgqrHKvghCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBteEhJ8wcZkpJfWtqMKWxKBF1fBT/s0OHOKAjUAX/WpmsM+ADze8o5xmWUwqK2SzT1eTSnaWEUFv5pBcy767rZVjJLDoPyJeaBYHtYPAsmZJmrxUNGrKkKrfXVUJm6/Q7KZyCKFsLU1NHQWTwwQlpfz4y6f6Lpg1al4hnw+PPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2MZnrTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2MZnrTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AA2C4CED1;
	Fri,  6 Dec 2024 15:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497402;
	bh=Zoyedq/CyoBoPT0BgCKnFIjKOY+ruwzNOgqrHKvghCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2MZnrTZ5pcPyiDBLzuoc/tANKAAPCzGFznovK1pxV/tbZNwpkVA4Xkf2wa4nGNu7
	 52Qkx2ENOthkeIU+jUP3Hy+TitHkAHL7qhmCatlCVkUfPKGJ9tOFIDGlRyZHuCx+6d
	 aCBwqXQTSv8Xu2rl+TbQtHiinTLaTHMqip98tzxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 250/676] ALSA: us122l: Use snd_card_free_when_closed() at disconnection
Date: Fri,  6 Dec 2024 15:31:09 +0100
Message-ID: <20241206143703.097132186@linuxfoundation.org>
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

[ Upstream commit b7df09bb348016943f56b09dcaafe221e3f73947 ]

The USB disconnect callback is supposed to be short and not too-long
waiting.  OTOH, the current code uses snd_card_free() at
disconnection, but this waits for the close of all used fds, hence it
can take long.  It eventually blocks the upper layer USB ioctls, which
may trigger a soft lockup.

An easy workaround is to replace snd_card_free() with
snd_card_free_when_closed().  This variant returns immediately while
the release of resources is done asynchronously by the card device
release at the last close.

The loop of us122l->mmap_count check is dropped as well.  The check is
useless for the asynchronous operation with *_when_closed().

Fixes: 030a07e44129 ("ALSA: Add USB US122L driver")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241113111042.15058-3-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/us122l.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index 709ccad972e2f..612047ca5fe7a 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -617,10 +617,7 @@ static void snd_us122l_disconnect(struct usb_interface *intf)
 	usb_put_intf(usb_ifnum_to_if(us122l->dev, 1));
 	usb_put_dev(us122l->dev);
 
-	while (atomic_read(&us122l->mmap_count))
-		msleep(500);
-
-	snd_card_free(card);
+	snd_card_free_when_closed(card);
 }
 
 static int snd_us122l_suspend(struct usb_interface *intf, pm_message_t message)
-- 
2.43.0



