Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB22176AA1;
	Thu, 12 Dec 2024 17:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024097; cv=none; b=CV30Zzy7THIbglmTGmfk941NuMnXrwX7je4wxJWWMa+30K7nCfjXinvZ4kU2hv2qaSCorkbO9CmWVaVugh+/nL4CrFYDZqTDxT4gux1uHbbX6kP7B6BpPYxDGV3mAjQCGn70PH9nW8jeyjWvG+os9e/1GPQNTOt/kzeZJlmYL7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024097; c=relaxed/simple;
	bh=sGriJpqdwVvOZZeM7p6BZOfsCcj+p1Hpcyu3n/V0T6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwybRzx2i4SiKfOuTlPBaUybqeDwLfPXwg6y5M48tdWGrjANTTfsRflILVHCNLkcJnwvUf2s+hO0wIPzHy9HmrOTpWyBGiIv7udRbO032rsJmvjTfApqW0AUWuQuIvAi2i0wDaDbWD2tTX55iNHJ7txAr9LUsoLzliICePUKi98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFt3qbc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFt3qbc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83702C4CECE;
	Thu, 12 Dec 2024 17:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024096;
	bh=sGriJpqdwVvOZZeM7p6BZOfsCcj+p1Hpcyu3n/V0T6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFt3qbc0rP2W12ynepX4Rqh0Xd1agCX442OwNCfUnHfT949y6pjkhNM3wOW50rDwW
	 W0hjeSxtcw4EG8hDOe3epyC4N+KsNWrj+t5aN4VMmQxFeRvAiT1EyJaTrE9xyYhrFx
	 IvJADS10X4789qSRY9f3e7MPVPh7KKk5q1go7how=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+73582d08864d8268b6fd@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/459] ALSA: usx2y: Use snd_card_free_when_closed() at disconnection
Date: Thu, 12 Dec 2024 15:58:13 +0100
Message-ID: <20241212144259.640539865@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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
index 9d5a33c4ff2f3..c567e58ceb4fd 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -396,7 +396,7 @@ static void snd_usx2y_disconnect(struct usb_interface *intf)
 	}
 	if (usx2y->us428ctls_sharedmem)
 		wake_up(&usx2y->us428ctls_wait_queue_head);
-	snd_card_free(card);
+	snd_card_free_when_closed(card);
 }
 
 static int snd_usx2y_probe(struct usb_interface *intf,
-- 
2.43.0



