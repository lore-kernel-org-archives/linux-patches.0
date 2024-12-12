Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD672253EC;
	Thu, 12 Dec 2024 16:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022286; cv=none; b=G1Op/+p/r4bXJHpMlwYAjqby/UIpOgHYKwKr/H60jBM41mjTm7oRRNbWtnCAa05nkzX38y626y3dhnffS5a9OXQhHdp7UBuc1iSZE6iHjVFxmc0c18rKf21nfZniIe8yQDF4v8EhE0+XLb++hio11GE63pZBRwhiBiBk3zDKIPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022286; c=relaxed/simple;
	bh=0Y2o9VoCzDGQYtQhU9cV4PWt0wLv8UqxuKin3TCyXWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p40wbjLfPJKbWdDEHroo4PNfhUBBB955hZc1mHG0CcQoVvhl2aj6YS/9vaP17wuz2uLxtX72qLwTkQcTD6lzz+Ok8P8+elVhwS3L75buBWQezsj38dNijg4CS/rJWioBTjUMdX5K+Aq7ImVgmtBuTfL9W2CTg+nB3RWC1djBtVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwMafnO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwMafnO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7039C4CECE;
	Thu, 12 Dec 2024 16:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022286;
	bh=0Y2o9VoCzDGQYtQhU9cV4PWt0wLv8UqxuKin3TCyXWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwMafnO5bavDbzXMtJ2hC00nNNdEPin1QRnFoUdTHKG5A2wTfP3QaTPtxDliIY96b
	 C68o0XUm7ndiWzdVPOYW6Rzvt7qhZtJ0CqyaDq6Gcf+QVTAAl4ueTuJtSUlWCT5zNN
	 JY30lZXX649zynLhQOWp5uyUr+B3b51tuN1WynKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+73582d08864d8268b6fd@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 200/565] ALSA: usx2y: Use snd_card_free_when_closed() at disconnection
Date: Thu, 12 Dec 2024 15:56:35 +0100
Message-ID: <20241212144319.399297075@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
index 099bee662af6b..c3292afa883ee 100644
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



