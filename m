Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3AB2505B8;
	Wed,  5 Mar 2025 17:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197321; cv=none; b=EkQ53o9ForNq22jw/UzH4JxHVC0NygrEhpy/vPqsEQ72rhxScWr3R3N2re3ZKnzmCOHjfoKasz1i0Hqx6HbnoBkiNvOTJ0MDqaAEXvwze29skdMmh1IWeDOF5uH6EvgqxDfwhGvZ3sZVM7WFdVc2BD/0lKMtLTtUd68/V2yieL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197321; c=relaxed/simple;
	bh=krGVe3N7PDIdZxU6on9f8mVzeOp0hzTuG4guXjWWZaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKiIF+bR1Zp0wD8nGdTIZ+Z/66zYkwBI3rp18/hXPuzsdjkbVBiSgRAdxxY7eP/RHsSpQpynQW2UElOpQy1UbuzRANt/X7LRo4Oc3Cbuxv6pY61L1qEa6VfIacgyiLVIMVS/QTZr/U9MJfEevMh4EYb8/PoiiCzFazrrfB+gFbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LWUW38t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LWUW38t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BF4C4CED1;
	Wed,  5 Mar 2025 17:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197320;
	bh=krGVe3N7PDIdZxU6on9f8mVzeOp0hzTuG4guXjWWZaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LWUW38thn+Qpc8EJMs2EgLoX2k+utjExrNotLKN3lInlq67eIqJQp33wYVNJA7ze
	 P8100kokMgu3XHSupbBl6VhIG5+RbPFcfmHCrSyPM1P1TMlKAlAckRT7D2uqYeoi+P
	 jugHlQrUspp5H42fLKj6vj9M/TVnVxh5k4EaBUPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	John Keeping <jkeeping@inmusicbrands.com>
Subject: [PATCH 6.1 116/176] ALSA: usb-audio: Avoid dropping MIDI events at closing multiple ports
Date: Wed,  5 Mar 2025 18:48:05 +0100
Message-ID: <20250305174510.118766028@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2839f6b6f09b4..eed71369c7af2 100644
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



