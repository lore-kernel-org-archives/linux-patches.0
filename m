Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216345;
	b=SK46OHaHFteUWCQvzWwQ3A4d3/DRWSdsyUx6tlLTnS3TEwP8FdbPPKAtnWPun5DfWzbo
	 c55AxTI/7ZeRo56FwESV3xDFS17n7CwRhSnsbWO03Jm08Aciee9X1z2LhcQGrzzXaWFld
	 6tcBEmzNXZ5isC7iK5Vcgzpu/oJY4wk7QpdcYUEsi3jDicT8+A4i2BfWVWR4QbDm8oGOW
	 MZgJsMFE9x0mZJ3PbrLXoKC7lwX6WsJ9GmGCvFpqqJK5UAcr1u85XCYv9f3Mjs0kknJ95
	 m1S8RX/BrPL7zd+4V9LkRDW23dj80lrYxb9H6sqsUdcYrsRG/2Ae1WW5uUU3lg+myeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VOi0UQw8bl/w/3DGSC6cywf6bB7dsnVg5uZNem22FWs=;
	b=X82xyy+CNbF5jeno3u2sQ8FTKQb088rywWtvJQVHJjve4q2EnC0T+gxwq1s1CGzXB7o1
	 z5WoShgGADb+F/runuzkrfpTI8KFPFW6xwD9BlzcNHSHy2SNSyiaWc9erF+UyZ6k9xtah
	 SYoQXRUPycri4CjXVfOndhgsTVHxUlCwGxGESOl6ECyPFZqUL50LU6MzAbPXl2DB0icua
	 AivGEBAgCNn2nkuoIgUt4k2VH5y9m2KPIjL7xi599imqjvw8plddQTOEUHIq8Tn2rrIiO
	 KklJvwrgEN66tvGEIsSeMTgTl3sBRWetSVNdcbWu+3uknxOKaSUdf+y5RAnW4bcfKwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RsI3fzYa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D86606A31C;
	Wed, 28 Oct 2026 19:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RsI3fzYa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C2C1F01825;
	Wed, 28 Oct 2026 19:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216345;
	bh=VOi0UQw8bl/w/3DGSC6cywf6bB7dsnVg5uZNem22FWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RsI3fzYa2J8Fre7T3VqHQHtR7/x0cRCQIRZqkY1q3N7D7tJDSVsTb2zLxixjDAuqj
	 6AafeAcxON6td8L9Cy9KPv17IKk3XHbvJHcpDn6bXM310oaZlyN9/I6PPNC+3XSOiz
	 kccv+N6y5wN9/F+0tGMjSwch8dTMzhmegQAx6lFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1526/1887] ALSA: mtpav: shut down output timer before card teardown
Date: Wed, 28 Oct 2026 18:00:22 +0100
Message-ID: <20261028170534.187921330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit c73cb5b7c159246dd572277c668851a56e516019 ]

snd_mtpav_output_timer() rearms chip->timer while holding
chip->spinlock and accesses the card-private mtpav state.

snd_mtpav_free() currently takes the same lock and calls
timer_delete() when the timer is active. This only removes a
pending timer; it does not wait for a callback that is already
running and does not prevent the callback from rearming the timer.

A callback running on another CPU can therefore continue after
snd_mtpav_free() releases the lock and access the card-private
state while the card is being torn down. It can also rearm the
timer after timer_delete() has returned.

Call timer_shutdown_sync() without holding chip->spinlock. This
waits for any running callback to finish and prevents further
rearming before the card-private mtpav state is released.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260820112749.9195-1-runyu.xiao@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/mtpav.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/sound/drivers/mtpav.c b/sound/drivers/mtpav.c
index f212f233ea618..1fb6797fa45f8 100644
--- a/sound/drivers/mtpav.c
+++ b/sound/drivers/mtpav.c
@@ -663,12 +663,8 @@ static int snd_mtpav_get_RAWMIDI(struct mtpav *mcard)
 static void snd_mtpav_free(struct snd_card *card)
 {
 	struct mtpav *crd = card->private_data;
-	unsigned long flags;
 
-	spin_lock_irqsave(&crd->spinlock, flags);
-	if (crd->istimer > 0)
-		snd_mtpav_remove_output_timer(crd);
-	spin_unlock_irqrestore(&crd->spinlock, flags);
+	timer_shutdown_sync(&crd->timer);
 }
 
 /*
-- 
2.53.0



