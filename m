Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD877477E51;
	Tue, 16 Jun 2026 17:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632726; cv=none; b=hEyaQ+USr6v9ZCgyGAh6VFeM5twhWh7ViPIQWnfWLPVjJjTbm2O14UgLddvGr0JbtTXalcJlROWkrEu+d9wlan/gGr86ALpVFxUN1aiYnWWtL0AS100GYxpfMxstU0Sj1NCBRB7koTW3I5B3aLofhj1o7jmvrP/Cc8rZSb+pUTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632726; c=relaxed/simple;
	bh=QX78Yz8i+NYLcpGwU1pzlfEb12JBUXhsLFGzxU1YL20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tW3kcTBr9dbmjY62M3rUEIvcgEFoGudEKaXSscXnJrYPpKDEQDU6IafkGKAJ8Yt6NyPuTnU0NXIseSuTTu5ysDJSgstP/Pacsxi+A8Jz4zbYRtti3p95Ed2FEtFoSh9jULhThmyKcdmWqAkouyk/pux/ZViJxMp7zVHIA2Au+yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGlp9Glp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGlp9Glp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955EE1F000E9;
	Tue, 16 Jun 2026 17:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632725;
	bh=B8PieQh1ALl9Z9VUyb+SbY72qmHnE7c690JE0EkQP7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGlp9GlptQu1e4FpHOWV2iQM9z82FGKWXoBbE5v5YVcsP/cTPZFQ3opKWW8aV1P0u
	 rhzjonHtp8YoHtuatFbaOEhtgRdsz8ZIzjgC/WzglFZJXkpf2zCYA6Hfu8PUyZ77rw
	 evymMiwWI7pM7ABRIB9AvAEBOXfeAA3OvwCcsqNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 465/522] ALSA: firewire-motu: Protect register DSP event queue positions
Date: Tue, 16 Jun 2026 20:30:12 +0530
Message-ID: <20260616145147.629077281@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 98fb1c1bb11e29eb609b7200a25e136e05aa4498 ]

The register DSP event queue is updated under parser->lock, but
snd_motu_register_dsp_message_parser_count_event() reads pull_pos and
push_pos without the lock.
snd_motu_register_dsp_message_parser_copy_event() also reads both queue
positions before taking the lock.

Protect these accesses with parser->lock as well. This keeps the hwdep
poll/read path consistent with the producer side and with the cached
meter/parameter accessors.

Fixes: 634ec0b2906e ("ALSA: firewire-motu: notify event for parameter change in register DSP model")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260521-alsa-firewire-motu-event-locking-v1-1-708e1c2b5e56@gmail.com
[ converted copy_event() from manual spin_lock_irqsave/spin_unlock_irqrestore to guard(spinlock_irqsave) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/motu/motu-register-dsp-message-parser.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/sound/firewire/motu/motu-register-dsp-message-parser.c
+++ b/sound/firewire/motu/motu-register-dsp-message-parser.c
@@ -390,6 +390,8 @@ unsigned int snd_motu_register_dsp_messa
 {
 	struct msg_parser *parser = motu->message_parser;
 
+	guard(spinlock_irqsave)(&parser->lock);
+
 	if (parser->pull_pos > parser->push_pos)
 		return EVENT_QUEUE_SIZE - parser->pull_pos + parser->push_pos;
 	else
@@ -399,14 +401,14 @@ unsigned int snd_motu_register_dsp_messa
 bool snd_motu_register_dsp_message_parser_copy_event(struct snd_motu *motu, u32 *event)
 {
 	struct msg_parser *parser = motu->message_parser;
-	unsigned int pos = parser->pull_pos;
-	unsigned long flags;
+	unsigned int pos;
 
-	if (pos == parser->push_pos)
-		return false;
+	guard(spinlock_irqsave)(&parser->lock);
 
-	spin_lock_irqsave(&parser->lock, flags);
+	if (parser->pull_pos == parser->push_pos)
+		return false;
 
+	pos = parser->pull_pos;
 	*event = parser->event_queue[pos];
 
 	++pos;
@@ -414,7 +416,5 @@ bool snd_motu_register_dsp_message_parse
 		pos = 0;
 	parser->pull_pos = pos;
 
-	spin_unlock_irqrestore(&parser->lock, flags);
-
 	return true;
 }


