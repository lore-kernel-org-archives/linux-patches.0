Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBD9250C07;
	Wed,  5 Mar 2025 17:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197546; cv=none; b=E45vd/5ei84p91Xr85nPVivS0jOvv6g3C2waXselkps6+gQspBTbSVRcIQNCLYt4LH6vZJymIvvFI/ZGhobHXv8B0SziylnL0NRDoqSLGwVyLScBCxDGPw7huhGzdNea438s6K6nj9T4bXSDxgYEGHH3/GRhgt+1nHOPGKHrJKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197546; c=relaxed/simple;
	bh=d0Bxg4WYmJ7UFU42cb1ocnIbi5tHzNDw0BFvTIwh7l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkrNqkm8jmcEUsFud/RY7Co5Krx1vFLwFzAoKRKf4xFyWf2gGQ1gaDHI0v1JnY6BiN3f5YiYMDTQNp2zAseHu1MPrMPcgByEldNLM1rTrIF2kxQlesBvfFSZToHQSxedPDqiwfe85e0rHELijbRjMf14FDoziYvPcW3MHscrIEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kn7KwhNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kn7KwhNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F02FC4CED1;
	Wed,  5 Mar 2025 17:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197545;
	bh=d0Bxg4WYmJ7UFU42cb1ocnIbi5tHzNDw0BFvTIwh7l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kn7KwhNx0fTNYXMrz84kDgCTsR/G7QQf3HEPxTvRjG17xVDE6XeE3AG2kyWLS1pzK
	 fXB2v9vSgAJKQcKdg4KKsy7A+auBnCZTEugg0rfjdVyL9DuWdQ/8R6jDVo3pzcJVhw
	 VdGXu4grIBTBwEeNxs5KLUgjZEsg0tvhNiqZBDuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	John Keeping <jkeeping@inmusicbrands.com>
Subject: [PATCH 6.6 017/142] ALSA: usb-audio: Avoid dropping MIDI events at closing multiple ports
Date: Wed,  5 Mar 2025 18:47:16 +0100
Message-ID: <20250305174501.035018290@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6b0993258e039..6d861046b582b 100644
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



