Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D67870808;
	Sun,  7 Jun 2026 10:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828951; cv=none; b=AUlFZ7EkKgsJu6vUnFT36m1iR1Tn9oymSEfueJeWr1Vy2II1enmf+aOmF3rUfD2ICwilrMqIx+mQmD06eXx45e02LlgTZA3YUzCWL6MNxVRoDmqg8z48socUb6OsfDRYN9qwVLOsNZ4tNtgb/sbqE3A0qvIUzUj5YnXXizpWLD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828951; c=relaxed/simple;
	bh=eMvw+OFK8YnLQDF4TD+h5FCy6IP7P6puTAZrGbiNCzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lEQL/2rVCl/b9xtASG3wQkJ7yvSTCwm316KP0avPoDJAz7DnKFxDpkA1DwBcuvxGfiZbXIBJ2pds7jL2aVlP/DXpKrK0cTqidkbfoKgBCpzdHcO02tCi6kkS7FMW9e7ie0VayA7T4HPeYAuq8MwagRBS1kSq1/85d/qBnvDGQCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfr9LJ/I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfr9LJ/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC431F00893;
	Sun,  7 Jun 2026 10:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828949;
	bh=WZ+qRCYTJz3eWJL8OSzVO3BMLzgdyOnH7pdNtnYuNew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bfr9LJ/Ica5akJHS50+wxMFATVpyR9puhrrInHcE1ZTD3bMT5vWiLdf38n62mnAc5
	 le7eWDToYUEtJrtY8Qf/Pdf1xZicIOECF9kizDpnSP2qylglARNrgizmQE3fT/qUmE
	 rkr80gHwMMXHXSNvzuKDkNbPmluz/LCSBUJpLNU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 229/332] ALSA: firewire-motu: Protect register DSP event queue positions
Date: Sun,  7 Jun 2026 11:59:58 +0200
Message-ID: <20260607095736.467109475@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 98fb1c1bb11e29eb609b7200a25e136e05aa4498 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/motu/motu-register-dsp-message-parser.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/sound/firewire/motu/motu-register-dsp-message-parser.c
+++ b/sound/firewire/motu/motu-register-dsp-message-parser.c
@@ -386,6 +386,8 @@ unsigned int snd_motu_register_dsp_messa
 {
 	struct msg_parser *parser = motu->message_parser;
 
+	guard(spinlock_irqsave)(&parser->lock);
+
 	if (parser->pull_pos > parser->push_pos)
 		return EVENT_QUEUE_SIZE - parser->pull_pos + parser->push_pos;
 	else
@@ -395,13 +397,14 @@ unsigned int snd_motu_register_dsp_messa
 bool snd_motu_register_dsp_message_parser_copy_event(struct snd_motu *motu, u32 *event)
 {
 	struct msg_parser *parser = motu->message_parser;
-	unsigned int pos = parser->pull_pos;
-
-	if (pos == parser->push_pos)
-		return false;
+	unsigned int pos;
 
 	guard(spinlock_irqsave)(&parser->lock);
 
+	if (parser->pull_pos == parser->push_pos)
+		return false;
+
+	pos = parser->pull_pos;
 	*event = parser->event_queue[pos];
 
 	++pos;


