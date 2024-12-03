Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EED1F8903;
	Tue,  3 Dec 2024 15:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238649; cv=none; b=Rf7B8L8HnVb+Xo3JYp1pGqWX6dHnKrTjfAjqkE+Ctyt6baEdeU7xopgWxR5SBnxu95gcUEt/EJNr3Nn6zIg106m/Qh3PnSDogO6tolb8aHjwM7dN6bvKrVxyx98TbxfwFcozWQT7XsLU54JaJUvhPLO6/U9NMXrfkLnNLKAfw/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238649; c=relaxed/simple;
	bh=Dr1QCDz8npQl0Lj0wAa0gxHhWOUcADxr1qGZYkMQv+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGug0G8CZZC91gdMECZL9ScgSxMWqSFuBX4duUMKC2gNPq9uV9zhDmJcnndi5Tgi0FIuJMLR4q7rrScVNK0RFFXn5TKpiY4W25DkCuRc6j4+RXp+0UMB03OdToAnv4x9yWeY6ORb3DYWrxrz1G7C1FalCEvn1jsPpmuPyW3toDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPaNgc8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPaNgc8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAB9C4CECF;
	Tue,  3 Dec 2024 15:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238649;
	bh=Dr1QCDz8npQl0Lj0wAa0gxHhWOUcADxr1qGZYkMQv+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPaNgc8yzZwDoLYrOzrwfIWZhQqzqHVmb7cvFzk8il6EYxtSsls1/HXvIlWfEsv8g
	 sHwmWRg+Ordf4ccGSyDhcDosxcbdI9aBAO3YqGjurgXYmG4PReAGENjQ+eqB4vXZBc
	 jQlsmFNFojpS/e0LJZt1OQNn1wFMahX8HZTLsMc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 351/817] ALSA: us122l: Use snd_card_free_when_closed() at disconnection
Date: Tue,  3 Dec 2024 15:38:43 +0100
Message-ID: <20241203144009.529295976@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



