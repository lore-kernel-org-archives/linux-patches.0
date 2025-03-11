Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27263C0B;
	Tue, 11 Mar 2025 15:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707333; cv=none; b=YweVWR7GAFcXSukwB7Uh8rJr1naR0dM+/4LLGUk4l1UuJwmme1qOw8qMAkZbOUFIz7HFJSqdnunrFsoaWIzbDKTwlHAHp7i7T+rg6N9riW3TpXJ6k/OPz+JpuOKWWNtSVFtAAuwLCZ663FfYizoMQU/1T4+3iTEAPUeooT1xs/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707333; c=relaxed/simple;
	bh=LAJy2WxoAeTrZEX5liyxKSNS/UDc74L5JPfpASYFa1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXSi28HZvKCgqvZrhqNeUYWCPoISTrsVS+qlh5q35wwtK4Hurmlo1P6+MsMMtwwv11SrxgUfMaQRilCP2qesaHF+e25wh9tMLmJlFtUXnzgsPxQVTLLt/92Q6GcvjXB+I1H+d7EkzEllVPo3Ml/H8Gvx5Ms4Nx/SqcvUXHjOrU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M02TD+BD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M02TD+BD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5977EC4CEEA;
	Tue, 11 Mar 2025 15:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707333;
	bh=LAJy2WxoAeTrZEX5liyxKSNS/UDc74L5JPfpASYFa1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M02TD+BD7Ril26gLehk8DvINfDg7Y9v9EezsalzJmL9+OF7VkDEAhbmmruNIgG4fP
	 A+0yGSbpaJnJU9DG4aZc0Zc4leLZBFjJA0UjaVpg3q2YjJKsnn1T4dN4mvBarCMD0/
	 zZZ9FqSd8p6vqB+IAwt86YrEMJHy7EDmXeBX1Oo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	John Keeping <jkeeping@inmusicbrands.com>
Subject: [PATCH 5.10 354/462] ALSA: usb-audio: Avoid dropping MIDI events at closing multiple ports
Date: Tue, 11 Mar 2025 16:00:20 +0100
Message-ID: <20250311145812.340090399@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b02e1a33304f0..f0a70e912bddc 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1161,7 +1161,7 @@ static int snd_usbmidi_output_close(struct snd_rawmidi_substream *substream)
 {
 	struct usbmidi_out_port *port = substream->runtime->private_data;
 
-	cancel_work_sync(&port->ep->work);
+	flush_work(&port->ep->work);
 	return substream_open(substream, 0, 0);
 }
 
-- 
2.39.5



