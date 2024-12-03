Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EA2153800;
	Tue,  3 Dec 2024 15:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241122; cv=none; b=k2pjb29NPVnypofyDJYSc98SWGLbSogvWkoedZBo4lERcT4WM/BjueDwJHj13M8pkOEssReyj6xn9mnzRLfJ5nDKaE4Sn7NursLK+tBdvjrpMdTCuHQ/E8YLAt8AyeQi2Fit02Y04dh0yVtMroLUz5LKeYIdnkVHeAnkKOP2XL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241122; c=relaxed/simple;
	bh=fg+kbkfeV8V+m9ramrnewdPJuNh8HRQd3AStv3OG3TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xq0aXsF9thPdIN38aGHrU4IgF+SBwgSil4QDlwwiXEpGMlenF/8ZUa1Pq9a5RE5JrTXLsCyAkFpPQwNqU2STFr2/Tqm6JeusYFOjDNAK9Eta00iytwS83u7JGGd+H5ZHg2jP1KwS5g1kSBSOyHSzBLpWnfrMGkmhJpO20btcAOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEOBzr9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEOBzr9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC3AC4CECF;
	Tue,  3 Dec 2024 15:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241122;
	bh=fg+kbkfeV8V+m9ramrnewdPJuNh8HRQd3AStv3OG3TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEOBzr9Ke+MxoLFeZBMR8FUqz3vBONui8PcL1jPVedKj7ChLwvL2dOZ/69JJ7fpyG
	 0WaXNRDC2U2K+bJ9G5bowjT5jj+xUqxTDgUBSAL1eqDrl1atYj2msxxIyw/ta5wZeW
	 nw9aFgvSrSuNiu/YQAeGX9N4VrpHrIdkxmIueh74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+73582d08864d8268b6fd@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 331/826] ALSA: usx2y: Use snd_card_free_when_closed() at disconnection
Date: Tue,  3 Dec 2024 15:40:58 +0100
Message-ID: <20241203144756.671478586@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2f9cede242b3a..5f81c68fd42b6 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -422,7 +422,7 @@ static void snd_usx2y_disconnect(struct usb_interface *intf)
 	}
 	if (usx2y->us428ctls_sharedmem)
 		wake_up(&usx2y->us428ctls_wait_queue_head);
-	snd_card_free(card);
+	snd_card_free_when_closed(card);
 }
 
 static int snd_usx2y_probe(struct usb_interface *intf,
-- 
2.43.0



