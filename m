Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE16A19C542;
	Wed,  5 Mar 2025 18:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197996; cv=none; b=maTp323lWqqUS1Ca2eqF9Xm1zpemTg6WG6O629keXrrsQ9BcDYb4nGifltNCVsH/hsYhLkdrEP2vRqkE277uP7wjjdU/9lH7s63ZMmTWsoVjNGfNQUBWSkV+7GbjakJIiAUnIyjvYiY72fKUVVuKX8s8TSTE0d9PM6puyE9FHvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197996; c=relaxed/simple;
	bh=ybA2fcwTblTTp0qcZEsDAx9gffUQC+9YeoDAW/2YxQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJEoou+3rON9DLikez/q9NxOJwpMiyIxS9mhSSnM8bXC9+SOQY+G39Z1B7YbB/79sKE4myDALWl0rBjGHryuk0YibabqyNwBTxyBAezdH//rf5k1YUqlWi3CNlgVVitHxeQ07wjd8M3JezGxq7IkMhu6b8+ePmMXlcxkRekp8zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ph7v6BnJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ph7v6BnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8FEC4CED1;
	Wed,  5 Mar 2025 18:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197995;
	bh=ybA2fcwTblTTp0qcZEsDAx9gffUQC+9YeoDAW/2YxQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ph7v6BnJMVD1eQZySLYJw0dNyC4ck81RdV8dvfYFdsJ98xNAyVWc4CREalBxJA/eJ
	 urP3aTrjqWUKShFATQwQedSaKNfGFgtTEirGAWDJyxmaXedTaqicMVn55C4+xtNicO
	 XH7YhRK9bYfjigNa/b6yQI9mKcJKT1FML0d8l7fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	John Keeping <jkeeping@inmusicbrands.com>
Subject: [PATCH 6.12 028/150] ALSA: usb-audio: Avoid dropping MIDI events at closing multiple ports
Date: Wed,  5 Mar 2025 18:47:37 +0100
Message-ID: <20250305174504.946021365@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit a3bdd8f5c2217e1cb35db02c2eed36ea20fb50f5 ]

We fixed the UAF issue in USB MIDI code by canceling the pending work
at closing each MIDI output device in the commit below.  However, this
assumed that it's the only one that is tied with the endpoint, and it
resulted in unexpected data truncations when multiple devices are
assigned to a single endpoint and opened simultaneously.

For addressing the unexpected MIDI message drops, simply replace
cancel_work_sync() with flush_work().  The drain callback should have
been already invoked before the close callback, hence the port->active
flag must be already cleared.  So this just assures that the pending
work is finished before freeing the resources.

Fixes: 0125de38122f ("ALSA: usb-audio: Cancel pending work at closing a MIDI substream")
Reported-and-tested-by: John Keeping <jkeeping@inmusicbrands.com>
Closes: https://lore.kernel.org/20250217111647.3368132-1-jkeeping@inmusicbrands.com
Link: https://patch.msgid.link/20250218114024.23125-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/midi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 737dd00e97b14..779d97d31f170 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1145,7 +1145,7 @@ static int snd_usbmidi_output_close(struct snd_rawmidi_substream *substream)
 {
 	struct usbmidi_out_port *port = substream->runtime->private_data;
 
-	cancel_work_sync(&port->ep->work);
+	flush_work(&port->ep->work);
 	return substream_open(substream, 0, 0);
 }
 
-- 
2.39.5



