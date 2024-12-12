Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2D020A5EE;
	Thu, 12 Dec 2024 17:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025267; cv=none; b=d6/T+2xsxdKNyoUsCnosXgZQcaPTbqZpsvf8FW17WqcEU78yCUsL6h1UqMVejv00FgKQaSVFbAU3/E7esFuxYKkjZP3KQ6eyYwWSMeIihfHOEUT0VqIE5fmpjKAKhmLqjkVeG4ovTexYcYxSJw7ouuXI8E3LAaH37+YOjldw3g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025267; c=relaxed/simple;
	bh=bqfOXGQFLp3zbhkmG69pDFno37rmDaL/yoitf6iI6yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/1UDlwb6nN85nvOjDaNi5oM5w4aFtwvB4zxHGeb8Ws2geSd91slTdjHikf1D8rPe7qcENZDd8RMKqfcVWBiPoEMXFQgSG36iaLolT9EyZ4BefmS6qyxNsvhPLRwG4movJ0+nbYNriz9BilISe5Fq2Vn0YfzthVc5lKcA6df3rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IA+RGu1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IA+RGu1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25B9C4CECE;
	Thu, 12 Dec 2024 17:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025267;
	bh=bqfOXGQFLp3zbhkmG69pDFno37rmDaL/yoitf6iI6yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IA+RGu1dHWd9ePRsC7Ua6Uf9WGAKNZLFCXPm0xYty138Qq0VQAPLvAMGv2j5VeIFt
	 cvVv68rYvT9lByl9PPKwfBlsQ7CW28bbGr16TCbI9NROQ9Fy4iKZk9Zts9VNGMF9iU
	 eGliyowfCH8CkgSUJ6Nre3s9JOQTpDP5GhFNFZl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/321] ALSA: us122l: Use snd_card_free_when_closed() at disconnection
Date: Thu, 12 Dec 2024 16:00:00 +0100
Message-ID: <20241212144233.223338813@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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
index e82c5236482df..eb7e57c4a7fdb 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -636,10 +636,7 @@ static void snd_us122l_disconnect(struct usb_interface *intf)
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



