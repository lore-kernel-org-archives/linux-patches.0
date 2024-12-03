Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D4C153800;
	Tue,  3 Dec 2024 15:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241126; cv=none; b=qX9I9wumNbcIT0BHEYUBPHVym5wcCjkHr3TUC0BX5InVCbl8lYO3iCqL+7O+6rcTjQUy97SI8myD89c34EAlp2UhmFO7jVj4vaPR6h1857N5tt7RBlEexK/3RHw7+2ctxZ5avf/Xpmvupop2hFPX9g5za3HkQtvsdozrJjr0d1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241126; c=relaxed/simple;
	bh=aRY7GYAUGa2hjtulzrM66B99NMvUmxjZ5GVGTM5hb5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1q10+EYsgS2tmahqnUJZYIsye0WR3wvvL2PfZDnSXuXlbqDcP8+fj7tInF7U+tJ/AHl2v5uvMD/G1xdgb7zHyCcDoaTt/L5JBsbaRgkacPq6yQ5UJGG1wEF26gj2DpWOb4n11xJJLd7oDvZC+Do3xCCZeQGK4bAdyBdwXiwMgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYP2dFTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYP2dFTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549ECC4CECF;
	Tue,  3 Dec 2024 15:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241125;
	bh=aRY7GYAUGa2hjtulzrM66B99NMvUmxjZ5GVGTM5hb5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYP2dFTVqzpmQ9JOfJoaWt1d5PnojCMXu6xxO7jEOfNN87CKKoTX3iLHzFk/XwkuB
	 qpWWT7ImUGBB3/BIYMnqPzpWDk8axU086gvWpro2kuGDWXX0YI9tvrPUtgMKq0Uw5n
	 ukG8zlwCpyV0vTPlMnPy/T6zH+zqwPtWwUqql7l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 332/826] ALSA: us122l: Use snd_card_free_when_closed() at disconnection
Date: Tue,  3 Dec 2024 15:40:59 +0100
Message-ID: <20241203144756.710955281@linuxfoundation.org>
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
index 1be0e980feb95..ca5fac03ec798 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -606,10 +606,7 @@ static void snd_us122l_disconnect(struct usb_interface *intf)
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



